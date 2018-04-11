From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 11 Apr 2018 22:39:42 +0000
Subject: Re: [PATCH net-next 1/5] virtio: Add support for SCTP checksum offloading
Message-Id: <20180411223942.GB3710@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <20180402134006.10111-1-vyasevic@redhat.com>
 <20180402134006.10111-2-vyasevic@redhat.com>
In-Reply-To: <20180402134006.10111-2-vyasevic@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladislav Yasevich <vyasevich@gmail.com>
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, virtualization@lists.linux-foundation.org, mst@redhat.com, jasowang@redhat.com, nhorman@tuxdriver.com, Vladislav Yasevich <vyasevic@redhat.com>

On Mon, Apr 02, 2018 at 09:40:02AM -0400, Vladislav Yasevich wrote:
> To support SCTP checksum offloading, we need to add a new feature
> to virtio_net, so we can negotiate support between the hypervisor
> and the guest.
>
> The signalling to the guest that an alternate checksum needs to
> be used is done via a new flag in the virtio_net_hdr.  If the
> flag is set, the host will know to perform an alternate checksum
> calculation, which right now is only CRC32c.
>
> Signed-off-by: Vladislav Yasevich <vyasevic@redhat.com>
> ---
>  drivers/net/virtio_net.c        | 11 ++++++++---
>  include/linux/virtio_net.h      |  6 ++++++
>  include/uapi/linux/virtio_net.h |  2 ++
>  3 files changed, 16 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 7b187ec..b601294 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -2724,9 +2724,14 @@ static int virtnet_probe(struct virtio_device *vdev)
>  	/* Do we support "hardware" checksums? */
>  	if (virtio_has_feature(vdev, VIRTIO_NET_F_CSUM)) {
>  		/* This opens up the world of extra features. */
> -		dev->hw_features |= NETIF_F_HW_CSUM | NETIF_F_SG;
> +		netdev_features_t sctp = 0;
> +
> +		if (virtio_has_feature(vdev, VIRTIO_NET_F_SCTP_CSUM))
> +			sctp |= NETIF_F_SCTP_CRC;
> +
> +		dev->hw_features |= NETIF_F_HW_CSUM | NETIF_F_SG | sctp;
>  		if (csum)
> -			dev->features |= NETIF_F_HW_CSUM | NETIF_F_SG;
> +			dev->features |= NETIF_F_HW_CSUM | NETIF_F_SG | sctp;
>
>  		if (virtio_has_feature(vdev, VIRTIO_NET_F_GSO)) {
>  			dev->hw_features |= NETIF_F_TSO
> @@ -2952,7 +2957,7 @@ static struct virtio_device_id id_table[] = {
>  };
>
>  #define VIRTNET_FEATURES \
> -	VIRTIO_NET_F_CSUM, VIRTIO_NET_F_GUEST_CSUM, \
> +	VIRTIO_NET_F_CSUM, VIRTIO_NET_F_GUEST_CSUM,  VIRTIO_NET_F_SCTP_CSUM, \
>  	VIRTIO_NET_F_MAC, \
>  	VIRTIO_NET_F_HOST_TSO4, VIRTIO_NET_F_HOST_UFO, VIRTIO_NET_F_HOST_TSO6, \
>  	VIRTIO_NET_F_HOST_ECN, VIRTIO_NET_F_GUEST_TSO4, VIRTIO_NET_F_GUEST_TSO6, \
> diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
> index f144216..2e7a64a 100644
> --- a/include/linux/virtio_net.h
> +++ b/include/linux/virtio_net.h
> @@ -39,6 +39,9 @@ static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,
>
>  		if (!skb_partial_csum_set(skb, start, off))
>  			return -EINVAL;
> +
> +		if (hdr->flags & VIRTIO_NET_HDR_F_CSUM_NOT_INET)
> +			skb->csum_not_inet = 1;
>  	}
>
>  	if (hdr->gso_type != VIRTIO_NET_HDR_GSO_NONE) {
> @@ -96,6 +99,9 @@ static inline int virtio_net_hdr_from_skb(const struct sk_buff *skb,
>  		hdr->flags = VIRTIO_NET_HDR_F_DATA_VALID;
>  	} /* else everything is zero */
>
> +	if (skb->csum_not_inet)
> +		hdr->flags &= VIRTIO_NET_HDR_F_CSUM_NOT_INET;
        Shouldn't this be  |=  instead?

> +
>  	return 0;
>  }
>
> diff --git a/include/uapi/linux/virtio_net.h b/include/uapi/linux/virtio_net.h
> index 5de6ed3..3f279c8 100644
> --- a/include/uapi/linux/virtio_net.h
> +++ b/include/uapi/linux/virtio_net.h
> @@ -36,6 +36,7 @@
>  #define VIRTIO_NET_F_GUEST_CSUM	1	/* Guest handles pkts w/ partial csum */
>  #define VIRTIO_NET_F_CTRL_GUEST_OFFLOADS 2 /* Dynamic offload configuration. */
>  #define VIRTIO_NET_F_MTU	3	/* Initial MTU advice */
> +#define VIRTIO_NET_F_SCTP_CSUM  4	/* SCTP checksum offload support */
>  #define VIRTIO_NET_F_MAC	5	/* Host has given MAC address. */
>  #define VIRTIO_NET_F_GUEST_TSO4	7	/* Guest can handle TSOv4 in. */
>  #define VIRTIO_NET_F_GUEST_TSO6	8	/* Guest can handle TSOv6 in. */
> @@ -101,6 +102,7 @@ struct virtio_net_config {
>  struct virtio_net_hdr_v1 {
>  #define VIRTIO_NET_HDR_F_NEEDS_CSUM	1	/* Use csum_start, csum_offset */
>  #define VIRTIO_NET_HDR_F_DATA_VALID	2	/* Csum is valid */
> +#define VIRTIO_NET_HDR_F_CSUM_NOT_INET  4       /* Checksum is not inet */
>  	__u8 flags;
>  #define VIRTIO_NET_HDR_GSO_NONE		0	/* Not a GSO frame */
>  #define VIRTIO_NET_HDR_GSO_TCPV4	1	/* GSO frame, IPv4 TCP (TSO) */
> --
> 2.9.5
>
