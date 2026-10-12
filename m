Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42CAE4BE45A
	for <linux-sctp@vger.kernel.org>; Mon, 12 Oct 2026 17:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.215.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791827361; cv=pass; b=u4tsvQplg314QTTI9o3hbto+SQQnz0gYTr98omPx5krmj5sUoi3SDXkOyYMXNIt34nY6Q0PeD5qbIgKRcc8AruiamklaGPP5hK/5oGOw5vka5BqIYGzS+71RQQH60FGwE4XKDkozkzLEIa5yBuHT65aWTsNdVEbi6Lkt99Nru1E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791827361; c=relaxed/simple;
	bh=zXMowjKMhNEHQ2iLsSxX5fh3k3aLhcEQjyZyEdIYKOM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=b/lLzxtB3t3K6r96NyZW63XMm5uBUqZ7c72GqoEFSN5hGjlFOVKQ74YObk9nQRafpaP5TsLZ1APWgJ9sEjClYUBh4KHKpNPtxHo5bTiD+V1E7DfC46bLb71TAFbXdRlrQgcnoe2GDehqS/GmM0R4SH5+1fiq2MhdkmIs4QkJVYs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QjVsEs/i; arc=pass smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QjVsEs/i"
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-cc7e79c1eaaso769024a12.2
        for <linux-sctp@vger.kernel.org>; Mon, 12 Oct 2026 10:49:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791827360; cv=none;
        d=google.com; s=arc-20260327;
        b=RTl5b7iAQP95nV/wdBNbht4yV0X/TfCq9OnG22yuKvL4fwJOYSorUaDr/Dwxy9kSIZ
         oKMo5bt1+IMPmiTrMLhL/YrR/otsX9wPO/6ZlXu6PJrgHoWAq7TuTOGht1owGCTaqVvg
         FLydHfJpjqsQCwsLnPTB9Q2/THV353OPFMFs+3NVX0tIbU5/SicTuiP6gAbc5b6Y53KS
         mmNHgiYe5U825PPOuBQpPM/khUes+b40J6g650ihODYmoLFHkzben4jpJ4gZ9+Nl7LIT
         6zHbVM7j6Ftc8Hg2/vZkWi5aV4RkYxP6jD4PG61KwMFlBrslCPtN7yMG3H55VgsfLDaA
         IklA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=zXMowjKMhNEHQ2iLsSxX5fh3k3aLhcEQjyZyEdIYKOM=;
        fh=AVc6tqTtuCUj7qOvCy/jEsA87CIyvvA9hrVDJohu5R0=;
        b=qlnkg+ocjBizZwOc2jQdclU4GQlmdpvBFpQpf15/uWB1nJZEo+X1OyJYCRCzE4Qrwh
         hKdXDjNdFZjEaiQ5V4+CbDwlaw2CAq9qC9yp3muWUAQwxlxuSey8uf1Qpo2cHYO26Bmk
         n9OtJ6VbWYSpU5/rKqqMIVkNsq/4p7Go135Rcqle/WZN1h/fjwGBWMdbQeuz4ebUzYx1
         uhevuacCXY6bM/vmZzksVQYAUA+mQRZ6Q52+etPy9614V+6GDseWx9UtpTdpvQgZQOGi
         y7rORTDX1Lm72DVDX7BeAP5TsqmI1KhaLLpNJICLhP6TqCsJT9kgexhZlad7JfsADQR5
         EstA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791827360; x=1792432160; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=zXMowjKMhNEHQ2iLsSxX5fh3k3aLhcEQjyZyEdIYKOM=;
        b=QjVsEs/i1gj7oOupNO6djz5HzvPI+SgcLMgPillgK31jjaFdJ9O0YRczAXp5ywQHII
         ylrjhlAkYnYsIRBuJBJVrwjasalK1KXBwHAMurelvKgyQ7hK3oIZjLsXp5eUQ8CD89Sa
         4UOYZcQeEl0SsVbCkfwQguVjRRc2dv6aAGrs1CzsZDZpOiS9pTNnYkcZkVX8sLKlxzgd
         0dvrLl2IqBKsY1AyQWDNIT4eddCLrN88ChvdSEVTMzPiYxHwNYtM2g15tFWfKxYQh89Y
         nIFg9rDIaOO+Pu2R8TV7TnH1scZamrqYFpvAEduaQEMQLqCK/ku2K3pKHpvxuIVICOs5
         CAUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791827360; x=1792432160;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zXMowjKMhNEHQ2iLsSxX5fh3k3aLhcEQjyZyEdIYKOM=;
        b=DzFnwQrDOSvpEfgKen6H8R1vAUR/cS8PxLy5ANfRLplD6uOqE472i54UnmfxdrU1HV
         LuKIfHWNexb/BYJM+nWH1dTzS8s1M24r2jPnbZPWLrzqK6UjIsNIycfFGHuV1KUvMazD
         STRYBbfODu3FF2pxLJ8WrcUqMtHcYRBouSIVMsoTSjoOgHyDV2euxtJ3UrxKgguJMli0
         A95MVb2kfGG3+fSpKvdDABeByPtfbklvJs6q+kXteg6uJeK0Na1k+r7IgOcuKxeXVtQv
         3ci7F1yA+yF5Obc4sywxTuIs6qpSE8U7Z9KumLSHf6/AHq9P910IAFd3uMWMXV8ZDSM3
         ZN+w==
X-Forwarded-Encrypted: i=1; AKwUvBwLEuw1Mqn5rZN12heFEblwebv58zpvqAB2r5IO6DWVFUjz3NlAR3XVrKtYdP7fXn/dOqs4+JKidggA@vger.kernel.org
X-Gm-Message-State: AFq9FYJ9KDIMwNYloUI0ljERom4V/o4hDhSu9zdCuTNqBHcgrpAIR0n3
	MNOCCmzJw/cwqngJgB9ctdmPzR/EbkcBxsHXOtLYLUX9t+G7IyAV+1g36jEVlGRHg1oYLUvK+21
	Mg7ocUz0WwYqnMDogJEP3UVdb+7Akr2A=
X-Gm-Gg: AYBFou1kNse7vBA6JyCgY2AGSux3q8aBX4owhNSIjUOijROA509bwqUiDNSBOz7j3Ep
	mgdTuMl/J+zRlr9MZsUYxRxI4xSVPe2rI34fx2d6qbsuRdd7rTyLEkTp+R7D2dDggN0ERi2pvME
	+jCglTg5cSMahl8oFAJWKp5sjRyKqVB43C0wkR/jCZ9/DY6s9Zlv3jZerUi9t3qezsrwtBGYW0f
	5A9C8Kbw/EoeldayQqzltm/z6pd+0m7+A6rcZMqIO1esTM8Luj5iE1IWAeTwGUn5OHEoijlpmPQ
	jX+CV7u64M6zxIMrCMABmuaUZGQbdCWlMf8lTbLIz0SfJ1Q99+Sj9FQY9bmo1xc5lmPpI6OlZxZ
	DM/518SfjWii+d3FqA0oL+7wQzYy7wIjKeCKNfA1ROd9DIdBePKobZMkz+hOfy6/WpnI=
X-Received: by 2002:a05:6a21:4c16:b0:3dd:85a8:4c57 with SMTP id
 adf61e73a8af0-3e16be08b6fmr7486829637.30.1791827359557; Mon, 12 Oct 2026
 10:49:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261009074244.3718-1-juny24602@gmail.com> <20261009074244.3718-3-juny24602@gmail.com>
In-Reply-To: <20261009074244.3718-3-juny24602@gmail.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 12 Oct 2026 13:49:07 -0400
X-Gm-Features: AclHuK_YBZf1ri3NIcdgg7Xs_NZXFV2yTbwpgrbst429Dk2_CK6dEWVN6lKvZyg
Message-ID: <CADvbK_cxZLjVYKw40-A+=42pCJpx1m3Dtao1Bv7tx65X5yHZkQ@mail.gmail.com>
Subject: Re: [PATCH net v4 2/2] sctp: re-point retained control chunks on
 association migration
To: Jun Yang <juny24602@gmail.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, "David S . Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, 
	David Lee <david.lee@trailofbits.com>, Kyle Zeng <kylebot@openai.com>, 
	Jun Yang <junvyyang@tencent.com>, stable@kernel.org, 
	TencentOS Corvus AI <corvus@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 9, 2026 at 3:43=E2=80=AFAM Jun Yang <juny24602@gmail.com> wrote=
:
>
> From: Jun Yang <junvyyang@tencent.com>
>
> sctp_sock_migrate() transfers DATA chunk ownership but leaves retained
> control chunks pointing at the old socket. A later retransmission can
> therefore access the socket after it has been freed.
>
> Extend the migration walk to cover retained control chunks and use
> sctp_control_set_owner_w() to assign their new owner. Reuse the DATA
> ownership check so each chunk is processed once per pass, even when it
> is reachable through multiple lists or retained pointers.
>
> Preserve a control chunk's existing authentication key across migration
> so its final release can still generate SCTP_AUTH_FREE_KEY when needed.
>
> Fixes: d04adf1b3551 ("sctp: reset owner sk for data chunks on out queues =
when migrating a sock")
> Cc: stable@kernel.org
> Reported-by: TencentOS Corvus AI <corvus@tencent.com>
> Assisted-by: tencentos-corvus-ai:hy4-preview
> Signed-off-by: Jun Yang <junvyyang@tencent.com>

Acked-by: Xin Long <lucien.xin@gmail.com>

Thanks.
