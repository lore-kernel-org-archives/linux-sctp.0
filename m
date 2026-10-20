Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792522854;
	b=ZwEp3xY3vlTV3hI1HwdcL+2MWo5mBBQ0ArOflo2q4aU8bX+QbHHz6TFNRuASvs/I92Nv
	 3QjmO5zksn6hQJYJ4042cenKYH/WasMQF/xwF/Lk9zUcgVPDfeUzHz1hczp64byxuWG7Q
	 vEmv6TjIhD4w2s02pJXZlUIdZEeKo/PeWal2XJdyIdsw2QxKotWpT94SXVEDdKswyZBmC
	 q0AclysG0taySXx0HGwIJucmu8ClkxGKJ1l5HQmVvCWlzV4qMGlsA/YN1el8GIgLr0TfY
	 VqyOPWK3kSGJZFzjtALE00+PTJ4NiGJRNnRJ/PZPWohCcpO9x88NhlZKdPvzdbbDbEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792522854;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=doFwaVtFpS6sC4IuXaKfGyTb696NhEj7zirNI3zBSPk=;
	b=B1YHYY9fuw6tUC3k7EUj15NCCvtJhsHH+hFV2iNjpB1k4v8Vu6kdCcXbLLiuP6nQFCty
	 Ty3qI26U2Oktka39lc6fqiY5v7u4divoXWhIYVUAqKUhel/dt9q45LdTG4XZvB1GEaj+0
	 fUYfesFmMWTpYozTeWVC6Y7nZ+SqbYFUdUPdPK2Lvyo70EOLkvbu7SHrhzfWf28EHvRo+
	 GHpFkBfCoYDkEPGrVrOg7p/X3kEW/Xry5g4UCVr1wRCyNhv9leZ/zKkJ7iXDJLok3rE2M
	 nqGZQdqNLWZBDCCOex7f16gj7toWkRWn6dPsisBBlNPS0Gpx4Z7CwCoMdgjC41/SEWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nFmWSkIZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9CBD606A32E;
	Tue, 20 Oct 2026 19:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nFmWSkIZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46E321F000C9;
	Tue, 20 Oct 2026 19:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792522822;
	bh=doFwaVtFpS6sC4IuXaKfGyTb696NhEj7zirNI3zBSPk=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=nFmWSkIZRpkljVSa23s6GPJ3aVIW5bIoTnLHx11JdS/V7eYtdXgjiNhXDsgVLmC/O
	 u+AFoyP9sQoc5dZ0l4UCRVYYMNAPcBsoor0gCI7bZIXsBsI+jxaA5fjBNGQoNk/UcA
	 U0HVGNjRC4Cq6kmD+gWSo9XYiQx3dXVYyZWF61RTmDmq5uPBXwr4iJy+gwCgJN3OQt
	 zHIlSNFSl9131/EhLdLyd1T6AoUUE9J4kjC9BHVNqhPc2MUle2iBf3bKw4fehQ11gd
	 ZLpEN5thUzwNIbwODsWVqSmZ3S1RaBdfxycFeTJ3TvcHMUrDUlsLEIzmxrqmFvhK/4
	 CY+PdAjm1i3Tw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3A4EF3808209;
	Tue, 20 Oct 2026 19:00:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
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
Subject: Re: [PATCH net-next] net: rename skb_unshare() to skb_unclone_full()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179252282077.159319.7792031411876485115.git-patchwork-notify@kernel.org>
Date: Tue, 20 Oct 2026 19:00:20 +0000
References: <20261015-nb-skb-unclone-full-v1-1-0dfbf01f60f2@tipi-net.de>
In-Reply-To: <20261015-nb-skb-unclone-full-v1-1-0dfbf01f60f2@tipi-net.de>
To: Nicolai Buchwitz <nb@tipi-net.de>
Cc: Raju.Rangoju@amd.com, PrashanthKumar.K.R@amd.com, andrew+netdev@lunn.ch,
 davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com,
 ioana.ciornei@nxp.com, sgoutham@marvell.com, gakula@marvell.com,
 rkannoth@marvell.com, sbhatta@marvell.com, bbhushan2@marvell.com,
 maxime.chevallier@bootlin.com, mcoquelin.stm32@gmail.com,
 alexandre.torgue@foss.st.com, sd@queasysnail.net, horms@kernel.org,
 marcel@holtmann.org, luiz.dentz@gmail.com, olteanv@gmail.com,
 alex.aring@gmail.com, stefan@datenfreihafen.org, miquel.raynal@bootlin.com,
 jk@codeconstruct.com.au, matt@codeconstruct.com.au,
 stephen@networkplumber.org, jhs@mojatatu.com, jiri@resnulli.us,
 marcelo.leitner@gmail.com, lucien.xin@gmail.com, jmaloy@redhat.com,
 tung.quang.nguyen@est.tech, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
 linux-arm-kernel@lists.infradead.org, linux-bluetooth@vger.kernel.org,
 linux-wpan@vger.kernel.org, linux-sctp@vger.kernel.org,
 tipc-discussion@lists.sourceforge.net

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 15 Oct 2026 10:16:38 +0200 you wrote:
> skb_unshare() only copies cloned skbs. A shared skb that is not a clone
> comes back unchanged, which the name doesn't suggest. The loopback
> selftest hooks got caught by this and hit BUG_ON(skb_shared()).
> 
> Rename it to skb_unclone_full(). Like skb_unclone() it only acts on
> clones, but it copies the whole skb, not just the head.
> 
> [...]

Here is the summary with links:
  - [net-next] net: rename skb_unshare() to skb_unclone_full()
    https://git.kernel.org/netdev/net-next/c/258c3ae4a4af

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


