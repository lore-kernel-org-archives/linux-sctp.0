From: David Miller <davem@davemloft.net>
Date: Tue, 17 Jun 2008 00:01:10 +0000
Subject: Re: [PATCH 1/2] sctp: Correctly cleanup procfs entries upon
Message-Id: <20080616.170110.253786385.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1213364949-9997-1-git-send-email-vladislav.yasevich@hp.com>
	<1213364949-9997-2-git-send-email-vladislav.yasevich@hp.com>
In-Reply-To: <1213364949-9997-2-git-send-email-vladislav.yasevich@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vladislav.yasevich@hp.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, lksctp-developers@lists.sourceforge.net, yjwei@cn.fujitsu.com

From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Fri, 13 Jun 2008 09:49:08 -0400

> This patch remove the proc fs entry which has been created if fail to
> set up proc fs entry for the SCTP protocol.
> 
> Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
> Acked-by: Neil Horman <nhorman@tuxdriver.com>
> Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>

Applied to net-2.6
