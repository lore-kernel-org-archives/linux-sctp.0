From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 30 Jan 2019 07:03:01 +0000
Subject: Re: [PATCH net-next 02/24] sctp: use SCTP_FUTURE_ASSOC for SCTP_PEER_ADDR_PARAMS sockopt
Message-Id: <CADvbK_fPbz+Rso6ADXh2PpUYoMRtHnbJdu4VygckAjDiW1MzSw@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1548659198.git.lucien.xin@gmail.com> <bf66a45aa6763646c07e1b8be102466f07fc1648.1548659198.git.lucien.xin@gmail.com>
 <20190129212508.GB2592@neilslaptop.think-freely.org>
In-Reply-To: <20190129212508.GB2592@neilslaptop.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Neil Horman <nhorman@tuxdriver.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, davem <davem@davemloft.net>

On Wed, Jan 30, 2019 at 5:25 AM Neil Horman <nhorman@tuxdriver.com> wrote:
>
> On Mon, Jan 28, 2019 at 03:08:24PM +0800, Xin Long wrote:
> > Check with SCTP_FUTURE_ASSOC instead in
> > sctp_/setgetsockopt_peer_addr_params, it's compatible with 0.
> >
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > ---
> >  net/sctp/socket.c | 18 ++++++++++--------
> >  1 file changed, 10 insertions(+), 8 deletions(-)
> >
> > diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> > index a52d132..4c43b95 100644
> > --- a/net/sctp/socket.c
> > +++ b/net/sctp/socket.c
> > @@ -2750,12 +2750,13 @@ static int sctp_setsockopt_peer_addr_params(struct sock *sk,
> >                       return -EINVAL;
> >       }
> >
> > -     /* Get association, if assoc_id != 0 and the socket is a one
> > -      * to many style socket, and an association was not found, then
> > -      * the id was invalid.
> > +     /* Get association, if assoc_id != SCTP_FUTURE_ASSOC and the
> > +      * socket is a one to many style socket, and an association
> > +      * was not found, then the id was invalid.
> >        */
> >       asoc = sctp_id2assoc(sk, params.spp_assoc_id);
> > -     if (!asoc && params.spp_assoc_id && sctp_style(sk, UDP))
> > +     if (!asoc && params.spp_assoc_id != SCTP_FUTURE_ASSOC &&
> Sorry to follow up, but I misspoke in my previous email, I should have said, why
> do we only allow future associations as the only special case association id
> here?  Since the function is meant to set a specific association id, it seems to
> me that you would want to:
>
> a) allow setting of a specific id
> b) allow setting of all association ids on the socket
> (SCTP_CURRENT_ASSOC)
> c) allow recording of a set of params to apply to all current and future
> associations (FUTURE/ALL).
>
> (a) is already handled clearly, but (b) and (c) require more work on this
> function than just checking association id on entry.
Hi, Neil,

Note that not all sockopts support both of them, like
we don't allow some sockopt to be applied to current assocs.
and we don't allow some to be applied to future assocs.

SCTP_FUTURE_ASSOC means sock's xxxx only
SCTP_CURRENT_ASSOC means all sock->asocs' xxxx only

If we only check assoc_id != SCTP_FUTURE_ASSOC, it means this
sockopt doesn't support for all sock->asocs xxxx setting,
or getting (like all sockopts getting).
If we only check assoc_id != SCTP_CURRENT_ASSOC, it means this
sockopt doesn't support for sock's xxxx setting (like Patch 11)

As for SCTP_ALL_ASSOC, it means both of sock's and sock->asocs
xxxx, not either of them. So we don't allow it in here.

As you can see, in this patchset:
1. for sockopt setting:
   these who only support FUTURE will check SCTP_FUTURE_ASSOC, like Patch 2-10.
   these who only support CURRENT will check SCTP_CURRENT_ASSOC, like Patch 11.
   these who support both FUTURE and CURRENT will check assoc_id >
SCTP_ALL_ASSOC, like Patch 12-24.
2. for sockopt getting:
   all sockopts will check SCTP_FUTURE_ASSOC. (as it's impossible to
get all sock->asocs' xxxx)

>
> I think this comment may apply to all the socket option functions
>
> > +         sctp_style(sk, UDP))
> >               return -EINVAL;
> >
> >       /* Heartbeat demand can only be sent on a transport or
> > @@ -5676,12 +5677,13 @@ static int sctp_getsockopt_peer_addr_params(struct sock *sk, int len,
> >               }
> >       }
> >
> > -     /* Get association, if assoc_id != 0 and the socket is a one
> > -      * to many style socket, and an association was not found, then
> > -      * the id was invalid.
> > +     /* Get association, if assoc_id != SCTP_FUTURE_ASSOC and the
> > +      * socket is a one to many style socket, and an association
> > +      * was not found, then the id was invalid.
> >        */
> >       asoc = sctp_id2assoc(sk, params.spp_assoc_id);
> > -     if (!asoc && params.spp_assoc_id && sctp_style(sk, UDP)) {
> > +     if (!asoc && params.spp_assoc_id != SCTP_FUTURE_ASSOC &&
> > +         sctp_style(sk, UDP)) {
> >               pr_debug("%s: failed no association\n", __func__);
> >               return -EINVAL;
> >       }
> > --
> > 2.1.0
> >
> >
