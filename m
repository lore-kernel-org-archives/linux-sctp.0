From: David Miller <davem@davemloft.net>
Date: Sat, 17 Dec 2016 16:25:21 +0000
Subject: Re: [PATCH net] sctp: sctp_transport_lookup_process should rcu_read_unlock when transport is null
Message-Id: <20161217.112521.863936916212574024.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <3d4f0205d5b5c64d372dffb37602f48e4a173612.1481814352.git.lucien.xin@gmail.com>
In-Reply-To: <3d4f0205d5b5c64d372dffb37602f48e4a173612.1481814352.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 15 Dec 2016 23:05:52 +0800

> Prior to this patch, sctp_transport_lookup_process didn't rcu_read_unlock
> when it failed to find a transport by sctp_addrs_lookup_transport.
> 
> This patch is to fix it by moving up rcu_read_unlock right before checking
> transport and also to remove the out path.
> 
> Fixes: 1cceda784980 ("sctp: fix the issue sctp_diag uses lock_sock in rcu_read_lock")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied and queued up for -stable, thanks.
