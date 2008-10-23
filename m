From: David Miller <davem@davemloft.net>
Date: Thu, 23 Oct 2008 08:00:02 +0000
Subject: Re: [PATCH 1/4] sctp: Drop ICMP packet too big message with MTU
Message-Id: <20081023.010002.179974041.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1224641327-11913-1-git-send-email-vladislav.yasevich@hp.com>
	<1224641327-11913-2-git-send-email-vladislav.yasevich@hp.com>
In-Reply-To: <1224641327-11913-2-git-send-email-vladislav.yasevich@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vladislav.yasevich@hp.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, yjwei@cn.fujitsu.com

From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Tue, 21 Oct 2008 22:08:44 -0400

> If ICMP packet too big message is received with MTU larger than current
> PMTU, SCTP will still accept this ICMP message and sync the PMTU of assoc
> with the wrong MTU.
> 
> Endpoing A                 Endpoint B
> (ESTABLISHED)              (ESTABLISHED)
> ICMP         --------->
> (packet too big, MTU too larger)
>                            sync PMTU
> 
> This patch fixed the problem by drop that ICMP message.
> 
> Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
> Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>

Applied.
