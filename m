From: Waiman Long <longman@redhat.com>
Date: Tue, 14 Apr 2020 19:37:51 +0000
Subject: Re: [PATCH v2 2/2] crypto: Remove unnecessary memzero_explicit()
Message-Id: <578fe9b6-1ccd-2698-60aa-96c3f2dd2c31@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200413211550.8307-1-longman@redhat.com>
 <20200413222846.24240-1-longman@redhat.com>
 <eca85e0b-0af3-c43a-31e4-bd5c3f519798@c-s.fr>
 <e194a51f-a5e5-a557-c008-b08cac558572@redhat.com>
 <20200414191601.GZ25468@kitsune.suse.cz>
In-Reply-To: <20200414191601.GZ25468@kitsune.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: =?UTF-8?Q?Michal_Such=c3=a1nek?= <msuchanek@suse.de>
Cc: linux-btrfs@vger.kernel.org, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, virtualization@lists.linux-foundation.org, David Howells <dhowells@redhat.com>, linux-mm@kvack.org, linux-sctp@vger.kernel.org, keyrings@vger.kernel.org, kasan-dev@googlegroups.com, samba-technical@lists.samba.org, linux-stm32@st-md-mailman.stormreply.com, devel@driverdev.osuosl.org, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, x86@kernel.org, James Morris <jmorris@namei.org>, Matthew Wilcox <willy@infradead.org>, cocci@systeme.lip6.fr, linux-wpan@vger.kernel.org, intel-wired-lan@lists.osuosl.org, David Rientjes <rientjes@google.com>, "Serge E. Hallyn" <serge@hallyn.com>, linux-pm@vger.kernel.org, ecryptfs@vger.kernel.org, linux-nfs@vger.kernel.org, linux-fscrypt@vger.kernel.org, linux-mediatek@lists.infradead.org, linux-amlogic@lists.infradead.org, linux-integrity@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Christophe Leroy <christophe.leroy@c-s.fr>, linux-cifs@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org, linux-security-module@vger.kernel.org, target-devel@vger.kernel.org, tipc-discussion@lists.sourceforge.net, linux-crypto@vger.kernel.org, netdev@vger.kernel.org, Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>, linuxppc-dev@lists.ozlabs.org, wireguard@lists.zx2c4.com, linux-ppp@vger.kernel.org

On 4/14/20 3:16 PM, Michal Such=E1nek wrote:
> On Tue, Apr 14, 2020 at 12:24:36PM -0400, Waiman Long wrote:
>> On 4/14/20 2:08 AM, Christophe Leroy wrote:
>>>
>>> Le 14/04/2020 =E0 00:28, Waiman Long a =E9crit=A0:
>>>> Since kfree_sensitive() will do an implicit memzero_explicit(), there
>>>> is no need to call memzero_explicit() before it. Eliminate those
>>>> memzero_explicit() and simplify the call sites. For better correctness,
>>>> the setting of keylen is also moved down after the key pointer check.
>>>>
>>>> Signed-off-by: Waiman Long <longman@redhat.com>
>>>> ---
>>>> =A0 .../allwinner/sun8i-ce/sun8i-ce-cipher.c=A0=A0=A0=A0=A0 | 19 +++++=
-------------
>>>> =A0 .../allwinner/sun8i-ss/sun8i-ss-cipher.c=A0=A0=A0=A0=A0 | 20 +++++=
--------------
>>>> =A0 drivers/crypto/amlogic/amlogic-gxl-cipher.c=A0=A0 | 12 +++--------
>>>> =A0 drivers/crypto/inside-secure/safexcel_hash.c=A0 |=A0 3 +--
>>>> =A0 4 files changed, 14 insertions(+), 40 deletions(-)
>>>>
>>>> diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
>>>> b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
>>>> index aa4e8fdc2b32..8358fac98719 100644
>>>> --- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
>>>> +++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
>>>> @@ -366,10 +366,7 @@ void sun8i_ce_cipher_exit(struct crypto_tfm *tfm)
>>>> =A0 {
>>>> =A0=A0=A0=A0=A0 struct sun8i_cipher_tfm_ctx *op =3D crypto_tfm_ctx(tfm=
);
>>>> =A0 -=A0=A0=A0 if (op->key) {
>>>> -=A0=A0=A0=A0=A0=A0=A0 memzero_explicit(op->key, op->keylen);
>>>> -=A0=A0=A0=A0=A0=A0=A0 kfree(op->key);
>>>> -=A0=A0=A0 }
>>>> +=A0=A0=A0 kfree_sensitive(op->key);
>>>> =A0=A0=A0=A0=A0 crypto_free_sync_skcipher(op->fallback_tfm);
>>>> =A0=A0=A0=A0=A0 pm_runtime_put_sync_suspend(op->ce->dev);
>>>> =A0 }
>>>> @@ -391,14 +388,11 @@ int sun8i_ce_aes_setkey(struct crypto_skcipher
>>>> *tfm, const u8 *key,
>>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0 dev_dbg(ce->dev, "ERROR: Invalid keylen %u=
\n", keylen);
>>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0 return -EINVAL;
>>>> =A0=A0=A0=A0=A0 }
>>>> -=A0=A0=A0 if (op->key) {
>>>> -=A0=A0=A0=A0=A0=A0=A0 memzero_explicit(op->key, op->keylen);
>>>> -=A0=A0=A0=A0=A0=A0=A0 kfree(op->key);
>>>> -=A0=A0=A0 }
>>>> -=A0=A0=A0 op->keylen =3D keylen;
>>>> +=A0=A0=A0 kfree_sensitive(op->key);
>>>> =A0=A0=A0=A0=A0 op->key =3D kmemdup(key, keylen, GFP_KERNEL | GFP_DMA);
>>>> =A0=A0=A0=A0=A0 if (!op->key)
>>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0 return -ENOMEM;
>>>> +=A0=A0=A0 op->keylen =3D keylen;
>>> Does it matter at all to ensure op->keylen is not set when of->key is
>>> NULL ? I'm not sure.
>>>
>>> But if it does, then op->keylen should be set to 0 when freeing op->key=
.=20
>> My thinking is that if memory allocation fails, we just don't touch
>> anything and return an error code. I will not explicitly set keylen to 0
>> in this case unless it is specified in the API documentation.
> You already freed the key by now so not touching anything is not
> possible. The key is set to NULL on allocation failure so setting keylen
> to 0 should be redundant. However, setting keylen to 0 is consisent with
> not having a key, and it avoids the possibility of leaking the length
> later should that ever cause any problem.

OK, I can change it to clear the key length when the allocation failed
which isn't likely.

Cheers,
Longman
