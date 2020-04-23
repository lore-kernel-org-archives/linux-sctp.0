From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Thu, 23 Apr 2020 01:09:02 +0000
Subject: Re: [PATCH net 1/2] sctp: Fix bundling of SHUTDOWN with COOKIE-ACK
Message-Id: <20200423010902.GB2688@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200421190342.548226-1-jere.leppanen@nokia.com>
 <20200421190342.548226-2-jere.leppanen@nokia.com>
In-Reply-To: <20200421190342.548226-2-jere.leppanen@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Jere =?iso-8859-1?Q?Lepp=E4nen?= <jere.leppanen@nokia.com>
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, "David S . Miller" <davem@davemloft.net>, Xin Long <lucien.xin@gmail.com>

On Tue, Apr 21, 2020 at 10:03:41PM +0300, Jere Lepp=E4nen wrote:
> When we start shutdown in sctp_sf_do_dupcook_a(), we want to bundle
> the SHUTDOWN with the COOKIE-ACK to ensure that the peer receives them
> at the same time and in the correct order. This bundling was broken by
> commit 4ff40b86262b ("sctp: set chunk transport correctly when it's a
> new asoc"), which assigns a transport for the COOKIE-ACK, but not for
> the SHUTDOWN.
>=20
> Fix this by passing a reference to the COOKIE-ACK chunk as an argument
> to sctp_sf_do_9_2_start_shutdown() and onward to
> sctp_make_shutdown(). This way the SHUTDOWN chunk is assigned the same
> transport as the COOKIE-ACK chunk, which allows them to be bundled.
>=20
> In sctp_sf_do_9_2_start_shutdown(), the void *arg parameter was
> previously unused. Now that we're taking it into use, it must be a
> valid pointer to a chunk, or NULL. There is only one call site where
> it's not, in sctp_sf_autoclose_timer_expire(). Fix that too.
>=20
> Fixes: 4ff40b86262b ("sctp: set chunk transport correctly when it's a new=
 asoc")
> Signed-off-by: Jere Lepp=E4nen <jere.leppanen@nokia.com>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
