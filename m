From: Guillaume Nault <g.nault@alphalink.fr>
Date: Fri, 19 Jan 2018 17:19:00 +0000
Subject: Re: kernel BUG at net/core/skbuff.c:LINE! (2)
Message-Id: <20180119171900.GO1422@alphalink.fr>
List-Id: <linux-sctp.vger.kernel.org>
References: <001a1149c712d56ccc055cc48e37@google.com>
 <001a113f6a6aea72c00562d65d39@google.com>
 <CADvbK_f8KVdqWMoFmhOxMxGD8OM5XxoCzMSiyxDv2d+F8sTa_w@mail.gmail.com>
In-Reply-To: <CADvbK_f8KVdqWMoFmhOxMxGD8OM5XxoCzMSiyxDv2d+F8sTa_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: syzbot <syzbot+ed0838d0fa4c4f2b528e20286e6dc63effc7c14d@syzkaller.appspotmail.com>, davem <davem@davemloft.net>, Eric Dumazet <eric.dumazet@gmail.com>, kuznet <kuznet@ms2.inr.ac.ru>, LKML <linux-kernel@vger.kernel.org>, linux-sctp@vger.kernel.org, network dev <netdev@vger.kernel.org>, Neil Horman <nhorman@tuxdriver.com>, syzkaller-bugs@googlegroups.com, Vlad Yasevich <vyasevich@gmail.com>, =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>, yoshfuji <yoshfuji@linux-ipv6.org>

On Tue, Jan 16, 2018 at 04:21:40PM +0800, Xin Long wrote:
> ipv4 tunnels don't  really set dev->hard_header_len properly,
> we may should fix it in pppoe by using needed_headroom,
> as what it doesn't in arp_create.
> 
I'm a bit in doubt about which device needs to be fixed. Should ip_gre
set ->hard_header_len? Or should pppoe take ->needed_headroom into
account in skb_reserve()? I'd favor the later option too, but I haven't
figured out the semantic of these fields precisely enough to justify
this choice.

> @@ -860,16 +861,16 @@ static int pppoe_sendmsg(struct socket *sock,
> struct msghdr *m,
>         if (total_len > (dev->mtu + dev->hard_header_len))
>                 goto end;
> 
> +       rlen = LL_RESERVED_SPACE(dev) + dev->needed_tailroom;
> 
> -       skb = sock_wmalloc(sk, total_len + dev->hard_header_len + 32,
> -                          0, GFP_KERNEL);
> +       skb = sock_wmalloc(sk, total_len + rlen + 32, 0, GFP_KERNEL);
>         if (!skb) {
>                 error = -ENOMEM;
>                 goto end;
>         }
> 
>         /* Reserve space for headers. */
> -       skb_reserve(skb, dev->hard_header_len);
> +       skb_reserve(skb, rlen);
Any reason why you include dev->needed_tailroom in skb_reserve()?
BTW, we also have to fix __pppoe_xmit.

What about this patch?


---- >8 ----
diff --git a/drivers/net/ppp/pppoe.c b/drivers/net/ppp/pppoe.c
index 4e1da1645b15..42518af53332 100644
--- a/drivers/net/ppp/pppoe.c
+++ b/drivers/net/ppp/pppoe.c
@@ -842,6 +842,7 @@ static int pppoe_sendmsg(struct socket *sock, struct msghdr *m,
 	struct pppoe_hdr *ph;
 	struct net_device *dev;
 	char *start;
+	int hlen;
 
 	lock_sock(sk);
 	if (sock_flag(sk, SOCK_DEAD) || !(sk->sk_state & PPPOX_CONNECTED)) {
@@ -860,16 +861,16 @@ static int pppoe_sendmsg(struct socket *sock, struct msghdr *m,
 	if (total_len > (dev->mtu + dev->hard_header_len))
 		goto end;
 
-
-	skb = sock_wmalloc(sk, total_len + dev->hard_header_len + 32,
-			   0, GFP_KERNEL);
+	hlen = LL_RESERVED_SPACE(dev);
+	skb = sock_wmalloc(sk, hlen + sizeof(struct pppoe_hdr) + total_len +
+			   dev->needed_tailroom, 0, GFP_KERNEL);
 	if (!skb) {
 		error = -ENOMEM;
 		goto end;
 	}
 
 	/* Reserve space for headers. */
-	skb_reserve(skb, dev->hard_header_len);
+	skb_reserve(skb, hlen);
 	skb_reset_network_header(skb);
 
 	skb->dev = dev;
@@ -930,7 +931,7 @@ static int __pppoe_xmit(struct sock *sk, struct sk_buff *skb)
 	/* Copy the data if there is no space for the header or if it's
 	 * read-only.
 	 */
-	if (skb_cow_head(skb, sizeof(*ph) + dev->hard_header_len))
+	if (skb_cow_head(skb, LL_RESERVED_SPACE(dev) + sizeof(*ph)))
 		goto abort;
 
 	__skb_push(skb, sizeof(*ph));
