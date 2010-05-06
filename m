From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Date: Thu, 06 May 2010 08:23:54 +0000
Subject: Re: [RFC PATCH v2] sctp: fix sctp to work with ipv6 source address
Message-Id: <4BE27C9A.5060302@6wind.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1273062644-11097-2-git-send-email-vladislav.yasevich@hp.com>
In-Reply-To: <1273062644-11097-2-git-send-email-vladislav.yasevich@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org

Hi Vlad,

I didn't succeed to test this patch. My kernel is not really an head, but a=
=20
2.6.33, maybe I miss a patch.

My tesbed:

       A -------------- B
2001::102:101   2001::101:101

With this patch, the stack send out wrong packets. This is a capture on B:
10:15:00.879812 ::.39713 > 2001::101:101.1234: sctp [class 0x2]
10:15:03.877103 ::.39713 > 2001::101:101.1234: sctp [class 0x2]
10:15:09.875920 ::.39713 > 2001::101:101.1234: sctp [class 0x2]
10:15:21.874233 ::.39713 > 2001::101:101.1234: sctp [class 0x2]


Regards,
Nicolas

Le 05.05.2010 14:30, Vlad Yasevich a =C3=A9crit :
> From: Weixing Shi <Weixing.Shi@windriver.com>
>=20
> <vlad>
> Ok, updated to be a bit more correct.  Only leave the function early if t=
he
> first lookup succeeds.
> </vlad>
>=20
> in the below test case, using the source address routing,
> sctp can not work.
> Node-A
> 1)ifconfig eth0 inet6 add 2001:1::1/64
> 2)ip -6 rule add from 2001:1::1 table 100 pref 100
> 3)ip -6 route add 2001:2::1 dev eth0 table 100
> 4)sctp_darn -H 2001:1::1 -P 250 -l &
> Node-B
> 1)ifconfig eth0 inet6 add 2001:2::1/64
> 2)ip -6 rule add from 2001:2::1 table 100 pref 100
> 3)ip -6 route add 2001:1::1 dev eth0 table 100
> 4)sctp_darn -H 2001:2::1 -P 250 -h 2001:1::1 -p 250 -s
>=20
> root cause:
> Node-A and Node-B use the source address routing, and
> at begining, source address will be NULL,sctp will
> search the  routing table by the destination address,
> because using the source address routing table, and
> the result dst_entry will be NULL.
>=20
> solution:
> walk through the bind address list to get the source
> address and then lookup the routing table again to get
> the correct dst_entry.
>=20
> Signed-off-by: Weixing Shi <Weixing.Shi@windriver.com>
> Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>
> ---
>  net/sctp/ipv6.c |  113 ++++++++++++++++++++++++++++++++++---------------=
------
>  1 files changed, 70 insertions(+), 43 deletions(-)
>=20
> diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
> index 7326891..f75e2f8 100644
> --- a/net/sctp/ipv6.c
> +++ b/net/sctp/ipv6.c
> @@ -77,6 +77,10 @@
>  #include <net/sctp/sctp.h>
> =20
>  #include <asm/uaccess.h>
> +static void sctp_v6_dst_saddr(union sctp_addr *addr, struct dst_entry *d=
st,
> +            __be16 port);
> +static int sctp_v6_cmp_addr(const union sctp_addr *addr1,
> +          const union sctp_addr *addr2);
> =20
>  /* Event handler for inet6 address addition/deletion events.
>   * The sctp_local_addr_list needs to be protocted by a spin lock since
> @@ -242,8 +246,12 @@ static struct dst_entry *sctp_v6_get_dst(struct sctp=
_association *asoc,
>  					 union sctp_addr *daddr,
>  					 union sctp_addr *saddr)
>  {
> -	struct dst_entry *dst;
> +	struct dst_entry *dst =3D NULL;
>  	struct flowi fl;
> +	struct sctp_bind_addr *bp;
> +	struct sctp_sockaddr_entry *laddr;
> +	union sctp_addr dst_saddr;
> +	sctp_scope_t scope;
> =20
>  	memset(&fl, 0, sizeof(fl));
>  	ipv6_addr_copy(&fl.fl6_dst, &daddr->v6.sin6_addr);
> @@ -259,16 +267,71 @@ static struct dst_entry *sctp_v6_get_dst(struct sct=
p_association *asoc,
>  	}
> =20
>  	dst =3D ip6_route_output(&init_net, NULL, &fl);
> +
> +	bp =3D &asoc->base.bind_addr;
> +	scope =3D sctp_scope(daddr);
> +
>  	if (!dst->error) {
> +		if (!asoc || saddr)
> +			goto out;
> +
> +		/* Walk through the bind address list and look for a bind
> +		 * address that matches the source address of the returned dst.
> +		 */
> +		sctp_v6_dst_saddr(&dst_saddr, dst, htons(bp->port));
> +		rcu_read_lock();
> +		list_for_each_entry_rcu(laddr, &bp->address_list, list) {
> +			if (!laddr->valid || (laddr->state !=3D SCTP_ADDR_SRC))
> +				continue;
> +
> +			/* Do not compare against v4 addrs */
> +			if ((laddr->a.sa.sa_family =3D AF_INET6) &&
> +			   (sctp_v6_cmp_addr(&dst_saddr, &laddr->a)))
> +				goto out_unlock;
> +		}
> +		rcu_read_unlock();
> +
> +		/* None of the bound addresses match the source address of the
> +		 * dst. So release it.
> +		 */
> +		dst_release(dst);
> +		dst =3D NULL;
> +	}
> +
> +	/* Walk through the bind address list and try to get a dst that
> +	 * matches a bind address as the source address.
> +	 */
> +	rcu_read_lock();
> +	list_for_each_entry_rcu(laddr, &bp->address_list, list) {
> +		if (!laddr->valid || (laddr->state !=3D SCTP_ADDR_SRC))
> +			continue;
> +
> +		if ((laddr->a.sa.sa_family =3D AF_INET6) &&
> +		    (scope <=3D sctp_scope(&laddr->a))) {
> +			ipv6_addr_copy(&fl.fl6_src, &laddr->a.v6.sin6_addr);
> +			dst =3D ip6_route_output(&init_net, NULL, &fl);
> +			if (dst->error) {
> +				dst_release(dst);
> +				dst =3D NULL;
> +			} else
> +				break;
> +		}
> +	}
> +
> +out_unlock:
> +	rcu_read_unlock();
> +
> +out:
> +	if (dst) {
>  		struct rt6_info *rt;
>  		rt =3D (struct rt6_info *)dst;
>  		SCTP_DEBUG_PRINTK("rt6_dst:%pI6 rt6_src:%pI6\n",
>  			&rt->rt6i_dst.addr, &rt->rt6i_src.addr);
>  		return dst;
> -	}
> -	SCTP_DEBUG_PRINTK("NO ROUTE\n");
> -	dst_release(dst);
> -	return NULL;
> +	} else=20
> +		SCTP_DEBUG_PRINTK("NO ROUTE\n");
> +
> +	return dst;
>  }
> =20
>  /* Returns the number of consecutive initial bits that match in the 2 ip=
v6
> @@ -289,13 +352,6 @@ static void sctp_v6_get_saddr(struct sctp_sock *sk,
>  			      union sctp_addr *daddr,
>  			      union sctp_addr *saddr)
>  {
> -	struct sctp_bind_addr *bp;
> -	struct sctp_sockaddr_entry *laddr;
> -	sctp_scope_t scope;
> -	union sctp_addr *baddr =3D NULL;
> -	__u8 matchlen =3D 0;
> -	__u8 bmatchlen;
> -
>  	SCTP_DEBUG_PRINTK("%s: asoc:%p dst:%p daddr:%pI6 ",
>  			  __func__, asoc, dst, &daddr->v6.sin6_addr);
> =20
> @@ -310,38 +366,9 @@ static void sctp_v6_get_saddr(struct sctp_sock *sk,
>  		return;
>  	}
> =20
> -	scope =3D sctp_scope(daddr);
> -
> -	bp =3D &asoc->base.bind_addr;
> -
> -	/* Go through the bind address list and find the best source address
> -	 * that matches the scope of the destination address.
> -	 */
> -	rcu_read_lock();
> -	list_for_each_entry_rcu(laddr, &bp->address_list, list) {
> -		if (!laddr->valid)
> -			continue;
> -		if ((laddr->state =3D SCTP_ADDR_SRC) &&
> -		    (laddr->a.sa.sa_family =3D AF_INET6) &&
> -		    (scope <=3D sctp_scope(&laddr->a))) {
> -			bmatchlen =3D sctp_v6_addr_match_len(daddr, &laddr->a);
> -			if (!baddr || (matchlen < bmatchlen)) {
> -				baddr =3D &laddr->a;
> -				matchlen =3D bmatchlen;
> -			}
> -		}
> -	}
> -
> -	if (baddr) {
> -		memcpy(saddr, baddr, sizeof(union sctp_addr));
> -		SCTP_DEBUG_PRINTK("saddr: %pI6\n", &saddr->v6.sin6_addr);
> -	} else {
> -		printk(KERN_ERR "%s: asoc:%p Could not find a valid source "
> -		       "address for the dest:%pI6\n",
> -		       __func__, asoc, &daddr->v6.sin6_addr);
> -	}
> +	if (dst)
> +		sctp_v6_dst_saddr(saddr, dst, htons(asoc->base.bind_addr.port));
> =20
> -	rcu_read_unlock();
>  }
> =20
>  /* Make a copy of all potential local addresses. */
