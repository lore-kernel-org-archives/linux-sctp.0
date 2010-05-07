From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Fri, 07 May 2010 19:05:33 +0000
Subject: Re: [RFC PATCH v2] sctp: fix sctp to work with ipv6 source address
Message-Id: <4BE4647D.5090502@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1273062644-11097-2-git-send-email-vladislav.yasevich@hp.com>
In-Reply-To: <1273062644-11097-2-git-send-email-vladislav.yasevich@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org



Vlad Yasevich wrote:
> A few comments on the patch.
> 
> 
>> ---
>>  net/sctp/ipv6.c |   46 ++++++++++++++++++++++++++++++++++++++++++++--
>>  1 files changed, 44 insertions(+), 2 deletions(-)
>>
>> diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
>> index 9fb5d37..6047b57 100644
>> --- a/net/sctp/ipv6.c
>> +++ b/net/sctp/ipv6.c
>> @@ -77,6 +77,8 @@
>>  #include <net/sctp/sctp.h>
>>  
>>  #include <asm/uaccess.h>
>> +static inline int sctp_v6_addr_match_len(union sctp_addr *s1,
>> +                                         union sctp_addr *s2);
>>  
>>  /* Event handler for inet6 address addition/deletion events.
>>   * The sctp_local_addr_list needs to be protocted by a spin lock since
>> @@ -242,8 +244,14 @@ static struct dst_entry *sctp_v6_get_dst(struct sctp_association *asoc,
>>  					 union sctp_addr *daddr,
>>  					 union sctp_addr *saddr)
>>  {
>> -	struct dst_entry *dst;
>> +	struct dst_entry *dst = NULL;
>>  	struct flowi fl;
>> +	struct sctp_bind_addr *bp;
>> +	struct sctp_sockaddr_entry *laddr;
>> +	union sctp_addr *baddr = NULL;
>> +	__u8 matchlen = 0;
>> +	__u8 bmatchlen;
>> +	sctp_scope_t scope;
>>  
>>  	memset(&fl, 0, sizeof(fl));
>>  	ipv6_addr_copy(&fl.fl6_dst, &daddr->v6.sin6_addr);
>> @@ -259,6 +267,39 @@ static struct dst_entry *sctp_v6_get_dst(struct sctp_association *asoc,
>>  	}
>>  
>>  	dst = ip6_route_output(&init_net, NULL, &fl);
>> +	if (!asoc || saddr)
>> +		goto out;
>> +
> 
> If the route lookup fails and you fulfill the if statement, you will return
> without a route.

This appears to be expected behavior, so I'll retract that.
> 
>> +	if (dst->error) {
>> +		dst_release(dst);
>> +		dst = NULL;
>> +		bp = &asoc->base.bind_addr;
>> +		scope = sctp_scope(daddr);
>> +		/* Walk through the bind address list and try to get a dst that
>> +		 * matches a bind address as the source address.
>> +		*/
>> +		rcu_read_lock();
>> +		list_for_each_entry_rcu(laddr, &bp->address_list, list) {
>> +			if (!laddr->valid)
>> +				continue;
>> +			if ((laddr->state = SCTP_ADDR_SRC) &&
>> +			   (laddr->a.sa.sa_family = AF_INET6) &&
>> +			   (scope <= sctp_scope(&laddr->a))) {
>> +				bmatchlen = sctp_v6_addr_match_len(daddr, &laddr->a);
>> +				if (!baddr || (matchlen < bmatchlen)) {
>> +					baddr = &laddr->a;
>> +					matchlen = bmatchlen;
>> +				}
> 
> This is not quite right since routing lookup code now can do proper source
> address selection.  The trouble is that in IPv6, a reference to the actual route
> is returned, while in IPv4, a cached route is created and returned.  Thus IPv4
> can fill in the source address in the cache route, while IPv6 can not do that
> since it would be then be modifying the route in the actual table.  To solve
> this issue, IPv6 returns the source address in the flowi.  So, now we need to
> carry around a flowi so that we can properly check the source.
> 
> It's possible that original lookup may return the correct source and we can skip
> the whole lookup up routes for every entry in the bind list.
> 
> I am going to rework this and merge some of the things IPsec patch tried to do
> here.  First, we should call ip6_dst_lookup as that actually fills the flowi
> properly.  Next, we need to pass the flowi into this function fill it in here,
> so that sctp_transport_route() can than take that and pass it to get_saddr().
> 
> IPv6 version of get_saddr() will take the source address out of the flowi.
> 
> The way you have you code is that we end walking the bind list multiple times
> looking for the source address.  That's very wasteful, especially since we are
> most likely in softirq context and we want to make that as fast as possible.
> 

I think all of the above can be a follow-on patch actually.  The thing I really
don't like though is the source address selection.  It's just as half-assed as
the original code, only taking into consideration scope and longest prefix
match.  There is more to it then that.

So, I am going to take this patch, but there will be follow-ons to fix all the
broken stuff.

-vlad

> -vlad
> 
>> +			}	
>> +		}
>> +		rcu_read_unlock();
>> +		if (baddr) {
>> +			ipv6_addr_copy(&fl.fl6_src, &baddr->v6.sin6_addr);
>> +			dst = ip6_route_output(&init_net, NULL, &fl);
>> +		}
>> +	}
>> +
>> +out:
>>  	if (!dst->error) {
>>  		struct rt6_info *rt;
>>  		rt = (struct rt6_info *)dst;
>> @@ -267,7 +308,8 @@ static struct dst_entry *sctp_v6_get_dst(struct sctp_association *asoc,
>>  		return dst;
>>  	}
>>  	SCTP_DEBUG_PRINTK("NO ROUTE\n");
>> -	dst_release(dst);
>> +	if (dst)
>> +		dst_release(dst);
>>  	return NULL;
>>  }
>>  
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
