From: David Laight <David.Laight@ACULAB.COM>
Date: Thu, 20 Feb 2014 13:25:31 +0000
Subject: RE: [PATCH net] net: sctp: fix multihoming retransmission path selection to rfc4960
Message-Id: <063D6719AE5E284EB5DD2968C1650D6D0F6C7694@AcuExch.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1392897186-26841-1-git-send-email-dborkman@redhat.com>
 <063D6719AE5E284EB5DD2968C1650D6D0F6C762B@AcuExch.aculab.com>
 <5305F993.4060603@redhat.com>
In-Reply-To: <5305F993.4060603@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 'Daniel Borkmann' <dborkman@redhat.com>
Cc: "davem@davemloft.net" <davem@davemloft.net>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, Gui Jianfeng <guijianfeng@cn.fujitsu.com>

From: Daniel Borkmann
> On 02/20/2014 01:25 PM, David Laight wrote:
> > I was wondering whether it is valid (or even reasonable) to send
> > the retransmit down multiple paths?  Particularly if they are
> > not known to be working.
> 
> As far as I can see, the RFC says that we should pick one, and
> not broadcast through all paths, besides HB should monitor these
> anyway.
> 
> Future work, however, could select a retransmission path "more
> intelligent" based on further transport path properties, but
> that is certainly not net material, plus it seems we would need
> additional state logic indicating that a path has been used before
> to not exclude other less optimal transports on successive
> retransmits.

Yes, anything like that probably requires a few steps (and testing)
before being finally implemented.

I always like to have a list of 'future work' (mostly in my head).
Sometimes you suddenly think of a cheap way of doing something,
and you also don't want to move in the wrong direction.

> > Or maybe resend heartbeats in a desperate attempt to find a working
> > path?
> 
> Yes, that is done through HBs, see 1.5.7 of RFC4960.

I've managed so far without having to read the SCTP RFCs :-)
But I've implemented enough comms protocols over the years to
know most of the pitfalls.

> > Do you guys know which kernel version(s) have that patch?
> 
> git describe 4141ddc02a92
> v2.6.26-rc4-210-g4141ddc

Thanks.

	David



