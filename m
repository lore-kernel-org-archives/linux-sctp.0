From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Thu, 26 Apr 2018 19:58:57 +0000
Subject: [PATCH net-next 08/13] sctp: introduce sctp_dst_mtu
Message-Id: <d4e3cd0c60a4560911c548ee31af66a1ad015df6.1524772453.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1524772453.git.marcelo.leitner@gmail.com>
In-Reply-To: <cover.1524772453.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Xin Long <lucien.xin@gmail.com>

Which makes sure that the MTU respects the minimum value of
SCTP_DEFAULT_MINSEGMENT and that it is correctly aligned.

Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 include/net/sctp/sctp.h | 9 +++++++--
 net/sctp/associola.c    | 6 ++----
 net/sctp/transport.c    | 6 +++---
 3 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
index e327acad8e7d0710e30f32d0829116593c1171cf..4965cbfa7d92c0f60a76dd6e03571f78209dda5a 100644
--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -600,10 +600,15 @@ static inline __u32 sctp_mtu_payload(const struct sctp_sock *sp,
 	return mtu ? mtu - overhead : overhead;
 }
 
+static inline __u32 sctp_dst_mtu(const struct dst_entry *dst)
+{
+	return SCTP_TRUNC4(max_t(__u32, dst_mtu(dst),
+				 SCTP_DEFAULT_MINSEGMENT));
+}
+
 static inline bool sctp_transport_pmtu_check(struct sctp_transport *t)
 {
-	__u32 pmtu = max_t(size_t, SCTP_TRUNC4(dst_mtu(t->dst)),
-			   SCTP_DEFAULT_MINSEGMENT);
+	__u32 pmtu = sctp_dst_mtu(t->dst);
 
 	if (t->pathmtu = pmtu)
 		return true;
diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index a29025418b96015dd0240013b0a7c636194da67b..039fdb862b1797686bf7e5e911379b5b47ea58f7 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -1405,11 +1405,9 @@ void sctp_assoc_sync_pmtu(struct sctp_association *asoc)
 		return;
 
 	/* Get the lowest pmtu of all the transports. */
-	list_for_each_entry(t, &asoc->peer.transport_addr_list,
-				transports) {
+	list_for_each_entry(t, &asoc->peer.transport_addr_list, transports) {
 		if (t->pmtu_pending && t->dst) {
-			sctp_transport_update_pmtu(
-					t, SCTP_TRUNC4(dst_mtu(t->dst)));
+			sctp_transport_update_pmtu(t, sctp_dst_mtu(t->dst));
 			t->pmtu_pending = 0;
 		}
 		if (!pmtu || (t->pathmtu < pmtu))
diff --git a/net/sctp/transport.c b/net/sctp/transport.c
index c5fc3aed08a18658448b528b07dbb13900686313..ed73a9d91b83eadd3eb8d681fda104fe71562c3f 100644
--- a/net/sctp/transport.c
+++ b/net/sctp/transport.c
@@ -242,9 +242,9 @@ void sctp_transport_pmtu(struct sctp_transport *transport, struct sock *sk)
 						&transport->fl, sk);
 	}
 
-	if (transport->dst) {
-		transport->pathmtu = SCTP_TRUNC4(dst_mtu(transport->dst));
-	} else
+	if (transport->dst)
+		transport->pathmtu = sctp_dst_mtu(transport->dst);
+	else
 		transport->pathmtu = SCTP_DEFAULT_MAXSEGMENT;
 }
 
-- 
2.14.3

