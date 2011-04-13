From: David Miller <davem@davemloft.net>
Date: Wed, 13 Apr 2011 02:34:00 +0000
Subject: Re: [PATCH] sctp: fix oops when updating retransmit path with
Message-Id: <20110412.193400.189720071.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <4DA4FA70.50506@cn.fujitsu.com>
In-Reply-To: <4DA4FA70.50506@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: yjwei@cn.fujitsu.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Wed, 13 Apr 2011 09:20:48 +0800

> From: Vlad Yasevich <vladislav.yasevich@hp.com>
> 
> commit fbdf501c9374966a56829ecca3a7f25d2b49a305
>   sctp: Do no select unconfirmed transports for retransmissions
> 
> Introduced the initial falt.
> 
> commit d598b166ced20d9b9281ea3527c0e18405ddb803
>   sctp: Make sure we always return valid retransmit path
> 
> Solved the problem, but forgot to change the DEBUG statement.
> Thus it was still possible to dereference a NULL pointer.
> 
> Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
> Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>

Applied.
