From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Wed, 21 Apr 2010 02:54:38 +0000
Subject: Re: [PATCH] fix sctp can not work with ipv6 source address routing
Message-Id: <4BCE68EE.8020500@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1271815076-31379-2-git-send-email-Weixing.Shi@windriver.com>
In-Reply-To: <1271815076-31379-2-git-send-email-Weixing.Shi@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org


> in the below test case, using the source address routing,
> sctp can not work.
> Node-A
> 1)ifconfig eth0 inet6 add 2001:1::1/64
> 2)ip -6 rule add from 2001:1::1 table 100 pref 100
> 3)ip -6 route add 2001:2::1 dev eth0 table 100
> 4)sctp_darn -H 2001:1::1 -P 250 -l &
> Node-B
> 1)ifconfig eth0 inet6 add 2001:2::1/64
> 2)ip -6 rule add from 2001:2::1 table 100 pref 100
> 3)ip -6 route add 2001:1::1 dev eth0 table 100
> 4)sctp_darn -H 2001:2::1 -P 250 -h 2001:1::1 -p 250 -s
>
> root cause:
> Node-A and Node-B use the source address routing, and
> at begining, source address will be NULL,sctp will
> search the  routing table by the destination address,
> because using the source address routing table, and
> the result dst_entry will be NULL.
>
> solution:
> walk through the bind address list to get the source
> address and then lookup the routing table again to get
> the correct dst_entry.
>
> Signed-off-by: Weixing Shi <Weixing.Shi@windriver.com>
> ---
>  net/sctp/ipv6.c |   65 ++++++++++++++++++++++++++++++++++++++++++++++++++++--
>  1 files changed, 62 insertions(+), 3 deletions(-)
>
> diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
> index 9fb5d37..5c55f98 100644
> --- a/net/sctp/ipv6.c
> +++ b/net/sctp/ipv6.c
> @@ -77,6 +77,10 @@
>  #include <net/sctp/sctp.h>
>  
>  #include <asm/uaccess.h>
> +static void sctp_v6_dst_saddr(union sctp_addr *addr, struct dst_entry *dst,
> +            __be16 port);
> +static int sctp_v6_cmp_addr(const union sctp_addr *addr1,
> +          const union sctp_addr *addr2);
>  
>  /* Event handler for inet6 address addition/deletion events.
>   * The sctp_local_addr_list needs to be protocted by a spin lock since
> @@ -242,8 +246,12 @@ static struct dst_entry *sctp_v6_get_dst(struct sctp_association *asoc,
>  					 union sctp_addr *daddr,
>  					 union sctp_addr *saddr)
>  {
> -	struct dst_entry *dst;
> -	struct flowi fl;
> +	struct dst_entry *dst = NULL;
> + 	struct flowi fl;
> +	struct sctp_bind_addr *bp;
> +	struct sctp_sockaddr_entry *laddr;
> +	union sctp_addr dst_saddr;
> +	sctp_scope_t scope;
>  
>  	memset(&fl, 0, sizeof(fl));
>  	ipv6_addr_copy(&fl.fl6_dst, &daddr->v6.sin6_addr);
> @@ -259,7 +267,58 @@ static struct dst_entry *sctp_v6_get_dst(struct sctp_association *asoc,
>  	}
>  
>  	dst = ip6_route_output(&init_net, NULL, &fl);
> -	if (!dst->error) {
> +	if (!asoc || saddr)
> +		goto out;
> +
> +	bp = &asoc->base.bind_addr;
> +	scope = sctp_scope(daddr);
> +
> +	if (dst) {
>   

IIRC, this may always be true since dst should not be NULL.
If dst can be NULL, orig code will cause OOPS in if (!dst->error), right?
We should use if (!dst->error) to check whether dst is exists.

> +		/* Walk through the bind address list and look for a bind
> +		 * address that matches the source address of the returned dst.
> +		 */	
> +		sctp_v6_dst_saddr(&dst_saddr, dst, htons(bp->port));
> +		rcu_read_lock();
> +		list_for_each_entry_rcu(laddr, &bp->address_list, list) {
> +			if (!laddr->valid)
> +				continue;
> +			if ((laddr->state = SCTP_ADDR_SRC) &&
> +			   (laddr->a.sa.sa_family = AF_INET6) &&
> +			   (scope <= sctp_scope(&laddr->a)) &&
> +			   (sctp_v6_cmp_addr(&dst_saddr, &laddr->a))){
> +				goto out_unlock;
> +			}
> +		rcu_read_unlock();
> +
> +		/* None of the bound addresses match the source address of the
> +		 * dst. So release it.
> +		 */
> +		dst_release(dst);
> +		dst = NULL;
> +		}
> +	}	
> +
> +	/* Walk through the bind address list and try to get a dst that
> +	 * matches a bind address as the source address.
> +	 */
> +	rcu_read_lock();
> +	list_for_each_entry_rcu(laddr, &bp->address_list, list) {
> +		if (!laddr->valid)
> +			continue;
> +		if ((laddr->state = SCTP_ADDR_SRC) &&
> +		   (laddr->a.sa.sa_family = AF_INET6) &&
> +		   (scope <= sctp_scope(&laddr->a))){
> +			ipv6_addr_copy(&fl.fl6_src, &laddr->a.v6.sin6_addr);
> +			dst = ip6_route_output(&init_net, NULL, &fl);				
> +			goto out_unlock;
> +		}
> +	}
> +
> +out_unlock:
> +	rcu_read_unlock();
> +	
> +out:
> +	if (dst) {
>  		struct rt6_info *rt;
>  		rt = (struct rt6_info *)dst;
>  		SCTP_DEBUG_PRINTK("rt6_dst:%pI6 rt6_src:%pI6\n",
>   
