From: David Miller <davem@davemloft.net>
Date: Mon, 19 Jun 2017 19:14:16 +0000
Subject: Re: [PATCH net] sctp: ensure ep is not destroyed before doing the dump
Message-Id: <20170619.151416.320922975636462627.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <6861fd3fc029ccba569fabccf7e05f6a52f28415.1497687027.git.lucien.xin@gmail.com>
In-Reply-To: <6861fd3fc029ccba569fabccf7e05f6a52f28415.1497687027.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Sat, 17 Jun 2017 16:10:27 +0800

> Now before dumping a sock in sctp_diag, it only holds the sock while
> the ep may be already destroyed. It can cause a use-after-free panic
> when accessing ep->asocs.
> 
> This patch is to set sctp_sk(sk)->ep NULL in sctp_endpoint_destroy,
> and check if this ep is already destroyed before dumping this ep.
> 
> Suggested-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied, thanks.
