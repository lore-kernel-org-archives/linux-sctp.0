From: David Miller <davem@davemloft.net>
Date: Mon, 29 Nov 2010 17:41:26 +0000
Subject: Re: [PATCH] sctp: kill unused macros in head file
Message-Id: <20101129.094126.189705325.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <4CF37D22.8090307@cn.fujitsu.com>
In-Reply-To: <4CF37D22.8090307@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: shanwei@cn.fujitsu.com
Cc: vladislav.yasevich@hp.com, shemminger@linux-foundation.org, netdev@vger.kernel.org, linux-sctp@vger.kernel.org

From: Shan Wei <shanwei@cn.fujitsu.com>
Date: Mon, 29 Nov 2010 18:14:58 +0800

> 
> 1. SCTP_CMD_NUM_VERBS,SCTP_CMD_MAX
> These two macros have never been used for several years since v2.6.12-rc2.
> 
> 2.sctp_port_rover,sctp_port_alloc_lock
> The commit 063930 abandoned global variables of port_rover and port_alloc_lock,
> but still keep two macros to refer to them.
> So, remove them now.
> 
> commit 06393009000779b00a558fd2f280882cc7dc2008
> Author: Stephen Hemminger <shemminger@linux-foundation.org>
> Date:   Wed Oct 10 17:30:18 2007 -0700
> 
>     [SCTP]: port randomization
> 
> 
> Signed-off-by: Shan Wei <shanwei@cn.fujitsu.com>

Applied, thank you.
