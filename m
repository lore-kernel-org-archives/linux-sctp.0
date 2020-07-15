From: David Laight <David.Laight@ACULAB.COM>
Date: Wed, 15 Jul 2020 13:08:37 +0000
Subject: RE: 200ms delays with SCTP streaming data
Message-Id: <6a5d72ff775d45adacf765ea41fefbb5@AcuMS.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200713215907.GE3235@minyard.net>
In-Reply-To: <20200713215907.GE3235@minyard.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

From: Corey Minyard
> Sent: 14 July 2020 17:24
...
> Well, that was a surprise, disabling Nagle caused the problem to go
> away.  Nagle generally doesn't make a difference when transferring lots
> of data.
> 
> I guess this is a bad interaction between Nagle and the SCTP
> sack algorithms.  With TCP in my test, data is flowing both ways so data
> is always being acked, and Nagle is never significantly involved.
> 
> That's happening with SCTP, too, but in some situations a sack could be
> sent, you get one more packet sent, and that packet won't be acked until
> another packet is sent.  So you have unacked data, and Nagle will hold
> any new data until it receives an ack for the outstanding packet.  So you
> get stuck until the sack delay elapses.  Bah.
> 
> This is sort of like the interaction between Nagle and TCP delayed ack.
> Which is sort of a bug, I guess, but well known.  I have a number of
> ways to work around this issue, and I can document it so users can know.

If you have an indefinite amount of data to send then even with Nagle
enabled data should get sent when enough is queued to fill an ethernet
frame.
The only proviso is that there is enough transmit window space.
Doing that in SCTP is much more horrid than TCP.

I have seen issues caused by 0 RTT, slow start and delayed acks.
But that was TCP with Nagle enabled.

If you want a 'full hands on debugging experience' enable ftrace
on 'useful' function entry points (all syscall entry/exit events
is a good start) and get the application to stop it on the 200ms
timeout.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
