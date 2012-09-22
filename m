From: Jan Engelhardt <jengelh@inai.de>
Date: Sat, 22 Sep 2012 16:49:07 +0000
Subject: Re: [PATCH net-next v2] Take care of xfrm policy when checking dst entries
Message-Id: <alpine.LNX.2.01.1209221841220.18458@nerf07.vanv.qr>
List-Id: <linux-sctp.vger.kernel.org>
References: <504DFA97.7070509@gmail.com> <20120910.131829.193126565067890591.davem@davemloft.net> <504E2A7A.9000003@gmail.com> <20120910.140105.1099041309239526456.davem@davemloft.net>
In-Reply-To: <20120910.140105.1099041309239526456.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem@davemloft.net>
Cc: vyasevich@gmail.com, nicolas.dichtel@6wind.com, eric.dumazet@gmail.com, sri@us.ibm.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org


On Monday 2012-09-10 20:01, David Miller wrote:
>> 
>> So you are perfectly ok with invalidating IPv6 cache when IPv4 table
>> changes, but not invalidating IPv4 cache if IPv6 table changes?
>
>Due to tunneling I can't see how this is avoidable?
>
>We do ipv6 over ipv4, but not vice-versa.

I have a setup here where 6 machines are connected with one another 
(most of them) to form 9 IPsec sessions, all of which are ESP6 links - 
since native IPv6 is provided - that also handle the site-to-site IPv4 
traffic. Does that count?
