Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.182
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795724843;
	b=ZYCgoBBG0NH7TjVg2/3PcXxh9d1aOuDUgD7pVhr8d6NYqBAoQqa1NaoPPdexadjru+uO
	 hByldBP2AGUn8oGwxdrR5Q99tlsCiNDYgh2hV2n2osGATTl8q73Ccb9lVj53BYFgLmazP
	 /wmfvYAl30IOEo3zpg7T5fzbq3O1KUMRtNs/bvQkIuVs7/MEEu65UD7xyD88+Oz8WiOqS
	 360Sd5LQhaVRjP4EUzoz6xagLNt1uO5uVnROHJ5Z0cCQ3x9/CJc+qEt8cjihfetaUy1vO
	 jUenLVuQdZMbrmzC0IFi52FEvrnGtDaF3vSEkdpDKB63AeVDsICgfyJy2Q8T+aMhitg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795724843;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=CdPL09V6vjBqFmHjF95aST+4s9bV78AjAx0jSltOIgA=;
	b=fAZAeA00TqsrzMmyULmY1EF0S35aAX0jAn21FhFfdLeOORnVjKdHMHxVoeQKn/Z6O8ZB
	 AzkSKfwLvj7vYJtINvTfA0BfCzrelAEdWG1iJzZO0Mbdt030gn4dS2Gk17PkvDDgxa18O
	 zs1H6uKbIYAGI8ZS7A+az5QNx4l0gczzI2N7gjS3uUjlFyz3wANXZJVhb3aAA2lRiDg9m
	 rce7yIyAexvsF/CJJ+PqQSG0nGcVMf2qDobkocX1/NgCVkASOJTRDUXZPITTbmcq2rnGX
	 oZX8PSNkEw6UNL79O+1J4lbRGBwnq6VaNQhL4+8NfgsEwwLNqhR5x0Pz8yBfRZdpkzw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="BAcHC/Fv";
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.182
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EB69606A321
	for <linux-sctp@vger.kernel.org>; Thu, 26 Nov 2026 20:27:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9EB69606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=BAcHC/Fv
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-8b9c51097e2so2970820b3a.1
        for <linux-sctp@vger.kernel.org>; Thu, 26 Nov 2026 12:27:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795724842; cv=none;
        d=google.com; s=arc-20260327;
        b=ZE5g7hVkWpAsLYeSMjaVseUA5FlOdz2JfFMmXwixXs7yruBmpwgWflbHpscAqAs8bE
         oTuUEQuhymqmzQdKLS8ZavC5jyfWI80BEJ7o0/pthEb3oYxR9k/biRBXAdpqnZw0jvGp
         2IAsHz1/YD+91X49jrhLhaQVY86STrR5YSOHNvhg22JGF6fRLNcXLTb8XzabLZnECW1J
         ZTqOAlKqL52GxlhaiGEtujvFpj/HfZPF7afWcmip6MDAqPRPB3XyhNLaraY/x7kDZTM/
         7thCjCIB/9AqQmj/F2nG7P1DHH/zEgNnNJT/ytp4ebs0NIAb0Dfok3htpagfqfpiKpAk
         e8ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=CdPL09V6vjBqFmHjF95aST+4s9bV78AjAx0jSltOIgA=;
        fh=8vzMYPHwupc7XaUBl5EYzwW4Zj4eFEPEwB+y3brLs9Y=;
        b=jjraKOFQ+qadzWcLCBUXOfF/LSMpTlsUdtNNtqluaxO7G21JP07B/SU1eCpRTDK2Ne
         wf8iWmkTd6zL1etwKlhRZtUTmUf0riHJxlRdseutWQMiasIpyUfBMk7kqn1A8bCX2hGf
         YdNHF8NgSBigh0z6ST/xxB2I3p20UoAJTY5YNvMMOujRwrXf5gwoEg3a9Z8y2PXMRwcR
         fAZH/OicCLBBAjGqegMKPYxlP8DJ/1rVVj848lyLuvuNuLBdx8SOLTJS2IzgLpeJAceP
         BEwE7g+7koWuEicDVg9pvE3dRIo9bJQKhdjYyfWoBQyvOBfDh6OiMLeNsSglyOEv+WaV
         T24Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795724842; x=1796329642; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=CdPL09V6vjBqFmHjF95aST+4s9bV78AjAx0jSltOIgA=;
        b=BAcHC/Fv91N4U9IimHPu6YSa9DJluh9hbeQxL4i/FBDbAWH0lPf/w7G85ZSvkykggH
         4m+uvhUK9/oVI2vniWITFMAssbexoIugs2XW0WTYIUSYikIurJ0O9JjAoYfyzjyGWQIH
         pur2+M8pL8Q5z5kwBDJ2Dv3m30CQSWZrmvCyUrYh2CIDOKzlDon7vQsl7GmvIqvHxDh8
         nJ0u3bBrE7Ivk2gm9XjIFTBwdRf3iQ5ORZFi0fgiSQJwdrLJPSm0rfRxIlERbDdAvhBR
         peTNErAAXWEjxCPYg0qIStxbElTbpQdnSoJSo214JfmGskX1RVQnIzuw3t9jV+aOcgqv
         GsYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795724842; x=1796329642;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CdPL09V6vjBqFmHjF95aST+4s9bV78AjAx0jSltOIgA=;
        b=jCPp8LWLK8MyWnzWV2Asl/+OjPJsZ+W5RrihMV7HRXdo0KOaeFWGYj33MS2eOu0TbU
         kFMV2MBm+J8v6i5wpZTFHY2K8zwjb7wwCuHk2LFtvQp098f7Z6jMyNk27au+gIBBJ+D2
         SK1SMt5rhukHR93wWfJxqq4+nFZkHQuH+X20hfhG7qN83JvVi1NV0+hxpPsxK+fkv4sI
         TJ1BqO5osrSrPQ3KwjiLO7/5/M0kMi32Eqx6ONroiDUkySevDrkp1cPxkj/hcUiUwvRy
         P3SlbKNlKBYze48MnqtuQVw3al32com3l/eIx/b5W2Ely4okz1ANEG4xhzeuREo8JKl0
         ZWCQ==
X-Forwarded-Encrypted: i=1; AL+hErGJVSLDaQHLp4HbqwqsXGxlEx3z6tdZm7wUBQXtjRiGFBufNvznvjYXLst1jWJDVqIY81EE5o4VzknZ@vger.kernel.org
X-Gm-Message-State: APuU4Z97R/3IGaI9RWUj9N92ltyueyrNAkWJkZjAUWPISofn6Cxrbl5e
	eeSavxiLxUO8GlccwDSAKqqvzxE/obWRRcb7JBvq7IG6OCjAuY78DIrfQP2QN0mFGw+nCOfyfZs
	l225qGZZGX8+YyJzH3XamlY/HIO9BiF8=
X-Gm-Gg: AZFdTZfIxtLmnMsgKz1J9aaP+q8RQVxjHzuOZjkeSajklrx4M02r2qO1KRgMac3g/rk
	IJbBWDvnKNJ6ByGLOHq7EIEoh8z8c9m9olt2Kg+GMf5OqlZLQN3w2RuNCROqyGBnq88rQg4afCz
	DckngQWtWGuxWK5HXNpnNfKfOoWPdmrtlCr49mTZN+1hyX0eW2N/7pLXme34r70UmAc2plWogyw
	/QkBbd+O4dnFhd+2If78iyFrL9av4xWiXVdvA2dP0gaATsq5vfg5Jzcqo/aIODcgeIpNuSPFukp
	v5Q7+8azBKLTKBL3qz8otz1RHEp5ZD+1Z8AZMHH7Lijv4XS/ujcjo09Rd6faUswebrRCFMGby5v
	W+TB3M2l6i4MwpHdj8TUBoLQKRDwQ3e9QUaZWVPJnyMdqsjadr+wjJcbEt+VOzdC6x6OJwQsndW
	x9xjbpYwYNHbm+aCzljqSYx1WMKuQOYqUo51Y=
X-Received: by 2002:a05:6a00:2e9d:b0:880:849d:c07c with SMTP id
 d2e1a72fcca58-8c87c29172cmr19318850b3a.25.1795724841902; Thu, 26 Nov 2026
 12:27:21 -0800 (PST)
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Post: <mailto:linux-sctp@vger.kernel.org>
List-Help: <mailto:linux-sctp+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sctp+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <7cc69548f249ff63527a663c22d9dc918d3c3e84.1795621751.git.lucien.xin@gmail.com>
 <179570816138.3135.14968815049241245107@kernel.org>
In-Reply-To: <179570816138.3135.14968815049241245107@kernel.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 26 Nov 2026 15:27:09 -0500
X-Gm-Features: Aa3M54r5B4wx34siMoGYdu5QqFcDcda8LErzfVJMrQldUnf9MssTYfgWQDCRNDQ
Message-ID: <CADvbK_fMso1BKZrdX54zph5ZbCgsmiecCm7HS88gA_PePPwRSw@mail.gmail.com>
Subject: Re: [PATCH net v2] sctp: diag: fix stack garbage in IPv6 scope_id
 during dump_one lookup
To: netdev-bot+sashiko@kernel.org
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, davem@davemloft.net, 
	kuba@kernel.org, edumazet@kernel.org, pabeni@redhat.com, horms@kernel.org, 
	marcelo.leitner@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 26, 2026 at 10:49=E2=80=AFAM <netdev-bot+sashiko@kernel.org> wr=
ote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue(s) to consider.
>
> Critical: 0 =C2=B7 High: 0 =C2=B7 Medium: 1 =C2=B7 Low: 0
>
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwor=
k
> know by including "pw-bot: cr" as a separate line at the end of your repl=
y
> (one such reply per series is enough).
>
> - [Medium] The commit message justifies the wildcard scope_id with: "The
>   dif check in sctp_addrs_lookup_transport() already filters by=E2=80=A6
>
> --
>
> sctp: diag: fix stack garbage in IPv6 scope_id during dump_one lookup
>
> This commit zero-initializes the laddr and paddr lookup addresses in
> sctp_diag_dump_one(). As a result, sin6_scope_id and sin6_flowinfo no
> longer hold stack garbage. A zero sin6_scope_id then acts as a wildcard i=
n
> __sctp_v6_cmp_addr(), and idiag_if is used only as a dif filter.
>
> > diff --git a/net/sctp/diag.c b/net/sctp/diag.c
> > index c2a0de2adf6fd..564a5b51e6ce3 100644
> > --- a/net/sctp/diag.c
> > +++ b/net/sctp/diag.c
> > @@ -433,7 +433,7 @@ static int sctp_diag_dump_one(struct netlink_callba=
ck *cb,
> >       struct sk_buff *skb =3D cb->skb;
> >       struct net *net =3D sock_net(skb->sk);
> >       const struct nlmsghdr *nlh =3D cb->nlh;
> > -     union sctp_addr laddr, paddr;
> > +     union sctp_addr laddr =3D {}, paddr =3D {};
> >       int dif =3D req->id.idiag_if;
>
> [Severity: Medium]
>
> The commit message says:
>
>   The dif check in sctp_addrs_lookup_transport() already filters by
>   sk_bound_dev_if, so scope_id on the lookup addresses is unnecessary.
>
> Does this hold for SCTP the way it does for TCP and UDP?
>
> For TCP, connect() to a link-local peer binds the socket to the scope
> interface, so a dif filter on sk_bound_dev_if is enough. SCTP does not
> seem to set sk_bound_dev_if from the peer's scope. The scope is kept only
> in the transport address:
>
> net/sctp/ipv6.c:sctp_v6_get_dst() {
>     ...
>         if (ipv6_addr_type(&daddr->v6.sin6_addr) & IPV6_ADDR_LINKLOCAL)
>                 fl6->flowi6_oif =3D daddr->v6.sin6_scope_id;
>         else if (asoc)
>                 fl6->flowi6_oif =3D asoc->base.sk->sk_bound_dev_if;
>     ...
> }
>
> On the dump side, idiag_if also reports something other than
> sk_bound_dev_if:
>
> net/sctp/diag.c:inet_diag_msg_sctpasoc_fill() {
>     ...
>         r->id.idiag_if =3D dst ? dst->dev->ifindex : 0;
>     ...
> }
>
> For a link-local peer, this is in effect the peer's scope interface.
>
> On the lookup side, the call chain
> sctp_transport_lookup_process()->sctp_addrs_lookup_transport() passes dif
> to sctp_sk_bound_dev_eq(). For an unbound socket (bound_dev_if =3D=3D 0),
> inet_bound_dev_eq() returns !sdif || l3mdev_accept. That is true by
> default, so any dif passes.
>
> With sin6_scope_id now always 0, __sctp_v6_cmp_addr() matches link-local
> transports on every interface. sctp_hash_transport() treats two different
> non-zero scope_ids as distinct. So an unbound socket can hold association=
s
> to fe80::X%ethA and fe80::X%ethB on the same port at the same time.
This is very uncommon.

I would rather NOT set sin6_scope_id from req->id.idiag_if to support this =
case.

Even if we want to support it, it should go to a separate patch in the futu=
re.

Thanks.

>
> Suppose a dump_one request echoes back a dumped tuple (addresses, ports
> and the reported idiag_if). Can it pick the wrong association in that
> case? sctp_addrs_lookup_transport() returns the first matching rhlist
> entry:
>
> - With INET_DIAG_NOCOOKIE, that entry could be a different association,
>   possibly on another socket.
> - With a cookie set, the lookup could return -ESTALE even though the
>   requested association exists.
>
> The same ambiguity existed before whenever the stack garbage happened to
> be 0. This patch makes the wildcard the intended behaviour.
>
> Would it make sense to keep the zero-init and, for link-local addresses,
> also set sin6_scope_id from req->id.idiag_if? The commit message could
> then be updated to match.
>
> --
> Sashiko AI review =C2=B7 https://netdev-ai.bots.linux.dev/sashiko/#/patch=
set/7cc69548f249ff63527a663c22d9dc918d3c3e84.1795621751.git.lucien.xin%40gm=
ail.com
