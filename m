From: David Miller <davem@davemloft.net>
Date: Sun, 31 Jul 2016 05:07:10 +0000
Subject: Re: [PATCH net] sctp: allow receiving msg when TCP-style sk is in CLOSED state
Message-Id: <20160730.220710.6804773780755703.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <d108342f2f89cfdf7f9abc529a746a032e236b78.1469859281.git.lucien.xin@gmail.com>
In-Reply-To: <d108342f2f89cfdf7f9abc529a746a032e236b78.1469859281.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, vyasevich@gmail.com, daniel@iogearbox.net

From: Xin Long <lucien.xin@gmail.com>
Date: Sat, 30 Jul 2016 14:14:41 +0800

> Commit 141ddefce7c8 ("sctp: change sk state to CLOSED instead of
> CLOSING in sctp_sock_migrate") changed sk state to CLOSED if the
> assoc is closed when sctp_accept clones a new sk.
> 
> If there is still data in sk receive queue, users will not be able
> to read it any more, as sctp_recvmsg returns directly if sk state
> is CLOSED.
> 
> This patch is to add CLOSED state check in sctp_recvmsg to allow
> reading data from TCP-style sk with CLOSED state as what TCP does.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied.
