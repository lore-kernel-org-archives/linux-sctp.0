From: David Miller <davem@davemloft.net>
Date: Thu, 17 Apr 2008 21:22:38 +0000
Subject: Re: [PATCH] SCTP: Initialize partial_bytes_acked to 0, when all of
Message-Id: <20080417.142238.250302376.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <4805A2CA.7030808@cn.fujitsu.com>
	<4807B318.2000307@hp.com>
In-Reply-To: <4807B318.2000307@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vladislav.yasevich@hp.com
Cc: guijianfeng@cn.fujitsu.com, netdev@vger.kernel.org, lksctp-developers@lists.sourceforge.net, linux-sctp@vger.kernel.org

From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Thu, 17 Apr 2008 16:29:12 -0400

> Loose the braces, otherwise looks good.

I took care of this an applied to net-2.6.26, thanks.
