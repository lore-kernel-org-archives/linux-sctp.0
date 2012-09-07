From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Date: Fri, 07 Sep 2012 14:47:06 +0000
Subject: Re: [PATCH 1/2] dst: take into account policy update on check()
Message-Id: <504A08EA.3080506@6wind.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <5049FAE3.2050403@6wind.com>  <1347033467-3757-1-git-send-email-nicolas.dichtel@6wind.com>  <1347033467-3757-2-git-send-email-nicolas.dichtel@6wind.com> <1347028510.2484.736.camel@edumazet-glaptop>
In-Reply-To: <1347028510.2484.736.camel@edumazet-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: vyasevich@gmail.com, davem@davemloft.net, sri@us.ibm.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

Le 07/09/2012 16:35, Eric Dumazet a =C3=A9crit :
> On Fri, 2012-09-07 at 17:57 +0200, Nicolas Dichtel wrote:
>> When a xfrm policy is inserted or deleted, we must invalidate
>> all dst and recalculate the route.
>>
>> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
>> ---
>>   include/net/dst.h     | 7 +++++++
>>   net/core/dst.c        | 1 +
>>   net/core/sock.c       | 4 ++--
>>   net/ipv6/ip6_tunnel.c | 3 +--
>>   4 files changed, 11 insertions(+), 4 deletions(-)
>>
>> diff --git a/include/net/dst.h b/include/net/dst.h
>> index 9a78810..478e55a 100644
>> --- a/include/net/dst.h
>> +++ b/include/net/dst.h
>> @@ -101,6 +101,9 @@ struct dst_entry {
>>   	atomic_t		__refcnt;	/* client references	*/
>>   	int			__use;
>>   	unsigned long		lastuse;
>> +#ifdef CONFIG_XFRM
>> +	u32			flow_cache_genid;
>> +#endif
>>   	union {
>>   		struct dst_entry	*next;
>>   		struct rtable __rcu	*rt_next;
>> @@ -457,6 +460,10 @@ static inline int dst_input(struct sk_buff *skb)
>>
>>   static inline struct dst_entry *dst_check(struct dst_entry *dst, u32 c=
ookie)
>>   {
>> +#ifdef CONFIG_XFRM
>> +	if (dst->flow_cache_genid !=3D atomic_read(&flow_cache_genid))
>> +		return NULL;
>> +#endif
>
> Hmm... cant we reuse rt_genid ?
>
> (When changing flow_cache_genid, change &net->ipv4.rt_genid)

And so adding a new field in net->ipv6?


Regards,
Nicolas
