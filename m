From: Xin Long <lucien.xin@gmail.com>
Date: Sat, 03 Oct 2020 08:20:17 +0000
Subject: Re: [PATCH net-next 15/15] sctp: enable udp tunneling socks
Message-Id: <CADvbK_cS1Zz3iraOy1gbU0=f3TxGAUqo_etabFkm=x7tazEBQA@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1601387231.git.lucien.xin@gmail.com> <780b235b6b4446f77cfcf167ba797ce1ae507cf1.1601387231.git.lucien.xin@gmail.com>
 <20201003041217.GI70998@localhost.localdomain>
In-Reply-To: <20201003041217.GI70998@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, Michael Tuexen <tuexen@fh-muenster.de>, Tom Herbert <therbert@google.com>, davem <davem@davemloft.net>

On Sat, Oct 3, 2020 at 12:12 PM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> On Tue, Sep 29, 2020 at 09:49:07PM +0800, Xin Long wrote:
> > This patch is to enable udp tunneling socks by calling
> > sctp_udp_sock_start() in sctp_ctrlsock_init(), and
> > sctp_udp_sock_stop() in sctp_ctrlsock_exit().
> >
> > Also add sysctl udp_port to allow changing the listening
> > sock's port by users.
> >
> > Wit this patch, the whole sctp over udp feature can be
>   With
>
> > enabled and used.
> ...
> > @@ -1466,6 +1466,10 @@ static int __net_init sctp_ctrlsock_init(struct net *net)
> >       if (status)
> >               pr_err("Failed to initialize the SCTP control sock\n");
> >
> > +     status = sctp_udp_sock_start(net);
>
> This can be masking the previous error.
right, will add more logs in sctp_udp_sock_start().

>
> > +     if (status)
> > +             pr_err("Failed to initialize the SCTP udp tunneling sock\n");
>                                                  SCTP UDP
>
> > +
> >       return status;
> >  }
> >
>
> This is the last comment I had.
> Thanks Xin! Nice patches.
Thanks for checking so carefully!
