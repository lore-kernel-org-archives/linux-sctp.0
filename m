From: David Laight <David.Laight@ACULAB.COM>
Date: Tue, 30 Jul 2019 14:59:12 +0000
Subject: RE: [PATCH v2] net/socket: fix GCC8+ Wpacked-not-aligned warnings
Message-Id: <69c6beab2d734ed88ce31a6381f85420@AcuMS.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1564497488-3030-1-git-send-email-cai@lca.pw>
In-Reply-To: <1564497488-3030-1-git-send-email-cai@lca.pw>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 'Qian Cai' <cai@lca.pw>, "davem@davemloft.net" <davem@davemloft.net>
Cc: "vyasevich@gmail.com" <vyasevich@gmail.com>, "nhorman@tuxdriver.com" <nhorman@tuxdriver.com>, "marcelo.leitner@gmail.com" <marcelo.leitner@gmail.com>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

From: Qian Cai
> Sent: 30 July 2019 15:38
...
> Use an implicit alignment for "struct __kernel_sockaddr_storage" so it
> can keep the same alignments as a member in both packed and un-packed
> structures without breaking UAPI.
> 
> Suggested-by: David Laight <David.Laight@ACULAB.COM>
...

Although I suggested it needs a bit of tidy up.

Add a comment maybe:

/* The definition uses anonymous union and struct in order to
 * control the default alignment. */

>  struct __kernel_sockaddr_storage {
> -	__kernel_sa_family_t	ss_family;		/* address family */
> -	/* Following field(s) are implementation specific */
> -	char		__data[_K_SS_MAXSIZE - sizeof(unsigned short)];
> +	union {
> +		void *__align; /* implementation specific desired alignment */

Move the 'void *' below the struct so the first member is the 'public one.

> +		struct {
> +			__kernel_sa_family_t	ss_family; /* address family */
> +			/* Following field(s) are implementation specific */
> +			char __data[_K_SS_MAXSIZE - sizeof(unsigned short)];
>  				/* space to achieve desired size, */
>  				/* _SS_MAXSIZE value minus size of ss_family */
> -} __attribute__ ((aligned(_K_SS_ALIGNSIZE)));	/* force desired alignment */
> +			};
> +		};
> +};
> 
>  #endif /* _UAPI_LINUX_SOCKET_H */
> --
> 1.8.3.1

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
