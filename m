Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794873006;
	b=5dpXCgwgRFpvt84JDkkzsKZTor4Vh45yebIQN1Q1Y0mj56eTY1Sk+HOtUadyRpZOFugs
	 fulcjWUlnbkpH0g4Q+mvxIt5nVtG7WuRVQVY46aaPVyhEOnRHak4hVEcmjJ5tEnvqA8SX
	 GyEOds872/lVmmlrIGm4V7e8QQ8PnrWffa1EUIBrC+i2lqrJiz0rWrOW7eKVhtNthj9+i
	 dsioVxU/3KuQPPYCIHnLNPd5BwpUDI3cLMhWQX7PDdHvaJrtOHOzohYs2gNO4jUM1sHpx
	 g0BC/q5vfbXK3gI97oXNZMf/2yEZCUcKy30iksoJOqNArHsKtN6GQuOrz/Jy1/E8BHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794873006;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=H5PEbT44AMh96DEOsaYSsxRntcOvO9oCNPKiBsM1txc=;
	b=XiAIVcQIrXS3dqDT5iU+xt6uHbbgzZm86xMluxcA5bmKOaKPP1lMSyuj6L2xzrRX3EwW
	 La+wH6UbIjqF/UMO1e1VAEaNTnqZubHbmJtYy9KO6a5PLHKjOJcZPu48V7x40cQ3sGNxg
	 gVumscmOhLSBI8n/oijlxJuP60d3BLFPdLekFxbuPl9pVQXFUjEPZCJNU6j7XW443z5Io
	 aNgMb6BVcsnM+CbZZewrxPhad37Jn2lg+xSWmArt9WXHfuuDCZT/HZilOrz84++3pZtTz
	 R6EuTPrp0FxNa9bhYlABLne2pCfNLS1sGLYGT/WxeJoKRvihYX/u5NC1hMlJr/lT1oQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="UtEK3E/Q";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EAD0606A31C;
	Mon, 16 Nov 2026 23:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UtEK3E/Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0785A1F000C7;
	Mon, 16 Nov 2026 23:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794873006;
	bh=H5PEbT44AMh96DEOsaYSsxRntcOvO9oCNPKiBsM1txc=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=UtEK3E/QqODJRgPB03hTllJdzvpes5EKtBvDhwlLI6ersXEi78YkMDv1XRCoeDuux
	 mpaGITGIu51A2tgw0+eivEtHDy9V8e3E6s2dG7LbE5rhwGaHVbro6p3OoueGMfR4/T
	 nTi0QDue1559zuim+Yp39URaDPn9Thmh+InHjQw8LaH92IthTgcW8FtLAuuZv1CGXu
	 nVvNsPU52j9DuBPocSgUn4mnuef6ysjbbMCYv5PYWIpAFyK755UnXNyDru2u+S59X0
	 FRPJNma/C0561hh/StnIKn17SIrPveuVM+LFECQwP3dRNIUIdmnNlEhFKLd4h4ovxD
	 h2zSRDK5RpB5g==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id F1490391B059;
	Mon, 16 Nov 2026 23:50:05 +0000 (UTC)
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
Subject: Re: [PATCH net v2] sctp: do not free a new asoc peeled off while
 sendmsg
 slept
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179487300478.245276.9003831986413993562.git-patchwork-notify@kernel.org>
Date: Mon, 16 Nov 2026 23:50:04 +0000
References: <20261112172149.27355-1-yves.bieri@theori.io>
In-Reply-To: <20261112172149.27355-1-yves.bieri@theori.io>
To: Yves Bieri <yves.bieri@theori.io>
Cc: marcelo.leitner@gmail.com, lucien.xin@gmail.com, davem@davemloft.net,
 edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 12 Nov 2026 18:21:49 +0100 you wrote:
> When sctp_sendmsg() creates a new association and sending on it fails
> with anything but -ESRCH, it frees the association. The send can
> sleep in sctp_wait_for_sndbuf(), which releases the socket lock, and
> meanwhile another thread can peel the new association off to a new
> socket. The wait then returns -EPIPE, and sctp_sendmsg() frees an
> association that now belongs to the peeled-off socket, without holding
> that socket's lock.
> 
> [...]

Here is the summary with links:
  - [net,v2] sctp: do not free a new asoc peeled off while sendmsg slept
    https://git.kernel.org/netdev/net/c/f2540da93a11

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


