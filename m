From: David Miller <davem@davemloft.net>
Date: Fri, 07 Sep 2012 18:48:28 +0000
Subject: Re: [PATCH 1/2] dst: take into account policy update on check()
Message-Id: <20120907.144828.97793990734588625.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <504A08EA.3080506@6wind.com>
	<1347030598.2484.777.camel@edumazet-glaptop>
	<504A0F1F.5060504@6wind.com>
In-Reply-To: <504A0F1F.5060504@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: nicolas.dichtel@6wind.com
Cc: eric.dumazet@gmail.com, vyasevich@gmail.com, sri@us.ibm.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Date: Fri, 07 Sep 2012 17:13:35 +0200

> Le 07/09/2012 17:09, Eric Dumazet a =E9crit :
>> On Fri, 2012-09-07 at 16:47 +0200, Nicolas Dichtel wrote:
>>> Le 07/09/2012 16:35, Eric Dumazet a =E9crit :
>>>>
>>>> Hmm... cant we reuse rt_genid ?
>>>>
>>>> (When changing flow_cache_genid, change &net->ipv4.rt_genid)
>>>
>>> And so adding a new field in net->ipv6?
>>
>> or move net->ipv4.rt_genid to net->rt_genid
>>
>> Having separate field for IPv4/IPv6 is of little interest IMHO
>>
> Ok, I will wait feedback from other people and repost a patch after.

A global net->rt_genid is definitely the way to go.
