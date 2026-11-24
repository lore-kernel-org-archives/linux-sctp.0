Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.222.52
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795532072;
	b=U9Zxn5MkQFzIHTr8DiiLQ6S5qfdiP6P5nXXQAY0E+iwV5mI748i8XPPXbRRQTDVAtMlD
	 k5zUDI1FYZCNMAFbfi7uDWWv840qzTqNNULiuCEwQDK8BHQUUQk6Q1u4wY5Mp2ZT1c0oV
	 LPjgP/ooG0qEdT/h4h1HNM08WhHBgQVQ5uyEqKM7d3Vn6CW4dIvvs+kmfjGpCsTyJgRae
	 WCBm8j0a7uJ/Tuies/Cn6iKwgm5DRHzvNd/e7uJLtzz3E80IQgq5IQDEJ65bjPzrBKomn
	 5BwG97e/75cYckXDMhAa81dSBszG1gJTJYWijExKsJC0vB/Tkc5KoMlTT76OGYt9qYw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795532072;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=71dTwShTfEdOQIdmJmi7XEX/3XHsadk4lJT6tIe3bHc=;
	b=Z8VjA7dnRktSyA9476UxVXgFynwkC5YniVUOtWmRp0DlyxGV2E9D9FMUJjUIRjbEcUaF
	 QHEc+9WiE+GUab/X3zQ1RLXAdylKCfxX0c6O1zZyScyjL92IAwZn2rIJHftcjRijhJGKh
	 +SH1eCAEnJpG/1KsMIoopAu+AGka/mhG5OSGZ+2xK6FyOrOLgTQD1xdacDIUrG7gjPyG3
	 xeM7iPVisimIdh8ZUqepHO+RmC5LCNogLTRMHZg0fExMRnq6PLKRdjI+MWl9/lRN3uAMY
	 kNn1+bvJuoVUDGUn9acjBp6oF/YoaFU+n3VhycpYKrPVPwiEFeuPEGt5xzg2VY3jrOw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wB1jEgxo;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.222.52
Received: from mail-ua1-f52.google.com (mail-ua1-f52.google.com [209.85.222.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38F9B606A327
	for <linux-sctp@vger.kernel.org>; Tue, 24 Nov 2026 14:54:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 38F9B606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wB1jEgxo
Received: by mail-ua1-f52.google.com with SMTP id a1e0cc1a2514c-99e0082c434so1103049241.3
        for <linux-sctp@vger.kernel.org>; Tue, 24 Nov 2026 06:54:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795532070; cv=none;
        d=google.com; s=arc-20260327;
        b=AZs15ib01at0EL3EioB/WQJAcLE1Kve18pdPMD6IAlvSYdpLm/MeDNGe1sh7JYtz78
         AlgtlLilRuMtvXZ2j7mFvN4YtiGZCSaQ/2iCNB43EHgccxZujZFIsI1iODeKb6oRrgQP
         3WprW2UrkGsqTDOH/0kRsxsRm8oxotr1udpIfF0093gcy7KFANGvRiOGKoYQBih8FuXf
         oCF2hUZnswPEFwmE8IEjFYnxPPEiXD2K4+bHOssh7AEg9Oph4geuHPcgVUfDpTOUIrii
         Afd3eVRFrNxfdIkH9ovRFwGy9xrdBSSHfQ/J9b3c+j3ZaaSzvdQjt4cyWQQnkbV1T2iO
         Rqgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=71dTwShTfEdOQIdmJmi7XEX/3XHsadk4lJT6tIe3bHc=;
        fh=IU1sDdWUS5le5X8v1cuZTXs+U6YsSHMQbQobwyrtehc=;
        b=oUIX3YUh5ClwVzA/Ip7xAdHWFUeuPu5VIqfjm2PCXEKfMIZcB1TVXPT6hApu6rUHLv
         g8WcPMrFVDBmIMrraHnoN9Ht6uwJqkYroSqQd5XTE0JWbjT1JJZj4VR7AQnVPF5geBBe
         3vqzSrFkl0B68Bb4qzzAvVj/CfhZBkFx7MmhdsSGbNnRbzMD3XT54v2H0E/Arxb+0yCX
         NgonLLddI8D43PgQgJlbfRFsR+IpxfGwgEHy4BHnPrGmM5Z/23p8Scx/TIrpZLneDBpg
         cCG2ENpzNjXBVNJS6alInsmmnHwTigjw2HsyEhKuKymZhHosfrPzb96mlqSZenB/7U8R
         iKJQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795532070; x=1796136870; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=71dTwShTfEdOQIdmJmi7XEX/3XHsadk4lJT6tIe3bHc=;
        b=wB1jEgxo3LCEB1zMm4kQGiZA7qS05r8+teZkpkEZ4S0amfm3fFSnZ/fohoGDEw0n8L
         Actc5v1/1+UxYOGIy0WzJtxW+adaMk48aS/uuUYvR/tdF7IWMHD4Hkt0gfohMdQGv4Uz
         b8T7x1qAOH2Nt6HOugRiojVc0wu7iPfd7R+oCXU+fWnyK9qG/TE8a8SC3WVlwKD/m30o
         a/m2gWdwteae1N7+Uck4xVr86kGvEhgl0F3IqAuC8lYwW/YDk3hNui82pDRdk8ytBwoW
         J9Kce+gP93vjixTE+vY+qkRgtgfPTsbBp6WW1KVUT0m30+OLu2iDEsX+AlKkUGf46iHs
         kGIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795532070; x=1796136870;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=71dTwShTfEdOQIdmJmi7XEX/3XHsadk4lJT6tIe3bHc=;
        b=y0hP1tJySIVV3f4WHIopelbnvgUx97nBMCPYv0u94NKSLdavGe6VbnSUXK/8stm/q7
         wIFaK9X7Azen7eKRvhJr1bSFV5ydTkFKyfPC1+uYkfxa3fp40Y562K9d+t+DxtKUJYMp
         IiW+GjX6nUSU3MBLizWvPQZaTfFjEkEukrT6HZ8rFJ770S7teQGOdpN6ay2R4XrcsQ2o
         2yE+0Oo8LQmNpzDkC8As94HTXtwKR3fN5iwvFTdvF+XHWa8WEzLXple1F3WILteh00AY
         VVuetT4n/vPbbA2xlc3l1jL/3Xb35x7nCTrD7Wq8vFSTIFakt9CQd6lvHysYhSpnb14Q
         lhSg==
X-Forwarded-Encrypted: i=1; AL+hErFy9+1IWeT8HIC11ncR9Ij1jkkIrO8yC45B3fh0mLnQUEbp0wFt7ijGnH7aEtdRg9cUjSvJ8R/60HG8@vger.kernel.org
X-Gm-Message-State: APuU4Z8kzzvPuoF5sY3ziEpE1TPp4kIKF6HfJFsMG0Q7QHB9TOJOpr0r
	FYwlOgzYIs3IgieX4lAal7mpX+zydRUKR4B1I9Ui7BbdVpVne19b5yx4l+2VQ25zPT5jWnmpkbR
	2Vzu5QLF4fEcqytoEI0F0URp/0+I57+Y=
X-Gm-Gg: AZFdTZffvAlRNnrc4j6RVqV7RBa8WanNo5k9CdV/jIoXYWlxEzaSkMkpZkHm4wmpbAk
	TZ2kzd+DvjhpdWsjNI1U/DEmQnQM3BaAAudxr9P1L/osrQ2hbLGvVPAYslMIa4YSaRnJKOyzEFx
	RW619/Uwe5Cu4Pb5sJJZ1uDc2+FQJ1oZDKkaXMShNLG2CcDaEugMiNe2oMMoP+sRFT1PRH8CAd3
	GEp3iEYqoMq+xjqZToRdJtB/Jd8i5CZysFjEWsqrwN4Wff7jQc15eQXeePdaTzF/UiJu+ekvUgS
	skeQ0t4UGkcJyGR+zFXeXcq02ex4yckSqbj95nHeWVLoao2ny3FhNvHARwJHAL2GyTCMQd0Q+vL
	uBJh5yVIyU8pCqhLrsig/fot/5xHqR2zpqVN4K9KgLXquJzqeSGEt00sH7lc56Q4scCebGmMwoK
	l3ughXjp+R2DGNC8ZK/9jls6P2MxKEj/XxpE+1VlgAXwG5HwV/b4ieP7lTjhk=
X-Received: by 2002:a05:6102:5494:b0:7cc:2cd0:e74f with SMTP id
 ada2fe7eead31-7d7398031b4mr5994320137.30.1795532070049; Tue, 24 Nov 2026
 06:54:30 -0800 (PST)
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Post: <mailto:linux-sctp@vger.kernel.org>
List-Help: <mailto:linux-sctp+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sctp+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261120035521.2098757-1-pkfxxxing@gmail.com>
In-Reply-To: <20261120035521.2098757-1-pkfxxxing@gmail.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 24 Nov 2026 09:54:17 -0500
X-Gm-Features: Aa3M54raP4uMsSk2aQXqFMpGIN55EvV3pDaZPRhl-7iMNA5lcjzDRXxQYcX7lvI
Message-ID: <CADvbK_e_qUTwQmhDquPnQNn3ghHmnHDA+3sdQ8p3-DNV6sQiXQ@mail.gmail.com>
Subject: Re: [PATCH net v4] sctp: fix use-after-free after association migration
To: Yong Liu <pkfxxxing@gmail.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Jakub Kicinski <kuba@kernel.org>, 
	linux-sctp@vger.kernel.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 19, 2026 at 10:56=E2=80=AFPM Yong Liu <pkfxxxing@gmail.com> wro=
te:
>
> SCTP timers and ICMP error handling can cache asoc->base.sk before
> locking it. If accept or peeloff migrates the association in between,
> processing under the old socket lock can race with an abort on the new
> socket that frees the association's queues. Transport and association
> references do not keep those queues alive. With mdelay() instrumentation
> widening the race, KASAN reported a slab-use-after-free in
> sctp_chunk_abandoned() from the T3 retransmit path.
>
> Recheck the association's socket after taking its BH lock and defer
> mismatched timer callbacks through the existing retry path. Pass the
> locked socket to the IPv4 and IPv6 ICMP handlers instead of rereading it,
> and treat a mismatch like a busy socket before processing ICMP errors.
> Skip socket error reporting after migration and check PMTU only under
> the owning socket's lock.
>
> Use READ_ONCE() for socket pointer reads in these paths and receive/backl=
og
> processing, including transport lookup, paired with WRITE_ONCE() in
> sctp_assoc_migrate(). Take the new socket reference before publishing it.
> The cached socket is protected by BH context and the endpoint's
> RCU-deferred sock_put().
>
> This issue was discovered by an LLM.
>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Cc: stable@vger.kernel.org
> Signed-off-by: Yong Liu <pkfxxxing@gmail.com>

Acked-by: Xin Long <lucien.xin@gmail.com>
