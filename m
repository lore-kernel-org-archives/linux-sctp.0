Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.169
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793049848;
	b=Tfh1FVb3VW2MhBjYkrzPSdzQ7Rzq5SxX1a2Oa/UYWDra+GvqvJar/cmdJEBVpfLVcvsx
	 rBphtGnBBKeoPVv4mL5tHK0u5yqYAaB3oX5bVOw2sbpJUxwklDOk/laBxtmswLNjtTqI7
	 x9vwEY551qAbr/C1cVaJ/SzAq9MQbxO5ozo3eLn+16FVFwCHwC/CAnp4mgi9SdH6TwSY1
	 jibqEjZ8vWPLwJGltiPIU7/nt3JZPdtgjwW99WOgXErD9yoS2cZh77szPf6gvzp659QGN
	 fDUaqvHWTppU4+/2iQVJ+RIISf6QgGm3h2PPnAtAVqsipZe2nPXyq79bXLI80TziJlQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793049848;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=GKPa9M5PoAhtNnZV69xKXcRKiwNy/DZc5TLsis+amX4=;
	b=LMDlVFZXVVS8TtfAMchJ3ByNqOqEt44RM9avUawPcmG+Z3CBgBwxeFSBoUf/lpa9Vnkb
	 gBDOdvG4ZvwTbM5glOtHYj1p7TYGrcPpcXkwWsaT9F0+8s0zAVEprdnC05dAAQwJ4BtyA
	 B40GgAoOo8GdDBQyVD8wyCShUWBSEs1ce9Gwx2Va20ITy/9ay90k32KwQxIvzOCHXcJ7f
	 5oTUC6U8FMXRDkNjORFAJCDHm8pN92M4S+i8LDmc2nc29b8b1LGGiz5hZjrwDaE1iajEY
	 6mdEGpGUau+aTR9K1XxP+7lVcPTvo0aQPceCqj5gEkJJSdbyfZAQOXaNgUrt+Ltrn2g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=JvW9vDSK;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.169
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB9F5606A327
	for <linux-sctp@vger.kernel.org>; Mon, 26 Oct 2026 21:24:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EB9F5606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=JvW9vDSK
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-8a05e3f0d23so1500621b3a.0
        for <linux-sctp@vger.kernel.org>; Mon, 26 Oct 2026 14:24:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793049847; cv=none;
        d=google.com; s=arc-20260327;
        b=EKiP/KSHQQDfpMaChrl66iaasxg3tmqWxk0kUM3CBU4EuhC43iHK42XqH7uIefmMVu
         uy4QOxEvmNdkXK1SyMmUhgzg741JHqC1GCaM425CPhR0H+faiIMw44vEzRIHyWnizw+L
         sycAo+ODnm3n2e3jq8NfmiEyLSor3zA4VkC4kA06Q9p/0XqWjHAlzxDaMV8HoRB6uzWe
         YOh32d99mXSPQixZ2TdvB53SHU3xF9X0YGVgvoEHpt++Vbx2bHBx934O+b7Pxvp4gqrv
         ZTd3R7sXZqyERC4bWO120UQrRHqSf0VxIzNdpRiCJMfkkzGz1QOohNG/anXGZtVDLnG5
         G/hA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=GKPa9M5PoAhtNnZV69xKXcRKiwNy/DZc5TLsis+amX4=;
        fh=6r7kAtI8kYbFFTVAEnMsY3FLv9zjRcHq8aSq/VUViwQ=;
        b=YmE6AuuPX2GqVki7udYd2H5XpDK4rE65Ah0TVN8UVvpypOIo3PMA9HESV/MW5N1BIX
         W6RvIg0BNrraaEdZqUCk12sEAsu1VfT/5YgkgaDVIvylKlFzVJ9lBTgNy0xrO0oMgxeP
         SiUwma1ZyS6qouhnAjsxpvRSCB66D7TJMoEJKLR+PPfGMbLny74+BkTFLbv9INA4rDm8
         EhNIzlVCzScNOfXDC2NInHnlcSkzkm7bt8S59HRqsJc6p/VQToX4XYpWXTU2BpVcsGVK
         RJVXBoZbnyyGSaxIkCHJdh3O4ZJmo+ZUznoS0kl0IPz5p5izfNmrHGDrvclEZ9Spfi14
         rHwQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793049847; x=1793654647; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=GKPa9M5PoAhtNnZV69xKXcRKiwNy/DZc5TLsis+amX4=;
        b=JvW9vDSKDQCQ/Iv5gH7W5O3cS0g69FgaSrzXh+G3mKOnwtx1dD5k2+/f8z9S5LGEJp
         qhfC119t2DQCRsdUB4RiBMCgW9qeU+bxBSK401Bk+wzfGwWxnoFATTv6HCNP19AxhKn5
         4q8CfdqkdshtIy14X3UgKdFIgmQ8I8OYThvgeWi6M5mHA5jj/IEmz5LzhYukJ5xRd7Iu
         69idP10I+bJCRRgR++AoP9HgxnDUUM1isC1kbmQG8h/snlHwe8L53Xc5dXrxDDUYZ3dW
         ov5as3DD2BB9Qd+hgBkonsm2UFAu+VwMBLKG3UrP+36q9N8IuBaXClaE+/WlNYJ877aL
         GaaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793049847; x=1793654647;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GKPa9M5PoAhtNnZV69xKXcRKiwNy/DZc5TLsis+amX4=;
        b=oT0JXz08vLewmFIsBlXvK7UEUPcPp83ym4ITXQeKcF3E0RfVLR40JwQpwhNZaCbw11
         B1wndAidNIHKRpnPZ7W6Xujlxucsxko51GyJFOgUu4DVioat6Jc/GhPpBdje/Osxz2JL
         vcQc7futoT9CU8A1BcWWtSWWAEKlxqX5IHNciDnoP6NvApy7BIbTBtAmNWdn8hhbZvro
         DNFOvCY4Bq7lgr3BPiT1cdKsl07wgn9GEnGgNxhs/JiztK3tpIm2QkOw0NQyk2Hvso58
         j20jJzJjwY9A0x5DzxftYy1gDSV4MFNIU1Y/+PF84fefQ9lH/16FT/pZSLjNh6ESxu3Z
         C1/A==
X-Forwarded-Encrypted: i=1; AKwUvBzc8R47rn7E9w5/yki4/KCHZKg/QjqEmbu/+zO62f7FERD0zqztVLGxhXMX8rfmWnLPzPETOb5/44bY@vger.kernel.org
X-Gm-Message-State: AFq9FYJeTLuqyM952lwrbX9tFk4GkFKV+xlV4+BZg7cvZzfbYsHDF0av
	J757akv03TYZnewF/fzZTBSUrFvus8hP0FDQvp5f04liPU4OJG6g+ZcFXzhGStdvCjYmUKHIbBP
	NpytaUG5fp0Km7PLzvPO02m0qWAIRaz4=
X-Gm-Gg: AYBFou0tecU/WFJeOjG+YlPdXZ5oXvdLicvhcFV1GvmCArtiHLB6L8e2e4KY6VPL7bK
	EMT621PHcjPZ5thwCirncg4t/nh/WuCnq9/XZk7u8WRnPOAOcIuKee/SwU4oCaIfSwpnP0CzMMG
	qHI+VAyLbvRbnz0UQqyQS7ZOTtLU10hNACd/7DZE5sxkxlg7pLHUGdOjulFtWJv/tfsauUe3ydC
	2vgNgEbYEpWa1WUkCVu5GtGZbomTNgL7yZax7kGPUNeNP1a8mjH8idbVa6mdD0ysuwDs4/i5eVb
	zJ7Np8gt8t5x2ZREFqIqgHFohQhfFgcuVs0fMaOVVzF196CCK04RIEeNxZi/iTSHwIbSUW/KIlK
	utDK9lBQteleM2/J08tYUqAKWdb3szFU6m8nJuR4vmdzkvw6EPX0wjd8nSdC4jTjz65wvdigDSJ
	VR9DPDKNONImBnDftf6G8piYFmbJqiVTBT6w==
X-Received: by 2002:a05:6a00:12d6:b0:89e:3742:3e16 with SMTP id
 d2e1a72fcca58-8a3666af17cmr6585603b3a.18.1793049847178; Mon, 26 Oct 2026
 14:24:07 -0700 (PDT)
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Post: <mailto:linux-sctp@vger.kernel.org>
List-Help: <mailto:linux-sctp+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sctp+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261024120627.837568-2-tim.budding@gmail.com>
 <179293012722.3134.13316596865856977030@kernel.org> <20261026052706.187296-1-tim.budding@gmail.com>
In-Reply-To: <20261026052706.187296-1-tim.budding@gmail.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 26 Oct 2026 17:23:55 -0400
X-Gm-Features: AclHuK_mrIu1EVf0x2dV3mIZYP2JHGyJuazQowznGXy4YPuBCm1N0ChSU-JmIKI
Message-ID: <CADvbK_du=-oT19kKBKYSjFKYscnQSH1mekRKMXgmLPMXTEH_=w@mail.gmail.com>
Subject: Re: [PATCH net 1/4] sctp: purge abandoned I-DATA fragments by stream
 and MID, not by TSN
To: Tim Budding <tim.budding@gmail.com>
Cc: netdev-bot+sashiko@kernel.org, netdev@vger.kernel.org, 
	linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, davem@davemloft.net, 
	edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, 
	shuah@kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 26, 2026 at 1:27=E2=80=AFAM Tim Budding <tim.budding@gmail.com>=
 wrote:
>
> On Sun, 25 Oct 2026 12:08:47 +0000, netdev-bot+sashiko@kernel.org wrote:
> > > +           if (event->stream < sid)
> > > +                   continue;
> >
> > [Severity: Low]
> > Each call to sctp_intl_reasm_flush_mid() starts at the head of the queu=
e.
>
> [...]
>
> Agreed. Walking each queue once per I-FORWARD-TSN would be a separate
> change. I could send that to net-next.
>
> > > -   /* purge the fragmentation queue */
> > > -   sctp_intl_reasm_flushtsn(ulpq, ftsn);
> >
> > [Severity: Medium]
> > With the TSN-based purge removed, what frees an unordered fragment of a=
n
> > abandoned message that arrives after the I-FORWARD-TSN naming that
> > message has been processed?
>
> [...]
>
> > Should the commit message also mention the lost rwnd and receive buffer
> > space? Alternatively, could these fragments be dropped when they arrive=
,
> > or when the cumulative TSN moves past them?
>
> Correct, and the commit message is wrong to say such fragments stay
> until the association is freed. An unordered fragment of an abandoned
> message that first arrives after the last I-FORWARD-TSN naming that
> message, with a TSN above the cumulative TSN, can't be reassembled. It
> keeps its rwnd and receive buffer charge until a later unordered skip
> on that stream with the same or a higher MID, a reset, or teardown. At
> the tail of reasm_uo it also stops reneging, as any fragment below the
> cumulative TSN already can.
>
> One late fragment is enough if nothing after it has arrived: the
> receiver then delays its SACK for the I-FORWARD-TSN, the fragment fills
> the gap within that delay, and the sender never names the message
> again. With the last fragment of an abandoned three-fragment message
> arriving in that window, that fragment stays queued (RX_QUEUE 1232). A
> duplicate can't do it, as the TSN map drops the second copy.
>
> Before this patch a later I-FORWARD-TSN covering its TSN would have
> freed it, so if another message is abandoned later, this patch keeps
> it longer. Without such a later I-FORWARD-TSN, this patch frees more
> than before: in the same test, the TSN-based purge leaves the
> message's received fragments above the New Cumulative TSN queued
> (RX_QUEUE 2464 without the delay), and this patch frees all but the
> late one.
>
> For an ordered message the same late fragment aborts the association
> instead: its MID is below the next expected one, so
> sctp_validate_idata() fails. That happens on net today as well. I
> could look at it separately.
>
> Freeing fragments once the cumulative TSN moves past them doesn't work
> with interleaving: a live unordered message can have fragments below
> the cumulative TSN, and freeing those is the loss this patch fixes.
> Dropping late fragments on arrival needs new per-stream state, the
> highest skipped unordered MID, which must be cleared on resets and must
> not go stale when MIDs wrap. I'd rather do that in a separate patch
> than grow this fix (question at the end). Either way, v2 will spell out
> the cost in the commit message.
>
> > >     /* abort only when it's for all data */
> > >     if (ftsn =3D=3D sctp_tsnmap_get_max_tsn_seen(&ulpq->asoc->peer.ts=
n_map))
> > >             sctp_intl_abort_pd(ulpq, GFP_ATOMIC);
> >
> > [Severity: High]
> > Can this branch still flush the whole ulpq for an ordinary I-FORWARD-TS=
N?
>
> [...]
>
> > A later patch in this series, "sctp: don't treat an I-FORWARD-TSN as an
> > association reset", seems to address this. It drops the max_tsn_seen
> > check from sctp_report_iftsn() and makes the stream reset paths call
> > si->abort_pd() directly. This patch is tagged for stable on its own.
> > Should that change be folded in here, or should the two be backported
> > together?
>
> Yes. At this commit an I-FORWARD-TSN whose New Cumulative TSN is at or
> above the highest TSN received still takes that branch, and
> sctp_intl_abort_pd() frees every queued fragment, including those of a
> message still being received on another stream: the same loss this
> patch fixes below the leading edge. If that message is ordered and in
> partial delivery, its MID is also skipped, and the association is
> aborted when its next fragment arrives. With this patch alone the
> ordered and unordered tests pass and leading_edge fails. The later
> patch fixes it. v2 adds a leading_edge case without partial delivery,
> which shows the loss directly.
>
> I kept the two apart because they are different mistakes in
> sctp_report_iftsn(): the TSN-based purge, and treating ftsn =3D=3D
> max_tsn_seen as a reset. But they share the Fixes: tag and the
> symptom, so folding them is reasonable too. The later patch needs
> patch 2 and the new pdapi_seq patch (see the reply to 3/4), and
> neither of those needs this one, so folding would mean those two
> first, then this patch and the later one as a single patch (question
> at the end). If they stay separate, this commit message will say in v2
> that the leading-edge case is only fixed by "sctp: don't treat an
> I-FORWARD-TSN as an association reset". All three fixes are Cc: stable
> and apply cleanly, in order, to the v5.10 through v6.18 release tags.
>
> > >                     sctp_intl_stream_abort_pd(ulpq, sid, mid, 0x1,
> > >                                               GFP_ATOMIC);
> > >             }
> > > +           sctp_intl_reasm_flush_mid(&ulpq->reasm_uo, sid, mid);
> >
> > [Severity: Medium]
> > This is a pre-existing issue, not one introduced by this patch. Does th=
e
> > new flush leave unordered partial delivery stuck when the skipped MID i=
s
> > the message currently being partially delivered?
>
> Yes, and that is the next patch in this series, "sctp: abort unordered
> partial delivery when its message is skipped". At this commit no abort
> notification is sent and the next unordered message on the stream is
> delivered as the rest of the skipped one. The uo_pd test fails at this
> commit and passes from the next patch on.
>
> Xin, Marcelo, two questions for v2:
>
> 1. Fold "sctp: don't treat an I-FORWARD-TSN as an association reset"
>    into this patch, or keep it separate?
> 2. Should dropping late unordered fragments be part of this series, or
>    a follow-up to net?
>
Please try to fold it into this patch, and leave the drop to a follow-up.

Thanks.

> Unless you prefer otherwise, v2 keeps them separate and leaves the drop
> to a follow-up.
>
> pw-bot: cr
