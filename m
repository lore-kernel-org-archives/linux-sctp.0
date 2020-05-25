From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Mon, 25 May 2020 20:59:47 +0000
Subject: Re: do a single memdup_user in sctp_setsockopt
Message-Id: <20200525205947.GC2491@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200521174724.2635475-1-hch@lst.de>
 <348217b7a3e14c1fa4868e47362be9c5@AcuMS.aculab.com>
 <20200522143623.GA386664@localhost.localdomain>
 <20200523071929.GA10466@lst.de>
 <38061a608f294766846e23170bdf0177@AcuMS.aculab.com>
In-Reply-To: <38061a608f294766846e23170bdf0177@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Laight <David.Laight@aculab.com>
Cc: 'Christoph Hellwig' <hch@lst.de>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>

On Mon, May 25, 2020 at 07:37:49PM +0000, David Laight wrote:
> I'm going to post a V3 of my big patch - I spotted an error.
> I'll include a different (smaller) patch in 0/1 that generates
> exactly the same object code but is easier to review.

Please make sure to split at least setsockopt and getsockopt changes
into different patches. That will help quite a lot already.
And to adopt the memset at the end of sctp_setsockopt_auth_key(), to
avoid special handling later on.

Thanks,
Marcelo
