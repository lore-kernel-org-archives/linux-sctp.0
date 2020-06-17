From: Denis Efremov <efremov@ispras.ru>
Date: Wed, 17 Jun 2020 21:31:01 +0000
Subject: Re: [PATCH v4 0/3] mm, treewide: Rename kzfree() to kfree_sensitive()
Message-Id: <17e4fede-bab0-d93c-6964-69decc889d7d@ispras.ru>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200616015718.7812-1-longman@redhat.com>
 <fe3b9a437be4aeab3bac68f04193cb6daaa5bee4.camel@perches.com>
In-Reply-To: <fe3b9a437be4aeab3bac68f04193cb6daaa5bee4.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joe Perches <joe@perches.com>, Waiman Long <longman@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, David Howells <dhowells@redhat.com>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, Linus Torvalds <torvalds@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, David Rientjes <rientjes@google.com>
Cc: "Jason A . Donenfeld" <Jason@zx2c4.com>, Michal Hocko <mhocko@suse.com>, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-sctp@vger.kernel.org, target-devel@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com, devel@driverdev.osuosl.org, linux-cifs@vger.kernel.org, linux-scsi@vger.kernel.org, kasan-dev@googlegroups.com, linux-wpan@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>, linux-pm@vger.kernel.org, ecryptfs@vger.kernel.org, linux-fscrypt@vger.kernel.org, linux-mediatek@lists.infradead.org, linux-amlogic@lists.infradead.org, virtualization@lists.linux-foundation.org, linux-nfs@vger.kernel.org, netdev@vger.kernel.org, linux-wireless@vger.kernel.org, David Sterba <dsterba@suse.cz>, linux-bluetooth@vger.kernel.org, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, tipc-discussion@lists.sourceforge.net, linux-crypto@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, linux-integrity@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, wireguard@lists.zx2c4.com, linux-ppp@vger.kernel.org



On 6/16/20 9:53 PM, Joe Perches wrote:
> On Mon, 2020-06-15 at 21:57 -0400, Waiman Long wrote:
>>  v4:
>>   - Break out the memzero_explicit() change as suggested by Dan Carpenter
>>     so that it can be backported to stable.
>>   - Drop the "crypto: Remove unnecessary memzero_explicit()" patch for
>>     now as there can be a bit more discussion on what is best. It will be
>>     introduced as a separate patch later on after this one is merged.
> 
> To this larger audience and last week without reply:
> https://lore.kernel.org/lkml/573b3fbd5927c643920e1364230c296b23e7584d.camel@perches.com/
> 
> Are there _any_ fastpath uses of kfree or vfree?
> 
> Many patches have been posted recently to fix mispairings
> of specific types of alloc and free functions.

I've prepared a coccinelle script to highlight these mispairings in a function
a couple of days ago: https://lkml.org/lkml/2020/6/5/953
I've listed all the fixes in the commit message. 

Not so many mispairings actually, and most of them are harmless like:
kmalloc(E) -> kvfree(E)

However, coccinelle script can't detect cross-functions mispairings, i.e.
allocation in one function, free in another funtion.

Thanks,
Denis
