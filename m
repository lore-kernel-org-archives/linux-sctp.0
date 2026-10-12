Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F57C446847
	for <linux-sctp@vger.kernel.org>; Mon, 12 Oct 2026 20:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.215.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791837812; cv=pass; b=efCbCU+BLGoIKjvjE6LcCAqTzsUtyUuIjUmv8rJUeGKKb+l0i0ew4yB/THGAtEwMLtG1rxRJaIiehCf5JhtuSNrEO3aZ1Kqrt3SGfl3eifE8pP47+Mh2UUqUYBxWvh5cKt9vpiSeReM/LvRO23k/4cLoC6QCROH53YgmGVq+gXI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791837812; c=relaxed/simple;
	bh=V9thtctaEPB6lL/KXtYDegVWUvfdX7j2N6TX62uRfpI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oUlWCAKXgvtlfwiAJ3FVBtthsWySqf2irs0c+eOFrzcxaPDbNCHneO/4U2cA8/xgCgTKUjLPXkgiPxKZwXgF581YWYCzYAzkaS1jCGfBvHttMSYBxA7a8Njc1ouWoP5OD1KqonYuF5PC2TQUdd7/azWfMi1QTr6kDX2QbefC1CE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pLtp9PA2; arc=pass smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pLtp9PA2"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-cc4dbcf2b85so878501a12.3
        for <linux-sctp@vger.kernel.org>; Mon, 12 Oct 2026 13:43:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791837811; cv=none;
        d=google.com; s=arc-20260327;
        b=qBLQaZXoZ2jOMeflHwHaPcReo6XjKyUBx+bgIMdusDxyUKOft0C/EBzqdm/G5zbC30
         VViE/DzxaGEwGKSH72D2JE+ZxBVYVTYfANWMu2jTvS2yOFFoQ9cSUbcQ60x0AkJ4Q2Vp
         lcZnLL6VYuwyA3goTqHD6NcQReYwSczfHsil6cY3CfvJ5PakRel/fGcYPCkQx0Z8heMY
         xGDlwGDZMyu2XXMvMKnY7AVqx+thmeIfZN2lo59WOguNJzr16cEfe/q7ziPnHBFSRx+Z
         ucFMvOQY+6Vs7ehgkjW+jbdXzdvCG1gtGK8eOApyGwqblLgV3vQ1NBd7FCMSYh4yxCNP
         AvVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=gBTKp/yDTh6RzoG3bbVkNoxEHUElC4XTCqvtS+EhVmE=;
        fh=mRcUvvbskKNkQm6/Xi+3gjMhJQbnu4HkmQdVOWTJPkw=;
        b=T8cY2q3OCtMfEM7RD8Dxl1+ovY5hcTyt1n1w7MLinnoam5dWwSLuRWvL7ai2fsRKsp
         KxawZHrk/T6kywN3Ulzygc6S4ijs8I2p37c/SuZ9t0UYGpZMmJsAXw3vr8PxloZZM55p
         rYSwRW89Q92hB0XBQ6xEcDI5Fhhq/QQZBXFd0xM4tgEkGA9QiMQschEBnpCJI4RKPtvI
         QRdevE/+PGYAUnbuiABCvmsYcsTrV5VSQF5dGCBEthrl605nzGCW1uhIekNTkTi8uWFf
         2scKqY+oTF97ZlrnluUOOY3XWKFJd3NXasM3e1g62eBIvU7thGdhfRGtQhmHiA55ygt4
         LcFQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791837811; x=1792442611; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gBTKp/yDTh6RzoG3bbVkNoxEHUElC4XTCqvtS+EhVmE=;
        b=pLtp9PA2RAqjY7DSMRJvq4Zsh9sbldCLLKKPH35EPwjd4Jjj7CHmM38YJ0shnL+dlw
         l93RHLRt/m5FVQbXV88j/4HcoLKELGT4xfyxX/6wkU9Z6WU5TzYMWYDy2LuEZF263X7X
         bxIvNIQ5K1a/A8aFpaVGbf0szBHVhMuugH8gFO+DuPPvOnWgGKkuK6V6SlZs+CWxrUPn
         gQ7uJzb45Yhau7AQ/W/NmdPgwW0pfz4JDGV9z+vGJYhIPZL0Qcj31HfHX9VmkrPX0QET
         GQcKecrrTjCV2bmb5jG2ZEgFh2OPhCRYgcG5QHK7eSf/OmHgazdvSjD7hhmcHPi1hiza
         37Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791837811; x=1792442611;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gBTKp/yDTh6RzoG3bbVkNoxEHUElC4XTCqvtS+EhVmE=;
        b=qeAh3CStQUb0fUJh4Bu/CU1E354e2vfpgBu2b8TPle1i529IDhwKPgrQAOXnpW94sZ
         aoAFCpTbnjP3QeBwIstETocBrgg5ZVnMWNj0l9TBY3LHq08aoR49nTXqdZoV7TQJXtKv
         bXGIb1A94ucHw7WqU+VWcy7aVFve5u+jSiJ5CxVdHObrVAIaBTvPiroAPlqbhPNuAr92
         hx0kaKLcIHDpjMl8wGhD1BFBSpcR1W8MLQCTHHmuKt+tp7d5aWmTkrYvu4yhaK9/d3xJ
         K38Y3VuPhxhMfVuk1rvx4UoGJ2VO7ufCr/dR7QI2NwKGkavGUPRlVSm9RI3eyL2NgT9e
         xn7A==
X-Forwarded-Encrypted: i=1; AKwUvBwfh1se8Nx2a4sQS9xs5BehnU8UETX8nvVOZgeUOhJyiV8DbK4/pCNRn5soF6XGZ/o0qLusiaH5CNww@vger.kernel.org
X-Gm-Message-State: AFq9FYIJH4yoHRlUVnmn64GaN05Km6bSakRacAeKHiq0q8WKqIMrXs/L
	gQMdprRalUThFad1LyZ32DwtJV6LeVuDZuC19pVrfrKYm7K/ydAJqdmbjpg5X164XaLK5z3v1+1
	+2oZ10zZbDXY2ylaUerajmXGeuT+R3OQ=
X-Gm-Gg: AYBFou1FdXCtqXcHK3da9356EfNIwg9FQcd6k0uUvO3vpt00CkIiwdU2BL9JWlaqkjg
	qB7fs9bRMeYB0qeHxesD9/BjLWOrcobC78wsJvBMRKIxNW37RaYDE1ilks9ChCn/s4STpu816Ya
	ZP/C4WXgJ23HIhLcC7LER2JISntkBF0lDmPPC/kn9XxtJmVC+vWEcGB2CaVZPY/9pk9sc2gmAhY
	OrPIqRepZa0P0zkAk7uRNDWkGuVStZCeBRWRn52FmBXFy9gH9WIlVcbXClWn2ud8HfbN8tYZT0H
	5lp7NTPe8ZHEaRjc/Sdo40QxOsMsawL78DxDWyWTQyVp9vNsIZ/LmtvhHMk9++Vw0dSOXSNb0bx
	rhw2Q9fednRZbjVJIYdzdAhQwo7NEh7MtDJglGLN2dU3Q5vbk/FD1as7fhg==
X-Received: by 2002:a05:6a21:4ea8:b0:3cc:92d9:80cb with SMTP id
 adf61e73a8af0-3e16bf7b29amr8270211637.12.1791837810715; Mon, 12 Oct 2026
 13:43:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261009074601.3954275-1-hdthky0@gmail.com> <179162162010.434549.13276446555925201942@kernel.org>
In-Reply-To: <179162162010.434549.13276446555925201942@kernel.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 12 Oct 2026 16:43:16 -0400
X-Gm-Features: AclHuK__f9Fmh30gHFKiGhSOt6lO_--K35IuH8GJSBpMK6CIFrgoJ7zRY7PfsL8
Message-ID: <CADvbK_c49wgA41_NwOig7TosQKAnNdkUa3HwgPCSukTpJ9DAtg@mail.gmail.com>
Subject: Re: [PATCH v4] sctp: reject forged cookie peer_addr with unknown
 address family
To: netdev-bot+sashiko@kernel.org
Cc: hdthky0@gmail.com, marcelo.leitner@gmail.com, davem@davemloft.net, 
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, 
	linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 10, 2026 at 4:40=E2=80=AFAM <netdev-bot+sashiko@kernel.org> wro=
te:
>
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue(s) to consider.
>
> Critical: 0 =C2=B7 High: 0 =C2=B7 Medium: 1 =C2=B7 Low: 0 (1)
>
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwor=
k
> know by including "pw-bot: cr" as a separate line at the end of your repl=
y
> (one such reply per series is enough).
>
> - [Medium] The patch now validates peer_addr in place.
>
> Pre-existing issues:
> - [Low] Two comments next to the code this patch changes contradict the
>   implementation.
>
> --
>
> sctp: reject forged cookie peer_addr with unknown address family
>
> This patch validates the COOKIE-ECHO peer_addr with af->addr_valid() in
> sctp_unpack_cookie(). Bad families are rejected, and v4-mapped addresses
> are normalised in place. It also makes sctp_v6_addr_valid() reject
> non-v4-mapped addresses on non-PF_INET6 sockets, uses addr_valid() to
> simplify sctp_process_param(), and adds a missing !af check in
> sctp_process_init().
>
> > diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
> > index ef26878f1282a..97390569c4bdc 100644
> > --- a/net/sctp/ipv6.c
> > +++ b/net/sctp/ipv6.c
> > @@ -725,7 +725,8 @@ static int sctp_v6_available(union sctp_addr *addr,=
 struct sctp_sock *sp)
> >   * SCTP.
> >   *
> >   * Output:
> > - * Return 0 - If the address is a non-unicast or an illegal address.
> > + * Return 0 - If the address is a non-unicast or an illegal address,
> > + *            or a non-v4-mapped address on a non-PF_INET6 socket.
> >   * Return 1 - If the address is a unicast.
> >   */
> >  static int sctp_v6_addr_valid(union sctp_addr *addr,
>
> [Severity: Low]
>
> This isn't a bug introduced by this patch, but two nearby comments
> don't match the code that this patch now relies on.
>
> The v4-mapped branch of sctp_v6_addr_valid() says:
>
>         /* Note: This routine is used in input, so v4-mapped-v6
>          * are disallowed here when there is no sctp_sock.
>          */
>         if (sp && ipv6_only_sock(sctp_opt2sk(sp)))
>                 return 0;
>         sctp_v6_map_v4(addr);
>
> When sp is NULL, as in the sctp_rcv() input path, the code maps and
> accepts the address instead of rejecting it.
>
> The header comment of sctp_v4_addr_valid() in net/sctp/protocol.c only
> lists non-unicast or illegal addresses as reasons to return 0. The
> function also returns 0 for any IPv4 address on an IPV6_V6ONLY socket:
>
>         /* IPv4 addresses not allowed */
>         if (sp && ipv6_only_sock(sctp_opt2sk(sp)))
>                 return 0;
>
> This patch removes the explicit ipv6_only_sock() test from
> sctp_process_param(), so that function now depends on this check.
>
> The sctp_v6_addr_valid() header comment is already being updated here.
> Could these two comments be updated as well?
>
> [ ... ]
>
> > diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
> > index 84a4c97d0f755..175dbb242e1cb 100644
> > --- a/net/sctp/sm_make_chunk.c
> > +++ b/net/sctp/sm_make_chunk.c
>
> [ ... ]
>
> > @@ -1841,6 +1843,11 @@ struct sctp_association *sctp_unpack_cookie(
> >               goto fail;
> >       }
> >
> > +     paddr =3D &bear_cookie->peer_addr;
> > +     af =3D sctp_get_af_specific(paddr->sa.sa_family);
> > +     if (!af || !af->addr_valid(paddr, sctp_sk(ep->base.sk), NULL))
> > +             goto malformed;
> > +
>
> [Severity: Medium]
>
> Can this modify packet data that is shared with a clone? bear_cookie
> points into the received skb. sctp_sf_do_5_1D_ce() and
> sctp_sf_do_5_2_4_dupcook() both set:
>
>         chunk->subh.cookie_hdr =3D
>                 (struct sctp_signed_cookie *)chunk->skb->data;
>
> For an AF_INET6 v4-mapped peer_addr, sctp_v6_addr_valid() calls
> sctp_v6_map_v4(), which writes directly into that buffer:
>
>         addr->v4.sin_family =3D AF_INET;
>         addr->v4.sin_port =3D addr->v6.sin6_port;
>         addr->v4.sin_addr.s_addr =3D addr->v6.sin6_addr.s6_addr32[3];
>
> No skb_cloned() or skb_unshare() check happens before this write.
>
> If an AUTH chunk is bundled before the COOKIE-ECHO,
> sctp_endpoint_bh_rcv() and sctp_assoc_bh_rcv() do:
>
>         chunk->auth_chunk =3D skb_clone(chunk->skb,
>                                 GFP_ATOMIC);
>
> The clone shares the same data.
>
> sctp_sf_do_5_1D_ce() calls sctp_unpack_cookie() first. AUTH is verified
> only afterwards:
>
> sctp_auth_chunk_verify()
>   sctp_sf_authenticate()
>     sctp_auth_calculate_hmac()
>       data_len =3D skb_tail_pointer(skb) - (unsigned char *)auth;
>
> That HMAC covers the COOKIE-ECHO body, including the rewritten
> peer_addr. The peer computed its HMAC over the original bytes. Would
> verification then fail and the COOKIE-ECHO be dropped through
> sctp_sf_pdiscard()? The duplicate-cookie handlers use the same order:
> unpack first, then verify AUTH.
>
> Other holders of a clone, such as raw IPPROTO_SCTP sockets and non-mmap
> AF_PACKET readers, would also see the changed bytes. sctp_rcv() doesn't
> prevent this, because skb_linearize() does nothing to an skb that is
> already linear but cloned.
>
> A v4-mapped peer_addr doesn't have to be forged. For an INIT that
> arrives over IPv6 from a ::ffff:a.b.c.d source, sctp_make_temp_asoc()
> stores the raw source in the signed cookie:
>
>         SCTP_INPUT_CB(skb)->af->from_skb(&asoc->c.peer_addr, skb, 1);
>
> It can also be forged directly when cookie authentication is disabled.
>
> In that case, the commit message statement "peer_addr is validated in
> place, so a v4-mapped v6 address is normalised to AF_INET before the
> association and its primary transport are built from it" would not hold
> when AUTH is bundled.
>
> Would it work to validate and normalise a stack copy of peer_addr, and
> pass that copy to the association and transport setup, instead of
> writing into the packet buffer?

This looks like a valid issue. We can't modify bear_cookie->peer_addr
through skb->data, so please restore your previous copy method. To address
the report from v3, you can then restore retval->c.peer_addr after copying
the cookie into the new association in sctp_unpack_cookie():

        /* Populate the association from the cookie.  */
        memcpy(&retval->c, bear_cookie, sizeof(*bear_cookie));
+       retval->c.peer_addr =3D paddr;

Also, change to use &new_asoc->c.peer_addr instead of
&chunk->subh.cookie_hdr->c.peer_addr in sctp_sf_do_5_1D_ce():

        if (!sctp_process_init(new_asoc, chunk,
-                              &chunk->subh.cookie_hdr->c.peer_addr,
+                              &new_asoc->c.peer_addr,
                               peer_init, GFP_ATOMIC))

Please give it a try.

Thanks.

pw-bot: cr
