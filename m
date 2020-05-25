From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 25 May 2020 16:17:55 +0000
Subject: Re: [PATCH] sctp: check assoc before SCTP_ADDR_{MADE_PRIM,ADDED} event
Message-Id: <CADvbK_fGCKg1jB86MTJmkPXaLmdDV191vpgfs1YomJ5_0zgONA@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CABUN9aCXZBTdYHSK5oSVX-HAA1wTWmyBW_ked_ydsCjsV-Ckaw@mail.gmail.com>
 <20200513160116.GA2491@localhost.localdomain> <CABUN9aCuoA+CXLujUxXyiKWQPkwq9_eOXNqOR=MK7dPY++Fxng@mail.gmail.com>
 <20200513213230.GE2491@localhost.localdomain> <CABUN9aBoxXjdPk9piKAZV-2dYOCEnuXr-4H5ZVVvqeMMFRsf7A@mail.gmail.com>
 <20200519204229.GQ2491@localhost.localdomain> <CABUN9aD85O3mF8j72QfrC8vbXPzj5Q=L801t2M6XsbDHn+9D1A@mail.gmail.com>
 <CADvbK_fpZWexYckNtmsEatb+JU_EW4=Xn9OpcL=Tk-a8odDHuw@mail.gmail.com> <20200525131036.GA2491@localhost.localdomain>
In-Reply-To: <20200525131036.GA2491@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: Jonas Falkevik <jonas.falkevik@gmail.com>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, linux-sctp@vger.kernel.org, network dev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

On Mon, May 25, 2020 at 9:10 PM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> On Mon, May 25, 2020 at 04:42:16PM +0800, Xin Long wrote:
> > On Sat, May 23, 2020 at 8:04 PM Jonas Falkevik <jonas.falkevik@gmail.com> wrote:
> > >
> > > On Tue, May 19, 2020 at 10:42 PM Marcelo Ricardo Leitner
> > > <marcelo.leitner@gmail.com> wrote:
> > > >
> > > > On Fri, May 15, 2020 at 10:30:29AM +0200, Jonas Falkevik wrote:
> > > > > On Wed, May 13, 2020 at 11:32 PM Marcelo Ricardo Leitner
> > > > > <marcelo.leitner@gmail.com> wrote:
> > > > > >
> > > > > > On Wed, May 13, 2020 at 10:11:05PM +0200, Jonas Falkevik wrote:
> > > > > > > On Wed, May 13, 2020 at 6:01 PM Marcelo Ricardo Leitner
> > > > > > > <marcelo.leitner@gmail.com> wrote:
> > > > > > > >
> > > > > > > > On Wed, May 13, 2020 at 04:52:16PM +0200, Jonas Falkevik wrote:
> > > > > > > > > Do not generate SCTP_ADDR_{MADE_PRIM,ADDED} events for SCTP_FUTURE_ASSOC assocs.
> > > > > > > >
> > > > > > > > How did you get them?
> > > > > > > >
> > > > > > >
> > > > > > > I think one case is when receiving INIT chunk in sctp_sf_do_5_1B_init().
> > > > > > > Here a closed association is created, sctp_make_temp_assoc().
> > > > > > > Which is later used when calling sctp_process_init().
> > > > > > > In sctp_process_init() one of the first things are to call
> > > > > > > sctp_assoc_add_peer()
> > > > > > > on the closed / temp assoc.
> > > > > > >
> > > > > > > sctp_assoc_add_peer() are generating the SCTP_ADDR_ADDED event on the socket
> > > > > > > for the potentially new association.
> > > > > >
> > > > > > I see, thanks. The SCTP_FUTURE_ASSOC means something different. It is
> > > > > > for setting/getting socket options that will be used for new asocs. In
> > > > > > this case, it is just a coincidence that asoc_id is not set (but
> > > > > > initialized to 0) and SCTP_FUTURE_ASSOC is also 0.
> > > > >
> > > > > yes, you are right, I overlooked that.
> > > > >
> > > > > > Moreso, if I didn't
> > > > > > miss anything, it would block valid events, such as those from
> > > > > >  sctp_sf_do_5_1D_ce
> > > > > >    sctp_process_init
> > > > > > because sctp_process_init will only call sctp_assoc_set_id() by its
> > > > > > end.
> > > > >
> > > > > Do we want these events at this stage?
> > > > > Since the association is a newly established one, have the peer address changed?
> > > > > Should we enqueue these messages with sm commands instead?
> > > > > And drop them if we don't have state SCTP_STATE_ESTABLISHED?
> > > > >
> > > > > >
> > > > > > I can't see a good reason for generating any event on temp assocs. So
> > > > > > I'm thinking the checks on this patch should be on whether the asoc is
> > > > > > a temporary one instead. WDYT?
> > > > > >
> > > > >
> > > > > Agree, we shouldn't rely on coincidence.
> > > > > Either check temp instead or the above mentioned state?
> > > > >
> > > > > > Then, considering the socket is locked, both code points should be
> > > > > > allocating the IDR earlier. It's expensive, yes (point being, it could
> > > > > > be avoided in case of other failures), but it should be generating
> > > > > > events with the right assoc id. Are you interested in pursuing this
> > > > > > fix as well?
> > > > >
> > > > > Sure.
> > > > >
> > > > > If we check temp status instead, we would need to allocate IDR earlier,
> > > > > as you mention. So that we send the notification with correct assoc id.
> > > > >
> > > > > But shouldn't the SCTP_COMM_UP, for a newly established association, be the
> > > > > first notification event sent?
> > > > > The SCTP_COMM_UP notification is enqueued later in sctp_sf_do_5_1D_ce().
> > > >
> > > > The RFC doesn't mention any specific ordering for them, but it would
> > > > make sense. Reading the FreeBSD code now (which I consider a reference
> > > > implementation), it doesn't raise these notifications from
> > > > INIT_ACK/COOKIE_ECHO at all. The only trigger for SCTP_ADDR_ADDED
> > > > event is ASCONF ADD command itself. So these are extra in Linux, and
> > > > I'm afraid we got to stick with them.
> > > >
> > > > Considering the error handling it already has, looks like the
> > > > reordering is feasible and welcomed. I'm thinking the temp check and
> > > > reordering is the best way forward here.
> > > >
> > > > Thoughts? Neil? Xin? The assoc_id change might be considered an UAPI
> > > > breakage.
> > >
> > > Some order is mentioned in RFC 6458 Chapter 6.1.1.
> > >
> > >       SCTP_COMM_UP:  A new association is now ready, and data may be
> > >          exchanged with this peer.  When an association has been
> > >          established successfully, this notification should be the
> > >          first one.
>
> Oh, nice finding.
>
> > If this is true, as SCTP_COMM_UP event is always followed by state changed
> > to ESTABLISHED. So I'm thinking to NOT make addr events by checking the
> > state:
> >
> > @@ -343,6 +343,9 @@ void sctp_ulpevent_nofity_peer_addr_change(struct
> > sctp_transport *transport,
> >         struct sockaddr_storage addr;
> >         struct sctp_ulpevent *event;
> >
> > +       if (asoc->state < SCTP_STATE_ESTABLISHED)
> > +               return;
> > +
> >         memset(&addr, 0, sizeof(struct sockaddr_storage));
> >         memcpy(&addr, &transport->ipaddr, transport->af_specific->sockaddr_len);
>
> With the above said, yep. Thanks.
>
> >
> > It's not easy to completely do assoc_id change/event reordering/temp check.
> > As:
>
> Temp check should be fine, but agree re the others. Anyhow, the above
> will be good already. :-)
Hi Jonas,

What do you think? If you agree, can you please continue to go with it
after testing?

Thanks.

>
> >
> > 1. sctp_assoc_add_peer() is called in quite a few places where assoc_id is
> >    not set.
> > 2. it's almost impossible to move SCTP_ADDR_ADDED from sctp_assoc_add_peer()
> >    after SCTP_COMM_UP.
> >
> > >
> > > I can make a patch with a check on temp and make COMM_UP event first.
> > > Currently the COMM_UP event is enqueued via commands
> > > while the SCTP_ADDR_ADDED event is enqueued directly.
> > >
> > > sctp_add_cmd_sf(commands, SCTP_CMD_EVENT_ULP, SCTP_ULPEVENT(ev));
> > > vs.
> > > asoc->stream.si->enqueue_event(&asoc->ulpq, event);
> > >
> > > Do you want me to change to use commands instead of enqueing?
> > > Or should we enqueue the COMM_UP event directly?
> > >
> > > -Jonas
