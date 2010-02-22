From: "Brandon Moreno" <brandomo@nortel.com>
Date: Mon, 22 Feb 2010 19:29:48 +0000
Subject: Fast Retransmission Settings
Message-Id: <4620668FFAA3D5458A691287D9DDAD11071917E6@zrtphxm2.corp.nortel.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi,

I have a general question about lksctp's fast retransmit implementation.


I am currently using lksctp-tools-1.0.6-1.i386.rpm on my server side.
After setting up an sctp connection, I am seeing proper messaging while
we run various messages over the SCTP stream. The issue that I am seeing
is when a packet is lost in the network. Presently, when a TSN is lost
on our client side, it starts transmitting sack messages with gap
reports. The server side is receiving the gap sack messages, however it
is not retransmitting the packet until the rto timer expires. Since the
rto timer increases, eventually the whole sctp association is going down
when too many gap reports are received without a retransmission.

I am curious why we are not seeing fast retransmit after 4 gap reports
are received. Is there some setting that will affect fast retransmit
being on or off?

Thanks,
Brandon Moreno
Ericsson BCAM
(972)684-1791 esn x444-1791

The author works for Telefonaktiebolaget L M Ericsson ("Ericsson"), who
is solely responsible for this email and its contents. All inquiries
regarding this email should be addressed to Ericsson. Nortel has
provided the use of the nortel.com domain to Ericsson in connection with
this email solely for the purpose of connectivity and Nortel Networks
has no liability for the email or its contents. The web site for
Ericsson is www.ericsson.com <http://www.ericsson.com/> ."


