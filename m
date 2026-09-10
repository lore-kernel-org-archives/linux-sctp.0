Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D86EE378D72
	for <linux-sctp@vger.kernel.org>; Thu, 10 Sep 2026 13:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789048090; cv=pass; b=JL1DnNDYtZici8VEJHX6+ByOAibPGmral6WfAtpXKy1s9vlYBtYcu6/9JWSm0v5IfyigFkomd8O0ZlZ7vxRIin2zmprWTk2NM4svRZSHrgJH3yCda1nb4hd/o4eZ+DTMbuR+IRm3euFEuyodgNzNQaY/60GArfenXJpdc5sXGb8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789048090; c=relaxed/simple;
	bh=FxLs2vs/J2uylK62rLnK+7N5L66TpTnceqzDX1Jt2Z0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UM8xi+LKVkl+tPLh+skQD6HKKw5VNQlcOZoygd0BeiRMOoDt7aTlmrYdMDMLmfYPwagpCme1ycA2JO+OK9UTRpDkbvBUx6DqZCdvIf9AFToL5XkZkMbMKKYa2/eSqmtgt4FC9WjQfDVzHUVqDVZqyE0eyDk96O4fU7oTjI5uUNU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rRB2mlx0; arc=pass smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rRB2mlx0"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-8557c3f270eso4742611b3a.3
        for <linux-sctp@vger.kernel.org>; Thu, 10 Sep 2026 06:48:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789048088; cv=none;
        d=google.com; s=arc-20260327;
        b=iE7hhUcTIFpN2kqldBsIItny719/LEQMgytIy6pBNYZJV4i6FNg5i5Gf7z0ZhEzR9Q
         YC8QjWvJ5e6HH6jfW7PwDIPkM05OL19SRfsU0J8UrNJB55b8o15vNcyuqWyIP1KwChGo
         MSjJR4u8D2hmGOjm3WPa5kFKheYVdB3CfpiHYr52h2kfB+UK5l85ZurY0CyV0rmX98JO
         MlqIxPAmjBPe3Z2KfoIK6CqrMZL3dn6tnTAia3rj0iXStWJ9rmMbjGppdZMY+xh2vdEY
         MDmDIZoDc1xu2hxW8mhaFlWl/OUV5A9wnYTe3/wCFKM6i/R78yfHvB6vZtOTmLtneyVy
         j3Eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=FxLs2vs/J2uylK62rLnK+7N5L66TpTnceqzDX1Jt2Z0=;
        fh=wcEnvpoc0o1HHMGc+7lLBTu1wpeqtQWvh/m2R+nlRXw=;
        b=SSXcUbSd47TuR3z5OMPuQfLCpWraI+Eu82xByP5KPUUBkjTlk+TmaLe5chQsFrDua2
         pQwXjhDdPZjM/N0TlcljV2nHD38iGd5CUihJxtWMmj31EjBoOT11jIoKgFKjCXwMXcEq
         4kE1abinSK2fHAmxul73OMlLwNBbWYrGjsS7WW5Iv393y7XIVQo12dUeDT7yz3lua5tk
         09FAdO3j+kSsxH9GALH1FTx4DX5jFuD0UMTAzKzS5k1Y3N2QlnM+o0w+UOTceAN+jWIk
         U8qgncJ9Z7MCShRD8VRscNZKbpIPCkOpFCQAGe0hXNONDz1a/uBE7glbFF6Wt2Jf/IkZ
         KKTQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789048088; x=1789652888; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FxLs2vs/J2uylK62rLnK+7N5L66TpTnceqzDX1Jt2Z0=;
        b=rRB2mlx0lMjhbda3ADle1Okrab0/BJMgO+TvIq9letyyruGzERKDKSc1CaDRbVKPJN
         m57pxE6+7GkLMIuzTjA118c3ktnZX5KyN37I9hLuK4U+CLOv8s6o/NxLyCQGpuxWeKin
         bomxeCgwVhhJAzfXDAeqfYd4C8kw9JWSpAfRHV2iXmy7QVGG7lCzy8Y28G08aXnWiJJI
         /OOq6SxdiWxc1FpeDbL8FIut7pwTJY61GcULqa9I6CfR3kUHYQ5JLslfnmHyh31kN57y
         evtrUbrp+J42Egaxq58lcSOZLCfWnVWB3C3EO+XaatLGh7zBQJ1urvX0KDo/TJZ0kVtP
         kCbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789048088; x=1789652888;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FxLs2vs/J2uylK62rLnK+7N5L66TpTnceqzDX1Jt2Z0=;
        b=hI1/h9kdkJOhrn0XWAm38nb+2/0l9JExGmViWCSRhRsbMmmsqenNaVbLndnFHOfAw1
         jSfAgndpQJUYxr/UXubyjGnucvLmVw6c7T+9NmV2w9lhx55X9xFj/g2fAQslnL4zTpT2
         Z6aSmTnYiRqRYSSriGQODOBSZ0MPHWIwpdSb3vwAY9CAI8emqC61Q9bQdv6Z1pQu/pR0
         qr1rWriCpQaDMDb3kPiAQyPJKOzN6BXcy0PRceqNeumi/UT0obojhr+YekZ9hgTBd3/4
         LUCZhwh0Ng18HLzVZv8k9VDhHPz2eBgFalrK1uK4IbwgRZCEKO6qSGgL8zZD+KWMb/74
         IWEw==
X-Forwarded-Encrypted: i=1; AKwUvBy3v2KPTnkpxsnjgrf5t8I1tKzZYmxQh1GaIfVpP0RkuLEjpcq5moGClsPJ9Uw5anRGTrQ1RirfofHq@vger.kernel.org
X-Gm-Message-State: AFuF++kPOwdIW/UiwAvbq7FuDWaLET/Kjj/J+uyPPlTcXo3gCvoamMB7
	VLYcnCwcjreSRkmx9Xa3U0OyBSevD6Y79yVlibEXUZmOc1tZJyj8wvvULfeE7qvSBqFmD4t097+
	+RiYmLaVXiOH5rHfaL1q9JiQGG3640q0=
X-Gm-Gg: AYBFou2hQe+yQLwn/SnbJhRqiThsdWwWw6uWOkjZAOIMLcYZbQrVwf3ZOAQfX/BUK+g
	NG4Me1FQK2b1xBACakQFDADKGpxsq64sxxdElPRg2dIp/Lfe9Qo9o9KF80EoNrFfN9zu4goiLbf
	6LuzjiFdHYVsp2+LdsxbmFc76rlNXIISBpPVDBaCjTwgjcBAaGQfW63qTBWMTNTVDMSfeBl3C5t
	0gntfZnsBWpNP50Dh3uyvYLyPdszG82vv+cgIBPb8qCBfD/N27Bwu/r6KR3fbN/hW3FDxlh6TDT
	U/97vA0M7fL1+4Fs8jdjkdxEwR8ZaFAyQOh2uK/HuUQrPXfaHAK9uMVC0VXfaR7je92aEqKsjh9
	l7nrEUi7gku8DgFPq5U6VAR2ys95SBCTOj1R/cMIXg4/F1Lvca0kHnWo=
X-Received: by 2002:a05:6a00:32c4:b0:857:73e2:9107 with SMTP id
 d2e1a72fcca58-8616c8498dfmr51907934b3a.23.1789048087728; Thu, 10 Sep 2026
 06:48:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CADvbK_dWeqUFR6XqC-BqjjwsWJpNjEeER-fJ2SVYKhUObkMm1A@mail.gmail.com>
 <20260910020748.3643902-1-scott_gzh@163.com>
In-Reply-To: <20260910020748.3643902-1-scott_gzh@163.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 10 Sep 2026 09:47:56 -0400
X-Gm-Features: AcwNN1XLYo9Tpctj6btW9Am1OvR1X4vsOSgww2ik4xoSX3FAmeg920CXO7UztCE
Message-ID: <CADvbK_dPtNmc=gaAy_u64JkV9_+nPHT-oniH=0vReKp=oJfJcg@mail.gmail.com>
Subject: Re: [PATCH] sctp: hold shkey across socket migration
To: scott_gzh@163.com
Cc: davem@davemloft.net, david.lee@trailofbits.com, 
	dominik.czarnota@trailofbits.com, edumazet@google.com, horms@kernel.org, 
	kuba@kernel.org, kylebot@openai.com, linux-kernel@vger.kernel.org, 
	linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, netdev@vger.kernel.org, 
	pabeni@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 9, 2026 at 10:08=E2=80=AFPM <scott_gzh@163.com> wrote:
>
> Hi Xin Long,
>
> Is there any progress regarding this patch?
>

I think you need to post v2 with the tag issues addressed.

Thanks.
