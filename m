From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Thu, 23 Apr 2020 01:09:31 +0000
Subject: Re: [PATCH net 2/2] sctp: Fix SHUTDOWN CTSN Ack in the peer restart case
Message-Id: <20200423010931.GC2688@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200421190342.548226-1-jere.leppanen@nokia.com>
 <20200421190342.548226-3-jere.leppanen@nokia.com>
In-Reply-To: <20200421190342.548226-3-jere.leppanen@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Jere =?iso-8859-1?Q?Lepp=E4nen?= <jere.leppanen@nokia.com>
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, "David S . Miller" <davem@davemloft.net>, Xin Long <lucien.xin@gmail.com>

On Tue, Apr 21, 2020 at 10:03:42PM +0300, Jere Lepp=E4nen wrote:
> When starting shutdown in sctp_sf_do_dupcook_a(), get the value for
> SHUTDOWN Cumulative TSN Ack from the new association, which is
> reconstructed from the cookie, instead of the old association, which
> the peer doesn't have anymore.
>=20
> Otherwise the SHUTDOWN is either ignored or replied to with an ABORT
> by the peer because CTSN Ack doesn't match the peer's Initial TSN.
>=20
> Fixes: bdf6fa52f01b ("sctp: handle association restarts when the socket i=
s closed.")
> Signed-off-by: Jere Lepp=E4nen <jere.leppanen@nokia.com>

Nice patches. Thanks.

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
