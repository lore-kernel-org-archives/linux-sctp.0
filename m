From: Jakub Audykowicz <jakub.audykowicz@gmail.com>
Date: Sun, 18 Nov 2018 20:47:36 +0000
Subject: [PATCH net] sctp: always set frag_point on pmtu change
Message-Id: <20181118204736.7178-1-jakub.audykowicz@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org, vyasevich@gmail.com, nhorman@tuxdriver.com, marcelo.leitner@gmail.com, davem@davemloft.net
Cc: netdev@vger.kernel.org, Jakub Audykowicz <jakub.audykowicz@gmail.com>

Calling send on a connected SCTP socket results in kernel panic if
spp_pathmtu was configured manually before an association is established
and it was not reconfigured to another value once the association is
established.

Steps to reproduce:
1. Set up a listening SCTP server socket.
2. Set up an SCTP client socket.
3. Configure client socket using setsockopt SCTP_PEER_ADDR_PARAMS with
    spp_pathmtu set to a legal value (e.g. 1000) and
    SPP_PMTUD_DISABLE set in spp_flags.
4. Connect client to server.
5. Send message from client to server.

At this point oom-killer is invoked, which will eventually lead to:
[    5.197262] Out of memory and no killable processes...
[    5.198107] Kernel panic - not syncing: System is deadlocked on memory

Commit 2f5e3c9df693 ("sctp: introduce sctp_assoc_update_frag_point")
introduces sctp_assoc_update_frag_point, but this function is not called
in this case, causing frag_point to be zero:
 void sctp_assoc_set_pmtu(struct sctp_association *asoc, __u32 pmtu)
 {
-	if (asoc->pathmtu != pmtu)
+	if (asoc->pathmtu != pmtu) {
 		asoc->pathmtu = pmtu;
+		sctp_assoc_update_frag_point(asoc);
+	}

In this scenario, on association establishment, asoc->pathmtu is already
1000 and pmtu will be as well. Before this commit the frag_point was being
correctly set in the scenario described. Moving the call outside the if
block fixes the issue.

I will be providing a separate patch to lksctp-tools with a simple test
reproducing this problem ("func_tests: frag_point should never be zero").

I have also taken the liberty to introduce a sanity check in chunk.c to
set the frag_point to a non-negative value in order to avoid chunking
endlessly (which is the reason for the eventual panic).

Fixes: 2f5e3c9df693 ("sctp: introduce sctp_assoc_update_frag_point")
Signed-off-by: Jakub Audykowicz <jakub.audykowicz@gmail.com>
---
 include/net/sctp/constants.h |  3 +++
 net/sctp/associola.c         | 13 +++++++------
 net/sctp/chunk.c             |  6 ++++++
 3 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/include/net/sctp/constants.h b/include/net/sctp/constants.h
index 8dadc74c22e7..90316fab6f04 100644
--- a/include/net/sctp/constants.h
+++ b/include/net/sctp/constants.h
@@ -293,6 +293,9 @@ enum { SCTP_MAX_GABS = 16 };
 					 */
 #define SCTP_DEFAULT_MINSEGMENT 512	/* MTU size ... if no mtu disc */
 
+/* An association's fragmentation point should never be non-positive */
+#define SCTP_FRAG_POINT_MIN 1
+
 #define SCTP_SECRET_SIZE 32		/* Number of octets in a 256 bits. */
 
 #define SCTP_SIGNATURE_SIZE 20	        /* size of a SLA-1 signature */
diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index 6a28b96e779e..44d71a1af62e 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -1431,13 +1431,14 @@ void sctp_assoc_update_frag_point(struct sctp_association *asoc)
 
 void sctp_assoc_set_pmtu(struct sctp_association *asoc, __u32 pmtu)
 {
-	if (asoc->pathmtu != pmtu) {
-		asoc->pathmtu = pmtu;
-		sctp_assoc_update_frag_point(asoc);
-	}
+	pr_debug("%s: before asoc:%p, pmtu:%d, frag_point:%d\n",
+		__func__, asoc, asoc->pathmtu, asoc->frag_point);
+
+	asoc->pathmtu = pmtu;
+	sctp_assoc_update_frag_point(asoc);
 
-	pr_debug("%s: asoc:%p, pmtu:%d, frag_point:%d\n", __func__, asoc,
-		 asoc->pathmtu, asoc->frag_point);
+	pr_debug("%s: after asoc:%p, pmtu:%d, frag_point:%d\n",
+		__func__, asoc, asoc->pathmtu, asoc->frag_point);
 }
 
 /* Update the association's pmtu and frag_point by going through all the
diff --git a/net/sctp/chunk.c b/net/sctp/chunk.c
index ce8087846f05..9f0e64ddbd9c 100644
--- a/net/sctp/chunk.c
+++ b/net/sctp/chunk.c
@@ -190,6 +190,12 @@ struct sctp_datamsg *sctp_datamsg_from_user(struct sctp_association *asoc,
 	/* This is the biggest possible DATA chunk that can fit into
 	 * the packet
 	 */
+	if (asoc->frag_point < SCTP_FRAG_POINT_MIN) {
+		pr_warn("%s: asoc:%p->frag_point is less than allowed (%d<%d)",
+			__func__, asoc, asoc->frag_point, SCTP_FRAG_POINT_MIN);
+		pr_warn("forcing minimum value to avoid chunking endlessly");
+		asoc->frag_point = SCTP_FRAG_POINT_MIN;
+	}
 	max_data = asoc->frag_point;
 
 	/* If the the peer requested that we authenticate DATA chunks
-- 
2.17.1
