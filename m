From: David Laight <David.Laight@ACULAB.COM>
Date: Fri, 21 Aug 2020 15:59:42 +0000
Subject: 64k streams not supported
Message-Id: <bedd13a72afd427ca4dbbdfa61985533@AcuMS.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Isn't SCTP supposed to support 65536 data streams?
If I try to enable that many I get 10.
Not surprising since the number of streams gets stored in a u16.

The whole code base may need changing to save the highest
valid stream?

Since I don't actually need that many I'm not writing the patch.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
