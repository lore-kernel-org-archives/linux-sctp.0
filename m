From: "David Laight" <David.Laight@ACULAB.COM>
Date: Wed, 17 Apr 2013 08:43:45 +0000
Subject: RE: [PATCH net-next 4/9] net: sctp: sctp_outq: consolidate chars into bitfield
Message-Id: <AE90C24D6B3A694183C094C60CF0A2F6026B71DC@saturn3.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1366146438-8815-1-git-send-email-dborkman@redhat.com> <1366146438-8815-5-git-send-email-dborkman@redhat.com>
In-Reply-To: <1366146438-8815-5-git-send-email-dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Borkmann <dborkman@redhat.com>, davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

>  	__u32 outstanding_bytes;
> 
> -	/* Are we doing fast-rtx on this queue */
> -	char fast_rtx;
> -
> -	/* Corked? */
> -	char cork;
> -
> -	/* Is this structure empty?  */
> -	char empty;
> +	__u8 fast_rtx:1,	/* Are we doing fast-rtx on this queue */
> +	     cork:1,		/* Corked? */
> +	     empty:1;		/* Is this structure empty?  */
>  };

Use of bitfields just makes the code slower.
The only real excuse for using them is to reduce the size
of a structure that is allocated a lot.

In the above you are just increasing the padding from
1 byte to 3 bytes.

	David



