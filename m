From: Qiujun Huang <hqjagain@gmail.com>
Date: Tue, 17 Mar 2020 04:44:10 +0000
Subject: Re: [PATCH] sctp: fix refcount bug in sctp_wfree
Message-Id: <CAJRQjodkqMM8Sap50UaDr5fXD+30+5tgpj4-CdEt9fM2WVjm7w@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1584330804-18477-1-git-send-email-hqjagain@gmail.com> <20200317041523.GB3756@localhost.localdomain>
In-Reply-To: <20200317041523.GB3756@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: vyasevich@gmail.com, nhorman@tuxdriver.com, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, linux-sctp@vger.kernel.org, netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

On Tue, Mar 17, 2020 at 12:15 PM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> On Mon, Mar 16, 2020 at 11:53:24AM +0800, Qiujun Huang wrote:
> > Do accounting for skb's real sk.
> > In some case skb->sk != asoc->base.sk.
>
> This is a too simple description.  Please elaborate how this can
> happen in sctp_wfree. Especially considering the construct for
> migrating the tx queue on sctp_sock_migrate(), as both sockets are
> locked while moving the chunks around and the asoc itself is only
> moved in between decrementing and incrementing the refcount:
>
>         lock_sock_nested(newsk, SINGLE_DEPTH_NESTING);
>         sctp_for_each_tx_datachunk(assoc, sctp_clear_owner_w);
>         sctp_assoc_migrate(assoc, newsk);
>         sctp_for_each_tx_datachunk(assoc, sctp_set_owner_w);
>         ...

Yeah, the description is too simple. I'll send v2.

>
> >
> > Reported-and-tested-by: syzbot+cea71eec5d6de256d54d@syzkaller.appspotmail.com
>
> I can't see a positive test result, though. If I didn't loose any
> email, your last test with a patch similar to this one actually
> failed.
> I'm talking about syzbot test result at Message-ID: <000000000000e7736205a0e041f5@google.com>

I told with syzbot privately avoiding noise :p
Thanks!
