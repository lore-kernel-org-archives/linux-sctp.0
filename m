From: David Miller <davem@davemloft.net>
Date: Sat, 01 Jul 2017 15:47:19 +0000
Subject: Re: [PATCH net-next] sctp: remove an unnecessary check from sctp_endpoint_destroy
Message-Id: <20170701.084719.435039770131658866.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <9a583ea8d84ee913f4c7ba1571e6cfeb24c9ef8b.1498728486.git.lucien.xin@gmail.com>
In-Reply-To: <9a583ea8d84ee913f4c7ba1571e6cfeb24c9ef8b.1498728486.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 29 Jun 2017 17:28:06 +0800

> ep->base.sk gets it's value since sctp_endpoint_new, nowhere
> will change it. So there's no need to check if it's null, as
> it can never be null.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied, thanks.
