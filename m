From: Xin Long <lucien.xin@gmail.com>
Date: Sun, 31 Dec 2017 08:41:01 +0000
Subject: Re: general protection fault in skb_segment
Message-Id: <CADvbK_d0_486KX-wtfQa=0aVGv0mtaFs4JeMTbv6n+aMWqU3hg@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <001a1137452496ffc305617e5fe0@google.com> <CAF=yD-+Ynn+t0dPJXUrXKQ2XMdtiKz8t6PKJUMNqeydYv=yG9A@mail.gmail.com>
 <20171231005220.GD22042@localhost.localdomain> <20171231022524.GE22042@localhost.localdomain>
In-Reply-To: <20171231022524.GE22042@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>, syzbot <syzbot+fee64147a25aecd48055@syzkaller.appspotmail.com>, David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>, linux-sctp@vger.kernel.org, Network Development <netdev@vger.kernel.org>, Neil Horman <nhorman@tuxdriver.com>, syzkaller-bugs@googlegroups.com, Vlad Yasevich <vyasevich@gmail.com>

On Sun, Dec 31, 2017 at 10:25 AM, Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
> On Sat, Dec 30, 2017 at 10:52:20PM -0200, Marcelo Ricardo Leitner wrote:
>> On Sat, Dec 30, 2017 at 08:42:41AM +0100, Willem de Bruijn wrote:
> [...]
>> > Somewhat tangential, but any PF_PACKET socket can set this
>> > magic gso_size value in its virtio_net_hdr, so if it is assumed to
>> > be an SCTP GSO specific option, setting it for a TCP GSO packet
>> > may also cause unexpected results.
>>
>> It seems virtio_net could use more sanity checks. When PACKET_VNET_HDR
>> is used, it will end up calling:
>> tpacket_rcv() {
>> ...
>>         if (do_vnet) {
>>                 if (virtio_net_hdr_from_skb(skb, h.raw + macoff -
>>                                             sizeof(struct virtio_net_hdr),
>>                                             vio_le(), true)) {
>>                         spin_lock(&sk->sk_receive_queue.lock);
>>                         goto drop_n_account;
>>                 }
>>         }
>>
>> and virtio_net_hdr_from_skb does:
>>         if (skb_is_gso(skb)) {
>> ...
>>                 if (sinfo->gso_type & SKB_GSO_TCPV4)
>>                         hdr->gso_type = VIRTIO_NET_HDR_GSO_TCPV4;
>>                 else if (sinfo->gso_type & SKB_GSO_TCPV6)
>>                         hdr->gso_type = VIRTIO_NET_HDR_GSO_TCPV6;
>>                 else
>>                         return -EINVAL;
>>
>> Meaning that any gso_type other than TCP would be rejected, but this
>> SCTP one got through. Seems the header contains a sctp header, but the
>> gso_type set was actually pointing to TCP (otherwise it would have
>> been rejected). AFAICT if this packet had an ESP header, for example,
>> it could have hit esp4_gso_segment. Can you please confirm this?
>
> I added:
> --- a/net/sctp/offload.c
> +++ b/net/sctp/offload.c
> @@ -44,6 +44,18 @@ static struct sk_buff *sctp_gso_segment(struct sk_buff *skb,
>  {
>         struct sk_buff *segs = ERR_PTR(-EINVAL);
>         struct sctphdr *sh;
> +       int fail = 0;
> +
> +       if (!(skb_shinfo(skb)->gso_type & SKB_GSO_SCTP)) {
> +               printk("Bogus gso_type: %x\n", skb_shinfo(skb)->gso_type);
> +               fail = 1;
> +       }
> +       if (skb_shinfo(skb)->gso_size != GSO_BY_FRAGS) {
> +               printk("Bogus gso_size: %u\n", skb_shinfo(skb)->gso_size);
> +               fail = 1;
> +       }
> +       if (fail)
> +               goto out;
>
>         sh = sctp_hdr(skb);
>         if (!pskb_may_pull(skb, sizeof(*sh)))
>

> and with the reproducer, got:
> [   54.255469] Bogus gso_type: 7
> [   54.258801] Bogus gso_size: 63464
> [   54.262532] ------------[ cut here ]------------
> [   54.267703] syz0: caps=(0x00000800000058c1, 0x0000000000000000) len2 data_len=0 gso_sizec464 gso_type=7 ip_summed0
> [   54.279777] WARNING: CPU: 1 PID: 13005 at /root/linux/net/core/dev.c:2600 skb_warn_bad_offload+0xd6/0xec
I couldn't reproduce this call trace on net-next, maybe it's been fixed by:
commit 8d74e9f88d65af8bb2e095aff506aa6eac755ada
Author: Willem de Bruijn <willemb@google.com>
Date:   Tue Dec 12 11:39:04 2017 -0500

    net: avoid skb_warn_bad_offload on IS_ERR
