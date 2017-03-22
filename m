From: David Miller <davem@davemloft.net>
Date: Wed, 22 Mar 2017 01:32:48 +0000
Subject: Re: [PATCH net] sctp: out_qlen should be updated when pruning unsent queue
Message-Id: <20170321.183248.1571202262140371999.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <16cb6e6d2ef47481123bc3ff1b99e8abf5334d14.1489838639.git.lucien.xin@gmail.com>
In-Reply-To: <16cb6e6d2ef47481123bc3ff1b99e8abf5334d14.1489838639.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com, vyasevich@gmail.com

From: Xin Long <lucien.xin@gmail.com>
Date: Sat, 18 Mar 2017 20:03:59 +0800

> This patch is to fix the issue that sctp_prsctp_prune_sent forgot
> to update q->out_qlen when removing a chunk from unsent queue.
> 
> Fixes: 8dbdf1f5b09c ("sctp: implement prsctp PRIO policy")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied, thanks.
