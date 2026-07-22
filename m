Received: from mail-vs1-f53.google.com (mail-vs1-f53.google.com [209.85.217.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B39F64399CE
	for <linux-sctp@vger.kernel.org>; Wed, 22 Jul 2026 18:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.217.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784745103; cv=pass; b=k7Yd1+8wT293CTpNHCX8J5UaPTBk21BvEm3a0gHe39fWH5lqbwOo3PxfOpQJP6UOFcXFkmax2ZYffWx0B/UJ60v+Kw0LMuxObyKtu8oMZFCFX16JwlVg1BlyaD6a0oq3UN5xs9ae/Qg6zyBXQ7SVMmANRrk2JZLIoLRdjBAyOeM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784745103; c=relaxed/simple;
	bh=IA7G2u2vV6NVKEZyHe3wo12TA7/PxKbDJFi3T4dwUg8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=t8tn4NXgKeE0k2XFDeFgLV8CMT7STI89uEYBVgIKS8SUPxayIv25xoykw3ZS15FtHIeHikjGQS7wKgV5VD9162dqU6LK8PmPRNDbbDLE+awPP98ngKBzJV84/MLzc+B5MEugAXZ++ekqQIe/U9TuarBCoUM/Vt/1z/t36JJdIww=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YzUCiH3h; arc=pass smtp.client-ip=209.85.217.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YzUCiH3h"
Received: by mail-vs1-f53.google.com with SMTP id ada2fe7eead31-747355a8565so1625965137.3
        for <linux-sctp@vger.kernel.org>; Wed, 22 Jul 2026 11:31:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784745100; cv=none;
        d=google.com; s=arc-20260327;
        b=DSZI/OSZbRKwNjFxxir0xdirdi9MsPNtY3QXX5d8twB5b5aOjRhNrqysAM2IMm65V0
         L0C2i5rXjTzYxpp5SthQ1nqe4NVDpc4r74SlTowMYQV3yQ7b5AhToX0Z7T7qAz6Ru0OS
         6SEDn+qgk7jBU8JQ7vSuXWwRmWNNriNjg66L6kx3Mbkr3kGeFuTOBfcA2oVPa0183U4G
         H05MXS0cZxuI1/qTScuH4QI3KWWuqYk+ngtTNLsAiZBkJF7nHcq+555apwrxhMz1P0fE
         P7SaVdQxtn/xp8ffIpRxf837abGod24vwuPPdJeP85EWrJPvVXf5CcY1Uzu4JX1Hx2bB
         LCLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=q/hMBR9xdLLcYOtadOuetEIVcftCz2uVEGlsfy4vyWE=;
        fh=1TukY3d8ZQzUhmn4v6gqzR3pL/1D7icF7SR6YshT4oo=;
        b=QvHChFvMOR2fH076r3dL/kOMhQAHp9sCVm6F2Xqsa6hTTdGK1pkqCjnNaDYFlB8+Sb
         lFn4srJa6YATNopxi3vGHpsNdjYSS6TuHqxgUqxv8n1pLLMwPH6E3kKbOMSsxhyHtpDR
         N3+KTXPKZxHj4/MES+eFkWYYae511OGeMmlyB1+c3WJfua0OACEri1dslPOZNrD6+o5X
         Fr2GDZtEvtZR9y/6d/8/vPvRjLy3kS+2AV5qRhfvMgBczqtveMsfnVpH8nzBgJGxu5DA
         9ZoIN45QXYuwDNTSuFsoBs8DZewAw/QEBWHPQa6yFmQ40KoZ5X80N7m1xjSAkRt0h1rV
         mLVg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784745100; x=1785349900; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=q/hMBR9xdLLcYOtadOuetEIVcftCz2uVEGlsfy4vyWE=;
        b=YzUCiH3hSfkRGHFlshF0edqY7kbscGdIzXEJcUIhu6g8guZkPI6/YP5qp574S2CtOM
         QNySgEXtju9t6NOlNYfRaNxliqNv5yRIahQ3PmUQwKu/v/1otn84i9riVVWxQ/O88T2a
         7KtodXS05WbBnwyyEJkDqQrb+4pK3i0asoYw7MCs3Jz/Lf7oj5VRUhyNfx6yd8HLbcDU
         EXtlqXuU64mnPwNpy1WG/snBijS9mv7GGwQii1E580vs/pvgZ+55WZYfEGVDc7s3j+01
         X6iMNeoeeZPv0n6/yyno8pAn1pP93GALEjXabfvNA/R6CuDp9fJWhsX/lT3Uh/8PTLn3
         TrBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784745100; x=1785349900;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=q/hMBR9xdLLcYOtadOuetEIVcftCz2uVEGlsfy4vyWE=;
        b=bryrQLn2HRH7ppdqet8o1EA0L1Wgah2dfnNkBrF9TOMcapey5bBHeTzwZxK6+05p2f
         1fDXHpuq6Jkr80ji96PvY0ga/FaEMIA9IBR4CN+uvwVkhmrT4c/+2UkdI9Wta9xmaXYn
         cpFx2O2mhYpsc/v76sA/zWzhDbrLS4a/7N7joq4l+RqzB2XC4ZFma781ESlyf4T9dKDa
         BLa6EEInGFsN6hxZuZNJ+HyagDQjNg8YtGRM/TdJdxCozPLnyYN80Ai+JKUeNxKytK0z
         k8c+QcQ0PEBkc696vSkzT/K2JKI2JD4Bd7TgwzhYGAD/edWQSTp67okR3OvCuw9+G+V5
         uEpA==
X-Forwarded-Encrypted: i=1; AHgh+RpFSIdqwVTUrTVOlKwDY0bKHFt/3x1VHm+w9BuSnZID8vjOa0i/jI+hG8Vo74OkhXDeiFc0p5PFxuSf@vger.kernel.org
X-Gm-Message-State: AOJu0YxlGd/dOvo7DXxDHpYgMPwQHvXCI4pS+KamTa8EMYDp68Hrw8v5
	olrVjUloLykxkZztLw7g/J5jFKxwWrE2iK/MWTCqQgHfbVrbnVs0+6qGq0I+B0GqEhf8h34tLZ+
	ZEu29g/gM8/eFZSUBLyUkTAmcSBOaUYc=
X-Gm-Gg: AR+sD11nmiGNwd5zV5OTzW6DCCSQ/wFxSay+PISA3WciWH1vfYtDJc/xDdkuUkCvCxt
	TupjCFh/fJOlpuSZYyFSp3Oo1T429bqkoHrA2rxyWK4iLfW8uYCPE2fYjRgajTAfY83+jkkZSY2
	u24x2mHneUF1lZ4Vva0/wYgnXc2quLTVbeF5C4O6uUOUU60Yas+szZESptoMgDpv13PNSiP8qwG
	IUXM+m+DorDCFv+SyE0XWk+yzEjFec6uch3I20saqIuTwsyWpzgrIlJna3t6w38HgcLgoTYuJm9
	OWrNn1LTZfHv/IBCucP0xY7Hf4pfeoGCpzuEaJmfTZg1TzfIWAVO6KX6kM+N
X-Received: by 2002:a05:6102:3f55:b0:745:6721:8c2e with SMTP id
 ada2fe7eead31-74753465622mr8799641137.2.1784745100524; Wed, 22 Jul 2026
 11:31:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260721015532.120157-1-l1138897701@163.com>
In-Reply-To: <20260721015532.120157-1-l1138897701@163.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 22 Jul 2026 14:31:26 -0400
X-Gm-Features: AUfX_mzhvOZLH9_yULd7m7gfTrtt0JvuYGRzvviB9G2wTum39x2hRL_f91lWRpw
Message-ID: <CADvbK_cb8Q=9nv5Z5eR3cf=NLb=5=wSg_HKHrtCtPU_bAN=qvg@mail.gmail.com>
Subject: Re: [PATCH v4 net-next] sctp: auth: break when skb_clone fails for auth_chunk
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
> When processing AUTH + COOKIE-ECHO packets, if skb_clone() fails
> due to memory pressure, chunk->auth_chunk is NULL. The original
> code still sets chunk->auth =3D 1 and continues, leaving the
> COOKIE-ECHO to be processed without a valid auth_chunk for
> deferred verification.
>
> The intent of not setting auth was to drop the chunk earlier,
> but in sctp_endpoint_bh_rcv() asoc is NULL for new connections,
> so sctp_auth_recv_cid() returns 0 and the early check is
> ineffective.
>
> Fix by breaking out of the receive loop when skb_clone() fails,
> dropping the entire packet since the AUTH data needed for
> COOKIE-ECHO verification cannot be preserved.
>
> Fixes: bbd0d59809f9 ("[SCTP]: Implement the receive and verification of A=
UTH chunk")
> Signed-off-by: Qing Luo <luoqing@kylinos.cn>
> ---
>  net/sctp/associola.c   | 2 ++
>  net/sctp/endpointola.c | 2 ++
>  2 files changed, 4 insertions(+)
>
> diff --git a/net/sctp/associola.c b/net/sctp/associola.c
> index 62d3cc155809..7741f982e368 100644
> --- a/net/sctp/associola.c
> +++ b/net/sctp/associola.c
> @@ -999,6 +999,8 @@ static void sctp_assoc_bh_rcv(struct work_struct *wor=
k)
>                         if (next_hdr->type =3D=3D SCTP_CID_COOKIE_ECHO) {
>                                 chunk->auth_chunk =3D skb_clone(chunk->sk=
b,
>                                                               GFP_ATOMIC)=
;
> +                               if (!chunk->auth_chunk)
> +                                       break;
>                                 chunk->auth =3D 1;
>                                 continue;
>                         }
> diff --git a/net/sctp/endpointola.c b/net/sctp/endpointola.c
> index dfb1719275db..9675370a46da 100644
> --- a/net/sctp/endpointola.c
> +++ b/net/sctp/endpointola.c
> @@ -368,6 +368,8 @@ static void sctp_endpoint_bh_rcv(struct work_struct *=
work)
>                         if (next_hdr->type =3D=3D SCTP_CID_COOKIE_ECHO) {
>                                 chunk->auth_chunk =3D skb_clone(chunk->sk=
b,
>                                                                 GFP_ATOMI=
C);
> +                               if (!chunk->auth_chunk)
> +                                       break;
>                                 chunk->auth =3D 1;
>                                 continue;
>                         }
> --
> 2.25.1
>
>

The sashiko suggests adding chunk->pdiscard =3D 1 and continue to avoid
stalling the queue.

                                if (!chunk->auth_chunk) {
                                        chunk->pdiscard =3D 1;
                                        continue;
                                }

Also, as the original issue was already addressed in the other patch,
you should delete the "Fixes:" tag from this patch. This patch is more
like to discard the packet early if the skb_clone() fails.

Thanks.
