From: David Miller <davem@davemloft.net>
Date: Tue, 10 Sep 2019 17:33:31 +0000
Subject: Re: [PATCH net] sctp: fix the missing put_user when dumping transport thresholds
Message-Id: <20190910.193331.2286136885426226233.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <3fa4f7700c93f06530c80bc666d1696cb7c077de.1568014409.git.lucien.xin@gmail.com>
In-Reply-To: <3fa4f7700c93f06530c80bc666d1696cb7c077de.1568014409.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Mon,  9 Sep 2019 15:33:29 +0800

> This issue causes SCTP_PEER_ADDR_THLDS sockopt not to be able to dump
> a transport thresholds info.
> 
> Fix it by adding 'goto' put_user in sctp_getsockopt_paddr_thresholds.
> 
> Fixes: 8add543e369d ("sctp: add SCTP_FUTURE_ASSOC for SCTP_PEER_ADDR_THLDS sockopt")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied and queued up for -stable, thanks.
