Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795798909;
	b=hVp072r1UfIVtzYlT1MhFCy0U93OEx9cZ21OsGPRXwtaHjHU/ZnOm+fOyOhtLXnJMaHu
	 AtiJF+B2D1rEoj9RGoQzBNmJVSd6zbsCJp2JtIjU9/DGCJ+Pw5NSWXAwIN9uqwIa0wkci
	 vSaxHaKoOxLhBDw/XpVxhWapbs+d6Q9pLFsF+GlOiji1fkBDHICysLRu0lBRFuMnuaUIK
	 pgsknHP4VMAyd5TM1DWv3IRwT4ZdRgbC5SYPjePtmAHJDRn5bHtaQqHIrSAXtRuJekc+f
	 5KsOXJyVohmzskMS5bzQ6MsuzdzmBDgZS3CQmyy6R5X2+HvYNU9CB/7NaFQEJopil8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795798909;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=+6RompY1HbfgtQmh1megrHiasfsgs35Bk9+9yv4xJ6E=;
	b=LCCowecUclJKfat4i4YsIZw1XZEFLdwMg1ocmYb+Fy0GP6hVwpikCb4SUXHLSnXOktJw
	 A+eXJySfAnPVqf9KNK35Ar9VNZP6cS6zABrUeBl8dRZvcaFS0ATnC6k36PkAdM3BdGnlt
	 k46VSMY2w34Px9kqErRsqvLmE7ZNqoZKwPiORngJCi62Eb4YNm+CSKYeX0l7z/SVK+Pro
	 zRcEEA8DXztIi1FNGySOW8T0O9cC1hXPjBupInCyCwUBCSmLfkq2yYA4qeuL5dvS8fHSy
	 LkVOvF5jD7M4WskKTj5NaeSmEiw8A+xlu8dm+9WhVGmw1WzpuduRxJAJsdWsYfrBjWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gFOAijA0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D007F606A31E;
	Fri, 27 Nov 2026 17:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gFOAijA0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E884A1F00898;
	Fri, 27 Nov 2026 17:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795798909;
	bh=+6RompY1HbfgtQmh1megrHiasfsgs35Bk9+9yv4xJ6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gFOAijA0FIlCXTbAhXaPZVJW6xu6TtDJad3csTL508rWHHp6grVpHxPApRudvRz7J
	 XY9ufnAZKCdSXDsfCtReIWAeRe//4vStcxYsByTHlW/OPLqr6Jp7gt+5BsvF1gY2C4
	 WhSnMupiC2BkYrpXTP2qz3QMXCzm9dScOGicFoYIhvrIDDM2Or3x7Jhwx3Zmkdh6qE
	 eL5xx3z0MxqCH78eKgE5fr3COhTWnKNqR+vMZ87rK5/HG+sRe6TXmzYvWleN0HcuDu
	 3CY1JemFvMPkUbupFABmcKFius1EFDK+thn2vw4KBsUaH0Pmy+FV6jFEYVnUg6+KAP
	 50uw62ci1nxFw==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	edumazet@kernel.org,
	horms@kernel.org,
	jeremy.jean@oss.cyber.gouv.fr,
	kuba@kernel.org,
	linux-sctp@vger.kernel.org,
	lucien.xin@gmail.com,
	marcelo.leitner@gmail.com,
	netdev@vger.kernel.org,
	pabeni@redhat.com,
	Artem Dinaburg <artem@trailofbits.com>
Subject: Re: [PATCH 6.18.y] sctp: validate cookie AUTH state before use
Date: Fri, 27 Nov 2026 12:00:57 -0500
Message-ID: <2026-11-26-1-daily-reply-0009@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261125203010.67858-1-artem@trailofbits.com>
References: <20261125203010.67858-1-artem@trailofbits.com>
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

> Validate the cookie's RANDOM, HMACS, and CHUNKS parameters at the cookie
> trust boundary before copying them into the association.

Queued for 6.18, thanks.

-- 
Thanks,
Sasha
