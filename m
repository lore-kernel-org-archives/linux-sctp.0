From: Waiman Long <longman@redhat.com>
Date: Tue, 16 Jun 2020 15:05:59 +0000
Subject: Re: [PATCH v4 2/3] mm, treewide: Rename kzfree() to kfree_sensitive()
Message-Id: <72aa954d-4933-333c-b784-f8df14e407e6@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200616015718.7812-1-longman@redhat.com>
 <20200616015718.7812-3-longman@redhat.com> <20200616142624.GO4282@kadam>
In-Reply-To: <20200616142624.GO4282@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "Jason A . Donenfeld" <Jason@zx2c4.com>, Michal Hocko <mhocko@suse.com>, linux-btrfs@vger.kernel.org, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, David Sterba <dsterba@suse.cz>, David Howells <dhowells@redhat.com>, linux-mm@kvack.org, linux-sctp@vger.kernel.org, keyrings@vger.kernel.org, kasan-dev@googlegroups.com, linux-stm32@st-md-mailman.stormreply.com, devel@driverdev.osuosl.org, linux-cifs@vger.kernel.org, linux-scsi@vger.kernel.org, James Morris <jmorris@namei.org>, Matthew Wilcox <willy@infradead.org>, linux-wpan@vger.kernel.org, David Rientjes <rientjes@google.com>, linux-pm@vger.kernel.org, ecryptfs@vger.kernel.org, linux-fscrypt@vger.kernel.org, linux-mediatek@lists.infradead.org, linux-amlogic@lists.infradead.org, virtualization@lists.linux-foundation.org, linux-integrity@vger.kernel.org, linux-nfs@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org, linux-security-module@vger.kernel.org, target-devel@vger.kernel.org, tipc-discussion@lists.sourceforge.net, linux-crypto@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>, linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org, wireguard@lists.zx2c4.com, linux-ppp@vger.kernel.org

On 6/16/20 10:26 AM, Dan Carpenter wrote:
> Last time you sent this we couldn't decide which tree it should go
> through.  Either the crypto tree or through Andrew seems like the right
> thing to me.
>
> Also the other issue is that it risks breaking things if people add
> new kzfree() instances while we are doing the transition.  Could you
> just add a "#define kzfree kfree_sensitive" so that things continue to
> compile and we can remove it in the next kernel release?
>
> regards,
> dan carpenter
>
Yes, that make sure sense. Will send out v5 later today.

Cheers,
Longman
