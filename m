From: David Laight <David.Laight@ACULAB.COM>
Date: Wed, 11 Jul 2018 11:09:33 +0000
Subject: RE: [PATCH net] sctp: Free connecting association if there is a pending signal
Message-Id: <e4aa0b572a40416eb9622d0a119a489b@AcuMS.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20180709101142.GA1820@bordel.klfree.net>
In-Reply-To: <20180709101142.GA1820@bordel.klfree.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

From: Petr Malat
> Sent: 11 July 2018 10:13
...
> I can look further and try to  change the patch to free the association
> only for blocking sockets, but that leads me to a question what is
> actually the intended behavior for these cases, should SCTP be as close
> to TCP as possible (to make s/IPPROTO_TCP/IPPROTO_SCTP/ working for
> most applications)?

Most TCP applications will fail to work properly over SCTP for
other reasons.

At least one problem is that unless the application enables receipt
of 'sctp_association_event' it won't be told about connection
restarts and will get very confused by the missing data.

It is also worth noting that TCP is likely to be considerably
faster than SCTP.
Partially because the SCTP code is significantly more complicated,
and partially because it is difficult for an application to get
multiple data chunks into a single ethernet frame (unless the
traffic pattern allows Nagle be enabled).

Even some of the protocols which (I think) were co-developed with
SCTP (I'm thinking about SIGTRAN M3UA and M2PA) have mis-understandings
about the way SCTP behaves and probably work better over TCP!

	David

