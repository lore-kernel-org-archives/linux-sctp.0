From: David Miller <davem@davemloft.net>
Date: Mon, 02 May 2016 23:16:14 +0000
Subject: Re: [PATCH 0/2] sctp: Add GSO support
Message-Id: <20160502.191614.608026435064266168.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1461965035.git.marcelo.leitner@gmail.com>
In-Reply-To: <cover.1461965035.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: marcelo.leitner@gmail.com
Cc: netdev@vger.kernel.org, vyasevich@gmail.com, nhorman@tuxdriver.com, linux-sctp@vger.kernel.org, David.Laight@ACULAB.COM, alexander.duyck@gmail.com

From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri, 29 Apr 2016 18:33:31 -0300

> This patchset adds sctp GSO support.
> 
> Performance tests indicates that increases throughput by 10% if using
> bigger chunk sizes, specially if bigger than MTU. For small chunks, it
> doesn't help much if not using heavy firewall rules.
> 
> For small chunks it will probably be of more use once we get something
> like MSG_MORE as David Laight had suggested.
> 
> I believe I could address all comments from the RFC attempt.

Are these packets idempotent?

Ie. if we GRO a bunch of SCTP frames on receive and that GRO frame is
forwarded rather than received locally, is the same exact packet
stream emitted on transmit?
