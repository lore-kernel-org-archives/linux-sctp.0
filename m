Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.178
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795722848;
	b=Ec25IQj9f+3o4n1ND0U3fQ8NhCbZ3lm5fEAGMSSPIcXx4EF2ZkzDbzZS270f0ZmVwCnD
	 WTB5v2mCY8nRuqKbbHOSDFYKE4Uq4sAMZ3JCZhhX7fnTDdxzg/oSrgnGTw6C/9lqSjXPJ
	 R7JMvYFV6zWoquXEoor+tLAWGkwT+gp3MTeHVUu4JmyqQO5GEhGNV59sQnliLlvPrLW/1
	 AxNj6lvLvNncMcskx+EWtP5aYhYC8o8Gk/m4M88I+e6g6+W38nH2pgZM6MFID3YtkLtTG
	 T8Yh1DHUUA+isJiSxESDSsOpRoUtsk4MstLWSKIh7Y4BzuYvpeMhd0KCfwUlV6bLBJQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795722848;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=jVs3B0k4bK97/0ULFOVRTQUP/538GGv4vZ02wgLOIWY=;
	b=DGfJ2U2hw+JypzqcOpVMYNkANzaMIMydugda76OACacsVDVP2IPPHNcVMAirfWgUxGSb
	 IOQcG32A6eWznoQU9v8bOqo2wvIdBCV9NAJHLuNN5KcVatpGbOIRoeIdDQH2jXiP7YUBM
	 IGo3Nhdte/EPQK3Q716C0ZcXpWYikdptQqbeuM6Kj2plRVe0v42iU65UcWaUYeCIbbluw
	 nmH6gIPzxrNyZaq5M6b2NYfSqIchW2CLWtaGSRTzvdb8ZdIe5iB++LhOyizPBZkDmqBuZ
	 fVsJDVs0aafSVVeH2zWiMjZ2NLxGPacvDwZXenKbK4Q5F7I7mXx4/k4qYdhyrlOc5bg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=tw0h1ZFp;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.178
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B725606A31E
	for <linux-sctp@vger.kernel.org>; Thu, 26 Nov 2026 19:54:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7B725606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=tw0h1ZFp
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-8a0880a46e7so4418323b3a.1
        for <linux-sctp@vger.kernel.org>; Thu, 26 Nov 2026 11:54:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795722847; cv=none;
        d=google.com; s=arc-20260327;
        b=ZklYQm5Yac4bn4D3k1pZxTiWDOuh4B4obOGEB7mtCBp+17tPUsqD8E2/5cWOlkuIRY
         I+svf5uwFoMnTzgndPQ96tdMlCNjXZ6zjpWv+jzUisVO3WE9g/CATn5NFmuDsEqEWgAJ
         +rMHrxrN8lCSUwvXNizueQYNKefQ1TLzAOuDlNNeF8wNAZQJVrr4StkBZkC1yc1sma2l
         iF0qG/cRsfMUii+WaOvacGIZEyFDxt3h/VLaPp/8GGVGFhw5IHZ6YRp2D4ebBSQu0q8r
         GVtqOLJwVSXyBtUS6MyetHMhkdXHt7afR1PVgxH47bnqJ5D0teYoi9M5rpfspLA04em8
         +bfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=jVs3B0k4bK97/0ULFOVRTQUP/538GGv4vZ02wgLOIWY=;
        fh=WzjkvS2ioWzxabe/uL0Yw5qz/jCN1m2YvzNPPJaCjkY=;
        b=holQJJzzHI/Sf5cpage79kEfAzSCOJ6UwQaK0g0HToTLSW6Wf+3Ni6xE3E2ASWsyiD
         LElD08EoHJftL6ggDunGm3BefvB8J2Tcwboeie1AE+lqRvKG4nTce8yCSdsVUxX18jqF
         6IIDU9jg1uccuUOuZCuF6t1Wqe4rsKuJ+DN+YJAeNSwJk5LPNqcb6s3mFkklR43zGQ2u
         sFod6nwkVSvd+J3V3IZfVWMivNaiJY0/AP6e0fPpVtqNxs+wuqyWZgouK01OX7IIpEYj
         28WaFqVOWIcN9XbtFKYaxR4pCSq4FCnCFP/a8c833l+fOau2TZX8bCYkHw70awthRHGe
         lUrw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795722847; x=1796327647; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jVs3B0k4bK97/0ULFOVRTQUP/538GGv4vZ02wgLOIWY=;
        b=tw0h1ZFp/sxhTnB4YNkotZ1aRJyf6WNJfpfQh0ZhmVgwD0kknwp/H3vUur7AMIu0fr
         VQ/fHeexWHkH3+qgMHy/KIQQxkPytm2+gRCaRU66+EcewkCkGbSsp6A3ZeGBbjH6X1WS
         B9X7YfGBCCi5vrhWZfBUbNwWBlLTWap+qhq9qOupYlJHRewPeUuZE5NTTIhBsUunKlJ3
         L8SaYirK3KYBrEQAnMDEsd5KKFeke9IJ6arTSzWn2zfkpUJAhrt++zALJE50hQoIF8k9
         tOQSmvVT6EMO0h41DLdth38GoaKFJIoqGZtpElEdGCLvgSCUgzw6bx7Ow7rT187r/EP3
         skTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795722847; x=1796327647;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jVs3B0k4bK97/0ULFOVRTQUP/538GGv4vZ02wgLOIWY=;
        b=o46vglU3k4QzRZqtCxOR9Q+hJZnhvRGHc2mDYdPdpGx70liTDyOuzNvsoX8wfsOPOF
         Y4t7UyzqDHKhqijqIqlRn+OETHxBQNDjfcAd9bf3HAPXUtP6tZSduI4ZZYlvqfqRQ5bq
         cPv5j5TV4iyv3q7tClHIV0IkpZxRBJDlfHkbyLAKEwaNhhzf7PJc2Ey38yYJMqqwKsVV
         ACUS4BX84jRuHrACAIz2MGK54OlcL55yxtKBIbaGwzEclB8O2z0QEbNMWYpEErquTCot
         FNd8GAB3szccuAAOSOSMMydlm+zhmXt+bZU3IOjJX7ApjQ8LUzvgAVusYrZ/VkW9PY+C
         dKLw==
X-Forwarded-Encrypted: i=1; AL+hErGbVGSnIRK9obg1s4P5vjufZYE4iqPOgsNWUJcEagk17Yw36gUH8kD+CCUXQUOoIhKe6YU7S4VPm0qk@vger.kernel.org
X-Gm-Message-State: APuU4Z+E9GqR6cYtR77Yq3ClnCnVXF7J6FlnY1pG3NbN5VhSa0Hr4cUk
	pQ6ABWtthtPV0HONPSuVYeqNCjUSeUzSsKa7tnK0R7+GbPN/vHAT9uwVNGzpc6yqFlfvid3tmTy
	Qcko5bb4RuAaBV62Od2qZcqE1tgJ7RSs=
X-Gm-Gg: AZFdTZezhKMLERguz89MYeH1DGCzunWzYYxPpHfSy3p1wRfrv1t31bWMpv9kn7slm8n
	cgmwW/E05pxdLaCSJQUI6PG7sGCFiPWphkl3lOGyncR35N6CcADyaQI5yyHSZ8weZwGwXqNjYpz
	W/x5uGKBXfU1n3Zs00CsZycvp0FthxadHVojuHlFfkv9yYOU1hfFzfn1P3x2YWTqF8hcIlGg1ZF
	aLhBkIS4KYa2OYrTm/37iah3BOQApcBmqzz6OE9KeXwLfwPbpGyMu2HaUCkYAw+7LJAMzLq6WSC
	HdnivrhlYbycRAb9nGZ+xAeGfdbs1+x25/vgI4H5wb5M8+rNEe6JfDH1iw0NzQjyTyaRuTEGdsB
	SYTmuiAgJvcUnUx50Osz1g5n+AO+rGE2b2yJbDZg7g371ZpLomIIwXS9wFonwCc3RB+VENUG0C8
	isCJVUlcbTV0qfrOdvXAJvGbL0WK3zUpGGAvRoa9X1Y+R+XqB7gv+KdTB8
X-Received: by 2002:a05:6a00:1794:b0:8b6:2333:54a3 with SMTP id
 d2e1a72fcca58-8c7de584caamr16353652b3a.39.1795722846696; Thu, 26 Nov 2026
 11:54:06 -0800 (PST)
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Post: <mailto:linux-sctp@vger.kernel.org>
List-Help: <mailto:linux-sctp+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sctp+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <739a5caed11c49ce53078747c43ea8cec5076d50.1795619846.git.lucien.xin@gmail.com>
 <179570984998.3135.13925553650605121170@kernel.org>
In-Reply-To: <179570984998.3135.13925553650605121170@kernel.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 26 Nov 2026 14:53:55 -0500
X-Gm-Features: Aa3M54pXqt-lowFnUzKsoPf3QHxKXj-kEgnCg7jydwqzJwuUgnmq_vMlKaLcjnc
Message-ID: <CADvbK_eUyi5HnGGUofzSthROW40zonrtuuZStXUQQHb-=yHKQQ@mail.gmail.com>
Subject: Re: [PATCH net v2] sctp: unshare GSO skb frag_list members instead of linearizing
To: netdev-bot+sashiko@kernel.org
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, davem@davemloft.net, 
	kuba@kernel.org, edumazet@kernel.org, pabeni@redhat.com, horms@kernel.org, 
	marcelo.leitner@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 26, 2026 at 11:17=E2=80=AFAM <netdev-bot+sashiko@kernel.org> wr=
ote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue(s) to consider.
>
> Critical: 0 =C2=B7 High: 1 =C2=B7 Medium: 0 =C2=B7 Low: 0
>
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwor=
k
> know by including "pw-bot: cr" as a separate line at the end of your repl=
y
> (one such reply per series is enough).
>
> - [High] In net/sctp/input.c, sctp_gso_unshare() does not give SCTP
>   exclusive ownership of the frag_list data buffers, although the commit=
=E2=80=A6
>
> --
>
> sctp: unshare GSO skb frag_list members instead of linearizing
>
> This patch stops linearizing SCTP GSO packets in sctp_rcv(). It adds
> sctp_gso_unshare() instead, which unclones the outer skb and replaces
> each shared frag_list member with a private pskb_copy(). The intent is to
> give SCTP exclusive ownership of both the member headers and their data,
> so that AUTH verification can rewrite the digest in place safely.
>
> > diff --git a/net/sctp/input.c b/net/sctp/input.c
> > index 9494cfa51106c..f993191ee1ea1 100644
> > --- a/net/sctp/input.c
> > +++ b/net/sctp/input.c
> > @@ -82,6 +82,39 @@ static inline int sctp_rcv_checksum(struct net *net,=
 struct sk_buff *skb)
> >       return 0;
> >  }
> >
> > +/* Ensure exclusive ownership of frag_list members for GSO skbs.
> > + * pskb_copy() shares them by reference; unshare with private copies
> > + * so AUTH verification can safely modify the digest in place.
> > + */
> > +static int sctp_gso_unshare(struct sk_buff *skb)
> > +{
> > +     struct sk_buff **pp, *p;
> > +
> > +     if (skb_unclone(skb, GFP_ATOMIC))
> > +             return -ENOMEM;
> > +
> > +     if (!skb_has_frag_list(skb))
> > +             return 0;
> > +
> > +     pp =3D &skb_shinfo(skb)->frag_list;
> > +     skb_walk_frags(skb, p) {
> > +             if (skb_shared(p)) {
>
> [Severity: High]
>
> Does this check catch members whose data buffer is shared while their
> users count is 1?
>
> skb_shared() only tests refcount_read(&p->users) !=3D 1. A frag_list memb=
er
> can have users =3D=3D 1 and still have skb_cloned(p) true (dataref > 1). =
The
> skb_unclone() on the outer skb doesn't help here, because by this point
> the outer head is already private.
>
> Core skb code produces this state. ___pskb_trim() forks shared members
> like this:
>
> net/core/skbuff.c:___pskb_trim() {
>     ...
>                 if (skb_shared(frag)) {
>                         struct sk_buff *nfrag;
>
>                         nfrag =3D skb_clone(frag, GFP_ATOMIC);
>                         ...
>                         consume_skb(frag);
>     ...
> }
Didn't expect cloned skb existing in the frag_list.

I will fix it by doing skb_unclone() for that case in sctp_gso_unshare().

Thanks.

pw-bot: cr

>
> __pskb_pull_tail() forks shared members with skb_clone() in the same way.
> In both cases, the member left behind in the other skb has users =3D=3D 1=
 and
> shares its data with the clone.
>
> One path that appears to reach this is an SCTP GSO skb looped over lo,
> with a non-mmap AF_PACKET socket attached whose BPF filter returns a
> snaplen:
>
> packet_rcv()
>   pskb_trim(skb, snaplen)
>     ___pskb_trim()
>       pskb_expand_head()   /* skb_clone_fraglist(), members users =3D=3D =
2 */
>       skb_clone(frag) + consume_skb(frag)   /* SCTP side users =3D=3D 1 *=
/
>
> The original skb then reaches sctp_rcv()->sctp_gso_unshare(). There,
> skb_unclone() does nothing and skb_shared(p) is false for every forked
> member, so nothing gets copied.
>
> skb_condense() only undoes the sharing when the trimmed data_len fits in
> the head's tailroom. Any snaplen larger than that keeps the sharing.
>
> Later, sctp_inq_pop() passes the member to sctp_sf_authenticate(), which
> does:
>
>         memset(digest, 0, sig_len);
>
>         if (sctp_auth_calculate_hmac(asoc, chunk->skb,
>                                      (struct sctp_auth_chunk *)chunk->chu=
nk_hdr,
>                                      sh_key, GFP_ATOMIC)) {
>
> Wouldn't this zero the digest and then overwrite it inside a buffer that
> the nfrag clones queued on the packet socket still share? The AF_PACKET
> reader would then copy out modified data.
>
> That appears to be the case the commit message says pskb_copy() prevents:
>
>     with skb_clone() the data buffer stays shared, which could let a
>     crafted packet pass AUTH on a second copy or corrupt data visible
>     to AF_PACKET readers.
>
> A similar fork could happen through __pskb_pull_tail() on one of two
> copies that both reach SCTP, for example a TEE duplicate plus a rule that
> pulls past the head. Two SCTP receivers could then write the same digest
> bytes at the same time. That variant is more speculative.
>
> Would checking skb_shared(p) || skb_cloned(p) here, or calling
> skb_unclone(p) when users =3D=3D 1, give the exclusive data ownership tha=
t
> the comment above sctp_gso_unshare() describes?
>
> > +                     struct sk_buff *copy;
> > +
> > +                     copy =3D pskb_copy(p, GFP_ATOMIC);
>
> [ ... ]
>
> --
> Sashiko AI review =C2=B7 https://netdev-ai.bots.linux.dev/sashiko/#/patch=
set/739a5caed11c49ce53078747c43ea8cec5076d50.1795619846.git.lucien.xin%40gm=
ail.com
