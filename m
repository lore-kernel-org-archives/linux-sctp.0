From: Vlad Yasevich <vyasevic@redhat.com>
Date: Wed, 02 May 2018 13:27:00 +0000
Subject: Re: [PATCH V2 net-next 5/6] macvlan/macvtap: Add support for SCTP checksum offload.
Message-Id: <35def050-3803-42f4-5ee3-c10f98186c6d@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20180502020739.19239-1-vyasevic@redhat.com>
 <20180502020739.19239-6-vyasevic@redhat.com>
 <20180502062400-mutt-send-email-mst@kernel.org>
In-Reply-To: <20180502062400-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Michael S. Tsirkin" <mst@redhat.com>, Vladislav Yasevich <vyasevich@gmail.com>
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, virtualization@lists.linux-foundation.org, virtio-dev@lists.oasis-open.org, jasowang@redhat.com, nhorman@tuxdriver.com, marcelo.leitner@gmail.com

On 05/01/2018 11:24 PM, Michael S. Tsirkin wrote:
> On Tue, May 01, 2018 at 10:07:38PM -0400, Vladislav Yasevich wrote:
>> Since we now have support for software CRC32c offload, turn it on
>> for macvlan and macvtap devices so that guests can take advantage
>> of offload SCTP checksums to the host or host hardware.
>>
>> Signed-off-by: Vladislav Yasevich <vyasevic@redhat.com>
>> ---
>>  drivers/net/macvlan.c | 5 +++--
>>  drivers/net/tap.c     | 8 +++++---
>>  2 files changed, 8 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
>> index 725f4b4..646b730 100644
>> --- a/drivers/net/macvlan.c
>> +++ b/drivers/net/macvlan.c
>> @@ -834,7 +834,7 @@ static struct lock_class_key macvlan_netdev_addr_lock_key;
>>  
>>  #define ALWAYS_ON_OFFLOADS \
>>  	(NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_GSO_SOFTWARE | \
>> -	 NETIF_F_GSO_ROBUST | NETIF_F_GSO_ENCAP_ALL)
>> +	 NETIF_F_GSO_ROBUST | NETIF_F_GSO_ENCAP_ALL | NETIF_F_SCTP_CRC)
>>  
>>  #define ALWAYS_ON_FEATURES (ALWAYS_ON_OFFLOADS | NETIF_F_LLTX)
>>  
>> @@ -842,7 +842,8 @@ static struct lock_class_key macvlan_netdev_addr_lock_key;
>>  	(NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_HIGHDMA | NETIF_F_FRAGLIST | \
>>  	 NETIF_F_GSO | NETIF_F_TSO | NETIF_F_LRO | \
>>  	 NETIF_F_TSO_ECN | NETIF_F_TSO6 | NETIF_F_GRO | NETIF_F_RXCSUM | \
>> -	 NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_HW_VLAN_STAG_FILTER)
>> +	 NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_HW_VLAN_STAG_FILTER | \
>> +	 NETIF_F_SCTP_CRC)
>>  
>>  #define MACVLAN_STATE_MASK \
>>  	((1<<__LINK_STATE_NOCARRIER) | (1<<__LINK_STATE_DORMANT))
>> diff --git a/drivers/net/tap.c b/drivers/net/tap.c
>> index 9b6cb78..2c8512b 100644
>> --- a/drivers/net/tap.c
>> +++ b/drivers/net/tap.c
>> @@ -369,8 +369,7 @@ rx_handler_result_t tap_handle_frame(struct sk_buff **pskb)
>>  		 *	  check, we either support them all or none.
>>  		 */
>>  		if (skb->ip_summed = CHECKSUM_PARTIAL &&
>> -		    !(features & NETIF_F_CSUM_MASK) &&
>> -		    skb_checksum_help(skb))
>> +		    skb_csum_hwoffload_help(skb, features))
>>  			goto drop;
>>  		if (ptr_ring_produce(&q->ring, skb))
>>  			goto drop;
>> @@ -945,6 +944,9 @@ static int set_offload(struct tap_queue *q, unsigned long arg)
>>  		}
>>  	}
>>  
>> +	if (arg & TUN_F_SCTP_CSUM)
>> +		feature_mask |= NETIF_F_SCTP_CRC;
>> +
> 
> so this still affects TX, shouldn't this affect RX instead?

There is no bit to set on the RX path just like there is no bit to set on the RX patch
for TUN_F_CSUM.

We only invert TSO offloads, not checksum offloads as the comment below states.
For checksum,  macvtap has to compute the checksum itself in tap_handle_frame() above.
It uses tx feature bits to see if needs do to the checksum.

If you think we need another flag to macvtap to control RXCSUM, that would need to be
separate and cover standard TCP checksum as well.

-vlad

> 
> 
>>  	/* tun/tap driver inverts the usage for TSO offloads, where
>>  	 * setting the TSO bit means that the userspace wants to
>>  	 * accept TSO frames and turning it off means that user space
>> @@ -1077,7 +1079,7 @@ static long tap_ioctl(struct file *file, unsigned int cmd,
>>  	case TUNSETOFFLOAD:
>>  		/* let the user check for future flags */
>>  		if (arg & ~(TUN_F_CSUM | TUN_F_TSO4 | TUN_F_TSO6 |
>> -			    TUN_F_TSO_ECN | TUN_F_UFO))
>> +			    TUN_F_TSO_ECN | TUN_F_UFO | TUN_F_SCTP_CSUM))
>>  			return -EINVAL;
>>  
>>  		rtnl_lock();
>> -- 
>> 2.9.5

