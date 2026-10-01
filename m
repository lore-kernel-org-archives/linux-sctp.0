Received: from mail-pz2-f39.google.com (mail-pz2-f39.google.com [74.125.228.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4EEE35E1A4
	for <linux-sctp@vger.kernel.org>; Thu,  1 Oct 2026 01:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.39
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790818752; cv=pass; b=DFFjdbBYy1tyDIAXtQDzBIActkWglyLnHqcgk58vj6vkt/QcuF2M3aCkibjEpLqziBP31oSq0b5yZCVCO70koq2q6ARdGdiqpFfXokaBakGrMtUxpq3EqWMo+eHxT+8O7xDkdMShQ4pv8B/6He5sFO+uI8Ta8zUtc03RdN2TDGY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790818752; c=relaxed/simple;
	bh=s4uh/gNbpaY1xwR/EMAvi6OUprbAp7HHnPGYKuWDVIY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Y/1g/+Pi2Mo7abJtS4Lmq0wyDpxS32Pp96cRvjuaJheedOgMorPaBP0quPrGPv2SfXrHsHIVd3ojUrkuIlNqFUaLhIC0vDZs/2xOhr4Ercin/AE2o+NCH7bqZx+L2r5/KQjVP9IjA9Ohs98/zs8J0IrKrzjKXjcAjlJ2incU/oU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hBBwJtcL; arc=pass smtp.client-ip=74.125.228.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hBBwJtcL"
Received: by mail-pz2-f39.google.com with SMTP id d2e1a72fcca58-88098dbba5fso1315107b3a.1
        for <linux-sctp@vger.kernel.org>; Wed, 30 Sep 2026 18:39:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790818749; cv=none;
        d=google.com; s=arc-20260327;
        b=OFvZ2xba/sR5t/nb9URp3keal6iUl7mo23uds9JdEG0z6YO7Sa52VZmhM1uYK9GBj8
         qyAYNfeYmcxVhnUnzzSvr96VTOLBShMXahm9dRpBIpwDfD1nnFR9yt/Xh2FjSI+/xYtq
         v1hbEiWUXdWcdeFHouGPCkNGEHMmUgPFSxwUCgKgxRdBwpWo9qYxGwsCqeBZkTd7tZib
         LwguOySWvdY3/xBjCVNPMEySQtM2tXYpnMek7to9Z9lhNhgkDgYeIRmwtubo9lcN1FDN
         PrOhUvEFpDAYWPj0ZwPPAQEUMy819PHFnARlM5br56lfgK/K6qt1U24oWguHXTnkfagm
         bc1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=COtjRv2U/Chi0BEOZyecEHUtcNDqgHXnui5nuMUUDpo=;
        fh=IbytfyoNcWipEPYdX6sgkufd3l1XCzM0nTQwuWr6drA=;
        b=OCa8q8n2ErHTJbkDrS2zfVEWjGtsTWy9FcI1ZGw95K3qTuPrdggH/n+Kn9Y9GC4ua1
         ujYjGAbJVlWlW3oe6MODhsFNRY7b+3f0s7y6P3EhocPkVWu12/GyW8rNKH1Qh1UqhP3C
         3/uGI2CKLnY39bbQVmOZD3u6xHB+mwQ49B1d/0Pzr6/ly542Jy9uVLgwQ14sGPe8xmpp
         H3mv6EW1/E2FV/cLCAEXiO+aDElRLxRm9keJjgoQ+J+RbS2Wr2YdkGr8hRbpWSVTtLqy
         rwcl7jl2oW6retXb48veJbK4uvUUfupNsGIc7rLfRCyDKjhUuUkn7lIBF6atsmP4b0MN
         JGjA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790818749; x=1791423549; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=COtjRv2U/Chi0BEOZyecEHUtcNDqgHXnui5nuMUUDpo=;
        b=hBBwJtcL2v4ct99hNSth1kgHpIu2ZYP25MBUuBMhLhXybX/NbA+mgHX7MbaTu6FwLy
         uhWXERAyMyuBgf0cEiSJTRc8TnRgsIrdef/ABKJ2k/CELEDFHOqPk4nPypjbRs1Uzlsn
         YmVUJLXDwiBe6IbwRnY/DyFMSK3XzqBjZa9Mle5KY+rzc8K925yXDb7XTYnzZI+9btpI
         bT07DeJSPwp1IL2DFlgcB6QnPcAtnOX40kSuVnDxY4u2GprbtMaYFs7/mSDWj1p73Aav
         qWdT9deitLQvi8hL5pHkYvO/qQy2eQR6WCx0Fdx/OLuVt0s5MsWp0vcNF9O/p0GcO3WZ
         BIgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790818749; x=1791423549;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=COtjRv2U/Chi0BEOZyecEHUtcNDqgHXnui5nuMUUDpo=;
        b=gAMdyghBcQm3/45GKp1tszWK3OTYcXRpDNe2aF3jdB6xZTFlvYwFZnnimjmUSLz7Cj
         RiZ1+RSRgkh5u3DCETtGJMk0Ahv+Wq8x/yFpnELuWxquxP/9ZRFgVP509jRr9cuuTZ8v
         LI9T+3Q63VAoY6nPO16PHmPNXWry2M7kVeCaho0Mm8x7gQ8pKsr+mtY9kvTsWTU86qNh
         WEEnEqNf5+AGEvEeuPHUy+ZiHPnBtZxCQes3G+ErOvT2rz2h9Y7uyYBXOG0l01oPXwwG
         ckTozP7D7XAzDKSnNKsmdv6wrtXzn9ePXWDvl8zOFD0PoTF5wUL9QfMo8Qanl0FhoOur
         wBQA==
X-Forwarded-Encrypted: i=1; AKwUvBwAmSgKC7Pa98Ns1OZrzf54K00I/bcUo7uLSArb3yhv0HPWJ3s1GdODzfcUqaJY0TAhMtz1ur3ccb8l@vger.kernel.org
X-Gm-Message-State: AFuF++lSaDjqijUbtvNMFGSYYZ0dXKTcOb6q/sk7hdKvs+3jZekSEqs7
	3lEeW5QSkZhXQhDOCOjg5kDZErdv+CNPrrQqp+tXhvwjRQEftGLg4H0I9TbBdpobckl++rwkw0m
	7tCDysVC1CcTcqHafONn1Om0zrLMMDBk=
X-Gm-Gg: AYBFou3VFYVhCA8b2bLjRc2p96DG7gHXrUUr4idZ9HkdpXAb6u65LmRtxRX4oOQur1Z
	kOmhijfanjbstoGHV6+0qBpa821/B09t6RdK0DFyvGh6As23PxUmj6mkoAcdi5BFBOg2uCovjv0
	TrdoiGeDb38ixW9jez/XTtQOkMR6rLPRrALZwaYSAjcQ5u69aiL9m1XlA9hdxUkxhaeazajYK0h
	QHf+ak6EBBhp3RLfBvQhu52ae9pEbnKn7YMMNwBfty+2d8pNBN8OnFIjaRQWfH1qqCKIo7HTlCp
	I7dA0KWlZD1j5MjyeqH3ATRGBQxoXIpt6syrjwYw0HyAQywpNVyjvt02U19uphA9bJfLS/SMo7/
	Z0eKslom6qhUSQW2BI8Kebu+61QP2zcYqPd5fqKNmZl+ek3Fh34aM
X-Received: by 2002:a05:6a00:8f0a:b0:872:a4fa:381a with SMTP id
 d2e1a72fcca58-887fc19880fmr904286b3a.2.1790818749064; Wed, 30 Sep 2026
 18:39:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260926100359.78731-2-juny24602@gmail.com> <179072681379.434549.16278864761662817865@kernel.org>
In-Reply-To: <179072681379.434549.16278864761662817865@kernel.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 30 Sep 2026 21:38:57 -0400
X-Gm-Features: AclHuK_efZJOdyuA_i8_5CE0jNPJyWD2XYVuhOmF_mYEVX21bU5_QCRlfQWvRK0
Message-ID: <CADvbK_d3uZKMbLTCbMC=S=M6Pmt0n+bt=Pdkq2vh21vzgg0VOw@mail.gmail.com>
Subject: Re: [PATCH net v3 1/2] sctp: hold shkey across socket migration
To: netdev-bot+sashiko@kernel.org
Cc: juny24602@gmail.com, marcelo.leitner@gmail.com, davem@davemloft.net, 
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, 
	linux-sctp@vger.kernel.org, netdev@vger.kernel.org, david.lee@trailofbits.com, 
	kylebot@openai.com, junvyyang@tencent.com, stable@kernel.org, 
	corvus@tencent.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 29, 2026 at 8:06=E2=80=AFPM <netdev-bot+sashiko@kernel.org> wro=
te:
>
> Thank you for your contribution! Sashiko AI review found more severe
> issue(s) in other patches of this series. This mail is only an FYI, in ca=
se
> you want to address the nit picks below when you respin.
>
> Low priority / nit picks for your consideration:
>
> - [Low] The commit author, David Lee <david.lee@trailofbits.com>, has no
>   Signed-off-by line.
>
> --
>
> sctp: hold shkey across socket migration
>
> sctp_sock_migrate() orphans queued tx chunks before moving the associatio=
n
> to the new socket. skb_orphan() calls sctp_wfree(), which can drop the la=
st
> reference on chunk->shkey before sctp_set_owner_w() uses it again. This
> patch takes a temporary shkey reference in sctp_clear_owner_w() and drops
> it in a new sctp_set_owner_w_migrate() helper, after the new owner has
> taken its own reference.
>
> > Fixes: 1b1e0bc99474 ("sctp: add refcnt support for sh_key")
> > Assisted-by: Codex:gpt-5.6-sol gpt-5.5-cyber
> > Signed-off-by: Kyle Zeng <kylebot@openai.com>
> > Acked-by: Xin Long <lucien.xin@gmail.com>
>
> [Severity: Low]
> This isn't a bug, but is there a Signed-off-by missing for the patch
> author?
>
> The Author: line is David Lee <david.lee@trailofbits.com>. The only
> Signed-off-by is from Kyle Zeng <kylebot@openai.com>, and there is no
> Co-developed-by tag.
>
> The original submission for this patch seems to have come from
> david.lee@trailofbits.com. That means the submitter has not signed off
> either.
>
> Documentation/process/submitting-patches.rst requires a DCO sign-off
> from the author. checkpatch.pl reports this case as "Missing
> Signed-off-by: line by nominal patch author".
>
> Which of these is the intended attribution?
>
>   - Kyle Zeng is the author. The patch would then need a From: Kyle Zeng
>     line and a sign-off from the submitter.
>
>   - David Lee is the author. He would then need to add his own
>     Signed-off-by, plus a Co-developed-by for Kyle Zeng if he co-wrote
>     the patch.
>
> The next patch in the series, "sctp: re-point retained control chunks
> on association migration", has the same trailers.
>
Please add Signed-off-by for the author as well:

Signed-off-by: David Lee <david.lee@trailofbits.com>

Thanks.
