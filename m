Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.175
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792992468;
	b=3zlQzpGR8WYz0k4vzqihQuotcapU9bAt3coHXI8/wcZJ0wUixiKem/3nouIZrCpJsvPZ
	 kwMlSLF3uhy4JbYGA4vQCl1vBzTZsynL4Bg7Q31JA0mLCn8XaFaVn0uURr0CvmZJIDlbJ
	 D5tMX6V3TGQOd8CK0Juz2Z2oBjV6XKhNC861E7X9slpdsIJzeuOd1QBElWIcpDmXmEM0+
	 mLiFiQ344TQGhrIDcUl8Pm+ciUFOZ/6vfxiZt3VCgGhSgZ95pdecoAOKtDztLIo8wFyhN
	 oQORRrcec3IJLI2IvRalcy5MpZIJ+40DNqlwKzLTMHepejbTwHB3tqFz/Y5qi1my35g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792992468;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KJHbuu9YNunQc2098aJOeh/4wneftBInLaZd5ecyQ20=;
	b=rOfBf1HScmKymwvHqeXMDprG7mdtUjNL0QuqcXzj5fQV/+fsfz2iMwJThIj8sQS9Y5T1
	 Ysv/CoS64raVOpfjcpI15kqgGVRc/VztMgtRIxMvhhR/AbCzZjkencCv7ia3T9D3FHiTr
	 RLxR/y7Mi1zAx8weVWVXw5xMqkuusWSDvHQNyzXmwnTE+QQ6s7Fonx5LaPcAE5K26Q7hu
	 IPUxKOhLJ3icgdSDwr4h/DQDveEi5bY3SnQktZA5dhRkXptHwGwgpIklaGqgfK/N++BEM
	 RhMq2ijGxj1RKhH3pV7iXu17cnrsi9lgbDlssPnIeNkSF/1IN2IE5mfJLSzQ+l+RV2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=cg0E+dri;
	arc=none smtp.remote-ip=74.125.82.175
Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC960606A320
	for <linux-sctp@vger.kernel.org>; Mon, 26 Oct 2026 05:27:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EC960606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=cg0E+dri
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-354ba08cfd1so4798682eec.1
        for <linux-sctp@vger.kernel.org>; Sun, 25 Oct 2026 22:27:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792992467; x=1793597267; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KJHbuu9YNunQc2098aJOeh/4wneftBInLaZd5ecyQ20=;
        b=cg0E+dritt0P6TfxAW9Q255khPeEmu+69fU8a2+/61exzipudfLtte3lz6pHT99rWJ
         NYh0W4TJ029dbTawErQ+RMpBmQSz611482As9+CYIbrL8/dA1OIcBJkDJUQtVhq3uKft
         8Xho4cBVbfyF3g1PoekWa2iOGxAm3ryDdP3tigjYTJU89NCwQVhS7FyZ/CTgfrLFDkts
         rbNE2r1zXGpM+8Zn07zrtdJ8ntU6kprsxSvad4T7fL3WFTq4nXGqK89wr56ZdHihhPSN
         gebvQ1afjV7bvIobenNv1K8k5v76Yd6zWZXiWvWLM4QKCNB62wf5aWZ1/f3BsqpjZdOV
         NA/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792992467; x=1793597267;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=KJHbuu9YNunQc2098aJOeh/4wneftBInLaZd5ecyQ20=;
        b=JvVHWyX2uMvYcjJ867T1doTgT7rbu3GLp7lHNDon9iFflXgi2pRkx+a0NGyLibUXkX
         hpa9ZTHHFBrJIabaci2CsfhEU1HlvKbSoOpN6DNd2rjU6vbbGJTEUTP/hDLq3NkGKiQj
         CAUXtaqVz3gbvwIfUYedbeUY/19uCFMZkQbksx8oPcDg3wn2aXAkoZ8+x32SrcB+1YjT
         qX9VJCepDfwTTC+cUIsFsTl+tYPRZRojft3kgQOI//w5IAR7a1wn81pcwDHwuNrjGZ+0
         kBzeKWhXibtjTHiHRUUj5l3KtkNLkdfvnh095U/nf7R9L1Emg01jCjvLbdOWWC8Y7cE6
         4T6A==
X-Forwarded-Encrypted: i=1; AKwUvBziG//KENDxyqbb/49KBfpa936EtVahJqCU0l7A6SLDkjJlKTilCDgZsldgk/RiZ0Pn6N4252gfA0iK@vger.kernel.org
X-Gm-Message-State: AFq9FYICtgKgj8P4bqk0sBINH38OEfLjoPbULPVMUmO6Chptg7XHELOM
	rDJmZM2CUikuUCID7Qth2/vy2O4XVQ4ZAa4Dcfd6B79tjZvPXt0/JCA+
X-Gm-Gg: AYBFou3nJaRAtH+0M3dFDm55cRppAOiZgQ4Wn5MH9ArZtgLnlUI+hejZz2H0j5vkucB
	OGgjb0C+hpGJhfo/pnmh6h7qStUzE2Cr2WIF9h+UQzRARLIUp4yA1XQbKJFjyLrkhP+XEcCW8Hr
	b+5unEbfiKSJwCkzLsHV3b03q44WLbKld0mPjHDpKVnesiA1zySXXLZbRJxhEyufcor6oNY0YPo
	QdPWzH2i26v0UT8FwjJD/7SjlS6hF81ffBve0BAtVOd0uxmTiL3ifuQv4PqdYs8zHudZGKoLT7D
	6llLNCvGXoprYmd3CFe6g5jMFQz/+afULMoN6lYJY1CDN3AWZZ1uZZdS0eT6bVRP5Ph3XvKdeU6
	uvUzHF+QEa8ZwfJz6xWh7e9+J5H6y1HI5wzcuG1NcGXiKyZi2RITNkPp9E3j5Rjqlp7+46GqLYj
	ExRAlXcTDA/fltTKtb8PjU8ki3S6xL7IafKp0V4Lyqv+wkJ8414V3AOJe61fIsGVgi6OhaIs7SV
	lPyrNn7KpFZp0TsfpQ4QiM7Koq29A0aVdhoUb08FlAfk+6giMw2OP3hGXB6ZagFCFc6aCVJXy7P
	jq/7WmJN0H2sxL6KhHxoz+fq6Q==
X-Received: by 2002:a05:7022:3a09:b0:195:76af:b810 with SMTP id a92af1059eb24-19935fc69dfmr10272975c88.25.1792992466519;
        Sun, 25 Oct 2026 22:27:46 -0700 (PDT)
Received: from localhost.localdomain ([136.25.42.214])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1989ff2ee69sm29188566c88.4.2026.10.25.22.27.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2026 22:27:46 -0700 (PDT)
From: Tim Budding <tim.budding@gmail.com>
To: netdev-bot+sashiko@kernel.org
Cc: netdev@vger.kernel.org,
	linux-sctp@vger.kernel.org,
	lucien.xin@gmail.com,
	marcelo.leitner@gmail.com,
	davem@davemloft.net,
	edumazet@kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	shuah@kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH net 3/4] sctp: don't treat an I-FORWARD-TSN as an association reset
Date: Sun, 25 Oct 2026 22:27:40 -0700
Message-Id: <20261026052740.187459-1-tim.budding@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <179293012867.3134.16497481637722705271@kernel.org>
References: <20261024120627.837568-4-tim.budding@gmail.com> <179293012867.3134.16497481637722705271@kernel.org>
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Post: <mailto:linux-sctp@vger.kernel.org>
List-Help: <mailto:linux-sctp+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sctp+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sun, 25 Oct 2026 12:08:48 +0000, netdev-bot+sashiko@kernel.org wrote:
> [Severity: Medium]
> With this call gone, sctp_intl_skip() now sends
> SCTP_PARTIAL_DELIVERY_ABORTED for an I-FORWARD-TSN at the leading edge.
> Is the pdapi_seq it reports still the message that was being partially
> delivered?

[...]

> Could sctp_intl_skip() pass sin->mid_uo (unordered) or sin->mid
> (ordered) to sctp_intl_stream_abort_pd() for the notification, and
> keep using the skip MID for the flush and sctp_mid_skip()?

Thanks, this is a real bug. sctp_intl_skip() has always reported the
skip entry's MID, which is the largest MID skipped on that stream, so
for an I-FORWARD-TSN below the leading edge pdapi_seq could already be
wrong when more than one message on the stream was skipped. For
unordered streams it was wrong whenever the abort was reported at all,
as the old check only fired when the skip MID was larger than the one
being delivered. This patch removes the path that happened to report
the right MID at the leading edge, so it now shows up there too.

v2 will add a patch before this one that does that: report sin->mid_uo
/ sin->mid in the notification and keep the skip MID for the flush and
sctp_mid_skip(). The selftest will check pdapi_seq for an I-FORWARD-TSN
below the leading edge that skips two messages on the stream being
partially delivered.
