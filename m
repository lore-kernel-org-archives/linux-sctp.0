From: David Miller <davem@davemloft.net>
Date: Thu, 12 May 2011 21:31:12 +0000
Subject: Re: [PATCH 1/2 v2] sctp: sctp_sendmsg: Don't initialize
Message-Id: <20110512.173112.1134946518914800656.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <a4e846ed62d7f9222dc9b09ca00b5356a1eb9b73.1305227620.git.joe@perches.com>
	<20110512.170603.549349521517995900.davem@davemloft.net>
	<1305235641.6124.64.camel@Joe-Laptop>
In-Reply-To: <1305235641.6124.64.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: joe@perches.com
Cc: vladislav.yasevich@hp.com, sri@us.ibm.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Thu, 12 May 2011 14:27:20 -0700

> This variable only needs initialization when cmsgs.info
> is NULL.
> 
> Use memset to ensure padding is also zeroed so
> kernel doesn't leak any data.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

This looks a lot better, applied.
