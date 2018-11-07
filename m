From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 07 Nov 2018 12:53:14 +0000
Subject: Re: Broken sack processing
Message-Id: <20181107125314.GI6761@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <5dcd9eb4ccf44ce293a73fb9ec4457cf@AcuMS.aculab.com>
In-Reply-To: <5dcd9eb4ccf44ce293a73fb9ec4457cf@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Wed, Nov 07, 2018 at 10:01:48AM +0000, David Laight wrote:
> I've a customer trace from a very old system (RHEL 5.7) that shows the

Ouch. That's really old. (and unsupported)

> kernel failing to respond to some SACK packets like:
> 
> SACK chunk (Cumulative TSN: 3327915808, a_rwnd: 224400, gaps: 12, duplicate TSNs: 0)
> Chunk type: SACK (3)
> Chunk flags: 0x00
> Chunk length: 64
> Cumulative TSN ACK: 3327915808
> Advertised receiver window credit (a_rwnd): 224400
> Number of gap acknowledgement blocks: 12
> Number of duplicated TSNs: 0
> Gap Acknowledgement for TSN 3327915813 to 3327915814
> Gap Acknowledgement for TSN 3327915818 to 3327915818
> Gap Acknowledgement for TSN 3327915822 to 3327915838
> Gap Acknowledgement for TSN 3327915842 to 3327915852
> Gap Acknowledgement for TSN 3327915856 to 3327915858
> Gap Acknowledgement for TSN 3327915860 to 3327915864
> Gap Acknowledgement for TSN 3327915866 to 3327915866
> Gap Acknowledgement for TSN 3327915868 to 3327915869
> Gap Acknowledgement for TSN 3327915873 to 3327915877
> Gap Acknowledgement for TSN 3327915881 to 3327915892
> Gap Acknowledgement for TSN 3327915894 to 3327916102
> Gap Acknowledgement for TSN 3327916104 to 3327916172
> [Number of TSNs in gap acknowledgement blocks: 337]
> 
> Does this ring a bell, any idea how long ago it was fixed?

I don't follow. What is broken in this SACK? And what does it mean
"kenrel fails to repond some SACK", like, is it not retransmitting?

> Not sure why the connection isn't dropped because of the unacked packets?

Whenever a new delivery is confirmed, the error count is zeroed. But,
once it enters RTO, it won't do new deliveries.
After a SACK like this I would expect some fast rtx, then RTO and then
a possible abort.
But if TSN 3327915809 (next after cumack) gets delivered, it will zero
the error count (again).

Is this connection triggering zero windows, by any chance? Doesn't
seem so, as per
  Advertised receiver window credit (a_rwnd): 224400

  Marcelo
