Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C5CD35E1BD;
	Wed, 23 Sep 2026 01:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790127676; cv=none; b=kZLHZ6lCam73FSG7RXEyt9lQyyiB68xcyzQ/apHmX0IZTLiimHhkXwgVWOuNWib2xM9E4gmYuNZT2mwHp/B6iLHbrxZi9JwvmvAwXyGEtsxUWKMalncNxIKmoIEhhgzS/foUc3nfxsHUORrBqquS//xC1/BgBloFp7nRb5smJuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790127676; c=relaxed/simple;
	bh=KiXmkd04zIsbMohMQpIZyFcCWd7UAaRQyljY9qo6oAs=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=BWffjGrtm41LAca+5VXUi3uLzEBwPGvdP/1cEKotGFaRxP7kj4WcaRo6eMaG5vD+MO4Wy/bkJTVoBBBzeAKWESsSymo6meoxj9mTWAq3j+2vW5cNlz5v9KX1bqMMHL9iFntWJ2fbE/2a2qSZyYi4CuTW4Dy3M8kqxjQUDVHCFY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gbriLNn/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gbriLNn/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 416E91F000FF;
	Wed, 23 Sep 2026 01:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790127675;
	bh=+XC7UpNvlub8+g4abzd7fnYUdwJ3E9mvV38izxIKMkA=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=gbriLNn/sq+e3woya4HtM35a7AVJY/xvngCZ5/vnTUdH58kpSfLA2lSNRKoQUWFtE
	 pVv0isND8ELRNiTZmcXkvROi8qOn84bqOW6DTPQgyNQ+vLH3n7bd5zAhljPoRYr3gH
	 YRjNE/We7LFhopUjdNuriv7GShEF+uJ5VLyNW2gtdc+9yTY44r9sjdl21ZnftKEC2d
	 aHq3FnUzIl8I9lew7vNWtz+lY2/2UI3Lnyg5obzpN1oJ1+JbOckeXAzj5GlJc2wt+U
	 j8hB4gem7qL1LzzrQV0ln12gX21FHxOz/lgSoKaoU/1DLjvKG1CUgsxRR0tJA7kbha
	 AdclFz/NDbbhw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 19A313924463;
	Wed, 23 Sep 2026 01:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] sctp: discard the rest of the packet on a
 stale-cookie
 error
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179012760572.167190.1940324637591255242.git-patchwork-notify@kernel.org>
Date: Wed, 23 Sep 2026 01:40:05 +0000
References: <20260921093707.1432184-1-ljp1205831794@gmail.com>
In-Reply-To: <20260921093707.1432184-1-ljp1205831794@gmail.com>
To: Aohan Mei <ljp1205831794@gmail.com>
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
 marcelo.leitner@gmail.com, lucien.xin@gmail.com, imv4bel@gmail.com,
 henrymei@tencent.com, corvus@tencent.com, stable@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 21 Sep 2026 17:37:04 +0800 you wrote:
> From: Aohan Mei <henrymei@tencent.com>
> 
> When an association is in COOKIE-ECHOED state and the peer sends a
> bundled [ERROR(Stale Cookie)][DATA] packet from one of its non-primary
> addresses, processing the ERROR chunk takes the non-fatal stale-cookie
> retry path sctp_sf_do_5_2_6_stale(), which queues
> SCTP_CMD_DEL_NON_PRIMARY while keeping the association alive.
> sctp_cmd_del_non_primary() removes every non-primary transport -
> including the very transport this packet arrived on, which is still
> referenced by the receive lookup and shared by all chunks of the
> packet via chunk->transport.
> 
> [...]

Here is the summary with links:
  - [net,v2] sctp: discard the rest of the packet on a stale-cookie error
    https://git.kernel.org/netdev/net/c/4498467a8af0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


