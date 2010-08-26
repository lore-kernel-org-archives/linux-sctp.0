From: David Miller <davem@davemloft.net>
Date: Thu, 26 Aug 2010 21:12:24 +0000
Subject: Re: net/sctp: Use pr_fmt and pr_<level>
Message-Id: <20100826.141224.229731596.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1282692068.25208.11.camel@Joe-Laptop>
In-Reply-To: <1282692068.25208.11.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: joe@perches.com
Cc: vladislav.yasevich@hp.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Tue, 24 Aug 2010 16:21:08 -0700

> Change SCTP_DEBUG_PRINTK and SCTP_DEBUG_PRINTK_IPADDR to
> use do { print } while (0) guards.
> Add SCTP_DEBUG_PRINTK_CONT to fix errors in log when
> lines were continued.
> Add #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> Add a missing newline in "Failed bind hash alloc"
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied.
