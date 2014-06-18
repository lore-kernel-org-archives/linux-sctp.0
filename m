From: David Miller <davem@davemloft.net>
Date: Wed, 18 Jun 2014 23:30:03 +0000
Subject: Re: [PATCH net-next 1/6] Support for SCTP_RECVRCVINFO socket option
Message-Id: <20140618.163003.1333759678831582150.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1403017296-28469-1-git-send-email-geirola@gmail.com>
	<1403017296-28469-2-git-send-email-geirola@gmail.com>
In-Reply-To: <1403017296-28469-2-git-send-email-geirola@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: geirola@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, vyasevich@gmail.com

From: Geir Ola Vaagland <geirola@gmail.com>
Date: Tue, 17 Jun 2014 17:01:31 +0200

> +}
> +
> +
> +
>  /* API 6.2 setsockopt(), getsockopt()

Please do not add more than one empty line between top-level objects
in the source file.


> +	return 0;
> +}
> +
> +
> +
>  static int sctp_getsockopt(struct sock *sk, int level, int optname,
>  			   char __user *optval, int __user *optlen)

Likewise.
