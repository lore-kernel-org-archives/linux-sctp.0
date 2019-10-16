From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 16 Oct 2019 05:26:12 +0000
Subject: Re: [PATCH net] sctp: change sctp_prot .no_autobind with true
Message-Id: <CADvbK_cdOXdcMv5ptyKNVAq2Q55XWP=A7u9bZ5-aNjnKoNZnZg@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <06beb8a9ceaec9224a507b58d3477da106c5f0cd.1571124278.git.lucien.xin@gmail.com>
 <20191015.203919.1387270193651224661.davem@davemloft.net>
In-Reply-To: <20191015.203919.1387270193651224661.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem@davemloft.net>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>

On Wed, Oct 16, 2019 at 11:39 AM David Miller <davem@davemloft.net> wrote:
>
> From: Xin Long <lucien.xin@gmail.com>
> Date: Tue, 15 Oct 2019 15:24:38 +0800
>
> > syzbot reported a memory leak:
> >
> >   BUG: memory leak, unreferenced object 0xffff888120b3d380 (size 64):
> >   backtrace:
>  ...
> > It was caused by when sending msgs without binding a port, in the path:
> > inet_sendmsg() -> inet_send_prepare() -> inet_autobind() ->
> > .get_port/sctp_get_port(), sp->bind_hash will be set while bp->port is
> > not. Later when binding another port by sctp_setsockopt_bindx(), a new
> > bucket will be created as bp->port is not set.
> >
> > sctp's autobind is supposed to call sctp_autobind() where it does all
> > things including setting bp->port. Since sctp_autobind() is called in
> > sctp_sendmsg() if the sk is not yet bound, it should have skipped the
> > auto bind.
> >
> > THis patch is to avoid calling inet_autobind() in inet_send_prepare()
> > by changing sctp_prot .no_autobind with true, also remove the unused
> > .get_port.
> >
> > Reported-by: syzbot+d44f7bbebdea49dbc84a@syzkaller.appspotmail.com
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
>
> Applied and queued up for -stable.
>
> Xin, in the future please always provide a Fixes: even if it is the
> initial kernel repository commit.
Copy, thanks.
