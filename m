Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3B0B4F0559
	for <linux-sctp@vger.kernel.org>; Mon,  5 Oct 2026 17:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791220791; cv=pass; b=KbQ7NUvVwwRTjZ1KSt6qQWCMsJIK8616VY0jpihkKkrzYuBLSrMFiDU7pNWim9IiVTfPVs6byjh7BYgipQiLnHep7ZA6ja24MPHSUE7sry0Lrd2U77DQKb2GEVhYwIcPem1oGNRAcQVZiqe/XLpV4zaT7zFaO11pBcOQKeqjlBw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791220791; c=relaxed/simple;
	bh=Iyy/EbW0PV9CgJFXeNSzqijmw9jKbQl0yvOdKn8dVN8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TOrZ2jBszJMjSy2Z3ghovZuSoyBF/cPIMlgKaFAnwz2Q4+GiL9B6FRH8FlfWXzv2vlCKFvL/YvGj2sGeQAAEG6OsGp4lWYcwxmaVhAVrFP9dL+DTbDyMgKyp3wlsR3n7t7otX87VLWld6Y0Krfl5Dkbw+PDYG6C++o62ZjDCnMw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gE8JLIr7; arc=pass smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gE8JLIr7"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-88bc25fcd0eso1784790b3a.2
        for <linux-sctp@vger.kernel.org>; Mon, 05 Oct 2026 10:19:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791220789; cv=none;
        d=google.com; s=arc-20260327;
        b=GHBKiwA1u20cIK0gN4CPqeFl3/ZyWSUEYtYnFVaL5eo49Sdpziw3clC+W07O/88oOE
         JTBa09I/3RBxSiIRLjAkCS5KhzmbFwkzoWDQCDGyLjItzWcYKSwEGpJk4EwBSl8D0BBi
         I5dFsqZnhHhH011AvJHgQyEEErWLZ3bmeMLkIOgtYfScs1cK3nHrcZfCRkmURV9krObc
         oZpvCzVs5nkfv95hjz0e7GHZsKRB088AWw/iKWyDjZMMtppyL66l7qQfQ8JjNAtUgYwn
         oUlhIhp2h/Lwwe2x/5922mtUrwSLSsjNKIQAX+HyHnK2A7zvwEf5mGcrqpxbK1MO6dXE
         4vWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=kZaUwiZFto6aopJ87je3gAd8sYajiTqXcqFYb3kLz6E=;
        fh=3vsIm7dnXdeOm2qfPirpqpjVMw/990wC64vvb4ExzRs=;
        b=F2S20q1BVSxISQuEA3z7JYNZDK9oDUXAJfitjZbFRN8Mh9PVAOWT/PeAO7n1IFhzRN
         Inm+tMx+2OKnbMlj6kW+Dyv8ihyARBhzInWmmd8vhSDmow8fjQbcQnsK1O6cVmrfhHMb
         /Es8VBdyJ+eMelAuWhAN1Z6TrQ9ZWBwiUn/SbuxzZgjPLwOPadHLI05qEedshjs7P0aG
         Q17fTjFTceWLg0JcHbVo4XUCXOe7l+ZcLMgv0q94l3gX4YY7rTAYx9QcB4xfgBuuTZsU
         lcY9QAga1bqHxYxZeD4AtdhuEnpdhl1oWRk2aXXOblyVpvuUVyZ7fB7u34cxUmB+r25X
         vDtA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791220789; x=1791825589; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kZaUwiZFto6aopJ87je3gAd8sYajiTqXcqFYb3kLz6E=;
        b=gE8JLIr7W6DAIA2P/MDRVo2hmbxwnbtXbOE3gq2W5rAmpUVaJBoVaVt94axWAYNIrw
         x90UBYGBiEorg40G5/vkF3/Ui2+UEFjI5rsIlrBBcPFU/DCVKvLb3lCXf0FjRZbutzA4
         Rnv8+MKrtnkziCBFsmFRkAnq/FrDGrr4d7bxmnuGfATx6pj076+7qVqdw56HcC16t2WB
         I+eNJr3ikBf5QaXFPSxcTjFSKfjeu8ks1VVeut3gYUjnwVFgSUrV0rI18/ifY2rLt/MK
         MrZpuQpB85gJJdBs50UXgW0rOj3j78mzHK5jNGxKDgUDroqFwfN+RLAi+Tg/tb4mtDeU
         oM+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791220789; x=1791825589;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kZaUwiZFto6aopJ87je3gAd8sYajiTqXcqFYb3kLz6E=;
        b=VwrZ5ngfRhi3AFi0f2l5ZVpsiGyf8SlDAu0XMpaYJZXn2uFYgPgRstKohAmDHKZb7y
         SfZLh3je65lCEospdiUO36ZJnzmXrGBq78y0gmOlt36isDKQ9AOTv8uKB2c0v0kPAloS
         kKPijOfu7sl75SfDQ2lcCIGA1qjE9wvN3yarTNDGwGvBsxsbb+uWZ7WACffeOL3lWna1
         dSpkE6401iLup9PxqVXS4lKE/3CXFh8uE0u00HFYRY1+kVrt0awWQAD/p5u4JcrlYvFw
         9VSlKonY9X8Szwxsx7XC1zLJpWxKgHl3HbCXZ159Zt5tFzoBkZ1o0ZJm3bepHnAO7vNd
         nFoA==
X-Forwarded-Encrypted: i=1; AKwUvBxW2+WJNFJr1RhJiZo0KY7oMeNMXA4MxPfdQERbUV91h44zRF8Fjd5gjGCFqF4lfj4WNVXG/mF5LdmT@vger.kernel.org
X-Gm-Message-State: AFuF++ks0G/GwDy60KiGFrzSLsFXZ5gc+ANIZXyQIT2TlKShCD6jgUnX
	+7YnRGgDhzdNaPH7esDLK3EYDQFiKjwPyoQAA59FVUSAqsE1q5tDIxVSuB4xQCL9ePAx1oqUdU3
	tT0egBYVWVv06C2hQvpThen23xzKNeCw=
X-Gm-Gg: AYBFou3ljoAZPPaif1pGUNhEax71hj/SrDHVpJHRdvpWEvb0Su/Y87bCP8qyNit+sxv
	Mxn1ZT/Hq845pRdWzfx/e4mQ+VzNYAL/v/C+59/d3c1x4QUcjYw4K0PEQqcjVWLD8VeMWDVGTbY
	h5bcW0qBiYq6TjnrTEWyW1bvND9hUZYVXVAy3epM9+HLx59t/f+wvK4kDpFuFJWKfjhLQ9ZLdku
	IUMB3BF+lQBtp9mK5vEl8iSNfxXwMXvoAJipvrnR7g+Yzt/+Rr+uTPjaApvrvg85kZtlJqlFfl2
	vSokGRmvXm8wbT9NCP5X03xmcirKgPl+i4YXudw8kv+FTqhA1pbWNCRvQvHcB/+/OKo5Pwn5TqR
	CU+Y1cn9BkE91IJHPDCDaVQIL9IUoMzADwt6j0F07clB1ZOLGVTqi0Yw=
X-Received: by 2002:a05:6a20:394a:b0:3dd:a197:edfb with SMTP id
 adf61e73a8af0-3e0d6cbdc69mr7529764637.74.1791220789033; Mon, 05 Oct 2026
 10:19:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260930044611.204739-1-benquike@gmail.com> <20261005170632.GB83879@horms.kernel.org>
In-Reply-To: <20261005170632.GB83879@horms.kernel.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 5 Oct 2026 13:19:37 -0400
X-Gm-Features: AclHuK-lyDkgT7D3dyZG9byu4tcMRkf70JRI3r14isoIqeQu9dgZ6L1lP-o_t_Y
Message-ID: <CADvbK_eAWQbGs7EUogG3kZDgpX_9bzrR-okU_6cAobcyp_SbtQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2] sctp: copy zeroed stats to user in
 sctp_getsockopt_pr_streamstatus() when !streamoute
To: Simon Horman <horms@kernel.org>
Cc: Hui Peng <benquike@gmail.com>, "David S . Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, linux-sctp@vger.kernel.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 5, 2026 at 1:06=E2=80=AFPM Simon Horman <horms@kernel.org> wrot=
e:
>
> On Wed, Sep 30, 2026 at 04:46:11AM +0000, Hui Peng wrote:
> > When an SCTP stream output extension structure (streamoute) has not yet
> > been allocated, sctp_getsockopt_pr_streamstatus() sets the local stack
> > variables params.sprstat_abandoned_unsent =3D 0 and
> > params.sprstat_abandoned_sent =3D 0, but then immediately jumps to 'out=
:',
> > bypassing copy_to_user(). As a result, when an uninitialized user buffe=
r
> > is passed to getsockopt(SCTP_PR_STREAM_STATUS), the kernel returns
> > success (0) without copying the zeroed stats back to user space, leavin=
g
> > uninitialized data in the user buffer.
> >
> > Refactor the !streamoute check into an if-else chain so that when
> > streamoute is NULL, params is zeroed and falls through to copy_to_user(=
),
> > copying the zeroed stats to user space and setting retval =3D 0 once be=
fore
> > returning.
> >
> > Tested in QEMU against Linux 7.3.0-rc3 using an uninitialized
> > sctp_prstatus user struct passed to getsockopt(SCTP_PR_STREAM_STATUS) o=
n a
> > freshly created stream: on the unfixed kernel the user struct contains
> > uninitialized stack garbage; whereas with this fix applied, getsockopt(=
)
> > copies zeroed stats into user space and returns 0.
> >
> > Fixes: 28b7eab0f910 ("sctp: add SCTP_PR_STREAM_STATUS getsockopt")
>
> The hash cited above does not seem to exist.
> I suggest that the appropriate fixes tag is as you had for v1:
>
> Fixes: 28b7eab0f910 ("sctp: add SCTP_PR_STREAM_STATUS getsockopt")
>
> Also, the patch should probably be targeted at net, again as you had for =
v1.
> I realised that Paolo suggested net-next, without a Fixes tag. But I
> believe the premise of that suggestion was that he felt this was not a bu=
g fix.
> However, Xin responded stating he thought it was, and I expect that carri=
es,
> especially when combined with the updated patch description you have
> supplied in v2.
>
> Please treat the above as FYI at this point.
> I do not expect a repost is required at this time.
>
Thanks Simon,

Yes, the fixes tag should be the one in v1:

Fixes: f952be79cebd ("sctp: introduce struct sctp_stream_out_ext")

> > Cc: stable@vger.kernel.org
> > Reviewed-by: Xin Long <lucien.xin@gmail.com>
> > Assisted-by: LLM
> > Signed-off-by: Hui Peng <benquike@gmail.com>
> > ---
> > Changes in v2:
> > - Re-target subject tag to [PATCH net-next v2].
> > - Remove redundant retval =3D 0 assignment in !streamoute block and fal=
l
> >   through to copy_to_user() as suggested by Paolo Abeni and Xin Long.
>
> ...
