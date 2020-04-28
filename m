From: Neil Horman <nhorman@tuxdriver.com>
Date: Tue, 28 Apr 2020 23:59:36 +0000
Subject: Re: [PATCH] sctp: Don't add the shutdown timer if its already been added
Message-Id: <20200428235936.GA1869802@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <1457467429-31904-1-git-send-email-nhorman@tuxdriver.com>
In-Reply-To: <1457467429-31904-1-git-send-email-nhorman@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org

On Tue, Apr 28, 2020 at 04:01:35PM -0300, Marcelo Ricardo Leitner wrote:
> On Tue, Apr 28, 2020 at 12:58:48PM -0400, Neil Horman wrote:
> > This BUG halt was reported a while back, but the patch somehow got
> > missed:
> >=20
> > PID: 2879   TASK: c16adaa0  CPU: 1   COMMAND: "sctpn"
> >  #0 [f418dd28] crash_kexec at c04a7d8c
> >  #1 [f418dd7c] oops_end at c0863e02
> >  #2 [f418dd90] do_invalid_op at c040aaca
> >  #3 [f418de28] error_code (via invalid_op) at c08631a5
> >     EAX: f34baac0  EBX: 00000090  ECX: f418deb0  EDX: f5542950  EBP: 00=
000000
> >     DS:  007b      ESI: f34ba800  ES:  007b      EDI: f418dea0  GS:  00=
e0
> >     CS:  0060      EIP: c046fa5e  ERR: ffffffff  EFLAGS: 00010286
> >  #4 [f418de5c] add_timer at c046fa5e
> >  #5 [f418de68] sctp_do_sm at f8db8c77 [sctp]
> >  #6 [f418df30] sctp_primitive_SHUTDOWN at f8dcc1b5 [sctp]
> >  #7 [f418df48] inet_shutdown at c080baf9
> >  #8 [f418df5c] sys_shutdown at c079eedf
> >  #9 [f418df70] sys_socketcall at c079fe88
> >     EAX: ffffffda  EBX: 0000000d  ECX: bfceea90  EDX: 0937af98
> >     DS:  007b      ESI: 0000000c  ES:  007b      EDI: b7150ae4
> >     SS:  007b      ESP: bfceea7c  EBP: bfceeaa8  GS:  0033
> >     CS:  0073      EIP: b775c424  ERR: 00000066  EFLAGS: 00000282
> >=20
> > It appears that the side effect that starts the shutdown timer was proc=
essed
> > multiple times, which can happen as multiple paths can trigger it.  Thi=
s of
> > course leads to the BUG halt in add_timer getting called.
> >=20
> > Fix seems pretty straightforward, just check before the timer is added =
if its
> > already been started.  If it has mod the timer instead to min(current
> > expiration, new expiration)
> >=20
> > Its been tested but not confirmed to fix the problem, as the issue has =
only
> > occured in production environments where test kernels are enjoined from=
 being
> > installed.  It appears to be a sane fix to me though.  Also, recentely,
> > Jere found a reproducer posted on list to confirm that this resolves the
> > issues
> >=20
> > Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> > CC: Vlad Yasevich <vyasevich@gmail.com>
> > CC: "David S. Miller" <davem@davemloft.net>
> > CC: Jere Lepp=C3=A4nen <jere.leppanen@nokia.com>
> > CC: marcelo.leitner@gmail.com
> > ---
> >  net/sctp/sm_sideeffect.c | 21 ++++++++++++++++++---
> >  1 file changed, 18 insertions(+), 3 deletions(-)
> >=20
> > diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
> > index 2bc29463e1dc..43a256b5a5f0 100644
> > --- a/net/sctp/sm_sideeffect.c
> > +++ b/net/sctp/sm_sideeffect.c
> > @@ -1523,9 +1523,24 @@ static int sctp_cmd_interpreter(enum sctp_event_=
type event_type,
> >  			timeout =3D asoc->timeouts[cmd->obj.to];
> >  			BUG_ON(!timeout);
> > =20
> > -			timer->expires =3D jiffies + timeout;
> > -			sctp_association_hold(asoc);
> > -			add_timer(timer);
> > +			/*
> > +			 * SCTP has a hard time with timer starts.  Because we process
> > +			 * timer starts as side effects, it can be hard to tell if we
> > +			 * have already started a timer or not, which leads to BUG
> > +			 * halts when we call add_timer. So here, instead of just starting
> > +			 * a timer, if the timer is already started, and just mod
> > +			 * the timer with the shorter of the two expiration times
> > +			 */
> > +			if (timer_pending(timer)) {
> > +				if (time_after(timer->expires, (jiffies + timeout))) {
> > +					timer->expires =3D jiffies+timeout;
> > +					mod_timer(timer, timer->expires);
> > +				}
> > +			} else {
> > +				timer->expires =3D jiffies + timeout;
> > +				sctp_association_hold(asoc);
> > +				mod_timer(timer, timer->expires);
> > +			}
>=20
> Jere, can you then update it to use timer_reduce(), as you had
> suggested?
> =20
Sorry, I didn't read past all the reproducer gorp, I can take care of this.
Neil

> >  			break;
> > =20
> >  		case SCTP_CMD_TIMER_RESTART:
> > --=20
> > 2.25.3
> >=20
>=20
