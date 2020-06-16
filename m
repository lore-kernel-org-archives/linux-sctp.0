From: Matthew Wilcox <willy@infradead.org>
Date: Tue, 16 Jun 2020 21:14:55 +0000
Subject: Re: [PATCH v4 0/3] mm, treewide: Rename kzfree() to kfree_sensitive()
Message-Id: <20200616211455.GB8681@bombadil.infradead.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200616015718.7812-1-longman@redhat.com>
 <fe3b9a437be4aeab3bac68f04193cb6daaa5bee4.camel@perches.com>
In-Reply-To: <fe3b9a437be4aeab3bac68f04193cb6daaa5bee4.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joe Perches <joe@perches.com>
Cc: "Jason A . Donenfeld" <Jason@zx2c4.com>, Michal Hocko <mhocko@suse.com>, linux-btrfs@vger.kernel.org, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, David Sterba <dsterba@suse.cz>, David Howells <dhowells@redhat.com>, linux-mm@kvack.org, linux-sctp@vger.kernel.org, keyrings@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com, devel@driverdev.osuosl.org, linux-cifs@vger.kernel.org, linux-scsi@vger.kernel.org, James Morris <jmorris@namei.org>, kasan-dev@googlegroups.com, linux-wpan@vger.kernel.org, David Rientjes <rientjes@google.com>, Waiman Long <longman@redhat.com>, Dan Carpenter <dan.carpenter@oracle.com>, linux-pm@vger.kernel.org, ecryptfs@vger.kernel.org, linux-fscrypt@vger.kernel.org, linux-mediatek@lists.infradead.org, linux-amlogic@lists.infradead.org, virtualization@lists.linux-foundation.org, linux-integrity@vger.kernel.org, linux-nfs@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org, linux-security-module@vger.kernel.org, target-devel@vger.kernel.org, tipc-discussion@lists.sourceforge.net, linux-crypto@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org, wireguard@lists.zx2c4.com, linux-ppp@vger.kernel.org

On Tue, Jun 16, 2020 at 11:53:50AM -0700, Joe Perches wrote:
> To this larger audience and last week without reply:
> https://lore.kernel.org/lkml/573b3fbd5927c643920e1364230c296b23e7584d.camel@perches.com/
> 
> Are there _any_ fastpath uses of kfree or vfree?

I worked on adding a 'free' a couple of years ago.  That was capable
of freeing percpu, vmalloc, kmalloc and alloc_pages memory.  I ran into
trouble when I tried to free kmem_cache_alloc memory -- it works for slab
and slub, but not slob (because slob needs the size from the kmem_cache).

My motivation for this was to change kfree_rcu() to just free_rcu().

> To eliminate these mispairings at a runtime cost of four
> comparisons, should the kfree/vfree/kvfree/kfree_const
> functions be consolidated into a single kfree?

I would say to leave kfree() alone and just introduce free() as a new
default.  There's some weird places in the kernel that have a 'free'
symbol of their own, but those should be renamed anyway.
