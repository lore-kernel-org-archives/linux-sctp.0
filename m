From: David Laight <David.Laight@ACULAB.COM>
Date: Sun, 07 Jun 2020 14:04:00 +0000
Subject: RE: EAGAIN
Message-Id: <021ba1317114431290cc2aae12a4ee64@AcuMS.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <0D6B7E65-36EC-4132-B02C-0371099E480A@list.fink.org>
In-Reply-To: <0D6B7E65-36EC-4132-B02C-0371099E480A@list.fink.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

From: Michael Tuexen
> Sent: 07 June 2020 13:48
...
> If you killed the peer, I would assume that there is an SCTP message containing an
> ABORT chunk in the wire. Is that true? If that is true, you could subscribe to
> SCTP_ASSOC_CHANGE notification, which should tell you.

Actually for TCP-style 1-1 connections you must subscribe to
SCTP_ASSOC_CHANGE.

If you don't and the far end is killed (eg kernel crash) and
restarts with the same port number pair then you get no
indication that everything has disconnected and reconnected.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
