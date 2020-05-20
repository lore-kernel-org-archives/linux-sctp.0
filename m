From: =?ISO-8859-15?Q?Jere_Lepp=E4nen?= <jere.leppanen@nokia.com>
Date: Wed, 20 May 2020 21:50:58 +0000
Subject: Re: [PATCH net 1/1] sctp: Start shutdown on association restart if in SHUTDOWN-SENT state and socket
Message-Id: <alpine.LFD.2.21.2005210039550.789637@sut4-server4-pub.sut-1.archcommon.nsn-rdnet.net>
MIME-Version: 1
Content-Type: multipart/mixed; boundary="352996365-1605154134-1590011470=:789637"
List-Id: <linux-sctp.vger.kernel.org>
References: <20200520151531.787414-1-jere.leppanen@nokia.com> <20200520194629.GS2491@localhost.localdomain>
In-Reply-To: <20200520194629.GS2491@localhost.localdomain>
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: =?ISO-8859-15?Q?Jere_Lepp=E4nen?= <jere.leppanen@nokia.com>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, "David S . Miller" <davem@davemloft.net>, David Laight <David.Laight@aculab.com>

--352996365-1605154134-1590011470=:789637
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Wed, 20 May 2020, Marcelo Ricardo Leitner wrote:

> On Wed, May 20, 2020 at 06:15:31PM +0300, Jere Lepp=E4nen wrote:
> > Commit bdf6fa52f01b ("sctp: handle association restarts when the
> > socket is closed.") starts shutdown when an association is restarted,
> > if in SHUTDOWN-PENDING state and the socket is closed. However, the
> > rationale stated in that commit applies also when in SHUTDOWN-SENT
> > state - we don't want to move an association to ESTABLISHED state when
> > the socket has been closed, because that results in an association
> > that is unreachable from user space.
> >=20
> > The problem scenario:
> >=20
> > 1.  Client crashes and/or restarts.
> >=20
> > 2.  Server (using one-to-one socket) calls close(). SHUTDOWN is lost.
> >=20
> > 3.  Client reconnects using the same addresses and ports.
> >=20
> > 4.  Server's association is restarted. The association and the socket
> >     move to ESTABLISHED state, even though the server process has
> >     closed its descriptor.
> >=20
> > Also, after step 4 when the server process exits, some resources are
> > leaked in an attempt to release the underlying inet sock structure in
> > ESTABLISHED state:
> >=20
> >     IPv4: Attempt to release TCP socket in state 1 00000000377288c7
> >=20
> > Fix by acting the same way as in SHUTDOWN-PENDING state. That is, if
> > an association is restarted in SHUTDOWN-SENT state and the socket is
> > closed, then start shutdown and don't move the association or the
> > socket to ESTABLISHED state.
> >=20
> > Fixes: bdf6fa52f01b ("sctp: handle association restarts when the socket=
 is closed.")
> > Signed-off-by: Jere Lepp=E4nen <jere.leppanen@nokia.com>
> > ---
> >  net/sctp/sm_statefuns.c | 9 +++++----
> >  1 file changed, 5 insertions(+), 4 deletions(-)
> >=20
> > diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
> > index 26788f4a3b9e..e86620fbd90f 100644
> > --- a/net/sctp/sm_statefuns.c
> > +++ b/net/sctp/sm_statefuns.c
> > @@ -1856,12 +1856,13 @@ static enum sctp_disposition sctp_sf_do_dupcook=
_a(
> >  	/* Update the content of current association. */
> >  	sctp_add_cmd_sf(commands, SCTP_CMD_UPDATE_ASSOC, SCTP_ASOC(new_asoc));
> >  	sctp_add_cmd_sf(commands, SCTP_CMD_EVENT_ULP, SCTP_ULPEVENT(ev));
> > -	if (sctp_state(asoc, SHUTDOWN_PENDING) &&
> > +	if ((sctp_state(asoc, SHUTDOWN_PENDING) ||
> > +	     sctp_state(asoc, SHUTDOWN_SENT)) &&
> >  	    (sctp_sstate(asoc->base.sk, CLOSING) ||
> >  	     sock_flag(asoc->base.sk, SOCK_DEAD))) {
> > -		/* if were currently in SHUTDOWN_PENDING, but the socket
> > -		 * has been closed by user, don't transition to ESTABLISHED.
> > -		 * Instead trigger SHUTDOWN bundled with COOKIE_ACK.
> > +		/* If the socket has been closed by user, don't
> > +		 * transition to ESTABLISHED. Instead trigger SHUTDOWN
> > +		 * bundled with COOKIE_ACK.
> >  		 */
> >  		sctp_add_cmd_sf(commands, SCTP_CMD_REPLY, SCTP_CHUNK(repl));
> >  		return sctp_sf_do_9_2_start_shutdown(net, ep, asoc,
> >=20
> > base-commit: 20a785aa52c82246055a089e55df9dac47d67da1
>=20
> This last line is not standard, but git didn't complain about it here.

The git format-patch --base option. It's mentioned in the docs:

https://www.kernel.org/doc/html/v5.6/process/submitting-patches.html#provid=
ing-base-tree-information

>=20
> Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Thanks for the speedy ack, Marcelo.
--352996365-1605154134-1590011470=:789637--
