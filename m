From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Tue, 19 May 2020 20:42:29 +0000
Subject: Re: [PATCH] sctp: check assoc before SCTP_ADDR_{MADE_PRIM,ADDED} event
Message-Id: <20200519204229.GQ2491@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <CABUN9aCXZBTdYHSK5oSVX-HAA1wTWmyBW_ked_ydsCjsV-Ckaw@mail.gmail.com>
 <20200513160116.GA2491@localhost.localdomain>
 <CABUN9aCuoA+CXLujUxXyiKWQPkwq9_eOXNqOR=MK7dPY++Fxng@mail.gmail.com>
 <20200513213230.GE2491@localhost.localdomain>
 <CABUN9aBoxXjdPk9piKAZV-2dYOCEnuXr-4H5ZVVvqeMMFRsf7A@mail.gmail.com>
In-Reply-To: <CABUN9aBoxXjdPk9piKAZV-2dYOCEnuXr-4H5ZVVvqeMMFRsf7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jonas Falkevik <jonas.falkevik@gmail.com>
Cc: Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, Xin Long <lucien.xin@gmail.com>

On Fri, May 15, 2020 at 10:30:29AM +0200, Jonas Falkevik wrote:
> On Wed, May 13, 2020 at 11:32 PM Marcelo Ricardo Leitner
> <marcelo.leitner@gmail.com> wrote:
> >
> > On Wed, May 13, 2020 at 10:11:05PM +0200, Jonas Falkevik wrote:
> > > On Wed, May 13, 2020 at 6:01 PM Marcelo Ricardo Leitner
> > > <marcelo.leitner@gmail.com> wrote:
> > > >
> > > > On Wed, May 13, 2020 at 04:52:16PM +0200, Jonas Falkevik wrote:
> > > > > Do not generate SCTP_ADDR_{MADE_PRIM,ADDED} events for SCTP_FUTURE_ASSOC assocs.
> > > >
> > > > How did you get them?
> > > >
> > >
> > > I think one case is when receiving INIT chunk in sctp_sf_do_5_1B_init().
> > > Here a closed association is created, sctp_make_temp_assoc().
> > > Which is later used when calling sctp_process_init().
> > > In sctp_process_init() one of the first things are to call
> > > sctp_assoc_add_peer()
> > > on the closed / temp assoc.
> > >
> > > sctp_assoc_add_peer() are generating the SCTP_ADDR_ADDED event on the socket
> > > for the potentially new association.
> >
> > I see, thanks. The SCTP_FUTURE_ASSOC means something different. It is
> > for setting/getting socket options that will be used for new asocs. In
> > this case, it is just a coincidence that asoc_id is not set (but
> > initialized to 0) and SCTP_FUTURE_ASSOC is also 0.
> 
> yes, you are right, I overlooked that.
> 
> > Moreso, if I didn't
> > miss anything, it would block valid events, such as those from
> >  sctp_sf_do_5_1D_ce
> >    sctp_process_init
> > because sctp_process_init will only call sctp_assoc_set_id() by its
> > end.
> 
> Do we want these events at this stage?
> Since the association is a newly established one, have the peer address changed?
> Should we enqueue these messages with sm commands instead?
> And drop them if we don't have state SCTP_STATE_ESTABLISHED?
> 
> >
> > I can't see a good reason for generating any event on temp assocs. So
> > I'm thinking the checks on this patch should be on whether the asoc is
> > a temporary one instead. WDYT?
> >
> 
> Agree, we shouldn't rely on coincidence.
> Either check temp instead or the above mentioned state?
> 
> > Then, considering the socket is locked, both code points should be
> > allocating the IDR earlier. It's expensive, yes (point being, it could
> > be avoided in case of other failures), but it should be generating
> > events with the right assoc id. Are you interested in pursuing this
> > fix as well?
> 
> Sure.
> 
> If we check temp status instead, we would need to allocate IDR earlier,
> as you mention. So that we send the notification with correct assoc id.
> 
> But shouldn't the SCTP_COMM_UP, for a newly established association, be the
> first notification event sent?
> The SCTP_COMM_UP notification is enqueued later in sctp_sf_do_5_1D_ce().

The RFC doesn't mention any specific ordering for them, but it would
make sense. Reading the FreeBSD code now (which I consider a reference
implementation), it doesn't raise these notifications from
INIT_ACK/COOKIE_ECHO at all. The only trigger for SCTP_ADDR_ADDED
event is ASCONF ADD command itself. So these are extra in Linux, and
I'm afraid we got to stick with them.

Considering the error handling it already has, looks like the
reordering is feasible and welcomed. I'm thinking the temp check and
reordering is the best way forward here.

Thoughts? Neil? Xin? The assoc_id change might be considered an UAPI
breakage.

Thanks,
Marcelo
