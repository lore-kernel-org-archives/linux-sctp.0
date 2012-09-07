From: David Miller <davem@davemloft.net>
Date: Fri, 07 Sep 2012 18:48:06 +0000
Subject: Re: [PATCH 1/2] dst: take into account policy update on check()
Message-Id: <20120907.144806.736840770944098543.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1347030598.2484.777.camel@edumazet-glaptop>
	<504A0F1F.5060504@6wind.com>
	<1347031312.2484.794.camel@edumazet-glaptop>
In-Reply-To: <1347031312.2484.794.camel@edumazet-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: eric.dumazet@gmail.com
Cc: nicolas.dichtel@6wind.com, vyasevich@gmail.com, sri@us.ibm.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Fri, 07 Sep 2012 17:21:52 +0200

> On Fri, 2012-09-07 at 17:13 +0200, Nicolas Dichtel wrote:
>> Le 07/09/2012 17:09, Eric Dumazet a =E9crit :
>> > On Fri, 2012-09-07 at 16:47 +0200, Nicolas Dichtel wrote:
>> >> Le 07/09/2012 16:35, Eric Dumazet a =E9crit :
>> >>>
>> >>> Hmm... cant we reuse rt_genid ?
>> >>>
>> >>> (When changing flow_cache_genid, change &net->ipv4.rt_genid)
>> >>
>> >> And so adding a new field in net->ipv6?
>> >
>> > or move net->ipv4.rt_genid to net->rt_genid
>> >
>> > Having separate field for IPv4/IPv6 is of little interest IMHO
>> >
>> Ok, I will wait feedback from other people and repost a patch after.
>=20
> By the way, the get_random_bytes() calls in rt_cache_invalidate() and in
> rt_genid_init() are no longer needed, since we dont use jhash anymore
> (no more route cache)

I like it, please submit this formally for net-next :-)
