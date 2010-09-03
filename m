From: Shan Wei <shanwei@cn.fujitsu.com>
Date: Fri, 03 Sep 2010 02:03:42 +0000
Subject: Re: [PATCH] sctp: implement SIOCINQ ioctl() (take 2)
Message-Id: <4C80577E.7050005@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1283476464-14341-1-git-send-email-flameeyes@gmail.com>
In-Reply-To: <1283476464-14341-1-git-send-email-flameeyes@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: =?UTF-8?B?RGllZ28gRWxpbyBQZXR0ZW7Dsg==?= <flameeyes@gmail.com>
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, Vlad Yasevich <vladislav.yasevich@hp.com>

Forward to linux-sctp maillist.


Diego Elio Pettenò wrote, at 09/03/2010 09:14 AM:
> From: Diego Elio 'Flameeyes' Pettenò <flameeyes@gmail.com>
> 
> This simple patch copies the current approach for SIOCINQ ioctl() from DCCP
> into SCTP so that the userland code working with SCTP can use a similar
> interface across different protocols to know how much space to allocate for
> a buffer.

lack of your singed-of-by.


-- 
Best Regards
-----
Shan Wei

> ---
>  net/sctp/socket.c |   35 ++++++++++++++++++++++++++++++++++-
>  1 files changed, 34 insertions(+), 1 deletions(-)
> 
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index ca44917..54c01e4 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -3595,7 +3595,40 @@ out:
>  /* The SCTP ioctl handler. */
>  SCTP_STATIC int sctp_ioctl(struct sock *sk, int cmd, unsigned long arg)
>  {
> -	return -ENOIOCTLCMD;
> +	int rc = -ENOTCONN;
> +
> +	sctp_lock_sock(sk);
> +
> +	/*
> +	 * SEQPACKET-style sockets in LISTENING state are valid, for
> +	 * SCTP, so only discard TCP-style sockets in LISTENING state.
> +	 */
> +	if (sctp_style(sk, TCP) && sctp_sstate(sk, LISTENING))
> +		goto out;
> +
> +	switch (cmd) {
> +	case SIOCINQ: {
> +		struct sk_buff *skb;
> +		unsigned long amount = 0;
> +
> +		skb = skb_peek(&sk->sk_receive_queue);
> +		if (skb != NULL) {
> +			/*
> +			 * We will only return the amount of this packet since
> +			 * that is all that will be read.
> +			 */
> +			amount = skb->len;
> +		}
> +		rc = put_user(amount, (int __user *)arg);
> +	}
> +		break;
> +	default:
> +		rc = -ENOIOCTLCMD;
> +		break;
> +	}
> +out:
> +	sctp_release_sock(sk);
> +	return rc;
>  }
>  
>  /* This is the function which gets called during socket creation to
