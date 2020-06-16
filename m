From: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 16 Jun 2020 18:09:44 +0000
Subject: Re: [PATCH v5 2/2] mm, treewide: Rename kzfree() to kfree_sensitive()
Message-Id: <20200616110944.c13f221e5c3f54e775190afe@linux-foundation.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200616154311.12314-1-longman@redhat.com>
 <20200616154311.12314-3-longman@redhat.com>
In-Reply-To: <20200616154311.12314-3-longman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: "Jason A . Donenfeld" <Jason@zx2c4.com>, Michal Hocko <mhocko@suse.com>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, virtualization@lists.linux-foundation.org, David Howells <dhowells@redhat.com>, linux-mm@kvack.org, linux-sctp@vger.kernel.org, keyrings@vger.kernel.org, kasan-dev@googlegroups.com, linux-stm32@st-md-mailman.stormreply.com, devel@driverdev.osuosl.org, linux-cifs@vger.kernel.org, linux-scsi@vger.kernel.org, James Morris <jmorris@namei.org>, Matthew Wilcox <willy@infradead.org>, linux-wpan@vger.kernel.org, David Rientjes <rientjes@google.com>, Dan Carpenter <dan.carpenter@oracle.com>, linux-pm@vger.kernel.org, ecryptfs@vger.kernel.org, linux-fscrypt@vger.kernel.org, linux-mediatek@lists.infradead.org, linux-amlogic@lists.infradead.org, linux-nfs@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org, linux-security-module@vger.kernel.org, target-devel@vger.kernel.org, tipc-discussion@lists.sourceforge.net, linux-crypto@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, Joe Perches <joe@perches.com>, linux-integrity@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org, wireguard@lists.zx2c4.com, linux-ppp@vger.kernel.org

On Tue, 16 Jun 2020 11:43:11 -0400 Waiman Long <longman@redhat.com> wrote:

> As said by Linus:
> 
>   A symmetric naming is only helpful if it implies symmetries in use.
>   Otherwise it's actively misleading.
> 
>   In "kzalloc()", the z is meaningful and an important part of what the
>   caller wants.
> 
>   In "kzfree()", the z is actively detrimental, because maybe in the
>   future we really _might_ want to use that "memfill(0xdeadbeef)" or
>   something. The "zero" part of the interface isn't even _relevant_.
> 
> The main reason that kzfree() exists is to clear sensitive information
> that should not be leaked to other future users of the same memory
> objects.
> 
> Rename kzfree() to kfree_sensitive() to follow the example of the
> recently added kvfree_sensitive() and make the intention of the API
> more explicit. In addition, memzero_explicit() is used to clear the
> memory to make sure that it won't get optimized away by the compiler.
> 
> The renaming is done by using the command sequence:
> 
>   git grep -w --name-only kzfree |\
>   xargs sed -i 's/\bkzfree\b/kfree_sensitive/'
> 
> followed by some editing of the kfree_sensitive() kerneldoc and adding
> a kzfree backward compatibility macro in slab.h.
> 
> ...
>
> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -186,10 +186,12 @@ void memcg_deactivate_kmem_caches(struct mem_cgroup *, struct mem_cgroup *);
>   */
>  void * __must_check krealloc(const void *, size_t, gfp_t);
>  void kfree(const void *);
> -void kzfree(const void *);
> +void kfree_sensitive(const void *);
>  size_t __ksize(const void *);
>  size_t ksize(const void *);
>  
> +#define kzfree(x)	kfree_sensitive(x)	/* For backward compatibility */
> +

What was the thinking here?  Is this really necessary?

I suppose we could keep this around for a while to ease migration.  But
not for too long, please.
