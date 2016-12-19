From: Hannes Frederic Sowa <hannes@stressinduktion.org>
Date: Mon, 19 Dec 2016 16:36:46 +0000
Subject: Re: [PATCH RFC net-next 2/7] net: add dst_pending_confirm flag to skbuff
Message-Id: <f9dadb5e-172a-4c39-c564-38be672ef0eb@stressinduktion.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <1482094596-26046-1-git-send-email-ja@ssi.bg>
 <1482094596-26046-3-git-send-email-ja@ssi.bg>
 <1482164252.1521.7.camel@edumazet-glaptop3.roam.corp.google.com>
In-Reply-To: <1482164252.1521.7.camel@edumazet-glaptop3.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Eric Dumazet <eric.dumazet@gmail.com>, Julian Anastasov <ja@ssi.bg>
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>

On 19.12.2016 17:17, Eric Dumazet wrote:
> On Sun, 2016-12-18 at 22:56 +0200, Julian Anastasov wrote:
> 
>>  
>> +static inline void sock_confirm_neigh(struct sk_buff *skb, struct neighbour *n)
>> +{
>> +	if (unlikely(skb->dst_pending_confirm)) {
>> +		struct sock *sk = skb->sk;
>> +		unsigned long now = jiffies;
>> +
>> +		/* avoid dirtying neighbour */
>> +		if (n->confirmed != now)
>> +			n->confirmed = now;
>> +		if (sk && sk->sk_dst_pending_confirm)
>> +			sk->sk_dst_pending_confirm = 0;
>> +	}
>> +}
>> +
> 
> I am still digesting this awesome patch series ;)
> 
> Not sure why you used an unlikely() here. TCP for example would hit this
> path quite often.
> 
> So considering sk_dst_pending_confirm might be dirtied quite often,
> 
> I am not sure why you placed it in the cache line that contains
> sk_rx_dst (in 1st patch)

Because they have to stay synchronized?

If we modify sk_rx_dst, we automatically also must clear
pending_confirm, otherwise we might end up confirming a wrong neighbor.

Bye,
Hannes

