From: David Miller <davem@davemloft.net>
Date: Mon, 06 Jun 2016 03:12:51 +0000
Subject: Re: [PATCHv2 net-next] sctp: sctp should change socket state when shutdown is received
Message-Id: <20160605.231251.1554542848732028723.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <67353a74d044f1f643cdfe1442136b44d7188ea9.1464964965.git.lucien.xin@gmail.com>
In-Reply-To: <67353a74d044f1f643cdfe1442136b44d7188ea9.1464964965.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, vyasevich@gmail.com, daniel@iogearbox.net, eric.dumazet@gmail.com

From: Xin Long <lucien.xin@gmail.com>
Date: Fri,  3 Jun 2016 22:42:45 +0800

> Now sctp doesn't change socket state upon shutdown reception. It changes
> just the assoc state, even though it's a TCP-style socket.
> 
> For some cases, if we really need to check sk->sk_state, it's necessary to
> fix this issue, at least when we use ss or netstat to dump, we can get a
> more exact information.
> 
> As an improvement, we will change sk->sk_state when we change asoc->state
> to SHUTDOWN_RECEIVED, and also do it in sctp_shutdown to keep consistent with
> sctp_close.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

It looks like some changes are still needed for this.
