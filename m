From: David Laight <David.Laight@ACULAB.COM>
Date: Mon, 02 Mar 2020 15:26:39 +0000
Subject: RE: Expected SCTP DATA chunk per second performance
Message-Id: <473732823f1b40f2bb5d47935840696c@AcuMS.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200302093532.GE43827@nataraja>
In-Reply-To: <20200302093532.GE43827@nataraja>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

From: Harald Welte
> Sent: 02 March 2020 13:48
...
> When disabling NAGLE ('client -d' of the attached program), I'm getting
> much higher throughput, but there is no single IP packet with more than
> a single DATA chunk inside at all anymore.  The latter is expected on
> the one hand side (every syscall goes all the way to build a packet and
> send it), but given at the high sender rate I would have expected that
> every so often multiple DATA chunks arrive from userspace before a
> packet has been sent (socket send buffer)?  In any case, no complaints
> in this case.

You'd have to flow control off (ie no ack from the remote system) the
connections before data chunks get merged.

If you know you have another data chunk to send, set MSG_MORE on the send.
That should stop the packet being sent until it is full.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
