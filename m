Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07C79331A48
	for <linux-sctp@vger.kernel.org>; Fri, 17 Jul 2026 15:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784300480; cv=pass; b=elOqnd6EJDe7UDEF7NcFx/Lxs4CdVV3FvJzg01cvKioLmRFS0GTSSZ7NnWtJVA2/JMMH6RYxe92eWHwhc9PPxa/uxYfOqXUF8obMVNmCnv7q5aZqV2wPIJDjXMIBlvB4s3encIqbdRlVIIHUxqPOCCk4AdWSOOA7IJLy34SwmKA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784300480; c=relaxed/simple;
	bh=EkG1bxatn03zKIN7M3Vbx6z4AVQ88IDTFkdJVDxKZ18=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RQnD95dBp9KGn6YrdgxH2ZKQKQBYgRMT22wZ7Z80LsE0Bov5k9irRZvubrpJ9Oa4HxdozGDieIfwRX44nYYY1sV6ma+wfXi/lCM0xXOldUMUIBE8g+kAMgrQl/7ypAs3mIms5OSHPCDdJhpU/W0oFRVgOO4eXc6ich26MG8bU88=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qWjdQyiN; arc=pass smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qWjdQyiN"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-84830c774a0so3783268b3a.1
        for <linux-sctp@vger.kernel.org>; Fri, 17 Jul 2026 08:01:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784300478; cv=none;
        d=google.com; s=arc-20260327;
        b=DUPINDpSmaO1yCwLiVTt4o6OF4YfO/kerD3MEztKQi3yeAjTCIICm7JUiD6rOQltL+
         fA1M28FIKL49csecyqhkwx+wB4ujheQu7Bpph/qef/5nwlj+oRaJjOCcFy7PDfar46yB
         L+5Rl73dsDcKp8t4C9BePGF8HtEYeim9jo7ZSbTqEVbrs8LEyQVoPrBFhoQpsVsAUaGY
         S/tg6gCtHrm7/P2jznzi8ccPcjZeGjL0rOXhL42OIvpONZPmO7A302VcTQLO5ylNn/XV
         cE1mfh55h5RHSIpnpLO1VMtyP0DuO9TU6erb//x4s/EgUy4REC3CE+WksMiYxWKPO+ln
         Vjrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Kn9JGcmwjXESSDo9043jlkisjjlqhE7Oa6B40ZDHtWo=;
        fh=GniTbfwCo9O03NpXsCCi+6P+seOQ6A1g77YOFPqITfQ=;
        b=sgEn7mJg+v7n0d+T1VILf+s8tYKORxGL2gXa22C9pgAnnk0fE4W+sseSc/sByX1yCT
         9lKM8TuN065rckZm4FN6s8D29+qMR7fv9Ne3Vzd7jCi+qUqorc7M1fFMhFw82Njx0sKf
         YJZtYQaGhQPqnlo2y/+1/uK/PT92JNT6cW1rmBSw92DkZP/vkqoPtVpfM02eV2rlW8wN
         1zDk7WCCO3hDsWFs7HUTbZiIwoyMZ16f/7GieQh8mw6CgKey1j3Ozdel+mXGRz4V7Q+r
         flFDFBuyYekLUqEcPm4unFdV6/Wsqb8WBo7D2fjemDVzp2ezUWjXMEfFa/EQ08XSIsHp
         eQAQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784300478; x=1784905278; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Kn9JGcmwjXESSDo9043jlkisjjlqhE7Oa6B40ZDHtWo=;
        b=qWjdQyiNdK9zl4ziC1bcwx14ff9qFSwcB23vT5768NTntx2vYzXsia9sZEQ+KOx7yO
         acgkvVkD7o1Gq+1wxgrdmUtBHSVKjCvc4OWrtXn/k2pmhwSsJtS//ssMaXFEaTSeswrt
         ElmWStj+8VTHrmr6kZKN3MpXOOTyFSyfvU743iepXzLpTvAklCMYYG/QkxqdoKJsrA3q
         YtBZG+L8H3taJIrO169xZK3ZsnOY+xsoyEXVDsGVZKK0gaHfMlKhZg2Md++eVHL0NuPv
         j6OugTbCt/PFMLtp6ucL5cOWlvAEjOm8fQZjZJ1jnOuUqDBY3W7GwaO1X5bWNozihzau
         42Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784300478; x=1784905278;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Kn9JGcmwjXESSDo9043jlkisjjlqhE7Oa6B40ZDHtWo=;
        b=gj7SqDE9Je5s2veDDUQ8MWDqwyThZHAWWWeG88RRhX48HVYjGwCPqKS6GP9u9E3se0
         E7rmWfLuQqcWJ/kTm8y97xsH/D9RpxrMJngkGuA0Nebyl1Aa6FgkcnfGmYKaxcMjdV6G
         jSaAz5cSKO2EkRGHVLdGW5p7nGH4KVGxNbMHgeGFHLhmZWTBkRx++AoKH/5QHKO5roKM
         spGVfIgNsuoBQQvb/1GVh3ZGIzHN+o8kU8GwsiLSfsLV7j7jaTwzFgmu5VeBdGyTnrrv
         vsvzYGEX6Wc/CYwbOpPqbigqu0eIK9E7cmBdBlipjiE9gQtSGe/FsAuXPnNkRpl5LSj6
         8Tdw==
X-Forwarded-Encrypted: i=1; AHgh+RpHeGjtsfdnVt1/V7N7fh+VA6DSTqGA9/Ca1CLChwpfNDUrtRDXS3L8QH889CQQw9gfLtoozHa4BkDx@vger.kernel.org
X-Gm-Message-State: AOJu0Yxh1jRGhpJjEn8LnHjX5f0Pm/h1avYlmmHP8SDWzWxHA6+p6CKB
	T5CyNbUguzsyj3ArrorwHaGs6D3J8jthz17RkttAquAcaZfeeioxCkKLKMID6cO8u/ZC21bUB3M
	4cx1s+fl16Jdj9LLPAf8L/yZh716P/rw=
X-Gm-Gg: AfdE7cmXmFSbVsy0S4rchfY0EI5KIyJEtXR/vHAQtRwHziCg7YwLpSIuxapQ9PQyjsN
	GT+wAwnJIG8VLqXEXuULOp4k75EBbUn3LHCEW+kSjAzQWhsr/aDvPb7yh/2uBa10wqfJWzsM1UC
	i77c+Dn5xD4Cb0EyQtg7EW7XNinHSmnHM/o58LMNvsXaidhvF3d+T9Kw9DFI41N4Am2Ii4A5jLX
	5y2XX1YZjxg7kA4NDHuPcVMQ4yAivFP7f3m0tfPIfXM+JBApH+KGVBuUdA0ckIu1MHJcA6k7eqC
	6tb58CYYBEUclfFqPkX7TByOljE/UATR9tMkg8fQ9CtujQycKNbW8tJuhAovAu0=
X-Received: by 2002:a05:6a00:c96:b0:848:4080:afe8 with SMTP id
 d2e1a72fcca58-84c292736e8mr3337468b3a.22.1784300476797; Fri, 17 Jul 2026
 08:01:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260716100407.1490724-1-l1138897701@163.com> <20260716100407.1490724-2-l1138897701@163.com>
In-Reply-To: <20260716100407.1490724-2-l1138897701@163.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 17 Jul 2026 11:01:03 -0400
X-Gm-Features: AUfX_mwQBr_0uroSgnb1cleNIWGMZc0ijXUtBVwhjK2_z4LEEEFBBUYjA1Elz0c
Message-ID: <CADvbK_fxLnyyx7kuuHr3_Vu9Wp9AenxAZYM7rO5kDwR=eXjd3w@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] net: sctp: auth: Fix safety issue when skb_clone
 fails in auth_chunk handling
To: luoqing <l1138897701@163.com>
Cc: marcelo.leitner@gmail.com, davem@davemloft.net, edumazet@google.com, 
	kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, 
	linux-sctp@vger.kernel.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, luoqing@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 16, 2026 at 6:05=E2=80=AFAM luoqing <l1138897701@163.com> wrote=
:
>
> From: luoqing <luoqing@kylinos.cn>
>
> When processing AUTH + COOKIE-ECHO packets, if skb_clone fails due to
> memory pressure, chunk->auth_chunk is set to NULL but chunk->auth is
> still set to 1. This causes sctp_auth_chunk_verify to skip the AUTH
> validation (since auth_chunk is NULL), allowing unauthenticated
> COOKIE-ECHO packets to be accepted.
>
> Fix this by only setting chunk->auth =3D 1 when skb_clone succeeds.
>
> Fixes: 59d8d4434f429b ("sctp: delay the authentication for the duplicated=
 cookie-echo chunk")
>
> Signed-off-by: luoqing <luoqing@kylinos.cn>
> ---
>  net/sctp/associola.c   | 3 ++-
>  net/sctp/endpointola.c | 3 ++-
>  2 files changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/net/sctp/associola.c b/net/sctp/associola.c
> index 62d3cc155809..e54068305396 100644
> --- a/net/sctp/associola.c
> +++ b/net/sctp/associola.c
> @@ -999,7 +999,8 @@ static void sctp_assoc_bh_rcv(struct work_struct *wor=
k)
>                         if (next_hdr->type =3D=3D SCTP_CID_COOKIE_ECHO) {
>                                 chunk->auth_chunk =3D skb_clone(chunk->sk=
b,
>                                                               GFP_ATOMIC)=
;
> -                               chunk->auth =3D 1;
> +                               if (chunk->auth_chunk)
> +                                       chunk->auth =3D 1;
>                                 continue;
>                         }
>                 }
> diff --git a/net/sctp/endpointola.c b/net/sctp/endpointola.c
> index dfb1719275db..3419748c66bc 100644
> --- a/net/sctp/endpointola.c
> +++ b/net/sctp/endpointola.c
> @@ -368,7 +368,8 @@ static void sctp_endpoint_bh_rcv(struct work_struct *=
work)
>                         if (next_hdr->type =3D=3D SCTP_CID_COOKIE_ECHO) {
>                                 chunk->auth_chunk =3D skb_clone(chunk->sk=
b,
>                                                                 GFP_ATOMI=
C);
> -                               chunk->auth =3D 1;
> +                               if (chunk->auth_chunk)
> +                                       chunk->auth =3D 1;
>                                 continue;
>                         }
>                 }
> --
> 2.25.1
>
The patch does not fully address the issues reported by Sashiko in the
following two cases (I will interpret them below):

1. [sashiko-gemini]:

When skb_clone() fails, chunk->auth_chunk is set to NULL and chunk->auth
remains 0. In this case, the chunk will be dropped/skipped in
sctp_assoc_bh_rcv() by the following check:

        if (sctp_auth_recv_cid(subtype.chunk, asoc) && !chunk->auth)
                continue;

This works as expected because the chunk is skipped. However, in
sctp_endpoint_bh_rcv(), asoc is NULL for new connections, so the above
condition is always false. As a result, the COOKIE-ECHO chunk can still be
processed with chunk->auth_chunk =3D=3D NULL.

2. [sashiko-claude]:

When the association requires authentication for the COOKIE-ECHO chunk, but
the packet does not contain an AUTH chunk, skb_clone() is never called and
chunk->auth_chunk remains NULL. Since the new association is also NULL in
sctp_endpoint_bh_rcv(), the check above cannot catch this case either. The
COOKIE-ECHO chunk will still be processed with chunk->auth_chunk =3D=3D NUL=
L.

A better fix would be:

Add a check in sctp_auth_chunk_verify() at the point where the COOKIE-ECHO
chunk is actually being processed:


        if (!chunk->auth_chunk)
                return !sctp_auth_recv_cid(chunk->chunk_hdr->type, asoc);

This ensures that if chunk->auth_chunk is missing while authentication is
required for the COOKIE-ECHO chunk, the verification fails and the chunk is
dropped. Otherwise, when authentication is not required, processing can
continue normally.

Please give it a try.

Thanks.
