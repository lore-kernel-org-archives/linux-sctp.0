From: David Miller <davem@davemloft.net>
Date: Sat, 29 Jun 2019 17:51:48 +0000
Subject: Re: [PATCH net] sctp: not bind the socket in sctp_connect
Message-Id: <20190629.105148.1104113228238361709.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <35a0e4f6ca68185117c6e5517d8ac924cc2f9d05.1561537899.git.lucien.xin@gmail.com>
In-Reply-To: <35a0e4f6ca68185117c6e5517d8ac924cc2f9d05.1561537899.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com, syzkaller-bugs@googlegroups.com

From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 26 Jun 2019 16:31:39 +0800

> Now when sctp_connect() is called with a wrong sa_family, it binds
> to a port but doesn't set bp->port, then sctp_get_af_specific will
> return NULL and sctp_connect() returns -EINVAL.
> 
> Then if sctp_bind() is called to bind to another port, the last
> port it has bound will leak due to bp->port is NULL by then.
> 
> sctp_connect() doesn't need to bind ports, as later __sctp_connect
> will do it if bp->port is NULL. So remove it from sctp_connect().
> While at it, remove the unnecessary sockaddr.sa_family len check
> as it's already done in sctp_inet_connect.
> 
> Fixes: 644fbdeacf1d ("sctp: fix the issue that flags are ignored when using kernel_connect")
> Reported-by: syzbot+079bf326b38072f849d9@syzkaller.appspotmail.com
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied and queued up for -stable, thanks.
