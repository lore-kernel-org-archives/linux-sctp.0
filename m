From: David Laight <David.Laight@ACULAB.COM>
Date: Mon, 25 May 2020 19:37:49 +0000
Subject: RE: do a single memdup_user in sctp_setsockopt
Message-Id: <38061a608f294766846e23170bdf0177@AcuMS.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200521174724.2635475-1-hch@lst.de>
 <348217b7a3e14c1fa4868e47362be9c5@AcuMS.aculab.com>
 <20200522143623.GA386664@localhost.localdomain>
 <20200523071929.GA10466@lst.de>
In-Reply-To: <20200523071929.GA10466@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 'Christoph Hellwig' <hch@lst.de>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>

From: 'Christoph Hellwig'
> Sent: 23 May 2020 08:19
...
> Alternatively I'll also happily only do a partial conversion for what
> I need for the kernel_setsockopt removal and let you and Dave decided
> what you guys prefer for the rest.

I presume the justification for removing kernel_[sg]etsockopt()
is that you want to get rid of set_fs(KERNEL_DS).
(Which I believe is only a flag to access_ok()?)
In any case I'm not against that at all.

To do that you also need to solve the problem of the BPF 'hook'
in setsockopt() that can also need to pass a kernel buffer through.

I don't see a rush to remove kernel_[sg]etsockopt() until you
have a solution for the BPF hook.
Especially since, until set_fs() is removed, any driver can
(and probably will) just implement their own version.

I think you may end up with the protocols being able to export
either [sg]etsockopt() functions or kernel_[sg]setsockopt()
functions and some paths erroring if the required function is absent.

But even that isn't trivial given the broken nature of one
sctp option - where the returned length has to be invalid!

I'm going to post a V3 of my big patch - I spotted an error.
I'll include a different (smaller) patch in 0/1 that generates
exactly the same object code but is easier to review.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
