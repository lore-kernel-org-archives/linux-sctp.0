Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0443E4334D8
	for <linux-sctp@vger.kernel.org>; Wed, 22 Jul 2026 17:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784741847; cv=pass; b=K9I43X5w+0qzJKT+ogZwxNI6eG4ZnsvKIgeAADoJyoWqGPq2A3RRA9Z33tjC9O/vKoKpQY7TFxZp+T/mKyd+jf/E++lCu/wBUzyCcx5rHclDLVjeGbSliRPYA9+QvDahxiQ4y1Hz6cXf7ATa5qU+eWCGL2cmesV6sQUTFuEbhYo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784741847; c=relaxed/simple;
	bh=2YaGvSahkhYvJJeXrg0grDnzuLburS+MPL6TF8eN83Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VJsKuKWul5+yRjthJM0k4+o7QQL8lPtj7VyJX2m4GCdjpvnDib6R4A8ZeGLHYTo7ykRawUOczwqikJF4NJZRV95fj/OUjwVlbBlW+F3rvldWvG9UtqHAiP2cRWVOX+VkWVQozEc6ZLV7JsXzWJlan7gEuYIex+zoG/8/ONFH+uM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mASSLZrP; arc=pass smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mASSLZrP"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-8485b358552so388887b3a.2
        for <linux-sctp@vger.kernel.org>; Wed, 22 Jul 2026 10:37:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784741841; cv=none;
        d=google.com; s=arc-20260327;
        b=aa+7KHlFBr/9gAo6k2tc2BJJfqj52RQmKvaff1jIhOy56VoJez2HsJM0RBvDdsLEDa
         UvbxJpJmyCHmtRAwCX/0vu5S3QnHWXroZQ/INTcqBkgCaqoZTligBS2Jw2ifq5t1qZFs
         mSFXR0gxFAM7VkibubLD1RthB8mJReBsCaMzzag2REAsU4qSzWZaRgjc9ktVCPlWrBRd
         I4j9Mi/jd6AvH6K6lFD7EMAe4mX7GSudKpJfQqmDEvS3Bgjr613rOxSrVfwogETXJbn5
         ks3ONtGhx0ralRq14zLXAXIbtx9aBfKQk/ikmfCHcyzdJLBKiVeuMDNteXCG0hLWGdNg
         5wgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=VEDltuycvPgxPShGpci6HVCtrtN6ph2YwVeiVOOXNSM=;
        fh=EfVCUFvt/UWEScr4t7m3PQ/uXNEbt1R+9aIQQntGZAU=;
        b=es8kMZTPtG+Ku0UUVgurgCZNSjGn2WrjAtK7XpBWCcNDwelrxtsXbwLR5lHWFRMpWu
         YvdtKrZ/Vh8QOc+K7GZfEvB9XdtZ2O5BXk4ajEFnRREaAi+HAdJvgU7NlnZ5tVMwtrdt
         uw5SiwcOwjAcMRY/d/e4kD9IrIHeyFm6gf66Ny2R8E2WQX+MyfAMWDQPhEkApiI2z9mA
         bzsA/sR5rWXEQnZoydlhkiuViBJwey0+mVfxMCN3Yh5YJIb90ZdzKJI6S4HfnnCx1cHS
         OuI+HS4bcJW4Z4bxIFE/YM1yw6Zdr5fHOsYoPzxs5AgkfzSqtobDVRxdjdgIO8C0kG0E
         pq7A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784741841; x=1785346641; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=VEDltuycvPgxPShGpci6HVCtrtN6ph2YwVeiVOOXNSM=;
        b=mASSLZrP1TaMQsEgyD2MId9Z/gJazfT1+/2etRXwYbWDKDrFz2GfiEHqRml+MmgsvY
         THpxA5X6tjF3kToqXM/zQXkKkyWwakup47K8tAys0Wdc+kdG/dcJG5XQV2VzMATcIwvK
         N9te9Kn/3++00HyINdffQLpVFY5MJht5GLOD5qglLD7niJvefBejWgQPwAM0ZOIHoHhK
         NV9+lO0MPLNe7B+qdltLKpNUgFLNwN+gtYDjbTWCISS+NFUqQL3dV0lTNUMLFjoM7iO2
         1nN21d9cwSlI9OCHwUXsDOQOHkK/gENW6ueT7riiJX6Rtsjqjyiup3fNZhOYHCqik1Gf
         G/vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784741841; x=1785346641;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VEDltuycvPgxPShGpci6HVCtrtN6ph2YwVeiVOOXNSM=;
        b=NF0ybbrhL2KUgd/rW70KfSXfez2jCCikYjWnWK6nsRDF9caiJmpmZzCKT6bhyl31o1
         jtIS4B5yRkRWVa2vvPpOzDNegVHmj/Jicpq0loUPJRsa4oubzAwo4bU610leKkF9pTK4
         2O+3jrZZyk9YuOlOIo1RL6kRL/RKWos0RUVmnAvFUGgSecyieWqXFfjSIrED9XUpUS+A
         DXyY0cqfhUDSv8YE3koLDnXGPrgqEkinBRVkOB1EbQeyf0tIc3CIXWYeyxZShOtR2t7/
         Us/ww+pRKV5msYy40KRQPFiKdVRk1gM9/rCEJapD+sLjp/0bcDnXo/OgKODuBi7cABlc
         Ac3A==
X-Forwarded-Encrypted: i=1; AHgh+RplKQRuwfOoUxqAPwCnB/qpQ17tSJ1tSomE9zFi9Z09Y8kzKXlNFYEVLvGrw2glPb+rtbdg7svKj39D@vger.kernel.org
X-Gm-Message-State: AOJu0YyUWpARNDAFC28Kq3SfMUaoFj9KcoM/uZZce58qokdN3+tKv44j
	28vA2qv+Vt9/szLABc6272Clq6z7SnhbrtDHBucpstfp+8eSzIVdeQgLALbWEq6DlCtjlBF6HWw
	/4XCiystjOW68hBMbnL59tnlzzGJ8Hc8=
X-Gm-Gg: AR+sD11ErpcVDvp9Vh76QxLjrBdta4mAwXBt6gextreA1zgaLSvlJbcnv+tffYdXdFu
	rfMUq62MVCix157WL3awJeY+0tmljzPfsOm7+hI9FWDscZ4RUfRz/wouxwkY6QbUCN9V90wFmAi
	FUEI+b5dNmXD4FJ4GQqehR+ibQ0afqaHlPBel4pVHQmeDps19bM4YBgJDGTd0/wNk+GpDhHE4Sg
	EDIP1omm/gcBIg2XfST86EtlItNzt6Bd00cHoNaxQQlaC08nWul60Z9tgcJI/vd8OCA5s70FU9a
	OHuOWa7ACHpGR/BK8Vmoe/CPU12o6f0BR3wC8Xn01liuIQ60BRQ6124MznjuF9+Dt7QIR+U=
X-Received: by 2002:a05:6a00:c348:20b0:84c:5b65:efbc with SMTP id
 d2e1a72fcca58-84c5b65f28fmr10366500b3a.71.1784741841115; Wed, 22 Jul 2026
 10:37:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260721015532.120157-1-l1138897701@163.com> <20260721015532.120157-2-l1138897701@163.com>
In-Reply-To: <20260721015532.120157-2-l1138897701@163.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 22 Jul 2026 13:37:09 -0400
X-Gm-Features: AUfX_myJ7H54zIEiR6KqyF35o03u0MYAnnFdtC3iQwdzI9JYw7vCan8qRWmR7V0
Message-ID: <CADvbK_cP69nhZJShW4_vVf1zsccTW_xQ1bGJnYwbhaLCLLsF6Q@mail.gmail.com>
Subject: Re: [PATCH v4 net] sctp: auth: verify auth requirement when
 auth_chunk is NULL
To: luoqing <l1138897701@163.com>
Cc: marcelo.leitner@gmail.com, davem@davemloft.net, edumazet@google.com, 
	kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, 
	linux-sctp@vger.kernel.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 20, 2026 at 9:56=E2=80=AFPM luoqing <l1138897701@163.com> wrote=
:
>
> From: Qing Luo <luoqing@kylinos.cn>
>
> sctp_auth_chunk_verify() returns true unconditionally when
> chunk->auth_chunk is NULL, silently skipping authentication.
> This is incorrect when:
>
> 1. skb_clone() failed in the BH receive path, leaving auth_chunk
>    NULL. In sctp_endpoint_bh_rcv() asoc is NULL for new
>    connections, so the early sctp_auth_recv_cid() check cannot
>    catch this.
>
> 2. No AUTH chunk precedes COOKIE-ECHO, so skb_clone() is never
>    called and auth_chunk remains NULL.
>
> Fix by checking sctp_auth_recv_cid() when auth_chunk is NULL:
> if authentication is required, return false to drop the chunk;
> otherwise continue normally.
>
> Fixes: bbd0d59809f9 ("[SCTP]: Implement the receive and verification of A=
UTH chunk")
> Signed-off-by: Qing Luo <luoqing@kylinos.cn>
> ---
>  net/sctp/sm_statefuns.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
> index d23d935e128e..89ed618b1de3 100644
> --- a/net/sctp/sm_statefuns.c
> +++ b/net/sctp/sm_statefuns.c
> @@ -642,7 +642,7 @@ static bool sctp_auth_chunk_verify(struct net *net, s=
truct sctp_chunk *chunk,
>         struct sctp_chunk auth;
>
>         if (!chunk->auth_chunk)
> -               return true;
> +               return !sctp_auth_recv_cid(chunk->chunk_hdr->type, asoc);
>
>         /* SCTP-AUTH:  auth_chunk pointer is only set when the cookie-ech=
o
>          * is supposed to be authenticated and we have to do delayed
> --
> 2.25.1
>
Acked-by: Xin Long <lucien.xin@gmail.com>
