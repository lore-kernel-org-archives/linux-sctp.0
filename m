Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01D32369D42
	for <linux-sctp@vger.kernel.org>; Tue, 18 Aug 2026 15:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787066087; cv=pass; b=RwY/n8wguh6z0DWz1nIsAsIUSLl+2UomAmJ8fIiB9B8+jYzKnYV9jIn/I5Mvj0PW1UU1rW0ssx2lUDA0gTP8tPx3qdKnty7yy2PbBTJIRg2LTl9MTDxODgITqf8dR0irGuut032bKdwohwza2TG7N5Bz7WjmgK/egLeTdGvjHhc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787066087; c=relaxed/simple;
	bh=fzWmwlWZP2PVM6eD7JNnl5BuebE2tTQXh7/8k3rwCVg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FIWGvAPopRUKIHg0IOp/1Pys1NVeTV8A6BQVN21grqmlivkL6ysEjslcg+zFhWoxb88GOxLZVabKXMgZGgKetoW/WOqFb3b4ZGh9UfFq/HqzgNFScN1gYangKStmsTfkvVa5yRErotrbSHYhZBwmAJUbLhzxrIvW6Cuvunpu4Ws=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BUpah2x+; arc=pass smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BUpah2x+"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-84eb992a881so32055b3a.2
        for <linux-sctp@vger.kernel.org>; Tue, 18 Aug 2026 08:14:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787066085; cv=none;
        d=google.com; s=arc-20260327;
        b=O5A8WtNyBWACw1A3E2Kv6HwVYGaeKYfQm7fJYrpMFAq8yr1/J3qB8cccChpv2HSEbH
         F/zVKHt8ODo/sYcO4bjv/qAfJYpu1Mz9u83WpVdRKpOLcvFysAStnsm6xlBrekauaYpP
         AV73ieqyDpYOJEGZAn4zZ2NhRvpNcPmJcK6ShQbOIK/x/Adqc4KSkaX2V6KAi7nlRBoa
         Ot05N2fUCKpmX1wIfuxNIRScflNB041dqGj63NTPelO/8Cj5pO6BnhjvWHjkUyuqGj7c
         xocvLIPPVclA5FjIP8pS0K3PV89IhnXa0YSY+VRkusu97vNeUGo8Hf8dPcEnRbRbWoP+
         xVOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=g8CQGd14/uVzcR48IxI6d4ODH2UhxlQ1SK9RbG2HEl4=;
        fh=NbyHbwmROb920k7OU4sURJNiwuO5l3fQ4GPdmfhJlgk=;
        b=cQ9S/4xG7o0jYd+6zWYhkU9dL0bfSqIp6zE9TQK1I6EV0S7tOOpqwygH9OIrQnO0U2
         pfUacroOkPnlD89RA89dYdFI+3rcG44WsXNh0y/NHtWNCi+GQvwkNttaI9VHe4G3q7Px
         Cb5bVHmdLXpl7Ble5/SLuIMlwB2TJeGDZ9gMlXyg2drOEK8mAzl+N9d/RZZCdst+Cwyq
         pUjo8KeI3+8qTaQ6muXtMnRC9k56Zf/VfMSb3yJ9VHdLh/o8Z6ln/yYSsfwR01VKKQQ2
         SRZ9d1lgag9Mw4EcOdT2NIPz7ye/6GsTcB3ZxWuRjuw/GIxJ2DzwBPwLkbNTvU5F9J3D
         gLmg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787066085; x=1787670885; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=g8CQGd14/uVzcR48IxI6d4ODH2UhxlQ1SK9RbG2HEl4=;
        b=BUpah2x+E7j2/artNPPXvQomBuLmnPrEfJ5u7wTNDoiuQe0xbPD9Yd9jQngctTUgRD
         7IlNWmPEQxI9KsCJ4LgNhS6TDGoGLFqzjGjsPCdFfBHCNOOni3FgUTkj+NQfVHg0v7wn
         VVGXgEeo5VMHlXof/VC9JPUWhyffjWDj0h0qugj8R4CXtiFzwcAvPRVge9siw70CCT3R
         W912Nrx73CnagR5yq7WI5C1wlTDJC38WDEqvd20UHoTVu2H39Kunj4ujXGFoh0d7L/ho
         l9+vT3kmigVGZr+A/NehjOo5AiXMfBN0Ok8j1tT8TLXsME2H+WLEBE55q0TI0EY2jLHL
         P00A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787066085; x=1787670885;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=g8CQGd14/uVzcR48IxI6d4ODH2UhxlQ1SK9RbG2HEl4=;
        b=OiYRlRLrU0/WKFPLAtxXPf/xYqmRVZyg0D+EV6heS+17kd7T9bz+qI8tYDB/vvJilv
         xWjdPqQnUd852btCCsaQCZxapALOxHCok43JbOmY/5ryYFFvjG+X38nK8z9+Cm/+S0mK
         lMIYgIgpTzlRqYf+Vis+zYHKgsLUfhBqrrlwZvqMMY4auuzJxW2BaR+dWsoBnCv1TmOH
         x9CFlKSYF+U1+S2jzAMmtqq2clL1IWSBqKDECvztHxGW2h05ICc72R9ihcR1hh3IGs0z
         ZCWXap6yilj5xwR/uhEQJZGTgwZiNsfbydXhYlETBx8t68LP3ZvSwgnKfbzw9ea6r/Rh
         r4bQ==
X-Forwarded-Encrypted: i=1; AHgh+RpzhwwOf8xMM9VPZc0HKBQ+XIaQ3QujPIoWqSPOxbR33WgOiKF3IcUFgCKhsRvj+09LQ+yy/sIXnXM0@vger.kernel.org
X-Gm-Message-State: AOJu0YzUOb8hYZpWMZyVTd3sfE4BledjOvayvDrcb4ETY6CABr5gKfg3
	gbpT48JHM0WJZCco9yDEREL0ST8wiDjEoiLATdt3Wsfc1CzVWOUuMUX7yWyPh7PRXBip1NSXZKZ
	zASPvjjonpOgSnen/QF+0dADYHM5ITsaQKWvj
X-Gm-Gg: AR+sD10et8h2d5LMs2QxGb4qqtdbTATmFr62od6PS1EMdwod1KUxNdKNpD8KbUZIagP
	kbcy6ybZK0pKr/gkZXavugzPWEWrpQAX+N8xIMo/jg1uVfM8weAaO3POCwpPLzMK6JK9gOW9FMC
	f9/2jbCofaSqCPcrtct+2OvDVZKwTffGQbhYm026jwAI85SnoNJ/J2TV3zHKiXneM3EMTON/Ph7
	EXNLoS9YhizTuz9c8Vr6k2J3OwcUqwQNUNjndlshy2n1Mmh8pIEz5Biq3t/IqfnaRrUzcxJEPpl
	uSAQj2D3/kmBXCwpNE/8N9P7ifUmpqf7gm4mq4fhW9CloiuItnCLS+tAdeaKxfERhShuXsiOZdX
	QXXRAF76OHB1232J5ApCFoviFuSrEPFC/x4di79oR1vxN
X-Received: by 2002:a05:6a00:1256:b0:845:e04b:565f with SMTP id
 d2e1a72fcca58-84fde122876mr33849721b3a.14.1787066085377; Tue, 18 Aug 2026
 08:14:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260818092252.782855-1-l1138897701@163.com>
In-Reply-To: <20260818092252.782855-1-l1138897701@163.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 18 Aug 2026 11:14:33 -0400
X-Gm-Features: AcwNN1VwdHJ0DcWiEJyRpRj61huJxMlZDpbYKZHijg-0CDJ-ZtBMTNBx5jsCLjo
Message-ID: <CADvbK_dRmpABM=DA6B1MxZLDf7pcqD0f_mWios+ecJnCBOqqNA@mail.gmail.com>
Subject: Re: [PATCH net] sctp: fix possible out-of-bounds read in SCTP_PARAM_SUPPORTED_ADDRESS_TYPES
To: luoqing <l1138897701@163.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 18, 2026 at 5:23=E2=80=AFAM luoqing <l1138897701@163.com> wrote=
:
>
> From: Qing Luo <luoqing@kylinos.cn>
>
> While processing SCTP_PARAM_SUPPORTED_ADDRESS_TYPES in
> sctp_process_param(), the length field is subtracted from
> sizeof(struct sctp_paramhdr) and stored in a __u16 variable. If the
> length is less than sizeof(struct sctp_paramhdr) (4 bytes), the unsigned
> subtraction underflows, resulting in a value near 0xFFFF. The subsequent
> for() loop then iterates far beyond the parameter boundaries, causing an
> out-of-bounds read.
>
> sctp_verify_param() performs no length validation for this parameter
> type, so a malformed parameter with insufficient length can reach
> sctp_process_param() through the INIT/INIT-ACK/COOKIE-ECHO processing
> path.
>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Cc: stable@vger.kernel.org
> Signed-off-by: Qing Luo <luoqing@kylinos.cn>
> ---
>  net/sctp/sm_make_chunk.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
>
> diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
> index 236e25abc7a4..ebf791969454 100644
> --- a/net/sctp/sm_make_chunk.c
> +++ b/net/sctp/sm_make_chunk.c
> @@ -2169,12 +2169,19 @@ static enum sctp_ierror sctp_verify_param(struct =
net *net,
>         case SCTP_PARAM_IPV4_ADDRESS:
>         case SCTP_PARAM_IPV6_ADDRESS:
>         case SCTP_PARAM_COOKIE_PRESERVATIVE:
> -       case SCTP_PARAM_SUPPORTED_ADDRESS_TYPES:
>         case SCTP_PARAM_STATE_COOKIE:
>         case SCTP_PARAM_HEARTBEAT_INFO:
>         case SCTP_PARAM_UNRECOGNIZED_PARAMETERS:
>         case SCTP_PARAM_ECN_CAPABLE:
>                 break;
> +
> +       case SCTP_PARAM_SUPPORTED_ADDRESS_TYPES:
> +               if (ntohs(param.p->length) < sizeof(struct sctp_paramhdr)=
) {
> +                       sctp_process_inv_paramlength(asoc, param.p,
> +                                                    chunk, err_chunk);
> +                       retval =3D SCTP_IERROR_ABORT;
> +               }
> +               break;
>         case SCTP_PARAM_ADAPTATION_LAYER_IND:
>                 if (ntohs(param.p->length) !=3D sizeof(*param.aind)) {
>                         sctp_process_inv_paramlength(asoc, param.p,
> @@ -2600,6 +2607,9 @@ static int sctp_process_param(struct sctp_associati=
on *asoc,
>                         asoc->peer.ipv4_address =3D 1;
>
>                 /* Cycle through address types; avoid divide by 0. */
> +               if (ntohs(param.p->length) < sizeof(struct sctp_paramhdr)=
)
> +                       break;
> +
>                 sat =3D ntohs(param.p->length) - sizeof(struct sctp_param=
hdr);
>                 if (sat)
>                         sat /=3D sizeof(__u16);
> --
> 2.25.1
>
This is not necessary. Please check sctp_walk_params(),
and I think it's already validated this for all params:

  ntohs(pos.p->length) >=3D sizeof(struct sctp_paramhdr)

Thanks.
