From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Mon, 16 Apr 2018 17:14:33 +0000
Subject: Re: [PATCH net-next 5/5] macvlan/macvtap: Add support for SCTP checksum offload.
Message-Id: <20180416201234-mutt-send-email-mst@kernel.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <20180402134006.10111-1-vyasevic@redhat.com>
 <20180402134006.10111-6-vyasevic@redhat.com>
In-Reply-To: <20180402134006.10111-6-vyasevic@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladislav Yasevich <vyasevich@gmail.com>
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, virtualization@lists.linux-foundation.org, jasowang@redhat.com, nhorman@tuxdriver.com, Vladislav Yasevich <vyasevic@redhat.com>

On Mon, Apr 02, 2018 at 09:40:06AM -0400, Vladislav Yasevich wrote:
> Since we now have support for software CRC32c offload, turn it on
> for macvlan and macvtap devices so that guests can take advantage
> of offload SCTP checksums to the host or host hardware.
> 
> Signed-off-by: Vladislav Yasevich <vyasevic@redhat.com>
> ---
>  drivers/net/macvlan.c       | 5 +++--
>  drivers/net/tap.c           | 8 +++++---
>  include/uapi/linux/if_tun.h | 1 +
>  3 files changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
> index 725f4b4..646b730 100644
> --- a/drivers/net/macvlan.c
> +++ b/drivers/net/macvlan.c
> @@ -834,7 +834,7 @@ static struct lock_class_key macvlan_netdev_addr_lock_key;
>  
>  #define ALWAYS_ON_OFFLOADS \
>  	(NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_GSO_SOFTWARE | \
> -	 NETIF_F_GSO_ROBUST | NETIF_F_GSO_ENCAP_ALL)
> +	 NETIF_F_GSO_ROBUST | NETIF_F_GSO_ENCAP_ALL | NETIF_F_SCTP_CRC)
>  
>  #define ALWAYS_ON_FEATURES (ALWAYS_ON_OFFLOADS | NETIF_F_LLTX)
>  
> @@ -842,7 +842,8 @@ static struct lock_class_key macvlan_netdev_addr_lock_key;
>  	(NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_HIGHDMA | NETIF_F_FRAGLIST | \
>  	 NETIF_F_GSO | NETIF_F_TSO | NETIF_F_LRO | \
>  	 NETIF_F_TSO_ECN | NETIF_F_TSO6 | NETIF_F_GRO | NETIF_F_RXCSUM | \
> -	 NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_HW_VLAN_STAG_FILTER)
> +	 NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_HW_VLAN_STAG_FILTER | \
> +	 NETIF_F_SCTP_CRC)
>  
>  #define MACVLAN_STATE_MASK \
>  	((1<<__LINK_STATE_NOCARRIER) | (1<<__LINK_STATE_DORMANT))
> diff --git a/drivers/net/tap.c b/drivers/net/tap.c
> index 9b6cb78..2c8512b 100644
> --- a/drivers/net/tap.c
> +++ b/drivers/net/tap.c
> @@ -369,8 +369,7 @@ rx_handler_result_t tap_handle_frame(struct sk_buff **pskb)
>  		 *	  check, we either support them all or none.
>  		 */
>  		if (skb->ip_summed = CHECKSUM_PARTIAL &&
> -		    !(features & NETIF_F_CSUM_MASK) &&
> -		    skb_checksum_help(skb))
> +		    skb_csum_hwoffload_help(skb, features))
>  			goto drop;
>  		if (ptr_ring_produce(&q->ring, skb))
>  			goto drop;
> @@ -945,6 +944,9 @@ static int set_offload(struct tap_queue *q, unsigned long arg)
>  		}
>  	}
>  
> +	if (arg & TUN_F_SCTP_CSUM)
> +		feature_mask |= NETIF_F_SCTP_CRC;
> +
>  	/* tun/tap driver inverts the usage for TSO offloads, where
>  	 * setting the TSO bit means that the userspace wants to
>  	 * accept TSO frames and turning it off means that user space

Does not the above comment apply to the new flag too?  It seems that
it's value should be inverted for macvtap, and isn't, here.


> @@ -1077,7 +1079,7 @@ static long tap_ioctl(struct file *file, unsigned int cmd,
>  	case TUNSETOFFLOAD:
>  		/* let the user check for future flags */
>  		if (arg & ~(TUN_F_CSUM | TUN_F_TSO4 | TUN_F_TSO6 |
> -			    TUN_F_TSO_ECN | TUN_F_UFO))
> +			    TUN_F_TSO_ECN | TUN_F_UFO | TUN_F_SCTP_CSUM))
>  			return -EINVAL;
>  
>  		rtnl_lock();
> diff --git a/include/uapi/linux/if_tun.h b/include/uapi/linux/if_tun.h
> index ee432cd..c3bb282 100644
> --- a/include/uapi/linux/if_tun.h
> +++ b/include/uapi/linux/if_tun.h
> @@ -86,6 +86,7 @@
>  #define TUN_F_TSO6	0x04	/* I can handle TSO for IPv6 packets */
>  #define TUN_F_TSO_ECN	0x08	/* I can handle TSO with ECN bits. */
>  #define TUN_F_UFO	0x10	/* I can handle UFO packets */
> +#define TUN_F_SCTP_CSUM 0x20	/* I can handle SCTP checksum offload */
>  
>  /* Protocol info prepended to the packets (when IFF_NO_PI is not set) */
>  #define TUN_PKT_STRIP	0x0001

Doesn't this belong in the previous patch?

> 2.9.5
