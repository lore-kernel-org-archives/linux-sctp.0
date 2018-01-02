From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date: Tue, 02 Jan 2018 17:23:27 +0000
Subject: Re: general protection fault in skb_segment
Message-Id: <CAF=yD-JLXo9T4XwnJZ6MqeQas5QM4qNTOic9jb3ZNHdeJPTfmA@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <001a1137452496ffc305617e5fe0@google.com> <CAF=yD-+Ynn+t0dPJXUrXKQ2XMdtiKz8t6PKJUMNqeydYv=yG9A@mail.gmail.com>
 <20171231005220.GD22042@localhost.localdomain> <CAF=yD-+KwmB+fX+4A1RiCV6ZCDQbkGGSVu8YVMrAGxfVtG7ndQ@mail.gmail.com>
 <CAF=yD-K9M1yps+SogVLSVgoi+ngKzKrwWH+xMr4-m+v-pqyXXQ@mail.gmail.com>
In-Reply-To: <CAF=yD-K9M1yps+SogVLSVgoi+ngKzKrwWH+xMr4-m+v-pqyXXQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: syzbot <syzbot+fee64147a25aecd48055@syzkaller.appspotmail.com>, David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>, linux-sctp@vger.kernel.org, Network Development <netdev@vger.kernel.org>, Neil Horman <nhorman@tuxdriver.com>, syzkaller-bugs@googlegroups.com, Vladislav Yasevich <vyasevich@gmail.com>

> Actually, changes just to inet_gso_segment and ipv6_gso_segment
> will suffice:
>
>        bool udpfrag = false, fixedid = false, gso_partial, encap;
>         struct sk_buff *segs = ERR_PTR(-EINVAL);
> +       unsigned int offset = 0, gso_type;
>         const struct net_offload *ops;
> -       unsigned int offset = 0;
>         struct iphdr *iph;
>         int proto, tot_len;
>         int nhoff;
> @@ -1258,6 +1258,22 @@ struct sk_buff *inet_gso_segment(struct sk_buff *skb,
>
>         skb_reset_transport_header(skb);
>
> +       gso_type = skb_shinfo(skb)->gso_type;
> +       if (gso_type & SKB_GSO_DODGY) {
> +               switch (gso_type & (SKB_GSO_TCPV4 | SKB_GSO_UDP)) {
> +               case SKB_GSO_TCPV4:
> +                       if (proto != IPPROTO_TCP)
> +                               goto out;
> +                       break;
> +               case SKB_GSO_UDP:
> +                       if (proto != IPPROTO_UDP)
> +                               goto out;
> +                       break;
> +               default:
> +                       goto out;
> +               }
> +       }
>
> and analogous for IPv6. For a real patch I would deduplicate this
> logic between them and move it to a separate helper function
> (in a header file, then).

This approach would also need an skb->protocol check either in
virtio_net_hdr_to_skb or skb_mac_gso_segment.
