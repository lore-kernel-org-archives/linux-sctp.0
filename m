From: David Miller <davem@davemloft.net>
Date: Sat, 10 Jun 2017 20:18:42 +0000
Subject: Re: [PATCH net] sctp: disable BH in sctp_for_each_endpoint
Message-Id: <20170610.161842.1880987451475541077.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <fc2c69db46c2dc7c877a54fc0b0917d99d0b7f0c.1497077294.git.lucien.xin@gmail.com>
In-Reply-To: <fc2c69db46c2dc7c877a54fc0b0917d99d0b7f0c.1497077294.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Sat, 10 Jun 2017 14:48:14 +0800

> Now sctp holds read_lock when foreach sctp_ep_hashtable without disabling
> BH. If CPU schedules to another thread A at this moment, the thread A may
> be trying to hold the write_lock with disabling BH.
> 
> As BH is disabled and CPU cannot schedule back to the thread holding the
> read_lock, while the thread A keeps waiting for the read_lock. A dead
> lock would be triggered by this.
> 
> This patch is to fix this dead lock by calling read_lock_bh instead to
> disable BH when holding the read_lock in sctp_for_each_endpoint.
> 
> Fixes: 626d16f50f39 ("sctp: export some apis or variables for sctp_diag and reuse some for proc")
> Reported-by: Xiumei Mu <xmu@redhat.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied and queued up for -stable, thanks.
