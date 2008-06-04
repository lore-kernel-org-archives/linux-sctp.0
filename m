From: David Miller <davem@davemloft.net>
Date: Wed, 04 Jun 2008 19:38:17 +0000
Subject: Re: [PATCH 2/6] SCTP: Move sctp_v4_dst_saddr out of loop
Message-Id: <20080604.123817.78089516.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1212603951-24932-1-git-send-email-vladislav.yasevich@hp.com>
	<1212603951-24932-3-git-send-email-vladislav.yasevich@hp.com>
In-Reply-To: <1212603951-24932-3-git-send-email-vladislav.yasevich@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vladislav.yasevich@hp.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, guijianfeng@cn.fujitsu.com

From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Wed,  4 Jun 2008 14:25:47 -0400

> There's no need to execute sctp_v4_dst_saddr() for each
> iteration, just move it out of loop.
> 
> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
> Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>

Applied.

