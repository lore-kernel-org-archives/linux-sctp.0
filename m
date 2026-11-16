Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.178
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794838452;
	b=YYP3M/gMu0wAjqD6KBSHU/gYLl37DYm5YBbDvVWQ+tORJ8z8sRVXSmYUxLVHUW8UzbSk
	 9RqFJIOli5LZK7FQHmX+Zw2f0q78OPgVgzMr8ku8L5k+CKNR3wBgJumQ5YYZWPiZG3UhZ
	 uHbTPYXUiYm6ADlawKqzK6dfvgkxplhWJJk7/pvjgR5K+rf5cBjq3fNtoXsR2XyNYARyH
	 xLdCeS5+PgIHhApF0dTWYBkxUbqgyQXPdejoRfwKKk8l6UTM2waFg4y02NcJeoluJT50g
	 DbQci/GFCgiBgMZzxSxCmzuqu9wMVqZre2cvF4LJNwNaG9TG82qLeCZcBVgOpfVTh5w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794838452;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=vb4ZJkfWv6+aUtGCDcEszVkftPli53KYaMyMrkK/QeY=;
	b=Agtd12Rhf2nPDHq/LaYpL2kZpEVTs3M7NTVmps+Gmia5sfiLigfF6gnMxmJpoPFnf59v
	 a/3PyajUUXbIsYibh00OQl0MWohi0nlnRJXH65yAtfPdC6K+FtDUIzJkfI5ffRy3fS7ni
	 jWMYZkhnyrZbIWLMfXOAYy2djL+ITmEewvtXVrpXj+jhbXfFbCFsSfulRxo49NbQaNCc4
	 i0woRa9CXTIB6XsvKjVNGAT+d6SKdiMZwgPzLBuMxElU3uqnsEjXXkigsUyKeF5IsENQU
	 v0hl71wqaI3d6K+HnvdSzlWpq2YS9u+FFrqNWHeB8ZFCoEEsjfKfn+B76+/NPIAOL6w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vG+CvywM;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.178
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45066606A32A
	for <linux-sctp@vger.kernel.org>; Mon, 16 Nov 2026 14:14:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 45066606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vG+CvywM
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-8b612fd74e1so1332905b3a.0
        for <linux-sctp@vger.kernel.org>; Mon, 16 Nov 2026 06:14:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794838451; cv=none;
        d=google.com; s=arc-20260327;
        b=Tpmf6FHCAajtSwBhkAnCJkQXqc97ZyAYvDOQjniDMV0vc9a26Z8irz2kIPX4rbSKh+
         up6JbeT1muQa3FZiR2ZX+NZg4qTioVdyxw8yvoTgloK4y4SouDvZ15GvOGi5Wr8ViIQr
         DDUnO5ZhrRxB7Fe1RbMDlPJwZFxIOm2WP4C4A2+7Q++CRpBZ/p9D58/2Ypw6CP45qmUr
         P0qAea+jfhFGVmzOpHWFQWTsoQq7I+awZH+O4Yjqt5vTlO0tTfj9z3I4JZifDhBRKHlY
         sJDRGgXXFeVWzO8PnBe+G92iVS76npbR4pAKc5EOjqHDXa2KkqlP5vAwfuWa5w4ZEGfd
         utbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vb4ZJkfWv6+aUtGCDcEszVkftPli53KYaMyMrkK/QeY=;
        fh=iT1GQQvBiw07szvgvNZ11F4V8aly9VwNfR1ZmqJBBq0=;
        b=kHA7ESfVlYPT00FMC9IPabMfDNMpG2XOIQ2I8KnGW7S4Tfj4JXX9UDTAuNX/qRoifY
         yDQqzsuuL6dOiwTDU92zKmzYcFWZGGybx1DlX6j/fNiNdhtjurGxKFqg+TO8uA3hNGik
         HTaxEvtGn0lNmWlAhonGqKzC7O80I3stU+Lndaa9c89/nSkQ3lynN+xCkrRpMV3AqRH5
         UbAh2Yd7f+3D94fnIOtjmGE1J8VM/86w/KDwGWfheg8BZQc3+XrBUKt83wc8f2O5h85r
         A6EovHlLbvawy5UlH8ZZMANMGNOZIP3KqurK7fQpMjDoirIq0MkBUR+OjUowgDdD5fGg
         RIIQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794838451; x=1795443251; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=vb4ZJkfWv6+aUtGCDcEszVkftPli53KYaMyMrkK/QeY=;
        b=vG+CvywMm1ldTXvGLhdGrQ39Y1Mc0sORNZCeR4GJ1dLmKEiARwnhn6ElkivHNtn20u
         MIxt5M8bR7Qq0pXOfhvZgdnaVIzPJxi26+/t5orEtQJWPon9vzvfQwmZHPVT6HsHgswG
         +kFK5YQE6ZXGfOos/BBLIpBAEQ1G6pydqP4r4yb4imRlq6Xw6pmghrK9qQpJTaHLU8Si
         5LBETHLbSgtbfKTFp33L/Fi6Q/43vh2ETPbSiQ96Mu2rmjYlqPWhEUvkJfi/fmMGrN94
         fDfIoVK63qyENq4WmDq3kNG/MuAU50ixMb0BmbvC0NdIKa143YZt+16zHk6b3fcjOGYu
         9N7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794838451; x=1795443251;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vb4ZJkfWv6+aUtGCDcEszVkftPli53KYaMyMrkK/QeY=;
        b=ufdzM/ZqWIwDPNVqNzGSHhv5jOSeJNFxehpnVfAbrWM7tWItMBhVC7NuzNqL0XyXgV
         3xjkVJIvWA4C3oX1vEDhNfctnF0zBBaQuRMT/dony9xWY+k5Bp8+VmoqNlrlu5Q0UVHV
         yGngCcPo+Iu8NArayfhzRCeKs0G/ghdy01iygYg8WTldjH98xcWBqWJJe8CuNwJQe+wB
         NeLgaEjfqRyg1s9MEO3/dDwkA4lUgMc+O9LKdiz22Yb6jgmt8imP1onFZQ99g1291viS
         EH1H7Oa+evaF1XgPFp7UIC3LDtwAI2lDL+eHpIDQYn9a/HhRuCcGS04KMWJ4Pr/kv3DX
         bETQ==
X-Forwarded-Encrypted: i=1; AL+hErEoIjoAPN+0ll3FtietR8U/JnwgzPw7vk/0bWsYtmwMHV/1CblXXQFf299Qk62l0FgnzkPg8FcHFUaG@vger.kernel.org
X-Gm-Message-State: APuU4Z/ZX4NrIXGtvqD/szdKu+MiUwNsdhQPChouYvNcCI1bBVrH0gmi
	1CFGX0AYqSKdlTy0YUFpGd0UYXQWSOEubT7eYRVTJaHMSEXkZforXFt7xn2GFomy+wPkGFD0afs
	Lo/YHOSM4o/h8Oxas6XSU58wkDvLD1aI=
X-Gm-Gg: AYBFou2QOl7jdsezlXkxghHKybycTU8ZHmBlvENhYrNVgZ5jpD4uxYcSLej/Zs3Fbv8
	LbXH/j/jOS3IQvot10GtVesZL5VPXP72qCFv1SY7Zf+AFLyI8u4TV2Epuv05Ep+KXCa45WmcSC3
	dayqbY8ebO70Gijq6oTS5GHUe5DxMS690zBigSJ9elBx6FijPm8LS1H6jQ2SfvtkKi4+5amHWcs
	roGthB/Cm++AlkTwp4i4YQl9J57rqB4NX3bB9sbY5ht478MnPoQPAndvSQ+/O/d752tfhiUUrSt
	lj1N9FcO5nFD6t+z7t1T4+oWmNIIM3lL+xzkg37NKuIpjxR94E0VsQ7DUdiOxVOOmEUO0fV+W2l
	26CP3ZHc0Toil/82/p3aeD1sAMvF2WTzbcHUxYugmAR/r0NFJ3gvVQjf+tw08UjZq2NKMi1JuO2
	DbaJdg213/p2rzBL/R9Ngq01dLWxJAUFctR9cW
X-Received: by 2002:a05:6a20:9191:b0:3e0:dc12:8908 with SMTP id
 adf61e73a8af0-3f7a8dd95damr9049521637.81.1794838451265; Mon, 16 Nov 2026
 06:14:11 -0800 (PST)
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Post: <mailto:linux-sctp@vger.kernel.org>
List-Help: <mailto:linux-sctp+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sctp+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <CADvbK_daN6zZNPckkGh=r70ooNwTz59VViJy5jPp1w18SDPrzw@mail.gmail.com>
 <20261111082313.1606366-1-bsdhenrymartin@gmail.com>
In-Reply-To: <20261111082313.1606366-1-bsdhenrymartin@gmail.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 16 Nov 2026 09:14:00 -0500
X-Gm-Features: AclHuK_PBS5DfVRnFcTFsg2uR9KLfQjm6-Pkb_EVvsTPuHEoQpl0gvLNWQC5tqI
Message-ID: <CADvbK_dKWmcM411yC6ZKrYtduukEL_aTp3Bw0XdkqOd5Tn=sXg@mail.gmail.com>
Subject: Re: [PATCH v2] sctp: fix skb_over_panic when adding addresses with a
 pending delete of another family
To: Henry Martin <bsdhenrymartin@gmail.com>
Cc: marcelo.leitner@gmail.com, davem@davemloft.net, kuba@kernel.org, 
	pabeni@redhat.com, horms@kernel.org, edumazet@kernel.org, 
	linux-sctp@vger.kernel.org, netdev@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 11, 2026 at 3:23=E2=80=AFAM Henry Martin <bsdhenrymartin@gmail.=
com> wrote:
>
> sctp_make_asconf_update_ip() accounts for a pending DEL_IP
> parameter by reusing the length of the address being added. The
> write-back side instead serializes the pending address itself,
> with its own address family. If the pending delete is IPv6
> (20-byte parameter) while the added addresses are IPv4 (8-byte),
> the chunk is allocated 12 bytes short and sctp_addto_chunk()
> writes past the end of the skb. E.g. on mainline (05441d697f7f):
>
>     skbuff: skb_over_panic: text:ffffffff84859c77 len:392 put:20
>         tail:0x188 end:0x180 dev:<NULL>
>     kernel BUG at net/core/skbuff.c:215!
>     CPU: 0 UID: 1000 PID: 379 Comm: poc_sctp
>     Call Trace:
>      skb_panic
>      skb_put
>      sctp_addto_chunk
>      sctp_make_asconf_update_ip
>      sctp_send_asconf_add_ip
>      sctp_setsockopt_bindx
>      __x64_sys_setsockopt
>
> Requires addip enabled on the endpoint (net.sctp.addip_enable=3D1).
>
> Account for the pending delete with its own address family, as the
> write-back side already does.
>
> This issue was discovered by Tencent CodeBuddy Security.
>
> Cc: stable@vger.kernel.org
> Fixes: 8a07eb0a50ae ("sctp: Add ASCONF operation on the single-homed host=
")
> Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
> ---
> v2: move the pending-delete accounting out of the length loop and
>     drop the del_pickup flag, which no longer guards anything.
>
>  net/sctp/sm_make_chunk.c | 16 ++++++++++------
>  1 file changed, 12 insertions(+), 4 deletions(-)
>
> diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
> index 90de272842512..b8e4db81636e2 100644
> --- a/net/sctp/sm_make_chunk.c
> +++ b/net/sctp/sm_make_chunk.c
> @@ -2870,7 +2870,6 @@ struct sctp_chunk *sctp_make_asconf_update_ip(struc=
t sctp_association *asoc,
>         int addr_param_len =3D 0;
>         union sctp_addr *addr;
>         int totallen =3D 0, i;
> -       int del_pickup =3D 0;
>         struct sctp_af *af;
>         void *addr_buf;
>
> @@ -2885,16 +2884,21 @@ struct sctp_chunk *sctp_make_asconf_update_ip(str=
uct sctp_association *asoc,
>                 totallen +=3D addr_param_len;
>
>                 addr_buf +=3D af->sockaddr_len;
> -               if (asoc->asconf_addr_del_pending && !del_pickup) {
> -                       /* reuse the parameter length from the same scope=
 one */
> -                       totallen +=3D paramlen;
> -                       totallen +=3D addr_param_len;
> -                       del_pickup =3D 1;
> -
> -                       pr_debug("%s: picked same-scope del_pending addr,=
 "
> -                                "totallen for all addresses is %d\n",
> -                                __func__, totallen);
> -               }
> +       }
> +
> +       if (asoc->asconf_addr_del_pending) {
> +               /* The DEL_IP parameter is serialized from the pending ad=
dress
> +                * itself below; account for its own address family, whic=
h may
> +                * differ from the added ones.
> +                */
> +               addr =3D asoc->asconf_addr_del_pending;
> +               af =3D sctp_get_af_specific(addr->v4.sin_family);
> +               totallen +=3D paramlen;
> +               totallen +=3D af->to_addr_param(addr, &addr_param);
> +
> +               pr_debug("%s: picked del_pending addr, "
> +                        "totallen for all addresses is %d\n",
> +                        __func__, totallen);
>         }
>
>         /* Create an asconf chunk with the required length. */
> @@ -2917,7 +2921,7 @@ struct sctp_chunk *sctp_make_asconf_update_ip(struc=
t sctp_association *asoc,
>
>                 addr_buf +=3D af->sockaddr_len;
>         }
> -       if (flags =3D=3D SCTP_PARAM_ADD_IP && del_pickup) {
> +       if (flags =3D=3D SCTP_PARAM_ADD_IP && asoc->asconf_addr_del_pendi=
ng) {
>                 addr =3D asoc->asconf_addr_del_pending;
>                 af =3D sctp_get_af_specific(addr->v4.sin_family);
>                 addr_param_len =3D af->to_addr_param(addr, &addr_param);

Acked-by: Xin Long <lucien.xin@gmail.com>
