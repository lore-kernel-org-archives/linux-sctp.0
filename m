From: Christophe Leroy <christophe.leroy@c-s.fr>
Date: Tue, 14 Apr 2020 06:08:22 +0000
Subject: Re: [PATCH v2 2/2] crypto: Remove unnecessary memzero_explicit()
Message-Id: <eca85e0b-0af3-c43a-31e4-bd5c3f519798@c-s.fr>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200413211550.8307-1-longman@redhat.com>
 <20200413222846.24240-1-longman@redhat.com>
In-Reply-To: <20200413222846.24240-1-longman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Waiman Long <longman@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, David Howells <dhowells@redhat.com>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, Linus Torvalds <torvalds@linux-foundation.org>, Joe Perches <joe@perches.com>, Matthew Wilcox <willy@infradead.org>, David Rientjes <rientjes@google.com>
Cc: samba-technical@lists.samba.org, virtualization@lists.linux-foundation.org, linux-mm@kvack.org, linux-sctp@vger.kernel.org, target-devel@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com, devel@driverdev.osuosl.org, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, x86@kernel.org, kasan-dev@googlegroups.com, cocci@systeme.lip6.fr, linux-wpan@vger.kernel.org, intel-wired-lan@lists.osuosl.org, linux-crypto@vger.kernel.org, linux-pm@vger.kernel.org, ecryptfs@vger.kernel.org, linux-nfs@vger.kernel.org, linux-fscrypt@vger.kernel.org, linux-mediatek@lists.infradead.org, linux-amlogic@lists.infradead.org, linux-arm-kernel@lists.infradead.org, linux-cifs@vger.kernel.org, netdev@vger.kernel.org, linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, tipc-discussion@lists.sourceforge.net, wireguard@lists.zx2c4.com, linux-ppp@vger.kernel.org, linux-integrity@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-btrfs@vger.kernel.org



Le 14/04/2020 à 00:28, Waiman Long a écrit :
> Since kfree_sensitive() will do an implicit memzero_explicit(), there
> is no need to call memzero_explicit() before it. Eliminate those
> memzero_explicit() and simplify the call sites. For better correctness,
> the setting of keylen is also moved down after the key pointer check.
> 
> Signed-off-by: Waiman Long <longman@redhat.com>
> ---
>   .../allwinner/sun8i-ce/sun8i-ce-cipher.c      | 19 +++++-------------
>   .../allwinner/sun8i-ss/sun8i-ss-cipher.c      | 20 +++++--------------
>   drivers/crypto/amlogic/amlogic-gxl-cipher.c   | 12 +++--------
>   drivers/crypto/inside-secure/safexcel_hash.c  |  3 +--
>   4 files changed, 14 insertions(+), 40 deletions(-)
> 
> diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
> index aa4e8fdc2b32..8358fac98719 100644
> --- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
> +++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
> @@ -366,10 +366,7 @@ void sun8i_ce_cipher_exit(struct crypto_tfm *tfm)
>   {
>   	struct sun8i_cipher_tfm_ctx *op = crypto_tfm_ctx(tfm);
>   
> -	if (op->key) {
> -		memzero_explicit(op->key, op->keylen);
> -		kfree(op->key);
> -	}
> +	kfree_sensitive(op->key);
>   	crypto_free_sync_skcipher(op->fallback_tfm);
>   	pm_runtime_put_sync_suspend(op->ce->dev);
>   }
> @@ -391,14 +388,11 @@ int sun8i_ce_aes_setkey(struct crypto_skcipher *tfm, const u8 *key,
>   		dev_dbg(ce->dev, "ERROR: Invalid keylen %u\n", keylen);
>   		return -EINVAL;
>   	}
> -	if (op->key) {
> -		memzero_explicit(op->key, op->keylen);
> -		kfree(op->key);
> -	}
> -	op->keylen = keylen;
> +	kfree_sensitive(op->key);
>   	op->key = kmemdup(key, keylen, GFP_KERNEL | GFP_DMA);
>   	if (!op->key)
>   		return -ENOMEM;
> +	op->keylen = keylen;

Does it matter at all to ensure op->keylen is not set when of->key is 
NULL ? I'm not sure.

But if it does, then op->keylen should be set to 0 when freeing op->key.

>   
>   	crypto_sync_skcipher_clear_flags(op->fallback_tfm, CRYPTO_TFM_REQ_MASK);
>   	crypto_sync_skcipher_set_flags(op->fallback_tfm, tfm->base.crt_flags & CRYPTO_TFM_REQ_MASK);
> @@ -416,14 +410,11 @@ int sun8i_ce_des3_setkey(struct crypto_skcipher *tfm, const u8 *key,
>   	if (err)
>   		return err;
>   
> -	if (op->key) {
> -		memzero_explicit(op->key, op->keylen);
> -		kfree(op->key);
> -	}
> -	op->keylen = keylen;
> +	kfree_sensitive(op->key);
>   	op->key = kmemdup(key, keylen, GFP_KERNEL | GFP_DMA);
>   	if (!op->key)
>   		return -ENOMEM;
> +	op->keylen = keylen;

Same comment as above.

>   
>   	crypto_sync_skcipher_clear_flags(op->fallback_tfm, CRYPTO_TFM_REQ_MASK);
>   	crypto_sync_skcipher_set_flags(op->fallback_tfm, tfm->base.crt_flags & CRYPTO_TFM_REQ_MASK);
> diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
> index 5246ef4f5430..0495fbc27fcc 100644
> --- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
> +++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
> @@ -249,7 +249,6 @@ static int sun8i_ss_cipher(struct skcipher_request *areq)
>   			offset = areq->cryptlen - ivsize;
>   			if (rctx->op_dir & SS_DECRYPTION) {
>   				memcpy(areq->iv, backup_iv, ivsize);
> -				memzero_explicit(backup_iv, ivsize);
>   				kfree_sensitive(backup_iv);
>   			} else {
>   				scatterwalk_map_and_copy(areq->iv, areq->dst, offset,
> @@ -367,10 +366,7 @@ void sun8i_ss_cipher_exit(struct crypto_tfm *tfm)
>   {
>   	struct sun8i_cipher_tfm_ctx *op = crypto_tfm_ctx(tfm);
>   
> -	if (op->key) {
> -		memzero_explicit(op->key, op->keylen);
> -		kfree(op->key);
> -	}
> +	kfree_sensitive(op->key);
>   	crypto_free_sync_skcipher(op->fallback_tfm);
>   	pm_runtime_put_sync(op->ss->dev);
>   }
> @@ -392,14 +388,11 @@ int sun8i_ss_aes_setkey(struct crypto_skcipher *tfm, const u8 *key,
>   		dev_dbg(ss->dev, "ERROR: Invalid keylen %u\n", keylen);
>   		return -EINVAL;
>   	}
> -	if (op->key) {
> -		memzero_explicit(op->key, op->keylen);
> -		kfree(op->key);
> -	}
> -	op->keylen = keylen;
> +	kfree_sensitive(op->key);
>   	op->key = kmemdup(key, keylen, GFP_KERNEL | GFP_DMA);
>   	if (!op->key)
>   		return -ENOMEM;
> +	op->keylen = keylen;

Same comment as above.

>   
>   	crypto_sync_skcipher_clear_flags(op->fallback_tfm, CRYPTO_TFM_REQ_MASK);
>   	crypto_sync_skcipher_set_flags(op->fallback_tfm, tfm->base.crt_flags & CRYPTO_TFM_REQ_MASK);
> @@ -418,14 +411,11 @@ int sun8i_ss_des3_setkey(struct crypto_skcipher *tfm, const u8 *key,
>   		return -EINVAL;
>   	}
>   
> -	if (op->key) {
> -		memzero_explicit(op->key, op->keylen);
> -		kfree(op->key);
> -	}
> -	op->keylen = keylen;
> +	kfree_sensitive(op->key);
>   	op->key = kmemdup(key, keylen, GFP_KERNEL | GFP_DMA);
>   	if (!op->key)
>   		return -ENOMEM;
> +	op->keylen = keylen;

Same comment as above.

>   
>   	crypto_sync_skcipher_clear_flags(op->fallback_tfm, CRYPTO_TFM_REQ_MASK);
>   	crypto_sync_skcipher_set_flags(op->fallback_tfm, tfm->base.crt_flags & CRYPTO_TFM_REQ_MASK);
> diff --git a/drivers/crypto/amlogic/amlogic-gxl-cipher.c b/drivers/crypto/amlogic/amlogic-gxl-cipher.c
> index fd1269900d67..6aa9ce7bbbd4 100644
> --- a/drivers/crypto/amlogic/amlogic-gxl-cipher.c
> +++ b/drivers/crypto/amlogic/amlogic-gxl-cipher.c
> @@ -341,10 +341,7 @@ void meson_cipher_exit(struct crypto_tfm *tfm)
>   {
>   	struct meson_cipher_tfm_ctx *op = crypto_tfm_ctx(tfm);
>   
> -	if (op->key) {
> -		memzero_explicit(op->key, op->keylen);
> -		kfree(op->key);
> -	}
> +	kfree_sensitive(op->key);
>   	crypto_free_sync_skcipher(op->fallback_tfm);
>   }
>   
> @@ -368,14 +365,11 @@ int meson_aes_setkey(struct crypto_skcipher *tfm, const u8 *key,
>   		dev_dbg(mc->dev, "ERROR: Invalid keylen %u\n", keylen);
>   		return -EINVAL;
>   	}
> -	if (op->key) {
> -		memzero_explicit(op->key, op->keylen);
> -		kfree(op->key);
> -	}
> -	op->keylen = keylen;
> +	kfree_sensitive(op->key);
>   	op->key = kmemdup(key, keylen, GFP_KERNEL | GFP_DMA);
>   	if (!op->key)
>   		return -ENOMEM;
> +	op->keylen = keylen;

Same comment as above.

>   
>   	return crypto_sync_skcipher_setkey(op->fallback_tfm, key, keylen);
>   }
> diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
> index 43962bc709c6..4a2d162914de 100644
> --- a/drivers/crypto/inside-secure/safexcel_hash.c
> +++ b/drivers/crypto/inside-secure/safexcel_hash.c
> @@ -1081,8 +1081,7 @@ static int safexcel_hmac_init_pad(struct ahash_request *areq,
>   		}
>   
>   		/* Avoid leaking */
> -		memzero_explicit(keydup, keylen);
> -		kfree(keydup);
> +		kfree_sensitive(keydup);
>   
>   		if (ret)
>   			return ret;
> 


Christophe
