Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE2E4346ACE
	for <linux-sctp@vger.kernel.org>; Sat,  1 Aug 2026 01:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785547480; cv=pass; b=V+m48DxLmvf6rVNUhdk/nieTzYX4ZLYlTKPAzvXfCz+QPP6MbhgxOHtVaLTYvgaGos3RG0h/015nHDN+kbbWtsG9nsy3mGJ+k1QtisuE6od+flhDzXAwQ3RVgabMUqgbc+ESEaFd+4plxOBL9kGMORbzjaiRBL4T2IiFtrkThYA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785547480; c=relaxed/simple;
	bh=+1GhZ+xe6kF0851bfcXUhheFoGYJWmbd5WSkoS1Lgxg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QQQgRvzqkFaJt4B7H2ygem+Ypy4p+rV673SIZj9qyD2tniQsA6UgBzJP62dPE5ShEoVmVltxPf95RG2U1voyPcQJ2goW+b0Yus2PKrwneyKDoGY4wN+1sFqwGmGlfAhc6njkM95DD9Uc3NOvrU1tvU+ZyU0lLk5W3mOWJVWo1Qk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dSXFZkBg; arc=pass smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dSXFZkBg"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-848643382fcso1527606b3a.1
        for <linux-sctp@vger.kernel.org>; Fri, 31 Jul 2026 18:24:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785547479; cv=none;
        d=google.com; s=arc-20260327;
        b=gWzk145v1u8oBCunhc6zb/K6EagS4HV/VT+UO0sLZdZNfXy1zZsLdTlvuoacriixbU
         4y4c3BMGtIBgNtVw5SJIN341mTzt/LdQswLPltmjkYr/Iu2sMuWNMoxV90GY6GHceytJ
         HDHWLHYXSGSSBLNSc6fEnM4tS+sKn4kFUh73tvmbk9lHXDuuCzZ9qsFCFn0weCjDn+/P
         7e3NEWW9uF8JFW/YIRoc+57L3B38kbUfn4jaG9gPbr5gJ79GsEDk58exB0buQZC1VOpl
         UE9TUxDHkO6sHMv0BLvrSEl+54/0wWxr6BNTcb0Ie7mVgwWGlHqzbWLE8qODkt9/TILa
         qUKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+1GhZ+xe6kF0851bfcXUhheFoGYJWmbd5WSkoS1Lgxg=;
        fh=J7cBOdSQAvgbQMu24in3mkz48mTybH8AWsIfe3gt9M0=;
        b=qbXrdwrXXWA3V+s1Fg6hTVpBwwbRsfydLpzR7jVNTWhYXU6vGPhCjjKlmdoYMH07wA
         63iltQ5NOZBp6C1juZ2mUvIUN6JOJilMDgFrBSdnj8fauiicQ3TODDYvNBItdyAldNTo
         u+YiTihPyGtulvEyGUdKF6sX7Qz3XSZseMz7njvERO/BmcrOgAVw+YA6sHYYatUCi/s0
         oRPRs7rYUMl4HMT2rB/K0KKUgDKjn+Ytmh9F2kxw2UJPYBoGgxSkghcqSo2EU/vhxUt5
         17Gt4/eIR+xIXbkDrCXKw70c+A9vcJVEVNYbnReBwDBE5Jfic1MGyMNKx/L4uxlHqI3X
         6EKQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785547479; x=1786152279; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+1GhZ+xe6kF0851bfcXUhheFoGYJWmbd5WSkoS1Lgxg=;
        b=dSXFZkBgONQDTJ+aHDinZALNGrhc86NHC3WlNc/EW4EejoYdo0A+ZFTB8a/Go9Ql05
         LdfjTXTyO/rEhVI7uESIBFDtuUq70aKnxutLxWkumGTNR1J8KEqSqj2y/dSS8bDv9SW7
         WkZn/lsFrxwnv6okAbCIl8h8q7dJHQW5/yt1lNjY2Eq+driyYFvAhc4fCOX48y4Is2p1
         WE0Rca2f3ub/QNHA8EdSGmD12FMY05zVU075NpaNp2KxwP1uhCe5+aU3gzlg5ZntbiW5
         WIlD29eMFUUIE7/2pYnudgROtXhVjaIdd03HmaW+KuAZ4XApEkM1YO5EM/to4QGP/+rP
         yh+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785547479; x=1786152279;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+1GhZ+xe6kF0851bfcXUhheFoGYJWmbd5WSkoS1Lgxg=;
        b=GUIQ/fHfLdHhHko41QVIlWzah3x/kIL3C1pYwc0950fgJXwXcTx6s6NznKXRsbJXIU
         YFL964rrzsuGKwUeed3lzOmLM5hJrbPv+MnKIJSQQImW7y3K4IUF0njAvYZtuc4xOLHP
         /vGrkWKZS4QIU+L4j/KLQgT0Qgjv0aY5i906nq1nKhIIZN8iANcMqxB+zhsxrS0sVsCQ
         +I1b0ImOuU8tIfiHASb4XuMjMdr0G3rLKhPXlvvE7WJ7L/D7bGxbxe1BlPC3/eIeBbLg
         BaGfEzVEVv08kBDpdtdTkhNERDE30kG08eEpjhBVCC1HnfHJQas/p3E3Yj+hfRDxtUno
         oQmQ==
X-Forwarded-Encrypted: i=1; AHgh+Rqft1LxHgljiuAthB3mn0FwjojQeqdP4SMHKzAR2eu2zKMTr1d4rIkpSgbXVwCu9kc221yvQWZBFRdx@vger.kernel.org
X-Gm-Message-State: AOJu0YxKHCJIsAPgEwFlABp6i8uLmt4+1sgSZz7Az6eO1XNwA95abdAM
	xB1gL10rxygdszzhdOUIBj/MvaFbZz17KDBlV4HwT+MJ1c4yrUnCccsBVZuVhqYwth2NNymM+HC
	zANSWqk5wqHgHlaK5eLF99zM2+iAgmeWlKh5S
X-Gm-Gg: AR+sD114Fa0xrJbsOwrBFJPkYGu1hthJQrM9Y0h8wy0Bexc18DlpzkGQcvyWHaXvpnC
	EmIfkK3YO+YrLEaenfRhcrDO6WLWA5i0Kr5VkiH60lMm9dxuMlFGcHE7SbMh2xAKP/LLIO0opnO
	8MsyijgokdkNEKEex8JXr9wKFzmp4T19huNEmcOxwllMNJje/drI0pVeO8uoDu7mbWOcIr3v0NQ
	N1KnN/KRzl+XexkKyFOtUck+Yj3xB0BA8ecySdC8fW2oN0Z/cxOr0Ei6cROagpIM63bZPcge50U
	7/kAsKYkDJ3TlUfY/9JYLHTqdQtS1hFat/SnGMNtB8CoznCj9vmGpdhKvOtMVcM7DHMe+XTDnR+
	EozVgbQnnQnq7g6P0w3IHg6xgtirPemRqKL5rOppBZiV6
X-Received: by 2002:a05:6a00:2301:b0:84a:2e5f:d697 with SMTP id
 d2e1a72fcca58-84ee480218bmr1414400b3a.33.1785547479057; Fri, 31 Jul 2026
 18:24:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260731120558.558957-1-david.lee@trailofbits.com>
In-Reply-To: <20260731120558.558957-1-david.lee@trailofbits.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 31 Jul 2026 21:24:27 -0400
X-Gm-Features: AUfX_mzpegywlV7QV3WPhDcRumAMkglk9BRzHj3-GDSqPu27ALqbeoWb7nBQuLg
Message-ID: <CADvbK_dWeqUFR6XqC-BqjjwsWJpNjEeER-fJ2SVYKhUObkMm1A@mail.gmail.com>
Subject: Re: [PATCH] sctp: hold shkey across socket migration
To: David Lee <david.lee@trailofbits.com>
Cc: marcelo.leitner@gmail.com, davem@davemloft.net, edumazet@google.com, 
	kuba@kernel.org, pabeni@redhat.com, Kyle Zeng <kylebot@openai.com>, 
	"Dominik 'Disconnect3d' Czarnota" <dominik.czarnota@trailofbits.com>, horms@kernel.org, 
	linux-sctp@vger.kernel.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 31, 2026 at 8:06=E2=80=AFAM David Lee <david.lee@trailofbits.co=
m> wrote:
>
> sctp_sock_migrate() transfers queued DATA skbs from the old socket to
> the new one. skb_orphan() invokes sctp_wfree() during that transfer and
> drops the skb-owned shared-key reference.
>
> If userspace has removed that key from the association, this can be the
> final reference. The following sctp_set_owner_w() then dereferences the
> freed chunk->shkey while trying to take the new owner reference.
>
> Take a temporary shared-key reference before orphaning the skb and
> release it after the new owner has taken its reference. This preserves
> the selected authentication key throughout the ownership transfer.
>
> Fixes: 1b1e0bc99474 ("sctp: add refcnt support for sh_key")
> Bug found and triaged by OpenAI Security Research and
> validated by Trail of Bits.
>
> Assisted-by: Codex:gpt-5.6-sol gpt-5.5-cyber
> Signed-off-by: Kyle Zeng <kylebot@openai.com>

The "Fixes: " is not together with others at the end, and the "Signed-off-b=
y:"
for yourself is also missed:

Signed-off-by: David Lee <david.lee@trailofbits.com>

Patch looks good to me:

Acked-by: Xin Long <lucien.xin@gmail.com>

Not sure if you need to repost for fixing the tags, let's see.

Thanks.
