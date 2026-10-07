Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6D2F49550A
	for <linux-sctp@vger.kernel.org>; Wed,  7 Oct 2026 12:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.215.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791377615; cv=pass; b=OGAG/7fWX/wHNjGPw2KUWJ0v4k7Ly56WoBZf4qIzZf72b5SICUa99of8uSXGf/iK4XsE2lT/ieJ7V5DfIOZhHyhLhMs765c84A/OauCRRquLDKJh/1rWw8/p+XtXIQyC+fvAyASnIoGY4GMRO0RqhKsOrpgw90vZBodqjc7uEgY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791377615; c=relaxed/simple;
	bh=7o8IHTHMGS/voyHQzhmgvEE338B91PLKSiRWBKqVlo4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MZIuEsPghOgXNh23ipfpZBaXan85KtWzs4P4O2xDeO15mFkmHO65/Yhl0YwnDRC+vlZmvCMA8JilC03QI430a2Se6d84+na9KZfuXk6x887M+bR0uMDibj6kYl4F2EwBCQzKS7JnwuwillV2Hl7r7IwDoNvdhzfPvYU59ZCcii4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PIxG2N49; arc=pass smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PIxG2N49"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-cc4b5bdd578so863467a12.2
        for <linux-sctp@vger.kernel.org>; Wed, 07 Oct 2026 05:53:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791377608; cv=none;
        d=google.com; s=arc-20260327;
        b=DGNJFM5zE37HaqA6Zz3WZHES0Gf8OB9UvP4c6SjJMg4uijfOUKOBgZ+rRXDENGNmjO
         f+a2mtnI6dTpF4ESXFnMn/oimMv3xASHbo8QbhbhxjuwThNf9PVoK6smbwoA9HWoj2R3
         W8n/70uW168dpcyh4P/FH37e2BSiAC4ja0bfgXbCunwQBBtvk6tBFVVk2y4/ElIrfOdT
         VJSsV6AoD+IJgQtidKXg7S4H3dUf+4kU0SMcDt9yMEkILBEL3O0+uQ88iv7uC9pqOXB8
         rSBROt8fFgVNsICOinmwMM5/0k/mtqTJ4QaBWNWqnPapOJkIU9nrnZ2cV6lRBX9Bxep7
         vgVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bvmAYJ9uVcHWwdsdUVnTxzhHRQGok8mw2i6i7B3HO9M=;
        fh=U1Hrlja4dCRcTDe/zj8wOcwmSf++x/mUsMSaRr9CZJg=;
        b=g9Yd3p7foVR1ftudrltQrVA+vcyEUsWFfHCe09dQuGBAPVxwKvGQQj3Kc+DkbwwK8H
         0ErJfnb2oVp1EBSjxMqhoUIrfq5829AMeMI9EyqTOYAhTJyiXYcgY+SuwDvd6hUqS+d5
         LrRa+rKI1QDX0dSciCW1vsrTNfWqWVhGDmwrFAiG0PeGLaPehlPOjwJY1Juwy3FxDvLh
         Ix/TWzTt9slKMPlzvGlb7vgtIePc5ih4uHKnfUp+X51roNDd1YMUuI2VW9tqNZzl8IHs
         cDg8lG+SdH4Oail/xP6QJpBNaEAE4UWa0wA4wEp4/gAVxWpXA0XrHP/w761NVZgf8vuO
         peHQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791377608; x=1791982408; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bvmAYJ9uVcHWwdsdUVnTxzhHRQGok8mw2i6i7B3HO9M=;
        b=PIxG2N49285eXSYCZn2gLCqbp8bjI59uxYeCx2TPVnB5M0DbL482ZZcECgaviONelM
         eEEhQLo0LzSIvpd40MbL6Jq774G3ddQ5daIuSeyaEpVYvxNWS79+jgzJuP3Yzz7ZRcy0
         gjYMa9CKknD99XA6mq5iOskjJ5jdMtDrd+OffKAvyWhWtX0yetE3KOIPYWs9hHJrqdTm
         QHqUFyxtwgGT1J985bMrIsoyps/R08+1Jv4QJg17QJWFMrwWhc8IN68dGUIKCaQ8MDPy
         47zjW2m1Ftde0iIMMJu2UyOdbFtZF4gza3fBOcFbFJlniC8WsAD9yqO1lDRyTdDqzpdb
         4o3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791377608; x=1791982408;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bvmAYJ9uVcHWwdsdUVnTxzhHRQGok8mw2i6i7B3HO9M=;
        b=jLEBIgqLiP5nH48Qh3jg98/x9QDGzHLyondpwmsCnJgHL2I4Z7N0wuAJGyTC9ziB/p
         70sUyoSLymq3yrP2gEXepo1deswO5FoknAe+0BnqqiluAQpj4NNu+0asCW6Zwy/SX/A9
         8vrZwvOAXdWr/VKCxD50TdXp1i7p3vwcDkBY1AHDKYsK5UTjeSyqxl2tSzyAbzLIaz4P
         am7JRS0I/imf8V5mCt8NQqhj/HcyQJvDbjuaTDOTUAIpVpZy158kpNyPZrRlQcW3Xest
         lSkF2zuelkvcUwLzKXQ27NUXUYG35MG1GW/v5oUPIFRZRHKH9ZLkChfi96hTaXAh9Bx4
         1zzg==
X-Forwarded-Encrypted: i=1; AKwUvByO8NjN+7jxQvJS50JbmJiRq7qyXK+NX2Rxk5nfm0cfHkO8ia6hFSxVQ2rLVL3Q5bVkxuwngwYzVg5g@vger.kernel.org
X-Gm-Message-State: AFuF++mrdZ9cTYKYBD4jVlF/Rfp73XlTGJ424BjuVmzL9AIqmIN5kUaI
	u1Ug+mX29pS5n75Ap8Ba26bru2vNTBaKvlvTxhnXeHZh2cqvuD/ubg6Sq5a7s13ol1w4LzvTomx
	bXbv2CF32uMclFxuNwBhR8p2PF30LdYQ=
X-Gm-Gg: AYBFou08VCSs5jZe7ZioAzeCDBJ/5voQEDtdmDqZx1yT8uGoXq/33DXTDZ5vmgGM/qp
	MDNy10J2lYXmOr9LCAA6ToOBhSqMjdr4XGtY6OYZ+cv503uOYRQQznPJ+4/Pr8qSae/zBBHN9Pt
	yOcv70NwoOROim1Dj8zkMOr7BE2mMH7O+1XjgkX/6yND6yRF7UsGcxHmegjH2ARtWOpxq+29uCL
	Zz491MfWyTw9ZR5Ak6UqrwNzviEZtgi//ul1F5vEa0dCZYuM4fbP/GaJs9XfsPcuYRsuFh1J98w
	0SxWnbGWCsdSSRAP2AgKdekEL6eZWVc0mwsBCHpWrFUfp+L2ZUGRKlQgwAQt/vF78fn1pjxFZTR
	lRH0rxzm4LS2XsWVEcpp5uKHVz0S1bnbCsEH6JhGoAr7T520v2OOGzCr2S4UeG7Jf
X-Received: by 2002:a05:6a21:394b:b0:3de:b0cc:b0ed with SMTP id
 adf61e73a8af0-3e134043d29mr1761808637.18.1791377608192; Wed, 07 Oct 2026
 05:53:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261007095128.1370109-1-benquike@gmail.com>
In-Reply-To: <20261007095128.1370109-1-benquike@gmail.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 7 Oct 2026 08:53:16 -0400
X-Gm-Features: AclHuK_HAnf8AxibDk4DcYXebRklfeO2nu44MIRw5S2vZVI5Uo2hAuf7krbvADw
Message-ID: <CADvbK_dOXrS+3JnqmRyssAJQ0v+WLig-i8Nk-M65Qg51AtskvA@mail.gmail.com>
Subject: Re: [PATCH net v3] sctp: copy zeroed stats to user in
 sctp_getsockopt_pr_streamstatus() when !streamoute
To: Hui Peng <benquike@gmail.com>
Cc: "David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Vlad Yasevich <vyasevich@gmail.com>, 
	Neil Horman <nhorman@tuxdriver.com>, Simon Horman <horms@kernel.org>, linux-sctp@vger.kernel.org, 
	netdev@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 7, 2026 at 5:51=E2=80=AFAM Hui Peng <benquike@gmail.com> wrote:
>
> When an SCTP stream output extension structure (streamoute) has not yet
> been allocated, sctp_getsockopt_pr_streamstatus() sets the local stack
> variables params.sprstat_abandoned_unsent =3D 0 and
> params.sprstat_abandoned_sent =3D 0, but then immediately jumps to 'out:'=
,
> bypassing copy_to_user(). As a result, when an uninitialized user buffer
> is passed to getsockopt(SCTP_PR_STREAM_STATUS), the kernel returns
> success (0) without copying the zeroed stats back to user space, leaving
> uninitialized data in the user buffer.
>
> Refactor the !streamoute check into an if-else chain so that when
> streamoute is NULL, params is zeroed and falls through to copy_to_user(),
> copying the zeroed stats to user space and setting retval =3D 0 once befo=
re
> returning.
>
> Tested in QEMU against Linux 7.3.0-rc3 using an uninitialized
> sctp_prstatus user struct passed to getsockopt(SCTP_PR_STREAM_STATUS) on =
a
> freshly created stream: on the unfixed kernel the user struct contains
> uninitialized stack garbage; whereas with this fix applied, getsockopt()
> copies zeroed stats into user space and returns 0.
>
> Fixes: f952be79cebd ("sctp: introduce struct sctp_stream_out_ext")
> Cc: stable@vger.kernel.org
> Reviewed-by: Xin Long <lucien.xin@gmail.com>
> Assisted-by: LLM
> Signed-off-by: Hui Peng <benquike@gmail.com>
> ---
> Changes in v3:
> - Re-target subject tag from [PATCH net-next v2] to [PATCH net v3].
> - Fix Fixes: tag SHA to f952be79cebd ("sctp: introduce struct sctp_stream=
_out_ext")
>   as suggested by Simon Horman and Xin Long.
>
> Changes in v2:
> - Re-target subject tag to [PATCH net-next v2].
> - Remove redundant retval =3D 0 assignment in !streamoute block and fall
>   through to copy_to_user() as suggested by Paolo Abeni and Xin Long.
>
>  net/sctp/socket.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
>
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index a2235905d2ee..bc5b78ab589a 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -7568,9 +7568,5 @@ static int sctp_getsockopt_pr_streamstatus(struct s=
ock *sk, int len,
>         if (!streamoute) {
>                 params.sprstat_abandoned_unsent =3D 0;
>                 params.sprstat_abandoned_sent =3D 0;
> -               retval =3D 0;
> -               goto out;
> -       } else if (policy =3D=3D SCTP_PR_SCTP_ALL) {
> +       } else if (policy =3D=3D SCTP_PR_SCTP_ALL) {
>                 params.sprstat_abandoned_unsent =3D 0;
>                 params.sprstat_abandoned_sent =3D 0;
> --
> 2.47.3
V2 is already applied by netdev maintainer with the Fixes tag fixed.

We can drop this one now.

Thanks.
