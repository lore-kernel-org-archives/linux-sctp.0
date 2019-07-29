From: David Laight <David.Laight@ACULAB.COM>
Date: Mon, 29 Jul 2019 10:39:16 +0000
Subject: RE: [PATCH] net/sctp: fix GCC8+ -Wpacked-not-aligned warnings
Message-Id: <158b26b6f3b24164aceacd2428095315@AcuMS.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1564174659-21211-1-git-send-email-cai@lca.pw>
In-Reply-To: <1564174659-21211-1-git-send-email-cai@lca.pw>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 'Qian Cai' <cai@lca.pw>, "vyasevich@gmail.com" <vyasevich@gmail.com>, "nhorman@tuxdriver.com" <nhorman@tuxdriver.com>, "marcelo.leitner@gmail.com" <marcelo.leitner@gmail.com>
Cc: "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

From: Qian Cai
> Sent: 26 July 2019 21:58
> 
> There are a lot of those warnings with GCC8+ 64bit,
> 
...
> Fix them by aligning the structures and fields to 8 bytes instead.
...
>  struct sctp_setpeerprim {
>  	sctp_assoc_t            sspp_assoc_id;
> -	struct sockaddr_storage sspp_addr;
> -} __attribute__((packed, aligned(4)));
> +	struct sockaddr_storage sspp_addr __attribute__((aligned(8)));
> +} __attribute__((packed, aligned(8)));

What happens to this one if you change both to aligned(4) ?
Much the same way as:
	struct {
		int a;
		long b __attribute__((aligned(4));
	};
is only 12 bytes on (most) 64bit systems.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
