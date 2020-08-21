From: David Laight <David.Laight@ACULAB.COM>
Date: Fri, 21 Aug 2020 07:41:00 +0000
Subject: RE: [PATCH v2] net: sctp: Fix negotiation of the number of data streams.
Message-Id: <abecfca0ee6d4fa1835e9f0a0338a04a@AcuMS.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <3aef12f2fdbb4ee6b885719f5561a997@AcuMS.aculab.com>
        <1f2ffcb1180e4080aab114683b06efab@AcuMS.aculab.com>
 <20200820.163838.2031881871934638484.davem@davemloft.net>
In-Reply-To: <20200820.163838.2031881871934638484.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 'David Miller' <davem@davemloft.net>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, "marcelo.leitner@gmail.com" <marcelo.leitner@gmail.com>

From: David Miller
> Sent: 21 August 2020 00:39
> 
> >
> > The number of output and input streams was never being reduced, eg when
> > processing received INIT or INIT_ACK chunks.
> > The effect is that DATA chunks can be sent with invalid stream ids
> > and then discarded by the remote system.
> >
> > Fixes: 2075e50caf5ea ("sctp: convert to genradix")
> > Signed-off-by: David Laight <david.laight@aculab.com>
> 
> Applied and queued up for -stable, thanks David.

Thank you.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
