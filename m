From: David Miller <davem@davemloft.net>
Date: Tue, 16 Jan 2018 19:25:19 +0000
Subject: Re: [PATCH net] sctp: do not allow the v4 socket to bind a v4mapped v6 address
Message-Id: <20180116.142519.2081883691476555323.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <e43f937592a7b022a72bdbbd784742ee6b3f6def.1516006920.git.lucien.xin@gmail.com>
In-Reply-To: <e43f937592a7b022a72bdbbd784742ee6b3f6def.1516006920.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 15 Jan 2018 17:02:00 +0800

> The check in sctp_sockaddr_af is not robust enough to forbid binding a
> v4mapped v6 addr on a v4 socket.
> 
> The worse thing is that v4 socket's bind_verify would not convert this
> v4mapped v6 addr to a v4 addr. syzbot even reported a crash as the v4
> socket bound a v6 addr.
> 
> This patch is to fix it by doing the common sa.sa_family check first,
> then AF_INET check for v4mapped v6 addrs.
> 
> Fixes: 7dab83de50c7 ("sctp: Support ipv6only AF_INET6 sockets.")
> Reported-by: syzbot+7b7b518b1228d2743963@syzkaller.appspotmail.com
> Acked-by: Neil Horman <nhorman@tuxdriver.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied and queued up for -stable.
