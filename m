From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Tue, 03 May 2016 11:49:18 +0000
Subject: Re: [PATCH 0/2] sctp: Add GSO support
Message-Id: <20160503114918.GD5676@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1461965035.git.marcelo.leitner@gmail.com>
 <20160502.191614.608026435064266168.davem@davemloft.net>
In-Reply-To: <20160502.191614.608026435064266168.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, vyasevich@gmail.com, nhorman@tuxdriver.com, linux-sctp@vger.kernel.org, David.Laight@ACULAB.COM, alexander.duyck@gmail.com

On Mon, May 02, 2016 at 07:16:14PM -0400, David Miller wrote:
> From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> Date: Fri, 29 Apr 2016 18:33:31 -0300
> 
> > This patchset adds sctp GSO support.
> > 
> > Performance tests indicates that increases throughput by 10% if using
> > bigger chunk sizes, specially if bigger than MTU. For small chunks, it
> > doesn't help much if not using heavy firewall rules.
> > 
> > For small chunks it will probably be of more use once we get something
> > like MSG_MORE as David Laight had suggested.
> > 
> > I believe I could address all comments from the RFC attempt.
> 
> Are these packets idempotent?
> 
> Ie. if we GRO a bunch of SCTP frames on receive and that GRO frame is
> forwarded rather than received locally, is the same exact packet
> stream emitted on transmit?

Forward path is not going to happen because we can't do GRO for SCTP,
unfortunatelly. We would have to somehow maintain frame boundaries (as
I did for GSO here) (so that AUTH chunks have a delimited scope, for
example) and that's not feasible with the current way we do GRO. Well,
at least I couldn't see how.

So this is just for pure tx path, no forwarding involved.

  Marcelo

