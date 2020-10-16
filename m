From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 16 Oct 2020 07:08:51 +0000
Subject: Re: [PATCHv3 net-next 16/16] sctp: enable udp tunneling socks
Message-Id: <CADvbK_eMOPQfB2URNshOizSe9_j0dpbA47TVWSwctziFas3GaQ@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1602574012.git.lucien.xin@gmail.com> <afbaca39fa40eba694bd63c200050a49d8c8df81.1602574012.git.lucien.xin@gmail.com>
 <20201015174252.GB11030@localhost.localdomain>
In-Reply-To: <20201015174252.GB11030@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, Michael Tuexen <tuexen@fh-muenster.de>, davem <davem@davemloft.net>, Guillaume Nault <gnault@redhat.com>, Paolo Abeni <pabeni@redhat.com>, Willem de Bruijn <willemdebruijn.kernel@gmail.com>

On Fri, Oct 16, 2020 at 1:42 AM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> Actually..
>
> On Tue, Oct 13, 2020 at 03:27:41PM +0800, Xin Long wrote:
> ...
> > Also add sysctl udp_port to allow changing the listening
> > sock's port by users.
> ...
> > ---
> >  net/sctp/protocol.c |  5 +++++
> >  net/sctp/sysctl.c   | 50 ++++++++++++++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 55 insertions(+)
>
> Xin, sorry for not noticing this earlier, but we need a documentation
> update here for this new sysctl. This is important. Please add its
> entry in ip-sysctl.rst.
no problem, I will add it.

>
> >
> > diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
> > index be002b7..79fb4b5 100644
> > --- a/net/sctp/protocol.c
> > +++ b/net/sctp/protocol.c
> > @@ -1469,6 +1469,10 @@ static int __net_init sctp_ctrlsock_init(struct net *net)
> >       if (status)
> >               pr_err("Failed to initialize the SCTP control sock\n");
> >
> > +     status = sctp_udp_sock_start(net);
> > +     if (status)
> > +             pr_err("Failed to initialize the SCTP udp tunneling sock\n");
>                                                       ^^^ upper case please.
> Nit. There are other occurrences of this.
You mean we can remove this log, as it's been handled well in
sctp_udp_sock_start()?

>
> > +
> >       return status;
> ...
> > +     ret = proc_dointvec(&tbl, write, buffer, lenp, ppos);
> > +     if (write && ret = 0) {
> > +             struct sock *sk = net->sctp.ctl_sock;
> > +
> > +             if (new_value > max || new_value < min)
> > +                     return -EINVAL;
> > +
> > +             net->sctp.udp_port = new_value;
> > +             sctp_udp_sock_stop(net);
>
> So, if it would be disabling the encapsulation, it shouldn't be
> calling _start() then, right? Like
>
>                 if (new_value)
>                         ret = sctp_udp_sock_start(net);
>
> Otherwise _start() here will call ..._bind() with port 0, which then
> will be a random one.
right, somehow I thought it wouldn't bind with port 0.

Thanks.
>
> > +             ret = sctp_udp_sock_start(net);
> > +             if (ret)
> > +                     net->sctp.udp_port = 0;
> > +
> > +             /* Update the value in the control socket */
> > +             lock_sock(sk);
> > +             sctp_sk(sk)->udp_port = htons(net->sctp.udp_port);
> > +             release_sock(sk);
> > +     }
> > +
> > +     return ret;
> > +}
> > +
> >  int sctp_sysctl_net_register(struct net *net)
> >  {
> >       struct ctl_table *table;
> > --
> > 2.1.0
> >
