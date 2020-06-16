From: Michal Hocko <mhocko@kernel.org>
Date: Tue, 16 Jun 2020 06:42:08 +0000
Subject: Re: [PATCH v4 1/3] mm/slab: Use memzero_explicit() in kzfree()
Message-Id: <20200616064208.GA9499@dhcp22.suse.cz>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200616015718.7812-1-longman@redhat.com>
 <20200616015718.7812-2-longman@redhat.com>
In-Reply-To: <20200616015718.7812-2-longman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: "Jason A . Donenfeld" <Jason@zx2c4.com>, linux-btrfs@vger.kernel.org, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, David Sterba <dsterba@suse.cz>, David Howells <dhowells@redhat.com>, linux-mm@kvack.org, linux-sctp@vger.kernel.org, keyrings@vger.kernel.org, kasan-dev@googlegroups.com, linux-stm32@st-md-mailman.stormreply.com, devel@driverdev.osuosl.org, linux-cifs@vger.kernel.org, linux-scsi@vger.kernel.org, James Morris <jmorris@namei.org>, Matthew Wilcox <willy@infradead.org>, linux-wpan@vger.kernel.org, David Rientjes <rientjes@google.com>, Dan Carpenter <dan.carpenter@oracle.com>, linux-pm@vger.kernel.org, ecryptfs@vger.kernel.org, linux-fscrypt@vger.kernel.org, linux-mediatek@lists.infradead.org, linux-amlogic@lists.infradead.org, virtualization@lists.linux-foundation.org, linux-integrity@vger.kernel.org, linux-nfs@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, linux-bluetooth@vger.kernel.org, linux-security-module@vger.kernel.org, target-devel@vger.kernel.org, tipc-discussion@lists.sourceforge.net, linux-crypto@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>, linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org, wireguard@lists.zx2c4.com, linux-ppp@vger.kernel.org

On Mon 15-06-20 21:57:16, Waiman Long wrote:
> The kzfree() function is normally used to clear some sensitive
> information, like encryption keys, in the buffer before freeing it back
> to the pool. Memset() is currently used for the buffer clearing. However,
> it is entirely possible that the compiler may choose to optimize away the
> memory clearing especially if LTO is being used. To make sure that this
> optimization will not happen, memzero_explicit(), which is introduced
> in v3.18, is now used in kzfree() to do the clearing.
> 
> Fixes: 3ef0e5ba4673 ("slab: introduce kzfree()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Waiman Long <longman@redhat.com>

Acked-by: Michal Hocko <mhocko@suse.com>

Although I am not really sure this is a stable material. Is there any
known instance where the memset was optimized out from kzfree?

> ---
>  mm/slab_common.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index 9e72ba224175..37d48a56431d 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -1726,7 +1726,7 @@ void kzfree(const void *p)
>  	if (unlikely(ZERO_OR_NULL_PTR(mem)))
>  		return;
>  	ks = ksize(mem);
> -	memset(mem, 0, ks);
> +	memzero_explicit(mem, ks);
>  	kfree(mem);
>  }
>  EXPORT_SYMBOL(kzfree);
> -- 
> 2.18.1
> 

-- 
Michal Hocko
SUSE Labs
