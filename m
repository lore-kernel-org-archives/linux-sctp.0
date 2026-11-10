Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.172
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794276590;
	b=O01MZRMpRq2ptnSGAr6Z4T5LMDl8XJN09zsbQ8u5cRwEExdldz6nkAHqKhmrpOm1RvTr
	 DRc21Ll0xOdkXgkoE9P/agYTL7ueyWCyhWupHfvc0QNwrqvVBeFP9pZap4GMTvpAsHzzP
	 sc/suiKA89JfmwSRVDp+oE/joz7Z1Kag30K2kU1JLdFLJ6yHKkyoWetAQu56lA+MS/kbP
	 kPPciulD2P4NQ7TQCuMLmaJANYhTW1wMrs7UeLysYrq56G/cRsoDxsuFN3IM6aTRiCsQj
	 Y8ngiHlhfQ/7Ua8OBF0bKPUYLmVy02u+8thzKnnfufDE5+wJo1xmXIOZ0wyVjHqnIgA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794276590;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=UzMGximFj4DUBgBHxhMcMwIgVslNRL9hrAzzKDz9yOQ=;
	b=CiOTmyAsRTFbi02SYBjxUCg7i9tnqWjGywA6HgPaX/Xk1MsyB9iB2azFJCQdFZmrDHHW
	 C67DO4wPu6caypjXFT/7tOBnhMHF8zgFSsbsSdmFXZ9J8FileHXQRu3PrvYbtXeL8qIom
	 eVQsXCkRaYsDaNoiKzj6Uz1XwTCoL2g8pezRcTscHubtUxjngwtAv7r8+TSB+gIol1Dlh
	 2r5jR+wFgF7JigToyI+c60962cAId5JDld0G2aFQmGkVA7hPg5rXB9H6YSQMfL+lOZrob
	 38kXO5yk8knqkDcwb5T+2lVohXwSnZLvgWBeoi3wUH54SzSCixCF4ii1WX80yzgDDoA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VhTWIjwJ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.172
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89B8D606A321
	for <linux-sctp@vger.kernel.org>; Tue, 10 Nov 2026 02:09:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 89B8D606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VhTWIjwJ
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-8a0673d9bd2so890482b3a.3
        for <linux-sctp@vger.kernel.org>; Mon, 09 Nov 2026 18:09:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794276590; cv=none;
        d=google.com; s=arc-20260327;
        b=pKL6hpOoxkDWRsBrRavdRk6qWUIdJcQlwakIWnZOX/f5tea1G2G3vSwgoyO92U8uSu
         Gs7XCY1Odreuix5wmtBtJHjKm1s7yWxBmoWhBspqUYF/uMv5LNDf6HvPi96bkMnOIblC
         kfs28CvHMKzBjuY4e34tkrzaHaUcRWwfa7WtbSWE9ZQ8dh1Iq+qqh+MnKY4EEmQG7ZBW
         0Pq9cuzsgVrpbzuSUh2peSllrC36oxEz2gZKxVxbAHimNe27DExdqRk7yc6LANSfwc+k
         44sabbHpG8Mt0Xo7eNI4sqMbeKWimF98dCN7LiD6ZODL80aCdieMbOm7Om/NwiFhcf6m
         gFAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=UzMGximFj4DUBgBHxhMcMwIgVslNRL9hrAzzKDz9yOQ=;
        fh=FdmftBgDcSeKNho9j+6V35wv1uz90PyXTAD/E9o8XUY=;
        b=lC1axFvu3KnEc0kBMe/XuSlOgisfluC0FIzPxsuFsyD7RBYIp3ip4MjhoP6w082Ypv
         buXIp7wgfTQk4YJpppLD5d1kfZjxtvDiZzw6sAqoQXkbv/qTzvOJrgTSEAFlKgkkGYVA
         jh52ZYF4pNNQZ7cKS5l00zfqPPbaO0Naki23+DRP2SWdWGKyfrffQswOZ+P7SLNrrV9X
         KQTmpzGe+AcqwvMbPx4vI7D6EGrkpAMmD3eqEwtONyEKD98DEeChi0HO31Hf0H0h4hhk
         DLZqGrPFtkEs/0EaDdEuTfnbWk9aF/yS7Cqa+PBFENFTLtKzzeSpjhBCTayDqMEWIWco
         VP7g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794276590; x=1794881390; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=UzMGximFj4DUBgBHxhMcMwIgVslNRL9hrAzzKDz9yOQ=;
        b=VhTWIjwJl1gVoUACZ6PlcP8DxAcXYhFGB0m6Z+8BOCsovVY/s5/Nolmu7n88G/axiZ
         SUEqZ9FVROd3tNVcVtk/5KGeIiQRWJxzMcfATqxXFuAFptTJ1aVzdEFfIrjlBXVrundS
         PX649y32l65CYBtR+yg+rJZ2yU/KY4dxX+DtoxNbrHoGNgFsqY5XDe+0daHiyBbIvNVn
         yTFSK1BaOjZRp8Qi/bVWxIkkqpkg7K8zWW/cG2YQRDd9oDtapjNaUFvZAVjymBJSXTSF
         Bwap2/T/T003yJrq+laLBfRW2LGbq5yTJNIS63J3z0dajDbS2BeFsy5NerPMX1764N4q
         PAvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794276590; x=1794881390;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UzMGximFj4DUBgBHxhMcMwIgVslNRL9hrAzzKDz9yOQ=;
        b=EVdzvJ/8bxDMhVyYTWEjwmADHkjSWOJnztcbvyDQ6kcwLvwkkV7z/IkC11EB7oZTa+
         t9Hp+382rRUR2lvXNGnjoy2EcQje/XU4mQjCv/zCT61L7qDaJqn9Umab3aTpqlGyZRG1
         56a2sX+2nHfA+7825h4gDct64Bu1F6wxYnag17TxzgkIOu06oP40EdNaATTQlLzlzovr
         Iis0GtXC0j5tM6jU2XYiEf5rAtEyV4uufcpZ8LMm5OUP2gGEJC9BpeJXXyocqXog6xLk
         U+xvrgdSGszK0CDK897z3W0OwDb6gGIRGsDBAfjS4E7McrIK7XOcy4SeCrZq5Rbit0qP
         1W+w==
X-Forwarded-Encrypted: i=1; AL+hErG+t8JhgOetMeTB8CPFeLjwgC6iwVfeI9WKSm0W0PV9mcRshFlAZ+jyHwjHpupXsJmV4b7flZ7vGFdk@vger.kernel.org
X-Gm-Message-State: APuU4Z9kE5rD5uOA3zN8/g7nU7DCFxZO7T2Q5Mdl45w4JPJMBJQtmlj/
	3jvunbZgGncKEWwMThHh/IQ6e+uYGqn4VencjXdG6bdmfhUPv6YpUiZugAHbRI201hIk9mWDK8N
	+pR4ezFftIqFyQKbu4DTn/QTY42/btgo=
X-Gm-Gg: AYBFou1y5XDgcuu5IycSz/T2Id+ev6onm8GkEKU/nIWK011tBqfTDUEvSwBciRmlFY6
	rNhlHmSij5MscmFwJ+Zdq4p0INxxMbjsONmADhjdOorJlQAczO6jzuOclyUbBEmYanALL3XLAJk
	a4XpjyXHpwcZLg5Nj0rJXQOPyMzY73ZMzbqZCu9W1BITTOCumO0ZJumXpExeDe+8i21oO1OXzoK
	6u9SHb3NajIykbs5u0jBAkVwPSXCCgmVdaXX5Vs3ubkMi1n2oCsI50nDcPS9o64A5DQkG85Nzqo
	6OnTb1vspdBILCWGgMUfazT+7nYxMNLj9Xw7B6yLYfbpVJ7vzJZOybd7y4ELkmbZFYVBjV1npLn
	8bKzwKniEFEt+mwaXk2ShJqZZ0A+RaxixqoKG7fHsFbtOBCyg3RoPAO5ggI4k/jSXwC7nxMfauL
	kVp0II//YMhhIKpb20cm2jwUSItm7MiztLqA==
X-Received: by 2002:a05:6a00:ac8a:b0:880:ee58:2768 with SMTP id
 d2e1a72fcca58-8ba885c540fmr1453882b3a.56.1794276589822; Mon, 09 Nov 2026
 18:09:49 -0800 (PST)
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Post: <mailto:linux-sctp@vger.kernel.org>
List-Help: <mailto:linux-sctp+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sctp+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261106195126.1563231-1-andrey.misyrov@gmail.com> <179408114179.994134.782467837057730523@kernel.org>
In-Reply-To: <179408114179.994134.782467837057730523@kernel.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 9 Nov 2026 21:09:38 -0500
X-Gm-Features: AclHuK9-_9zDYgYh_PNtipPEbD4w4V5_qSi5RppRmeY4tJ42ye-6FwxEoUTQuyo
Message-ID: <CADvbK_cwMN-KoELV4O3R9dMOsj+4CHpEhV1VqG-gB0KJd7CfFA@mail.gmail.com>
Subject: Re: [PATCH net v3] sctp: fix ASCONF address change on single-homed hosts
To: netdev-bot+sashiko@kernel.org
Cc: andrey.misyrov@gmail.com, marcelo.leitner@gmail.com, junvyyang@tencent.com, 
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, 
	horms@kernel.org, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 7, 2026 at 2:52=E2=80=AFPM <netdev-bot+sashiko@kernel.org> wrot=
e:
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
> - [Medium] In sctp_process_asconf_param()
>   (net/sctp/sm_make_chunk.c:3181-3183), a plain DEL-IP that removes=E2=80=
=A6
> - [Low] The rewritten wildcard DEL-IP branch in
>   sctp_process_asconf_param() (net/sctp/sm_make_chunk.c:3162-3170)=E2=80=
=A6
>
> --
>
> sctp: fix ASCONF address change on single-homed hosts
>
> This patch removes the refusal of a DEL-IP for the ASCONF's own transport
> that commit 9b2854f86f0b added, since that refusal broke the RFC 5061
> single-homed renumber sequence. The wildcard DEL-IP now looks up the
> transport for the packet source, and both DEL-IP paths retarget
> asconf->transport to a surviving transport.
>
> > diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
> > index 90de272842512..15c2d87575a8a 100644
> > --- a/net/sctp/sm_make_chunk.c
> > +++ b/net/sctp/sm_make_chunk.c
> > @@ -3160,9 +3160,12 @@ static __be16 sctp_process_asconf_param(struct s=
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
>
> [Severity: Low]
>
> This changes how a wildcard DEL-IP behaves on the wire. Before, this
> branch always made asconf->transport primary, removed every other peer
> address and returned SCTP_ERROR_NO_ERROR.
>
> Now the request is refused if the packet source is not already a
> transport of the association. That can happen when the ASCONF was found
> through its Address Parameter and no earlier ADD-IP in the same chunk
> added the source. For example:
>
>     [Addr L] [DEL-IP 0.0.0.0] [ADD-IP S]
>
> The delete used to succeed here. Now it returns an error cause and all
> the other peer addresses stay.
>
> Refusing may well be more correct. However, the commit message only says
> the branch now "look[s] up the transport of the packet source rather than
> reusing asconf->transport". Since this is tagged for stable, could the
> changelog mention the new SCTP_ERROR_REQ_REFUSED case?
>
> > +                     sctp_assoc_set_primary(asoc, peer);
> > +                     sctp_assoc_del_nonprimary_peers(asoc, peer);
> > +                     asconf->transport =3D peer;
> >                       return SCTP_ERROR_NO_ERROR;
> >               }
> >
> > @@ -3175,13 +3178,9 @@ static __be16 sctp_process_asconf_param(struct s=
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
> > +                     asconf->transport =3D asoc->peer.primary_path;
>
> [Severity: Medium]
>
> Can primary_path be a transport other than the packet source here?
>
> The D8 check earlier in sctp_process_asconf_param() returns
> SCTP_ERROR_DEL_SRC_IP, so this branch only removes asconf->transport when
> two things are true. The association was found through the Address
> Parameter L, and the packet came from a different address S.
>
> In that case a transport for S exists only if an earlier ADD-IP S in the
> same chunk created it. That is the [Addr L] [ADD-IP S] [DEL-IP L]
> sequence this patch fixes.
>
> With two peer addresses after the ADD, sctp_assoc_rm_peer() makes the
> first remaining entry (T_S) primary, so this works. With three or more
> addresses it does not seem to. For example, with peer addresses
> {A (primary), L}:
>
>     ADD-IP S  -> {A (primary), L, S}
>     DEL-IP L  -> sctp_assoc_rm_peer(asoc, T_L), primary stays T_A
>                  asconf->transport =3D T_A
>
> This happens even though T_S exists.
>
> sctp_inq_pop() reuses the same sctp_chunk for every chunk bundled after
> the ASCONF and does not reset chunk->transport. Those chunks are then
> credited to T_A in three places.
>
> First, sctp_vtag_verify() copies the packet's encap_port into T_A:
>
>     chunk->transport->encap_port =3D SCTP_INPUT_CB(chunk->skb)->encap_por=
t;
>
> Second, sctp_assoc_bh_rcv() updates last_data_from and last_time_heard
> on T_A, so the SACK for bundled DATA goes to A:
>
>     if (sctp_chunk_is_data(chunk))
>         asoc->peer.last_data_from =3D chunk->transport;
>     ...
>     if (chunk->transport)
>         chunk->transport->last_time_heard =3D ktime_get();
>
> Third, a wildcard SET_PRIMARY later in the same ASCONF resolves
> sctp_source(asconf) to T_A->ipaddr. A then becomes primary instead of
> the packet source, and the request is still acked as a success.
>
> Before this patch, bundled chunks in this case were credited to T_L,
> which was not the source either. Still, the new code picks a transport
> other than S even when T_S exists.
>
> The wildcard branch in this same patch already calls
> sctp_assoc_lookup_paddr(asoc, &asconf->source). Would it make sense to
> do that here too, and fall back to asoc->peer.primary_path only when
> there is no transport for the source? That would also match the
> "Remember where we came from" meaning that sctp_rcv() gives
> chunk->transport.
>

This requires a rare combination: an unknown source address, an earlier
ADD-IP creating its transport, a subsequent DEL-IP removing the looked-up
transport, and later processing (bundled DATA or wildcard SET_PRIMARY)
relying on chunk->transport.

The impact is minor: an incorrect liveness timestamp or a misrouted SACK
for one packet. No crash, UAF, or data corruption.

I'll use primary_path as the fallback to keep the code simple, as already
done in this patch.

Thanks.
