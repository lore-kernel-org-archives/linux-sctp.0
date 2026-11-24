Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.182
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795536728;
	b=2NZvNg0UkCYQsIei01x47ppMYbYA5ujuFg++08xnHM3bSf9SQ9qa8dxqs6Z0kBImZfBg
	 vvcQbAp3WOtXOCCpr2IBZyLKFdZQ1LWgjohUFhbOcUCf1RoSp7LMhPOZsIuv3dEPn4eGi
	 v+eVgZv5CUb9OtVwY1zISzguyI/COLnqby97bYyXUsETqqKAbPUMWVcIDo4Nz0JUOx/Gh
	 5PUYex9TvMhtssjRf78oXrVi1NzWCzJw/rEDfZqAzUR9Hg4LL1FNGmiRkH+NXY4sr3qXR
	 ik9phwyppMKsRwrNvai6EW8mDzgMZJoaUXVhFGk8+IPJEpZstMkboXnLxs6KuQyKgkg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795536728;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=pYLlGY9anwpb2Q0J0H7lZsHuURtjsvjjHUo0v1ukGAk=;
	b=TZBaq1Bs+uA8mShTA5xH2kO8DCi3qSZePSbPBY7JGqvptm4E3NqFUkgXfkTnY6C2t6ne
	 O3fUhukXOlbP4Awb/y98gQe3SbSZw2tZLp8jmKZMnRfchRCgbfyrTaVBrWahLFrKtSahQ
	 VoCKQ0uQBsNlRtVkMqx6VHqydOaErf4w1FZP7YbRS6WW7pTFAYEaz8LErGvN0LVgr2561
	 d9YOmqQxFo4vFaGpxEdsvgWHidCbDz2iwMFkSZd88fMrOf39W0LhHWIcPjzQba0fuQW8J
	 0/lGblQYDxPhEeDvCOnx/0Vv8LtPOGqcRUHaJVlxUZtFg9nO+ApcU+xrYzE3MJbcwQw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=UXXyVN0x;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.182
Received: from mail-vk1-f182.google.com (mail-vk1-f182.google.com [209.85.221.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83AD3606A323
	for <linux-sctp@vger.kernel.org>; Tue, 24 Nov 2026 16:12:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 83AD3606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=UXXyVN0x
Received: by mail-vk1-f182.google.com with SMTP id 71dfb90a1353d-5ee3a3d281fso3014301e0c.3
        for <linux-sctp@vger.kernel.org>; Tue, 24 Nov 2026 08:12:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795536727; cv=none;
        d=google.com; s=arc-20260327;
        b=XTINqMjbK3hodsoxkQXmqCghQEqcdug6EXqUG4U98Z7cT36Yp1ephWi5BiiuHXiltC
         PuxlinBoCVoZivuxE20QEVJizdTAFz36sJ/+/bSoghlmo3YigLAtO0WIZ3s2kNW1FEEd
         YMtCzkdU3UN5rYQBf6vnfYluT/qv//j8d1whPYtkR9iVoZdRJbzEUC1/0lE0iKWuQ6th
         BkEgiuHxNDzhhhNvL2ek35zIDtk6sIL5Da/p8+GBV96yrDMgSBaigI+/wirh3c1k96qu
         eP/RIinZLpyLrFm8v60LlLnQR0Qv/wVGKY0hHDmN0R0XZ5TpV8c4FxpFqYjGWLY0IZ50
         71Lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pYLlGY9anwpb2Q0J0H7lZsHuURtjsvjjHUo0v1ukGAk=;
        fh=AF7vkwbSkTW0qKG28TOCfpppiFf25xrrUMQoXPfmBT8=;
        b=ntVCSggLG5qPi7rST/CmyXIy7ClDhZW+A+NmCCQzxW+z1SqCIusPo/JUVJLnNDEzr4
         yzwOe3TAaNldJFtx9OvEBczG7ZSTJRLqmSlLtV2+fiMz976fJYuIKUAGcEGrLwElji31
         4wMpr01IPWWnC85M0uWE2rFQp/RZuIV5aBEXaud7E7jD2DE2l7UL8WgcJVskXDOYTRPE
         DHXSQVD7KgL6CW3P86TttGjAstphS6XzVcvBtOwnbimvlV27F1hPrA0FM+EHHTbQjkrD
         E5zJzx+4oJPZ2bWjcp8Ey8kS5D+cuXyndRLro0xmzkyF+lmuUeIhEyH9Iv/mQxsjDGBl
         c4fQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795536727; x=1796141527; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=pYLlGY9anwpb2Q0J0H7lZsHuURtjsvjjHUo0v1ukGAk=;
        b=UXXyVN0xytSlIXEW2iQEhjp/MPhYUgJhJJSzv3XuObQgmlaMQ3rEYTC1sXw4cw5ked
         Ny16b3lqpRpeM3YOEa969DFm1S4vDTJiIyiAXW3/iftuvFpgYDi/Nm2MzxLiAr8mlOXE
         Y14IS44LbELxb7kENKfwLCG9YwfeEcwXdHOExDfBHb5lMrlBw+/P5JONWF1DsJBRICNy
         P43uTA19DZOLi1E39omx6Q61Rfc1NnRaxRcpju66qdxBC1pmb0ZbkDYvq4ka1Z34dK6O
         3nAV24GNFShGvRDATuYFvWcxT/aAFxeSskEWGLfeTb7tHzVAVIppd9ahxZeTPNRxZQDI
         J+sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795536727; x=1796141527;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pYLlGY9anwpb2Q0J0H7lZsHuURtjsvjjHUo0v1ukGAk=;
        b=sVtPfLiqnJEkzsfv9qJxCytdqKhtG8ftTu6Bph3XwsduaGBzfRCQxouiKxDnd+/EKl
         GStDRdmD02mTj7hiJlpm5dEnZo4aKUPUEAX1dnLk0l2Lx4sfikYVsI69HnO1Z4QtdHqr
         SjpXC5t9WJrUU+8FtzA/3tfvPdQOPIYUOp5A/NX8flM4YaZBRp3/SXA0/qWM+PZHC7kZ
         lrDwjafSKFgfX2HkpIpMuLHWmMll+SIJTZwidmg/TuVoZd8BSRZGClQS5ogUrGWYg8qF
         gRzbrrTtw3uQxxsKzH2eilzV+fJ9l7rniM3G8ny9LQ1moEvYAadpXgnf/c3JQpVlcxjn
         pkUg==
X-Forwarded-Encrypted: i=1; AL+hErFFXcC9aEU3rqHTndf+ZiaOHFDwsNzrwFZX037fceJVET7EeElfcrYY4fTaA+yEt1K8eXsULAu5zNCR@vger.kernel.org
X-Gm-Message-State: APuU4Z8OeU5C/c9g1BdRdm18DXfSjec9ze7ldtv5iYT8UT0IIlye6ezi
	R3M4dULSfSy2WA5pzHQmIsJoLididUxNPXTPzygxIFZNhVz8M4D2g0nD20re0o9v8i1z9oNtGQ1
	KAx3N3PXbQsbtA1q2JQxOj2SBGnq713g=
X-Gm-Gg: AZFdTZdbZFWojCm9NlsDTVJ/hD/DYQH9Fre6eOS0YtRQv1h8oZHahLHF8fZARflslE4
	e5zh4mkfABv8/Hg2OPQfPMQwB/6k6UwAibOqTjqeiooWh/mZ+cfwa0CKQSkC4hBqS2vAzHUMKCp
	fPCsDdcgCX6RWRrD1TXShcbmkrvSn/t6D2AnECsf/Hdfd2NRQrdg8Cbfn1BtWsCBKVgohwwyYYu
	NzBSqcR8nz7G7v25hwJsdr0EXSmSqyXTuYuOsfDY9HbbgJOPL0deLGS7lwPzzReFMuD9JB8I5ac
	HMib1LMSEfRLBGr5T5tG9kOH2dVU//Jb0TuEONNeoPnED5OvsgjuxsY9XdzIvIQZSog9t/LEY1N
	TxoXq3LWjBrbWfCJ1xhEKHDfwzxIeIQm3rE4xcRFeHMS9ZoGzFHSBQSHi368eDz8i4RgBNDEtKt
	oyTMaZteXvMiemKjP3qhV1IT66hAW8NQj5SwxZ8vyMsSwavGrxWSGQPB7tmx0=
X-Received: by 2002:a05:6122:d03:b0:5ec:b8f0:774a with SMTP id
 71dfb90a1353d-5ee8adf6c85mr8478872e0c.3.1795536727041; Tue, 24 Nov 2026
 08:12:07 -0800 (PST)
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Post: <mailto:linux-sctp@vger.kernel.org>
List-Help: <mailto:linux-sctp+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sctp+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <409da01d058fee776791de001ffd222069f06090.1795394936.git.lucien.xin@gmail.com>
 <179548140847.3135.8828188577061386396@kernel.org>
In-Reply-To: <179548140847.3135.8828188577061386396@kernel.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 24 Nov 2026 11:11:54 -0500
X-Gm-Features: Aa3M54rqETa2lnqAo-ABIO05wIeeFIjUfvZmi8lF89O6LgYoCp4j7vLsobhJRjY
Message-ID: <CADvbK_eX-86Wh28QBQomBANJ=UpxhzXJe028r99KN5+VA9Urpw@mail.gmail.com>
Subject: Re: [PATCH net-next] sctp: diag: set sin6_scope_id for IPv6
 link-local lookup addresses
To: netdev-bot+sashiko@kernel.org
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, davem@davemloft.net, 
	kuba@kernel.org, edumazet@kernel.org, pabeni@redhat.com, horms@kernel.org, 
	marcelo.leitner@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 23, 2026 at 7:50=E2=80=AFPM <netdev-bot+sashiko@kernel.org> wro=
te:
>
> Thank you for your contribution! Sashiko AI review found 2 potential
> issue(s) to consider.
>
> Critical: 0 =C2=B7 High: 0 =C2=B7 Medium: 1 =C2=B7 Low: 1
>
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwor=
k
> know by including "pw-bot: cr" as a separate line at the end of your repl=
y
> (one such reply per series is enough).
>
> - [Medium] sctp_diag_dump_one() (net/sctp/diag.c:458 and 464) uses the
>   single req->id.idiag_if as the scope id for both laddr and paddr.
> - [Low] The patch fixes a long-standing bug but has no Fixes: tag and no
>   Reported-by: tag.
>
> --
>
> sctp: diag: set sin6_scope_id for IPv6 link-local lookup addresses
>
> This patch sets sin6_scope_id from req->id.idiag_if on the IPv6 laddr
> and paddr lookup addresses built in sctp_diag_dump_one(). The goal is to
> let exact SOCK_DIAG_BY_FAMILY queries match IPv6 link-local associations
> when the caller supplies the correct interface index.
>
> > As gomaja noticed, sctp_diag_dump_one() builds IPv6 lookup addresses on=
 the
> > stack but never sets sin6_scope_id.
>
> [Severity: Low]
> Should this patch have Fixes: and Reported-by: tags?
>
> The laddr and paddr union in sctp_diag_dump_one() has been declared
> without an initializer since commit 8f840e47f190 ("sctp: add the
> sctp_diag.c file"). So on the IPv6 path, sin6_scope_id has been
> uninitialized stack data since that commit.
>
> For link-local peers, the scope of the transport's ipaddr is non-zero.
> Both sctp_v6_from_skb() and sctp_v6_from_addr_param() set it from the
> iif. This means __sctp_v6_cmp_addr() reads the uninitialized value
> through two paths:
>
>   sctp_hash_cmp()->sctp_cmp_addr_exact()
>   sctp_bind_addr_match()->sctp_inet6_cmp_addr()
>
> As a result, whether an exact query matches has depended on leftover
> stack contents, and KMSAN could flag the read.
>
> Would it make sense to add a Fixes: 8f840e47f190 tag, so stable tooling
> picks this up, and a Reported-by: tag for gomaja?
>
> > diff --git a/net/sctp/diag.c b/net/sctp/diag.c
> > index c2a0de2adf6fd..dc199e3e96b1c 100644
> > --- a/net/sctp/diag.c
> > +++ b/net/sctp/diag.c
> > @@ -455,11 +455,13 @@ static int sctp_diag_dump_one(struct netlink_call=
back *cb,
> >               memcpy(&laddr.v6.sin6_addr, req->id.idiag_src,
> >                      sizeof(laddr.v6.sin6_addr));
> >               laddr.v6.sin6_family =3D AF_INET6;
> > +             laddr.v6.sin6_scope_id =3D req->id.idiag_if;
>
> [Severity: Medium]
> Can using idiag_if as the scope for laddr make an exact query fail, even
> when the sockid is copied straight from the kernel's own dump?
>
> On the dump side, inet_diag_msg_sctpasoc_fill() takes idiag_src and
> idiag_if from different places:
>
> net/sctp/diag.c:inet_diag_msg_sctpasoc_fill() {
>     ...
>         laddr =3D list_entry(asoc->base.bind_addr.address_list.next,
>                            struct sctp_sockaddr_entry, list)->a;
>         paddr =3D asoc->peer.primary_path->ipaddr;
>         dst =3D asoc->peer.primary_path->dst;
>     ...
>         r->id.idiag_if =3D dst ? dst->dev->ifindex : 0;
>     ...
> }
>
> So idiag_src comes from the first bind entry, which has its own
> sin6_scope_id. idiag_if comes from the primary path's dst device.
>
> Here is an example. A multi-homed socket calls bindx() with fe80::a%eth0
> and then fe80::b%eth1, and its peer is fe80::p%eth1.
> sctp_inet6_bind_verify() allows these binds without setting
> sk_bound_dev_if.
>
> sctp_add_bind_addr() uses list_add_tail_rcu(), and sctp_bind_addr_copy()
> keeps that order. The dump therefore reports idiag_src=3Dfe80::a,
> idiag_dst=3Dfe80::p and idiag_if=3Deth1.
>
> When that sockid is sent back, laddr.sin6_scope_id is set to eth1. The
> lookup then goes through:
>
> sctp_transport_lookup_process()
>   sctp_addrs_lookup_transport()
>     sctp_bind_addr_match()
>       sctp_inet6_cmp_addr()
>         __sctp_v6_cmp_addr()
>
> __sctp_v6_cmp_addr() rejects the fe80::a entry because both scopes are
> non-zero and differ:
>
>         if ((ipv6_addr_type(&addr1->v6.sin6_addr) & IPV6_ADDR_LINKLOCAL) =
&&
>             addr1->v6.sin6_scope_id && addr2->v6.sin6_scope_id &&
>             addr1->v6.sin6_scope_id !=3D addr2->v6.sin6_scope_id)
>                 return 0;
>
> The other bind entry has a different address, so the query returns
> -ENOENT.
>
> In this case no non-zero idiag_if works for both laddr and paddr. Only
> idiag_if =3D=3D 0 works, and only for sockets not bound to a device.
> Wildcard-bound sockets on hosts with several NICs might hit the same
> problem, depending on the order of local_addr_list.
>
> The transport hash lookup is keyed on paddr, and dif already filters on
> the bound device. Would it be better to set only the scope id on paddr,
> or to leave the laddr scope at 0 so it acts as a wildcard?
>
> >
> >               paddr.v6.sin6_port =3D req->id.idiag_dport;
> >               memcpy(&paddr.v6.sin6_addr, req->id.idiag_dst,
> >                      sizeof(paddr.v6.sin6_addr));
> >               paddr.v6.sin6_family =3D AF_INET6;
> > +             paddr.v6.sin6_scope_id =3D req->id.idiag_if;
> >       }
>
It's better not to set sin6_scope_id for both laddr and paddr, and
leave req->id.idiag_if to match sk->sk_bound_dev_if as it is.

I will just zero-initialize laddr and paddr only and target it as
a fix to net.git instead.

Thanks.

pw-bot: cr
