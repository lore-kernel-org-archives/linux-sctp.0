From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 02 May 2018 14:53:47 +0000
Subject: Re: [PATCH V2 net-next 4/6] tun: Add support for SCTP checksum offload
Message-Id: <20180502145347.GG5105@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <20180502020739.19239-1-vyasevic@redhat.com>
 <20180502020739.19239-5-vyasevic@redhat.com>
In-Reply-To: <20180502020739.19239-5-vyasevic@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladislav Yasevich <vyasevich@gmail.com>
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, virtualization@lists.linux-foundation.org, virtio-dev@lists.oasis-open.org, mst@redhat.com, jasowang@redhat.com, nhorman@tuxdriver.com, Vladislav Yasevich <vyasevic@redhat.com>

On Tue, May 01, 2018 at 10:07:37PM -0400, Vladislav Yasevich wrote:
> Adds a new tun offload flag to allow for SCTP checksum offload.
> The flag has to be set by the user and defaults to "no offload".

I'm confused here:

> +++ b/drivers/net/tun.c
> @@ -216,7 +216,7 @@ struct tun_struct {
>  	struct net_device	*dev;
>  	netdev_features_t	set_features;
>  #define TUN_USER_FEATURES (NETIF_F_HW_CSUM|NETIF_F_TSO_ECN|NETIF_F_TSO| \
> -			  NETIF_F_TSO6)
> +			  NETIF_F_TSO6|NETIF_F_SCTP_CRC)

Doesn't adding it here mean it defaults to "offload", instead?

later on, it does:
                dev->hw_features = NETIF_F_SG | NETIF_F_FRAGLIST |
                                   TUN_USER_FEATURES | NETIF_F_HW_VLAN_CTAG_TX |
                                   NETIF_F_HW_VLAN_STAG_TX;
