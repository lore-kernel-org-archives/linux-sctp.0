Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 009623B05A5
	for <linux-sctp@vger.kernel.org>; Wed, 29 Jul 2026 15:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785337710; cv=pass; b=rppuzQ9EyKNuC3f1BAiDrIumyK9c+Y0hE9GPzhLec0XwUtcIcEUEOCu0kpzVazzpSBMWGngS936rFtDpbs3FpSnlDiksUnuMzWWTw9NrCtJOzGPApCpNmRxQwe+ipFPglIEI0ya6qrfe6tmCVW7vvCnwiidzZXK0EbKniM77y44=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785337710; c=relaxed/simple;
	bh=C1hDEqmnAa3TDi8gjx1zqfyVR/iLfuR2KeKJu77rxU4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hn0dPDrXxnYt0j9xCd/+CGy+WmtGNWXw46R2XXv6LC6daNPx2ra3KSaW7khVw39GSUQ5eM4fOb1jS7k6PQkw3aNAbwn4D+waYpX/ZtzXXHYjuRmDf2JOYRS0gDXILBr9ZAxQEHmnDOHKB4RDfGYPV4On4X4WCskqSFIF5Ib57W4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M5rJwYmZ; arc=pass smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M5rJwYmZ"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-84847482584so898899b3a.0
        for <linux-sctp@vger.kernel.org>; Wed, 29 Jul 2026 08:08:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785337708; cv=none;
        d=google.com; s=arc-20260327;
        b=L6UhsFCnKDx5nVFX7r74NHF8JysHNRNVbDcIfj/77KqW/2qy4ZVUFwR+1fe90xQ4Vg
         0CkgIKfR90vKjBAbIsXgzvySVi5FEeuQ3FRPVugWZ5of3CJP6G/yqYSEx+5HdUNZUUcW
         MiDIjzqaJNKCyiRCHIuR2ew9rq0pZp4HcQHo7hgUfTgo/FFkNv/ytYQZZobkUMox1xMe
         WIfy1+ogDaLt6hToZRiEotuNh7QK7U5V6EciEFfhmtWc2XBduHrDVhwOmA3e3/PTZ5oN
         49oJio65gCVYAKdKLxK1fBBsB6uMCvodOpTKhvqhoEOMZYRFB+jrMSGPy4laS1LNEACU
         Gu5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=DN2pJ0iBJxGrKHnDKUdsB6jvMBxu/va3aV7+6RRh+Zg=;
        fh=v43HBV+6DcXqvj1svJzijNDJDFDjhpAatXGv6r2lMeQ=;
        b=c72iyvRLrPfzpva2djlwdZrQpgkEDo8AzKvC7v0Cbn3gWu8ZOP9YvDgRtrUdNYCpyr
         No8v8SH4yZQh2CFVXL6tI3FUSAnLzuJeUMBl/qqJA8neO7v0aXCUq2RlU5eLlWt816FX
         b6MGljolv5W74GcAV3+yJIt2pFFkQBMtDfbUiU5t3UQOZtDU5FNSvdG4T0oh7pbZlnkI
         RA/PWPPSst3g2/Ew7QmJYiS+31R8uF3fD8+T5mhtaZP4hVHG5nj6z4JRdZccF2sDpwBk
         9HX3MBEM+DvTOiIduWa9YA05hXRog8zsmuInrljp4AF4yKRe9+w+pZ6zysKdUUY1+zvG
         MpdQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785337708; x=1785942508; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=DN2pJ0iBJxGrKHnDKUdsB6jvMBxu/va3aV7+6RRh+Zg=;
        b=M5rJwYmZIAtlq2ZrXWae5DyVp354Bdhjn+v8XphW1gScMIbXvLwDFkRLCUBBgMqowp
         u25PREYtIQY4zXbqPGZYRcH9UiWZcSW5cG5J8Ih2etgIARHnoRdnv0VBKWmpQZ4fyatz
         v+AhHsriMbdRHCgCuedHZj/GXbRfjMRKZjXG2NzBJPp2tk29qMfvGwss8Fk9pbOvJeLr
         imfUc0eNOr9EEmjc9joTMa+eWQJFoRecb3d2TFqrkn3BtR8k2oARWcg7FhWtV7XZYndt
         h1NMJkkBhXxhs4Nj6gZp4/iqT7FrEEvG18k+0YIYONZoPFmbyWPLsz301B2E1WEXXnvP
         JVYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785337708; x=1785942508;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DN2pJ0iBJxGrKHnDKUdsB6jvMBxu/va3aV7+6RRh+Zg=;
        b=mfxxed/7WIUzhpP1uHgcYxpUwWzTtvzp86wocbag4Cgb062sXnSmvVmFeLbAgWG54+
         wotLg8p6qRdDg1G5EA49A0lu4H/1cJMrZNd5q9QVK041xKsrQxbALsPKuKxzkrscFpbB
         CO3PcLDkkC7UwQmg0bxj/6BvpyEZLjPJZo70+FSxjd3L4CNooJcAvgegHY60c0lXomIJ
         gy2yfNajtDdy/RWgI70VRmp4trYeVpM0d23faPG98lzdb2PrybSiONK/QufdCMqk+cBV
         S/atXRqXLOyP6TYPoSpAgbqOUI0LjfULjRB6fiu3uP9OH8e0k6Wa5CVJzK+2kJ5euB2k
         ybQQ==
X-Forwarded-Encrypted: i=1; AHgh+RoJzWtQxiP5PpQ/hpOfmiSAm0eyxOs9a6b+/6tXff8HtnlJmn0kWP733iZq2/T2PcgbzG/+jLk/ccqz@vger.kernel.org
X-Gm-Message-State: AOJu0YztbkLt0dtiT3MVphCZ91tjyBS8An4EAQ4MrbbKxOrqb9esvJn9
	qW4nrizozkH/alSvDICRdUvpgFTGkgtZ62Tsq5dzNOE2A/Oqg5OhxFVBKPGvlOshLrbHOxKvUY3
	AfBgQa79NUunlwsCVdYw/Yrc7e45pZQQ=
X-Gm-Gg: AR+sD106Qd6pS/nVnkd1Ztw8VYSEE9EDapANlIr0ME/2SuyoGlLE870hO0+Y61iCJ24
	GtE7FUc1c9CBpfzPzLsJoetCqkndfQjDh7U0ee5eab1q2DzZRE91kcdYUOqDZnM9JPbEPWIA44U
	rRrg6Ndizjp2edwmgcMivehYd0pCSKjS5KAdg5yIZdmx2OTFJC5fOnw1asdz0fjv26BM/lk9Jvn
	FY55Yj8JWE0Ywixxc94vbDIwgYosRKpJrK5UDH4wMt1JAd0ezxX7XOTCnri1K48v0ev3EmXp3eJ
	lIhjxVxOP9uaZcFzgvWKSH82hlMnMqilxHxOTmu6txNkWUnPJIlFDEF9PDl50zKH8Av8G2SRxgC
	DkJDc+2sEoBKcEPnnWV4dzNYrJLITapJhbeC6+W1CpFI=
X-Received: by 2002:a05:6a00:bd86:b0:84a:46ec:3b9c with SMTP id
 d2e1a72fcca58-84ea7aa3469mr2826245b3a.31.1785337708243; Wed, 29 Jul 2026
 08:08:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260729-sctp-cookie-preservative-length-v1-1-1ade32e42668@gmail.com>
In-Reply-To: <20260729-sctp-cookie-preservative-length-v1-1-1ade32e42668@gmail.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 29 Jul 2026 11:08:16 -0400
X-Gm-Features: AUfX_mypXq3HMlzPwWFUdF9XmRRShPhdnIHIc7-DAFADR9LIdIHSrIzgJYlIUYQ
Message-ID: <CADvbK_ds_4sNnVTxXEooHkkA6JjV35ByCx+BWXiihiAo2cX8gQ@mail.gmail.com>
Subject: Re: [PATCH net] sctp: validate Cookie Preservative parameter length
To: trilobyte777@gmail.com
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 29, 2026 at 10:54=E2=80=AFAM Charles Vosburgh via B4 Relay
<devnull+trilobyte777.gmail.com@kernel.org> wrote:
>
> From: Charles Vosburgh <trilobyte777@gmail.com>
>
> The Cookie Preservative parameter contains a fixed 32-bit Suggested
> Cookie Life-span Increment after its parameter header. However,
> sctp_verify_param() accepts a header-only parameter because the generic
> parameter walker only requires the header to be present.
>
> sctp_process_param() then reads lifespan_increment beyond the declared
> parameter and adds the value to asoc->cookie_life. When the malformed
> parameter is last in an INIT, the read starts at the receive skb tail,
> and the resulting value changes the expiration in the State Cookie
> returned in the INIT ACK.
>
> Require the declared parameter length to match the fixed structure size
> and abort the association through the existing invalid parameter length
> path otherwise.
>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Suggested-by: Xin Long <lucien.xin@gmail.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Charles Vosburgh <trilobyte777@gmail.com>
> ---
> This follows Xin Long's review of "[PATCH net] sctp: validate Adaptation
> Indication parameter length", which noted that
> SCTP_PARAM_COOKIE_PRESERVATIVE has the same fixed-format validation issue=
.
>
> Runtime-tested in KVM/QEMU. The unchanged reproducer accepts header-only
> and overlong Cookie Preservative parameters on the unpatched kernel. With
> this patch applied to net.git base 51b093a7ba27, both malformed forms are
> rejected while the baseline and valid eight-byte controls still pass.
>
> The patch passes checkpatch --strict, builds net/sctp/sm_make_chunk.o,
> and completes a full x86-64 bzImage build.
> ---
>  net/sctp/sm_make_chunk.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
> index a1c0334a1038..eb9cff77759b 100644
> --- a/net/sctp/sm_make_chunk.c
> +++ b/net/sctp/sm_make_chunk.c
> @@ -2165,7 +2165,14 @@ static enum sctp_ierror sctp_verify_param(struct n=
et *net,
>         switch (param.p->type) {
>         case SCTP_PARAM_IPV4_ADDRESS:
>         case SCTP_PARAM_IPV6_ADDRESS:
> +               break;
>         case SCTP_PARAM_COOKIE_PRESERVATIVE:
> +               if (ntohs(param.p->length) !=3D sizeof(*param.life)) {
> +                       sctp_process_inv_paramlength(asoc, param.p,
> +                                                    chunk, err_chunk);
> +                       retval =3D SCTP_IERROR_ABORT;
> +               }
> +               break;
Why not move 'case SCTP_PARAM_COOKIE_PRESERVATIVE' down
to after 'case SCTP_PARAM_ECN_CAPABLE'? it will save a 'break;'.

Thanks.

>         case SCTP_PARAM_SUPPORTED_ADDRESS_TYPES:
>         case SCTP_PARAM_STATE_COOKIE:
>         case SCTP_PARAM_HEARTBEAT_INFO:
>
> ---
> base-commit: 51b093a7ba27476e1f639455f005e8d2e75390e4
> change-id: 20260729-sctp-cookie-preservative-length-ffa4472272fb
>
> Best regards,
> --
> Charles Vosburgh <trilobyte777@gmail.com>
>
>
