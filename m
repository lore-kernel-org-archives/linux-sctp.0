From: Eric Biggers <ebiggers@kernel.org>
Date: Sat, 02 May 2020 05:31:20 +0000
Subject: [PATCH 18/20] sctp: use crypto_shash_tfm_digest()
Message-Id: <20200502053122.995648-19-ebiggers@kernel.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200502053122.995648-1-ebiggers@kernel.org>
In-Reply-To: <20200502053122.995648-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Cc: linux-sctp@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Instead of manually allocating a 'struct shash_desc' on the stack and
calling crypto_shash_digest(), switch to using the new helper function
crypto_shash_tfm_digest() which does this for us.

Cc: linux-sctp@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 net/sctp/auth.c          | 10 ++--------
 net/sctp/sm_make_chunk.c | 23 ++++++++---------------
 2 files changed, 10 insertions(+), 23 deletions(-)

diff --git a/net/sctp/auth.c b/net/sctp/auth.c
index 4278764d82b827..83e97e8892e05a 100644
--- a/net/sctp/auth.c
+++ b/net/sctp/auth.c
@@ -741,14 +741,8 @@ void sctp_auth_calculate_hmac(const struct sctp_association *asoc,
 	if (crypto_shash_setkey(tfm, &asoc_key->data[0], asoc_key->len))
 		goto free;
 
-	{
-		SHASH_DESC_ON_STACK(desc, tfm);
-
-		desc->tfm = tfm;
-		crypto_shash_digest(desc, (u8 *)auth,
-				    end - (unsigned char *)auth, digest);
-		shash_desc_zero(desc);
-	}
+	crypto_shash_tfm_digest(tfm, (u8 *)auth, end - (unsigned char *)auth,
+				digest);
 
 free:
 	if (free_key)
diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 09050c1d5517e7..c786215ba69a54 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -1666,17 +1666,14 @@ static struct sctp_cookie_param *sctp_pack_cookie(
 	       ntohs(init_chunk->chunk_hdr->length), raw_addrs, addrs_len);
 
 	if (sctp_sk(ep->base.sk)->hmac) {
-		SHASH_DESC_ON_STACK(desc, sctp_sk(ep->base.sk)->hmac);
+		struct crypto_shash *tfm = sctp_sk(ep->base.sk)->hmac;
 		int err;
 
 		/* Sign the message.  */
-		desc->tfm = sctp_sk(ep->base.sk)->hmac;
-
-		err = crypto_shash_setkey(desc->tfm, ep->secret_key,
+		err = crypto_shash_setkey(tfm, ep->secret_key,
 					  sizeof(ep->secret_key)) ?:
-		      crypto_shash_digest(desc, (u8 *)&cookie->c, bodysize,
-					  cookie->signature);
-		shash_desc_zero(desc);
+		      crypto_shash_tfm_digest(tfm, (u8 *)&cookie->c, bodysize,
+					      cookie->signature);
 		if (err)
 			goto free_cookie;
 	}
@@ -1737,17 +1734,13 @@ struct sctp_association *sctp_unpack_cookie(
 
 	/* Check the signature.  */
 	{
-		SHASH_DESC_ON_STACK(desc, sctp_sk(ep->base.sk)->hmac);
+		struct crypto_shash *tfm = sctp_sk(ep->base.sk)->hmac;
 		int err;
 
-		desc->tfm = sctp_sk(ep->base.sk)->hmac;
-
-		err = crypto_shash_setkey(desc->tfm, ep->secret_key,
+		err = crypto_shash_setkey(tfm, ep->secret_key,
 					  sizeof(ep->secret_key)) ?:
-		      crypto_shash_digest(desc, (u8 *)bear_cookie, bodysize,
-					  digest);
-		shash_desc_zero(desc);
-
+		      crypto_shash_tfm_digest(tfm, (u8 *)bear_cookie, bodysize,
+					      digest);
 		if (err) {
 			*error = -SCTP_IERROR_NOMEM;
 			goto fail;
-- 
2.26.2
