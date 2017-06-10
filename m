From: David Miller <davem@davemloft.net>
Date: Sat, 10 Jun 2017 20:23:01 +0000
Subject: Re: [PATCH net-next] sctp: use read_lock_bh in sctp_eps_seq_show
Message-Id: <20170610.162301.1998013616040326583.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <f845585a99f0cb76659f4d5dae4f7d6fd5552224.1497078812.git.lucien.xin@gmail.com>
In-Reply-To: <f845585a99f0cb76659f4d5dae4f7d6fd5552224.1497078812.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Sat, 10 Jun 2017 15:13:32 +0800

> This patch is to use read_lock_bh instead of local_bh_disable
> and read_lock in sctp_eps_seq_show.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied.
