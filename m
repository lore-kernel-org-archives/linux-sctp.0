Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793302849;
	b=QErI4/NQZPR/tjDS8Hb04jqj8wl/A2tKBROQvj0rHS2MSL7KyEYeEdFFR+dnL5egck9p
	 giNjiDRQm4qS4SFW+QutGW69ZedO4KePtfwuMvRB4gp07/9UkFC9fNRJlUnsKm4GkJAjY
	 kv6H3lgtTNosnWhTXIEAO6wwPRABfre464uUG+e+/JuveLaC5QqsXDLL7t2icUcMFiVAr
	 61H6OVPWrt2tWBQVnEz1BJQbo3USAjXluYaQxq2Xo/GXsvWCiAdsO05MozZZ5k6fJK7Dq
	 9GaK/Xd1FLKu2P1F4gKFGf9HH5nsMRv8/3252yiiIWptsaPmIg2rTyzUzE9QoQSQfPA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793302849;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=BI99PD+ATh1Y5+RSlEwKFF3tajPLYbWsXiWu2yRi084=;
	b=B3qz6SSrwmMMxf2cnZuFa/+aKx9DtS9+adRFP1/MLiaaqL2COhmJh33f2umhwPgLPWKf
	 5INnL6KwVwfDG+Fal3HxxnfKB/0Gd1t69D6i60ZxCuby2Pe541lQVI+V6BwMUr1FuUpYs
	 mFr7+3wugeylTkl/GL/FY+aS7W2+dN3vGYVJnP6Vf1N/0B/tYosX9kSMsuKXczKBqAcRH
	 /UmhGeCvnRpD7UexxSP4O3D4Lfr7/QJzm/schcYu1IoZXuAZBWtFjZsza/Cr4FsZChV6I
	 Aj2nCEBGnnGMHGEudhf55L157J4abC+i0gK63A4veOj3r98sQI6oT1nyqCejurjcIWA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Oy04HEx4;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.42
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CD0C606A31D
	for <linux-sctp@vger.kernel.org>; Thu, 29 Oct 2026 19:40:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6CD0C606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Oy04HEx4
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-843a4ca671eso19596a34.2
        for <linux-sctp@vger.kernel.org>; Thu, 29 Oct 2026 12:40:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793302848; cv=none;
        d=google.com; s=arc-20260327;
        b=cJJ+h0RBu4TeHEut7VfrmDhXPSTbEDMsv0TZWM3heyC63zsRSEvBERRCizPmCvFwrm
         HCybtqTMtMr2ccIlXG1MlF964pxvu/31ZzaYrzuxiCvHkEg+zmOsYWuUerbbe2eQ5y6X
         me1hU/c+GMVNpbzLUQ/OKpLYjqMLlaL4Q9hnPbWhD7TzZeHQAul0h441xr9PfJpXAXSA
         9f9BLNSIxfZXXtrYhHbxT4PRgcm0v3AlJ4YMmnRfnTLEbtAbE7/M89/84hK1McxroaKC
         MOTP/770e9d4i+KHMcWYTpqIenyM2wpSR5QsKeP5yAwL6QjmYF5lizz4nWsZT+pNXCBs
         yytg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=BI99PD+ATh1Y5+RSlEwKFF3tajPLYbWsXiWu2yRi084=;
        fh=7WhbEsHXDHXg2ExJmdTnxybr0wxTrMRDUciGcgs/Iuw=;
        b=Gy+f9P/vClN5oqtIbZgSgTf6yCDSUoATVm72iQXCnf2Tf3lST9krAjgzun5kqFPJl7
         Tzjzlq+Ruek7DUMLB07WR6NZVPPAFQkNZ3/wBx+4aRCZwu5EUOzvKdNXASvij0XXzhlp
         +7e1t5xY4x2EWPG6vM70t+0geAvPmB7A0aqugcdHqXRlEXWe1vCVKNrP7nrHlr+iikko
         V1QZC8fnaOUKJqd+WpkptP9CSb/EY6yLNFsd6y3fOeq8u5jvbdU0zYD7K+iJGPydiqPt
         FZmhw3sP1J3WrFD2oyuRmDiKW20JOKaVemeGndXnvs+Xa39tDWxuPRnmvjs36DlOhgxX
         g3Kw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793302848; x=1793907648; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BI99PD+ATh1Y5+RSlEwKFF3tajPLYbWsXiWu2yRi084=;
        b=Oy04HEx4VXsy7bnK+jxK7wLwJKJgZjMD+ok02/ElUmFMcCdqOEpl4CNxdWoxJzIhzn
         U9RRGRt6Otan88a2NMxx9hAn+vJiyjDSutvbDnQ4fcfybjPlhxmIxNbVjs5s10zwcK92
         qYY1ODXDGpBmd69+yoWLRWbNxPvInfpeDY8XkeJeCFG0nCIscbu6LhWZlJFfvgNakjJP
         ggb9DU+L4K0N5slxw86nSUklX444AEIO8JnQXaH1vGuPc4coVKJTwqNt10udSvszwDnM
         Mh0X5ZLVObaRXY/xgb7VXOmvBk9Hv7hm3jm15v6zxqOE4mkNYW3VpvNXXZHhE1kT1t1/
         7jsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793302848; x=1793907648;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=BI99PD+ATh1Y5+RSlEwKFF3tajPLYbWsXiWu2yRi084=;
        b=qPPuVYgIc47r9ijQ5VYKRg6RjiQte+Hk3EWifb6XNxTFwQnfmlvgVA4ocOgiC3PQix
         IZpccN3HyPS7JWM7akBlVl+9BVX2IoEjMy1lBCFcQenmxskuNAVODVWYI1OwycMvUgux
         7xQlR8d+lp8LXydiH5jk4kPXi85HkHIcklFHJ2gP0WyQx8Gco7lYaUNQQiO+M/FYB5gb
         pqd0vOTZrm7U1hy1Z+RR17vhZoILHQt5hCDJQG5iImPYkuRs+AEmXWpAJEsTUlgG+z/u
         WBS7IwsDycrgsp6LkRsFRdnND4i+sCFOYfD/s95bvEhNApjemdrBgaHHYXmU6Sw+vsw8
         8DCw==
X-Forwarded-Encrypted: i=1; AKwUvBy4yNYSQJnKy8b8Ny60FbB/QNdsxJTWVkDI6uLN7n1ClE831kUqEhNFA4qU+je8+X7k7ERLxFuYwKYe@vger.kernel.org
X-Gm-Message-State: AFq9FYKY6wjGf8lC2i6vfsIGis5RYtXkElLzJBA3LyyqrCbMdABVT3fP
	qLp7wrcy2AXFc8Ur+ECVJ0xjm0h5ljpkToMwGvs6bXbmcfIzq/pggsp5iCU2C5xxvLhyW8o3LAV
	D5dDCjHUJOlRNcW/9jbuHcql38LkCN/k=
X-Gm-Gg: AYBFou3qaXhNVeQLWGULLwrGo3cw9dIVt5n4NyL5lqGqTsuW3ZjQ37Tx5u9w8nleS4q
	6A2y6u4sL84kEa2xI0Ym25iLDmZm3y6OZsigvZsf/OxHzbLxN2hr3TM1nLivfE9qts30jFUWJav
	UOD2rOrY2iLUq+bwQg2uhbvlz4zm2UKijqRXEaqYkAgcEVhasJqXvdkG5LO1NSvhsNpZwAknXcf
	mdWaMDOkGPsLBniunSyUvwUTiwF+ptaisx9+Yy+1hnzkyPTjRSHaAfShjf15UiwQ+QAuJKbdZ6e
	IBQ4XXL7waCh08hy/RX8N97rx2E/7b+SA1Ni9H+5jJalcBKTNUHDJQZl76imt8O1y9ujBop9bKB
	JY9GX2DpfiMtZUiiNFS0xWmzW1tbfAA7vPHMYKQ==
X-Received: by 2002:a05:6830:4391:b0:822:95ff:43f3 with SMTP id
 46e09a7af769-85d3664ca3dmr142180a34.24.1793302848352; Thu, 29 Oct 2026
 12:40:48 -0700 (PDT)
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Post: <mailto:linux-sctp@vger.kernel.org>
List-Help: <mailto:linux-sctp+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sctp+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261022163639.2566945-1-andrey.misyrov@gmail.com>
 <179303675173.3134.11217955296529787762@kernel.org> <CADvbK_dTUCUFn+sLY+zuN5_9+YC-axzM9FVr-yBKJ4jxwebkkg@mail.gmail.com>
In-Reply-To: <CADvbK_dTUCUFn+sLY+zuN5_9+YC-axzM9FVr-yBKJ4jxwebkkg@mail.gmail.com>
From: =?UTF-8?B?0JDQvdC00YDQtdC5INCc0LjRgdGO0YDQvtCy?= <andrey.misyrov@gmail.com>
Date: Thu, 29 Oct 2026 22:40:37 +0300
X-Gm-Features: AclHuK9ZvCDg2n35I76iYH83HI7jntHSzE-MkCUSpArWzEKyyvJVxDkcplmhCjw
Message-ID: <CAC=piAqJCtKEn=jLaoaBCr5yAgF5dibhPYcrZGWPytYN=Ct8cQ@mail.gmail.com>
Subject: Re: [PATCH net] sctp: fix ASCONF address change on single-homed hosts
To: Xin Long <lucien.xin@gmail.com>
Cc: netdev-bot+sashiko@kernel.org, marcelo.leitner@gmail.com, 
	junvyyang@tencent.com, davem@davemloft.net, edumazet@kernel.org, 
	kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, 
	linux-sctp@vger.kernel.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, Oct 27, 2026 at 01:38, Xin Long <lucien.xin@gmail.com> wrote:
> This looks like a legit issue. Either way above works for me.
>
> Thanks.

Thanks, Xin. I've prepared v2 and posted it as a separate thread:

  https://lore.kernel.org/all/20261029193454.1028626-1-andrey.misyrov@gmail.com/

pw-bot: cr
