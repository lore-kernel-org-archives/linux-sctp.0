From: David Miller <davem@davemloft.net>
Date: Fri, 09 May 2008 22:11:26 +0000
Subject: Re: [PATCH] [SCTP]: Do not enable peer IPv6 address support on
Message-Id: <20080509.151126.02367630.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1210360195-16524-1-git-send-email-vladislav.yasevich@hp.com>
In-Reply-To: <1210360195-16524-1-git-send-email-vladislav.yasevich@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vladislav.yasevich@hp.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, lksctp-developers@lists.sourceforge.net, yjwei@cn.fujitsu.com

From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Fri,  9 May 2008 15:09:54 -0400

> If socket is create by PF_INET type, it can not used IPv6 address to
> send/recv DATA, So we can not used IPv6 address even if peer tell us it
> support IPv6 address.
> This patch fix to only enabled peer IPv6 address support on PF_INET6 socket.
> 
> Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
> Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>

Applied.
