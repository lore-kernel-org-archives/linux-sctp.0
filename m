From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Tue, 24 Apr 2018 21:17:34 +0000
Subject: [PATCH net-next] sctp: fix const parameter violation in sctp_make_sack
Message-Id: <b9065b3cfb0a2bf3c83008ff53967f473e081766.1524603855.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, Xin Long <lucien.xin@gmail.com>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>

sctp_make_sack() make changes to the asoc and this cast is just
bypassing the const attribute. As there is no need to have the const
there, just remove it and fix the violation.

Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---

This one can go to net or net-next, but targetting net-next here just to
keep it together with the rest (which I'll post as patches get in).

 include/net/sctp/sm.h    | 2 +-
 net/sctp/sm_make_chunk.c | 9 ++++-----
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/include/net/sctp/sm.h b/include/net/sctp/sm.h
index 2d0e782c90551377ad654bcef1224bbdb75ba394..f4b657478a304050851f33d92c71162a4a4a2e50 100644
--- a/include/net/sctp/sm.h
+++ b/include/net/sctp/sm.h
@@ -207,7 +207,7 @@ struct sctp_chunk *sctp_make_datafrag_empty(const struct sctp_association *asoc,
 					    int len, __u8 flags, gfp_t gfp);
 struct sctp_chunk *sctp_make_ecne(const struct sctp_association *asoc,
 				  const __u32 lowest_tsn);
-struct sctp_chunk *sctp_make_sack(const struct sctp_association *asoc);
+struct sctp_chunk *sctp_make_sack(struct sctp_association *asoc);
 struct sctp_chunk *sctp_make_shutdown(const struct sctp_association *asoc,
 				      const struct sctp_chunk *chunk);
 struct sctp_chunk *sctp_make_shutdown_ack(const struct sctp_association *asoc,
diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 5a4fb1dc8400a0316177ce65be8126857297eb5e..db93eabd6ef500ab20be6e091ee06bd3b60923c9 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -779,10 +779,9 @@ struct sctp_chunk *sctp_make_datafrag_empty(const struct sctp_association *asoc,
  * association.  This reports on which TSN's we've seen to date,
  * including duplicates and gaps.
  */
-struct sctp_chunk *sctp_make_sack(const struct sctp_association *asoc)
+struct sctp_chunk *sctp_make_sack(struct sctp_association *asoc)
 {
 	struct sctp_tsnmap *map = (struct sctp_tsnmap *)&asoc->peer.tsn_map;
-	struct sctp_association *aptr = (struct sctp_association *)asoc;
 	struct sctp_gap_ack_block gabs[SCTP_MAX_GABS];
 	__u16 num_gabs, num_dup_tsns;
 	struct sctp_transport *trans;
@@ -857,7 +856,7 @@ struct sctp_chunk *sctp_make_sack(const struct sctp_association *asoc)

 	/* Add the duplicate TSN information.  */
 	if (num_dup_tsns) {
-		aptr->stats.idupchunks += num_dup_tsns;
+		asoc->stats.idupchunks += num_dup_tsns;
 		sctp_addto_chunk(retval, sizeof(__u32) * num_dup_tsns,
 				 sctp_tsnmap_get_dups(map));
 	}
@@ -869,11 +868,11 @@ struct sctp_chunk *sctp_make_sack(const struct sctp_association *asoc)
 	 * association so no transport will match after a wrap event like this,
 	 * Until the next sack
 	 */
-	if (++aptr->peer.sack_generation = 0) {
+	if (++asoc->peer.sack_generation = 0) {
 		list_for_each_entry(trans, &asoc->peer.transport_addr_list,
 				    transports)
 			trans->sack_generation = 0;
-		aptr->peer.sack_generation = 1;
+		asoc->peer.sack_generation = 1;
 	}
 nodata:
 	return retval;
--
2.14.3

