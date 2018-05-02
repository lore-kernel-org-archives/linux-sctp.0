From: Davide Caratti <dcaratti@redhat.com>
Date: Wed, 02 May 2018 08:12:44 +0000
Subject: Re: [PATCH V2 net-next 6/6] ipvlan: Add support for SCTP checksum offload
Message-Id: <1525248764.2641.9.camel@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20180502020739.19239-1-vyasevic@redhat.com>
         <20180502020739.19239-7-vyasevic@redhat.com>
In-Reply-To: <20180502020739.19239-7-vyasevic@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladislav Yasevich <vyasevich@gmail.com>, netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, virtualization@lists.linux-foundation.org, virtio-dev@lists.oasis-open.org, mst@redhat.com, jasowang@redhat.com, nhorman@tuxdriver.com, marcelo.leitner@gmail.com, Vladislav Yasevich <vyasevic@redhat.com>

On Tue, 2018-05-01 at 22:07 -0400, Vladislav Yasevich wrote:
> Since ipvlan is a software device, we can turn on SCTP checksum
> offload and let the checksum be computed at the lower layer.
> 
> Signed-off-by: Vladislav Yasevich <vyasevic@redhat.com>
> ---
>  drivers/net/ipvlan/ipvlan_main.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 

Acked-by: Davide Caratti <dcaratti@redhat.com>

> diff --git a/drivers/net/ipvlan/ipvlan_main.c b/drivers/net/ipvlan/ipvlan_main.c
> index 450eec2..ddb1590 100644
> --- a/drivers/net/ipvlan/ipvlan_main.c
> +++ b/drivers/net/ipvlan/ipvlan_main.c
> @@ -161,7 +161,8 @@ static void ipvlan_port_destroy(struct net_device *dev)
>  	(NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_HIGHDMA | NETIF_F_FRAGLIST | \
>  	 NETIF_F_GSO | NETIF_F_TSO | NETIF_F_GSO_ROBUST | \
>  	 NETIF_F_TSO_ECN | NETIF_F_TSO6 | NETIF_F_GRO | NETIF_F_RXCSUM | \
> -	 NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_HW_VLAN_STAG_FILTER)
> +	 NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_HW_VLAN_STAG_FILTER | \
> +	 NETIF_F_SCTP_CRC)
>  
>  #define IPVLAN_STATE_MASK \
>  	((1<<__LINK_STATE_NOCARRIER) | (1<<__LINK_STATE_DORMANT))

