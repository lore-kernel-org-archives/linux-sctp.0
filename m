From: David Laight <David.Laight@ACULAB.COM>
Date: Thu, 15 Oct 2020 21:23:58 +0000
Subject: RE: [PATCHv3 net-next 16/16] sctp: enable udp tunneling socks
Message-Id: <a5ee7f3c99b14e43aac8938434fd9264@AcuMS.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1602574012.git.lucien.xin@gmail.com>
 <afbaca39fa40eba694bd63c200050a49d8c8df81.1602574012.git.lucien.xin@gmail.com>
 <20201015174252.GB11030@localhost.localdomain>
In-Reply-To: <20201015174252.GB11030@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>, Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, Neil Horman <nhorman@tuxdriver.com>, Michael Tuexen <tuexen@fh-muenster.de>, "davem@davemloft.net" <davem@davemloft.net>, "gnault@redhat.com" <gnault@redhat.com>, "pabeni@redhat.com" <pabeni@redhat.com>, "willemdebruijn.kernel@gmail.com" <willemdebruijn.kernel@gmail.com>

From: Marcelo Ricardo Leitner
> Sent: 15 October 2020 18:43
> 
> Actually..
> 
> On Tue, Oct 13, 2020 at 03:27:41PM +0800, Xin Long wrote:
> ...
> > Also add sysctl udp_port to allow changing the listening
> > sock's port by users.

I've not read through this change...

But surely the UDP port (or ports) that you need to use
will depend on the remote system's configuration.

So they need to be a property of the socket, not a
system-wide value.

I can easily imagine my M3UA code connecting to different
network providers which have decided to use different
UDP port numbers.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
