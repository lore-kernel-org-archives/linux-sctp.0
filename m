From: David Laight <David.Laight@ACULAB.COM>
Date: Tue, 26 Nov 2019 10:24:10 +0000
Subject: sctp protocol violation state 2 chunkid 5
Message-Id: <431b0b65c3604076bb5ef633bcac8198@AcuMS.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

I've a customer saying they are seeing the error ' sctp protocol violation state 2 chunkid 5'
being logged on a system where receive SCTP data isn't being processed properly.
They've only sent me a .pcap file so I'm not actually certain what the (kernel) code that
has the socket is seeing.
I think that SACK is being sent for all the receive data, but nothing is being transmitted.
Of course, that data could be on a different socket (well address quartet) than the
one generating the error.

The pcap trace is made harder to read because there are several SCTP connections,
none of which are working and, I think, some have the same port number pairs
but different remote IP addresses.

To make any sense of the error they must be using a RHEL 6 (2.6.32 based) kernel.
Which makes it erroring a HEARTBEAT_ACK in state COOKIE_WAIT.

One complication that might lead to sockets with duplicate address quartets is
that these are M3UA connections and it is typical to bind to a specific local
IP address and port number then bindx to a second local IP address before
making the outwards connection.
(We only connect to one of the remote IPs, the other is picked up by SCTP.)

I can try to persuade them it is fixed in a later kernel, but getting them to
use anything newer than the RHEL 7.7 3.10 based kernel will be very hard.

Any ideas?

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
