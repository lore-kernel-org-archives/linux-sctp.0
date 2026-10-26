Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792992458;
	b=jPH+bTlQEww7KUD9p+8qPFUJ2YoiNjubvxUtDtho/tNHRWvB237W8vfNBN57CNjRldYo
	 CowVV3cidcXhJN5Co4jZ7qtZ9iFbp2jpYrxrcFTd53/miBNkqR/qisxUWBwXqcg1JSVIe
	 5Uy8CYJxBiIpwhSqA4LLcWGiJDcMLydNn7lqd8mRq9rFnA1UTScDAgzdJv17rK/AIdrJA
	 kyD/z5UsfgnUqOBA3x4ezUmNgUIzV8ISPuzszeVp3/AjamuD9+kjjHlXAb8ZYTpdxAFeF
	 Zx0PI0+g3GqleLNyNireVKBBqIGcS+nbG7i232+hkEdyxxHerrIxG6GbH/qnB9U1bMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792992458;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RCGPlQz9/nbP749pKlUHj7iqUI3R/GYuLrhh68VMhX4=;
	b=HrY8nfyt98Cq3b8qeoKdlF6IgkrK1bPOH6KfxyqBoQcN3b0eTM4VshlIBrC5kJEj7oVa
	 kx8NA+RJ+mq0s7iqUyiW+B9RvgDDVribCxJuzYJcdx2Lykiz6S42TEf8uOiuz4C28k6Ks
	 599p7RTqZYx/OoR//1TJMlFzXMpt5FPBgiFxq0oNUPqsOA6gza/RYkCwK+aJDApSN/1Fw
	 9dOUmEtoRGbdOl71fE6/QIQzPadF7BKAj5mSxM5nBlbgMG1aAQKqUzWOOTnbqc0lOyZwG
	 AiO0NdDRiNHo4iaTGdoX7SVOT+0sAhkIVVmW/rScckWjfzEZjMP9rHLfO3H9bjae7gw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=azji0Yvb;
	arc=none smtp.remote-ip=74.125.82.46
Received: from mail-dl1-f46.google.com (mail-dl1-f46.google.com [74.125.82.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36197606A31A
	for <linux-sctp@vger.kernel.org>; Mon, 26 Oct 2026 05:27:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 36197606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=azji0Yvb
Received: by mail-dl1-f46.google.com with SMTP id a92af1059eb24-14394530ec6so3200782c88.1
        for <linux-sctp@vger.kernel.org>; Sun, 25 Oct 2026 22:27:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792992457; x=1793597257; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RCGPlQz9/nbP749pKlUHj7iqUI3R/GYuLrhh68VMhX4=;
        b=azji0YvbQpXonPfhYaQOd4vN8DayEMzg6nrWZ+k9qUgnGH+Qty9ZoVl2H1T0DpoB2Y
         S6PuW3zslfumGLO5cOFGQXqvB6FlhXNk1x3xWJzy9jzfdAYMeGnxpgXkO+CHEFl6ILHf
         CSe5/3oPDppMSzPeO+hbvs3/kG6jBs3+IA3yc65Vo3LWxwbW6oT0qRXAY3cp/bJesXIh
         9qjma+u8mCKxWUdvJR4ixY6vkgsuUSn/3KJHzOnsY+TMu7akbq7B+spnmniyndnMOXfs
         Or0qSgsY25u8uz1rqn7FjFgUDPMKRFbovrmNX3RwS6i4cze+wwfJ7njGnbzAQbv4UYjU
         UMSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792992457; x=1793597257;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=RCGPlQz9/nbP749pKlUHj7iqUI3R/GYuLrhh68VMhX4=;
        b=ppp+FPaNYbBrPSDHGZXQsPHEr967plo9C1H+/vpBxAneJRu10/C/c9lmu8kMmFefkl
         ykuVImYWkXK5KmPlbOp0OGa3A0p/RkNlHNKhtg5+Mfxjm4oBJQoS5Hg6Ijb1Pffr56qL
         vpjrywcIeDeMnYAz006Tq6W7faz3i4no13K+0AionpOBBdegcg4sskNxMg/KuIRMDVUC
         fYdKsiut2U2BSN+4/JvJ4L6rDMUmv4Q4i8VUiRuOiA5L8o9EiaTz7JHI4apZfQZq0Kgx
         4ReOstKIL2Q6cIEIfoOfxX/lc6twFDHWsz4qaUQulMwlE23dQ63hF2ocgMlWYX23DlQm
         asMQ==
X-Forwarded-Encrypted: i=1; AKwUvBzpbadMnw38UZ33SuAK44kaWMuWYYxiwa02MA/UWVIw8piJykyGMT9FbQ6qs1yG91K6v8acaKn/9/F1@vger.kernel.org
X-Gm-Message-State: AFq9FYKNcEDQqeJMm+YVUAvtO9+rpoRSm3GTgvuf6w5IRbRZFo6LtUWu
	KDkXsjiZm89SZ3eDuwV1W1Rkg2B1STq0pZUd033QELjJpEqtgbdtLgG6
X-Gm-Gg: AYBFou2ml669BrtAbl/l/rXx6HE9FiUckFbSdlJ+INiVcLFIr/uIz4EgVh3MWcxVYec
	WaeRd2eMa01HWJwz7qU/upXKNURZo2CDs2OEqA+Us4UFp/kgcp3OvoxAtEi6DWKXNq3pwi6N7K/
	lceqw6IuL7NtqTHi/WQuhJbMrfUAvW9ccOeNz0mSgh5c15gn0TS4f5zxvkIJHrF8NBiLlpu0LQx
	PFOUf2zs9c1hM2K5YemZQh/Ks2iO6fzAing0NPIgGCXqk40VbHQpr/LTove1ZeDHEmat9orUeCG
	CCQQ3MkIFFed3ZxxnfGiAC5FqHZrjKSjAErX19vhly+jBRE8HvHlhtUHCJ4/x8L2Of6hmNPBrSI
	r3C+srmr5CP2taJ+jdbF5OK8u7zBJM64zJ/pLU/Hj88SRGqamosgWKyLlrjBuf7sBoVn4jskWWA
	V/8Qpo6z/PeI7D1sqJDNGO7afoPaUdYrY4LeRTcI8RcsjinlgPnTrK4yniSUMQi1orQdI8OVFx9
	xMRCI1zwq/MuM26UkQtvqsa8RiFvre5WeMVBH8GBJNe7M5KYnQUDxaQGzeUgDO6JDZIigmKDiQB
	TWeAJPVw24y/gEIO9nhSvGLpug==
X-Received: by 2002:a05:7022:3b8a:b0:166:f097:6f12 with SMTP id a92af1059eb24-19934a9278cmr9164130c88.15.1792992457049;
        Sun, 25 Oct 2026 22:27:37 -0700 (PDT)
Received: from localhost.localdomain ([136.25.42.214])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-198a1bfaebfsm21437866c88.15.2026.10.25.22.27.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2026 22:27:36 -0700 (PDT)
From: Tim Budding <tim.budding@gmail.com>
To: netdev-bot+sashiko@kernel.org
Cc: netdev@vger.kernel.org,
	linux-sctp@vger.kernel.org,
	lucien.xin@gmail.com,
	marcelo.leitner@gmail.com,
	davem@davemloft.net,
	edumazet@kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	shuah@kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH net 1/4] sctp: purge abandoned I-DATA fragments by stream and MID, not by TSN
Date: Sun, 25 Oct 2026 22:27:05 -0700
Message-Id: <20261026052706.187296-1-tim.budding@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <179293012722.3134.13316596865856977030@kernel.org>
References: <20261024120627.837568-2-tim.budding@gmail.com> <179293012722.3134.13316596865856977030@kernel.org>
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Post: <mailto:linux-sctp@vger.kernel.org>
List-Help: <mailto:linux-sctp+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sctp+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sun, 25 Oct 2026 12:08:47 +0000, netdev-bot+sashiko@kernel.org wrote:
> > +		if (event->stream < sid)
> > +			continue;
>
> [Severity: Low]
> Each call to sctp_intl_reasm_flush_mid() starts at the head of the queue.

[...]

Agreed. Walking each queue once per I-FORWARD-TSN would be a separate
change. I could send that to net-next.

> > -	/* purge the fragmentation queue */
> > -	sctp_intl_reasm_flushtsn(ulpq, ftsn);
>
> [Severity: Medium]
> With the TSN-based purge removed, what frees an unordered fragment of an
> abandoned message that arrives after the I-FORWARD-TSN naming that
> message has been processed?

[...]

> Should the commit message also mention the lost rwnd and receive buffer
> space? Alternatively, could these fragments be dropped when they arrive,
> or when the cumulative TSN moves past them?

Correct, and the commit message is wrong to say such fragments stay
until the association is freed. An unordered fragment of an abandoned
message that first arrives after the last I-FORWARD-TSN naming that
message, with a TSN above the cumulative TSN, can't be reassembled. It
keeps its rwnd and receive buffer charge until a later unordered skip
on that stream with the same or a higher MID, a reset, or teardown. At
the tail of reasm_uo it also stops reneging, as any fragment below the
cumulative TSN already can.

One late fragment is enough if nothing after it has arrived: the
receiver then delays its SACK for the I-FORWARD-TSN, the fragment fills
the gap within that delay, and the sender never names the message
again. With the last fragment of an abandoned three-fragment message
arriving in that window, that fragment stays queued (RX_QUEUE 1232). A
duplicate can't do it, as the TSN map drops the second copy.

Before this patch a later I-FORWARD-TSN covering its TSN would have
freed it, so if another message is abandoned later, this patch keeps
it longer. Without such a later I-FORWARD-TSN, this patch frees more
than before: in the same test, the TSN-based purge leaves the
message's received fragments above the New Cumulative TSN queued
(RX_QUEUE 2464 without the delay), and this patch frees all but the
late one.

For an ordered message the same late fragment aborts the association
instead: its MID is below the next expected one, so
sctp_validate_idata() fails. That happens on net today as well. I
could look at it separately.

Freeing fragments once the cumulative TSN moves past them doesn't work
with interleaving: a live unordered message can have fragments below
the cumulative TSN, and freeing those is the loss this patch fixes.
Dropping late fragments on arrival needs new per-stream state, the
highest skipped unordered MID, which must be cleared on resets and must
not go stale when MIDs wrap. I'd rather do that in a separate patch
than grow this fix (question at the end). Either way, v2 will spell out
the cost in the commit message.

> >  	/* abort only when it's for all data */
> >  	if (ftsn == sctp_tsnmap_get_max_tsn_seen(&ulpq->asoc->peer.tsn_map))
> >  		sctp_intl_abort_pd(ulpq, GFP_ATOMIC);
>
> [Severity: High]
> Can this branch still flush the whole ulpq for an ordinary I-FORWARD-TSN?

[...]

> A later patch in this series, "sctp: don't treat an I-FORWARD-TSN as an
> association reset", seems to address this. It drops the max_tsn_seen
> check from sctp_report_iftsn() and makes the stream reset paths call
> si->abort_pd() directly. This patch is tagged for stable on its own.
> Should that change be folded in here, or should the two be backported
> together?

Yes. At this commit an I-FORWARD-TSN whose New Cumulative TSN is at or
above the highest TSN received still takes that branch, and
sctp_intl_abort_pd() frees every queued fragment, including those of a
message still being received on another stream: the same loss this
patch fixes below the leading edge. If that message is ordered and in
partial delivery, its MID is also skipped, and the association is
aborted when its next fragment arrives. With this patch alone the
ordered and unordered tests pass and leading_edge fails. The later
patch fixes it. v2 adds a leading_edge case without partial delivery,
which shows the loss directly.

I kept the two apart because they are different mistakes in
sctp_report_iftsn(): the TSN-based purge, and treating ftsn ==
max_tsn_seen as a reset. But they share the Fixes: tag and the
symptom, so folding them is reasonable too. The later patch needs
patch 2 and the new pdapi_seq patch (see the reply to 3/4), and
neither of those needs this one, so folding would mean those two
first, then this patch and the later one as a single patch (question
at the end). If they stay separate, this commit message will say in v2
that the leading-edge case is only fixed by "sctp: don't treat an
I-FORWARD-TSN as an association reset". All three fixes are Cc: stable
and apply cleanly, in order, to the v5.10 through v6.18 release tags.

> >  			sctp_intl_stream_abort_pd(ulpq, sid, mid, 0x1,
> >  						  GFP_ATOMIC);
> >  		}
> > +		sctp_intl_reasm_flush_mid(&ulpq->reasm_uo, sid, mid);
>
> [Severity: Medium]
> This is a pre-existing issue, not one introduced by this patch. Does the
> new flush leave unordered partial delivery stuck when the skipped MID is
> the message currently being partially delivered?

Yes, and that is the next patch in this series, "sctp: abort unordered
partial delivery when its message is skipped". At this commit no abort
notification is sent and the next unordered message on the stream is
delivered as the rest of the skipped one. The uo_pd test fails at this
commit and passes from the next patch on.

Xin, Marcelo, two questions for v2:

1. Fold "sctp: don't treat an I-FORWARD-TSN as an association reset"
   into this patch, or keep it separate?
2. Should dropping late unordered fragments be part of this series, or
   a follow-up to net?

Unless you prefer otherwise, v2 keeps them separate and leaves the drop
to a follow-up.

pw-bot: cr
