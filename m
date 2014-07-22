From: David Laight <David.Laight@ACULAB.COM>
Date: Tue, 22 Jul 2014 09:03:17 +0000
Subject: RE: [PATCH net-next v3 1/3] Open out the check for Nagle
Message-Id: <063D6719AE5E284EB5DD2968C1650D6D1727AF43@AcuExch.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <063D6719AE5E284EB5DD2968C1650D6D17278F4D@AcuExch.aculab.com>
 <20140721.162537.1473346987310446422.davem@davemloft.net>
In-Reply-To: <20140721.162537.1473346987310446422.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 'David Miller' <davem@davemloft.net>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>

> From: David Laight <David.Laight@ACULAB.COM>
> Date: Fri, 18 Jul 2014 17:36:24 +0000
> 
> > The check for Nagle contains 6 separate checks all of which must be true
> > before a data packet is delayed.
> > Separate out each into its own 'if (test) return SCTP_XMIT_OK' so that
> > the reasons can be individually described.
> >
> > Also return directly with SCTP_XMIT_RWND_FULL.
> > Delete the now-unused 'retval' variable and 'finish' label from
> > sctp_packet_can_append_data().
> >
> > Signed-off-by: David Laight <david.laight@aculab.com>
> 
> Please add the "sctp: " subsystem prefix to this subject line.

I've resent all 3 patches with net: sctp: added to the subject line
and a comment below the ---.

I must check whether I can send patches directly, instead of pasting
from wordpad into outlook (which seems to preserve any tabs).

	David



