From: David Miller <davem@davemloft.net>
Date: Fri, 26 Dec 2008 00:59:14 +0000
Subject: Re: [PATCH net-next 5/5] sctp: Add validity check for
Message-Id: <20081225.165914.95302523.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1229737672-28328-1-git-send-email-vladislav.yasevich@hp.com>
	<1229737672-28328-7-git-send-email-vladislav.yasevich@hp.com>
In-Reply-To: <1229737672-28328-7-git-send-email-vladislav.yasevich@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vladislav.yasevich@hp.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, yjwei@cn.fujitsu.com

From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Fri, 19 Dec 2008 20:47:52 -0500

> The latest ietf socket extensions API draft said:
> 
>   8.1.21.  Set or Get the SCTP Partial Delivery Point
> 
>     Note also that the call will fail if the user attempts to set
>     this value larger than the socket receive buffer size.
> 
> This patch add this validity check for SCTP_PARTIAL_DELIVERY_POINT
> socket option.
> 
> Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
> Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>

Also applied, thanks.
