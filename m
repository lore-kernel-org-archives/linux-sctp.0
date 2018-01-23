From: David Miller <davem@davemloft.net>
Date: Tue, 23 Jan 2018 16:22:46 +0000
Subject: Re: [PATCH net-next] sctp: reset ret in again path in sctp_for_each_transport
Message-Id: <20180123.112246.308462044491465065.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <07dcfcd8098979f6693426fd562867ffa67dd65b.1516702945.git.lucien.xin@gmail.com>
In-Reply-To: <07dcfcd8098979f6693426fd562867ffa67dd65b.1516702945.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 23 Jan 2018 18:22:25 +0800

> Commit 97a6ec4ac021 ("rhashtable: Change rhashtable_walk_start to
> return void") only initialized ret for the first time, when going
> to again path, the next tsp could be NULL. Without resetting ret,
> cb_done would be called with tsp as NULL.
> 
> A kernel crash was caused by this when running sctpdiag testcase
> in sctp-tests.
> 
> Note that this issue doesn't affect net.git yet.
> 
> Fixes: 97a6ec4ac021 ("rhashtable: Change rhashtable_walk_start to return void")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied, thanks.
