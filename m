From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Wed, 23 Apr 2008 19:53:18 +0000
Subject: Re: [PATCH] SCTP: Fix DATA retransmit after fast retransmit
Message-Id: <480F93AE.8000004@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <48085441.2030904@cn.fujitsu.com>
In-Reply-To: <48085441.2030904@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi Wei

I was able to reproduce the problem as well as understand when the rfc really
wants us to do.

On further analysis we have a lot of problems with fast retransmit.

1.  We really should be restarting the T3 timer any time we fast retransmit the
lowest outstanding TSN.  In your scenario, we would restart the T3-rtx time when
we fast retransmit TSN 2.

2.  We should not change the cnwd every time we enter hit the fast retransmit
event.  We should follow the Fast Recovery algorithm as specified in the spec.

3.  We only be sending 1 MTU worth fast retransmit.  What happens now is if we have
multiple chunks to retransmit, we queue all the chunks on the retransmit queue, fast
retransmit one and call outq_flush() which will send the rest, assuming cwnd allows it.
For an on-the-wire observer, it appears like we fast retransmitted more the 1-mtu worth
of data.

-vlad
