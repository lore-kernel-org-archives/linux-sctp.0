Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.181
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794275408;
	b=rdPk/LVfdFQWekeAIMEqmx6jFiQFJaoZ9jGEyjWi5ja2cPfCdwlGXjvAd6geCprhDaW1
	 CGOU97rRWFxZDUpqpOOV2He+B4HZG1Ky+XHoYnsjoOjI/qegBVGlQ/7Albio5FEnPUYLo
	 jXNuqpqOkz6R1gqdVoNnt1xGn0jj2lnvvrinqXxKrVp4SoPp7aWFdVEprKdEmtR6SPQ26
	 JqSDqAvyE6l+yUccGDZGvF7dyQm/JSiGLqKnMjbP6TOKNkPVv1pShh+XmTtG3xXLk4C3l
	 yg1YmxFGpj4EvfTUtWSzy24frvc7SWmh7lXO7W3X16sUxY23jSZc0vvKkjnWp5pVMFA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794275408;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=LRwY0s/9Ai93Iy+nzK08jQ5PQZo3RhKZL2NxrzNG8QQ=;
	b=D7qfxYBDtgqpTOQS9IJ91XKjxC7PTACfclyhdMvoc62T13REFsbVFvJhUwGMA252aPnu
	 TviZhOFCzYtxC18gWXiAG4mGxW2TC67THd1c8R3oJyDzhIdPL8dO5khjLxlt0cdtgmIbG
	 Az4rtmyqhk70/selL3c90cwSRFzP1pNn2SC71+TUH1Rk6loNqPVgR74JE65ALIzLqyW0c
	 6RI0KHDfKlELR4LdOEumcBRijNuXcFX7HrH40qqq7HtWdWLzFOSPRM7u98LtAh5bXMkvI
	 CvwNXuIStZIvNtEi93yeRRNudT3ASdG1Tt8O2vSRBSQ9rTPEcuDVBYS+DrtmB1/fqig==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=caa9+GcX;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.181
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00D3A606A321
	for <linux-sctp@vger.kernel.org>; Tue, 10 Nov 2026 01:50:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 00D3A606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=caa9+GcX
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-8a594d313a3so853971b3a.1
        for <linux-sctp@vger.kernel.org>; Mon, 09 Nov 2026 17:50:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794275407; cv=none;
        d=google.com; s=arc-20260327;
        b=hJFEZTgDh7pPSEWQyrgSUuamaoOlTOisPcVlq3gU2kVvTJbhG8Yn4Z6gZ9wI33t1Fj
         LnUp2g6QUBGD6K7KcjuGCgDsngdv1HXAGSbyW7hGiHFHuQTswBddXE8Etm/YYrbKYcgT
         R18BwEB2L+h41fHYOQjRh589xhQELZ/8AGwqIrAEvnsgwwLbu9o3vmwDgOuMs5g5sSAp
         1K7CKTZSu46cITdUigxQmFsH7H4Gcmv1S5IR5/5dBEIkbs4XfGHtIP84M9OBy2Sr95XK
         zmy7mrItYAyX+X0laDDb09pa/Zl41HrV10rJPQU3XadTl75AhRJKAynjT4kZouKbhXhX
         Fucw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=LRwY0s/9Ai93Iy+nzK08jQ5PQZo3RhKZL2NxrzNG8QQ=;
        fh=1S4CciTRQ/DTCjA4iRfra8c6QKJKORuuLMJCn3BbcOI=;
        b=mSrtyawZ7SBrKC+8zqTtd9ms+5YM4u3lZgpOV0jDbp0185Q0jef1RU2oyaTLIvzJei
         dFiqYXTYZo4yUz1sRiWJdF/GMdGsrApb4yoMIeOdP4fXEKxEEydMNwBL2HxiWUBuh53v
         6NXmCJFN110fJwG86X5IxAsRomet6r9mwz3cf1GgQ/Ey330DgdbYRbbqL+A6cVaBKXyn
         sZ7Ms/I3rPNuFSwuZ9NjD7QXaGrPwgukVqVj039WAmj+VujpXiyyDupNQTYahm4JiXYw
         pjY8Zf3KXVsYHKPdKe+GmqEcqQpLjuFubE9XxsMuFNyiS/UTk7eblzbTBaLseZd2mf0b
         Xmdw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794275407; x=1794880207; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=LRwY0s/9Ai93Iy+nzK08jQ5PQZo3RhKZL2NxrzNG8QQ=;
        b=caa9+GcX8FODMW0Uw2uZEM6WeD1C1YW4XINY7hemj2bKSWd1XGSyJ/BaHbQjRlYuCK
         askFg7GpXmVUH5qMIy2ja7LGDIVYxjGsBGHK0EuBEAeqJORxwAni7nnDGFXLwSH0rEGY
         sHJSG7tx/bs85E1yIDunnKbIA1mTv1NiU727IYzUSzxJYs54yxNRoCKnDXRVA2gaZ4wL
         6P7Sax87eoMGlX9kOo1wtiDQUQaThOMWrGmnce541kf/tjRVLrwLHPVyYB0kSaTEYhTf
         WHYwE5nKGHmoH+d++KNHDn4ZCLuteE43AHudmpi8n+RD0OOuSFyMovdb5sFCwgeYdmeK
         qRBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794275407; x=1794880207;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LRwY0s/9Ai93Iy+nzK08jQ5PQZo3RhKZL2NxrzNG8QQ=;
        b=pRGMORkGMWG5cjGQtzqLyqZ/ARGKCQ2iLb7shknkJkWsvlT07y0qO8QAKzq5PYpIIM
         kaM3mSo8nhf5i6kK2AA3XCVmA6aCUWhSndpzXrJjhXF7v12kat7hv5HtF3yzl0Hq2h7D
         UnU9ktDO6pR3dmTOAwu1iQDEI+/ECECQJQl/sSIOc9+Jkwd431gJnl9bDNKUMn6EXSyU
         OB1aJcJ3mhOLp8OgWUW6JUdi1RuZu2sl5+J2lqCiKccBDvD4il5BpAwFf0cjVJtAbXgB
         de5bCXnLTi8//lR2N7huckb5PH2sZ+EJxzdccp4TJXRc5Dc+7eMJ13yc6WzZAzWD8/ep
         nUSg==
X-Forwarded-Encrypted: i=1; AL+hErEJEP2ZzOzmBFUm/FMz5daf4t+c1K01rc/y+FnCXhXZD8WwOXdV5JmBlYE7xcH05CVP0x21RwJE8dxn@vger.kernel.org
X-Gm-Message-State: APuU4Z/ropYLD1yIpP5NiYuSIkKfO7yJUd8kF0hJoj7FpnUkgzV3Dy6U
	xYaU5kSsPXG5NPhUNe5JTBiYxiGe7VuPbJAFswIdozP274tcuFrfqg/nl/1VDxbbT5PlVogQc48
	j3arMV8aXxufkgEI+ms1MPu4LMLOnhqU=
X-Gm-Gg: AYBFou3CNHZCuwextrPif2RlUJYWIBFSaLxhLEYdhvOIMAh9meDSBbJDdBdpliXGfOC
	FcAG/ACQjwn2sR/YvGj9k8Yo0Xp4mjElcsfuJmNPChwuQvRtaExSGAT/HOxnTHOhJ/BIKnYF43m
	SCYgilKHbF+XSpAYj17NahaWC/LxrMrhOA1e1BuBjm9oXbnickRkOitD1gtbiS+1lIVaZ5SC0ro
	kmHZqpATKlA7FIBbL4Oj0YPEwRtDX6Oy9EiVJg6dMq6PcxuJp16zbTxoRVa58PYkc9OMZXigpWQ
	Fn6kWRVkS2JfC/xPUPG6GSxYj/0bW2oe5Y03Vku+49ofe54JWPmcH8NehdJrDWiYTYw2lXN54Rm
	5V8WEr/JjQiwMHzGXTBMbDBlELNIWAYJKXD7KyqRQziE0eWuoG/+MMVeVZI3z+TgPIikxJ21Z4P
	WLeksbfBBzF8OSn+9XMvxPVVEuSQIQtRQVuA==
X-Received: by 2002:a05:6a21:9185:b0:3e2:59b5:a697 with SMTP id
 adf61e73a8af0-3f18e7c26eemr1089485637.20.1794275407216; Mon, 09 Nov 2026
 17:50:07 -0800 (PST)
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Post: <mailto:linux-sctp@vger.kernel.org>
List-Help: <mailto:linux-sctp+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sctp+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <9997493edadfe9faa713c73de9c70e36cee9ffea.1793902911.git.lucien.xin@gmail.com>
 <179417171282.994134.16986580743973805142@kernel.org>
In-Reply-To: <179417171282.994134.16986580743973805142@kernel.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 9 Nov 2026 20:49:55 -0500
X-Gm-Features: AclHuK-HVWM3DCnOnl30angHiobF4jNX2koeSkiW95MveYQHzB1YP2q55mewFCs
Message-ID: <CADvbK_eRrKOT9YGj6dZS3XOUHKW=DhPTEY4=ggjDTgX91JnAnQ@mail.gmail.com>
Subject: Re: [PATCH net] sctp: linearize GSO skb when frag_list skbs are shared
To: netdev-bot+sashiko@kernel.org
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, davem@davemloft.net, 
	kuba@kernel.org, edumazet@google.com, pabeni@redhat.com, horms@kernel.org, 
	marcelo.leitner@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 8, 2026 at 4:01=E2=80=AFPM <netdev-bot+sashiko@kernel.org> wrot=
e:
>
> Thank you for your contribution! Sashiko AI review found 3 potential
> issue(s) to consider.
>
> Critical: 0 =C2=B7 High: 1 =C2=B7 Medium: 1 =C2=B7 Low: 1
>
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwor=
k
> know by including "pw-bot: cr" as a separate line at the end of your repl=
y
> (one such reply per series is enough).
>
> - [High] The fix is incomplete because sctp_rcv() only tests the first
>   frag_list member for sharing.
> - [Medium] sctp: skb_linearize() on GSO skb in sctp_rcv() breaks SCTP-
>   AUTH verification
> - [Low] The comment above the changed condition in sctp_rcv()
>   (net/sctp/input.c:116-119, from 4c2f24549644) gives CRC cost as the=E2=
=80=A6
>
> --
>
> sctp: linearize GSO skb when frag_list skbs are shared
>
> This patch widens the linearization condition in sctp_rcv(). GSO packets
> whose frag_list head skb is shared are now linearized as well. The aim is
> to stop SCTP from working in place on frag_list skbs shared through
> pskb_copy() (for example by the TEE target), which can end in a BUG_ON in
> __pskb_pull_tail().
>
> > diff --git a/net/sctp/input.c b/net/sctp/input.c
> > index 9494cfa51106c..db3c7818724b8 100644
> > --- a/net/sctp/input.c
> > +++ b/net/sctp/input.c
> > @@ -117,8 +117,13 @@ int sctp_rcv(struct sk_buff *skb)
> >        * it's better to just linearize it otherwise crc computing
> >        * takes longer.
> >        */
>
> [Severity: Low]
> This isn't a bug, but the comment above this block still gives CRC cost
> as the only reason to linearize:
>
>     /* If the packet is fragmented and we need to do crc checking,
>      * it's better to just linearize it otherwise crc computing
>      * takes longer.
>      */
>
> The new frag_list clause only matters when is_gso is true. In that case
> sctp_rcv_checksum() is skipped anyway. The clause is there for
> correctness, not for CRC speed.
>
> Could the comment be updated to say that GSO packets with shared frag_lis=
t
> skbs must be linearized?
>
> > -     if (((!is_gso || skb_cloned(skb)) && skb_linearize(skb)) ||
> > -         !pskb_may_pull(skb, sizeof(struct sctphdr)))
> > +     if (!is_gso || skb_cloned(skb) ||
> > +         (skb_has_frag_list(skb) && skb_shared(skb_shinfo(skb)->frag_l=
ist))) {
>
> [Severity: High]
> Is it enough to check only the first frag_list member here?
>
> pskb_copy() goes through __pskb_copy_fclone()->skb_clone_fraglist(),
> which takes a reference on every member of the chain:
>
> net/core/skbuff.c:skb_clone_fraglist() {
>         skb_walk_frags(skb, list)
>                 skb_get(list);
> }
>
> So after nf_dup_ipv4()->pskb_copy() in the TEE target, every frag_list
> member is shared, not only the head.
>
> Something may pull into the frag_list before sctp_rcv() runs. Examples
> are nft_payload_set_eval() or tcf_pedit_act() through
> skb_ensure_writable(), and bpf_skb_pull_data(). In that case
> __pskb_pull_tail() forks a partially eaten shared head:
>
> net/core/skbuff.c:__pskb_pull_tail() {
>     ...
>                                 if (skb_shared(list)) {
>                                         /* Sucks! We need to fork list. :=
-( */
>                                         clone =3D skb_clone(list, GFP_ATO=
MIC);
>                                         ...
>                                         insp =3D list->next;
>                                         list =3D clone;
>                                 }
>     ...
>                 /* Free pulled out fragments. */
>                 while ((list =3D skb_shinfo(skb)->frag_list) !=3D insp) {
>                         skb_shinfo(skb)->frag_list =3D list->next;
>                         consume_skb(list);
>                 }
>                 /* And insert new clone at head. */
>                 if (clone) {
>                         clone->next =3D list;
>                         skb_shinfo(skb)->frag_list =3D clone;
>                 }
>     ...
> }
>
> The pulled copy then has a private clone at the head of its frag_list,
> while the later members still have users =3D=3D 2. Because consume_skb() =
drops
> a reference on the old head, the twin skb's head also goes back to
> users =3D=3D 1. An eat that consumes whole leading members ends in the sa=
me
> state.
>
> Both outer skbs stay uncloned with is_gso true. The new check therefore
> returns false in both of them and skb_linearize() is skipped.
>
> sctp_inq_pop() then walks the chain and calls skb_pull() on each member:
>
> net/sctp/inqueue.c:sctp_inq_pop() {
>     ...
>                         if (chunk->skb->next) {
>                                 chunk->skb =3D chunk->skb->next;
>                                 goto new_skb;
>                         }
>     ...
>                         skb_pull(chunk->skb, chunk->chunk_end - chunk->sk=
b->data);
>     ...
>         skb_pull(chunk->skb, sizeof(*ch));
>     ...
> }
>
> It also writes SCTP_INPUT_CB() into those members. Can the two SCTP
> receive paths, possibly on different CPUs, end up changing data, len and
> cb of the same shared sk_buff structs?
>
> Suppose either copy is linearized later, for example because a tap made
> it skb_cloned(), or because of another pull into the frag_list. Then
> __pskb_pull_tail()->skb_copy_bits() walks members whose len has already
> been reduced. Would that still return -EFAULT and hit
> BUG_ON(skb_copy_bits(...)), the same panic this patch is meant to fix?
>
> The commit message talks about sharing of "the frag_list skbs" in general=
,
> but the check only looks at the head. Should this walk every member with
> skb_walk_frags() and linearize if any of them is skb_shared()?
>
> > +             if (skb_linearize(skb))
> > +                     goto discard_it;
> > +     }
> > +
> > +     if (!pskb_may_pull(skb, sizeof(struct sctphdr)))
> >               goto discard_it;
> >
> >       /* Pull up the IP header. */
>
> [Severity: Medium]
> Does linearizing an SCTP GSO skb here lose the per-segment boundaries
> that the SCTP-AUTH check depends on?
>
> On transmit, sctp_packet_pack() builds each GSO segment in its own nskb
> and appends it to skb_shinfo(head)->frag_list. When the association
> uses AUTH, the HMAC is computed over that single nskb only:
>
> net/sctp/output.c:sctp_packet_pack() {
>     ...
>                 if (auth) {
>                         if (sctp_auth_calculate_hmac(tp->asoc, nskb, auth=
,
>                                                      packet->auth->shkey,=
 gfp)) {
>     ...
> }
>
> After skb_linearize() the frag_list is gone. sctp_inq_pop() then no
> longer sets chunk->head_skb, and it treats all the concatenated
> segments as one SCTP packet. When sctp_sf_authenticate() checks the
> first AUTH chunk, it passes chunk->skb to sctp_auth_calculate_hmac(),
> which hashes up to the tail of the whole linear buffer:
>
> net/sctp/auth.c:sctp_auth_calculate_hmac() {
>     ...
>         data_len =3D skb_tail_pointer(skb) - (unsigned char *)auth;
>     ...
> }
>
> That range now covers every following segment as well, so the digest
> cannot match. sctp_sf_authenticate() returns SCTP_IERROR_BAD_SIG, and
> sctp_sf_pdiscard() discards the remaining chunks, which now means all
> segments of the GSO packet.
>
> The existing skb_cloned() leg already behaves this way. The new clause
> extends it to every GSO packet whose frag_list was shared by
> pskb_copy(). If I read nf_dup_ipv4() right, with the TEE target that
> includes the original skb that keeps going to the local socket, not
> only the duplicate. skb_clone_fraglist() takes a reference on members
> that both skbs point to, so both see a shared frag_list head. On
> loopback or veth with AUTH enabled, a TEE rule would then turn the
> BUG_ON into silent drops of authenticated traffic.
>
> Would it be better to unshare the frag_list members instead, for
> example by replacing each shared member with a private copy, so the
> segments stay separate? Or is there another way to get an exclusive
> copy without merging the segments into one SCTP packet?
>
The issues reported are valid, we should never linearize a SCTP GSO
packet, even prior to this patch.

I will try to fix it by adding a new helper for this in SCTP, like:

static int sctp_gso_unshare(struct sk_buff *skb)
{
        struct sk_buff **pp, *p;

        if (skb_unclone(skb, GFP_ATOMIC))
                return -ENOMEM;

        if (!skb_has_frag_list(skb))
                return 0;

        pp =3D &skb_shinfo(skb)->frag_list;
        skb_walk_frags(skb, p) {
                if (skb_shared(p)) {
                        struct sk_buff *clone;

                        clone =3D skb_clone(p, GFP_ATOMIC);
                        if (!clone)
                                return -ENOMEM;
                        clone->next =3D p->next;
                        consume_skb(p);
                        p =3D clone;
                        *pp =3D p;
                }
                pp =3D &p->next;
        }

        return 0;
}

Thanks.

pw-bot: cr
