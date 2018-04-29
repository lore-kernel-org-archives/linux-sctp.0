From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Sun, 29 Apr 2018 15:56:32 +0000
Subject: [PATCH net-next 2/2] sctp: add sctp_make_op_error_limited and reuse inner functions
Message-Id: <53909b1bd523d45a453431968fd1e03fd4be6196.1525017179.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1525017179.git.marcelo.leitner@gmail.com>
In-Reply-To: <cover.1525017179.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Xin Long <lucien.xin@gmail.com>

The idea is quite similar to the old functions, but note that the _fixed
function wasn't "fixed" as in that it would generate a packet with a fixed
size, but rather limited/bounded to PMTU.

Also, now with sctp_mtu_payload(), we have a more accurate limit.

Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 net/sctp/sm_make_chunk.c | 130 +++++++++++++++++------------------------------
 1 file changed, 46 insertions(+), 84 deletions(-)

diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index e518eb64ccf3578f7892da050c160a56cf3cc833..4d7b3ccea0789f3a695f710046b50855e4cc41fc 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -81,8 +81,6 @@ static int sctp_process_param(struct sctp_association *asoc,
 			      gfp_t gfp);
 static void *sctp_addto_param(struct sctp_chunk *chunk, int len,
 			      const void *data);
-static void  *sctp_addto_chunk_fixed(struct sctp_chunk *, int len,
-				     const void *data);
 
 /* Control chunk destructor */
 static void sctp_control_release_owner(struct sk_buff *skb)
@@ -154,9 +152,8 @@ static const struct sctp_paramhdr prsctp_param = {
 	cpu_to_be16(sizeof(struct sctp_paramhdr)),
 };
 
-/* A helper to initialize an op error inside a
- * provided chunk, as most cause codes will be embedded inside an
- * abort chunk.
+/* A helper to initialize an op error inside a provided chunk, as most
+ * cause codes will be embedded inside an abort chunk.
  */
 int sctp_init_cause(struct sctp_chunk *chunk, __be16 cause_code,
 		    size_t paylen)
@@ -177,29 +174,6 @@ int sctp_init_cause(struct sctp_chunk *chunk, __be16 cause_code,
 	return 0;
 }
 
-/* A helper to initialize an op error inside a
- * provided chunk, as most cause codes will be embedded inside an
- * abort chunk.  Differs from sctp_init_cause in that it won't oops
- * if there isn't enough space in the op error chunk
- */
-static int sctp_init_cause_fixed(struct sctp_chunk *chunk, __be16 cause_code,
-				 size_t paylen)
-{
-	struct sctp_errhdr err;
-	__u16 len;
-
-	/* Cause code constants are now defined in network order.  */
-	err.cause = cause_code;
-	len = sizeof(err) + paylen;
-	err.length  = htons(len);
-
-	if (skb_tailroom(chunk->skb) < len)
-		return -ENOSPC;
-
-	chunk->subh.err_hdr = sctp_addto_chunk_fixed(chunk, sizeof(err), &err);
-
-	return 0;
-}
 /* 3.3.2 Initiation (INIT) (1)
  *
  * This chunk is used to initiate a SCTP association between two
@@ -1263,20 +1237,26 @@ static struct sctp_chunk *sctp_make_op_error_space(
 	return retval;
 }
 
-/* Create an Operation Error chunk of a fixed size,
- * specifically, max(asoc->pathmtu, SCTP_DEFAULT_MAXSEGMENT)
- * This is a helper function to allocate an error chunk for
- * for those invalid parameter codes in which we may not want
- * to report all the errors, if the incoming chunk is large
+/* Create an Operation Error chunk of a fixed size, specifically,
+ * min(asoc->pathmtu, SCTP_DEFAULT_MAXSEGMENT) - overheads.
+ * This is a helper function to allocate an error chunk for for those
+ * invalid parameter codes in which we may not want to report all the
+ * errors, if the incoming chunk is large. If it can't fit in a single
+ * packet, we ignore it.
  */
-static inline struct sctp_chunk *sctp_make_op_error_fixed(
+static inline struct sctp_chunk *sctp_make_op_error_limited(
 					const struct sctp_association *asoc,
 					const struct sctp_chunk *chunk)
 {
-	size_t size = asoc ? asoc->pathmtu : 0;
+	size_t size = SCTP_DEFAULT_MAXSEGMENT;
+	struct sctp_sock *sp = NULL;
+
+	if (asoc) {
+		size = min_t(size_t, size, asoc->pathmtu);
+		sp = sctp_sk(asoc->base.sk);
+	}
 
-	if (!size)
-		size = SCTP_DEFAULT_MAXSEGMENT;
+	size = sctp_mtu_payload(sp, size, sizeof(struct sctp_errhdr));
 
 	return sctp_make_op_error_space(asoc, chunk, size);
 }
@@ -1528,18 +1508,6 @@ void *sctp_addto_chunk(struct sctp_chunk *chunk, int len, const void *data)
 	return target;
 }
 
-/* Append bytes to the end of a chunk. Returns NULL if there isn't sufficient
- * space in the chunk
- */
-static void *sctp_addto_chunk_fixed(struct sctp_chunk *chunk,
-				    int len, const void *data)
-{
-	if (skb_tailroom(chunk->skb) >= len)
-		return sctp_addto_chunk(chunk, len, data);
-	else
-		return NULL;
-}
-
 /* Append bytes from user space to the end of a chunk.  Will panic if
  * chunk is not big enough.
  * Returns a kernel err value.
@@ -1834,6 +1802,9 @@ struct sctp_association *sctp_unpack_cookie(
 		kt = ktime_get_real();
 
 	if (!asoc && ktime_before(bear_cookie->expiration, kt)) {
+		suseconds_t usecs = ktime_to_us(ktime_sub(kt, bear_cookie->expiration));
+		__be32 n = htonl(usecs);
+
 		/*
 		 * Section 3.3.10.3 Stale Cookie Error (3)
 		 *
@@ -1842,17 +1813,12 @@ struct sctp_association *sctp_unpack_cookie(
 		 * Stale Cookie Error:  Indicates the receipt of a valid State
 		 * Cookie that has expired.
 		 */
-		len = ntohs(chunk->chunk_hdr->length);
-		*errp = sctp_make_op_error_space(asoc, chunk, len);
-		if (*errp) {
-			suseconds_t usecs = ktime_to_us(ktime_sub(kt, bear_cookie->expiration));
-			__be32 n = htonl(usecs);
-
-			sctp_init_cause(*errp, SCTP_ERROR_STALE_COOKIE,
-					sizeof(n));
-			sctp_addto_chunk(*errp, sizeof(n), &n);
+		*errp = sctp_make_op_error(asoc, chunk,
+					   SCTP_ERROR_STALE_COOKIE, &n,
+					   sizeof(n), 0);
+		if (*errp)
 			*error = -SCTP_IERROR_STALE_COOKIE;
-		} else
+		else
 			*error = -SCTP_IERROR_NOMEM;
 
 		goto fail;
@@ -2003,12 +1969,8 @@ static int sctp_process_hn_param(const struct sctp_association *asoc,
 	if (*errp)
 		sctp_chunk_free(*errp);
 
-	*errp = sctp_make_op_error_space(asoc, chunk, len);
-
-	if (*errp) {
-		sctp_init_cause(*errp, SCTP_ERROR_DNS_FAILED, len);
-		sctp_addto_chunk(*errp, len, param.v);
-	}
+	*errp = sctp_make_op_error(asoc, chunk, SCTP_ERROR_DNS_FAILED,
+				   param.v, len, 0);
 
 	/* Stop processing this chunk. */
 	return 0;
@@ -2133,23 +2095,23 @@ static enum sctp_ierror sctp_process_unk_param(
 		/* Make an ERROR chunk, preparing enough room for
 		 * returning multiple unknown parameters.
 		 */
-		if (NULL = *errp)
-			*errp = sctp_make_op_error_fixed(asoc, chunk);
-
-		if (*errp) {
-			if (!sctp_init_cause_fixed(*errp, SCTP_ERROR_UNKNOWN_PARAM,
-					SCTP_PAD4(ntohs(param.p->length))))
-				sctp_addto_chunk_fixed(*errp,
-						SCTP_PAD4(ntohs(param.p->length)),
-						param.v);
-		} else {
-			/* If there is no memory for generating the ERROR
-			 * report as specified, an ABORT will be triggered
-			 * to the peer and the association won't be
-			 * established.
-			 */
-			retval = SCTP_IERROR_NOMEM;
+		if (!*errp) {
+			*errp = sctp_make_op_error_limited(asoc, chunk);
+			if (!*errp) {
+				/* If there is no memory for generating the
+				 * ERROR report as specified, an ABORT will be
+				 * triggered to the peer and the association
+				 * won't be established.
+				 */
+				retval = SCTP_IERROR_NOMEM;
+				break;
+			}
 		}
+
+		if (!sctp_init_cause(*errp, SCTP_ERROR_UNKNOWN_PARAM,
+				     ntohs(param.p->length)))
+			sctp_addto_chunk(*errp, ntohs(param.p->length),
+					 param.v);
 		break;
 	default:
 		break;
@@ -2225,10 +2187,10 @@ static enum sctp_ierror sctp_verify_param(struct net *net,
 		 * MUST be aborted.  The ABORT chunk SHOULD contain the error
 		 * cause 'Protocol Violation'.
 		 */
-		if (SCTP_AUTH_RANDOM_LENGTH !-			ntohs(param.p->length) - sizeof(struct sctp_paramhdr)) {
+		if (SCTP_AUTH_RANDOM_LENGTH != ntohs(param.p->length) -
+					       sizeof(struct sctp_paramhdr)) {
 			sctp_process_inv_paramlength(asoc, param.p,
-							chunk, err_chunk);
+						     chunk, err_chunk);
 			retval = SCTP_IERROR_ABORT;
 		}
 		break;
-- 
2.14.3

