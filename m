From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri, 25 Oct 2019 03:22:06 +0000
Subject: Re: [PATCHv3 net-next 1/5] sctp: add SCTP_ADDR_POTENTIALLY_FAILED notification
Message-Id: <20191025032206.GB4326@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1571033544.git.lucien.xin@gmail.com>
 <7d08b42f4c1480caa855776d92331fe9beed001d.1571033544.git.lucien.xin@gmail.com>
 <fb115b1444764b3eacdf69ebd9cf9681@AcuMS.aculab.com>
 <CADvbK_eQrXs4VC+OgsLibA-q2VkkdKXTK+meaRGbxJDK41aLKg@mail.gmail.com>
In-Reply-To: <CADvbK_eQrXs4VC+OgsLibA-q2VkkdKXTK+meaRGbxJDK41aLKg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: David Laight <David.Laight@aculab.com>, network dev <netdev@vger.kernel.org>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, Neil Horman <nhorman@tuxdriver.com>, "davem@davemloft.net" <davem@davemloft.net>

On Sat, Oct 19, 2019 at 04:55:01PM +0800, Xin Long wrote:
> > > @@ -801,14 +801,6 @@ void sctp_assoc_control_transport(struct sctp_association *asoc,
> > >                       spc_state = SCTP_ADDR_CONFIRMED;
> > >               else
> > >                       spc_state = SCTP_ADDR_AVAILABLE;
> > > -             /* Don't inform ULP about transition from PF to
> > > -              * active state and set cwnd to 1 MTU, see SCTP
> > > -              * Quick failover draft section 5.1, point 5
> > > -              */
> > > -             if (transport->state = SCTP_PF) {
> > > -                     ulp_notify = false;
> > > -                     transport->cwnd = asoc->pathmtu;
> > > -             }
> >
> > This is wrong.
> > If the old state is PF and the application hasn't exposed PF the event should be
> > ignored.
> yeps, in Patch 2/5:
> +               if (transport->state = SCTP_PF &&
> +                   asoc->pf_expose != SCTP_PF_EXPOSE_ENABLE)
> +                       ulp_notify = false;
> +               else if (transport->state = SCTP_UNCONFIRMED &&
> +                        error = SCTP_HEARTBEAT_SUCCESS)
>                         spc_state = SCTP_ADDR_CONFIRMED;
>                 else
>                         spc_state = SCTP_ADDR_AVAILABLE;

Right, yet for one bisecting the kernel, a checkout on this patch will
see this change regardless of patch 2. Patches 1 and 2 could be
swapped to avoid this situation.

> 
> >
> > >               transport->state = SCTP_ACTIVE;
> > >               break;
> > >
> > > @@ -817,19 +809,18 @@ void sctp_assoc_control_transport(struct sctp_association *asoc,
> > >                * to inactive state.  Also, release the cached route since
> > >                * there may be a better route next time.
> > >                */
> > > -             if (transport->state != SCTP_UNCONFIRMED)
> > > +             if (transport->state != SCTP_UNCONFIRMED) {
> > >                       transport->state = SCTP_INACTIVE;
> > > -             else {
> > > +                     spc_state = SCTP_ADDR_UNREACHABLE;
> > > +             } else {
> > >                       sctp_transport_dst_release(transport);
> > >                       ulp_notify = false;
> > >               }
> > > -
> > > -             spc_state = SCTP_ADDR_UNREACHABLE;
> > >               break;
> > >
> > >       case SCTP_TRANSPORT_PF:
> > >               transport->state = SCTP_PF;
> > > -             ulp_notify = false;
> >
> > Again the event should be supressed if PF isn't exposed.
> it will be suppressed after Patch 2/5:
> +               if (asoc->pf_expose != SCTP_PF_EXPOSE_ENABLE)
> +                       ulp_notify = false;
> +               else
> +                       spc_state = SCTP_ADDR_POTENTIALLY_FAILED;
>                 break;

Same here.

> 
> >
> > > +             spc_state = SCTP_ADDR_POTENTIALLY_FAILED;
> > >               break;
> > >
> > >       default:
> > > --
> > > 2.1.0
> >
> > I also haven't spotted where the test that the application has actually enabled
> > state transition events is in the code.
> all events will be created, but dropped in sctp_ulpq_tail_event() when trying
> to deliver up:
> 
>         /* Check if the user wishes to receive this event.  */
>         if (!sctp_ulpevent_is_enabled(event, ulpq->asoc->subscribe))
>                 goto out_free;
> 
> > I'd have thought it would be anything is built and allocated.
> >
> >         David
> >
> > -
> > Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> > Registration No: 1397386 (Wales)
> >
> 
