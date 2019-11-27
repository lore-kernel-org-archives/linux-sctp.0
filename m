From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 27 Nov 2019 13:22:46 +0000
Subject: Re: KMSAN: uninit-value in __crc32c_le_base
Message-Id: <20191127132246.GN388551@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <00000000000004b2df0598075fc8@google.com>
 <20191127060138.GB227319@sol.localdomain>
 <CADvbK_fOZ+kLiOOOXN-qUzDC2376-UxHmg1L6xiAFRR6=+re3w@mail.gmail.com>
In-Reply-To: <CADvbK_fOZ+kLiOOOXN-qUzDC2376-UxHmg1L6xiAFRR6=+re3w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: Eric Biggers <ebiggers@kernel.org>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, linux-sctp@vger.kernel.org, syzbot <syzbot+6dcbfea81cd3d4dd0b02@syzkaller.appspotmail.com>, davem <davem@davemloft.net>, Alexander Potapenko <glider@google.com>, Herbert Xu <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, syzkaller-bugs <syzkaller-bugs@googlegroups.com>

On Wed, Nov 27, 2019 at 04:49:46PM +0800, Xin Long wrote:
> On Wed, Nov 27, 2019 at 2:02 PM Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > Looks like a bug in net/sctp/ where it's passing uninitialized memory into the
> > crc32c() function.  SCTP maintainers, can you please take a look?
> Thanks.
> 
> The issue was caused by:
> transport->ipaddr set with uninit addr param, which was passed by:
> 
>   sctp_transport_init net/sctp/transport.c:47 [inline]
>   sctp_transport_new+0x248/0xa00 net/sctp/transport.c:100
>   sctp_assoc_add_peer+0x5ba/0x2030 net/sctp/associola.c:611
>   sctp_process_param net/sctp/sm_make_chunk.c:2524 [inline]
> 
> where 'addr' is set by sctp_v4_from_addr_param(), which doesn't initialize the
> padding of addr->v4.
> 
> later when calling sctp_make_heartbeat(), hbinfo.daddr(=transport->ipaddr)
> will become the part of skb, and the issue occurs.

Sweet.

> 
> The fix should be:
> 
> diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
> index 09050c1d5517..0e73405eba4f 100644
> --- a/net/sctp/sm_make_chunk.c
> +++ b/net/sctp/sm_make_chunk.c
> @@ -2516,6 +2516,7 @@ static int sctp_process_param(struct
> sctp_association *asoc,
>   if (ipv6_only_sock(asoc->base.sk))
>   break;
>  do_addr_param:
> + memset(&addr, 0, sizeof(addr));
>   af = sctp_get_af_specific(param_type2af(param.p->type));
>   af->from_addr_param(&addr, param.addr, htons(asoc->peer.port), 0);
>   scope = sctp_scope(peer_addr);
> @@ -3040,6 +3041,7 @@ static __be16 sctp_process_asconf_param(struct
> sctp_association *asoc,
>   if (unlikely(!af))
>   return SCTP_ERROR_DNS_FAILED;
> 
> + memset(&addr, 0, sizeof(addr));
>   af->from_addr_param(&addr, addr_param, htons(asoc->peer.port), 0);

In sctp_v4_from_addr_param() itself seems cleaner.
(Ditto for sctp_v4_to_addr_param() and related ones, like
sctp_v4_dst_saddr())

These functions shouldn't trust that the caller initializes the
memory. They are dealing with ipv4 but they know that the buffer
they are writting into is larger and the size of it.

  Marcelo
