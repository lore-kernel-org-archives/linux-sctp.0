Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99D533E63A8;
	Fri,  7 Aug 2026 22:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786142448; cv=none; b=J7cumthtELOaa2CtrVIz1Uv+cRis0DDfEizlIlOF2sSMgitLy1JmOzwpLoUSP2JJ5CYP3IT7SI2SWhJTrcosRQ6036Hs7oxWd3t/UchC8qgSvf7sI/npM4pjKCeXz7HBTp+qv87jmvelRFalxEQeOECu00ll9Xe2yr7OSf9bDkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786142448; c=relaxed/simple;
	bh=A3OZ4WheXYBiqLennK8dtLcO/X1mvJl3ED4jUxiMNKg=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=PXrs39qb+CsrJn+ibUaiC44Qe1jOmfBXlOgOuLzb22O1bsyPr5YE9W1IEDP1NCf5+KNJowIYA3sW2XrYjL2LUI4kBPJXx+Gt/0n9UZRebWDneuuBj2rfeoqq6KoSXEU6TbEIPROj+iaY8Cmn4+EwYVjbFzG2PCx5QUUYRHgkX4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O6bmzbxk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O6bmzbxk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FE731F000E9;
	Fri,  7 Aug 2026 22:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786142447;
	bh=dO4+NdII2HSxAD5U6y68CBY3wcvoSD59ZLtUerF+Wtg=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=O6bmzbxk22ENVd2FfLJffnia8MhgwyY7eBjrQ50DtxBMex07FznAACZyXpe84dsjF
	 pkqsRN2KKWK3zhckojfzaIkY0qPDAAnmDryHUJpcPDss9Wh17M5HVfggLFVKfqVm+i
	 mSWPxUhI+8PdKmqFBigHgc8ypcK+Tuu0o5rA/qmSnNX0XtAEM9y1VmaH8lZPeqekfs
	 q9DXQlDonHGtylxwV5trh2OF3ZS2m7nO/v0fNpKi25/Uq2MyQH6sST1e06aU7qxTWZ
	 U1wggtzy0lF1qtYW6+D+oFtNukdOJKtQGdFxTZaYXMW635bscxvGfQMbA+zS6VLvZu
	 HLS4Fz1oXzEaQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 19772380CEF9;
	Fri,  7 Aug 2026 22:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] sctp: validate cookie AUTH state before use
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178614240590.2445639.1288172802373951589.git-patchwork-notify@kernel.org>
Date: Fri, 07 Aug 2026 22:40:05 +0000
References: <20260804200042.2412009-1-Jeremy.Jean@oss.cyber.gouv.fr>
In-Reply-To: <20260804200042.2412009-1-Jeremy.Jean@oss.cyber.gouv.fr>
To: =?utf-8?b?SsOpcsOpbXkgSmVhbiA8SmVyZW15LkplYW5Ab3NzLmN5YmVyLmdvdXYuZnI+?=@aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org
Cc: marcelo.leitner@gmail.com, lucien.xin@gmail.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  4 Aug 2026 20:00:42 +0000 you wrote:
> When cookie authentication is disabled, COOKIE_ECHO restores fixed-size
> AUTH fields directly from peer-controlled cookie bytes.  A forged RANDOM
> length, HMAC list, or CHUNKS list can then reach association consumers
> with lengths or identifiers that were never validated against the local
> backing arrays.
> 
> A forged RANDOM length can cause out-of-bounds reads during key-vector
> construction.  A forged HMAC identifier also caused a 32-byte write past
> a zero-length AUTH chunk, providing a primitive for a local privilege
> escalation chain.
> 
> [...]

Here is the summary with links:
  - sctp: validate cookie AUTH state before use
    https://git.kernel.org/netdev/net/c/3dbb44d88b1e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


