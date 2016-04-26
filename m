From: David Miller <davem@davemloft.net>
Date: Tue, 26 Apr 2016 19:19:33 +0000
Subject: Re: [PATCH net-next] sctp: sctp_diag should fill RMEM_ALLOC with asoc->rmem_alloc when rcvbuf_policy
Message-Id: <20160426.151933.1727797620994322847.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <f21861d502b04cf3752dce4cde8cd3f5f1806571.1461511282.git.lucien.xin@gmail.com>
In-Reply-To: <f21861d502b04cf3752dce4cde8cd3f5f1806571.1461511282.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, vyasevich@gmail.com, daniel@iogearbox.net, eric.dumazet@gmail.com

From: Xin Long <lucien.xin@gmail.com>
Date: Sun, 24 Apr 2016 23:21:22 +0800

> For sctp assoc, when rcvbuf_policy is set, it will has it's own
> rmem_alloc, when we dump asoc info in sctp_diag, we should use that
> value on RMEM_ALLOC as well, just like WMEM_ALLOC.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied.
