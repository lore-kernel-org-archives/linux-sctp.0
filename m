From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Mon, 11 Jan 2016 09:30:12 +0000
Subject: Re: [PATCH net-next 1/5] sctp: add the rhashtable apis for sctp global transport hashtable
Message-Id: <20160111093012.GA23525@gondor.apana.org.au>
List-Id: <linux-sctp.vger.kernel.org>
References: <2c413161eb3a2c74453bd8dc11815af7e237515e.1451490447.git.lucien.xin@gmail.com>
In-Reply-To: <2c413161eb3a2c74453bd8dc11815af7e237515e.1451490447.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, mleitner@redhat.com, vyasevic@redhat.com, daniel@iogearbox.net, davem@davemloft.net

Xin Long <lucien.xin@gmail.com> wrote:
>
> +static inline int sctp_hash_cmp(struct rhashtable_compare_arg *arg,
> +                               const void *ptr)
> +{
> +       const struct sctp_hash_cmp_arg *x = arg->key;
> +       const struct sctp_transport *t = ptr;
> +       struct sctp_association *asoc = t->asoc;
> +       const struct net *net = x->net;
> +
> +       if (x->laddr->v4.sin_port != htons(asoc->base.bind_addr.port))
> +               return 1;
> +       if (!sctp_cmp_addr_exact(&t->ipaddr, x->paddr))
> +               return 1;
> +       if (!net_eq(sock_net(asoc->base.sk), net))
> +               return 1;
> +       if (!sctp_bind_addr_match(&asoc->base.bind_addr,
> +                                 x->laddr, sctp_sk(asoc->base.sk)))
> +               return 1;
> +
> +       return 0;
> +}
> +
> +static inline u32 sctp_hash_obj(const void *data, u32 len, u32 seed)
> +{
> +       const struct sctp_transport *t = data;
> +       const union sctp_addr *paddr = &t->ipaddr;
> +       const struct net *net = sock_net(t->asoc->base.sk);
> +       u16 lport = htons(t->asoc->base.bind_addr.port);
> +       u32 addr;
> +
> +       if (paddr->sa.sa_family = AF_INET6)
> +               addr = jhash(&paddr->v6.sin6_addr, 16, seed);
> +       else
> +               addr = paddr->v4.sin_addr.s_addr;
> +
> +       return  jhash_3words(addr, ((__u32)paddr->v4.sin_port) << 16 |
> +                            (__force __u32)lport, net_hash_mix(net), seed);
> +}
> +
> +static inline u32 sctp_hash_key(const void *data, u32 len, u32 seed)
> +{
> +       const struct sctp_hash_cmp_arg *x = data;
> +       const union sctp_addr *paddr = x->paddr;
> +       const struct net *net = x->net;
> +       u16 lport = x->laddr->v4.sin_port;
> +       u32 addr;
> +
> +       if (paddr->sa.sa_family = AF_INET6)
> +               addr = jhash(&paddr->v6.sin6_addr, 16, seed);
> +       else
> +               addr = paddr->v4.sin_addr.s_addr;
> +
> +       return  jhash_3words(addr, ((__u32)paddr->v4.sin_port) << 16 |
> +                            (__force __u32)lport, net_hash_mix(net), seed);
> +}

There's your problem.  You are allowing multiple objects to hash
to the same value.  This is unacceptable with rhashtable because
we use the hash chain length to determine if we're under attack
and need to rehash.  This is the reason why you would see EBUSY
during insertion.

So instead of inserting your objects as is, you should instead hash
a list object that then links to all the objects that has the same
hash key.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
