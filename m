From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Thu, 26 Apr 2018 19:58:53 +0000
Subject: [PATCH net-next 04/13] sctp: introduce sctp_assoc_set_pmtu
Message-Id: <681866125037624e9bf6df47bcd6286e0936d129.1524772453.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1524772453.git.marcelo.leitner@gmail.com>
In-Reply-To: <cover.1524772453.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Xin Long <lucien.xin@gmail.com>

All changes to asoc PMTU should now go through this wrapper, making it
easier to track them and to do other actions upon it.

Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 include/net/sctp/structs.h |  1 +
 net/sctp/associola.c       | 21 +++++++++++++--------
 net/sctp/socket.c          |  2 +-
 3 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 05594b248e5277790cca6542c3680510739ce18b..c5e244be8f1ea99118cac9ada0cfce871cb15d3f 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -2097,6 +2097,7 @@ int sctp_assoc_update(struct sctp_association *old,
 
 __u32 sctp_association_get_next_tsn(struct sctp_association *);
 
+void sctp_assoc_set_pmtu(struct sctp_association *asoc, __u32 pmtu);
 void sctp_assoc_sync_pmtu(struct sctp_association *asoc);
 void sctp_assoc_rwnd_increase(struct sctp_association *, unsigned int);
 void sctp_assoc_rwnd_decrease(struct sctp_association *, unsigned int);
diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index c5ed09cfa8423b17546e3d45f6d06db03af66384..85b362324084e9ba139a39293a527ef06824e55b 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -660,13 +660,9 @@ struct sctp_transport *sctp_assoc_add_peer(struct sctp_association *asoc,
 	 * If not and the current association PMTU is higher than the new
 	 * peer's PMTU, reset the association PMTU to the new peer's PMTU.
 	 */
-	if (asoc->pathmtu)
-		asoc->pathmtu = min_t(int, peer->pathmtu, asoc->pathmtu);
-	else
-		asoc->pathmtu = peer->pathmtu;
-
-	pr_debug("%s: association:%p PMTU set to %d\n", __func__, asoc,
-		 asoc->pathmtu);
+	sctp_assoc_set_pmtu(asoc, asoc->pathmtu ?
+				  min_t(int, peer->pathmtu, asoc->pathmtu) :
+				  peer->pathmtu);
 
 	peer->pmtu_pending = 0;
 
@@ -1374,6 +1370,15 @@ sctp_assoc_choose_alter_transport(struct sctp_association *asoc,
 	}
 }
 
+void sctp_assoc_set_pmtu(struct sctp_association *asoc, __u32 pmtu)
+{
+	if (asoc->pathmtu != pmtu)
+		asoc->pathmtu = pmtu;
+
+	pr_debug("%s: asoc:%p, pmtu:%d, frag_point:%d\n", __func__, asoc,
+		 asoc->pathmtu, asoc->frag_point);
+}
+
 /* Update the association's pmtu and frag_point by going through all the
  * transports. This routine is called when a transport's PMTU has changed.
  */
@@ -1397,7 +1402,7 @@ void sctp_assoc_sync_pmtu(struct sctp_association *asoc)
 			pmtu = t->pathmtu;
 	}
 
-	asoc->pathmtu = pmtu;
+	sctp_assoc_set_pmtu(asoc, pmtu);
 	asoc->frag_point = sctp_frag_point(asoc, pmtu);
 
 	pr_debug("%s: asoc:%p, pmtu:%d, frag_point:%d\n", __func__, asoc,
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 80835ac26d2c3ce6559f75aaaa0b315fb77d9adf..eeec81d5c485b86076f4e3a4f5dc01fc28fbb91b 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -2539,7 +2539,7 @@ static int sctp_apply_peer_addr_params(struct sctp_paddrparams *params,
 			trans->pathmtu = params->spp_pathmtu;
 			sctp_assoc_sync_pmtu(asoc);
 		} else if (asoc) {
-			asoc->pathmtu = params->spp_pathmtu;
+			sctp_assoc_set_pmtu(asoc, params->spp_pathmtu);
 		} else {
 			sp->pathmtu = params->spp_pathmtu;
 		}
-- 
2.14.3

