From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Mon, 20 Jul 2020 13:08:40 +0000
Subject: Re: do a single memdup_user in sctp_setsockopt v2
Message-Id: <20200720130840.GB2491@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200719072228.112645-1-hch@lst.de>
 <20200719.182727.141244810520299886.davem@davemloft.net>
In-Reply-To: <20200719.182727.141244810520299886.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem@davemloft.net>
Cc: hch@lst.de, vyasevich@gmail.com, nhorman@tuxdriver.com, kuba@kernel.org, David.Laight@aculab.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

On Sun, Jul 19, 2020 at 06:27:27PM -0700, David Miller wrote:
> From: Christoph Hellwig <hch@lst.de>
> Date: Sun, 19 Jul 2020 09:21:37 +0200
> 
> > here is a resend of my series to lift the copy_from_user out of the
> > individual sctp sockopt handlers into the main sctp_setsockopt
> > routine.
> > 
> > Changes since v1:
> >  - fixes a few sizeof calls.
> >  - use memzero_explicit in sctp_setsockopt_auth_key instead of special
> >    casing it for a kzfree in the caller
> >  - remove some minor cleanups from sctp_setsockopt_autoclose to keep
> >    it closer to the existing version
> >  - add another little only vaguely related cleanup patch
> 
> This is all very mechanical and contained to the sockopt code of SCTP,
> so I reviewed this a few times and applied it to net-next.
> 
> Thanks Christoph!

Yep! And way easier to work with, function by function.

Just for the records,
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Thanks.
