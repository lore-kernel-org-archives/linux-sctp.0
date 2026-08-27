Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A00B9484259
	for <linux-sctp@vger.kernel.org>; Thu, 27 Aug 2026 15:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787846394; cv=pass; b=Tck/z+F7qqrdHvQWddIviZVLcFw95hdIr6DojEn645KGDrKJX+Rtco4izIEYSV6wOt0VLd4SAxMrUjaJci97QllU8MKNp9QwikikuWCVq1zY5lXARTIuoVDVpEIp3EGaYlAvLHxtYPGmftOfiJUq227cnGJef61N5qktP4CTJ3I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787846394; c=relaxed/simple;
	bh=MapsIztLy09UbhU+7+S9oaDp8H3eC/Z/hVQj74AC93E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=s039B3pWjcDYIxR0zYx5zH3WkHkaVAGQ28sG9XjNqIcYQVuPSRKEctSUCokRbyrgAeWiT+L6BL4yjqquKjbXBcxFIgFRMxdOYYXErkUQRZvRycnsOlDF1qbKR8SMzngcdcHZR93Hh09M7CTiYz2tHeA0y+1GMYSEhpm5uuok9gA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gyQsAXYu; arc=pass smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gyQsAXYu"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-8557c3f270eso33234b3a.3
        for <linux-sctp@vger.kernel.org>; Thu, 27 Aug 2026 08:59:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787846392; cv=none;
        d=google.com; s=arc-20260327;
        b=DHljUs3YDtLoyg99QM5MrjOkQ2BkKu69GfUKf9bHavn5+x6aSTM9A85UVVqEq2DRGv
         W30pagZ5jCjo+xNPcuOU+RKz7zzCv0tm4dYyZNXSh2HKUd9MFHsKecvyc/Vn1MJOMHQQ
         39B/3l1ZOcDBWMweG3kLwkk80zNv0/6YaOOIGZN10N2DQ/kk4mrmD2R4F1uJ6UqVkaAv
         AqT0qkrr2jByUDZ1j52wWewXWkll27eXcuJYBR+lmTC58d+YpMhM5zuaID6fkVgkHPvv
         JHHhZ0TOL55izjzpZrF6QPib1F8Peo2sNiuVaX/n2LO1stu4OSvYVW6Bu7iYMu4hXN7Y
         RY3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Uf3bB7qcZpR+PPJRdyv+umREJvvSw/JAIAYin8FVQIk=;
        fh=7VNzLZTBEOce9ZOvsV1synKq5I4YtBPjY7mbETSC/5U=;
        b=VqKindLh94zQ171UrFG9F3EoNhHNZVphwHuMfZyzyQS8VE2YdXr7S/790HAujNKYHk
         eHq73sDUfIxFvBecDRF0J7mHE5gr2qm25Hs5aR3XKERqC8zJ3hA59qgEcuiJOwB+7dqV
         Gxi167BVV5eE92DccsS6PS6bDnkDv3SNWeXAc28An4N4WdnzZ+893kgNgyaloQw3+/tW
         IG6vCgu3vev1uC8wD5CKZRycI4rqrPrKNFX/LRClvDK7jZWgRTGTBDgAf5jf4oWxmvWm
         75sL/+QcSvxMxTa4tyxO4fsjfRpRikg+CXyhCt2kh54x/ht7e7Gm1vzy4LfZ32w4cZXV
         iymA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787846392; x=1788451192; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Uf3bB7qcZpR+PPJRdyv+umREJvvSw/JAIAYin8FVQIk=;
        b=gyQsAXYui1kjZzJaYcacaul2rNwImI3SwlddyhMwBZqU44Q1InzwFAeElIaPKTkSFx
         /Fqqhn6ZcieZHRdj4EYxHgw6drK1uVMy8CIkzYZNqCpcuGlheZzBUQ2yb/0zwEvQWyPd
         8e4gH7IxDMDL3QVvgIfAvxhEhZ1uyCKG71i5fF48WAQ3nABbLbRYeKS2K94LlMvw8oGL
         atOHMfyOTZFz0KlViALDu3hVo41YjCZJp0lo7sgI0DPbO8xIMy8DVP8zWXeo92sCIa2f
         CRLPYPO6vMzGi/zKn/wslT6zXTPYHApS6xxLN5Sv7jXpZMOa/GYOeLVeiOIHbBKvEnKr
         RVjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787846392; x=1788451192;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Uf3bB7qcZpR+PPJRdyv+umREJvvSw/JAIAYin8FVQIk=;
        b=ifNqdwAzDnOI6nJIcEauKY9NpKKmK9Og4lcDr8+GeA9XYrTxNT4rsmz+X3qOveEXWu
         bV1Pfmuydj/MWkdSS8MJ8pRIVYDjMIICzFZrK++ci1OMxpojg1i88FmC303skmVfZ+af
         eL3xuXzFUHNH1P/MqG/2CdKf8t94NJ+pThS+nSG02ht7Zs5o4JTs529L+cIEGp6GPH/v
         v9dyEBpJukCntj3bNU1ZziLQ9JoGhUWKrCpDbY3XNJ4cuQK6XixAvrywrx7NwRcXwuJA
         uPzU+sRiyobo3zK1YaBmHZND4k+mZJcybpIKmpvfU6t3FJ2REczF4jDEQBAdn5SAGhQP
         JBXw==
X-Forwarded-Encrypted: i=1; AHgh+Ro9oRcvgmieaO/R/QsBIXlYxIG/TawTMwszGcmcEwr2NXnx6/nhamEp1MdE8nu6vShvcynZB0uYXyvS@vger.kernel.org
X-Gm-Message-State: AFuF++myeFa8n6nfBvGniHyla2Kee2pwfSZjH913OParKaioBfndDAcp
	5UkuDRbrbpj9Nni9FR2c6vj+9kuSLDxeFtL2GpHSGV5INE6hmCY48/99/0NRAN4j+9tDMct5gy2
	dIII3spp+KrqnksSNgwNcLLSykn7LLFM=
X-Gm-Gg: AR+sD10icOvJ6EXyEcd4WPMUjv+xEp++7L5cqVMtbuleL1QJGlawlMmxZLa/hsdFILR
	oD59IUk+dBO3cLxpq7ylj87ZpXT5YczQcDYT/Rs+BmdFGgy/jRQMkbww1F3ZCqVFQZKuw8bs/me
	YDCgwxArQWFfo0U7sBufU4Bcokp9O/j4sbPDnPzs0suW2xc/D1RZIrtqAF7AVotrP/RWKgZgMip
	VfX2MmHSFBDcr7WTMxYn4SzsB60gkex6HhNvdJv5XPey/V406uGIgD0OqyC7XGlkvluRnn4ltba
	y/rZJkS2pu87oKKveeEVA5zHionlR7qSmdkPNLsqFhJKlKrpL1pFHIwngTrgajNj+J+nJEvVekN
	fkR9Id/0imscDUCLA1hQuH+wID405+wtDdh+FHqUr5VTe
X-Received: by 2002:a05:6a00:a118:b0:847:8449:2bb6 with SMTP id
 d2e1a72fcca58-8562953d5e9mr371891b3a.4.1787846391540; Thu, 27 Aug 2026
 08:59:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CADvbK_dr8Oz7DFpA3YJ_YH0HXgWJgkQPRK7QNDCUQrQzQnw-MQ@mail.gmail.com>
 <20260825082909.2650171-1-bsdhenrymartin@gmail.com>
In-Reply-To: <20260825082909.2650171-1-bsdhenrymartin@gmail.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 27 Aug 2026 11:59:39 -0400
X-Gm-Features: AcwNN1UBd9hEJA40P83_GWTvA_-wfWR0MxVh5pE0XrwDHnI3rwCFvXgtb9RJz7A
Message-ID: <CADvbK_fh1LG1nr5gFgFRZUPWam_A0DRxG+tuHd+bq2hYwsgMZg@mail.gmail.com>
Subject: Re: [PATCH net v2] sctp: fix soft lockup from unpadded ASCONF-ACK
 parameter iteration
To: Henry Martin <bsdhenrymartin@gmail.com>
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, 
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, "David S . Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 25, 2026 at 4:29=E2=80=AFAM Henry Martin <bsdhenrymartin@gmail.=
com> wrote:
>
> sctp_verify_asconf() walks ASCONF-ACK parameters with
> sctp_walk_params(), which advances by SCTP_PAD4(length), and its
> SCTP_PARAM_ERR_CAUSE case performs no length checks, so an odd-length
> parameter passes verification. The consumer sctp_get_asconf_response()
> then iterates the same parameters advancing by the raw length, without
> padding. A single odd-length parameter desynchronises the two walks and
> makes the consumer interpret attacker-controlled bytes at a misaligned
> offset.
>
> When those bytes yield a length of zero, the while loop over
> asconf_ack_len makes no progress, spinning forever in softirq context,
> and the watchdog reports a soft lockup. A remote peer can trigger this
> with a crafted ASCONF-ACK on an ADD-IP enabled association with an
> outstanding ASCONF (RFC 5061 section 4.1.2 requires the chunk to be
> authenticated, but the predefined empty key id 0 allows the peer to
> compute the same association HMAC from publicly exchanged parameters,
> so the gate does not help).
>
> The missing length check in the SCTP_PARAM_ERR_CAUSE case also lets a
> 4-byte parameter reach the consumer, which reads crr_id (offset 4)
> before validating anything, yielding a 4-byte out-of-bounds read past
> the parameter, as reported by Sashiko.
>
> All reads stay within the received skb for the lockup, so it is a
> pure remote denial of service.
>
> Reject undersized SCTP_PARAM_ERR_CAUSE parameters at the verifier,
> and advance the consumer iterator with the same padding rule as the
> verifier to keep the two walks in lockstep. The verifier change alone
> guarantees length >=3D sizeof(struct sctp_paramhdr) for every parameter
> the consumer can see, so no separate minimum-length check is needed in
> the consumer. The consumer padding fix is still required because odd
> lengths >=3D sizeof(struct sctp_addip_param) remain valid for
> SCTP_PARAM_ERR_CAUSE per RFC 5061.
>
> The issue was found by ZeroHive, a vulnerability hunting agent at
> Tencent Yunding Lab.
>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
> ---
> v2:
> - Drop the redundant length < sizeof(struct sctp_paramhdr) check in
>   sctp_get_asconf_response(); sctp_walk_params() together with the
>   param.v !=3D chunk->chunk_end check in sctp_verify_asconf() already
>   guarantees it (Xin Long).
> - Add length < sizeof(struct sctp_addip_param) check to the
>   SCTP_PARAM_ERR_CAUSE case in sctp_verify_asconf(), which also fixes
>   the out-of-bounds crr_id read reported by Sashiko.
>
>
>  net/sctp/sm_make_chunk.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
> index 236e25abc7a42..1166d1c5ea584 100644
> --- a/net/sctp/sm_make_chunk.c
> +++ b/net/sctp/sm_make_chunk.c
> @@ -3215,6 +3215,8 @@ bool sctp_verify_asconf(const struct sctp_associati=
on *asoc,
>                 *errp =3D param.p;
>                 switch (param.p->type) {
>                 case SCTP_PARAM_ERR_CAUSE:
> +                       if (length < sizeof(struct sctp_addip_param))
> +                               return false;

Sashiko [1] is asking to raise the check against:

sizeof(struct sctp_addip_param) + sizeof(struct sctp_errhdr)

[1] https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260825082909.2650=
171-1-bsdhenrymartin%40gmail.com

With this change, I think you can remove the asconf_ack_len check from the
SCTP_PARAM_ERR_CAUSE case in sctp_get_asconf_response(), like:

-                               asconf_ack_len -=3D length;
-                               if (asconf_ack_len > 0)
-                                       return err_param->cause;
-                               else
-                                       return SCTP_ERROR_INV_PARAM;
-                               break;
+                               return err_param->cause;

Thanks.

>                         break;
>                 case SCTP_PARAM_IPV4_ADDRESS:
>                         if (length !=3D sizeof(struct sctp_ipv4addr_param=
))
> @@ -3460,8 +3462,8 @@ static __be16 sctp_get_asconf_response(struct sctp_=
chunk *asconf_ack,
>                 }
>
>                 length =3D ntohs(asconf_ack_param->param_hdr.length);
> -               asconf_ack_param =3D (void *)asconf_ack_param + length;
> -               asconf_ack_len -=3D length;
> +               asconf_ack_param =3D (void *)asconf_ack_param + SCTP_PAD4=
(length);
> +               asconf_ack_len -=3D SCTP_PAD4(length);
>         }
>
>         return err_code;
> --
> 2.43.0
