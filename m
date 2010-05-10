From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Mon, 10 May 2010 13:39:28 +0000
Subject: Re: [RFC PATCH v2] sctp: fix sctp to work with ipv6 source address
Message-Id: <4BE80C90.8080702@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1273062644-11097-2-git-send-email-vladislav.yasevich@hp.com>
In-Reply-To: <1273062644-11097-2-git-send-email-vladislav.yasevich@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org



Weixing.Shi(Stone) wrote:
> Vlad Yasevich wrote:
>> Vlad Yasevich wrote:
>>  

>>
>> I think all of the above can be a follow-on patch actually.  The thing
>> I really
>> don't like though is the source address selection.  
> hi vlad:
>    i have a question about the routing cache, why do we use routing
> cache to get the source and dest address?because source address has
> inserted into bp->address_list when we bind the source address and dest
> address is from msghdr when we send message.

We don't do anything wit destination addresses other then lookup routes to them.
 However, source address is different in that we don't know it a lot of time due
to multihoming nature of SCTP.  We know a set of source addresses, but not
what's the best one for this particular destination.  That's why we try to use a
route lookup to tell us what the best source address is.  Once we know it, we
can determine if we can use it.
When we find the best source, it's cached in the sctp_transport structure for
future use.  Also, as routes and interfaces change on the system, the source
address may change as well.

>> It's just as half-assed as
>> the original code, only taking into consideration scope and longest
>> prefix
>> match.  There is more to it then that.
>>
>>   
> if we support multi-home, here are more than one source address 
> existed,  which  ip will be selected for a primary source address?

There is no concept of primary source, just a primary destination.  The source
is selected based on source address selection algorithms and routes to the
destination.

> i do
> not find the algorithm in the sctp RFC(maybe i am mistake here), so i
> think the nearest ip for the dest address is best choice!

For IPv4 yes, it works fairly well, unless there are tons of aliases.

For IPv6, there is a whole source address selection and preference that has to
be followed.  See rfc 3484.  So, by us selectiong the closes match is not always
right.  Additionally, with the current code, if you have 2 addresses that have
the same number of common bits with destination, only the first found will be
used, but the route may not be the most optimal one or may not even exist.
Thus having on 1 route lookup hurts us in this case.

So, this algorithm needs some work.  The source address selection rules already
specify that there must be route for a given source to a given destination for
the source to be considered.  So, I'll look into how we can use that algorithm.

-vlad

> 
>> So, I am going to take this patch, but there will be follow-ons to fix
>> all the
>> broken stuff.
>>
>> -vlad
>>
>>  
>>> -vlad
>>>
>>>    
>>>> +            }   
>>>> +        }
>>>> +        rcu_read_unlock();
>>>> +        if (baddr) {
>>>> +            ipv6_addr_copy(&fl.fl6_src, &baddr->v6.sin6_addr);
>>>> +            dst = ip6_route_output(&init_net, NULL, &fl);
>>>> +        }
>>>> +    }
>>>> +
>>>> +out:
>>>>      if (!dst->error) {
>>>>          struct rt6_info *rt;
>>>>          rt = (struct rt6_info *)dst;
>>>> @@ -267,7 +308,8 @@ static struct dst_entry *sctp_v6_get_dst(struct
>>>> sctp_association *asoc,
>>>>          return dst;
>>>>      }
>>>>      SCTP_DEBUG_PRINTK("NO ROUTE\n");
>>>> -    dst_release(dst);
>>>> +    if (dst)
>>>> +        dst_release(dst);
>>>>      return NULL;
>>>>  }
>>>>  
>>>>       
>>> -- 
>>> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>>     
> 
> 
