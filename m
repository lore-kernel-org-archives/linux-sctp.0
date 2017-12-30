From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date: Sat, 30 Dec 2017 11:54:54 +0000
Subject: Re: general protection fault in skb_segment
Message-Id: <CAF=yD-KM9ZmHdMrQXr9x5FM4T7xuYYhGL2xnHfNFaaKbaJCohw@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <001a1137452496ffc305617e5fe0@google.com> <CAF=yD-+Ynn+t0dPJXUrXKQ2XMdtiKz8t6PKJUMNqeydYv=yG9A@mail.gmail.com>
In-Reply-To: <CAF=yD-+Ynn+t0dPJXUrXKQ2XMdtiKz8t6PKJUMNqeydYv=yG9A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: syzbot <syzbot+fee64147a25aecd48055@syzkaller.appspotmail.com>
Cc: David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>, linux-sctp@vger.kernel.org, Network Development <netdev@vger.kernel.org>, nhorman@tuxdriver.com, syzkaller-bugs@googlegroups.com, Vladislav Yasevich <vyasevich@gmail.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

> So this is a packet socket writing something that apparently looks
> like an SCTP packet, is only 42 bytes long, but has GSO set in its
> virtio_net_hdr struct.
>
> It crashes in skb_segment seemingly on a NULL list_skb.
>
> (gdb) list *(skb_segment+0x2a4)
> 0xffffffff8167cc24 is in skb_segment (net/core/skbuff.c:3566).
> 3561                    if (hsize < 0)
> 3562                            hsize = 0;
> 3563                    if (hsize > len || !sg)
> 3564                            hsize = len;
> 3565
> 3566                    if (!hsize && i >= nfrags && skb_headlen(list_skb) &&
> 3567                        (skb_headlen(list_skb) = len || sg)) {
> 3568                            BUG_ON(skb_headlen(list_skb) > len);
> 3569
> 3570                            i = 0;

It appears to be a packet that consists only of an sctp header.
sctp_gso_segment pulls the header before calling skb_segment,
after which hsize = skb_headlen(head_skb) = 0 and nfrags = 0.

This check avoids the crash, but still triggers an skb_warn_bad_offload
on return in __skb_gso_segment

@@ -45,6 +45,13 @@ static struct sk_buff *sctp_gso_segment(struct sk_buff *skb,
        struct sk_buff *segs = ERR_PTR(-EINVAL);
        struct sctphdr *sh;

+       if (!skb_has_frag_list(skb))
+               goto out;

A gso packet shorter than mss should perhaps just be dropped. The stack
does not generate these. tcp_gso_segment does have a test

       if (unlikely(skb->len <= mss))
                goto out;

but as mss is derived from gso_size, which a packet socket controls, this
may not be sufficient for this purpose.
