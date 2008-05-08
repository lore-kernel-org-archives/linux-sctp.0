From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Date: Thu, 08 May 2008 09:03:11 +0000
Subject: Re: [Lksctp-developers] sctp related routing cache question
Message-Id: <4822C1CF.8010901@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Thanks wei,
With this patch,only one dst entry has been created, it is reused.
problem solved.

Wei Yongjun wrote:
> Hi all:
> 
> Maybe this patch can resolve this problem.
> 
> Gui Jianfeng wrote:
>> Neil Horman wrote:
>>  
>>> On Wed, May 07, 2008 at 08:33:29AM -0400, Vlad Yasevich wrote:
>>>    
>>>> Actually there is another cache entry created.
>>>>
>>>> Neil Horman wrote:
>>>>      
>>>>> On Wed, May 07, 2008 at 01:14:01PM +0800, Gui Jianfeng wrote:
>>>>>        
>>>>>> Hi everyone,
>>>>>> Consider the following scenario:
>>>>>>
>>>>>> Machine A          Machine B
>>>>>> (10.0.0.1)          (10.0.0.2)
>>>>>>            Echo request
>>>>>>      --------------->
>>>>>>           
>>>>                 Routing cache I(nput)
>>>>      
>>>>>>        Echo reply
>>>>>>          <--------------  Routing cache A created(src key:10.0.0.2)
>>>>>>        INIT CHUNK
>>>>>>      <--------------  Routing cache B created(src key:0)
>>>>>>
>>>>>> Question is whether it is possible to use "Routing cache A" for
>>>>>> sending INIT rather
>>>>>> then create a new "Routing cache B".           
>>>>> This doesn't really have much to do with SCTP at all, given that
>>>>> the routing
>>>>> cache operates exclusively on the network header bits (ip
>>>>> src:dst:tos, etc).
>>>>> Given that the destination entries are a hash of ip source, ip
>>>>> destination, tos,
>>>>> and a few other bits, the short answer is no, outgoing frames and
>>>>> incomming
>>>>> frames will have separate dst entries, and thats by design.
>>>>>         
>>>> As Neil stated, if the sctp association uses the same src:dst:tos as
>>>> well as the same
>>>> outgoing interface, then the cache entry will be reused.  So, in
>>>> theory it's possible.
>>>>
>>>>       
>>> In theory yes, but when replying the src and dst addresses are
>>> reversed, which
>>> causes the src:dst:tos hash to change, meaning another dst entry will be
>>> created, or am I missing something here?
>>>     
>>
>>   Neil,
>>   Do you mean they have different hash keys, so there must be two
>> different dst entry to be created?
>>   
> [PATCH] SCTP: lookup output route with addresses bind to assoc first
> while src address not specified
> 
> 
> Change to used addresses which bind to the association first to search
> route while search output route with source address not specified.
> 
> Now sctp_v4_get_dst() do this thing if source address not specified:
> 1. Lookup route with the addresses bind to the association. If found,
> return this route.
> 2. Lookup route with unspecified address.
> 
> Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
> 
> --- a/net/sctp/protocol.c    2008-04-18 09:00:58.000000000 -0400
> +++ b/net/sctp/protocol.c    2008-05-01 14:25:15.000000000 -0400
> @@ -449,6 +449,27 @@ static struct dst_entry *sctp_v4_get_dst
>     }
>     if (saddr)
>         fl.fl4_src = saddr->v4.sin_addr.s_addr;
> +    else if (asoc) {
> +        bp = &asoc->base.bind_addr;
> +
> +        /* Walk through the bind address list and try to get a dst that
> +         * matches a bind address as the source address.
> +         */
> +        rcu_read_lock();
> +        list_for_each_entry_rcu(laddr, &bp->address_list, list) {
> +            if (!laddr->valid)
> +                continue;
> +            if ((laddr->state = SCTP_ADDR_SRC) &&
> +                (AF_INET = laddr->a.sa.sa_family)) {
> +                fl.fl4_src = laddr->a.v4.sin_addr.s_addr;
> +                if (!ip_route_output_key(&init_net, &rt, &fl)) {
> +                    dst = &rt->u.dst;
> +                    goto out_unlock;
> +                }
> +            }
> +        }
> +        memset(&fl.fl4_src, 0x0, sizeof(fl.fl4_src));
> +    }
> 
>     SCTP_DEBUG_PRINTK("%s: DST:%u.%u.%u.%u, SRC:%u.%u.%u.%u - ",
>               __FUNCTION__, NIPQUAD(fl.fl4_dst),
> @@ -487,23 +508,6 @@ static struct dst_entry *sctp_v4_get_dst
>         dst = NULL;
>     }
> 
> -    /* Walk through the bind address list and try to get a dst that
> -     * matches a bind address as the source address.
> -     */
> -    rcu_read_lock();
> -    list_for_each_entry_rcu(laddr, &bp->address_list, list) {
> -        if (!laddr->valid)
> -            continue;
> -        if ((laddr->state = SCTP_ADDR_SRC) &&
> -            (AF_INET = laddr->a.sa.sa_family)) {
> -            fl.fl4_src = laddr->a.v4.sin_addr.s_addr;
> -            if (!ip_route_output_key(&init_net, &rt, &fl)) {
> -                dst = &rt->u.dst;
> -                goto out_unlock;
> -            }
> -        }
> -    }
> -
> out_unlock:
>     rcu_read_unlock();
> out:
> 
> 
> 
> 
> 
> 

-- 
Regards
Gui Jianfeng

