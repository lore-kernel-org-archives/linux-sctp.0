Received: from mail-pz2-f41.google.com (mail-pz2-f41.google.com [74.125.228.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A63349CF30
	for <linux-sctp@vger.kernel.org>; Mon, 21 Sep 2026 13:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789996954; cv=pass; b=V5kOVi+PJGLPb0R6FnYbxG6PTouFUvgsvfo9e6qEMv4Uz/gMTuXM+AS/N6xp3MecW4eoqCocF7G8OyaE53mPzz0hoWWBctYO+986FrH/xFjaO6Y5WNWjwod5Z8cVu1ynBTVDhcsiWkZo4Pg3+eUAVUeAb9LbS54CLyLRw87IOCE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789996954; c=relaxed/simple;
	bh=q0Rgrb3mklPfNQOTHmKN1ETL7s9UMkDuqdVY/nwEHwU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dk0qLpArReSCHDBTCbwUPICYg8hDcg7WZEJLwaL5EDkpOt5JNABCeMr6Z37UETKWEf/0xjiFjUKR562yCIvL9APcwy/2rCPZgMifo2lY7614TAS3Or+6uRWr8aYRPmCTJ4iEhoQiPPle9XCe2diWAulcSUmOyrO+XKkAH7syp/Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dXJUw9UQ; arc=pass smtp.client-ip=74.125.228.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dXJUw9UQ"
Received: by mail-pz2-f41.google.com with SMTP id d2e1a72fcca58-85469a34908so2657425b3a.0
        for <linux-sctp@vger.kernel.org>; Mon, 21 Sep 2026 06:22:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789996952; cv=none;
        d=google.com; s=arc-20260327;
        b=LmUj2w+OGD8uudFuuk2/2yEvi9FgI73HTRrIdPrbYIaQjiRIMBldkNRJtwt5waBJWy
         Nw6gwOlAm7rj7AkFTTh8Vyv1TYQjv0lNR8oHjXQyS26Gxx30M4N3lBfRmtyuM6g9j/uH
         XHTRZsDhF46/lDc1PsBXj21AfiGeybf8p8rW/ValSOEaH0OLXhZoDYLcoKtEW1i5gfON
         ub93bFxoxPS5J1klQyYXymzfonaF7+wCwAWahTekRWgdLG2gREa5T8ND3VzVTcYDT8Jm
         Zwf55Gq3wAfsn7j4UXGbl6lISaOX9wjsCEPh45QxtQ9jwTR/kIG5nO/c+gCdIia1Ei9e
         cndg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=NCyT56f7SIOC3arok05y+rtGMVn6dlMONoZIfjEFKRc=;
        fh=DcJgPFX6dyr5lFr3KOBpQDVKcG9cO6x+CLxJWwCYWDU=;
        b=bMJgxzCJbNxBVDw18S6Qf4c76mDXM/Ksegyac6M9s/WD1BjSw6jJC1DuhxT1UmmrJu
         n1j/cpk4nGnP8Hq+tbyzPnNYbD+TljJoMQkhQ6j5nexFMoxBqgnAFiJp6qzDE/qlHYJa
         3r1vkizdOaiz3Xv/ZepnM/QhCh21hhSbv1stBsuYhgDrplBsxQoGT1kRS6fYHL9HflG3
         AYfukx4O+DCZsAKY2B00Es8fdCVjXyDU/z5qq9nx4lSQOiedhAO0UtNvQO+k/xSGe/+b
         uLG1sXblUZS75WNuJh/reRD4aZ5e725uIxxuniw9Mwetoe7AUFNe7arflIk99bNlM4J1
         TPXg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789996952; x=1790601752; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=NCyT56f7SIOC3arok05y+rtGMVn6dlMONoZIfjEFKRc=;
        b=dXJUw9UQuZywow1s5YGz6Afbw57l+XzDhYoQRc6NaQn2llxRhPegS+p072RA4CcYya
         SBukJytjJ0vMWl0hwPQn/5WnbxZZ1JUck8mr/t49T+S9NaTpke6Vqho11O/fLJKztI9e
         gffO0fM7FTjPZ5xr+LMEIL/u2k25ZIuKDS3NMstSlv5ubMRrFyZKLKEHVPbRc95yxBVZ
         HZb1X/BxgsYnr2VGe+gxzrMOf/j6JIeR/iXofPfiUyeZQTludZ7VrFLVEMF39988vQ2b
         8RabrFo+yAK86iV12pvwWZNAzIIaRLTR0wOHEWYm+HCLm8tovy9xn7ePVItsINpzFo/w
         CQlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789996952; x=1790601752;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NCyT56f7SIOC3arok05y+rtGMVn6dlMONoZIfjEFKRc=;
        b=iqjPK+sUIkJrhx+eRnj/DtQ67yJBlZr0Mm0IJAJmgv5EQgWF3rrPlx8pvLL5Wr2IOu
         RcqdeBukeiuS/W7hS6UUw98r1dMs/ncz5IbIe2HDyEyFAqUuZj1XB94NwFeLXuyaVKxM
         hfp7jMxTGQ4o9qQb5+2TnfWtfcq68JeJkIiJC5lBfo8awCn6uBIgnRtqvtvum4Grp6y2
         Q/ujN8ssvTaaalsEDD8XjslhNdSA2DfLkHxfDvuNtjoY2p/HWrl63pZ2j3Ek1GOpGXFr
         UjA54a2q7NISxmlNsDbQFOwKroV3UJRR7F0+7SjK2SEayFUN1f/M0kK9m82BW9GOuX/4
         iXQQ==
X-Forwarded-Encrypted: i=1; AKwUvBwsjRqqwHUaCR5T7QUxap28qQ1Xc43cIwTvznjRkWbQAqnNuxLGL9Y78Xbd1j7MhLd/FwXyGX8Fhaf8@vger.kernel.org
X-Gm-Message-State: AFuF++lSH+nr6hJkow8C0YrjdcrC8GRMc5+wQMs8MIJS9bFj5YXMkLoS
	X9WOmsWGCeEEy3T8DBL2EWgTMkxZhZc9yXbs6zj1SSqp6NffZWd2iFLZ6DNCly7ezB5n9yhM0rV
	QfFLarRwJ7YBZuCNgs9cz/LDClIzcZGs=
X-Gm-Gg: AYBFou2nMckqoo6mTXUJwLiHnn2s09LC9kruJudZ4M+PiRalJrfSXapb6gGdWSSCvi2
	kOd9qUbs6IHjDKug6KfP2pjENw5yYUwgHw7jUpUDxdSe2MO8evnc1Nll8Fn7TsQMtpwcqtTzNJn
	aJZXnEn+lfwbzgRDsH9y+WPp37O7rnMzMbXmCZv+yuWNQOOMBjH0/opbeMUjv8qPNWwTvc0RgOG
	hB8A/Zdv3b6PZn3+MEDEQWDNtgjRqQSZuiaMOvPCRXfXgbk+dsMpU3kwbS29jeOQHDrMcKgK/Y0
	RtZ8s/a8BjLQitEqugQhMBIHUtxX2WS0FENvn6AquDNQ91zYWNwS/tnQujAGNoftox0Tp6MV1js
	bp8yk+y2wU+7Ria8yA1FyoOoWzRueTWreO58z/6uIHDBHtybkhA6A5w==
X-Received: by 2002:a05:6a00:1584:b0:879:2a08:99bb with SMTP id
 d2e1a72fcca58-8792a08a88bmr4708773b3a.56.1789996952141; Mon, 21 Sep 2026
 06:22:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260917030505.4176635-1-hdthky0@gmail.com> <178996115646.2160803.7706206745490493314@kernel.org>
In-Reply-To: <178996115646.2160803.7706206745490493314@kernel.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 21 Sep 2026 09:22:20 -0400
X-Gm-Features: AcwNN1X-Y21APkEp22wEnaBkfw87Wx27-8Ih2hHw4nv8RtpRyhs6lWyLNy-xnPM
Message-ID: <CADvbK_f1hihbvFB7G0aEicBcQz5hiuFQwcdQKsqsvhgz5kZ=8w@mail.gmail.com>
Subject: Re: [PATCH v3] sctp: reject forged cookie peer_addr with unknown
 address family
To: netdev-bot+sashiko@kernel.org
Cc: hdthky0@gmail.com, marcelo.leitner@gmail.com, davem@davemloft.net, 
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, 
	linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 20, 2026 at 11:26=E2=80=AFPM <netdev-bot+sashiko@kernel.org> wr=
ote:
>
> Thank you for your contribution! Sashiko AI review found 3 potential
> issue(s) to consider.
>
> Critical: 0 =C2=B7 High: 0 =C2=B7 Medium: 2 =C2=B7 Low: 1
>
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwor=
k
> know by including "pw-bot: cr" as a separate line at the end of your repl=
y
> (one such reply per series is enough).
>
> - [Medium] Undisclosed UAPI/behavioural regression on two socket-option
>   paths.
> - [Medium] sctp_unpack_cookie() validates a stack *copy* of the attacker-
>   controlled cookie peer_addr (`paddr =3D bear_cookie->peer_addr; ...=E2=
=80=A6
> - [Low] The kernel-doc block above sctp_v6_addr_valid()
>   (net/sctp/ipv6.c:724-730) documents the return value purely as a=E2=80=
=A6
>
> --
>
> sctp: reject forged cookie peer_addr with unknown address family
>
> This validates the attacker-controlled COOKIE-ECHO peer_addr in
> sctp_unpack_cookie() with af->addr_valid() on a stack copy, makes
> sctp_v6_addr_valid() reject non-PF_INET6 sockets, and reuses
> addr_valid() in sctp_process_param() while adding the missing !af
> checks.
>
> A few questions below.
>
> > diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
> > index ef26878f1282a..c45ac15f3b79d 100644
> > --- a/net/sctp/ipv6.c
> > +++ b/net/sctp/ipv6.c
> > @@ -734,6 +734,9 @@ static int sctp_v6_addr_valid(union sctp_addr *addr=
,
> >  {
> >       int ret =3D ipv6_addr_type(&addr->v6.sin6_addr);
> >
> > +     if (sp && sctp_opt2sk(sp)->sk_family !=3D PF_INET6)
> > +             return 0;
> > +
>
> [Severity: Medium]
> Should this gate sit before the IPV6_ADDR_MAPPED branch?  Placed here it
> also rejects a v4-mapped sockaddr_in6 on an AF_INET socket, not only
> genuine IPv6 addresses, and it fires for every caller that passes a
> non-NULL sctp_sock.
>
> Two socket option callers build af straight from the user-supplied
> sa_family with no pf->af_supported() cross-check first, unlike
> sctp_verify_addr() which goes through sctp_sockaddr_af() ->
> opt->pf->af_supported().
>
> net/sctp/socket.c:sctp_bindx_rem() {
>         ...
>         af =3D sctp_get_af_specific(sa_addr->sa.sa_family);
>         if (!af) {
>                 retval =3D -EINVAL;
>                 goto err_bindx_rem;
>         }
>
>         if (!af->addr_valid(sa_addr, sp, NULL)) {
>                 retval =3D -EADDRNOTAVAIL;
>                 goto err_bindx_rem;
>         }
>         ...
> }
>
> net/sctp/socket.c:sctp_setsockopt_peer_primary_addr() {
>         ...
>         if (!af->addr_valid((union sctp_addr *)&prim->sspp_addr, sp, NULL=
))
>                 return -EADDRNOTAVAIL;
>         ...
> }
>
> Before this change, a v4-mapped sockaddr_in6 handed to a non-v6only
> PF_INET socket was rewritten in place by sctp_v6_map_v4() and validated
> as IPv4, so sctp_del_bind_addr() and sctp_assoc_lookup_laddr() then
> operated on the normalised AF_INET address and could succeed.  With the
> new early return, do SCTP_SOCKOPT_BINDX_REM and
> SCTP_SET_PEER_PRIMARY_ADDR with ::ffff:a.b.c.d now return -EADDRNOTAVAIL
> where they previously worked?
>
Moving if (sp && sctp_opt2sk(sp)->sk_family !=3D PF_INET6) to the end
of sctp_v6_addr_valid() should fix this.

> The changelog describes the helper change only in terms of the cookie and
> INIT paths ("so that IPv6 addresses are never used on IPv4 sockets") and
> does not mention the socket API side effect.  Since the patch carries
> Fixes: 1da177e4c3f4 and will be picked up for stable, could this be eithe=
r
> described in the changelog or scoped to the paths that need it?
>
> [Severity: Low]
> This isn't a bug, but the comment block above sctp_v6_addr_valid() still
> documents the verdict as a property of the address alone:
>
> /* This function checks if the address is a valid address to be used for
>  * SCTP.
>  *
>  * Output:
>  * Return 0 - If the address is a non-unicast or an illegal address.
>  * Return 1 - If the address is a unicast.
>  */
>
> A legal global unicast IPv6 address now returns 0 whenever the supplied
> sctp_sock is not PF_INET6, and the callers above turn that into
> -EADDRNOTAVAIL.  Could the comment gain a line about the socket family
> rejection?
>
> >       /* Support v4-mapped-v6 address. */
> >       if (ret =3D=3D IPV6_ADDR_MAPPED) {
> >               /* Note: This routine is used in input, so v4-mapped-v6
>
> > diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
> > index 84a4c97d0f755..20c0938948843 100644
> > --- a/net/sctp/sm_make_chunk.c
> > +++ b/net/sctp/sm_make_chunk.c
>
> [ ... ]
>
> > @@ -1841,6 +1843,11 @@ struct sctp_association *sctp_unpack_cookie(
> >               goto fail;
> >       }
> >
> > +     paddr =3D bear_cookie->peer_addr;
> > +     af =3D sctp_get_af_specific(paddr.sa.sa_family);
> > +     if (!af || !af->addr_valid(&paddr, sctp_sk(ep->base.sk), NULL))
> > +             goto malformed;
> > +
>
> [Severity: Medium]
> Is the object that gets validated here the same one that is later used?
>
> sctp_v6_addr_valid() only declares a v4-mapped AF_INET6 address valid
> after rewriting it in place:
>
> net/sctp/ipv6.c:sctp_v6_addr_valid() {
>         ...
>         if (ret =3D=3D IPV6_ADDR_MAPPED) {
>                 ...
>                 sctp_v6_map_v4(addr);
>                 return sctp_get_af_specific(AF_INET)->addr_valid(addr, sp=
, skb);
>         }
>         ...
> }
>
> The rewrite lands in the throw-away stack copy paddr, which is then
> discarded.  The association and its primary transport are built from the
> original in-skb address:
>
> net/sctp/sm_statefuns.c:sctp_sf_do_5_1D_ce() {
>         ...
>         if (!sctp_process_init(new_asoc, chunk,
>                                &chunk->subh.cookie_hdr->c.peer_addr,
>                                peer_init, GFP_ATOMIC))
>         ...
> }
>
> and memcpy(&retval->c, bear_cookie, sizeof(*bear_cookie)) copies the
> un-normalised address into the association.
>
> So for a forged cookie carrying sa_family =3D AF_INET6 with ::ffff:a.b.c.=
d
> on a dual-stack PF_INET6 listener, the check passes (validated as IPv4)
> while sctp_assoc_add_peer() -> sctp_transport_new() installs an AF_INET6
> v4-mapped primary with af_specific =3D IPv6, and the primary path is then
> driven through sctp_v6_get_dst() with a v4-mapped destination.  The IPv4
> address parameters from the same forged INIT are normalised to AF_INET, s=
o
> the same peer ends up with transports of two different families.
>
> The sibling call site added by the same patch does consume the normalised
> address:
>
> net/sctp/sm_make_chunk.c:sctp_process_param() {
>         ...
>                 if (!af || !af->from_addr_param(&addr, param.addr,
>                                                 htons(asoc->peer.port), 0=
) ||
>                     !af->addr_valid(&addr, sctp_sk(asoc->base.sk), NULL))
>                         break;
>                 scope =3D sctp_scope(peer_addr);
>                 if (sctp_in_scope(net, &addr, scope))
>                         if (!sctp_assoc_add_peer(asoc, &addr, gfp, SCTP_U=
NCONFIRMED))
>         ...
> }
>
> Could the two new users of addr_valid() be made to agree, for instance by
> storing the validated copy into retval->c.peer_addr and having the state
> function pass that instead of re-reading the raw cookie, so nothing is
> written into the possibly shared skb?
>
Please pass the reference of bear_cookie->peer_addr instead of the
copy to af->addr_valid().

  paddr =3D &bear_cookie->peer_addr;

Thanks.
