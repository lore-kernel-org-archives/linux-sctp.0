From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Wed, 02 Apr 2008 08:07:10 +0000
Subject: [PATCH] SCTP: remove useless function sctp_auth_asoc_get_hmac()
Message-Id: <47F33EAE.3000408@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Since we have do a strict check of HMAC-ALGO parameter while establish 
the association, the function sctp_auth_asoc_get_hmac() become useless.

This patch remove function sctp_auth_asoc_get_hmac().

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>

--- a/include/net/sctp/auth.h	2008-02-11 17:14:15.000000000 -0500
+++ b/include/net/sctp/auth.h	2008-03-27 21:24:17.000000000 -0400
@@ -99,7 +99,6 @@ int sctp_auth_asoc_copy_shkeys(const str
 int sctp_auth_init_hmacs(struct sctp_endpoint *ep, gfp_t gfp);
 void sctp_auth_destroy_hmacs(struct crypto_hash *auth_hmacs[]);
 struct sctp_hmac *sctp_auth_get_hmac(__u16 hmac_id);
-struct sctp_hmac *sctp_auth_asoc_get_hmac(const struct sctp_association *asoc);
 void sctp_auth_asoc_set_default_hmac(struct sctp_association *asoc,
 				     struct sctp_hmac_algo_param *hmacs);
 int sctp_auth_asoc_verify_hmac_id(const struct sctp_association *asoc,
--- a/net/sctp/auth.c	2008-02-11 17:14:05.000000000 -0500
+++ b/net/sctp/auth.c	2008-03-27 21:24:17.000000000 -0400
@@ -512,52 +512,6 @@ struct sctp_hmac *sctp_auth_get_hmac(__u
 	return &sctp_hmac_list[hmac_id];
 }
 
-/* Get an hmac description information that we can use to build
- * the AUTH chunk
- */
-struct sctp_hmac *sctp_auth_asoc_get_hmac(const struct sctp_association *asoc)
-{
-	struct sctp_hmac_algo_param *hmacs;
-	__u16 n_elt;
-	__u16 id = 0;
-	int i;
-
-	/* If we have a default entry, use it */
-	if (asoc->default_hmac_id)
-		return &sctp_hmac_list[asoc->default_hmac_id];
-
-	/* Since we do not have a default entry, find the first entry
-	 * we support and return that.  Do not cache that id.
-	 */
-	hmacs = asoc->peer.peer_hmacs;
-	if (!hmacs)
-		return NULL;
-
-	n_elt = (ntohs(hmacs->param_hdr.length) - sizeof(sctp_paramhdr_t)) >> 1;
-	for (i = 0; i < n_elt; i++) {
-		id = ntohs(hmacs->hmac_ids[i]);
-
-		/* Check the id is in the supported range */
-		if (id > SCTP_AUTH_HMAC_ID_MAX)
-			continue;
-
-		/* See is we support the id.  Supported IDs have name and
-		 * length fields set, so that we can allocated and use
-		 * them.  We can safely just check for name, for without the
-		 * name, we can't allocate the TFM.
-		 */
-		if (!sctp_hmac_list[id].hmac_name)
-			continue;
-
-		break;
-	}
-
-	if (id = 0)
-		return NULL;
-
-	return &sctp_hmac_list[id];
-}
-
 static int __sctp_auth_find_hmacid(__be16 *hmacs, int n_elts, __be16 hmac_id)
 {
 	int  found = 0;
--- a/net/sctp/chunk.c	2008-02-11 17:14:05.000000000 -0500
+++ b/net/sctp/chunk.c	2008-03-27 21:25:32.000000000 -0400
@@ -199,7 +199,7 @@ struct sctp_datamsg *sctp_datamsg_from_u
 	 * DATA.
 	 */
 	if (sctp_auth_send_cid(SCTP_CID_DATA, asoc)) {
-		struct sctp_hmac *hmac_desc = sctp_auth_asoc_get_hmac(asoc);
+		struct sctp_hmac *hmac_desc = sctp_auth_get_hmac(asoc->default_hmac_id);
 
 		if (hmac_desc)
 			max -= WORD_ROUND(sizeof(sctp_auth_chunk_t) +
--- a/net/sctp/sm_make_chunk.c	2008-02-11 17:14:05.000000000 -0500
+++ b/net/sctp/sm_make_chunk.c	2008-03-27 21:25:08.000000000 -0400
@@ -1118,7 +1118,7 @@ struct sctp_chunk *sctp_make_auth(const 
 	__u8 *hmac;
 
 	/* Get the first hmac that the peer told us to use */
-	hmac_desc = sctp_auth_asoc_get_hmac(asoc);
+	hmac_desc = sctp_auth_get_hmac(asoc->default_hmac_id);
 	if (unlikely(!hmac_desc))
 		return NULL;
 



