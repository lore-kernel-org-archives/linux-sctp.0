From: Shan Wei <shanwei@cn.fujitsu.com>
Date: Wed, 15 Sep 2010 08:44:24 +0000
Subject: Re: [PATCH] net: SCTP NULL-pointer dereference problem description
Message-Id: <4C908768.4040502@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <201009151003.17407.dreibh@iem.uni-due.de>
In-Reply-To: <201009151003.17407.dreibh@iem.uni-due.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Thomas Dreibholz <dreibh@iem.uni-due.de>
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, Martin Becke <martin.becke@uni-due.de>

Thomas Dreibholz wrote, at 09/15/2010 04:03 PM:
> sctp_assoc_update_retran_path() in net/sctp/associola.c may dereference a=
=20
> NULL-pointer when compiled with SCTP_DEBUG option: t will be NULL if ther=
e is=20
> no usable path for retransmission. SCTP_DEBUG_PRINTK_IPADDR() makes an ac=
cess=20
> to t->ipaddr.v4.sin_port, without checking t before. t=3DNULL =3D> oops.
>=20
> The patch below against 2.6.36-rc4 (git repository) simply ensures that t=
 is=20
> checked for not being set to NULL before calling SCTP_DEBUG_PRINTK_IPADDR=
().

This bug has been reported by WeiYongjun and fixed by vlad for several mont=
hs.
About the details see .
http://marc.info/?l=3Dlinux-sctp&m=127359276009851&w=3D2

But this patch is still in vlad's net-next tree, not in main tree.
See the patch:
http://git.kernel.org/?p=3Dlinux/kernel/git/vxy/lksctp-dev.git;a=3Dcommit;h=
=EB1639d206320e6a09168d6dd77306eaf5f02582



>=20
>=20
> Signed-off-by: Thomas Dreibholz <dreibh@iem.uni-due.de>
> ---
> diff --git a/net/sctp/associola.c b/net/sctp/associola.c
> index e41feff..b2688a4 100644
> --- a/net/sctp/associola.c
> +++ b/net/sctp/associola.c
> @@ -1321,15 +1321,15 @@ void sctp_assoc_update_retran_path(struct=20
> sctp_association *asoc)
>  		}
>  	}
>=20
> -	if (t)
> +	if (t) {
>  		asoc->peer.retran_path =3D t;
> -
> -	SCTP_DEBUG_PRINTK_IPADDR("sctp_assoc_update_retran_path:association"
> -				 " %p addr: ",
> -				 " port: %d\n",
> -				 asoc,
> -				 (&t->ipaddr),
> -				 ntohs(t->ipaddr.v4.sin_port));
> +		SCTP_DEBUG_PRINTK_IPADDR("sctp_assoc_update_retran_path:association"
> +					 " %p addr: ",
> +					 " port: %d\n",
> +					 asoc,
> +					 (&t->ipaddr),
> +					 ntohs(t->ipaddr.v4.sin_port));
> +	}
>  }
>=20
>  /* Choose the transport for sending retransmit packet.  */
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
>=20


--=20

Best Regards
-----
Shan Wei
