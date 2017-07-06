From: David Miller <davem@davemloft.net>
Date: Thu, 06 Jul 2017 10:40:20 +0000
Subject: Re: [PATCH] sctp: set the value of flowi6_oif to sk_bound_dev_if to make sctp_v6_get_dst to find the
Message-Id: <20170706.114020.1164331043260731183.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1499324409-12489-1-git-send-email-lizheng043@gmail.com>
In-Reply-To: <1499324409-12489-1-git-send-email-lizheng043@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizheng043@gmail.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, vyasevich@gmail.com, nhorman@tuxdriver.com, linux-sctp@vger.kernel.org, jmorris@namei.org, james.z.li@ericsson.com, allen.y.zhao@ericsson.com, feng.qiu@ericsson.com

From: Zheng Li <lizheng043@gmail.com>
Date: Thu,  6 Jul 2017 15:00:09 +0800

> From: Zheng Li <james.z.li@ericsson.com>
> 
> if there are several same route entries with different outgoing net device,
> application's socket specifies the oif through setsockopt with
> SO_BINDTODEVICE, sctpv6 should choose the route entry whose outgoing net
> device is the oif which was specified by socket, set the value of
> flowi6_oif to sk->sk_bound_dev_if to make sctp_v6_get_dst to find the
> correct route entry.
> 
> Signed-off-by: Zheng Li <james.z.li@ericsson.com>

Applied, thanks.
