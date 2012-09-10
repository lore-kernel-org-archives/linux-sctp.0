From: David Miller <davem@davemloft.net>
Date: Mon, 10 Sep 2012 18:01:05 +0000
Subject: Re: [PATCH net-next v2] Take care of xfrm policy when checking dst entries
Message-Id: <20120910.140105.1099041309239526456.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <504DFA97.7070509@gmail.com>
	<20120910.131829.193126565067890591.davem@davemloft.net>
	<504E2A7A.9000003@gmail.com>
In-Reply-To: <504E2A7A.9000003@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vyasevich@gmail.com
Cc: nicolas.dichtel@6wind.com, eric.dumazet@gmail.com, sri@us.ibm.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

From: Vlad Yasevich <vyasevich@gmail.com>
Date: Mon, 10 Sep 2012 13:59:22 -0400

> On 09/10/2012 01:18 PM, David Miller wrote:
>> From: Vlad Yasevich <vyasevich@gmail.com>
>> Date: Mon, 10 Sep 2012 10:35:03 -0400
>>
>>> I am not sure this is right...  This has a side-effect that when an
>>> rt_cache_flush() is called, it invalidates IPv6 routes a well....
>>>
>>> Its all fine and good do this when a new policy is added, but not when
>>> IPv4 routing table changes.
>>
>> I disagree.
>>
> 
> So you are perfectly ok with invalidating IPv6 cache when IPv4 table
> changes, but not invalidating IPv4 cache if IPv6 table changes?

Due to tunneling I can't see how this is avoidable?

We do ipv6 over ipv4, but not vice-versa.
