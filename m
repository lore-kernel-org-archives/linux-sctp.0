From: David Miller <davem@davemloft.net>
Date: Sun, 19 Feb 2017 23:19:55 +0000
Subject: Re: [PATCH net-next] sctp: sctp_transport_dst_check should check if transport pmtu is dst mtu
Message-Id: <20170219.181955.660651394406915269.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <7cbbbf479fddc8b516f87bc6258e775634e84dd6.1487320905.git.lucien.xin@gmail.com>
In-Reply-To: <7cbbbf479fddc8b516f87bc6258e775634e84dd6.1487320905.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com, vyasevich@gmail.com

From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 17 Feb 2017 16:41:45 +0800

> Now when sending a packet, sctp_transport_dst_check will check if dst
> is obsolete by calling ipv4/ip6_dst_check. But they return obsolete
> only when adding a new cache, after that when the cache's pmtu is
> updated again, it will not trigger transport->dst/pmtu's update.
> 
> It can be reproduced by reducing route's pmtu twice. At the 1st time
> client will add a new cache, and transport->pathmtu gets updated as
> sctp_transport_dst_check finds it's obsolete. But at the 2nd time,
> cache's mtu is updated, sctp client will never send out any packet,
> because transport->pmtu has no chance to update.
> 
> This patch is to fix this by also checking if transport pmtu is dst
> mtu in sctp_transport_dst_check, so that transport->pmtu can be
> updated on time.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied.
