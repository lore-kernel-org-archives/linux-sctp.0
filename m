From: David Miller <davem@davemloft.net>
Date: Fri, 22 May 2020 22:48:33 +0000
Subject: Re: [PATCH net 1/1] sctp: Start shutdown on association restart if in SHUTDOWN-SENT state and socket
Message-Id: <20200522.154833.1534807790311464208.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200520151531.787414-1-jere.leppanen@nokia.com>
In-Reply-To: <20200520151531.787414-1-jere.leppanen@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: jere.leppanen@nokia.com
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org, vyasevich@gmail.com, nhorman@tuxdriver.com, marcelo.leitner@gmail.com, David.Laight@aculab.com

From: Jere Lepp=E4nen <jere.leppanen@nokia.com>
Date: Wed, 20 May 2020 18:15:31 +0300

> Commit bdf6fa52f01b ("sctp: handle association restarts when the
> socket is closed.") starts shutdown when an association is restarted,
> if in SHUTDOWN-PENDING state and the socket is closed. However, the
> rationale stated in that commit applies also when in SHUTDOWN-SENT
> state - we don't want to move an association to ESTABLISHED state when
> the socket has been closed, because that results in an association
> that is unreachable from user space.
>=20
> The problem scenario:
>=20
> 1.  Client crashes and/or restarts.
>=20
> 2.  Server (using one-to-one socket) calls close(). SHUTDOWN is lost.
>=20
> 3.  Client reconnects using the same addresses and ports.
>=20
> 4.  Server's association is restarted. The association and the socket
>     move to ESTABLISHED state, even though the server process has
>     closed its descriptor.
>=20
> Also, after step 4 when the server process exits, some resources are
> leaked in an attempt to release the underlying inet sock structure in
> ESTABLISHED state:
>=20
>     IPv4: Attempt to release TCP socket in state 1 00000000377288c7
>=20
> Fix by acting the same way as in SHUTDOWN-PENDING state. That is, if
> an association is restarted in SHUTDOWN-SENT state and the socket is
> closed, then start shutdown and don't move the association or the
> socket to ESTABLISHED state.
>=20
> Fixes: bdf6fa52f01b ("sctp: handle association restarts when the socket i=
s closed.")
> Signed-off-by: Jere Lepp=E4nen <jere.leppanen@nokia.com>

Applied and queued up for -stable, thanks.
