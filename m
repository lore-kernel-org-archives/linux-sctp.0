From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Date: Fri, 07 Sep 2012 15:13:35 +0000
Subject: Re: [PATCH 1/2] dst: take into account policy update on check()
Message-Id: <504A0F1F.5060504@6wind.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <5049FAE3.2050403@6wind.com>  <1347033467-3757-1-git-send-email-nicolas.dichtel@6wind.com>  <1347033467-3757-2-git-send-email-nicolas.dichtel@6wind.com>  <1347028510.2484.736.camel@edumazet-glaptop>  <504A08EA.3080506@6wind.com> <1347030598.2484.777.camel@edumazet-glaptop>
In-Reply-To: <1347030598.2484.777.camel@edumazet-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: vyasevich@gmail.com, davem@davemloft.net, sri@us.ibm.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

Le 07/09/2012 17:09, Eric Dumazet a écrit :
> On Fri, 2012-09-07 at 16:47 +0200, Nicolas Dichtel wrote:
>> Le 07/09/2012 16:35, Eric Dumazet a écrit :
>>>
>>> Hmm... cant we reuse rt_genid ?
>>>
>>> (When changing flow_cache_genid, change &net->ipv4.rt_genid)
>>
>> And so adding a new field in net->ipv6?
>
> or move net->ipv4.rt_genid to net->rt_genid
>
> Having separate field for IPv4/IPv6 is of little interest IMHO
>
Ok, I will wait feedback from other people and repost a patch after.
