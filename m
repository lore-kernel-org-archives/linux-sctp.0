From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 29 May 2019 23:37:57 +0000
Subject: Re: memory leak in sctp_process_init
Message-Id: <20190529233757.GC3713@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <00000000000097abb90589e804fd@google.com>
 <20190528013600.GM5506@localhost.localdomain>
 <20190528111550.GA4658@hmswarspite.think-freely.org>
 <20190529190709.GE31099@hmswarspite.think-freely.org>
In-Reply-To: <20190529190709.GE31099@hmswarspite.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Neil Horman <nhorman@tuxdriver.com>
Cc: syzbot <syzbot+f7e9153b037eac9b1df8@syzkaller.appspotmail.com>, davem@davemloft.net, linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com, vyasevich@gmail.com

On Wed, May 29, 2019 at 03:07:09PM -0400, Neil Horman wrote:
> --- a/net/sctp/sm_make_chunk.c
> +++ b/net/sctp/sm_make_chunk.c
> @@ -2419,9 +2419,12 @@ int sctp_process_init(struct sctp_association *asoc, struct sctp_chunk *chunk,
>  	/* Copy cookie in case we need to resend COOKIE-ECHO. */
>  	cookie = asoc->peer.cookie;
>  	if (cookie) {
> +		if (asoc->peer.cookie_allocated)
> +			kfree(cookie);
>  		asoc->peer.cookie = kmemdup(cookie, asoc->peer.cookie_len, gfp);
>  		if (!asoc->peer.cookie)
>  			goto clean_up;
> +		asoc->peer.cookie_allocated=1;
>  	}
>  
>  	/* RFC 2960 7.2.1 The initial value of ssthresh MAY be arbitrarily

What if we kmemdup directly at sctp_process_param(), as it's done for
others already? Like SCTP_PARAM_RANDOM and SCTP_PARAM_HMAC_ALGO. I
don't see a reason for SCTP_PARAM_STATE_COOKIE to be different
here. This way it would be always allocated, and ready to be kfreed.

We still need to free it after the handshake, btw.

  Marcelo
