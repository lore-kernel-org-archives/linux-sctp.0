Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795140096;
	b=BbxTLrmD24M4NOGik7bCjGdX1DV4y9QQc3dnA/B1UpK55kFxCfKsarjwmQc0HflzQYHH
	 MyE1Ju9C2x134hI2BgFp+UqNRKrjKoxGgAiIm0KrA912bzqBcxu80FiLv91iLPs+IvbEA
	 JzZkollhIzq8YnQhaWFR4GwrKpQ2nHdaVA/g5iDe5hEJCfycIw6tycbb0HHp3x3rZzR/g
	 mqgIno0ME7u09O7qUzlF6VE4d6He17CM90hrmFs2w/ru+ly9/zuJgZNOcEk72rMM4wnoM
	 Xi07nyexo6K+rNrVRzYacGJ562WUNMNILNk1F1b2KKY9HjuP4nK96vsksIbgZjvABgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795140096;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=wSLmnlVttOtNFc4eH5xNqse3tXgTbz/C0DN03vgVe5k=;
	b=N8KjEGegaoGaFRugGnGARw3U4aDQyhljA/tEOojaDi/WP6s4FWCbiaNLl0RJ1//s3fNr
	 UbHXY0zpFPSDd5h/Joo6U4Xuec6T2ZyE7Cs84RKJV7+uzM6cyixw+w1HfwN/4jB8Wr71s
	 fwkAezkqz+NSp4PtQ1NTpIEcb8A+l2/PUUlXEUdphZNxmkCSzI+tCWYeVu2cq1hRxuxSQ
	 B9gfAWlLT4vME7hNIS1RNVGEI3sQrl5XwYWLGbcF+hcued1FZwUP/XAe97DjdtyTeF722
	 F1pLjxIvQzMZB8GsnV9iYjo4vdXl1djB7KB/1ZIyVZ+dGpjLyWzxnkQvc7NwQI8CY8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d5UM+DTq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4911C606A320;
	Fri, 20 Nov 2026 02:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d5UM+DTq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9992F1F000CF;
	Fri, 20 Nov 2026 02:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795140095;
	bh=wSLmnlVttOtNFc4eH5xNqse3tXgTbz/C0DN03vgVe5k=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=d5UM+DTq5pBXfzn9HusA9Yj0U3ihEutwrpHlGeUNUu+yAjRFPATpgUG/+NwQg91oP
	 WT6q4/cb3IjN4rWyvFhaAC7KmGfBf1ICde8yHpX20sE9qG8crekY86fPHjm/C9UCnx
	 X/rVnFYqodzvbw6bxjSkceXaVotPHqtzKzhEnGVKxBgs/gLyraTIVbNV1W6nFsI1sG
	 fSX/fwkkTfEiEAcTUhqTJrD/Of3iPj/jksebDvfPSoQ0JnO1IPoU0dTz9NcVbKy8eK
	 WB2JJIbYDwPTl+xJqGhUup7zqtMwXYIy6vv5GTRFWonuT9eE7RiQmP63VcarXxutTZ
	 mquF+1qP2rdaA==
Date: Thu, 19 Nov 2026 18:01:34 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Yong Liu <pkfxxxing@gmail.com>
Cc: netdev-bot+sinfo@kernel.org, Marcelo Ricardo Leitner
 <marcelo.leitner@gmail.com>, Xin Long <lucien.xin@gmail.com>,
 linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v3] sctp: fix use-after-free after association
 migration
Message-ID: <20261119180134.13b67f15@kernel.org>
In-Reply-To: <CAGAoTxxpSJgg9S0TrpKJ2uHSSpQMsbzWS1CbLAOj-qqnQPGsiQ@mail.gmail.com>
References: <20261116033855.1792036-1-pkfxxxing@gmail.com>
	<179480061110.3291.15316004866558271126@kernel.org>
	<CAGAoTxxpSJgg9S0TrpKJ2uHSSpQMsbzWS1CbLAOj-qqnQPGsiQ@mail.gmail.com>
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Post: <mailto:linux-sctp@vger.kernel.org>
List-Help: <mailto:linux-sctp+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sctp+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 19 Nov 2026 18:16:28 +0800 Yong Liu wrote:
> These issues were discovered by Qihoo 360's Tulongfeng multi-agent system.

Please say "Discovered by LLM" in the commit message when/if you post v4
The marketing name of your tool doesn't belong in the commit msg
but the info that the LLM found it (vs you actually hit this as a user)
matters.
