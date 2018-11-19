From: Neil Horman <nhorman@tuxdriver.com>
Date: Mon, 19 Nov 2018 17:26:36 +0000
Subject: Re: [PATCH net] sctp: not allow to set asoc prsctp_enable by sockopt
Message-Id: <20181119172636.GA7622@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <7417f2d10de933afb69b832d9a30a210f42a16bb.1542280468.git.lucien.xin@gmail.com>
 <20181115172221.GA3601@localhost.localdomain>
 <20181115214310.GA8505@neilslaptop.think-freely.org>
 <20181115222536.GB31918@localhost.localdomain>
 <20181115232540.GA7442@hmswarspite.think-freely.org>
 <20181115234101.GC31918@localhost.localdomain>
 <20181116151216.GA12928@neilslaptop.think-freely.org>
 <CADvbK_dkuMn_v_0vpvB9VJjUUsa66Po44EDevEzqACjveY94Tg@mail.gmail.com>
 <20181119041450.GB3601@localhost.localdomain>
In-Reply-To: <20181119041450.GB3601@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: Xin Long <lucien.xin@gmail.com>, network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem <davem@davemloft.net>

On Mon, Nov 19, 2018 at 02:14:50AM -0200, Marcelo Ricardo Leitner wrote:
> On Sun, Nov 18, 2018 at 04:02:25PM +0900, Xin Long wrote:
> > On Sat, Nov 17, 2018 at 12:12 AM Neil Horman <nhorman@tuxdriver.com> wrote:
> > >
> > > On Thu, Nov 15, 2018 at 09:41:01PM -0200, Marcelo Ricardo Leitner wrote:
> > > > [ re-sending, without html this time ]
> > > >
> > > > On Thu, Nov 15, 2018, 15:26 Neil Horman <nhorman@tuxdriver.com wrote:
> > > >
> > > > > On Thu, Nov 15, 2018 at 08:25:36PM -0200, Marcelo Ricardo Leitner wrote:
> > > > > > On Thu, Nov 15, 2018 at 04:43:10PM -0500, Neil Horman wrote:
> > > > > > > On Thu, Nov 15, 2018 at 03:22:21PM -0200, Marcelo Ricardo Leitner
> > > > > wrote:
> > > > > > > > On Thu, Nov 15, 2018 at 07:14:28PM +0800, Xin Long wrote:
> > > > > > > > > As rfc7496#section4.5 says about SCTP_PR_SUPPORTED:
> > > > > > > > >
> > > > > > > > >    This socket option allows the enabling or disabling of the
> > > > > > > > >    negotiation of PR-SCTP support for future associations.  For
> > > > > existing
> > > > > > > > >    associations, it allows one to query whether or not PR-SCTP
> > > > > support
> > > > > > > > >    was negotiated on a particular association.
> > > > > > > > >
> > > > > > > > > It means only sctp sock's prsctp_enable can be set.
> > > > > > > > >
> > > > > > > > > Note that for the limitation of SCTP_{CURRENT|ALL}_ASSOC, we will
> > > > > > > > > add it when introducing SCTP_{FUTURE|CURRENT|ALL}_ASSOC for linux
> > > > > > > > > sctp in another patchset.
> > > > > > > > >
> > > > > > > > > Fixes: 28aa4c26fce2 ("sctp: add SCTP_PR_SUPPORTED on sctp sockopt")
> > > > > > > > > Reported-by: Ying Xu <yinxu@redhat.com>
> > > > > > > > > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > > > > > > > > ---
> > > > > > > > >  net/sctp/socket.c | 13 +++----------
> > > > > > > > >  1 file changed, 3 insertions(+), 10 deletions(-)
> > > > > > > > >
> > > > > > > > > diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> > > > > > > > > index 739f3e5..e9b8232 100644
> > > > > > > > > --- a/net/sctp/socket.c
> > > > > > > > > +++ b/net/sctp/socket.c
> > > > > > > > > @@ -3940,7 +3940,6 @@ static int
> > > > > sctp_setsockopt_pr_supported(struct sock *sk,
> > > > > > > > >                                         unsigned int optlen)
> > > > > > > > >  {
> > > > > > > > >         struct sctp_assoc_value params;
> > > > > > > > > -       struct sctp_association *asoc;
> > > > > > > > >         int retval = -EINVAL;
> > > > > > > > >
> > > > > > > > >         if (optlen != sizeof(params))
> > > > > > > > > @@ -3951,16 +3950,10 @@ static int
> > > > > sctp_setsockopt_pr_supported(struct sock *sk,
> > > > > > > > >                 goto out;
> > > > > > > > >         }
> > > > > > > > >
> > > > > > > > > -       asoc = sctp_id2assoc(sk, params.assoc_id);
> > > > > > > > > -       if (asoc) {
> > > > > > > > > -               asoc->prsctp_enable = !!params.assoc_value;
> > > > > > > > > -       } else if (!params.assoc_id) {
> > > > > > > > > -               struct sctp_sock *sp = sctp_sk(sk);
> > > > > > > > > -
> > > > > > > > > -               sp->ep->prsctp_enable = !!params.assoc_value;
> > > > > > > > > -       } else {
> > > > > > > > > +       if (sctp_style(sk, UDP) && sctp_id2assoc(sk,
> > > > > params.assoc_id))
> > > > > > > >
> > > > > > > > This would allow using a non-existent assoc id on UDP-style sockets
> > > > > to
> > > > > > > > set it at the socket, which is not expected. It should be more like:
> > > > > > > >
> > > > > > > > + if (sctp_style(sk, UDP) && params.assoc_id)
> > > > > > > How do you see that to be the case? sctp_id2assoc will return NULL if
> > > > > an
> > > > > > > association isn't found, so the use of sctp_id2assoc should work just
> > > > > fine.
> > > > > >
> > > > > > Right, it will return NULL, and because of that it won't bail out as
> > > > > > it should and will adjust the socket config instead.
> > > > > >
> > > > >
> > > > > Oh, duh, you're absolutely right, NULL will evalutate to false there, and
> > > > > skip
> > > > > the conditional goto out;
> > > > >
> > > > > that said, It would make more sense to me to just change the sense of the
> > > > > second
> > > > > condition to !sctp_id2assoc(sk, params.assoc_id), so that we goto out if no
> > > > > association is found.  it still seems a
> > > >
> > > >
> > > > That would break setting it on the socket without an assoc so far.
> > > >
> > > ok, yes, I see what xin is getting at now.  The RFC indicates that the
> > > setsockopt method for this socket option is meant to set the prsctp enabled
> > > value on _future_ associations, implying that we should not operate at all on
> > > already existing associations (i.e. we should ignore the assoc_id in the passed
> > > in structure and only operate on the socket).  That said, heres the entire text
> > > of the RFC section:
> > >
> > > 4.5.  Socket Option for Getting and Setting the PR-SCTP Support
> > >       (SCTP_PR_SUPPORTED)
> > >
> > >    This socket option allows the enabling or disabling of the
> > >    negotiation of PR-SCTP support for future associations.  For existing
> > >    associations, it allows one to query whether or not PR-SCTP support
> > >    was negotiated on a particular association.
> > >
> > >    Whether or not PR-SCTP is enabled by default is implementation
> > >    specific.
> > >
> > >    This socket option uses IPPROTO_SCTP as its level and
> > >    SCTP_PR_SUPPORTED as its name.  It can be used with getsockopt() and
> > >    setsockopt().  The socket option value uses the following structure
> > >    defined in [RFC6458]:
> > >
> > >    struct sctp_assoc_value {
> > >      sctp_assoc_t assoc_id;
> > >      uint32_t assoc_value;
> > >    };
> > >
> > >    assoc_id:  This parameter is ignored for one-to-one style sockets.
> > >       For one-to-many style sockets, this parameter indicates upon which
> > >       association the user is performing an action.  The special
> > >       sctp_assoc_t SCTP_FUTURE_ASSOC can also be used; it is an error to
> > >       use SCTP_{CURRENT|ALL}_ASSOC in assoc_id.
> > >
> > >    assoc_value:  A non-zero value encodes the enabling of PR-SCTP,
> > >       whereas a value of 0 encodes the disabling of PR-SCTP.
> > >
> > >    sctp_opt_info() needs to be extended to support SCTP_PR_SUPPORTED
> > >
> > > My read of this suggests that for setting the prsctp_enabled flag, we only need
> > > a valid socket (the presence or lack of associations is irrelevant), its only
> > > for the getsockopt method that we need to specify an assoc_id, as the getsockopt
> > > method operates on associations, while the setsockopt method operates at the
> > > socket level (to be inherited as association init).
> > >
> > > Given that, I'd argue that we can skip the check entirely, and just assign
> > > sctp_sock(sk)->prsctp_enabled = !!param.assoc_value
> > >
> > > directly.
> > RFC seems to have no clear demands for this, I will just drop the check
> > in this patch, thanks.
> 
> RFC may not have clear demands, but I still don't see a reason for not
> rejecting bogus arguments that can potentially lead to confusion.
> We usually do argument parsing in the other way around: restrict as
> much as possible, and relax when needed. That avoids applications to
> build bad behaviors that we would end up having to cope with it.
> Anyhow, I won't oppose to this any further.
> 

I think we could make the same argument about the assoc_value field on the
getsockopt method.  Its an output in that path, but we make no checks regarding
its input value.

It seems the long and short of it here is that this interface is overloaded for
multiple functions and some values are simply don't care states in certain
paths.  What we should do is document it as such in a subsequent version of the
RFC and any related man pages.  What we shouldn't do is impose artificial
constraints on those don't care values where none need to exist.

Neil

> @Dave: please give me till Tue to review the other patches. I'm
> traveling and will be offline till Mon night. Thanks.
> 
>   Marcelo
> 
