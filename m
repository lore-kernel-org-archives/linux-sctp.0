Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 055503B6C1D
	for <linux-sctp@vger.kernel.org>; Tue, 21 Jul 2026 22:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671970; cv=pass; b=OO1EnGRUfz9icBg9xVYlR5HWe2vUlJXl6YepK8y8Q/0HEKWQLKKX5UlHtfdWogS700J1SZtvSZ5DotnEkCVVWqddv0+rMGdxd+h4e+pSfIDN/hbMVLydu70X9GzeqYkKzB8iKe6Sw6vNYhqSIZ6Bbaai8x4pMu7yND8ohcNEimc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671970; c=relaxed/simple;
	bh=H+7LkQADNzB0cXhx5A1s857U7lWmk87SJ7hEPe8oOa8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AsJUi917KYY13/RNL8/66i/3dx4KBXnYqllidINF08fqrCf5QVIl9jmwBxhwGDNIU+dBNwlM0sne7V6jubp7IXyUf0XNWqIefzrpeLvdF0QulxiFZ9AneL4s57lgi3kWYx7Z1mOGkIkQSfzKcbMXyoPf/GVBA95cD8PPn8KR1cI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N++S9/fg; arc=pass smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N++S9/fg"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-8487b7b3fc8so12032283b3a.3
        for <linux-sctp@vger.kernel.org>; Tue, 21 Jul 2026 15:12:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784671968; cv=none;
        d=google.com; s=arc-20260327;
        b=nQ17zQHR6KvfYY8o/HE4MtRX7NYv15FK1l6c57YWt8MY/JJmjZiFOKyqlwglZGPbGk
         qRZ/xjzV4a2pCZ+o7X8dKKTOTnKoK2K7vG+CVOdCUmyQAKFWn9xtpHci2kfp49xzsWq5
         lNVThaHXTJ9ZNinXwZw49O62s8kZAYOsMHVJhj01og7kvbetTlKx7x7QNHB0yNB+xy6i
         VW+/MI6+hDikNZyjGAZGqwQVz/m7ODK2PCJzItYB42Lt5p29LP5tOx0pj4+eBpMmV//+
         K9JDFiWiDGcvqBEaLeksxGhx6low8Vc8Fof0zkKQ9mp+QT/GNecLL4xBaNHSyD+kStlD
         NIqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=gYVMxuiA54aa9lgQfdByJFmIx0IDKL8nOBFRc8WiSV0=;
        fh=c0uqpbZVGqQY64icC9zAotghlhmT1RWpTfNgXkH5sN0=;
        b=ZqmP94Y+uN1onKdC8LuLNIhOaEodx09JZDwyVAIDPne+P9ek2SEhJfROZsi1eA8/0g
         9yJvufDCRKhx8ji+0eTkXZenyyC7yHvyXOpuhteq1MfXpPE/UrdqHsrWgdRTNJu6sJwO
         2eAXqb2Us8pKpIFO7OL87VYu7xKgEbCy2Hlb0hTtT8Cx7AC3iTa6EbFqcmfm3jxpbfZW
         LgshhwS6hBdqqJuopv1xbrtOWm+X/N8qJXu3IoNZvMnTrK+ibDFo/1rsSaz4CSIerg81
         YEUOtmlMTy+hwsXtjwM4f3T6OmvG5o9NdKJlDF8ZDnaSDTswUOhQ0zUk7Fo7yeVIIFXr
         +CaA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784671968; x=1785276768; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gYVMxuiA54aa9lgQfdByJFmIx0IDKL8nOBFRc8WiSV0=;
        b=N++S9/fg5hEplY19R75HSK4MngF29BldSXMpeoVeIJnuy/ZcgDizosnRlTjrMJ37Lw
         YqcnUmr0FwOaoGRnd7WqaQ0MESZ3xic/xl9VNWKCZuuneGl1pMNsmItXM2JpGu/UejbY
         fF4N6nG696Vfy2y9QnjwzAO9CjPwRjEBaQzs+pDSw5YRDN9x3gZormwkNjT4mObKnRY5
         E5WffiDLRH5sFr9YO5kq2rRuQPew3kVcMBOSU5xVVWIS2q/jFJfgGgNwPwbHgBzajyQQ
         QWPzzppQtriFW93ZqksYR/9srEL9K7N49kbkvcfDkp6org4XWeMdtpzILXXJFfNU9g58
         Vn3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784671968; x=1785276768;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gYVMxuiA54aa9lgQfdByJFmIx0IDKL8nOBFRc8WiSV0=;
        b=L+5Y94HLx2AqICLS36BxgG8Lp+dMyqxIF4+Gjzwl0h3qR4ZZHrNwwfyIDSdmzbGieU
         NhqbsohwsW800nxJpcimTJ0J31TYOBiL0PJywCVtvW2BZxjWmfZDF46urExSuD2gDiPY
         UD9BK7gxo7JmGHzpNQFd0jUPlvmCTrPrInrTL/1jfnLjBzx9soku+hqQaftBmPMvXiXX
         ccI0wVz01/3mFUrxGFup9TNVh+CZKD6Uo1Fs4/6pSvodsnCdja17ulK6SJzjrl/i7VC/
         N0/Kf0pz3HjAWqrZGfBpJPCW8yz2NNZwRViHMPCg5oVpk91NLTYvtDq+4gW7QFkXCEvm
         tSdA==
X-Forwarded-Encrypted: i=1; AHgh+Ro3t8MRT1fP9xM1/U2nd1pUFN1VxRWy7+bLhxcZG17l0I8cSAyxDdAbwNzh95CQwyhqu0mPn/hVJprH@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/G9YSLCTi8YHGPhxBWJSONhvAL74/kumQ5CgaIJ+PT9LRzv4o
	ALBHuW46s0v9OiIynQymyqg0Ntg8EjVf9b8uXyHjtnLTBbm+44u2MVhSZv7IBzs7LvyYgPIob2A
	C+gvZaEkVLejvXHScZjI0Wr8J1v7PxVA=
X-Gm-Gg: AR+sD10WzrI30PpeH/gvWM4rF5bvl5OIAV1fxuhGKKmP50Zb+V+fMb9QJCuTR1TyZQG
	2jw2OY4OalH3o2Oyg+g4EPYR8pHjcW9MOXibhGXbEWG7zFOSCJFPW/qMHSKaPqTlaqZwD73hRl4
	Y9HM5V2BwEeV9k6b1S7GP3CjG1528BCfRq2je6Z1GVL03GWqYjLuZ0jymJnJK9I57UWwS4QD+qa
	Q7OdMjDSQ/ZB6G7TuuGkrQTfjuNvBhejsKgAAQ30LlSVdz5+HOGpdOXNg4UXqq1CQoEK/FPpCuA
	NmuI4+SKHWTvHGR9Da7dAsH6RCRs7qn1GqEPaUtUAyh5Pp2Koo99vUv7cF1/vkLJoHwZXlo4aGr
	h3sq8PZIIJ/wFl/uiCg==
X-Received: by 2002:a05:6a00:2445:b0:848:2f73:8ff6 with SMTP id
 d2e1a72fcca58-84c29519487mr19079987b3a.63.1784671968180; Tue, 21 Jul 2026
 15:12:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <5dc95f295bdb5c3f60e880dd9aa5112dc5c071cc.1783707823.git.lucien.xin@gmail.com>
 <20260721140227.538ce6b3@kernel.org>
In-Reply-To: <20260721140227.538ce6b3@kernel.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 21 Jul 2026 18:12:35 -0400
X-Gm-Features: AUfX_myY_Kiu7B2PbI3W-OCNeoqmK7UY5NNLOlIFHZufRuD7emAW2GZPYOFX_bo
Message-ID: <CADvbK_dRySbf_iC2qUt9a6A8sMHpFcwtrCtKyJzKY_wnZg8PVA@mail.gmail.com>
Subject: Re: [PATCH net] sctp: fix addr_wq_timer race in sctp_free_addr_wq()
To: Jakub Kicinski <kuba@kernel.org>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem@davemloft.net, 
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 21, 2026 at 5:02=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> wr=
ote:
>
> On Fri, 10 Jul 2026 14:23:43 -0400 Xin Long wrote:
> > sctp_free_addr_wq() previously removed addr_wq_timer using timer_delete=
()
> > while holding addr_wq_lock. However, timer_delete() does not guarantee =
that
> > a currently running timer handler has completed.
> >
> > This allows a race with sctp_addr_wq_timeout_handler(), where the handl=
er
> > may still run after addr_waitq has been freed, acquire addr_wq_lock, an=
d
> > access freed memory, leading to a use-after-free.
> >
> > Fix this by calling timer_shutdown_sync() before taking addr_wq_lock.  =
This
> > guarantees that any in-flight timer handler has finished and prevents t=
he
> > timer from being re-armed during teardown, making subsequent cleanup sa=
fe.
>
> This version did not apply when it was posted (IDK if it applies now)
> Please rebase and repost if it's still needed?
You already applied this one:

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=
=3D976c19de0f22a857ba0112f39635f8fd7a257568

I think I accidently posted this one twice, sorry for the confusion.

We can drop this dup one.

Thanks.
