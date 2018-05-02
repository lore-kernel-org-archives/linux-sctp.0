From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 02 May 2018 14:34:28 +0000
Subject: Re: [PATCH V2 net-next 1/6] virtio: Add support for SCTP checksum offloading
Message-Id: <20180502143428.GE5105@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <20180502020739.19239-1-vyasevic@redhat.com>
 <20180502020739.19239-2-vyasevic@redhat.com>
 <20180502061520-mutt-send-email-mst@kernel.org>
 <20180502141413.GD5105@localhost.localdomain>
 <20180502171943-mutt-send-email-mst@kernel.org>
In-Reply-To: <20180502171943-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Vladislav Yasevich <vyasevich@gmail.com>, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, virtualization@lists.linux-foundation.org, virtio-dev@lists.oasis-open.org, jasowang@redhat.com, nhorman@tuxdriver.com, Vladislav Yasevich <vyasevic@redhat.com>

On Wed, May 02, 2018 at 05:21:38PM +0300, Michael S. Tsirkin wrote:
> On Wed, May 02, 2018 at 11:14:13AM -0300, Marcelo Ricardo Leitner wrote:
> > On Wed, May 02, 2018 at 06:16:45AM +0300, Michael S. Tsirkin wrote:
> > > On Tue, May 01, 2018 at 10:07:34PM -0400, Vladislav Yasevich wrote:
> > > > To support SCTP checksum offloading, we need to add a new feature
> > > > to virtio_net, so we can negotiate support between the hypervisor
> > > > and the guest.
> > > > The HOST feature bit signifies offloading support for transmit and
> > > > enables device offload features.
> > > > The GUEST feature bit signifies offloading support of recieve and
> > > > is currently only used by the driver in case of xdp.
> > > >
> > > > That patch also adds an addition virtio_net header flag which
> > > > mirrors the skb->csum_not_inet flag.  This flags is used to indicate
> > > > that is this an SCTP packet that needs its checksum computed by the
> > > > lower layer.  In this case, the lower layer is the host hypervisor or
> > > > possibly HW nic that supporst CRC32c offload.
> > > >
> > > > In the case that GUEST feature bit is flag, it will be possible to
> > > > receive a virtio_net header with this bit set, which will set the
> > > > corresponding skb bit.  SCTP protocol will be updated to correctly
> > > > deal with it.
> > > >
> > > > Signed-off-by: Vladislav Yasevich <vyasevic@redhat.com>
> > > > ---
> > > >  drivers/net/virtio_net.c        | 14 +++++++++++++-
> > > >  include/linux/virtio_net.h      |  6 ++++++
> > > >  include/uapi/linux/virtio_net.h |  5 +++++
> > > >  3 files changed, 24 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > > index 7b187ec..34af280 100644
> > > > --- a/drivers/net/virtio_net.c
> > > > +++ b/drivers/net/virtio_net.c
> > > > @@ -2148,6 +2148,8 @@ static int virtnet_clear_guest_offloads(struct virtnet_info *vi)
> > > >
> > > >  	if (virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_CSUM))
> > > >  		offloads = 1ULL << VIRTIO_NET_F_GUEST_CSUM;
> > > > +	if (virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_SCTP_CSUM))
> > > > +		offloads |= 1ULL << VIRTIO_NET_F_GUEST_SCTP_CSUM;
> > > >
> > > >  	return virtnet_set_guest_offloads(vi, offloads);
> > > >  }
> > > > @@ -2160,6 +2162,8 @@ static int virtnet_restore_guest_offloads(struct virtnet_info *vi)
> > > >  		return 0;
> > > >  	if (virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_CSUM))
> > > >  		offloads |= 1ULL << VIRTIO_NET_F_GUEST_CSUM;
> > > > +	if (virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_SCTP_CSUM))
> > > > +		offloads |= 1ULL << VIRTIO_NET_F_GUEST_SCTP_CSUM;
> > > >
> > > >  	return virtnet_set_guest_offloads(vi, offloads);
> > > >  }
> > > > @@ -2724,6 +2728,7 @@ static int virtnet_probe(struct virtio_device *vdev)
> > > >  	/* Do we support "hardware" checksums? */
> > > >  	if (virtio_has_feature(vdev, VIRTIO_NET_F_CSUM)) {
> > > >  		/* This opens up the world of extra features. */
> > > > +
> > > >  		dev->hw_features |= NETIF_F_HW_CSUM | NETIF_F_SG;
> > > >  		if (csum)
> > > >  			dev->features |= NETIF_F_HW_CSUM | NETIF_F_SG;
> > > > @@ -2746,9 +2751,15 @@ static int virtnet_probe(struct virtio_device *vdev)
> > > >  			dev->features |= dev->hw_features & NETIF_F_ALL_TSO;
> > > >  		/* (!csum && gso) case will be fixed by register_netdev() */
> > > >  	}
> > > > +
> > > >  	if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_CSUM))
> > > >  		dev->features |= NETIF_F_RXCSUM;
> > > >
> > > > +	if (virtio_has_feature(vdev, VIRTIO_NET_F_HOST_SCTP_CSUM)) {
> > > > +		dev->hw_features |= NETIF_F_SCTP_CRC;
> > > > +		dev->features |= NETIF_F_SCTP_CRC;
> > > > +	}
> > > > +
> > > >  	dev->vlan_features = dev->features;
> > > >
> > > >  	/* MTU range: 68 - 65535 */
> > > > @@ -2962,7 +2973,8 @@ static struct virtio_device_id id_table[] = {
> > > >  	VIRTIO_NET_F_GUEST_ANNOUNCE, VIRTIO_NET_F_MQ, \
> > > >  	VIRTIO_NET_F_CTRL_MAC_ADDR, \
> > > >  	VIRTIO_NET_F_MTU, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS, \
> > > > -	VIRTIO_NET_F_SPEED_DUPLEX
> > > > +	VIRTIO_NET_F_SPEED_DUPLEX, \
> > > > +	VIRTIO_NET_F_HOST_SCTP_CSUM, VIRTIO_NET_F_GUEST_SCTP_CSUM
> > > >
> > > >  static unsigned int features[] = {
> > > >  	VIRTNET_FEATURES,
> > > > diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
> > > > index f144216..28fffdc 100644
> > > > --- a/include/linux/virtio_net.h
> > > > +++ b/include/linux/virtio_net.h
> > > > @@ -39,6 +39,9 @@ static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,
> > > >
> > > >  		if (!skb_partial_csum_set(skb, start, off))
> > > >  			return -EINVAL;
> > > > +
> > > > +		if (hdr->flags & VIRTIO_NET_HDR_F_CSUM_NOT_INET)
> > > > +			skb->csum_not_inet = 1;
> > > >  	}
> > > >
> > > >  	if (hdr->gso_type != VIRTIO_NET_HDR_GSO_NONE) {
> > > > @@ -91,6 +94,9 @@ static inline int virtio_net_hdr_from_skb(const struct sk_buff *skb,
> > > >  				skb_checksum_start_offset(skb));
> > > >  		hdr->csum_offset = __cpu_to_virtio16(little_endian,
> > > >  				skb->csum_offset);
> > > > +
> > > > +		if (skb->csum_not_inet)
> > > > +			hdr->flags |= VIRTIO_NET_HDR_F_CSUM_NOT_INET;
> > > >  	} else if (has_data_valid &&
> > > >  		   skb->ip_summed = CHECKSUM_UNNECESSARY) {
> > > >  		hdr->flags = VIRTIO_NET_HDR_F_DATA_VALID;
> > > > diff --git a/include/uapi/linux/virtio_net.h b/include/uapi/linux/virtio_net.h
> > > > index 5de6ed3..9dfca1a 100644
> > > > --- a/include/uapi/linux/virtio_net.h
> > > > +++ b/include/uapi/linux/virtio_net.h
> > > > @@ -57,6 +57,10 @@
> > > >  					 * Steering */
> > > >  #define VIRTIO_NET_F_CTRL_MAC_ADDR 23	/* Set MAC address */
> > > >
> > > > +#define VIRTIO_NET_F_GUEST_SCTP_CSUM  61 /* Guest handles SCTP pks w/ partial
> > > > +					  * csum */
> > > > +#define VIRTIO_NET_F_HOST_SCTP_CSUM   62 /* HOST handles SCTP pkts w/ partial
> > > > +					  * csum */
> > > >  #define VIRTIO_NET_F_SPEED_DUPLEX 63	/* Device set linkspeed and duplex */
> > > >
> > > >  #ifndef VIRTIO_NET_NO_LEGACY
> > > > @@ -101,6 +105,7 @@ struct virtio_net_config {
> > > >  struct virtio_net_hdr_v1 {
> > > >  #define VIRTIO_NET_HDR_F_NEEDS_CSUM	1	/* Use csum_start, csum_offset */
> > > >  #define VIRTIO_NET_HDR_F_DATA_VALID	2	/* Csum is valid */
> > > > +#define VIRTIO_NET_HDR_F_CSUM_NOT_INET  4       /* Checksum is not inet */
> > >
> > > Both comment and name are not very informative.
> > > How about just saying CRC32c ?
> >
> > csum_not_inet is following the nomenclature used in sk_buff. Initially
> > Davide had named the sk_buff field after crc32c but then it was argued
> > that maybe another check method may be introduced later and the name
> > would be bogus, thus why the "csum_not_inet".
>
> That's sk_buff internals, since Linux can change these
> at any time without breaking anything.
>
> virtio defines an ABI so we won't be able to make it
> mean something else, need to document it fully.
> "Go read linux net core code" is not a good answer
> to the natural question "what does this bit in the
> interface do".

Fair enough, but as I just said that is exactly why it was named
'csum_not_inet' in the first place, so that it wouldn't have to change
if another method needs to be added.

But I guess your main point is that virtio can have a cleaner ABI and
skip this csum_not_inet case (which is only there because sk_buff
doesn't have as many bits as we would want), right?

>
> > >
> > > >  	__u8 flags;
> > > >  #define VIRTIO_NET_HDR_GSO_NONE		0	/* Not a GSO frame */
> > > >  #define VIRTIO_NET_HDR_GSO_TCPV4	1	/* GSO frame, IPv4 TCP (TSO) */
> > > > --
> > > > 2.9.5
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
