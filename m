From: David Miller <davem@davemloft.net>
Date: Mon, 27 Aug 2018 22:14:02 +0000
Subject: Re: [PATCH net] sctp: remove useless start_fail from sctp_ht_iter in proc
Message-Id: <20180827.151402.567119455394127008.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <265533f54ceb4684bb8323c9601a743eed409527.1535366418.git.lucien.xin@gmail.com>
In-Reply-To: <265533f54ceb4684bb8323c9601a743eed409527.1535366418.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 27 Aug 2018 18:40:18 +0800

> After changing rhashtable_walk_start to return void, start_fail would
> never be set other value than 0, and the checking for start_fail is
> pointless, so remove it.
> 
> Fixes: 97a6ec4ac021 ("rhashtable: Change rhashtable_walk_start to return void")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied and queued up for -stable.
