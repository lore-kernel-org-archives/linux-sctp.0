Received: from mail-pz2-f43.google.com (mail-pz2-f43.google.com [74.125.228.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB0C622A7F6
	for <linux-sctp@vger.kernel.org>; Mon, 14 Sep 2026 18:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789411533; cv=pass; b=oz2z3vTqV8N2BFCFGdKUPVye0L+11YcM4FE67sWgxaLtv9TLE5tBwP5NRgDMfgtfBq8IyIQYE3cSBcDLE6D4gh/ZSsmoHLE/m/s/hp2DFgBYJ4stOf9sEy5WhdVisi4cqyrjlp5NZBWbzBsVClnk14xlQpNmquhZn7UId/52Z4U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789411533; c=relaxed/simple;
	bh=SOaoH7wdfHga3kmm2KklRs8RybjgZlJTIv6zPmNSO9k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EoWTBOQpXCPtrRQ0gjEMMYTduJGGJh9F9tunvznNPCny7opi/XYeu8uVxJpN1iesSZ6/D+sOYZjl/5NuYh9tEYKOh9/3Z8LCyb5E1GKahWGHh8yTlAOAps+N4Og5m43ADZ7//oDJnxQ6LQSzoXUDCkdd9Km0O3lVX0Fnn9oKDcg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jdvwhteg; arc=pass smtp.client-ip=74.125.228.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jdvwhteg"
Received: by mail-pz2-f43.google.com with SMTP id d2e1a72fcca58-85469e25400so1884904b3a.0
        for <linux-sctp@vger.kernel.org>; Mon, 14 Sep 2026 11:45:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789411527; cv=none;
        d=google.com; s=arc-20260327;
        b=LfOHU81aXBhi40+zeZaCKAdSEVdQG40TLfcn5TKa8yJgEJ+HdxuRnKpUGfTZqa/knR
         OeX1Ixio7ZkGqA2fkuvyJ81b783YNZD27wFwQDnySF2QOrHa+ZkXeskNk4moMCJ9RAL/
         bM7sO0hMws6+139eY/Py8+5daWzIKkiDuQ9Yle3d7AXGfWs8lgNMbUc4dciAoBf8Lukj
         8JV69oSiiGjXWBIu4RPSQgpXAyYIQp0BOWMfOx/H1QHXS8bW4LlY4IIDf9eYTgIUn3dR
         j5T8EeBMoC53qxYqTeJfQf4IsEikd6DpwoOZ6aRYfe32QUnf+huyU8Rx4ue3/4vvrN81
         7wXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=32SMw+83rZgkWkErpxP8QdaEA2gM9ZInRO85Uqktxr0=;
        fh=Hqt/Hj3g+TLV2rvVUpPSwhJ/3biyPnFkwcrpAxh2caw=;
        b=iBYMkA83kQnFaRiYBScNBgeTs9HSt0uO1huTY7AlpQ7ty4O3CadJE4VK0197slInHC
         bxKMeSEnXARO3cGi9ixxXCyPkayCmDzRXurbdvx4NsbH9tJH6/9KvbOQPHP9o+YyV/d4
         OrGgq9LJKwOD6C9yUktUVGv7QPnZn8BjjBLSx2oJKFoGNtV1WXrS2D4ogYmBiv0AHrWP
         FJNlbnMdylAft41GQkShjQOPkKO1IPhITq+POlbqjKu17uvF3iTpLQz0O6o4qjb3xHvW
         zu3ogEPAsBBTqt0GklHgNYBUj6+EuIJlvrUR2/40Gzzjtmu6AXNJ/4k0fLU1+vMwp2k8
         RCBw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789411527; x=1790016327; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=32SMw+83rZgkWkErpxP8QdaEA2gM9ZInRO85Uqktxr0=;
        b=jdvwhtegZ5I4p5oGF4Ft2oW35QwTm8tX32nCVfwAYbEWv4rokCAgBFFrYfF0XlTPts
         JFmSHlRdF+fpSo4Fwql8nLmUKCTdLgbZeUPzVoIARHYcX0qGjLyCVRHOz2giUfYTF2dP
         AUiKUIQRhQoDFYM+IJ0uwTPMFuZ6NzudrHViurVAkLH5ksBkW5J766bO9ZzKc/15uf5t
         0sXi9h/lGcgZMHXdlBRz4a6dtAHP2vlIr/FPeMS5VtePMbG128UJxy59XWJv12SP2BV4
         ig7tbstObEzrDMapVmNJKhaRRJ4/rPSa5KXHhNdpMA1eq7Y1yK47PhF2ABuFgW8Ec9JM
         SyGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789411527; x=1790016327;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=32SMw+83rZgkWkErpxP8QdaEA2gM9ZInRO85Uqktxr0=;
        b=jLFNQZdy7B+yFul4N/RsdUAdigYiUtCthOC/maVqqDX5TNnNTSPWZkgypcI/Rp4udu
         +tnEwWqaBiGdg/n7cqLYJcxxjMmEXKVEXSHdZ0e/iBD8EcWcFQZyfnwFKuml2TrDyEbI
         ozPdVlKmizBsNf/3zLF4UpEC9gPeLxs6du4rUTBZR5yTCs51aXQkpQqosnQE+sOncpJ5
         dvIYX4xSs4P4raU4RqjGtRxLz5n12A9fS6o3bgin7MxVDlLWFMvUuHXYFg+zJgoYYeZ/
         wZTMhXCnTJAGJ1niQ1dzrkRQayZuIux3dKXNhbi4RdxrGfEgMt8W3xEOo+12jHSo/XIG
         s/9A==
X-Forwarded-Encrypted: i=1; AKwUvBzfnYmM0krn+4e4BE0lRvg9MzwwLPSYDFJeDy24SkBb7dS3Z3S6gr/d6yOq2JTRZq9gsCkjX+UUuOpt@vger.kernel.org
X-Gm-Message-State: AFuF++mzhDWrbpkFvy3z4MtgveBIAziGVd6Bws93D090OZPZctE5vb2q
	u79MKd0iqkMPV3gtMqEVJ7QMHDHvJ1QQxvlfW/KoMvmhOBLlQ7FXvbopC8kk3R7fmnAE/U7se+V
	r97Wl2zm+6WzaAj87X1ixrMeHM1qSC9MuMRKVWA9n8w==
X-Gm-Gg: AYBFou35n/V5BE5Ji1PkwJBaUfwu7uNhpivt87N9fOw5PCkLaSCTRZWNTyjKKdAZ8EF
	qPBKXPLA0XhqYX+N1/BN+17qWvR7oUbqrckTp0dG111/fuzl2cVjeHFAhUbEggCnAyWUSov20m+
	iBFu7gn51nJMTOmrJEJ3BjA5uEFgDOVA4uk9DzvZmkpPSHXYa2OFikcjzr7qmXgwkAnOxUFIpBf
	1F6kOb8zO9njURr80ghm66IfFKtTptx+Clxi/22PBetloJ16VrRMfersqIt8qn4Dj0Q/T8SaMum
	sKJ84OQTxlieSYe/nxaSCKedWbLLZfbunZkjAap1hlcSfdTFV7ll85FngSkQl171oVCAw5D9iQi
	9PsJjFLvSYaNCGD9QnlQ4VYLDju7f0ha03cP/gQjjuNbpwXSaltJfMQ==
X-Received: by 2002:a05:6a00:368b:b0:84e:e741:174f with SMTP id
 d2e1a72fcca58-86f83e3afdbmr8307833b3a.7.1789411527238; Mon, 14 Sep 2026
 11:45:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260913113522.2674588-1-hdthky0@gmail.com> <178938799829.22033.13386158820091728844@kernel.org>
In-Reply-To: <178938799829.22033.13386158820091728844@kernel.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 14 Sep 2026 14:45:15 -0400
X-Gm-Features: AcwNN1UoClxoGetwJ1AafGRvEazsIKxBVsqIWr5gxkX6ipl4l4fqy9ZTB8Hq45A
Message-ID: <CADvbK_f_im2JK5__BU+QHS1gyQ51QVRAD=8ov4rjVQmS1oNn5Q@mail.gmail.com>
Subject: Re: [PATCH] sctp: reject forged cookie peer_addr with unknown address family
To: netdev-bot+sashiko@kernel.org
Cc: hdthky0@gmail.com, marcelo.leitner@gmail.com, davem@davemloft.net, 
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, 
	linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 14, 2026 at 8:13=E2=80=AFAM <netdev-bot+sashiko@kernel.org> wro=
te:
>
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue(s) to consider:
>
> Critical: 0 =C2=B7 High: 1 (1) =C2=B7 Medium: 0 =C2=B7 Low: 0
>
> - [High] Incomplete fix: sctp_unpack_cookie()
>   (net/sctp/sm_make_chunk.c:1858-1860) only checks that the forged=E2=80=
=A6
>
> Pre-existing issues:
> - [High] This problem wasn't introduced by this patch, but the patch
>   establishes the NULL-check contract for sctp_get_af_specific() at one=
=E2=80=A6
>
> --
>
> sctp: reject forged cookie peer_addr with unknown address family
>
> This adds a family whitelist for the COOKIE-ECHO cookie peer_addr in
> sctp_unpack_cookie(), and makes sctp_transport_new() bail out when
> sctp_get_af_specific() has no implementation for the requested family.
> Both changes target the null dereference seen from sctp_transport_init().
>
> > diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
> > index 84a4c97d0f755..7c8fe4b38cd1c 100644
> > --- a/net/sctp/sm_make_chunk.c
> > +++ b/net/sctp/sm_make_chunk.c
> > @@ -1855,6 +1855,10 @@ struct sctp_association *sctp_unpack_cookie(
> >       if (!sctp_auth_verify_cookie_params(ep, bear_cookie))
> >               goto malformed;
> >
> > +     if (bear_cookie->peer_addr.sa.sa_family !=3D AF_INET &&
> > +         bear_cookie->peer_addr.sa.sa_family !=3D AF_INET6)
> > +             goto malformed;
> > +
>
> [Severity: High]
> Does this check still leave the mismatched-family case open?  It only ask=
s
> whether sa_family is one of AF_INET or AF_INET6, it never relates that fa=
mily
> to the family of the endpoint that received the packet.
>
> On a PF_INET listener with cookie authentication disabled the cookie cont=
ents
> are attacker supplied, so sa_family can be AF_INET6.  The new guard in
> sctp_transport_new() passes as well, since sctp_get_af_specific(AF_INET6)=
 is
> non-NULL on CONFIG_IPV6 kernels, and the transport ends up with
> af_specific =3D sctp_af_inet6.
>
> sctp_assoc_add_peer() then routes that transport using the IPv4 socket:
>
> net/sctp/associola.c:sctp_assoc_add_peer() {
>         sp =3D sctp_sk(asoc->base.sk);
>         ...
>         /* Initialize the pmtu of the transport. */
>         sctp_transport_route(peer, NULL, sp);
> }
>
> sctp_transport_route() calls af->get_dst(), which is sctp_v6_get_dst() he=
re:
>
> net/sctp/ipv6.c:sctp_v6_get_dst() {
>         struct ipv6_pinfo *np =3D inet6_sk(sk);
>         ...
>         final_p =3D fl6_update_dst(fl6, rcu_dereference(np->opt), &final)=
;
> }
>
> inet6_sk() returns inet_sk(sk)->pinet6, which is only populated by
> inet6_create(), so np is NULL for an AF_INET socket and np->opt is
> dereferenced with no guard.
>
> Isn't that the same remotely triggered null dereference in softirq contex=
t
> that this patch is meant to close, only at a different offset?
>
> For comparison, sctp_process_param() already refuses IPv6 addresses on
> sockets that are not PF_INET6:
>
>         case SCTP_PARAM_IPV6_ADDRESS:
>                 if (PF_INET6 !=3D asoc->base.sk->sk_family)
>                         break;
>
> Would it make more sense to validate the cookie family against the receiv=
ing
> socket family, or against SCTP_INPUT_CB(skb)->af->sa_family, rather than
> accepting AF_INET6 unconditionally?
>
I think you can try fixing it with af->addr_valid() in
sctp_unpack_cookie(), like:

        paddr =3D &bear_cookie->peer_addr;
        af =3D sctp_get_af_specific(paddr->sa.sa_family);
        if (!af || !af->addr_valid(paddr, sctp_sk(ep->base.sk), NULL))
                goto malformed;

You may also need to add an inet.sk.sk_family check in
sctp_v6_addr_valid():

diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
index ef26878f1282..12e429b3e2d1 100644
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -734,6 +734,9 @@ static int sctp_v6_addr_valid(union sctp_addr *addr,
 {
        int ret =3D ipv6_addr_type(&addr->v6.sin6_addr);

+       if (sp && sp->inet.sk.sk_family !=3D PF_INET6)
+               return 0;
+

> >       /* Populate the association from the cookie.  */
> >       memcpy(&retval->c, bear_cookie, sizeof(*bear_cookie));
> >
> > diff --git a/net/sctp/transport.c b/net/sctp/transport.c
> > index 6ea55b9fbde45..cd1a604d6f8e3 100644
> > --- a/net/sctp/transport.c
> > +++ b/net/sctp/transport.c
> > @@ -92,6 +92,9 @@ struct sctp_transport *sctp_transport_new(struct net =
*net,
> >  {
> >       struct sctp_transport *transport;
> >
> > +     if (!sctp_get_af_specific(addr->sa.sa_family))
> > +             return NULL;
> > +
>
> [Severity: High]
> This isn't a bug introduced by this patch, but the same
> sctp_get_af_specific() result is used unchecked a little further along th=
e
> same COOKIE-ECHO path, in sctp_process_init():
>
> net/sctp/sm_make_chunk.c:sctp_process_init() {
>         sctp_walk_params(param, peer_init) {
>                 if (!src_match &&
>                     (param.p->type =3D=3D SCTP_PARAM_IPV4_ADDRESS ||
>                      param.p->type =3D=3D SCTP_PARAM_IPV6_ADDRESS)) {
>                         af =3D sctp_get_af_specific(param_type2af(param.p=
->type));
>                         if (!af->from_addr_param(&addr, param.addr,
>                                                  chunk->sctp_hdr->source,=
 0))
>                                 continue;
>         ...
> }

This looks like a legit one. Please add !af to this check in
sctp_process_init().

Also, in sctp_process_param(), af->addr_valid() is needed, since we only
want unicast addresses to be added. As addr_valid() now checks sk_family
and ipv6_only_sock, we can simplify it to:

        switch (param.p->type) {
        case SCTP_PARAM_IPV6_ADDRESS:
        case SCTP_PARAM_IPV4_ADDRESS:
                af =3D sctp_get_af_specific(param_type2af(param.p->type));
                if (!af->from_addr_param(&addr, param.addr,
htons(asoc->peer.port), 0))
                        break;
                if (!af->addr_valid(&addr, sctp_sk(ep->base.sk), NULL))
                        break;

Thanks.

>
> The five other sctp_get_af_specific() callers in sm_make_chunk.c,
> bind_addr.c and input.c all test the result for NULL first.
>
> On a CONFIG_IPV6=3Dn build sctp_get_af_specific(AF_INET6) is permanently =
NULL,
> and sctp_verify_param() accepts SCTP_PARAM_IPV6_ADDRESS with a bare break=
, so
> an attacker supplied IPv6 address parameter reaches af->from_addr_param w=
ith
> af =3D=3D NULL.
>
> That block only runs when src_match is 0, and sctp_sf_do_5_1D_ce() is the=
 one
> sctp_process_init() caller that does not pass sctp_source(chunk) as peer_=
addr:
>
> net/sctp/sm_statefuns.c:sctp_sf_do_5_1D_ce() {
>         if (!sctp_process_init(new_asoc, chunk,
>                                &chunk->subh.cookie_hdr->c.peer_addr,
>                                peer_init, GFP_ATOMIC))
>         ...
> }
>
> So src_match stays 0 whenever the COOKIE-ECHO source address differs from=
 the
> cookie peer_addr, which is attacker chosen with cookie authentication
> disabled, and also reachable with cookie authentication enabled by replay=
ing a
> legitimately obtained cookie from another source address while keeping th=
e
> same source port.
>
> Since this is the same failure mode the patch hardens in sctp_transport_n=
ew(),
> would it be worth adding the missing !af check in sctp_process_init() in =
the
> same series?
>
> >       transport =3D kzalloc_obj(*transport, gfp);
> >       if (!transport)
> >               return NULL;
>
> --
> Sashiko AI review =C2=B7 https://netdev-ai.bots.linux.dev/sashiko/#/patch=
set/20260913113522.2674588-1-hdthky0%40gmail.com
