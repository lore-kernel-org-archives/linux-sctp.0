From: Vlad Yasevich <vyasevich@gmail.com>
Date: Thu, 06 Sep 2012 17:03:48 +0000
Subject: Re: [PATCH] sctp: check dst validity after IPsec operations
Message-Id: <5048D774.3020008@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1346953229-3825-1-git-send-email-nicolas.dichtel@6wind.com> <5048C984.3030306@gmail.com> <5048D219.4020001@6wind.com>
In-Reply-To: <5048D219.4020001@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: nicolas.dichtel@6wind.com
Cc: sri@us.ibm.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

On 09/06/2012 12:40 PM, Nicolas Dichtel wrote:
> Le 06/09/2012 18:04, Vlad Yasevich a =E9crit :
>> On 09/06/2012 01:40 PM, Nicolas Dichtel wrote:
>>> dst stored in struct sctp_transport needs to be recalculated when
>>> ipsec policy
>>> are updated. We use flow_cache_genid for that.
>>>
>>> For example, if a SCTP connection is established and then an IPsec
>>> policy is
>>> set, the old SCTP flow will not be updated and thus will not use the new
>>> IPsec policy.
>>>
>>> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
>>
>> why doesn't this need to be done for TCP?  What makes SCTP special in
>> this case?
> Tests prove that the pb does not exist with TCP. I made the patch some
> times ago, I will look again deeply to find the difference.
>

TCP appears to cache the flowi and uses that to re-route the packet.
However, re-route still seems predicated on dst_check()...

>>
>> ip_queue_xmit does an __sk_dst_check() which is essentially what
>> sctp_transport_dst_check() does.  That should determine if the
>> currently cached
>> route is valid or not.
> The problem is that route will not be invalidated, because dst->check()
> has no xfrm path so xfrm_dst_check() will never be called.
>

Shouldn't the cache be invalidated in this case?  If the cache is=20
invalidated, that should cause a new lookup.  If the cache isn't=20
invalidated, then any established connections that may now be impacted=20
by the policy will not pick it up.

-vlad

>
> Regards,
> Nicolas
>
>>
>> Looks like sctp may need to change to using ip_route_output_ports() call
>> as ip_route_output_key may not do all that is necessary
>>
>> -vlad
>>
>>> ---
>>>   include/net/sctp/sctp.h    | 3 ++-
>>>   include/net/sctp/structs.h | 3 +++
>>>   net/sctp/ipv6.c            | 1 +
>>>   net/sctp/protocol.c        | 1 +
>>>   4 files changed, 7 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
>>> index 9c6414f..3267246 100644
>>> --- a/include/net/sctp/sctp.h
>>> +++ b/include/net/sctp/sctp.h
>>> @@ -712,7 +712,8 @@ static inline void sctp_v4_map_v6(union sctp_addr
>>> *addr)
>>>    */
>>>   static inline struct dst_entry *sctp_transport_dst_check(struct
>>> sctp_transport *t)
>>>   {
>>> -    if (t->dst && !dst_check(t->dst, 0)) {
>>> +    if ((t->dst && !dst_check(t->dst, 0)) ||
>>> +        (t->flow_cache_genid !=3D atomic_read(&flow_cache_genid))) {
>>>           dst_release(t->dst);
>>>           t->dst =3D NULL;
>>>       }
>>> diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
>>> index 0fef00f..9dab882 100644
>>> --- a/include/net/sctp/structs.h
>>> +++ b/include/net/sctp/structs.h
>>> @@ -948,6 +948,9 @@ struct sctp_transport {
>>>
>>>       /* 64-bit random number sent with heartbeat. */
>>>       __u64 hb_nonce;
>>> +
>>> +    /* used to check validity of dst */
>>> +    __u32 flow_cache_genid;
>>>   };
>>>
>>>   struct sctp_transport *sctp_transport_new(struct net *, const union
>>> sctp_addr *,
>>> diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
>>> index ea14cb4..2ed7410 100644
>>> --- a/net/sctp/ipv6.c
>>> +++ b/net/sctp/ipv6.c
>>> @@ -349,6 +349,7 @@ out:
>>>           struct rt6_info *rt;
>>>           rt =3D (struct rt6_info *)dst;
>>>           t->dst =3D dst;
>>> +        t->flow_cache_genid =3D atomic_read(&flow_cache_genid);
>>>           SCTP_DEBUG_PRINTK("rt6_dst:%pI6 rt6_src:%pI6\n",
>>>               &rt->rt6i_dst.addr, &fl6->saddr);
>>>       } else {
>>> diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
>>> index 2d51842..4795a1a 100644
>>> --- a/net/sctp/protocol.c
>>> +++ b/net/sctp/protocol.c
>>> @@ -512,6 +512,7 @@ out_unlock:
>>>       rcu_read_unlock();
>>>   out:
>>>       t->dst =3D dst;
>>> +    t->flow_cache_genid =3D atomic_read(&flow_cache_genid);
>>>       if (dst)
>>>           SCTP_DEBUG_PRINTK("rt_dst:%pI4, rt_src:%pI4\n",
>>>                     &fl4->daddr, &fl4->saddr);
>>>
>>

