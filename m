From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Date: Tue, 20 Apr 2010 09:19:28 +0000
Subject: Re: [PATCH] sctp: make IPSec rules effective with IPv6
Message-Id: <4BCD71A0.50107@dev.6wind.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <4BCD4A77.2030502@cn.fujitsu.com>
In-Reply-To: <4BCD4A77.2030502@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

What about the PMTU problem?

I've understand that this solution will not work:

You wrote:
"This would work for transmit SCTP packet under IPSEC, the
problem is that we can not get the correct PMTU for the
transport.Under IPv4, both transmit and the PMTU is correct."

Regards,
Nicolas

Wei Yongjun wrote:
> IPSec rules are ineffective with IPv6 transmit currently, so
> this patch make them effective with IPv6.
> Idea from Nicolas Dichtel <nicolas.dichtel@dev.6wind.com>
> 
> Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
> ---
>  include/net/sctp/structs.h |    3 +++
>  net/sctp/ipv6.c            |   23 +++++++++++++++++++++++
>  net/sctp/transport.c       |    3 +++
>  3 files changed, 29 insertions(+), 0 deletions(-)
> 
> diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
> index ff30177..5fe4df4 100644
> --- a/include/net/sctp/structs.h
> +++ b/include/net/sctp/structs.h
> @@ -569,6 +569,9 @@ struct sctp_af {
>  	struct dst_entry *(*get_dst)	(struct sctp_association *asoc,
>  					 union sctp_addr *daddr,
>  					 union sctp_addr *saddr);
> +	struct dst_entry *(*get_xfrm_dst)(struct dst_entry **dst_p,
> +					  union sctp_addr *daddr,
> +					  union sctp_addr *saddr);
>  	void		(*get_saddr)	(struct sctp_sock *sk,
>  					 struct sctp_association *asoc,
>  					 struct dst_entry *dst,
> diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
> index 9fb5d37..09a4c9c 100644
> --- a/net/sctp/ipv6.c
> +++ b/net/sctp/ipv6.c
> @@ -271,6 +271,28 @@ static struct dst_entry *sctp_v6_get_dst(struct sctp_association *asoc,
>  	return NULL;
>  }
>  
> +static struct dst_entry *sctp_v6_get_xfrm_dst(struct dst_entry **dst_p,
> +					       union sctp_addr *daddr,
> +					       union sctp_addr *saddr)
> +{
> +	struct flowi fl;
> +
> +	SCTP_DEBUG_PRINTK("%s: daddr:%pI6 saddr:%pI6",
> +		__func__, &daddr->v6.sin6_addr, &saddr->v6.sin6_addr);
> +
> +	memset(&fl, 0, sizeof(fl));
> +	fl.proto = IPPROTO_SCTP;
> +	fl.fl_ip_dport = daddr->v6.sin6_port;
> +	fl.fl_ip_sport = saddr->v6.sin6_port;
> +	ipv6_addr_copy(&fl.fl6_dst, &daddr->v6.sin6_addr);
> +	ipv6_addr_copy(&fl.fl6_src, &saddr->v6.sin6_addr);
> +
> +	if (xfrm_lookup(&init_net, dst_p, &fl, NULL, 0) < 0)
> +		return NULL;
> +	else
> +		return *dst_p;
> +}
> +
>  /* Returns the number of consecutive initial bits that match in the 2 ipv6
>   * addresses.
>   */
> @@ -962,6 +984,7 @@ static struct sctp_af sctp_af_inet6 = {
>  	.setsockopt	   = ipv6_setsockopt,
>  	.getsockopt	   = ipv6_getsockopt,
>  	.get_dst	   = sctp_v6_get_dst,
> +	.get_xfrm_dst	   = sctp_v6_get_xfrm_dst,
>  	.get_saddr	   = sctp_v6_get_saddr,
>  	.copy_addrlist	   = sctp_v6_copy_addrlist,
>  	.from_skb	   = sctp_v6_from_skb,
> diff --git a/net/sctp/transport.c b/net/sctp/transport.c
> index be4d63d..f89dd4d 100644
> --- a/net/sctp/transport.c
> +++ b/net/sctp/transport.c
> @@ -298,6 +298,9 @@ void sctp_transport_route(struct sctp_transport *transport,
>  	else
>  		af->get_saddr(opt, asoc, dst, daddr, &transport->saddr);
>  
> +	if (af->get_xfrm_dst)
> +		dst = af->get_xfrm_dst(&dst, daddr, &transport->saddr);
> +
>  	transport->dst = dst;
>  	if ((transport->param_flags & SPP_PMTUD_DISABLE) && transport->pathmtu) {
>  		return;
