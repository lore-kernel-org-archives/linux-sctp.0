Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=209.85.210.182
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1793054324;
	b=42ln5T7ETSOnaCR0B0GvLsJaoWneeZiHVjV+thNw6UrO+8sVrkVR847YXyEAdnxi55qs
	 V1hc5w4YbpHLVIf9GaChDqX+G/J469WABr9FV6NqP6n9y3qYsWB1IMTKEUlWh5qCf+tae
	 dQ2hmhZy9QGBpbYpkVGQg3aj1IY798TRbf3WlQimhp6Sl4jRtS4oA2G3FnHTSXoxT/eJ1
	 XH5dC/xvyEkG0lRf/bIUNXfRJONjM17t4256WalJ9hMDvAQASAm6dFaEyhDDR3jYFCPYo
	 OKNkujYlkIv/6SLXF7Qfa/CT75ZnAlwZWuX9sxPhUWYZGhW3Qq1Yb8OqtBpjCPgQYjg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793054324;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=cHXZbNTUg/Ax1p5zA4xqb/Pkz7l6MQaU/rT8lSK2nOM=;
	b=As1FBCMQdCIVKEkS0QcgpkWKq3ZXpaOoLz4rKMBdx20/zAxOv/dHwyojwpRKr36i20/l
	 Zzecf8xLr4o0/EqqQATRQNTa6I1c9gVUUgxNto50A/gSpWncH6wttvMCJtOi6iEYpBDXC
	 oOMi1lNMarlFNRNLsQ0tOM4HFxBYfDm+fGWwuvTk18JDUWrf5qIRxiQbtkZETQWrt4CEy
	 njLlEL24gjFGZl9zsxZI1vUeODEGayG7TPKADDNQqDbQotwSEeo0zEviMr3VdhSTLy6nE
	 RRmAunrC1RceqB/IVKrl+//MziivQLHLtvu1xU8Cg37Z8xt1gA9roCxbbh8Iy+EI7DA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=AhkYbOgr;
	arc=fail smtp.remote-ip=209.85.210.182
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 810F6606A31A
	for <linux-sctp@vger.kernel.org>; Mon, 26 Oct 2026 22:38:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 810F6606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=AhkYbOgr
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-8a05effaf8dso2345029b3a.2
        for <linux-sctp@vger.kernel.org>; Mon, 26 Oct 2026 15:38:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793054324; cv=none;
        d=google.com; s=arc-20260327;
        b=QyMI2EL0KgKCzXP2/eguMJZlPQqzul2Tatxyy/eSlL612AQePJlWVqo2C5o8CW5BDV
         8CK8fiMVkAL3rg2OfxIFs3k40WJDfbEdfcLDHR5s5H5rtsYxbWBYSnKl9kGI6fCr1KWA
         44T3COod1UNN4kX69aL37hl41B2zMeCZPXk9YEZccPHsb3NGrRwnFtZsSQAzVuNpfqnD
         c37S3THmCV35m45mGiNxa+2UszgfDDmVmlvWcicDpkZjJQyHMQZ3Abg1feqJSsLnIfY/
         zyudgGrl0LuC7lwYnXY70zYmZFLrEkOCsAx23zfxQnQYaHQUDH797Yf0YIzWCPShVAGk
         +BUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=cHXZbNTUg/Ax1p5zA4xqb/Pkz7l6MQaU/rT8lSK2nOM=;
        fh=ZSNaQ2IDy8Lv9dCxJTwMQecfOoQfv+2wl79NrqKnn7s=;
        b=PKBuIXPllERix6y4e/uhv2oZRmIHmZYGFXCuN58LtVxbTjgouR+q4nQ+5ADbp46f2b
         Zu7/ckzRpBzZN2SIHcy1rpxQVD2YcoJCD2KNYr/qQO/0k45ygmAsMTSDG7YOrh5VsNuu
         LE6hWxzryzo60Nk/a/bfduItBDOxMNehKQVjSoKcku+QqbiXqRp6k80+c3sa8pAHKe8E
         /c3NfZgX6tYHnXVh1EUoIdMfl8A/YuzgHYE1t5HZdH+r7kn0SfgPYnGveBIhWmOKNh9I
         0TteooYka3l72Uo3zF0pDgMbPBs7dIDGdoURFAZfF467thmBqH3ES0souzWXJwOjo4F8
         TS+Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793054324; x=1793659124; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=cHXZbNTUg/Ax1p5zA4xqb/Pkz7l6MQaU/rT8lSK2nOM=;
        b=AhkYbOgrlKuxl0cBRMaCcQFeQKH33/Zs4GV4wWsW1yxxo70qOYtYHPDypHnGOR1fDX
         BtzQd/zto+rNjL+a2+Wk224dfucP3x13AXdZmPGVt91cBlzxdjEUCqbwEbiTaSVR5BeO
         LmWy5gztB96pjlwKNPnojgLN7jldXRlZKFOhwRE6YrgphyQI5ncevlOxzOoMhh3ibibO
         UW5oia+Hdk1v3Dyn9yCAhszv0H2GhMkaSJ0yZ9vSekBPLQMPxcyhTwwv+AASdXSueHvE
         vsWXX/IKHKsItO3CnPAdjKcNM/XGb4hcFwbrlEkq5OGsYUjECtRhkJvJrQXY/k+uF8na
         fI5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793054324; x=1793659124;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cHXZbNTUg/Ax1p5zA4xqb/Pkz7l6MQaU/rT8lSK2nOM=;
        b=E8ky7ZFSCFkStRFo2nxqM/XirHKFaVwnoTcXkrBSiBH1YB2rFnYvSaJdmHiFIp+X1h
         ZtSgE8E4kE1WBKFqUA7ogfD6zja/WmA7MNTOaCuaoYM1Gb8W03ktRU33V326wZvES9OG
         4nKvqrSNUUceoUAP1DQ59daYL9Hec0/4G5juX0UMxyYkUr0scuZUBSiRedRym6PWdZMd
         W+9W/R6wyncIjBfrzXu7Va+Gq14ymBGwKrryeZMsIakrmgafvn4kI0I9ixGXhc6+7VUc
         28vpJl6AWIbyfIY8sGuWaBI+89QHYn71mUiGnBpd8+/WUr+Bs8cvgQGQ5t8WadhwBanl
         5OjA==
X-Forwarded-Encrypted: i=1; AKwUvBzc/LEWQxA0bsAy9Dp5kAN3/9/tQh3oXvZ0y4TOijvpcosONB/aWdSpddimOArTi2JDxxyQ4X6MqA69@vger.kernel.org
X-Gm-Message-State: AFq9FYLDZYkkfJ2SPMO8urMi7QQ9Gg+FPWi+KGbzHBkMkRHii6znQh8+
	hNn5YifQTfItAziQunq7jGT4s3A6G6pMo78FPwxTbTnES7aDD1CjE172atwbsDyVmmaAlYp+PEH
	Tfdn4KkRN4QP//JE1R1u3EptyEwMgLR0=
X-Gm-Gg: AYBFou3GHldzk4PwnjCdiOEKBHrXGMKMniMNdSE74kg4mEctGwh5ndu73n+hVMogmQe
	+MElvvFk0bnWC3CapR0FiX9HWai9V1MTOPOeKuUfrg1ukNLAapHL4EK54dTTRRqrQTaC9Oi3YE5
	lRanYcPWJQEuthWMT7D39nnSS4vKAPvLXfY/Tq4tuLHwhnW9UZSwmlFl1QL+NP57e8CPDoGnUJL
	St3Ol16gyB9HYpt0V+E4uXHF3S3OLkpwulj2DIwXyXgrD15VSOYonh9SitAot1D11UnUV1Xk3XB
	N5lfqkLmPL/PyxkdKToKltROwdzKMdY+VNEOPf7K5RXOCxtV7NRqW8xh32sgzEIDTG9JkwusnyZ
	OE3J/8VPvFDUquOlwZNEcJotVFpWuUX0dQPxYZHjTZteKZ4F/oJcWWDWMwjoIhOTMKkLXEX+lar
	hQLP0P6okVB3mnV3HUgriGjh2QZVDVyJEYAA==
X-Received: by 2002:a05:6a00:800f:b0:881:a5b6:7954 with SMTP id
 d2e1a72fcca58-8a367a3e9c5mr6111889b3a.39.1793054323880; Mon, 26 Oct 2026
 15:38:43 -0700 (PDT)
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Post: <mailto:linux-sctp@vger.kernel.org>
List-Help: <mailto:linux-sctp+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sctp+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261022163639.2566945-1-andrey.misyrov@gmail.com> <179303675173.3134.11217955296529787762@kernel.org>
In-Reply-To: <179303675173.3134.11217955296529787762@kernel.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 26 Oct 2026 18:38:32 -0400
X-Gm-Features: AclHuK__RAb9glund1hU_JAR20mlu30KhixzS1u2vtH0FD81M4p2c0D4Z7kbBXM
Message-ID: <CADvbK_dTUCUFn+sLY+zuN5_9+YC-axzM9FVr-yBKJ4jxwebkkg@mail.gmail.com>
Subject: Re: [PATCH net] sctp: fix ASCONF address change on single-homed hosts
To: netdev-bot+sashiko@kernel.org
Cc: andrey.misyrov@gmail.com, marcelo.leitner@gmail.com, junvyyang@tencent.com, 
	davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com, 
	horms@kernel.org, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 26, 2026 at 1:45=E2=80=AFPM <netdev-bot+sashiko@kernel.org> wro=
te:
>
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue(s) to consider.
>
> Critical: 1 =C2=B7 High: 0 =C2=B7 Medium: 0 =C2=B7 Low: 0 (1)
>
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwor=
k
> know by including "pw-bot: cr" as a separate line at the end of your repl=
y
> (one such reply per series is enough).
>
> - [Critical] The patch rewrites the wildcard DEL-IP (0.0.0.0) branch of
>   sctp_process_asconf_param() (net/sctp/sm_make_chunk.c:3153-3159) to=E2=
=80=A6
>
> Pre-existing issues:
> - [Low] The wildcard SET_PRIMARY branch of sctp_process_asconf_param()
>   (net/sctp/sm_make_chunk.c:3182) takes the packet source address from=E2=
=80=A6
>
> --
>
> sctp: fix ASCONF address change on single-homed hosts
>
> This patch drops the refusal of a plain DEL-IP of asconf->transport that
> commit 9b2854f86f0b added, so the RFC 5061 5.3.2 single-homed address
> change works again. The wildcard DEL-IP branch now looks up the
> transport of the packet source instead of reusing asconf->transport. The
> plain DEL-IP branch now clears asconf->transport when it removes that
> peer.
>
> > diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
> > index ddc31a5dbad32..2b76e451d5cb0 100644
> > --- a/net/sctp/sm_make_chunk.c
> > +++ b/net/sctp/sm_make_chunk.c
> > @@ -3151,9 +3151,11 @@ static __be16 sctp_process_asconf_param(struct s=
ctp_association *asoc,
> >                * packet MUST be deleted.
> >                */
> >               if (af->is_any(&addr)) {
> > -                     sctp_assoc_set_primary(asoc, asconf->transport);
> > -                     sctp_assoc_del_nonprimary_peers(asoc,
> > -                                                     asconf->transport=
);
> > +                     peer =3D sctp_assoc_lookup_paddr(asoc, &asconf->s=
ource);
> > +                     if (!peer)
> > +                             return SCTP_ERROR_REQ_REFUSED;
> > +                     sctp_assoc_set_primary(asoc, peer);
> > +                     sctp_assoc_del_nonprimary_peers(asoc, peer);
> >                       return SCTP_ERROR_NO_ERROR;
> >               }
>
> [Severity: Critical]
>
> Can this leave asconf->transport pointing at a freed transport?
>
> Suppose __sctp_rcv_asconf_lookup() found the association through the
> ASCONF Address Parameter L. Then asconf->transport is T(L), while
> asconf->source is the packet source S. Take a packet from a new source S
> like this:
>
>   [AUTH][ASCONF: AddrParam L, ADD-IP S (or ADD-IP 0.0.0.0), DEL-IP 0.0.0.=
0][DATA]
>
> ADD-IP S creates T(S). The wildcard DEL-IP then keeps T(S) and removes
> everything else, including T(L):
>
> sctp_assoc_del_nonprimary_peers(asoc, T(S))
>   sctp_assoc_rm_peer(asoc, T(L))
>     sctp_transport_free(T(L))
>
> Nothing in this branch clears or retargets asconf->transport. Only the
> plain DEL-IP branch below does that.
>
> sctp_inq_pop() reuses the same chunk struct for the bundled DATA chunk.
> sctp_assoc_bh_rcv() then runs:
>
>         if (sctp_chunk_is_data(chunk))
>                 asoc->peer.last_data_from =3D chunk->transport;
>
> This stores the removed T(L). The last_data_from fixup in
> sctp_assoc_rm_peer() has already run, so it does not catch this.
> sctp_rcv() then drops its lookup reference, and T(L) is freed after the
> RCU grace period.
>
> When the delayed SACK timer fires:
>
> sctp_gen_sack()
>   trans =3D asoc->peer.last_data_from
>   sctp_make_sack()
>     retval->transport =3D asoc->peer.last_data_from;
>   ...
>   sctp_outq_select_transport()
>     reads new_transport->state
>     list_add_tail(&ctx->transport->send_ready, &ctx->transport_list)
>
> Is that a use-after-free read and write of the transport?
>
> Before this patch, the wildcard branch always kept asconf->transport, and
> 9b2854f86f0b refused a plain DEL-IP of it. So asconf->transport could not
> be freed during ASCONF processing.
>
> Any peer of an association with ASCONF enabled appears able to reach
> this, including a well-behaved peer following the RFC 5061 wildcard
> procedure.
>
> Would it close this to set asconf->transport =3D peer after
> sctp_assoc_del_nonprimary_peers(), or to clear it whenever it is not the
> surviving transport?
>
This looks like a legit issue. Either way above works for me.

Thanks.

> > @@ -3166,13 +3168,9 @@ static __be16 sctp_process_asconf_param(struct s=
ctp_association *asoc,
> >               if (!peer)
> >                       return SCTP_ERROR_DNS_FAILED;
> >
> > -             /* Don't free asconf->transport; a later wildcard DEL-IP
> > -              * parameter reuses it.
> > -              */
> > -             if (peer =3D=3D asconf->transport)
> > -                     return SCTP_ERROR_REQ_REFUSED;
> > -
> >               sctp_assoc_rm_peer(asoc, peer);
> > +             if (asconf->transport =3D=3D peer)
> > +                     asconf->transport =3D NULL;
> >               break;
> >       case SCTP_PARAM_SET_PRIMARY:
> >               /* ADDIP Section 4.2.4
>
> [Severity: Low]
>
> This is a pre-existing issue and was not introduced by this patch. The
> wildcard SET_PRIMARY handling in sctp_process_asconf_param() uses
> sctp_source() instead of &asconf->source:
>
>         if (af->is_any(&addr))
>                 memcpy(&addr, sctp_source(asconf), sizeof(addr));
>
> sctp_source() returns &chunk->transport->ipaddr whenever chunk->transport
> is set. When the association was located via the Address Parameter
> (transport T(L), source S), SET_PRIMARY 0.0.0.0 makes L primary instead
> of the packet source S. That doesn't match the comment. The ADD-IP and
> DEL-IP wildcard branches both use &asconf->source.
>
> With this patch the result also depends on parameter order:
>
> - After a plain DEL-IP L clears asconf->transport, sctp_source() returns
>   S.
> - After a wildcard DEL-IP, it returns the ipaddr of the removed T(L), the
>   dangling pointer described above. The lookup then fails and the
>   parameter gets SCTP_ERROR_DNS_FAILED.
>
> Should this branch use &asconf->source like the other two?
>
> --
> Sashiko AI review =C2=B7 https://netdev-ai.bots.linux.dev/sashiko/#/patch=
set/20261022163639.2566945-1-andrey.misyrov%40gmail.com
