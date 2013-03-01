From: David Miller <davem@davemloft.net>
Date: Fri, 01 Mar 2013 21:00:05 +0000
Subject: Re: [patch] sctp: use the passed in gfp flags instead GFP_KERNEL
Message-Id: <20130301.160005.2165970105360874488.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <20130301052743.GD2669@longonot.mountain>
In-Reply-To: <20130301052743.GD2669@longonot.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: dan.carpenter@oracle.com
Cc: vyasevich@gmail.com, sri@us.ibm.com, nhorman@tuxdriver.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, kernel-janitors@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Fri, 1 Mar 2013 08:27:43 +0300

> This patch doesn't change how the code works because in the current
> kernel gfp is always GFP_KERNEL.  But gfp was obviously intended
> instead of GFP_KERNEL.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied, thanks.
