From: David Laight <David.Laight@ACULAB.COM>
Date: Tue, 19 May 2020 10:47:17 +0000
Subject: sctp doesn't honour net.ipv6.bindv6only
Message-Id: <62ff05456c5d4ab5953b85fff3934ba9@AcuMS.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>
Cc: Neil Horman <nhorman@tuxdriver.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

The sctp code doesn't use sk->sk_ipv6only (which is initialised
from net.ipv6.bindv6only) but instead uses its own flag
sp->v4mapped which always defaults to 1.

There may also be an expectation that
  [gs]etsockopt(sctp_fd, IPPROTO_IPV6, IPV6_V6ONLY,...)
will access the flag that sctp uses internally.
(Matching TCP and UDP.)

Patch is trivial (remembering the inverted state)
but I don't have a clean enough source tree :-(

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
