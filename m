From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Tue, 16 Jun 2020 09:08:07 +0000
Subject: Re: [PATCH v4 1/3] mm/slab: Use memzero_explicit() in kzfree()
Message-Id: <20200616090807.GK4151@kadam>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200616015718.7812-1-longman@redhat.com>
 <20200616015718.7812-2-longman@redhat.com>
 <20200616064208.GA9499@dhcp22.suse.cz>
In-Reply-To: <20200616064208.GA9499@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: "Jason A . Donenfeld" <Jason@zx2c4.com>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, virtualization@lists.linux-foundation.org, David Howells <dhowells@redhat.com>, linux-mm@kvack.org, linux-sctp@vger.kernel.org, keyrings@vger.kernel.org, kasan-dev@googlegroups.com, linux-stm32@st-md-mailman.stormreply.com, devel@driverdev.osuosl.org, linux-cifs@vger.kernel.org, linux-scsi@vger.kernel.org, James Morris <jmorris@namei.org>, Matthew Wilcox <willy@infradead.org>, David Rientjes <rientjes@google.com>, Waiman Long <longman@redhat.com>, linux-pm@vger.kernel.org, ecryptfs@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, wireguard@lists.zx2c4.com, linux-fscrypt@vger.kernel.org, linux-mediatek@lists.infradead.org, linux-amlogic@lists.infradead.org, Andrew Morton <akpm@linux-foundation.org>, linux-nfs@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, linux-wireless@vger.kernel.org, David Sterba <dsterba@suse.cz>, stable@vger.kernel.org, linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org, linux-security-module@vger.kernel.org, target-devel@vger.kernel.org, tipc-discussion@lists.sourceforge.net, linux-crypto@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, Joe Perches <joe@perches.com>, linux-integrity@vger.kernel.org, linux-wpan@vger.kernel.org, netdev@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ppp@vger.kernel.org

On Tue, Jun 16, 2020 at 08:42:08AM +0200, Michal Hocko wrote:
> On Mon 15-06-20 21:57:16, Waiman Long wrote:
> > The kzfree() function is normally used to clear some sensitive
> > information, like encryption keys, in the buffer before freeing it back
> > to the pool. Memset() is currently used for the buffer clearing. However,
> > it is entirely possible that the compiler may choose to optimize away the
> > memory clearing especially if LTO is being used. To make sure that this
> > optimization will not happen, memzero_explicit(), which is introduced
> > in v3.18, is now used in kzfree() to do the clearing.
> > 
> > Fixes: 3ef0e5ba4673 ("slab: introduce kzfree()")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Waiman Long <longman@redhat.com>
> 
> Acked-by: Michal Hocko <mhocko@suse.com>
> 
> Although I am not really sure this is a stable material. Is there any
> known instance where the memset was optimized out from kzfree?

I told him to add the stable.  Otherwise it will just get reported to
me again.  It's a just safer to backport it before we forget.

regards,
dan carpenter
