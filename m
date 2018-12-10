From: David Miller <davem@davemloft.net>
Date: Mon, 10 Dec 2018 19:54:33 +0000
Subject: Re: [PATCH net] sctp: initialize sin6_flowinfo for ipv6 addrs in sctp_inet6addr_event
Message-Id: <20181210.115433.42616985092042285.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <4c3dc15beee77a541042f79f35702574347dffc9.1544436052.git.lucien.xin@gmail.com>
In-Reply-To: <4c3dc15beee77a541042f79f35702574347dffc9.1544436052.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 10 Dec 2018 18:00:52 +0800

> syzbot reported a kernel-infoleak, which is caused by an uninitialized
> field(sin6_flowinfo) of addr->a.v6 in sctp_inet6addr_event().
> The call trace is as below:
...
> sin6_flowinfo is not really used by SCTP, so it will be fixed by simply
> setting it to 0.
> 
> The issue exists since very beginning.
> Thanks Alexander for the reproducer provided.
> 
> Reported-by: syzbot+ad5d327e6936a2e284be@syzkaller.appspotmail.com
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied and queued up for -stable, thanks Xin.
