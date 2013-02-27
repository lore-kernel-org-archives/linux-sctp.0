From: David Miller <davem@davemloft.net>
Date: Wed, 27 Feb 2013 20:45:44 +0000
Subject: Re: [patch] sctp: check len in sctp_getsockopt_assoc_stats()
Message-Id: <20130227.154544.1758858137863453045.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <20130227204144.GA11300@longonot.mountain>
In-Reply-To: <20130227204144.GA11300@longonot.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: dan.carpenter@oracle.com
Cc: vyasevich@gmail.com, michele@acksyn.org, sri@us.ibm.com, nhorman@tuxdriver.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, kernel-janitors@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Wed, 27 Feb 2013 23:41:44 +0300

> This check is missing an upper bound.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> This should go in 3.8 -stable as well.

There is a discussion and patch on netdev already.
