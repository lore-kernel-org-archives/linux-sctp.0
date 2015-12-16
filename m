From: David Miller <davem@davemloft.net>
Date: Wed, 16 Dec 2015 15:57:02 +0000
Subject: Re: [PATCH 1/1] net: sctp: dynamically enable or disable pf state
Message-Id: <20151216.105702.1186081559511068169.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <566ED0D9.8040200@gmail.com>
	<1450245304-29848-1-git-send-email-zyjzyj2000@gmail.com>
	<1450245304-29848-2-git-send-email-zyjzyj2000@gmail.com>
In-Reply-To: <1450245304-29848-2-git-send-email-zyjzyj2000@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: zyjzyj2000@gmail.com
Cc: vyasevich@gmail.com, nhorman@tuxdriver.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, alexandre.dietsch@windriver.com, stefan.costandache@windriver.com

From: <zyjzyj2000@gmail.com>
Date: Wed, 16 Dec 2015 13:55:04 +0800

> From: Zhu Yanjun <zyjzyj2000@gmail.com>
> 
> As we all know, the value of pf_retrans >= max_retrans_path can
> disable pf state. The variables of pf_retrans and max_retrans_path
> can be changed by the userspace application.
> 
> Sometimes the user expects to disable pf state while the 2
> variables are changed to enable pf state. So it is necessary to
> introduce a new variable to disable pf state.
> 
> According to the suggestions from Vlad Yasevich, extra1 and extra2
> are removed. The initialization of pf_enable is added.
> 
> Acked-by: Vlad Yasevich <vyasevich@gmail.com>
> Signed-off-by: Zhu Yanjun <zyjzyj2000@gmail.com>

Applied to net-next, thanks.
