From: David Miller <davem@davemloft.net>
Date: Tue, 20 Jun 2017 19:33:22 +0000
Subject: Re: [PATCH net-next] sctp: handle errors when updating asoc
Message-Id: <20170620.153322.781087834282340962.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <a6aa86ed657155e13c72c246b79cf297159a8765.1497945911.git.lucien.xin@gmail.com>
In-Reply-To: <a6aa86ed657155e13c72c246b79cf297159a8765.1497945911.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 20 Jun 2017 16:05:11 +0800

> It's a bad thing not to handle errors when updating asoc. The memory
> allocation failure in any of the functions called in sctp_assoc_update()
> would cause sctp to work unexpectedly.
> 
> This patch is to fix it by aborting the asoc and reporting the error when
> any of these functions fails.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Also applied, thank you.
