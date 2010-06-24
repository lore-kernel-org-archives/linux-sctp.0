From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Thu, 24 Jun 2010 13:19:49 +0000
Subject: Re: [PATCH] sctp: implement SIOCINQ ioctl()
Message-Id: <4C235B75.2000807@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1277329060-21543-1-git-send-email-flameeyes@gmail.com>
In-Reply-To: <1277329060-21543-1-git-send-email-flameeyes@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: =?ISO-8859-1?Q?Diego_Elio_=27Flameeyes=27_Petten=F2?= <flameeyes@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org



Diego Elio 'Flameeyes' Petten=F2 wrote:
> This simple patch copies the current approach for SIOCINQ ioctl() from DC=
CP
> into SCTp so that the userland code working with SCTP can use a similar
> interface across different protocols to know how much space to allocate f=
or
> a buffer.
> ---
>  net/sctp/socket.c |   31 ++++++++++++++++++++++++++++++-
>  1 files changed, 30 insertions(+), 1 deletions(-)
>=20
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index 44a1ab0..3135b4e 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -3595,7 +3595,36 @@ out:
>  /* The SCTP ioctl handler. */
>  SCTP_STATIC int sctp_ioctl(struct sock *sk, int cmd, unsigned long arg)
>  {
> -	return -ENOIOCTLCMD;
> +	int rc =3D -ENOTCONN;
> +
> +	sctp_lock_sock(sk);
> +
> +	if (sctp_sstate(sk, LISTENING))

This should add a check for sctp_style(sk, TCP), since one can't read from
a TCP style listening sockets, but can do so from UDP-style (SOCK_SEQPACKET=
).

-vlad

> +		goto out;
> +
> +	switch(cmd) {
> +	case SIOCINQ: {
> +		struct sk_buff *skb;
> +		unsigned long amount =3D 0;
> +
> +		skb =3D skb_peek(&sk->sk_receive_queue);
> +		if (skb !=3D NULL) {
> +			/*
> +			 * We will only return the amount of this packet since
> +			 * that is all that will be read.
> +			 */
> +			amount =3D skb->len;
> +		}
> +		rc =3D put_user(amount, (int __user *)arg);
> +	}
> +		break;
> +	default:
> +		rc =3D -ENOIOCTLCMD;
> +		break;
> +	}
> +out:
> +	sctp_release_sock(sk);
> +	return rc;
>  }
> =20
>  /* This is the function which gets called during socket creation to
