From: David Miller <davem@davemloft.net>
Date: Tue, 26 Apr 2011 07:12:27 +0000
Subject: Re: [PATCH net-next-2.6 4/7] sctp: remove useless arguments from
Message-Id: <20110426.001227.112589346.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <4DB63F85.2090609@cn.fujitsu.com>
	<4DB6405B.2060200@cn.fujitsu.com>
In-Reply-To: <4DB6405B.2060200@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
To: yjwei@cn.fujitsu.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Tue, 26 Apr 2011 11:47:39 +0800

> @@ -392,11 +392,11 @@ static inline int sctp_v6_addr_match_len(union sctp=
_addr *s1,
>   */
>  static void sctp_v6_get_saddr(struct sctp_sock *sk,
>  			      struct sctp_transport *t,
> -			      union sctp_addr *daddr,
>  			      struct flowi *fl)
>  {
>  	struct flowi6 *fl6 =3D &fl->u.ip6;
>  	union sctp_addr *saddr =3D &t->saddr;
> +	union sctp_addr *daddr =3D &t->ipaddr;
> =20
>  	SCTP_DEBUG_PRINTK("%s: asoc:%p dst:%p daddr:%pI6 ",
>  			  __func__, t->asoc, t->dst, &daddr->v6.sin6_addr);

I really get grumpy when I have to fix up stuff like this:

net/sctp/ipv6.c: In function =A1sctp_v6_get_saddr=A2:
net/sctp/ipv6.c:382: warning: unused variable =A1daddr=A2

You guys know I'm going to immediately run make on any patch you send
me and look for new warnings.

Why waste my time and not look for them yourselves before posting the
patch?

This wasn't even one of those cases where the warning goes away at
the end of the patch series, and only exists somewhere in the middle.

=FF=F4=E8=BA{.n=C7+=89=B7=9F=AE=89=AD=86+%=8A=CB=FF=B1=E9=DD=B6=17=A5=8Aw=
=FF=BA{.n=C7+=89=B7=A5=8A{=B1=FE=C7-=A7=F8=A7=B6=17=9B=A1=DC=A8}=A9=9E=B2=
=C6=A0z=DA&j:+v=89=A8=FE=F8=1E=AF=F9=1E=AEw=A5=FE=8A=E02=8A=DE=99=A8=E8=AD=
=DA&=A2)=DF=A1=ABa=B6=DA=FF=FF=FB=E0z=BF=E4z=B9=DE=97=FA+=83=F9=9A=8E=8A=DD=
=A2j=FF=8Aw=E8=FE=1Bf
