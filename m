From: David Miller <davem@davemloft.net>
Date: Tue, 09 Jul 2019 03:18:30 +0000
Subject: Re: [PATCH net-next] sctp: remove rcu_read_lock from sctp_bind_addr_state
Message-Id: <20190708.201830.1677642444055911875.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <30ff9e8a45fa0c64d1c71bc13e217f3374f6120e.1562605180.git.lucien.xin@gmail.com>
In-Reply-To: <30ff9e8a45fa0c64d1c71bc13e217f3374f6120e.1562605180.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Tue,  9 Jul 2019 00:59:40 +0800

> sctp_bind_addr_state() is called either in packet rcv path or
> by sctp_copy_local_addr_list(), which are under rcu_read_lock.
> So there's no need to call it again in sctp_bind_addr_state().
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

This is correct, patch applied.

Thanks.
