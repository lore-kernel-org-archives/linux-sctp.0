From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date: Tue, 02 Jan 2018 15:48:17 +0000
Subject: Re: general protection fault in skb_segment
Message-Id: <CAF=yD-K9M1yps+SogVLSVgoi+ngKzKrwWH+xMr4-m+v-pqyXXQ@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <001a1137452496ffc305617e5fe0@google.com> <CAF=yD-+Ynn+t0dPJXUrXKQ2XMdtiKz8t6PKJUMNqeydYv=yG9A@mail.gmail.com>
 <20171231005220.GD22042@localhost.localdomain> <CAF=yD-+KwmB+fX+4A1RiCV6ZCDQbkGGSVu8YVMrAGxfVtG7ndQ@mail.gmail.com>
In-Reply-To: <CAF=yD-+KwmB+fX+4A1RiCV6ZCDQbkGGSVu8YVMrAGxfVtG7ndQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: syzbot <syzbot+fee64147a25aecd48055@syzkaller.appspotmail.com>, David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>, linux-sctp@vger.kernel.org, Network Development <netdev@vger.kernel.org>, Neil Horman <nhorman@tuxdriver.com>, syzkaller-bugs@googlegroups.com, Vladislav Yasevich <vyasevich@gmail.com>

> Good point. Packet sockets require CAP_NET_RAW, but this is also
> taken for virtio, so we probably want more stringent entry tests here.

That would be something like

 #include <linux/if_vlan.h>
+#include <linux/skbuff.h>
 #include <uapi/linux/virtio_net.h>
+#include <net/flow_dissector.h>

 static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,
                                        const struct virtio_net_hdr *hdr,
@@ -12,14 +14,27 @@ static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,
        unsigned int gso_type = 0;

        if (hdr->gso_type != VIRTIO_NET_HDR_GSO_NONE) {
+               struct flow_keys flow = { .basic = {0} };
+
+               if (!skb_flow_dissect(skb, &flow_keys_buf_dissector, &flow, 0))
+                       return -EINVAL;
+
                switch (hdr->gso_type & ~VIRTIO_NET_HDR_GSO_ECN) {
                case VIRTIO_NET_HDR_GSO_TCPV4:
+                       if (flow.basic.n_proto != htons(ETH_P_IP) ||
+                           flow.basic.ip_proto != IPPROTO_TCP)
+                               return -EINVAL;
                        gso_type = SKB_GSO_TCPV4;
                        break;
                case VIRTIO_NET_HDR_GSO_TCPV6:
+                       if (flow.basic.n_proto != htons(ETH_P_IPV6) ||
+                           flow.basic.ip_proto != IPPROTO_TCP)
+                               return -EINVAL;
                        gso_type = SKB_GSO_TCPV6;
                        break;
                case VIRTIO_NET_HDR_GSO_UDP:
+                       if (flow.basic.ip_proto != IPPROTO_UDP)
+                               return -EINVAL;
                        gso_type = SKB_GSO_UDP;
                        break;
                default:

but I think we can block these packets without adding a flow dissector
call for each untrusted packet (SKB_GSO_DODGY).

> The alternative to harden the segmentation code itself with a gso_type
> sanity check in every gso callback is more work and fragile.

Actually, changes just to inet_gso_segment and ipv6_gso_segment
will suffice:

       bool udpfrag = false, fixedid = false, gso_partial, encap;
        struct sk_buff *segs = ERR_PTR(-EINVAL);
+       unsigned int offset = 0, gso_type;
        const struct net_offload *ops;
-       unsigned int offset = 0;
        struct iphdr *iph;
        int proto, tot_len;
        int nhoff;
@@ -1258,6 +1258,22 @@ struct sk_buff *inet_gso_segment(struct sk_buff *skb,

        skb_reset_transport_header(skb);

+       gso_type = skb_shinfo(skb)->gso_type;
+       if (gso_type & SKB_GSO_DODGY) {
+               switch (gso_type & (SKB_GSO_TCPV4 | SKB_GSO_UDP)) {
+               case SKB_GSO_TCPV4:
+                       if (proto != IPPROTO_TCP)
+                               goto out;
+                       break;
+               case SKB_GSO_UDP:
+                       if (proto != IPPROTO_UDP)
+                               goto out;
+                       break;
+               default:
+                       goto out;
+               }
+       }

and analogous for IPv6. For a real patch I would deduplicate this
logic between them and move it to a separate helper function
(in a header file, then).
