Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.180
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792504349;
	b=4niK1DzNdxHZ5yvxZQWnlQekqTf6ahn5FvYg5STtgmh4NBHVYH/NdFTMWzJlXHJf/j94
	 k4VTRkhbJfb1V7hOKh0gsr06c/Sdil4kMQYeQjqW1JibaJAAXEun34jtRxfENDBgIlWJp
	 CWt8Za+z1yUY2iyLEMnxktUzorn9OKyybN6fVZZG7MCnGJOGOkeQxiWyZjsTN1y3VQosH
	 9JUh6Tnk3OF2R6aeArKp4gBSJnFSxQF+SB0QLwjKUphChE0cyvOF2YFxpHBJzWbJOz7h+
	 85BfbzkRmV/QIjHKdDuINWeFSoSUUl4eRDXk/dk95KEaG19pbPnwMwFKA5aQe3UHB+Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792504349;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=k/hbwlcYMnNfV2mBX84KMoYZ1kQ82mEtSuTGwp2XYJ0=;
	b=0eMAJ/zrlzUBePE+qbR8KrITWp/RSKMtvykq69lT2zC+7oqQdVadxpFklGWzZy7b7wFY
	 p3XitExZq6t3lQjgNYbaFRH815WESk8/WV/EUpMHFbrqAtakGreXrP6HM6f3TYdr0Y37s
	 sHVBtDDTNF54UkEJ7Rabbg1TyDxu6d8Qb4dWvI7jw1NG3Ck17R1h/WTYDrp6vpDPTbSsI
	 TRcNeIXoT4woXIMpDR2L2rgMQqHFVj3DGlroTRcRP2HZRmfWJK4YD5wxXdMdLxR+DHi/u
	 wx+RGOWARtL5FINPy0AJGdkxYfZLvqZszPuBmxpNgPRL/Rg9j9SA8OqNLOgmXUQt/lw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=IV2bjblS;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.180
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C302606A329
	for <linux-sctp@vger.kernel.org>; Tue, 20 Oct 2026 13:52:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2C302606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=IV2bjblS
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-8a07ba994aaso354003b3a.3
        for <linux-sctp@vger.kernel.org>; Tue, 20 Oct 2026 06:52:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792504348; cv=none;
        d=google.com; s=arc-20260327;
        b=d+rvcqV1UQzQmACeuMiR0YglAnrbIF55CtsGiFJMfdH/idgsxFkAlJ508zz31/aR8c
         XoNqXZDwKplP09pYmQ7KoMde35i0pTYKeBuAcFP4FDbqjZrVF8DlADw9PjJAsprdB3CA
         Ee/ws03RXjV6tg3UtXDzd06dJR82SzNPQ+hLXQVPi88OiiO7BlalGWcu+/zp/9GPCTtr
         BWOwJoY1xbuPoMuSXI+2Y+muqXoHtq0+zPXWsDbiN3kDRH8COcNBsb2a0eHNsQevLQI1
         C2Sbz53C+vGdD6R9xUubVlkE6vIv2jy1vtYIuvIqb+09Qal/1mkeOjMtk/3iOzUtgmDz
         Hkww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=k/hbwlcYMnNfV2mBX84KMoYZ1kQ82mEtSuTGwp2XYJ0=;
        fh=x7aozTl3nzHRskkV2CRfQDR8fegR7VUdY/jfhzXcOYg=;
        b=PT5N/IVNXdYpQh5sxJlYvTowcIvMirAWRsC5biCH7MwZp5827EvQO7JmcZgeFuEZxo
         5DdF5Drfn36uJr9b4FydEngYBGVDq+PojCnovhtEyyjnqtHoNLfY68zwlOTeInMNEsXa
         AaPtFO4I0vfHd2l1qJhEKfnXrRmHJaHhp8hI3ZQON+nXSI9Y9sFY4Apfyx0k3L4NyVS5
         GDCS3tHLw1tTDrOlKCih1Ez6zgx+mqMHu+PMurIzTTRPho8Es+7w/a+wAEDXJP15YaZb
         sdpj0SMsZSnh/6zHjirGY2cv/IlvyZfpEr1WFFjJ1Xw/mv8lr5nxfb3y12MIxomJNfmq
         rtjg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792504348; x=1793109148; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=k/hbwlcYMnNfV2mBX84KMoYZ1kQ82mEtSuTGwp2XYJ0=;
        b=IV2bjblS35z+WtRmdC+d2NdVsRgCEc2iwHZCl7nN04NO7e2vjqFjw+Kx6HSekD8k2E
         /NPZRHZ2d9c1Lug7zCFOG0L68NjXSPPtKPzbZDrCoc8aYx91Wv0bQUQUtgRqVZulPYqu
         1syNEVnV219YTcsBqwsBTN8OTqFxpdGQxQXvZjeKMq+Ep4Z1SjPPQ2wtKwOxkoh5zuly
         P4+EdYiXsq+MlyOJePp6ZT18lccIxbzkqhPTQ/AorTqz9PdbsZePwazefSSyjIBhqVlp
         rbcM+9y4QEhyT9xZ5apQ6lMNz3ew0gGjIvKSy+Cg69b03SN4ZpNYRn/LcJvQzq+77ydf
         +7KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792504348; x=1793109148;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=k/hbwlcYMnNfV2mBX84KMoYZ1kQ82mEtSuTGwp2XYJ0=;
        b=FkjEfeh01MV4psQo2d09x7NaFrue24FJPeL8UtyUU/cL11RxZkPByqNqxA5lx12+q8
         aidOrNFt8h/d6+zAMdZEiLRyxcDv/wC7uq7yCFO5lg+EmdsQLJUApHvEwpx5ZI9sb5r7
         jzUjunYu6kjQokxciYCmO4G8PwolMYUjMuckNX5rajGlPPW3omXE2G4VEH8YGepsL0Ek
         AyEwwJucnNusu1m9hKUYcdmvVOY/krKibFfBfT1GJZEHHOou4+MfjJv+Dxnf9nla3aNB
         9XNsQQOh+myhiBh/fSLFZNmcHau2AIEKD3fI4S7RXJ4QPCkhdG+wQc3rmMwMp8QJORA9
         JCvg==
X-Forwarded-Encrypted: i=1; AKwUvByarLYLflVz7STa2VtOpSyFiIyPu9ZEb5/BWt/fzVm+ONZjTG8PoEx3DYIFDg+dVyScI2fbv4Vq2pww@vger.kernel.org
X-Gm-Message-State: AFq9FYJRZmqNw44jAW6DXsoyJpmjxUzbzGJUiHfuMWli0MOmCezorx5t
	Z3Mn1Sru3fpowMBVRrTCNOMm07KUEaEGqlZ4LIsT8yEa0bBy6b4poKXP3ELpScw00nCSftZYSju
	m/tnyBfjQWTe3TTpM3i72rt4jVyGZJ6Q=
X-Gm-Gg: AYBFou1CHO/zL0Oq6TeB9Mw/fyNpjaAbDF0l0bKFfvAnc9LiOlEcXYObzJV37uSHBhC
	/EpQsKMqRuSj+04Dr781A8cyVOgZp0D6aohak+grsOJQQo+oS3oghFS9QNfA+uDuo5gk0PQV1qI
	xkNAoPXMfCiR0mAXkDSbZbTlpRdn+8216KxaSuu8Ks4w6iwaNfhY3tBawa3bGHWIcrrjZocawOo
	sIsZB6TO2NDuNV1UA3KmgaJS8iv0LknjTaYYlOksTGLwy+EmktWxsbXStIRiI91ROuE4awZhhOP
	fSUIGLpO73p2QbSm/86YNXbKKlENj8iHbQiCVJU6vlBBcIAOOTnOr2dKJf3hL03zTrKvwHjUo6u
	kjF5qVLFelzGK5w3RUr9z72Zk7+O2KfalQWElPSdZ41wI48x9rFFA+oUy53jj908F2aj/CkYeZw
	cQgl0XVc6N5uBsRdbOhOAJHExOvAHwYHE8EtN/bA==
X-Received: by 2002:a05:6a00:2343:b0:89e:9c7e:fd51 with SMTP id
 d2e1a72fcca58-8a04ba30b92mr8261328b3a.10.1792504348492; Tue, 20 Oct 2026
 06:52:28 -0700 (PDT)
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Post: <mailto:linux-sctp@vger.kernel.org>
List-Help: <mailto:linux-sctp+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sctp+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261019135441.1420968-1-sashal@kernel.org> <20261019135441.1420968-252-sashal@kernel.org>
 <20261019172836.GA1885@quark>
In-Reply-To: <20261019172836.GA1885@quark>
From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 20 Oct 2026 09:52:16 -0400
X-Gm-Features: AclHuK-B306P9cHCODywZCNc6I1CxZirkEbtUGcvZRPSRQ2med4P2bdTR4gz54A
Message-ID: <CADvbK_d3hcGcP21Fy_z9hkoSuQT0Bg7111Ejns_WxOYfCCGFHw@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 6.18-5.10] sctp: auth: propagate HMAC calculation
 errors to callers
To: Eric Biggers <ebiggers@kernel.org>
Cc: Sasha Levin <sashal@kernel.org>, patches@lists.linux.dev, stable@vger.kernel.org, 
	Qing Luo <luoqing@kylinos.cn>, Paolo Abeni <pabeni@redhat.com>, marcelo.leitner@gmail.com, 
	davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org, 
	linux-sctp@vger.kernel.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 19, 2026 at 1:28=E2=80=AFPM Eric Biggers <ebiggers@kernel.org> =
wrote:
>
> On Mon, Oct 19, 2026 at 09:49:03AM -0400, Sasha Levin wrote:
> > - Residual in this tree: `crypto_shash_setkey()` failure still `goto
> >   free` without an error (mainline HMAC helpers no longer have that
> >   path). That is preexisting and outside this commit.
>
> I don't think this backport can be considered complete without handling
> that case.
>

Agreed. We should return the error from crypto_shash_setkey() when
it fails in sctp_auth_calculate_hmac().

Thanks.
