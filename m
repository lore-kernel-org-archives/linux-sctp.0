Received: from mail-pz2-f34.google.com (mail-pz2-f34.google.com [74.125.228.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D746DF6C
	for <linux-sctp@vger.kernel.org>; Wed, 16 Sep 2026 01:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.34
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789520564; cv=pass; b=bQ3PW2JucghdMQE7qWLtLRfKWVL6jHwpsPWQpwzQ73olpd/dqTnIHVz83R5NKEhqsdcgk8pBrmu0OJL1o7OV0T6iiJ7QsKkcfQcyiBe2PSwbLkHv+m3X3ceHenregACqC1xtnFGTHJtgNauJW16/efP2Zc4oXimb3U5gH9hFhCA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789520564; c=relaxed/simple;
	bh=JMIZ1HQc/UBc+/CPxOO+3Fp2exN89TGzbvfAhz08DWA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bA8dB3om738iFq0gbBc0eLcvoIrQD2ayBRCuZAUak3YEne1X2tRPpXV+ScLZ3flWnMnq3vD59XaO1JcTAJyXy3tZvGb+wLdh4iN5eePX+dnjfwU0iPAYWXHiQO7yyAQgrraNys1r7Jb0ReCZd6Z25EhLvjMXnhzxyguYPBLVGGQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BEj80snP; arc=pass smtp.client-ip=74.125.228.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BEj80snP"
Received: by mail-pz2-f34.google.com with SMTP id 41be03b00d2f7-cc4ae616175so267194a12.1
        for <linux-sctp@vger.kernel.org>; Tue, 15 Sep 2026 18:02:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789520562; cv=none;
        d=google.com; s=arc-20260327;
        b=jCJsTQ5LT6on2K0f9ruloNNcLrlYfaxqDE7wwVOTSyVUWoqdukPlaUHV0OFbB2ih3d
         h/gBKm2X7PUlNJacvb2Ukhd+IDYL9GMdOMBG1GD8LG+bKgPRsOFi2M7vsn9b1KOcHXh4
         FheEUr8Rf12rSTrDG+c/oM2dk7+RohydyoNEoCPoTs/O94Y30r2I0rRhXu7+2wg86tMB
         s0w34Q214FupNPnv1Xg+4FxQtB24YmWF1VXOkxt6eoxrMLRG3LwV071gcD17JfgPNNoi
         7q/Qvp1QL63iWO7Ipu/QDb39ywwtx7C0bVEzps+e716LBWH4Q5YDUVsgFTKu1UhoS48S
         3ynQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5L4ngA2BVP+44InrGnb18L5ocpcWrylapMKoe4Jf2TQ=;
        fh=k8qEILKEIUEnV+7oZ/QtNR8ZD6lO0psgLvac5Ez25og=;
        b=JzzT91HKZvTr6dLrRG4GjBFvo77bGo8znKERaREMoOsjo8bgZUQogQg1hLGucWvNDN
         fk/MFYh76bAktv09quEexVMeRKNqPjIk3EyIU53ZufU+Wyim+T7mAzdQ41AEVdUJRxZx
         0YRm47lSrQT/HgE8/Mrv8XegbrV2wspl36HlzVdxPRlGX2iJz75jkugwmtVgxGxJtxeA
         SCJh33Nb9fWlbtxmjcEOWQemTiPLgR9NkAfXf2hWMMaScjEO+UCLjjrg4/rbzADYKvK4
         D4NLS4S/STYCqwaJgrPsL+0QbDQBuzkYAcoNLy7DWVVhfS7FEGNBLxb1xwMI3VoEmC8R
         D7bw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789520562; x=1790125362; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5L4ngA2BVP+44InrGnb18L5ocpcWrylapMKoe4Jf2TQ=;
        b=BEj80snP9g0qrQbG1oiuIIIkob3fFVgXSuKrYUCz7YrdKvqsj7XYA0+nKNFQbsYoZQ
         urOYl7NOBw4AOaY1cWiCl11yu2wjQO+QTd9L9cXtjBpvuvjxwYI5LPBRTT45QDQ9U7yB
         bC126KHec/wSDS2MD37Xcb9oVjmo8iEnM7RRLNvxz680IDngyB52+fOR/F3kSNhR3TRi
         4MdRWdEREPGWr4JddJVGpAysfCYX2DVcVPyVOIshFr0mPPgomYPaSBRFPxaBVXLHJsH6
         IBygzjzmLg8G5TdW+635czFQYc3Oy/AZ463/+D7D6d1k5B3N375NYzcrWBEY/zF2k+UD
         3b2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789520562; x=1790125362;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5L4ngA2BVP+44InrGnb18L5ocpcWrylapMKoe4Jf2TQ=;
        b=PzftxgfTdzmhkpSP4SfpaNDZuDJlpUxzX2XXmD8rhDPlsPefu+CXOUFsqKEqa7SoQC
         dCADWHYMCyVng5owlhIM1NU3OIR2vvEBGl4DPDB/je06LVfXQzxz9+qGxA+hx0MLMSdw
         I2GK8fC1d9+A0efxUoQcCzO2giJAnKJU8adQ0kxSCxF10RZ6y8d68gUCEeGB0+LqNjVz
         BOXJOlppwAUo4vp4PnEaaUpNKRWCppsF7KgoNEIyMPwP+G3DdG11/aIxOsnTvemkewKq
         J9OdF34ujgtriXhcnyq3+HZh1JMaASgMG1PSA4Bsry9ScR8tl4BL2bZcnC/ITngYYdug
         yy7Q==
X-Forwarded-Encrypted: i=1; AKwUvBw2NmH0defMwg3QTqF76cXHHTrF402iPEjhz1ce/Gv09qbrLqRdhvWtzAhI0oSThxf+AXO+7QgJu46C@vger.kernel.org
X-Gm-Message-State: AFuF++lv9xebE5GSnBOClgjOBz0lS09KB+169E3k4wb1IVFOeidCunRg
	z7YBqYtwf3YYoD08ph+wfO2cICD7aJP2dAhwWpqXXcvVYduER5MhFbF9CZDvys+zpVA/BhjHvdg
	PqTjoDmT8hNK3SNXTzCmWPFeUhtJwD8U=
X-Gm-Gg: AYBFou1XgJ2Fj8PizRaw7Z3Kub5+eDkPULbvIhls2wScoNr201Jw3RwJUCTyQo9PBQt
	i3OuUp64MU5D4M5lyV3bvRqVFXBRPRi5DYAu7Lf7e0AbHgIKAk5FTqkNrXC+Lx/tsSl3mgkHmdJ
	zpyFMkaQVZAA77az5jKa1O/dFNloCHW1hxkdQ0YcTVO0iwQOEj+jdNzIVMkgE7/saX1018EeHoq
	6t/+okRasUcC1/WQXXliry7I38hSmD0m+zYfY6pw9MVn1VUDw+i0PVCGlk7M0LpHwS7BbOmUP3T
	mP2ighDOR6GjXP9HQ6YRQX41WcJoV1+fF4EaKFsY0XRfcBpx+Mp4ASMvhdoUqg5vk/w++YmRcB9
	EUND7UyFNENtMuiCWVyDMA8d+kuRRgonjz2NchZwm8XwPDohY8rZy
X-Received: by 2002:a05:6a21:514:b0:3c3:6928:8b25 with SMTP id
 adf61e73a8af0-3dd5f5ab211mr1680582637.17.1789520561620; Tue, 15 Sep 2026
 18:02:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260915212917.3775248-1-hdthky0@gmail.com>
In-Reply-To: <20260915212917.3775248-1-hdthky0@gmail.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 15 Sep 2026 21:02:29 -0400
X-Gm-Features: AcwNN1V0CM-5mz5gun9fainBhvQUZHzvH84RDSHXKS3zSGsNubBDWwnxO4U9zfE
Message-ID: <CADvbK_dqcndstCnBYLaT4BRwBcTPrz+n97Xu0LTGuxyW0x8jsA@mail.gmail.com>
Subject: Re: [PATCH v2] sctp: reject forged cookie peer_addr with unknown
 address family
To: Xingyuan Mo <hdthky0@gmail.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, "open list:SCTP PROTOCOL" <linux-sctp@vger.kernel.org>, 
	"open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 15, 2026 at 5:29=E2=80=AFPM Xingyuan Mo <hdthky0@gmail.com> wro=
te:
>
> When cookie authentication is disabled, COOKIE-ECHO peer_addr is
> attacker-controlled. An invalid sa_family made sctp_get_af_specific()
> return NULL and crash in sctp_transport_init() on
> af_specific->sockaddr_len. Validate it with af->addr_valid() in
> sctp_unpack_cookie(), which also rejects a mismatched family, e.g.
> an AF_INET6 peer_addr on an IPv4 socket that would later crash in
> sctp_v6_get_dst() on inet6_sk(sk)->opt, and bail in
> sctp_transport_new() if af_specific is missing. Validate a copy of
> peer_addr, since addr_valid() rewrites a v4-mapped v6 address in
> place and the cookie still lives in the received skb, which is not
> guaranteed to be unshared.
>
> For that, sctp_v6_addr_valid() has to return 0 when it is called with
> a socket that is not PF_INET6, so that IPv6 addresses are never used
> on IPv4 sockets. As addr_valid() now also checks sk_family and
> ipv6_only_sock, simplify the address handling in sctp_process_param()
> with it, as it additionally filters out non-unicast addresses. As a
> side effect, a v4-mapped address in an IPv6 address parameter is now
> normalised to AF_INET before the transport is created, matching what
> the socket API paths already do.
>
> Also add the missing !af check in sctp_process_init(), as
> sctp_get_af_specific(AF_INET6) returns NULL on CONFIG_IPV6=3Dn builds.
>
>   BUG: KASAN: null-ptr-deref in sctp_transport_new+0xa7/0x350
>   Read of size 4 at addr 00000000000000b4 by task poc/682
>   Call Trace:
>    <IRQ>
>    sctp_transport_new+0xa7/0x350
>    sctp_assoc_add_peer+0x153/0x850
>    sctp_process_init+0xf9/0x1180
>    sctp_sf_do_5_1D_ce+0x464/0xbc0
>    sctp_do_sm+0x114/0x2990
>    sctp_endpoint_bh_rcv+0x280/0x430
>    sctp_inq_push+0xdd/0x100
>    sctp_rcv+0x17f5/0x1ae0
>    sctp4_rcv+0x2b/0x40
>    ip_protocol_deliver_rcu+0x25b/0x270
>    ip_local_deliver+0xd1/0xe0
>    </IRQ>
>   Kernel panic - not syncing: Fatal exception in interrupt
>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Assisted-by: opencode:deepseek-v4
> Signed-off-by: Xingyuan Mo <hdthky0@gmail.com>
> ---
>
> Changes since v1 [1]:
> - validate the forged cookie peer_addr with af->addr_valid() instead of
>   a family whitelist, and make sctp_v6_addr_valid() reject non-PF_INET6
>   sockets, so a forged AF_INET6 cookie can no longer crash an IPv4
>   socket in sctp_v6_get_dst() (found by Sashiko)
> - simplify sctp_process_param() address handling with addr_valid(), as
>   addr_valid() now also checks sk_family and ipv6_only_sock
> - add the missing !af check in sctp_process_init() for CONFIG_IPV6=3Dn
>   builds (suggested by Xin Long)
>
> [1] https://lore.kernel.org/netdev/20260913113522.2674588-1-hdthky0@gmail=
.com/
>
>  net/sctp/ipv6.c          |  3 +++
>  net/sctp/sm_make_chunk.c | 25 +++++++++++++++++--------
>  net/sctp/transport.c     |  3 +++
>  3 files changed, 23 insertions(+), 8 deletions(-)
>
> diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
> index ef26878f1282..c45ac15f3b79 100644
> --- a/net/sctp/ipv6.c
> +++ b/net/sctp/ipv6.c
> @@ -734,6 +734,9 @@ static int sctp_v6_addr_valid(union sctp_addr *addr,
>  {
>         int ret =3D ipv6_addr_type(&addr->v6.sin6_addr);
>
> +       if (sp && sctp_opt2sk(sp)->sk_family !=3D PF_INET6)
> +               return 0;
> +
>         /* Support v4-mapped-v6 address. */
>         if (ret =3D=3D IPV6_ADDR_MAPPED) {
>                 /* Note: This routine is used in input, so v4-mapped-v6
> diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
> index 84a4c97d0f75..cfc4973f4d4a 100644
> --- a/net/sctp/sm_make_chunk.c
> +++ b/net/sctp/sm_make_chunk.c
> @@ -1732,7 +1732,9 @@ struct sctp_association *sctp_unpack_cookie(
>         struct sctp_cookie *bear_cookie;
>         struct sctp_chunkhdr *ch;
>         unsigned int len, chlen;
> +       union sctp_addr paddr;
>         enum sctp_scope scope;
> +       struct sctp_af *af;
>         ktime_t kt;
>
>         /* Header size is static data prior to the actual cookie, includi=
ng
> @@ -1841,6 +1843,15 @@ struct sctp_association *sctp_unpack_cookie(
>                 goto fail;
>         }
>
> +       /* peer_addr is peer-controlled when cookie authentication is
> +        * disabled.  Validate a copy, as addr_valid() may rewrite a
> +        * v4-mapped address in place.
> +        */
af->addr_valid() is more like ensuring the address is a unicast address
and the socket supports the address family. You can either improve
the inline comment above or just remove it.

> +       paddr =3D bear_cookie->peer_addr;
> +       af =3D sctp_get_af_specific(paddr.sa.sa_family);
> +       if (!af || !af->addr_valid(&paddr, sctp_sk(ep->base.sk), NULL))
> +               goto malformed;
> +
>         /* Make a new base association.  */
>         scope =3D sctp_scope(sctp_source(chunk));
>         retval =3D sctp_association_new(ep, ep->base.sk, scope, gfp);
> @@ -2381,6 +2392,8 @@ int sctp_process_init(struct sctp_association *asoc=
, struct sctp_chunk *chunk,
>                     (param.p->type =3D=3D SCTP_PARAM_IPV4_ADDRESS ||
>                      param.p->type =3D=3D SCTP_PARAM_IPV6_ADDRESS)) {
>                         af =3D sctp_get_af_specific(param_type2af(param.p=
->type));
> +                       if (!af)
> +                               continue;
>                         if (!af->from_addr_param(&addr, param.addr,
>                                                  chunk->sctp_hdr->source,=
 0))
>                                 continue;

You can merge these 2 checks with (!af || !af->from_addr_param()).

> @@ -2554,18 +2567,14 @@ static int sctp_process_param(struct sctp_associa=
tion *asoc,
>          */
>         switch (param.p->type) {
>         case SCTP_PARAM_IPV6_ADDRESS:
> -               if (PF_INET6 !=3D asoc->base.sk->sk_family)
> -                       break;
> -               goto do_addr_param;
> -
>         case SCTP_PARAM_IPV4_ADDRESS:
> -               /* v4 addresses are not allowed on v6-only socket */
> -               if (ipv6_only_sock(asoc->base.sk))
> -                       break;
> -do_addr_param:
>                 af =3D sctp_get_af_specific(param_type2af(param.p->type))=
;
> +               if (!af)
> +                       break;
>                 if (!af->from_addr_param(&addr, param.addr, htons(asoc->p=
eer.port), 0))
>                         break;

Same here.

> +               if (!af->addr_valid(&addr, sctp_sk(asoc->base.sk), NULL))
> +                       break;
>                 scope =3D sctp_scope(peer_addr);
>                 if (sctp_in_scope(net, &addr, scope))
>                         if (!sctp_assoc_add_peer(asoc, &addr, gfp, SCTP_U=
NCONFIRMED))
> diff --git a/net/sctp/transport.c b/net/sctp/transport.c
> index 6ea55b9fbde4..cd1a604d6f8e 100644
> --- a/net/sctp/transport.c
> +++ b/net/sctp/transport.c
> @@ -92,6 +92,9 @@ struct sctp_transport *sctp_transport_new(struct net *n=
et,
>  {
>         struct sctp_transport *transport;
>
> +       if (!sctp_get_af_specific(addr->sa.sa_family))
> +               return NULL;
> +

Any reason why we need this check?

Thanks.

>         transport =3D kzalloc_obj(*transport, gfp);
>         if (!transport)
>                 return NULL;
> --
> 2.43.0
>
