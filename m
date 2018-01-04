From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Thu, 04 Jan 2018 11:23:29 +0000
Subject: Re: [PATCH net v2 1/2] sctp: do not retransmit upon FragNeeded if PMTU discovery is disabled
Message-Id: <20180104112329.GB727@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1515020059.git.marcelo.leitner@gmail.com>
 <f96c4b84a1d19d16424cca1eaafc382d4bcd313b.1515020059.git.marcelo.leitner@gmail.com>
 <CADvbK_crQBvi=T3vXN9vOEZov99Yp=VGqkE0fjL0mP7PgvuuEg@mail.gmail.com>
In-Reply-To: <CADvbK_crQBvi=T3vXN9vOEZov99Yp=VGqkE0fjL0mP7PgvuuEg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>

On Thu, Jan 04, 2018 at 12:52:32PM +0800, Xin Long wrote:
> On Thu, Jan 4, 2018 at 6:59 AM, Marcelo Ricardo Leitner
> <marcelo.leitner@gmail.com> wrote:
> > Currently, if PMTU discovery is disabled on a given transport, but the
> > configured value is higher than the actual PMTU, it is likely that we
> > will get some icmp Frag Needed. The issue is, if PMTU discovery is
> > disabled, we won't update the information and will issue a
> > retransmission immediately, which may very well trigger another ICMP,
> > and another retransmission, leading to a loop.
> >
> > The fix is to simply not trigger immediate retransmissions if PMTU
> > discovery is disabled on the given transport.
> >
> > Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> > ---
> >  net/sctp/input.c | 17 +++++++++++------
> >  1 file changed, 11 insertions(+), 6 deletions(-)
> >
> > diff --git a/net/sctp/input.c b/net/sctp/input.c
> > index 621b5ca3fd1c17c3d7ef7bb1c7677ab98cebbe77..4a8e76f4834c90de9398455862423e598b8354a7 100644
> > --- a/net/sctp/input.c
> > +++ b/net/sctp/input.c
> > @@ -399,13 +399,18 @@ void sctp_icmp_frag_needed(struct sock *sk, struct sctp_association *asoc,
> >                 return;
> >         }
> >
> > -       if (t->param_flags & SPP_PMTUD_ENABLE) {
> > -               /* Update transports view of the MTU */
> > -               sctp_transport_update_pmtu(t, pmtu);
> > +       if (!(t->param_flags & SPP_PMTUD_ENABLE))
> > +               /* We can't allow retransmitting in such case, as the
> > +                * retransmission would be sized just as before, and thus we
> > +                * would get another icmp, and retransmit again.
> > +                */
> > +               return;
> >
> > -               /* Update association pmtu. */
> > -               sctp_assoc_sync_pmtu(asoc);
> > -       }
> > +       /* Update transports view of the MTU */
> > +       sctp_transport_update_pmtu(t, pmtu);
> > +
> > +       /* Update association pmtu. */
> > +       sctp_assoc_sync_pmtu(asoc);
> >
> >         /* Retransmit with the new pmtu setting.
> >          * Normally, if PMTU discovery is disabled, an ICMP Fragmentation
> > --
> > 2.14.3
> >
> 
> commit 52ccb8e90c0ace233b8b740f2fc5de0dbd706b27
> Author: Frank Filz <ffilz@us.ibm.com>
> Date:   Thu Dec 22 11:36:46 2005 -0800
> 
>     [SCTP]: Update SCTP_PEER_ADDR_PARAMS socket option to the latest api draft.
> 
> It seemed intended to move sctp_retransmit out of 'if (SPP_PMTUD_ENABLE) {}'
> on the above commit with some notes:

Good point.

> 
>         /* Retransmit with the new pmtu setting.
>          * Normally, if PMTU discovery is disabled, an ICMP Fragmentation
>          * Needed will never be sent, but if a message was sent before
>          * PMTU discovery was disabled that was larger than the PMTU, it
>          * would not be fragmented, so it must be re-transmitted fragmented.
>          */
> 
> But this patch is equivalent to move it back into 'if (SPP_PMTUD_ENABLE) {}'.
> will there be no regression caused?

I don't think this comment has been effective because the function
starts with:

void sctp_icmp_frag_needed(struct sock *sk, struct sctp_association *asoc,
                           struct sctp_transport *t, __u32 pmtu)
{
        if (!t || (t->pathmtu <= pmtu))
                return;

So if the application managed to adjust pmtu after sending some data,
t->pathmtu will fit this check and nothing would be done anyway.

commit 91bd6b1e030266cf87d3f567b49f0fa60a7318ba
Author: Wei Yongjun <yjwei@cn.fujitsu.com>
Date:   Thu Oct 23 00:59:52 2008 -0700

    sctp: Drop ICMP packet too big message with MTU larger than
    current PMTU

I guess I should have removed this comment too. WDYT?
I'll prepare a v3 meanwhile.
