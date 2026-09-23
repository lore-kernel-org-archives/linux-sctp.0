Received: from mail-pz2-f40.google.com (mail-pz2-f40.google.com [74.125.228.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDD8B51C05F
	for <linux-sctp@vger.kernel.org>; Wed, 23 Sep 2026 12:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790167796; cv=pass; b=YUvGsDKTUMYvOw6HGCP1suYKXYwBNv6SdRwydianQRT7gGKmosKFWwa2KwOEOb9MODmpnVtFmKhkRxDrWA8B5Mb5+fWdSWu6v+/+vwmY9wkF07NXNvX41NHBUkMc6xz0pX1+tuvODCgswU3NDVlWes7yLK7YxSbPfzLwzAIqNW0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790167796; c=relaxed/simple;
	bh=WczYCDXqUgoVXGvzgCz68aujHcgv00ejLg+b56OK4Wk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nN3NvuHYmNHCgTbFGipfEAzU77r/xMUVWiWd13PjRhPZZ02XpD0V1AqHWmbotfnS1MGCO84LL6OnELZUly4BLatyoDZzQ0LlTn7C8dD+miT4lbfIL3i4CO8HCoP+1JsVl1iFVzEYzRkI2F1IjPk6GU4mZxFsn1tuimpQwH6TjlQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k9yeYGOZ; arc=pass smtp.client-ip=74.125.228.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k9yeYGOZ"
Received: by mail-pz2-f40.google.com with SMTP id 41be03b00d2f7-cc7641d03a5so112199a12.0
        for <linux-sctp@vger.kernel.org>; Wed, 23 Sep 2026 05:49:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790167792; cv=none;
        d=google.com; s=arc-20260327;
        b=VZsHScjOk2EcgTbKXRFrGLwnvWkIlbwM0b4MVZCTP+ja4GDYYNlXH+T6I4CYogkn+d
         tI//vBuVYVPG7TmC8oHhRjj8+Tu1QAg47WI7HQyFfEUvLwNwjCO5shiOo3nt0TJ5S9zH
         mDw3vpZCIfF1oGhuvn3lPq93bOE3FD5ffboptC3AOMdG0XcjwCMlFnxGv3TStHPjhaNC
         82SvyFiTUEYSvqgllakJrDpW2JIYkhDmh5qsKUAqGPa5BXm+hts9mRCCrqtj0/1ZPmza
         GPHxKwulHXuHfMmquh7wdJCoWzvoRY6fYawjI0RoOZjaxmIpov9RpFnYLxXNyb30unin
         Dcqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WczYCDXqUgoVXGvzgCz68aujHcgv00ejLg+b56OK4Wk=;
        fh=1VT126H4t+m3H6zS1ffscCYgCPE1p23kJIwj3snWQ3s=;
        b=NBb3YwfBLCW1Emw6HnMqu2p2uJDaIaj4TmFu40nYH9HdJupdSrHPVaspAAPp0A3EX8
         C4SX08o7OuBdKY/HiGkuxqIItKxiVzEIfJA4SYcQ5dlLhGLojK35/tvJ2d0flYJiV3gC
         1NX2u4Ac3qVmiCs6Pwla5fseI7uwr3xKhCzT32b2mtOjUICa7lptnrRr8LOMVY1tuK4q
         MtvA8W0dyvaXU80ejhGbaRYUTz3CQ5Hfc/Uqq1RsTZ+taXRTurfQBGKDArBfMyI0QsEQ
         698FjPhIQhqJ4RDPDnF/sh5SsjJqQDhXrQi2Fw3y13i8HMb4puBM1qH4tGAL1StmFN9u
         Gy+Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790167792; x=1790772592; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=WczYCDXqUgoVXGvzgCz68aujHcgv00ejLg+b56OK4Wk=;
        b=k9yeYGOZIzqyP+uZIwcnCLW6uVKp7V8XIDsIJ1B4uedji9gIG5G7tecfoHTIwnYaNn
         /VeHneQIHSc8L716N2wtTbgB62wwW/3yeQIAt57zvdiNSNxFXYI+SBpVEyFs7Ayojt9x
         ZPHQOAnUXLuXdak6knyhHEl3FqqoTThqi6K0aIVnMmUej1A2Eh1FSv1r4Zmn2mPbS2ES
         joAPox33Flyv+oOqO3s2U3/UAmubUkLeiIG5MPsAAy9f1OhVxdiGHnJkjk1mKj8pQVbL
         91afOl/gB4A6takK9biJc8rIimf/hMndUnD1KL+608htzbxuGA3kN8HOqOrHwUdsve5K
         X2OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790167792; x=1790772592;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WczYCDXqUgoVXGvzgCz68aujHcgv00ejLg+b56OK4Wk=;
        b=BtpuyY8RVaYpUEvmFxQ+wpiAyseX5g+SbTGfOdT0zO2NUjn5Ul/Zy064cRE/AYPhC3
         mZRbmlHGfUE6LHdihJeumHrxGtd7DvWddj/PtZ0wH4HeX6QBURBlaVfWecE7c/H0WC05
         h6tYQCHluomC76klL62ExWJ7B1gy5JD/3QmhGWbtHGlhu6M4891PmSJtkx1492aymV3c
         6BS7lqYubNMWkBUfveuAd6xmRQwRPmZD1D+5Fo2hOVRKLjRuMTOhrJw3tsHTiVoq4dZZ
         KBQZK/eN/G0JtDkdMGKcn3G19iTFsYgOBwe3sTxfSTJ+ax8TyvBTga/XLAYB3xZwxHS1
         1sCw==
X-Forwarded-Encrypted: i=1; AKwUvBz3Y4ok3VaV0BrQB1YD7EYErA2dSf8K35Am/9yAIxwQjVsxEhYvcxtwX/xZnL9nbius2mcCNZBLz8uo@vger.kernel.org
X-Gm-Message-State: AFuF++n2zn7FEvv3htG1E2vn9iFaGR3nP5EdnriQrqiXzR7Rl4JMIFD1
	d+/sbef1cZlcjKNAQaxZNcX+2iRTjtD3gGNUzTA7zoC3deSM6Di+7LMnh3SugpWFNhvhIH9HpK8
	bCdFvF7Raz0hr94BPEj/8PuLTaqRBFAw=
X-Gm-Gg: AYBFou0JcxgV+5f7TAsYevnv9M9BQivX6anf8RrPp22mMkKnvi1plC+vSe7wYnf1J4Q
	sBo1gCtAerbAOgxyXVB0rdVZ9JmHTwdd26LDJTxtBOjBc8kFzKUi8neuPSK8VUjIUg7eYPLqyLM
	AhmYM0Bdez5moxZ3maOqHXI/5seVUvD8U57g/jxbOXh9z4OdUI+7olF5FP6Nx2rfkPpltfh0u0Q
	cmcWLJQlHckD8FtbbLv85GCTpcKPc4KZwh4vhhWOFdmQw8gWR909lPa82f0FSYINnI5CbRxFK9u
	HUzCKj9RvQsBgbnIaRf1Dn9NbBlMggWRVQVxwTrXtytUQHhNckO+UTFQ3Of694ss4Fbb1mXpuzo
	bt+VYvAEfC3PGO9ns1XBHm6pVMO6DZ/ECnMXEqm+TXwAtfZCyJ2s9iP05HiJKgjNfjvgBC/uYSF
	jC3Q==
X-Received: by 2002:a17:903:1a27:b0:2de:834b:b594 with SMTP id
 d9443c01a7336-2df69e1b831mr20044595ad.74.1790167791713; Wed, 23 Sep 2026
 05:49:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260731120558.558957-1-david.lee@trailofbits.com> <20260923080440.83800-1-juny24602@gmail.com>
In-Reply-To: <20260923080440.83800-1-juny24602@gmail.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 23 Sep 2026 08:49:39 -0400
X-Gm-Features: AclHuK8q-tKfIXpOtBC769X0FlyROJnLC1fznk8CJsvtBkQX8N7_kYK4qoM4O3o
Message-ID: <CADvbK_cYWhx5J2M86hE_PJdoS5-KMuMjO8s40=+Dfhx6bsHkOg@mail.gmail.com>
Subject: Re: [PATCH] sctp: hold shkey across socket migration
To: Jun Yang <juny24602@gmail.com>
Cc: David Lee <david.lee@trailofbits.com>, Kyle Zeng <kylebot@openai.com>, 
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, 
	Dominik Czarnota <dominik.czarnota@trailofbits.com>, "David S . Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 23, 2026 at 4:04=E2=80=AFAM Jun Yang <juny24602@gmail.com> wrot=
e:
>
> Hi David and Xin,
>
> My control-chunk migration fix [1] depends on this patch. Xin asked me
> to wait for it to land so the dependent patch would apply.
>
> Xin, would it be acceptable to send a v3 series carrying this patch as
> 1/2, without code changes, and my fix as 2/2? I would preserve David's
> authorship, fix the tag placement noted in your review, and add my
> sign-off.
Sure, sounds good to me.

Thanks.

>
> David, could you provide the missing Signed-off-by requested in the
> earlier review?
>
> Thanks,
> Jun
>
> [1] https://lore.kernel.org/netdev/20260804113705.45754-1-juny24602@gmail=
.com/
