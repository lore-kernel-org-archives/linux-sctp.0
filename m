From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 30 Dec 2015 17:41:03 +0000
Subject: Re: [PATCH net-next 1/5] sctp: add the rhashtable apis for sctp global transport hashtable
Message-Id: <20151230174103.GC16270@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1451490447.git.lucien.xin@gmail.com>
 <2c413161eb3a2c74453bd8dc11815af7e237515e.1451490447.git.lucien.xin@gmail.com>
In-Reply-To: <2c413161eb3a2c74453bd8dc11815af7e237515e.1451490447.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, mleitner@redhat.com, vyasevic@redhat.com, daniel@iogearbox.net, davem@davemloft.net, Herbert Xu <herbert@gondor.apana.org.au>, Xin Long <lucien.xin@gmail.com>

On Wed, Dec 30, 2015 at 11:50:46PM +0800, Xin Long wrote:
...
> +void sctp_hash_transport(struct sctp_transport *t)
> +{
> +	struct sctp_sockaddr_entry *addr;
> +	struct sctp_hash_cmp_arg arg;
> +
> +	addr = list_entry(t->asoc->base.bind_addr.address_list.next,
> +			  struct sctp_sockaddr_entry, list);
> +	arg.laddr = &addr->a;
> +	arg.paddr = &t->ipaddr;
> +	arg.net   = sock_net(t->asoc->base.sk);
> +
> +reinsert:
> +	if (rhashtable_lookup_insert_key(&sctp_transport_hashtable, &arg,
> +					 &t->node, sctp_hash_params) = -EBUSY)
> +		goto reinsert;
> +}

This is the nasty situation I mentioned in previous email. It seems that
a stress test can trigger a double rehash and cause an entry to not be
added.

This is in fact very near some bugs you caught on rhashtable in the past
few days/couple of weeks tops.

I'm actually against this loop as is. I may have not been clear with Xin
about not adding my signature to the patchset due to this.

Please take a look at Xin's emails on thread 'rhashtable: Prevent
spurious EBUSY errors on insertion' about this particular situation.
Cc'ing Herbert as he wanted to see the patches for that issue.

  Marcelo

