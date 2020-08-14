From: David Laight <David.Laight@ACULAB.COM>
Date: Fri, 14 Aug 2020 10:50:20 +0000
Subject: num_ostreams and max_instreams negotiation
Message-Id: <0b4319e4b2cf4ee68fc2b0183536aa7a@AcuMS.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>

At some point the negotiation of the number of SCTP streams
seems to have got broken.
I've definitely tested it in the past (probably 10 years ago!)
but on a 5.8.0 kernel getsockopt(SCTP_INFO) seems to be
returning the 'num_ostreams' set by setsockopt(SCTP_INIT)
rather than the smaller of that value and that configured
at the other end of the connection.

I'll do a bit of digging.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
