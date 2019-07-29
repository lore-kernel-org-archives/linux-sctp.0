From: Qian Cai <cai@lca.pw>
Date: Mon, 29 Jul 2019 15:16:42 +0000
Subject: Re: [PATCH] net/sctp: fix GCC8+ -Wpacked-not-aligned warnings
Message-Id: <1564413402.11067.26.camel@lca.pw>
List-Id: <linux-sctp.vger.kernel.org>
References: <1564174659-21211-1-git-send-email-cai@lca.pw>
         <158b26b6f3b24164aceacd2428095315@AcuMS.aculab.com>
In-Reply-To: <158b26b6f3b24164aceacd2428095315@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: David Laight <David.Laight@ACULAB.COM>, "vyasevich@gmail.com" <vyasevich@gmail.com>, "nhorman@tuxdriver.com" <nhorman@tuxdriver.com>, "marcelo.leitner@gmail.com" <marcelo.leitner@gmail.com>
Cc: "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Mon, 2019-07-29 at 10:39 +0000, David Laight wrote:
> From: Qian Cai
> > Sent: 26 July 2019 21:58
> > 
> > There are a lot of those warnings with GCC8+ 64bit,
> > 
> 
> ...
> > Fix them by aligning the structures and fields to 8 bytes instead.
> 
> ...
> >  struct sctp_setpeerprim {
> >  	sctp_assoc_t            sspp_assoc_id;
> > -	struct sockaddr_storage sspp_addr;
> > -} __attribute__((packed, aligned(4)));
> > +	struct sockaddr_storage sspp_addr __attribute__((aligned(8)));
> > +} __attribute__((packed, aligned(8)));
> 
> What happens to this one if you change both to aligned(4) ?
> Much the same way as:
> 	struct {
> 		int a;
> 		long b __attribute__((aligned(4));
> 	};
> is only 12 bytes on (most) 64bit systems.

No, that won't work. It because that,

#define sockaddr_storage __kernel_sockaddr_storage

struct __kernel_sockaddr_storage {
...
} __attribute__ ((aligned(_K_SS_ALIGNSIZE)))

#define _K_SS_ALIGNSIZE	(__alignof__ (struct sockaddr *))

A pointer is 8-byte on 64-bit systems. If changed "struct
__kernel_sockaddr_storage" to use,

__attribute__ ((aligned((4)))

it then silence the warnings.
