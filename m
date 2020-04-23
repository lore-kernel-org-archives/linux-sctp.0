From: David Miller <davem@davemloft.net>
Date: Thu, 23 Apr 2020 02:28:10 +0000
Subject: Re: [PATCH net 0/2] sctp: Fix problems with peer restart when in SHUTDOWN-PENDING state and socket i
Message-Id: <20200422.192810.397679580233184854.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200421190342.548226-1-jere.leppanen@nokia.com>
In-Reply-To: <20200421190342.548226-1-jere.leppanen@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: jere.leppanen@nokia.com
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org, vyasevich@gmail.com, nhorman@tuxdriver.com, marcelo.leitner@gmail.com, lucien.xin@gmail.com

From: Jere Lepp=E4nen <jere.leppanen@nokia.com>
Date: Tue, 21 Apr 2020 22:03:40 +0300

> These patches are related to the scenario described in commit
> bdf6fa52f01b ("sctp: handle association restarts when the socket is
> closed."). To recap, when our association is in SHUTDOWN-PENDING state
> and we've closed our one-to-one socket, while the peer crashes without
> being detected, restarts and reconnects using the same addresses and
> ports, we start association shutdown.
>=20
> In this case, Cumulative TSN Ack in the SHUTDOWN that we send has
> always been incorrect. Additionally, bundling of the SHUTDOWN with the
> COOKIE-ACK was broken by a later commit. This series fixes both of
> these issues.

Series applied, thanks.
