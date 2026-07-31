Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 347A843C045
	for <linux-sctp@vger.kernel.org>; Fri, 31 Jul 2026 15:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785511645; cv=pass; b=aViHNS4iIQas9h8FgAmRWXF/3tZmPO1hO4DvO9miQdZnS/wgMbsBcm+qcLeac9kz3hoKFuXtwwaRQjNmYe2DUHfWuZECG+yxp6oq7KhxARs2KlidYxn1RlQZQjdsjPfJYtIipJbR1noRHARtf2nk7im3LbEGEHyRX3EN6DvMtN8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785511645; c=relaxed/simple;
	bh=O3BQ3jZ6tOaEQn6y3cDLly/xE1BrIxn+Q4iMGzfBJeU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ltNljSFN2la7G3GzvPGpNjAq3TRJMlnGTsMkdMtF39R+WTg/AgmLRhCTMg7Eo4sb5SklOsRvUJq9mtMk5xwd57dD5FH/bSxAAAblDI33+1iohbcOZdT0AVwvQ9t5ttlCj2MMYuNkpRXOxgv9FnStRQTnvr8liE2lZd1tYrQA2js=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lvzMsdOZ; arc=pass smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lvzMsdOZ"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-8487b7b3fc8so1369632b3a.3
        for <linux-sctp@vger.kernel.org>; Fri, 31 Jul 2026 08:27:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785511643; cv=none;
        d=google.com; s=arc-20260327;
        b=o6kiIMtn9mg/kya+38h5Ji6LygDMbfE4HeknN/wHN7fmhjGhV0eH1DekYS4oYIW8UE
         e/9bf5GLVG8KpxGrJ/EOSCPrbZLBkQ+QYIvOW3ttv7qiRRvc0M7/zoxOLlx0Mu7EkTZz
         v8qfS8sA74gfapqW8KD/vSozNF6Gy9trf8wvM3tSFumZSZRcrwQT1LiqcQWqtH6g+l7x
         SWjrMa/Cac+KgsJq/5kXWj8zBa00lq49DgsXfBbjTvDNHm85FB7bRseQuBQ7R1qkbDtF
         yYbX3b0jRS0Wh1oD/6iBMWFf7akgVh7VrySTiKctctF/1kWOoeAew18uXvVVbNyX1gqC
         7t5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Bo32CreubqYXJNbokFXe3UB03tI4c52nlVDOvA0DsHU=;
        fh=XPq1ta1+VdAAfytlNglRN4UASB2Qc+gIHUtlTVXTd2I=;
        b=T9LaUVbn+3lXATC1V+xixcXLoCdBUMixOn9KviXiVvl75WFroWIwc7vvwEv+D4H2w8
         v7+d4BKFeBu8B6pVB2noInPTjII/aNpjNfTjJg3UXGdZKxJ4S7HcRlt1mqx8h02ozqWv
         4SYEJR3VKQ7r2bBCa9ZU5QXMnwz76vsIrG0uvFKaYWMa8GlMJL9LkA+iTaimTdGF5Ncm
         2o+4P0sNZbq4zT+JK29FGxOsdZXFZ/FHud+eyonqLVez0kluJNFPT21cbsSMCnNV3FTb
         kkLSLMdCEH0Hv13UfLFniQBYj2L+bTcO1tMrUQyRMh+733iRsAtVqqpnescxXYAgYsfw
         ZpVg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785511643; x=1786116443; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Bo32CreubqYXJNbokFXe3UB03tI4c52nlVDOvA0DsHU=;
        b=lvzMsdOZeRkpYWhaRqj2A/WKm2J8iYcRsQS3HINMWoO5R013DU8rA6yRaIfzq92XHD
         Pgu6G4VD/Pcl785aoyIJfN5pj7C1uZy7uV83J5wQNSlm4Gf4pf1UyShayhCHlmY8nrH1
         lBUx+cOg6680kCFjT2JBTiCMhfvtfM1uB+T2i72gSblOq1NhrYjBHIpUvJcJduS0GVJh
         wyDBiQba2r5wkLLo3fSQ8Q9ATabI5zBfjOx/6Hm5L/ET0iGLmdnIUhlh8MF9dCCUKH4n
         4BDKaZNm8+iDvtJUyOJdrDGmEgVqsvr4C8MuPHwO7K2SrGUCnXqs0Txv3R5XU6WZZA4I
         VcFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785511643; x=1786116443;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Bo32CreubqYXJNbokFXe3UB03tI4c52nlVDOvA0DsHU=;
        b=X0QL8eQ2e0IjHxiS2q40nbuL2KwSulGXNejZytqp+jwll/Dkd1Ac5ERX2bNE34WLhx
         wRGJaNs7UGHzrCycp8bUyOyeKxSK5e8JT6mGmjDHazXKU9zTWa9YTQxO9Tdke8pf9Us9
         vBJBTB34PqAw/Ix1NzyU0cgTns8THK+p4JRRs1XKkWHoHPNB8/zCmqi5kUvBlij7Qy4m
         Uh5DN9v6aSFCzL4CSd4uG9Pk/dIaHMQnlnVLZgVQqX7i03GSZtWA6YPZMxDfa3EXmras
         SXCg4tktuR3fHmeweA3Ac6NvmsKPAmXKhzThvr5O9GniUKx0lC4IUzFVaf7nB/pb4HmR
         SrPQ==
X-Forwarded-Encrypted: i=1; AHgh+Rp60rcQ8YPFN75rnv7r7/Ljmj5oNZNereNYifoUx7c+4fVIf3UBPDbuCvk97+OYO7wZrpVc6sqjko9s@vger.kernel.org
X-Gm-Message-State: AOJu0YxLJxX1GkZhtQ3mPO6sT3xpr22CJXFatdVPUMOTokqYO0FksOiz
	Eo+G7055fbCPppW+MikNMMWDsiF+BXXfFkzBweFks/B+AwuIcp5dB45ZGJDxNGGx+2WtTUBpu4m
	JxyyeMAVQWgpiP3Hf9S1epWJs4Aq2goU=
X-Gm-Gg: AR+sD133Ccy+I5mFc8tfZcEjRy955digrnV+Ku5NM6CaYe44fRZGXBY68QBgZkUyWTy
	srj+iZ6jHzaQj9J0hd5WTKKErnRTjy139nsrx8SNMvwxPa3qmXfUdezRRMmd6H9zta6zpnVUPHW
	G1MSbSz8yCHc2c6Qp0caGsAkQJgvHJdAMR2IIzCJCnWfklxOBJw4adxmbiHq5KaKgCe5p5WOWZ7
	rmZf/HlSOxGn1fUd0Qpc22TPbQson5XzcdksCRudzNt0vlvmhug/wEfUCeVaqajHtyiM+jyigTj
	iY+Wvb6nKkG5x93hqRHhGCv5Yh8gmCzcT2sO+Gkx9QCGrcPW2ZE9AopLZbqnoDjtuqZfkC/jQsf
	AY8Wa2vq/UuBG4u9asqgb7/Ns3RPLg3qulwnF88ESn0hi
X-Received: by 2002:a05:6a00:1906:b0:845:e501:568f with SMTP id
 d2e1a72fcca58-84ee48a4a4dmr94534b3a.47.1785511643012; Fri, 31 Jul 2026
 08:27:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260730090149.24040-1-juny24602@gmail.com>
In-Reply-To: <20260730090149.24040-1-juny24602@gmail.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 31 Jul 2026 11:27:11 -0400
X-Gm-Features: AUfX_mwSd_0ySL5ztSl5IL_zEeDZrHxteTKNfpt1bcMBfrZSskYYUInT9sXKpv8
Message-ID: <CADvbK_fx=1mQZ4LaSvQj=3jW+=1zCUuAf1xZpiez7Mag4e_GDw@mail.gmail.com>
Subject: Re: [PATCH net] sctp: bound the auth_chunks copy length in SCTP_LOCAL_AUTH_CHUNKS
To: Jun Yang <juny24602@gmail.com>, JEAN Jeremy <jeremy.jean@ssi.gouv.fr>
Cc: netdev@vger.kernel.org, Jun Yang <junvyyang@tencent.com>, stable@kernel.org, 
	TencentOS Corvus AI <corvus@tencent.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Vlad Yasevich <vladislav.yasevich@hp.com>, linux-sctp@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 30, 2026 at 5:02=E2=80=AFAM Jun Yang <juny24602@gmail.com> wrot=
e:
>
> From: Jun Yang <junvyyang@tencent.com>
>
> sctp_getsockopt_local_auth_chunks() copies ntohs(length) -
> sizeof(paramhdr) bytes out of ch->chunks without bounding the count.
> For an association ch is the fixed-size asoc->c.auth_chunks[] array
> (sizeof(struct sctp_paramhdr) + SCTP_AUTH_MAX_CHUNKS bytes), whose length
> field is restored from the received state cookie by sctp_unpack_cookie()
> and is not validated against the array size.  A cookie carrying an
> oversized length makes copy_to_user() read past the array (out-of-bounds
> read).
>
> Bound the chunk count to SCTP_AUTH_MAX_CHUNKS before the copy.  That is
> the most valid chunk bytes either source can hold, so legitimate output
> is unchanged, and it also covers a stored length smaller than the
> parameter header, which would otherwise underflow.
>
> Fixes: 65b07e5d0d09 ("[SCTP]: API updates to suport SCTP-AUTH extensions.=
")
> Cc: stable@kernel.org
> Reported-by: TencentOS Corvus AI <corvus@tencent.com>
> Signed-off-by: Jun Yang <junvyyang@tencent.com>
> ---
>  net/sctp/socket.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index 9a6da4e0d741..3e9dacb772a0 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -7109,6 +7109,12 @@ static int sctp_getsockopt_local_auth_chunks(struc=
t sock *sk, int len,
>                 goto num;
>
>         num_chunks =3D ntohs(ch->param_hdr.length) - sizeof(struct sctp_p=
aramhdr);
> +       /* asoc->c.auth_chunks[] holds at most SCTP_AUTH_MAX_CHUNKS bytes=
 but its
> +        * length is restored from the state cookie and is not bounded he=
re;
> +        * clamp so an oversized length cannot read past the array.
> +        */
> +       if (num_chunks > SCTP_AUTH_MAX_CHUNKS)
> +               num_chunks =3D SCTP_AUTH_MAX_CHUNKS;
>         if (len < sizeof(struct sctp_authchunks) + num_chunks)
>                 return -EINVAL;
>
> --
> 2.55.0
>
The issue requires sysctl net.sctp.cookie_hmac_alg=3Dnone, right?

If so, Jean Jeremy has reported two issues caused by the missing validation
of the auth params in the cookie. We may need to validate all auth_random,
auth_hmacs and auth_chunks in sctp_unpack_cookie().

Let's wait a bit and see if he proceeds with the fix I've suggested.

Thanks.
