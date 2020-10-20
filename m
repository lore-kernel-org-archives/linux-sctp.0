From: 'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>
Date: Tue, 20 Oct 2020 22:13:49 +0000
Subject: Re: [PATCHv4 net-next 16/16] sctp: enable udp tunneling socks
Message-Id: <20201020221349.GH11030@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1603110316.git.lucien.xin@gmail.com>
 <b65bdc11e5a17e328227676ea283cee617f973fb.1603110316.git.lucien.xin@gmail.com>
 <20201019221545.GD11030@localhost.localdomain>
 <CADvbK_ezWXMxpKkt3kxbXhcgu73PTJ1zpChb_sCgDu38xcROtA@mail.gmail.com>
 <20201020211108.GF11030@localhost.localdomain>
 <3BC2D946-9EA7-4847-9C6E-B3C9DA6A6618@fh-muenster.de>
 <20201020212338.GG11030@localhost.localdomain>
 <1614a5aa143147a385f7db7bdda0bfd3@AcuMS.aculab.com>
In-Reply-To: <1614a5aa143147a385f7db7bdda0bfd3@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Laight <David.Laight@aculab.com>
Cc: Michael Tuexen <tuexen@fh-muenster.de>, Xin Long <lucien.xin@gmail.com>, network dev <netdev@vger.kernel.org>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, Neil Horman <nhorman@tuxdriver.com>, davem <davem@davemloft.net>, Guillaume Nault <gnault@redhat.com>, Paolo Abeni <pabeni@redhat.com>, Willem de Bruijn <willemdebruijn.kernel@gmail.com>

On Tue, Oct 20, 2020 at 10:08:17PM +0000, David Laight wrote:
> From: Marcelo Ricardo Leitner
> > Sent: 20 October 2020 22:24
> ...
> > > > Did FreeBSD enable it by default too?
> > > No. The default is 0, which means that the encapsulation is turned off.
> > > Setting this sysctl variable to a non-zero value enables the UDP tunneling
> > > with the given port.
> > 
> > Thanks Michael.
> > Xin, then we should change this default value (and update the
> > documentation above accordingly, to still have the standard port #
> > readily available in there).
> 
> Does that mean that you can't have some 'normal' connections and
> others that use UDP encapsulation?
> Seems a pretty strong restriction.

That's not what was said. Just that the socket shouldn't be created by
default.

> 
> (I'm waiting for one of our customers to ask for this...)

It can. The setting in question is for receiving encapsulated packets,
and which doesn't exclude the standard one. It can still receive
normal/non-encapsulated packets.
