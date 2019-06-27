From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Thu, 27 Jun 2019 02:59:15 +0000
Subject: Re: [PATCH net] sctp: not bind the socket in sctp_connect
Message-Id: <20190627025915.GA2747@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <35a0e4f6ca68185117c6e5517d8ac924cc2f9d05.1561537899.git.lucien.xin@gmail.com>
In-Reply-To: <35a0e4f6ca68185117c6e5517d8ac924cc2f9d05.1561537899.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem@davemloft.net, Neil Horman <nhorman@tuxdriver.com>, syzkaller-bugs@googlegroups.com

On Wed, Jun 26, 2019 at 04:31:39PM +0800, Xin Long wrote:
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

Please give me another day to review this one. Thanks.
