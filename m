From: David Laight <David.Laight@ACULAB.COM>
Date: Wed, 20 May 2020 14:57:07 +0000
Subject: Minor bugs in sctp_getsockopt()
Message-Id: <a91c8461b73b499593d014e3fcadce71@AcuMS.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, 'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>

I've found 2 minor bugs in sctp_getsockopt().

sctp_getsockopt_peer_auth_chunks() fails to allow for the header
structure when checking the length of the user buffer.
So it can write beyond the end of the user buffer.

sctp_getsockopt_pr_streamstatus() fails to do the copy_to_user()
when streamoute is NULL.

I found these in the middle of writing another patch.
So generating the patch is tricky.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
