From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 16 Nov 2018 06:42:08 +0000
Subject: Re: [PATCH net] sctp: not allow to set asoc prsctp_enable by sockopt
Message-Id: <CADvbK_c4X9KUb6A6x4KJFFd70PnmicKg+jO-F55-_dQ8rBkxsA@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <7417f2d10de933afb69b832d9a30a210f42a16bb.1542280468.git.lucien.xin@gmail.com>
 <20181115172221.GA3601@localhost.localdomain>
In-Reply-To: <20181115172221.GA3601@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem <davem@davemloft.net>, Neil Horman <nhorman@tuxdriver.com>

On Fri, Nov 16, 2018 at 2:22 AM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> On Thu, Nov 15, 2018 at 07:14:28PM +0800, Xin Long wrote:
> > As rfc7496#section4.5 says about SCTP_PR_SUPPORTED:
> >
> >    This socket option allows the enabling or disabling of the
> >    negotiation of PR-SCTP support for future associations.  For existing
> >    associations, it allows one to query whether or not PR-SCTP support
> >    was negotiated on a particular association.
> >
> > It means only sctp sock's prsctp_enable can be set.
> >
> > Note that for the limitation of SCTP_{CURRENT|ALL}_ASSOC, we will
> > add it when introducing SCTP_{FUTURE|CURRENT|ALL}_ASSOC for linux
> > sctp in another patchset.
> >
> > Fixes: 28aa4c26fce2 ("sctp: add SCTP_PR_SUPPORTED on sctp sockopt")
> > Reported-by: Ying Xu <yinxu@redhat.com>
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > ---
> >  net/sctp/socket.c | 13 +++----------
> >  1 file changed, 3 insertions(+), 10 deletions(-)
> >
> > diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> > index 739f3e5..e9b8232 100644
> > --- a/net/sctp/socket.c
> > +++ b/net/sctp/socket.c
> > @@ -3940,7 +3940,6 @@ static int sctp_setsockopt_pr_supported(struct sock *sk,
> >                                       unsigned int optlen)
> >  {
> >       struct sctp_assoc_value params;
> > -     struct sctp_association *asoc;
> >       int retval = -EINVAL;
> >
> >       if (optlen != sizeof(params))
> > @@ -3951,16 +3950,10 @@ static int sctp_setsockopt_pr_supported(struct sock *sk,
> >               goto out;
> >       }
> >
> > -     asoc = sctp_id2assoc(sk, params.assoc_id);
> > -     if (asoc) {
> > -             asoc->prsctp_enable = !!params.assoc_value;
> > -     } else if (!params.assoc_id) {
> > -             struct sctp_sock *sp = sctp_sk(sk);
> > -
> > -             sp->ep->prsctp_enable = !!params.assoc_value;
> > -     } else {
> > +     if (sctp_style(sk, UDP) && sctp_id2assoc(sk, params.assoc_id))
I got this semantic from BSD's SCTP_PR_SUPPORTED sockopt:
                        SCTP_FIND_STCB(inp, stcb, av->assoc_id);

                        if (stcb) {
                                SCTP_LTRACE_ERR_RET(...);
                                error = EINVAL;
                                SCTP_TCB_UNLOCK(stcb);
                        } else {
                                ...
                        }

>
> This would allow using a non-existent assoc id on UDP-style sockets to
> set it at the socket, which is not expected. It should be more like:
>
> +       if (sctp_style(sk, UDP) && params.assoc_id)
This way is more strict, but it seems reasonable.

When a user sets params.assoc_id for UDP type socket, it should be
thought as he WANTs to apply this on assoc, which is not allowed here.
