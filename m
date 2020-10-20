From: David Laight <David.Laight@ACULAB.COM>
Date: Tue, 20 Oct 2020 22:08:17 +0000
Subject: RE: [PATCHv4 net-next 16/16] sctp: enable udp tunneling socks
Message-Id: <1614a5aa143147a385f7db7bdda0bfd3@AcuMS.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1603110316.git.lucien.xin@gmail.com>
 <b65bdc11e5a17e328227676ea283cee617f973fb.1603110316.git.lucien.xin@gmail.com>
 <20201019221545.GD11030@localhost.localdomain>
 <CADvbK_ezWXMxpKkt3kxbXhcgu73PTJ1zpChb_sCgDu38xcROtA@mail.gmail.com>
 <20201020211108.GF11030@localhost.localdomain>
 <3BC2D946-9EA7-4847-9C6E-B3C9DA6A6618@fh-muenster.de>
 <20201020212338.GG11030@localhost.localdomain>
In-Reply-To: <20201020212338.GG11030@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>, Michael Tuexen <tuexen@fh-muenster.de>
Cc: Xin Long <lucien.xin@gmail.com>, network dev <netdev@vger.kernel.org>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, Neil Horman <nhorman@tuxdriver.com>, davem <davem@davemloft.net>, Guillaume Nault <gnault@redhat.com>, Paolo Abeni <pabeni@redhat.com>, Willem de Bruijn <willemdebruijn.kernel@gmail.com>

From: Marcelo Ricardo Leitner
> Sent: 20 October 2020 22:24
...
> > > Did FreeBSD enable it by default too?
> > No. The default is 0, which means that the encapsulation is turned off.
> > Setting this sysctl variable to a non-zero value enables the UDP tunneling
> > with the given port.
> 
> Thanks Michael.
> Xin, then we should change this default value (and update the
> documentation above accordingly, to still have the standard port #
> readily available in there).

Does that mean that you can't have some 'normal' connections and
others that use UDP encapsulation?
Seems a pretty strong restriction.

(I'm waiting for one of our customers to ask for this...)

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
