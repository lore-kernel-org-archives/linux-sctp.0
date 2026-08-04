Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 806653542F6
	for <linux-sctp@vger.kernel.org>; Tue,  4 Aug 2026 22:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785881417; cv=pass; b=fK3jDUDeAucNZ8SVHdEWupTTEJaeQ8GJ8Wl2h+aG9nXfF4OuF6Z5XLCyZhzLxeLXqZQoXxxzK06CKaXwIAcxaCkipNNfD1OPbyAkd5OYJ+ygeaiHNj+wV6lIaA02AjCVgKel69G1VKXiodXLEMAbMK0WW2LJNNclrcm1RWFs5UU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785881417; c=relaxed/simple;
	bh=7X5cSaIboniyv0K9SwBjXLnvxPS6WGXW/hc2d3Q4Zig=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=s6YJkLiw+oj3fYEQ3PZNSvFXT0kALy5SxAJYhEwFM695g8y8/m/WXNvVocgpbaSEy0ZsyvXRHT4/XSAYxXcyHWIjfAwKn3JpJWFPR8ZPuEvFUsS3An52esZZj0WYZZK4ZllgwNqfw6/m6PN2Huv2OrKV+jbAz+RIOxHyidaPfVw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bher2DFi; arc=pass smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bher2DFi"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-8485bd28dd0so349650b3a.2
        for <linux-sctp@vger.kernel.org>; Tue, 04 Aug 2026 15:10:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785881416; cv=none;
        d=google.com; s=arc-20260327;
        b=CS2rSzm8/GzuAaQT+x3pVw57SlFsT2V+cB1BjKnEBqq5c+Wv3xoY1Fzh9Vkblsf0oR
         Tuh6PBqett+lbNfCFZAbt2/OiZA1G0SJgnN10/VND9Gym+5Tf+ybsslw4BeUflpPCg9v
         Z2PIs7yPXcKMgeqKk8kKKz/77yDJSW3T0SmJz677/sMxEl6aTa3s7rgbIWzpR3VLqUS5
         nI3PqKn6mrC0c4qG6ZSx+d4d9oAmDCq8FU3ujSo/wpRSHbdpR/eNOAENL2gXyJMtU59v
         oHD4oRwccgt/lCVQ9q0XNcoXCVkk2+BV8oCTsCSmV2QY89+GOk8NUd5oYkNFN5Jc6qRn
         3bbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=MEsur95lzysG65UeFCPO1I0QCJo39klMfTJllaEhaIw=;
        fh=SLq1nzCV5Tl5oPdYLEVSCCVevRIdDHwXOUiBVxEU+/s=;
        b=E1CP0tjs4hWGWlKs+Xq9P5g80+IMzTy/GaDIUnkUTgE3fHxWhW/fAlFUdB7ZVDXATa
         aP8rKBWRdd4Vxay50gX+v3dcemW15MJxKPgcM4fnQqivisEsWs1vN0wmV/z77VklCKdb
         X/YytsLHuK9VOYUvkrMtFzRApcU+VqMZ80mN9O+AhyeJcAf2UMkeXTrLS3KHcRgccbpJ
         akdp2DlDWGP8obqCgYAqRMOnUVolASlPpV1AlhLEJIrVbwBxiRZgBAzaVhOywY78Aq4K
         SGmeZW9TrtnnSVsdAOOiWQqV+DWfipT2cWiEFj1ZJuP+mLdE35sNQcQugOdMNum5kYP8
         d22Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785881416; x=1786486216; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=MEsur95lzysG65UeFCPO1I0QCJo39klMfTJllaEhaIw=;
        b=bher2DFioxtrGJJ8dFbFICZjcFp/z+BMYay933VbMlU27cnXyebB5JBdGq9W96Efns
         ExJLlWb9CJ91ytfujdPAnrzdQSEHk7Hpc1FwvLS9lZ2yn/qoHMvh2IWh7hflYpJlfW/K
         n0MnlraL94m5ngTdoHgxQy3xj9VO6eQFOV41vVmSGOX9FExOhf3nXvutYe/UVP/ddSSW
         /NogScA9RZjoycWPl/zKgfhQDJoPEZLsjJFqR4x1S781qeDv3zQ62dTuODPjx1EGVIJv
         Yu0qJlZAtUcQfMmuF0Sh4UE9YCYcBRWEiy6iEntnh5rfd1M5PHU7+JTqoE3XQGvymNqK
         O32g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785881416; x=1786486216;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MEsur95lzysG65UeFCPO1I0QCJo39klMfTJllaEhaIw=;
        b=Js3et7eS+HIarrDKYgmqV7blr+qH8iYe3pxJ/vd3nZGiAKJbH/zxakO1ZTiDeGEOeO
         L83U4+OJqNbshQE4RjaNTTRUBY/OA48CLIx+gvCx0nj/TTSEwit2VnutmAqHMwP4NyNH
         v+KnIEx6/1+zY0gbmMnSDTMUOo3moRJ7at4PAM619Qf6UvBUCjfrf68sMYPbaYYKqaq9
         9x+zLk3wzEUO7LD/s0ywz+lS7+XldHefX0mlWI5hC4/opNYn+dSETCQVn2R3OUxn00sq
         lg8isS+azsboxwGRJL4gjaeBG8Ans5uJuXpxoP1aTxGz9yrtchXEOnWthnZCbeUvlfdb
         fo7Q==
X-Forwarded-Encrypted: i=1; AHgh+RpVNMhiG9tarH34xAKXiDIZsPfkdHo3q1RlJFfzNuFDDHm+L7Zckz/LOoFHh4RaksIA5dVYRLC/r3cf@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1Q80Ts3tmquTF31u29QSlHabio1yGpGGuUM+TnWzBaoDA9MiY
	6OE4pI8pnWWHZz/X5zNMdBy1MwgayAH+8PP+FPcZFODev++nmsBSqIKfN9jwd2LUHRXlsmrIa9L
	xm6I4HYQo0JPKkSwLni+FzxcLWfC8ArE=
X-Gm-Gg: AR+sD12TRgW/LbsoBqf3Jqm+D6RTdl7DrUpdXWBNJFV0+6S4Hbd+SmXbuVHbBkvMrug
	wHLOHpmObiQjH7SLvPkYRQ4Ta/NaAf1C4ZdjBqIQrkBfbkgHH9Jho8ug9rC0puCg8C6y2s8pJWh
	Le8U12UV0N3vtZHw4/broyLM6tF5Su7YjoRFgXF6S8t8quaPQmzZ57l0naWK1eUqQ3zQC48e14d
	5HYWvUJInYoQKSr4hC3YwMmznRFhZh+8+M0FjlgWcC9GY2CYoYZba17Gz77arMSK3VfX28aTecR
	oB8pMFzYCgM0TZzPEo3lIooRRdQbYCbTP28j5et9Iyvv5ePz8J5E+IV6KgPOwHCla0Tf3+qKY1L
	0uo+JV2VU1oUtoVIvCYBxuJQbcfsfCIje9nYOdAtgBAc=
X-Received: by 2002:a05:6a00:2c9:b0:848:5ed6:9d27 with SMTP id
 d2e1a72fcca58-84f2e12c9f4mr1932259b3a.36.1785881415967; Tue, 04 Aug 2026
 15:10:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260804084310.818056-1-l1138897701@163.com>
In-Reply-To: <20260804084310.818056-1-l1138897701@163.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 4 Aug 2026 18:10:04 -0400
X-Gm-Features: AUfX_myk3fRliFcAY6f6ydLKWG57MHJVOOKE5vhJtiNaQeP_eu-slQ7PjG3Bu-g
Message-ID: <CADvbK_daHZ4vizDt4fiMT=rTDwhT=AJdKK5qe8v_jaLNAYBqxQ@mail.gmail.com>
Subject: Re: [PATCH net-next] sctp: fix use-after-free in timeout event handling
To: luoqing <l1138897701@163.com>
Cc: marcelo.leitner@gmail.com, davem@davemloft.net, edumazet@google.com, 
	kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, 
	linux-sctp@vger.kernel.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 4, 2026 at 4:44=E2=80=AFAM luoqing <l1138897701@163.com> wrote:
>
> From: Qing Luo <luoqing@kylinos.cn>
>
> sctp_do_sm() in sctp_generate_timeout_event() may process an
> SCTP_CMD_ASSOC_FAILED command, which calls sctp_association_free() and
> drops the last reference, freeing the association and its socket while
> the timer callback is still running. The callback then dereferences the
> freed sk and asoc, a use-after-free.
>
I don't understand how this happened.

If the timer callback is still running, the asoc refcnt must be held until =
the
callback completes, and sctp_association_destroy() is not supposed to
put the refcnt any running timer holds.

Can you share the PoC and the call trace if any?

Thanks.

> Hold an extra reference on the association at the start of the callback
> so both it and its socket stay alive until we are done, and release it
> at out_unlock along with the timer's reference. Also only set sk->sk_err
> while the association is still alive.
>
> Assisted-by: LLM
> Signed-off-by: Qing Luo <luoqing@kylinos.cn>
> ---
>  net/sctp/sm_sideeffect.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
>
> diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
> index 424f10a6fdba..f384c2faf1c4 100644
> --- a/net/sctp/sm_sideeffect.c
> +++ b/net/sctp/sm_sideeffect.c
> @@ -275,6 +275,12 @@ static void sctp_generate_timeout_event(struct sctp_=
association *asoc,
>         int error =3D 0;
>
>         bh_lock_sock(sk);
> +
> +       /* Take an extra ref to keep asoc alive through sctp_do_sm().
> +        * The timer already holds one ref; we'll release both at out_unl=
ock.
> +        */
> +       sctp_association_hold(asoc);
> +
>         if (sock_owned_by_user(sk)) {
>                 pr_debug("%s: sock is busy: timer %d\n", __func__,
>                          timeout_type);
> @@ -296,13 +302,13 @@ static void sctp_generate_timeout_event(struct sctp=
_association *asoc,
>                            SCTP_ST_TIMEOUT(timeout_type),
>                            asoc->state, asoc->ep, asoc,
>                            (void *)timeout_type, GFP_ATOMIC);
> -
> -       if (error)
> +       if (!asoc->base.dead && error)
>                 sk->sk_err =3D -error;
>
>  out_unlock:
>         bh_unlock_sock(sk);
> -       sctp_association_put(asoc);
> +       sctp_association_put(asoc);     /* release timer's ref */
> +       sctp_association_put(asoc);     /* release our extra ref */
>  }
>
>  static void sctp_generate_t1_cookie_event(struct timer_list *t)
> --
> 2.25.1
>
