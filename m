From: David Miller <davem@davemloft.net>
Date: Mon, 20 Jul 2020 01:27:27 +0000
Subject: Re: do a single memdup_user in sctp_setsockopt v2
Message-Id: <20200719.182727.141244810520299886.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200719072228.112645-1-hch@lst.de>
In-Reply-To: <20200719072228.112645-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hch@lst.de
Cc: vyasevich@gmail.com, nhorman@tuxdriver.com, marcelo.leitner@gmail.com, kuba@kernel.org, David.Laight@ACULAB.COM, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>
Date: Sun, 19 Jul 2020 09:21:37 +0200

> here is a resend of my series to lift the copy_from_user out of the
> individual sctp sockopt handlers into the main sctp_setsockopt
> routine.
> 
> Changes since v1:
>  - fixes a few sizeof calls.
>  - use memzero_explicit in sctp_setsockopt_auth_key instead of special
>    casing it for a kzfree in the caller
>  - remove some minor cleanups from sctp_setsockopt_autoclose to keep
>    it closer to the existing version
>  - add another little only vaguely related cleanup patch

This is all very mechanical and contained to the sockopt code of SCTP,
so I reviewed this a few times and applied it to net-next.

Thanks Christoph!
