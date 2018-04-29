From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Sun, 29 Apr 2018 15:56:31 +0000
Subject: [PATCH net-next 1/2] sctp: allow sctp_init_cause to return errors
Message-Id: <985b5d2b052dd5121ab46be2704543258c6f5e8b.1525017179.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1525017179.git.marcelo.leitner@gmail.com>
In-Reply-To: <cover.1525017179.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Xin Long <lucien.xin@gmail.com>

And do so if the skb doesn't have enough space for the payload.
This is a preparation for the next patch.

Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 include/net/sctp/sm.h    |  2 +-
 net/sctp/sm_make_chunk.c | 12 +++++++++---
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/include/net/sctp/sm.h b/include/net/sctp/sm.h
index f4b657478a304050851f33d92c71162a4a4a2e50..5ef1bad81ef54906b375dbfd0e4fd897d078abce 100644
--- a/include/net/sctp/sm.h
+++ b/include/net/sctp/sm.h
@@ -215,7 +215,7 @@ struct sctp_chunk *sctp_make_shutdown_ack(const struct sctp_association *asoc,
 struct sctp_chunk *sctp_make_shutdown_complete(
 					const struct sctp_association *asoc,
 					const struct sctp_chunk *chunk);
-void sctp_init_cause(struct sctp_chunk *chunk, __be16 cause, size_t paylen);
+int sctp_init_cause(struct sctp_chunk *chunk, __be16 cause, size_t paylen);
 struct sctp_chunk *sctp_make_abort(const struct sctp_association *asoc,
 				   const struct sctp_chunk *chunk,
 				   const size_t hint);
diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index db93eabd6ef500ab20be6e091ee06bd3b60923c9..e518eb64ccf3578f7892da050c160a56cf3cc833 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -158,8 +158,8 @@ static const struct sctp_paramhdr prsctp_param = {
  * provided chunk, as most cause codes will be embedded inside an
  * abort chunk.
  */
-void sctp_init_cause(struct sctp_chunk *chunk, __be16 cause_code,
-		     size_t paylen)
+int sctp_init_cause(struct sctp_chunk *chunk, __be16 cause_code,
+		    size_t paylen)
 {
 	struct sctp_errhdr err;
 	__u16 len;
@@ -167,8 +167,14 @@ void sctp_init_cause(struct sctp_chunk *chunk, __be16 cause_code,
 	/* Cause code constants are now defined in network order.  */
 	err.cause = cause_code;
 	len = sizeof(err) + paylen;
-	err.length  = htons(len);
+	err.length = htons(len);
+
+	if (skb_tailroom(chunk->skb) < len)
+		return -ENOSPC;
+
 	chunk->subh.err_hdr = sctp_addto_chunk(chunk, sizeof(err), &err);
+
+	return 0;
 }
 
 /* A helper to initialize an op error inside a
-- 
2.14.3

