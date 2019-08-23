From: Edward Cree <ecree@solarflare.com>
Date: Fri, 23 Aug 2019 12:07:55 +0000
Subject: Re: [PATCH net-next] net: ipv6: fix listify ip6_rcv_finish in case of forwarding
Message-Id: <5b2e79d5-57af-e340-c629-fc6b55a7a61a@solarflare.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <e355527b374f6ce70fcc286457f87592cd8f3dcc.1566559983.git.lucien.xin@gmail.com>
In-Reply-To: <e355527b374f6ce70fcc286457f87592cd8f3dcc.1566559983.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>, network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net, Jesper Dangaard Brouer <brouer@redhat.com>, Dmitry Vyukov <dvyukov@google.com>, syzkaller-bugs@googlegroups.com

On 23/08/2019 12:33, Xin Long wrote:
> We need a similar fix for ipv6 as Commit 0761680d5215 ("net: ipv4: fix
> listify ip_rcv_finish in case of forwarding") does for ipv4.
>
> This issue can be reprocuded by syzbot since Commit 323ebb61e32b ("net:
> use listified RX for handling GRO_NORMAL skbs") on net-next. The call
> trace was:
>
>   kernel BUG at include/linux/skbuff.h:2225!
>   RIP: 0010:__skb_pull include/linux/skbuff.h:2225 [inline]
>   RIP: 0010:skb_pull+0xea/0x110 net/core/skbuff.c:1902
>   Call Trace:
>     sctp_inq_pop+0x2f1/0xd80 net/sctp/inqueue.c:202
>     sctp_endpoint_bh_rcv+0x184/0x8d0 net/sctp/endpointola.c:385
>     sctp_inq_push+0x1e4/0x280 net/sctp/inqueue.c:80
>     sctp_rcv+0x2807/0x3590 net/sctp/input.c:256
>     sctp6_rcv+0x17/0x30 net/sctp/ipv6.c:1049
>     ip6_protocol_deliver_rcu+0x2fe/0x1660 net/ipv6/ip6_input.c:397
>     ip6_input_finish+0x84/0x170 net/ipv6/ip6_input.c:438
>     NF_HOOK include/linux/netfilter.h:305 [inline]
>     NF_HOOK include/linux/netfilter.h:299 [inline]
>     ip6_input+0xe4/0x3f0 net/ipv6/ip6_input.c:447
>     dst_input include/net/dst.h:442 [inline]
>     ip6_sublist_rcv_finish+0x98/0x1e0 net/ipv6/ip6_input.c:84
>     ip6_list_rcv_finish net/ipv6/ip6_input.c:118 [inline]
>     ip6_sublist_rcv+0x80c/0xcf0 net/ipv6/ip6_input.c:282
>     ipv6_list_rcv+0x373/0x4b0 net/ipv6/ip6_input.c:316
>     __netif_receive_skb_list_ptype net/core/dev.c:5049 [inline]
>     __netif_receive_skb_list_core+0x5fc/0x9d0 net/core/dev.c:5097
>     __netif_receive_skb_list net/core/dev.c:5149 [inline]
>     netif_receive_skb_list_internal+0x7eb/0xe60 net/core/dev.c:5244
>     gro_normal_list.part.0+0x1e/0xb0 net/core/dev.c:5757
>     gro_normal_list net/core/dev.c:5755 [inline]
>     gro_normal_one net/core/dev.c:5769 [inline]
>     napi_frags_finish net/core/dev.c:5782 [inline]
>     napi_gro_frags+0xa6a/0xea0 net/core/dev.c:5855
>     tun_get_user+0x2e98/0x3fa0 drivers/net/tun.c:1974
>     tun_chr_write_iter+0xbd/0x156 drivers/net/tun.c:2020
>
> Fixes: d8269e2cbf90 ("net: ipv6: listify ipv6_rcv() and ip6_rcv_finish()")
> Fixes: 323ebb61e32b ("net: use listified RX for handling GRO_NORMAL skbs")
> Reported-by: syzbot+eb349eeee854e389c36d@syzkaller.appspotmail.com
> Reported-by: syzbot+4a0643a653ac375612d1@syzkaller.appspotmail.com
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Edward Cree <ecree@solarflare.com>
Thanks for catching this.
> ---
>  net/ipv6/ip6_input.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
> index fa014d5..d432d00 100644
> --- a/net/ipv6/ip6_input.c
> +++ b/net/ipv6/ip6_input.c
> @@ -80,8 +80,10 @@ static void ip6_sublist_rcv_finish(struct list_head *head)
>  {
>  	struct sk_buff *skb, *next;
>  
> -	list_for_each_entry_safe(skb, next, head, list)
> +	list_for_each_entry_safe(skb, next, head, list) {
> +		skb_list_del_init(skb);
>  		dst_input(skb);
> +	}
>  }
>  
>  static void ip6_list_rcv_finish(struct net *net, struct sock *sk,
