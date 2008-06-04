From: David Miller <davem@davemloft.net>
Date: Wed, 04 Jun 2008 19:38:51 +0000
Subject: Re: [PATCH 3/6] SCTP: Correctly implement Fast Recovery cwnd
Message-Id: <20080604.123851.195184149.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1212603951-24932-1-git-send-email-vladislav.yasevich@hp.com>
	<1212603951-24932-4-git-send-email-vladislav.yasevich@hp.com>
In-Reply-To: <1212603951-24932-4-git-send-email-vladislav.yasevich@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vladislav.yasevich@hp.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Wed,  4 Jun 2008 14:25:48 -0400

> Correctly keep track of Fast Recovery state and do not reduce
> congestion window multiple times during sucht state.
> 
> Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>
> Tested-by: Wei Yongjun <yjwei@cn.fujitsu.com>

Applied.
