From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Tue, 12 Feb 2019 23:03:40 +0000
Subject: Re: [PATCH] inet_diag: fix reporting cgroup classid and fallback to priority
Message-Id: <85412c23-fe10-a7cd-5907-ae69ab55784e@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <154970855279.305165.13649851988934332761.stgit@buzz>
In-Reply-To: <154970855279.305165.13649851988934332761.stgit@buzz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Cc: Sasha Levin <sashal@kernel.org>, linux-sctp@vger.kernel.org



On 02/09/2019 02:35 AM, Konstantin Khlebnikov wrote:
> Field idiag_ext in struct inet_diag_req_v2 used as bitmap of requested
> extensions has only 8 bits. Thus extensions starting from DCTCPINFO
> cannot be requested directly. Some of them included into response
> unconditionally or hook into some of lower 8 bits.
> 
> Extension INET_DIAG_CLASS_ID has not way to request from the beginning.
> 
> This patch bundle it with INET_DIAG_TCLASS (ipv6 tos), fixes space
> reservation, and documents behavior for other extensions.
> 
> Also this patch adds fallback to reporting socket priority. This filed
> is more widely used for traffic classification because ipv4 sockets
> automatically maps TOS to priority and default qdisc pfifo_fast knows
> about that. But priority could be changed via setsockopt SO_PRIORITY so
> INET_DIAG_TOS isn't enough for predicting class.
> 
> Also cgroup2 obsoletes net_cls classid (it always zero), but we cannot
> reuse this field for reporting cgroup2 id because it is 64-bit (ino+gen).
> 
> So, after this patch INET_DIAG_CLASS_ID will report socket priority
> for most common setup when net_cls isn't set and/or cgroup2 in use.
>

Nice catch Konstantin

Are you planing sending an iproute2/ss patch to output NET_DIAG_CLASS_ID values then ?

Thanks.
