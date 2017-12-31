From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date: Sun, 31 Dec 2017 09:52:14 +0000
Subject: Re: general protection fault in skb_segment
Message-Id: <CAF=yD-+KwmB+fX+4A1RiCV6ZCDQbkGGSVu8YVMrAGxfVtG7ndQ@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <001a1137452496ffc305617e5fe0@google.com> <CAF=yD-+Ynn+t0dPJXUrXKQ2XMdtiKz8t6PKJUMNqeydYv=yG9A@mail.gmail.com>
 <20171231005220.GD22042@localhost.localdomain>
In-Reply-To: <20171231005220.GD22042@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: syzbot <syzbot+fee64147a25aecd48055@syzkaller.appspotmail.com>, David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>, linux-sctp@vger.kernel.org, Network Development <netdev@vger.kernel.org>, Neil Horman <nhorman@tuxdriver.com>, syzkaller-bugs@googlegroups.com, Vladislav Yasevich <vyasevich@gmail.com>

> It seems virtio_net could use more sanity checks. When PACKET_VNET_HDR
> is used, it will end up calling:
> tpacket_rcv() {
> ...
>         if (do_vnet) {
>                 if (virtio_net_hdr_from_skb(skb, h.raw + macoff -
>                                             sizeof(struct virtio_net_hdr),
>                                             vio_le(), true)) {
>                         spin_lock(&sk->sk_receive_queue.lock);
>                         goto drop_n_account;
>                 }
>         }
>
> and virtio_net_hdr_from_skb does:
>         if (skb_is_gso(skb)) {
> ...
>                 if (sinfo->gso_type & SKB_GSO_TCPV4)
>                         hdr->gso_type = VIRTIO_NET_HDR_GSO_TCPV4;
>                 else if (sinfo->gso_type & SKB_GSO_TCPV6)
>                         hdr->gso_type = VIRTIO_NET_HDR_GSO_TCPV6;
>                 else
>                         return -EINVAL;

That is the receive path, but the send path is analogous. Just adds
UFO.

> Meaning that any gso_type other than TCP would be rejected, but this
> SCTP one got through. Seems the header contains a sctp header, but the
> gso_type set was actually pointing to TCP (otherwise it would have
> been rejected). AFAICT if this packet had an ESP header, for example,
> it could have hit esp4_gso_segment. Can you please confirm this?

I have not tested this yet, but it certainly seems plausible.

There is nothing ensuring consistency between gso_type and
the actual packet contents that are parsed to look up gso callbacks.

> I don't know of anywhere in the stack validating if the gso_type
> matches the header that actually is in there.
>
> The fix you mentioned is a good start, we want that one way or
> another, but I'm afraid this bug is bigger than sctp.

Good point. Packet sockets require CAP_NET_RAW, but this is also
taken for virtio, so we probably want more stringent entry tests here.

The alternative to harden the segmentation code itself with a gso_type
sanity check in every gso callback is more work and fragile.

Need to figure out whether a brief check for just TCP or UDP is sufficient
or we need a full flow dissector step to support tunnel headers and such.
