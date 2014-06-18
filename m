From: David Miller <davem@davemloft.net>
Date: Wed, 18 Jun 2014 23:33:01 +0000
Subject: Re: [PATCH net-next 6/6] Support for SCTP_DEFAULT_SNDINFO socket option
Message-Id: <20140618.163301.1261423911029627800.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1403017296-28469-1-git-send-email-geirola@gmail.com>
	<1403017296-28469-7-git-send-email-geirola@gmail.com>
In-Reply-To: <1403017296-28469-7-git-send-email-geirola@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: geirola@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, vyasevich@gmail.com

From: Geir Ola Vaagland <geirola@gmail.com>
Date: Tue, 17 Jun 2014 17:01:36 +0200

> +
> +	/* Note! asoc->default_timetolive is not set in this way anymore.
> +	 * The PR-SCTP extension needs to be implemented.
> +    */

This comment is not formatted correctly.

> +	if (asoc) {
> +		asoc->default_stream = info.snd_sid;
> +		asoc->default_flags = info.snd_flags;
> +		asoc->default_ppid = info.snd_ppid;
> +		asoc->default_context = info.snd_context;
> +	} else {
> +		sp->default_stream = info.snd_sid;
> +		sp->default_flags = info.snd_flags;
> +		sp->default_ppid = info.snd_ppid;
> +		sp->default_context = info.snd_context;
> +	}
> +	return 0;
> +}
> +
>  
>  /* 7.1.10 Set Primary Address (SCTP_PRIMARY_ADDR)

Only one empty line between top-level objects in a source file,
thank you.

>   *
> @@ -5063,6 +5115,45 @@ static int sctp_getsockopt_default_send_param(struct sock *sk,
>  
>  	return 0;
>  }
> +static int sctp_getsockopt_default_sndinfo(struct sock *sk,
> +					int len, char __user *optval,

Please one empty line between top level objects in the source file.
