Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.176
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794856815;
	b=ASbY4ImvgLxWJkXc41OxQDe1qv4zRnpdkXGE6nbwaVKb3zJI7HzapQFLQC3k831hJEZp
	 28AvMmvWhDjyTrJ9HfjRKlcQ/tlbmBj81qS6Vq0PDR1gkekqoqyKNme5uMy/To/B6mJZK
	 J3+EOu2vJ+6Vr+rEMNYOi6POTXNp6WjYNY8SFBtaQg3YSln3/iOqesQ4qmbCiodj4PB/v
	 OKyRiUiZK5/AaS4Hw2axQvyVpEvaXaL9CNWi2S40zH/fMSBbUCtyoPIsEv+b7/dh8FPoS
	 zWWwspwsbs5iRR5Hv0YGDr6FEVMDmjiqkb+9slpObv5MyJ7RUA/b4iJaMDfeF1U2Kuw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794856815;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=mCe6Bp3SM314rnTJTs464tCuYj4/L9FqVj7duj6GVqA=;
	b=TVnpjX9m4187HsnletDuT817oBEkL0XJDKJFXDuhCxwfY5JuPZqxxL86K38lZw9U9Z4b
	 ymZEdvhNlnE7toWkNM6wr0CXqxbHL6nql1JlAoDQDyUHBg+tRSY/80t3pfxBfh+bbhxv3
	 sCfBH0v4dnfduTlkf48gIsNFGSVxuEl0pICEJIlpK+2slVEbqjrzbdOCetiFq6yFolLpk
	 v1fPNjDf0Baj+CyFCRXSpx1fBHYL/Ka2vJdmwNghjezJ3SgXwy/REVsr7Zk9FWiHVevtP
	 l0oFJZipJdeeIgg3SvaLvy/uYp0CfCh1rjfkjbQ6M04INR+h4gXcLkxKzTDZ8A0R+4Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=xeY7gzSS;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.176
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28FDE606A323
	for <linux-sctp@vger.kernel.org>; Mon, 16 Nov 2026 19:20:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 28FDE606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=xeY7gzSS
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-8b4c8b51b58so3212157b3a.1
        for <linux-sctp@vger.kernel.org>; Mon, 16 Nov 2026 11:20:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794856814; cv=none;
        d=google.com; s=arc-20260327;
        b=RapuTJS67RMJpjLYbl30C/1v9uNcb8KnNuqDuQOjBbQ5VkQ2uRHE2UI743n5dwm8i8
         7tYVbBjUdYqkL+EsqEWSrUkYUxWbNeYf/FvfEpExACCzBYh9uTljcpolI7IPzb++br+B
         2wBCUa09bVzvf3g2wFRYsqn8AF79lqdSR973EdlifePTc7RSW/ufixgiGWU+Mv/ldNDy
         fp5CqbOzGb2pNmKNeA9z0IrpVSLHiH9YxlCt9AvsTMzTRLQH8Tno/sdAqGLYhnUdnc1r
         mntN5IQP7ihLBszkyQdBp+DkDAT9Im0DciBJIAypuRb4W+wlWpSiGbde+8JP+qiPwOYp
         hv0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mCe6Bp3SM314rnTJTs464tCuYj4/L9FqVj7duj6GVqA=;
        fh=KRCUonY6T61igmyCuoFds/JR2n/BSHi45JYKiRXWhXk=;
        b=MnCKB+9toz3sJ9GUFWqYJjz2rGBqP2kbxs+R/6X1pGQ3Y5CzOW19P+OyqImx8CKOji
         dhFu36cLkPkzk29ODQjC7zLzv7QIyLT/H23vJ1QL+TR2e9SCqLAwnK6xFHB+nMXZfx8D
         p0lw+XN2m+Spy4RRc6LHfwqPgDWPotdbI1K0RX75lUBeEPUkxQxbLo5pjfZYEe2Dtpy0
         MXUvYdEFx9h8qLWPNGrHQ5BS1L1yIeeaNgb8J/mcGAEzEXPCJ/x2e2oqU86HkeRe7zn5
         Ugv/UogGiaNgf2bDYwX7kGFWAp14Ne5GMyh/Vh8cFFQb7FqLpCamE9jwTJsAs6Q46kDN
         OnMw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794856814; x=1795461614; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mCe6Bp3SM314rnTJTs464tCuYj4/L9FqVj7duj6GVqA=;
        b=xeY7gzSSCEuVOvYjp/AC0uzzuAsYcrN6pxNfPByiT8ldwrZXRQxmFBpfDD4bhGWg01
         R4MoRCPnqnGB9JYIdLEL75YMl24QQ+etoZWZowzk9hWlZLhGqFAj2Ww/Jm71h6Vv7Rat
         kzmyKrVRwXigpWyOLSEOQKYXEG5Km8Xd8qjHGPcEbO7aO8s3QMlsQDLDWRAoVCOo9kwR
         ixPbjHWMDTY6qyVJpjdQM90un/qV9ouTiSXVT+y2OK85A5vJLivMpXS5piKQEGkBoS6c
         9xYwyQH4ZbhU4IXPg3VU2CjjYeysClKYyVA26NO6WObtbI56PCRk34P4FFyeNcke5+Ch
         yw+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794856814; x=1795461614;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mCe6Bp3SM314rnTJTs464tCuYj4/L9FqVj7duj6GVqA=;
        b=h5JnnjNddfZ7QkpwnA2Wh0UAp9EktwMZGJ4sIB5XFfhRSeKNuq6AXxJv0+Mia1YQZQ
         Gk4VOEFdimu98aryaIegw/pjuFos4HQZi0WU/dDib+vVBbyeK4vLBK1b/uEwaFA+JYNi
         lTyUM820LAieuixPSJqJO84fCH9YjSn0BhquLwl2yWaEsVVY4wTmXi8/zbGrGO92ydRW
         +6DE5cZCfSn9eujgUfTBgTnTkw4rqHKcIkJTYeIUWIZaeUZLcMxz6Ni1OkSjhFChvgiH
         RZXA+R+xBd1jlvVapKftI6PPSZ4cuiC3rWO6ZCYtGUGkmSxmmg4WwrOhYP2Aeh8YeIri
         pMmw==
X-Forwarded-Encrypted: i=1; AL+hErH5/O8qUMnLK5tpvZdHXEYQODMex/lJHRdAopvApWQNAj/FDWJOkN1i8fJ5pUmYwcihdu9R4L9C7ugq@vger.kernel.org
X-Gm-Message-State: APuU4Z+Mk+IjKKLwYUKSD2EoNlnJxmQ71n/GDbfUY8X8GUsZ4hYjBgmy
	2zG8fndtBW3Hv1dsmSsfzY+KdOMMgGzdEKRti8KuRwVJiOa6Ol9T4wPuy4kiPxQBLmEyGvLvXqN
	W6KVeqACtSCGKYoXG29gpsKWSMQBgAfs=
X-Gm-Gg: AYBFou2bxg1MgDf1UkhJ+yvS86r3awf4ovoC9eDL8ARZ6Z/gZuWBbpM0K4yyFp4GlXT
	F/XmfrolSZdjPGQmYr5PVo0dEhvd7Z1dcNBdpJKFxK3VLR0caVeaKWfNyRNRdiWt9l8ANBUIIoc
	vGIo7DaAyIaltZEvL2fssfA8AO7gdEnZahhCM669hyUiJk2U9/clv2PfVgzNH0xksb+MrhCuj0k
	9Vc1ntMcBwPyTsOfQUolmyDcDKXRIYlD4YwFhJk/wOqG1BNWTr4Kaljp7noBXWRTbsJEmRZ92mo
	vK9OPRrievM3zpCbAP9CpreXozFqz/Xbzrq9/ngaP+ptMEsDWkz0n7oL5uCwVed6ls4fbBEsJ7T
	bC+ctFhqAROHiVcDshDJz5two2oez4u/6Sl38uozF5DAVXlvtIaSGEw5BWGcdUd9sgaSVH5fsLU
	GdeqTp6PDk5TC21tHFm6aFa0/VhBvyARc6zar3
X-Received: by 2002:a05:6a00:2d1b:b0:89e:37b0:d1bc with SMTP id
 d2e1a72fcca58-8beb658dfa5mr10967409b3a.28.1794856814201; Mon, 16 Nov 2026
 11:20:14 -0800 (PST)
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Post: <mailto:linux-sctp@vger.kernel.org>
List-Help: <mailto:linux-sctp+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sctp+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261113124625.4010206-5-edumazet@kernel.org> <179484404697.3136.10852363970744263229@kernel.org>
In-Reply-To: <179484404697.3136.10852363970744263229@kernel.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 16 Nov 2026 14:20:03 -0500
X-Gm-Features: AclHuK9lkGr_PDkzaRaW8fMRu4GpO2qf42caRW7hNGQP2NB-uQH93uU0ogZ3mOU
Message-ID: <CADvbK_dKiTF4gSjsRuVKUDVTJn-EVVvunmhOOEGyG7Bt6jjeVw@mail.gmail.com>
Subject: Re: [PATCH net 4/5] sctp: use skb_set_transport_header_careful() in sctp_v6_err()
To: netdev-bot+sashiko@kernel.org
Cc: edumazet@kernel.org, davem@davemloft.net, kuba@kernel.org, 
	pabeni@redhat.com, horms@kernel.org, dsahern@kernel.org, idosch@nvidia.com, 
	willemdebruijn.kernel@gmail.com, marcelo.leitner@gmail.com, 
	aconole@redhat.com, echaudro@redhat.com, i.maximets@ovn.org, 
	daniel@iogearbox.net, justin.iurman@gmail.com, linus.luessing@c0d3.blue, 
	sd@queasysnail.net, sbrivio@redhat.com, imv4bel@gmail.com, 
	netdev@vger.kernel.org, linux-sctp@vger.kernel.org, dev@openvswitch.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 16, 2026 at 10:47=E2=80=AFAM <netdev-bot+sashiko@kernel.org> wr=
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
> - [Medium] The main part of this concern is fixed later in the series.
>
> --
>
> sctp: use skb_set_transport_header_careful() in sctp_v6_err()
>
> sctp_v6_err() now stores the ICMPv6 inner transport offset with
> skb_set_transport_header_careful(). If the offset does not fit in the
> 16-bit skb->transport_header field, the ICMPv6 error is ignored. Before,
> the offset was silently truncated and sctp_err_lookup() read the SCTP
> header from the wrong place.
>
> > diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
> > index 97390569c4bdc..ad5c951efdf06 100644
> > --- a/net/sctp/ipv6.c
> > +++ b/net/sctp/ipv6.c
> > @@ -170,8 +170,11 @@ static int sctp_v6_err(struct sk_buff *skb, struct=
 inet6_skb_parm *opt,
> >       /* Fix up skb to look at the embedded net header. */
> >       saveip   =3D skb->network_header;
> >       savesctp =3D skb->transport_header;
> > +     if (unlikely(!skb_set_transport_header_careful(skb, offset))) {
> > +             __ICMP6_INC_STATS(net, __in6_dev_get(skb->dev), ICMP6_MIB=
_INERRORS);
> > +             return -EINVAL;
> > +     }
> >       skb_reset_network_header(skb);
> > -     skb_set_transport_header(skb, offset);
> >       sk =3D sctp_err_lookup(net, AF_INET6, skb, sctp_hdr(skb), &asoc, =
&transport);
>
> [Severity: Medium]
>
> This covers native SCTP. Can the SCTP-over-UDPv6 handler in the same file
> still hand a wrapped transport header to sctp_err_lookup()?
>
> sctp_udp_v6_err() is installed as encap_err_lookup. It still does an
> unchecked 16-bit add:
>
> net/sctp/ipv6.c:sctp_udp_v6_err() {
>     ...
>         skb->transport_header +=3D sizeof(struct udphdr);
>         sk =3D sctp_err_lookup(net, AF_INET6, skb, sctp_hdr(skb), &asoc, =
&t);
>     ...
> }
>
> A later patch in this series ("udp: use skb_set_transport_header_careful(=
)
> in __udp6_lib_err_encap()") makes __udp6_lib_err_encap() store the UDP
> header offset carefully. That check only makes sure the UDP header offset
> itself fits and is not U16_MAX, so transport_header can still be as high
> as 0xFFFE when sctp_udp_v6_err() runs.
>
> For a UDP header offset between 0xFFF7 and 0xFFFE, adding 8 gives a bad
> value:
>
>   - 0xFFF7 becomes 0xFFFF, the "not set" value. With CONFIG_DEBUG_NET thi=
s
>     trips the DEBUG_NET_WARN_ON_ONCE() in skb_transport_header().
>   - 0xFFF8 to 0xFFFE wrap to 0..6, so sctp_hdr(skb) points at
>     skb->head + 0..6.
>
> In the wrapped case, sctp_err_lookup() reads vtag from the wrong bytes.
> sctp_v6_from_skb(), called through af->from_skb, also reads sh->source an=
d
> sh->dest from there for the association lookup. When vtag =3D=3D 0, the I=
NIT
> chunk is read with skb_header_pointer() at a negative
> skb_transport_offset().
>
> The commit message says "Should the value be truncated, sctp_err_lookup()
> would read the SCTP header at the wrong place". Would it make sense to
> also check, before the +=3D in sctp_udp_v6_err(), that transport_header +
> sizeof(struct udphdr) fits in 16 bits and is not U16_MAX? Another option
> is for __udp6_lib_err_encap() to reserve room for the payload header.
>
> This needs the same large skb->data - skb->head precondition the series
> describes, and there is no reproducer.
>
> >       /* Put back, the original pointers. */
> >       skb->network_header   =3D saveip;
>
> --
> Sashiko AI review =C2=B7 https://netdev-ai.bots.linux.dev/sashiko/#/patch=
set/20261113124625.4010206-1-edumazet%40kernel.org

The new skb->transport_header is used by sctp_hdr(skb) in af->from_skb()
in sctp_err_lookup(). I think it's better to avoid changing
skb->transport_header by passing sctphdr to af->from_skb(), which also
makes code cleaner.

Hi Eric, you can either continue with the idea, or discard this patch and
leave it to me.

Thanks.
