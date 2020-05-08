From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Fri, 08 May 2020 06:07:01 +0000
Subject: Re: [PATCH 00/20] crypto: introduce crypto_shash_tfm_digest()
Message-Id: <20200508060700.GA24956@gondor.apana.org.au>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200502053122.995648-1-ebiggers@kernel.org>
In-Reply-To: <20200502053122.995648-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, cychiang@chromium.org, ecryptfs@vger.kernel.org, enric.balletbo@collabora.com, gilad@benyossef.com, groeck@chromium.org, jesper.nilsson@axis.com, k.konieczny@samsung.com, keyrings@vger.kernel.org, krzk@kernel.org, k.opasiak@samsung.com, lars.persson@axis.com, linux-bluetooth@vger.kernel.org, linux-mtd@lists.infradead.org, linux-nfs@vger.kernel.org, linux-sctp@vger.kernel.org, r.baldyga@samsung.com, thomas.lendacky@amd.com, vz@mleia.com, xuzaibo@huawei.com

Eric Biggers <ebiggers@kernel.org> wrote:
> This series introduces a helper function crypto_shash_tfm_digest() which
> replaces the following common pattern:
> 
>        {
>                SHASH_DESC_ON_STACK(desc, tfm);
>                int err;
> 
>                desc->tfm = tfm;
> 
>                err = crypto_shash_digest(desc, data, len, out);
> 
>                shash_desc_zero(desc);
>        }
> 
> with:
> 
>        err = crypto_shash_tfm_digest(tfm, data, len, out);
> 
> Patch 1 introduces this helper function, and patches 2-20 convert all
> relevant users to use it.
> 
> IMO, it would be easiest to take all these patches through the crypto
> tree.  But taking just the "crypto:" ones and then me trying to get the
> rest merged later via subsystem trees is also an option.
> 
> Eric Biggers (20):
>  crypto: hash - introduce crypto_shash_tfm_digest()
>  crypto: arm64/aes-glue - use crypto_shash_tfm_digest()
>  crypto: essiv - use crypto_shash_tfm_digest()
>  crypto: artpec6 - use crypto_shash_tfm_digest()
>  crypto: ccp - use crypto_shash_tfm_digest()
>  crypto: ccree - use crypto_shash_tfm_digest()
>  crypto: hisilicon/sec2 - use crypto_shash_tfm_digest()
>  crypto: mediatek - use crypto_shash_tfm_digest()
>  crypto: n2 - use crypto_shash_tfm_digest()
>  crypto: omap-sham - use crypto_shash_tfm_digest()
>  crypto: s5p-sss - use crypto_shash_tfm_digest()
>  nfc: s3fwrn5: use crypto_shash_tfm_digest()
>  fscrypt: use crypto_shash_tfm_digest()
>  ecryptfs: use crypto_shash_tfm_digest()
>  nfsd: use crypto_shash_tfm_digest()
>  ubifs: use crypto_shash_tfm_digest()
>  Bluetooth: use crypto_shash_tfm_digest()
>  sctp: use crypto_shash_tfm_digest()
>  KEYS: encrypted: use crypto_shash_tfm_digest()
>  ASoC: cros_ec_codec: use crypto_shash_tfm_digest()
> 
> arch/arm64/crypto/aes-glue.c               |  4 +--
> crypto/essiv.c                             |  4 +--
> crypto/shash.c                             | 16 +++++++++
> drivers/crypto/axis/artpec6_crypto.c       | 10 ++----
> drivers/crypto/ccp/ccp-crypto-sha.c        |  9 ++---
> drivers/crypto/ccree/cc_cipher.c           |  9 ++---
> drivers/crypto/hisilicon/sec2/sec_crypto.c |  5 ++-
> drivers/crypto/mediatek/mtk-sha.c          |  7 ++--
> drivers/crypto/n2_core.c                   |  7 ++--
> drivers/crypto/omap-sham.c                 | 20 +++--------
> drivers/crypto/s5p-sss.c                   | 39 ++++------------------
> drivers/nfc/s3fwrn5/firmware.c             | 10 +-----
> fs/crypto/fname.c                          |  7 +---
> fs/crypto/hkdf.c                           |  6 +---
> fs/ecryptfs/crypto.c                       | 17 +---------
> fs/nfsd/nfs4recover.c                      | 26 ++++-----------
> fs/ubifs/auth.c                            | 20 ++---------
> fs/ubifs/master.c                          |  9 ++---
> fs/ubifs/replay.c                          | 14 ++------
> include/crypto/hash.h                      | 19 +++++++++++
> net/bluetooth/smp.c                        |  6 +---
> net/sctp/auth.c                            | 10 ++----
> net/sctp/sm_make_chunk.c                   | 23 +++++--------
> security/keys/encrypted-keys/encrypted.c   | 18 ++--------
> sound/soc/codecs/cros_ec_codec.c           |  9 +----
> 25 files changed, 95 insertions(+), 229 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
