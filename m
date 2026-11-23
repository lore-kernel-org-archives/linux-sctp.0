Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.215.179
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795448996;
	b=pPuyMwTXqGTPLktKJ8S0t1puRi4L4NEKM+AtJVWp7fhf492FDvKO6rphpXu6HhGyy2Ib
	 r/e2KkC5MO0gesyY9k7cXs8dxo1VkTdgjUKFfBXiP90/Od2wif4J5rkzpADZFj+4YE5Et
	 zVbz6RVTpD1cll2ACS+z0eu/fWTyNiJis1Z+p7q/hE/XrrOD9bjuExAbJ27j9RrcbLm/2
	 7Y3v+b1Pxj4R92g5uEtOIO2okM+idLPNmr8LUWL+YHDZiWK87eIwu1DxJnApu5vPQ7squ
	 aKxhmeIDfBJcIKvwoASrp0i3WihfZkynjYr4WfZQxoRvq1HwRHaluubA8wLal2igITQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795448996;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=CMmQ6INmXiwcGVG7cDEb9gETIEOSBjI9cIVQ8TCWVFM=;
	b=4XbtlXBm3/ZIOoB2K+l/11ULwZIP02X6/C0yI8MIY98qyplE2mxxS/cGeiPxnKzcAlRO
	 gvVi3WUVC0BUneo9OHpZ0bomY9rG9z3/9/WuozCH/+Id6g1P2J+b5AtWzL0da5POr6D/N
	 itiV8/z0/ZCUOQXH6mNeG6JGKZryHmCtCks6bFX/6osIzUOYsgUU7JwLwdAbY6jIPoDS9
	 ggP7TvszRhJLahzK43SD7n63hHXghyb6qa7YEWoFNFQlSVkCJ6av8NGes/x30c0Nk94fB
	 za6NT+5gw0s+qwledIsTJ42N20+wbh+iXC5Ht1t9PT3Jarq6gtkmgIfvrzherx0vIcg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=eedCJ9tf;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.215.179
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E6E5606A31E
	for <linux-sctp@vger.kernel.org>; Mon, 23 Nov 2026 15:49:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4E6E5606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=eedCJ9tf
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-cdb2e0062bbso1315325a12.1
        for <linux-sctp@vger.kernel.org>; Mon, 23 Nov 2026 07:49:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795448996; cv=none;
        d=google.com; s=arc-20260327;
        b=R4P0rKxtS1QO+zvpHGYJZrUXTk9OdCLz5CF3/Q5alay9VuW3AIfnbBUFl4nNVqocDP
         1pY5BAIxaLid55Z1zxP0+HwaoVEzEe4zVsOvBTa/1G5ZyMpQHgzRY52MLKjlQK2wNUrr
         M5b9arcyPO2aMFVZwUYPW305fgDG3NyJkv3a7aSLROI+s+D09FgxBk2YtTBcIBEWattc
         9HEy1PFAIdVmhLpQlfMj8W3UmxSIZ7LG6ucI4KiCbMzVWaepsy9a2dRJK8o2fX9L52bS
         xC23CLe8PiBPdWjhLsqrhVjkmXLLQMAmr9qk4ee6/jZ5jaTsRNZx7TfGU6AXfYVjOjzF
         v4+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=CMmQ6INmXiwcGVG7cDEb9gETIEOSBjI9cIVQ8TCWVFM=;
        fh=s++EnXiDLDD+07YpzEQGaLiEg2noUcTHvzdnbzl8NNA=;
        b=DPtPRQW5u/mUPtGWAtVLSo/TzIvO4WEv2kIWCkQQconzukz/TVh27zAtCaxzdAo8yD
         zpBOr64/xcfm2z8nCR7l/3sE7aFVsZvBu5f0aGvkvRxOTta7pYua9FdMTMDB7T1EdKux
         rr93sBCTvOb+mGUHRM68VyCcT6cfZ0JDoWfyc0Syb91D43EOiJk+1jky8+dH8hrq3rPV
         +CYf9VZZUtkiOiDokAK7y2PEPkjM8M+/dllMBpwJZyZpJepI44gRMuTKH/NhFGlRKIPA
         c238/3CG4DWrdm05HEOR+UacHGxbIeffZ+blAqmY25N2ILMRNwdYu/uT1WX87y4Vf+OT
         wF3Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795448996; x=1796053796; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=CMmQ6INmXiwcGVG7cDEb9gETIEOSBjI9cIVQ8TCWVFM=;
        b=eedCJ9tfTDSRzyln54EeHnzpZvJfRz9BWwilFHCmrk/prroJ6ckCamqhW2ClVr6O6H
         K1tBqT42ZInhovMBN+MJJlyhWHgDwmPIpbcYon/qGKi/kcF/eCt0u3L4uNHC766R7sD3
         9wZ4rAh0i1mt9s/6WrftWFKrSnF0O7STxc64IMTqKaUkQcBz26o9DPF3iVaFL8oGwXIC
         arGnIFv55TOKvFGwSbG9WX8VkFx1tGNTsvG5+9C5fRImsxaZdkQz0w/Iu5BYG+54ZiW5
         NvCElLl6ipiS41t2CUz7VeAb5l4cx933/Vi5COeXfxyguJH9y9uKD/qH6TYB1UK0FvXy
         2RCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795448996; x=1796053796;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CMmQ6INmXiwcGVG7cDEb9gETIEOSBjI9cIVQ8TCWVFM=;
        b=EgHd66soRs3ScnDIpBxGzYd3rUC4P12hSA41xGFZXuYRNJcnK+/oqaqAP1MWvsyN8c
         BxHvr8cOlsCRsJK678YV11PKlgxvh3jLfQKFsSkUSusjiAOooZzaOJgwW+YJzfpKLTVu
         Y3DOzb2HGOqbojzc2Tu8MSiNWUfeh+YuKgzGXnDjEEgeepzv6cKaR9SCkrjuDCVF5DRF
         0b3/ExRn1c9HG6da2sXxjTtHP/5QHhwnofPX8EvRrkGYLa36qk7qADES1VMjXok7cGb+
         5qq/CgYRbgQqfDuiCPyMxKb7h0eqwH/3yfvzZViruZRxnIi2KOgYVfjKZuZXXHLCWf9w
         3jFQ==
X-Forwarded-Encrypted: i=1; AL+hErF8pVbqYW92++w/5ZnxZKIkdZ8sUzLDfJpuwAFpMAtwdt/NC+U5CJI4OVmBWmJs876iAQ4YGNyL5Zmz@vger.kernel.org
X-Gm-Message-State: APuU4Z/JgfUv0QMP/4aVKk4XM7Wsjqdz/PQHreNqZBX5t33wcUXwQroB
	JQKBNpbbKovLKGHJiBr4MitdGkr6AzUvwYA1tGJ8PSWvQk8axDEcMeGQngqAH8pAvKrXCJbK9mp
	Acy4NMwn8+FuiqXXANMBM89qwP+r9WPY=
X-Gm-Gg: AZFdTZf9jcW3fM+vLA+Pxarcnybjj0n83L3SawoCV3glDtLQxTof6tIxMJO5quaCrb+
	ckD3EXRbm4BW2YzwjU1uZm9rm5w7shhrESMp4yQq59YDXq0gIkU+NoD5kjffg1hC4RaoU69xEh7
	0VHOeyT9U9HiFO6YEalus2xt2qzDdHawj8c2J8QWJAvNXQGMoIeLNjZUTskjdW5bFglmeDoVE0o
	6agEEjw1+lts61nGQppCtf2QWAMEhT9YMJgxuky6wJeBb0S9aFCnPi0Hqd6qEOFWag36/i8Zl1q
	KfhmERJWPComX2T1q29w0iOzpEOC+tC2f8WxP/FO5kBrJeHgmgpEhm4P9dv3Qquiq0o6+iCKl1i
	yir9YnJyxwbPMyrn9SKxjmDxU7qCUWgotMQmTBRE9qNRozch4ZJJ1NodLsT+NT/PdSXMu9At18L
	o+4NlNAeLNoSx3E4V24gfRn5A5RG41c/JL9BqZI77yN16v3m+lA5gttZEtiMvKn+zKRCFb4PETb
	WlD5HpO94c2cst6pw==
X-Received: by 2002:a05:6a20:1a1e:b0:401:e88a:66bd with SMTP id
 adf61e73a8af0-401e88a69afmr7266262637.1.1795448995563; Mon, 23 Nov 2026
 07:49:55 -0800 (PST)
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Post: <mailto:linux-sctp@vger.kernel.org>
List-Help: <mailto:linux-sctp+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sctp+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261117110459.44083-1-juny24602@gmail.com>
In-Reply-To: <20261117110459.44083-1-juny24602@gmail.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 23 Nov 2026 10:49:43 -0500
X-Gm-Features: Aa3M54pdoBf8iHky-mzKnZEQ3ImMVON5VYmghhM6AEY0RpAbNmQuTFG1XGcluso
Message-ID: <CADvbK_e=_=Vsqp6dxbRtdS6_chO0TebDrwXu-J0WMFrMRBb3Fg@mail.gmail.com>
Subject: Re: [PATCH net v2] sctp: preserve stream scheduler across outq teardown
To: Jun Yang <juny24602@gmail.com>
Cc: marcelo.leitner@gmail.com, davem@davemloft.net, edumazet@kernel.org, 
	kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, 
	linux-sctp@vger.kernel.org, netdev@vger.kernel.org, junvyyang@tencent.com, 
	corvus@tencent.com, stable@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 17, 2026 at 6:05=E2=80=AFAM Jun Yang <juny24602@gmail.com> wrot=
e:
>
> From: Jun Yang <junvyyang@tencent.com>
>
> sctp_outq_init() clears the installed scheduler when it reinitializes
> an outqueue after teardown. The streams still have scheduler-specific
> state that the old scheduler needs to release if the scheduler changes.
>
> Initialize the queue counters and flags individually so that
> sctp_sched_set_sched() can use the installed scheduler. A new
> association is zero-allocated and starts with the socket's default
> scheduler as before.
>
> When the socket default matches the installed scheduler, streams retain
> their PRIO priorities and WFQ weights. FC and WFQ also retain fc_length,
> including bytes charged for purged chunks. Those chunks were queued on
> the stream and the accounting converges as new data flows.
>
> Fixes: 5bbbbe32a431 ("sctp: introduce stream scheduler foundations")
> Cc: stable@kernel.org
> Reported-by: TencentOS Corvus AI <corvus@tencent.com>
> Link: https://lore.kernel.org/r/20261104105507.62743-1-juny24602@gmail.co=
m
> Signed-off-by: Jun Yang <junvyyang@tencent.com>
> ---
> v2:
>   - Initialize the five queue counters and flags individually, as Xin
>     Long suggested.
>   - Document the per-stream settings and fc_length accounting retained
>     when the scheduler stays the same.
> v1: https://lore.kernel.org/netdev/20261104105507.62743-1-juny24602@gmail=
.com/
>
>  net/sctp/outqueue.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
> index e92fb9da4647..3dafa6e6cab3 100644
> --- a/net/sctp/outqueue.c
> +++ b/net/sctp/outqueue.c
> @@ -190,9 +190,12 @@ static inline int sctp_cacc_skip(struct sctp_transpo=
rt *primary,
>   */
>  void sctp_outq_init(struct sctp_association *asoc, struct sctp_outq *q)
>  {
> -       memset(q, 0, sizeof(struct sctp_outq));
> -
>         q->asoc =3D asoc;
> +       q->out_qlen =3D 0;
> +       q->error =3D 0;
> +       q->outstanding_bytes =3D 0;
> +       q->fast_rtx =3D 0;
> +       q->cork =3D 0;
>         INIT_LIST_HEAD(&q->out_chunk_list);
>         INIT_LIST_HEAD(&q->control_chunk_list);
>         INIT_LIST_HEAD(&q->retransmit);
>
> base-commit: a2239d5dbbda3a61b6323df8836f605921a29f7f
>

Acked-by: Xin Long <lucien.xin@gmail.com>
