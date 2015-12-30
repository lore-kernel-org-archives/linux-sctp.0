From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Wed, 30 Dec 2015 16:57:31 +0000
Subject: Re: [PATCH net-next 1/5] sctp: add the rhashtable apis for sctp global transport hashtable
Message-Id: <1451494651.8255.22.camel@edumazet-glaptop2.roam.corp.google.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1451490447.git.lucien.xin@gmail.com>
	 <2c413161eb3a2c74453bd8dc11815af7e237515e.1451490447.git.lucien.xin@gmail.com>
In-Reply-To: <2c413161eb3a2c74453bd8dc11815af7e237515e.1451490447.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, mleitner@redhat.com, vyasevic@redhat.com, daniel@iogearbox.net, davem@davemloft.net

On Wed, 2015-12-30 at 23:50 +0800, Xin Long wrote:
> tranport hashtbale will replace the association hashtable to do the
> lookup for transport, and then get association by t->assoc, rhashtable
> apis will be used because of it's resizable, scalable and using rcu.
> 
> lport + rport + paddr will be the base hashkey to locate the chain,
> with net to protect one netns from another, then plus the laddr to
> compare to get the target.
> 
> this patch will provider the lookup functions:
> - sctp_epaddr_lookup_transport
> - sctp_addrs_lookup_transport
> 
> hash/unhash functions:
> - sctp_hash_transport
> - sctp_unhash_transport
> 
> init/destroy functions:
> - sctp_transport_hashtable_init
> - sctp_transport_hashtable_destroy
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> ---


I am against using rhashtable in SCTP (or TCP) at this stage, given the
number of bugs we have with it.



