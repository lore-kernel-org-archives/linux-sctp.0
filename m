Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.46
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795083403;
	b=ygiZdW9t/cr6uNRDMilKbnlF7MQ0ios6veuUu3RyhbbNJBuSiJHSSuQ7v4x0pb8l/OEH
	 3TBRE/Gd6CAoubSe2FLmH8flmVsaReTkiQzRikyPcRAVF8v2EcvU2kGqAMIBN9vTUmwxu
	 fE/b4BxHZmekhMSw5QGKRQ0RW6oTxNSU51R3c6FnsHaKdXlnQ+e4iJTje6RFla/5hXLMZ
	 pbR2r/Nv7Odw+7Pmt1LlWXpWRJpPCWNwsMx+bAi7AfHYIb6GXV934jh+3YEp5ERk/CmFi
	 5OLcZKAIO4MiMztuYc/tEpljGwcs3Mfzoxoa+qhR680C+b+j/oFx9JUo8i75h8zMqsg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795083403;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=O1yda0oNcQ3dTlRMr9OgT/gY+usASYUmww7AeKEP0Go=;
	b=NoNJO/UeW/x5yVfJaVJOdvmriWiqAwz9nbngOwD8bH7vniIIGYUZwgtG0NSqljEy3pn/
	 TePvlx3hac40hhNEkG4RIzSnbaUq4AJusB/HeUJ1SegxaEjV8aMqrajHOccDmTFK5vene
	 5XcrTxKg1lQjkhelUqtZm+U8npGknxvkjyKlU+/8WIQGWPZVrpT3EOsiVDRsZcqFH5o5l
	 CkuvW4Edvs8AFfR9gmAsHmYyDekPq216DrebyL28sRtCRop1B+MaHh1Habr8uU/i5NHLJ
	 IDqGXkbH18f5Ob5/E2uz5SqIX5bDeAZJR2zYUMSvsIo6eYVYBmEtNc7qcnm4QWbpjhQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=lfYzBwxs;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.46
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0578606A32C
	for <linux-sctp@vger.kernel.org>; Thu, 19 Nov 2026 10:16:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A0578606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=lfYzBwxs
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-4a3e706b5dfso1297203f8f.2
        for <linux-sctp@vger.kernel.org>; Thu, 19 Nov 2026 02:16:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795083400; cv=none;
        d=google.com; s=arc-20260327;
        b=T96SJ7A4cOy0VboXmppPszEihBF1QrOz0BDRQo7uecQhKByyIQWA1q73v+11DMQM4Y
         FH0eXC6pklpCiAZVYWxxH6Cg1d9kCK9R6syeTLzU6fDzW4wyYYLPvEPXI+B0f2fBN6lc
         TQ3oVqxaIKsZkEo1gy1d9hWAiUs6JR9SbXX5wNP8QMX+Kp9nHMfU96q/MoVE5/Zx5yl4
         NRkrIKUaP3wpvCiytkr8jisoUzHT82J/F+gi7YsPDy3cjDBPghnWYvjvOInHJHFJ3FzM
         L8MopyMkkyJWKrDSpT5TVxKadJfOQ7+4/6uF1r9ldgUWy621DdXfa2akzhQKGtdXfIyD
         3rzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=O1yda0oNcQ3dTlRMr9OgT/gY+usASYUmww7AeKEP0Go=;
        fh=YFdqjxc3XfEZGTuaukKEboflF6KxkwTW7N1uc/H4byo=;
        b=jLUNSP3kkJXIrs6UksbJibAP6OPJEqNC8irIcuyomuwEmvxezXWoFSvAti7+VQYqri
         lB1h9F4YIXQZl/n2J1FnaCRodQuiW+KKYVe5toyk4evYwn34JLcNIxA9gH69uM95mQKQ
         RFocX05LUad5oE5aJRcO/uBUniig1QkJawB/nWHbgB9ji869/zV6Uww7AzeQPVTrMAFg
         mn8+wWwXCsIJRk6sGLRqrkiNBpLPA84eN4lJ8HSy96DFIYSbgAnfFMlLCBdQkJSR0n5L
         Qk5dYeRbcJEmSy+ykxe01QzvTE+s6q7vPUQ2OArpPdHF1jdTACrrv4vv/qoNq1lW7ZLr
         xXhg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795083400; x=1795688200; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=O1yda0oNcQ3dTlRMr9OgT/gY+usASYUmww7AeKEP0Go=;
        b=lfYzBwxsT9U7ylJXY0sfQJTL5g2+pJaJckEy3Jm7MMozfDKx1lk7v1M08TZl0ESbXw
         p8c234b17gzBV4Rp2pwGQa8FfFCh3MBxjQI3v6lALsKJl00SEXsDdFezGiQHqP880una
         fIWgf600eJxpSpqYjBRDt3oQxKagVBQ12XtSqE77+JJHJtv1iNjGFTa+LrCEy6kbfOfk
         5VwgWQ0kr54h21kXjzkY/CTzjz3SA1rIuKSEz0kV1jE7AHi2w4KU4EzZxtoXYreQaaMA
         oQy3lgYmE6vL/IuMcEiIvJKrGrfKzR7rdqOOBmss5pcS8UQ1MC7Xb6QTuPD33QN6zX71
         wEjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795083400; x=1795688200;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=O1yda0oNcQ3dTlRMr9OgT/gY+usASYUmww7AeKEP0Go=;
        b=j3QIuXlHsP5GaxSAie6fMxUzQU2KL5gkOGNEliAYPcPeHI/gG9f/N4hJrcHI3f9WZ+
         /6d1A9r6S+65duK5cBEjUHrOTmT1kENqJXQ7ZZgl06BhGhFeWJw9UvjMjFzNnlIwbHPg
         n3M8oGrIkDuJlRR496RRtUOyPWYka9Wm0Bbfmgex2y4P7sYn3mqQ7abths1s2Gbb6uCn
         /w6BxINjXFFXD+ILH2RJwZWX5/DTfV7n29PYMwnF7hT4rHEl+VtnVlSJYMIOFehmP/Pb
         Stfu02cLJyQyVDFXJE2ZdEZJg3nmnludR9GLZK5COAvMo37pRtAJA5DQ/7Rnc+Y1IMGK
         +DJw==
X-Forwarded-Encrypted: i=1; AL+hErHnKU6QdzJ4ynQgT6dKhHWVME+5GUL5IZrkN8cam5W/h6hXch9zB/dO3mF7vBu6eHQBr6ZFLE31F8n1@vger.kernel.org
X-Gm-Message-State: APuU4Z+MAUXKHLJnIsvz2L+/6kgl60JbUV3yLTwslhINOTSvv1u8kELa
	BeaU5JLPg65nEk0gCt8lo8FE+VBv/dPSC1SmSnYHY/OyEIzxmUIf0nau+oDtwUYwi/1GtozYoNt
	ceZp98qXQndynuEHh97wy9HwlbisTTpc=
X-Gm-Gg: AZFdTZdIoFLCEADRVJbrVACwiyU6sKl2l7jOj03p33OFcwfKACEse4j7vB+51NTJ+It
	pbjqiSYlUL+BX/FORzSo6XtcFF9iqTNMBQ1Yf6wbBm8TnoMQrhVKW1XdzJ3sKxqCoBp0JgzE5JN
	GRJjZ64vrf0uGOb8OChxRIgTHxPSW1yIxzQMf4qop/VQhFU4896HAx0CT+8rMy0rU6Ium4sDj07
	7eKxOZqY+MAZjCRxNC0n3x0ZD8stsVWKBTnS29QqF7jtVGT60QlNRkYDozuIDE93GM1iUXmVG6d
	oGuTAFOXEGOZdvOiacE0c2ds7emds0J7U+o4UoUbsiZtDlH0BFRTTruYck6mvbK9Omqg7T7OlAD
	WVqfRFixo0DXbEYf9qhy2RSyBXh/nOTPVBFI+imIVObr7M1TSLULcXi8Z3ps=
X-Received: by 2002:a5d:5f48:0:b0:4a6:5954:843a with SMTP id
 ffacd0b85a97d-4a659548d0emr11671217f8f.12.1795083399306; Thu, 19 Nov 2026
 02:16:39 -0800 (PST)
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Post: <mailto:linux-sctp@vger.kernel.org>
List-Help: <mailto:linux-sctp+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sctp+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261116033855.1792036-1-pkfxxxing@gmail.com> <179480061110.3291.15316004866558271126@kernel.org>
In-Reply-To: <179480061110.3291.15316004866558271126@kernel.org>
From: Yong Liu <pkfxxxing@gmail.com>
Date: Thu, 19 Nov 2026 18:16:28 +0800
X-Gm-Features: Aa3M54ogh544PGKFMgJOF_6_QyLKjCrKPu4i3Uzi_u-cmYcNt0aY1QGx5VWRF4I
Message-ID: <CAGAoTxxpSJgg9S0TrpKJ2uHSSpQMsbzWS1CbLAOj-qqnQPGsiQ@mail.gmail.com>
Subject: Re: [PATCH net v3] sctp: fix use-after-free after association migration
To: netdev-bot+sinfo@kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Xin Long <lucien.xin@gmail.com>, 
	Jakub Kicinski <kuba@kernel.org>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

These issues were discovered by Qihoo 360's Tulongfeng multi-agent system.

Thanks,
Yong Liu

<netdev-bot+sinfo@kernel.org> =E4=BA=8E2026=E5=B9=B411=E6=9C=8816=E6=97=A5=
=E5=91=A8=E4=B8=80 11:43=E5=86=99=E9=81=93=EF=BC=9A
>
> Hi!
>
> This is an automated message. This series looks like a fix, but its
> commit messages seem to be missing some information:
>
>  - How the issue was discovered, e.g. hit in production, hit during
>    development, syzbot report, manual code inspection, LLM or static
>    analysis tool scan.
>
> Please do not repost the series just to address the above. Instead,
> reply to this email with the missing information, so that reviewers
> can take it into account.
>
> *IMPORTANT*: If you do repost (for other reasons) - please include
> the relevant info in the cover letter or commit messages.
> --
> The evaluation is done by an LLM so it may be wrong, if you think
> that is the case please reply and explain.
