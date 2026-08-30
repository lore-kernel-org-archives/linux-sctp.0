Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28C39329E7E;
	Sun, 30 Aug 2026 21:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788126095; cv=none; b=ftVrhBkEt5OTCjFre1U6JXAuMkqUEP3xQZdvgeYFWWulNH63Jg1+gmWaF2sd4bK8jTCmHJNj/VYFPV4aqom2luXfxu/JEqe4T4sxZTA8gVShqNArQnkBrEMxpMNDZG1hy0CQroyt/71dcDuQeM1/8BWVK/5vsjdBLXG9dMcz3nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788126095; c=relaxed/simple;
	bh=zOYCUARD93lPtw7NXgNFV/eXTioVquewPvb62kGE9yY=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=bGv1nTmGixsY27CYsWIItrfbstYXJplIum4JGmNNbchplnpcIxA9azO51ZYaR9kN5yTscTIOsD+fJYnZNgBTPGwhxyIDnlLK7/QmXQkNqt8nfr9ha8azkDR0BWx9UaQBLlJ5cHoQR3r3owdFcP9QkgJVYybs1z2/rO0xkybfm3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A9JArc9J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A9JArc9J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B0F61F00A3D;
	Sun, 30 Aug 2026 21:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788126094;
	bh=NqsX4h9UpYgw5WV+4SKrC+IVJjyWBaPZLUn+Vpt29pE=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=A9JArc9J01N+TjVWaeylqVnA0QF3/ItnzcbsM5Nrz4HPjr7pidUjwujggAlsrJwK2
	 XwUfVrrRd4kZHY7hhartkhkmqgEGfUwhXWDa3iuqMCaUMlXSm/qZNUNmLzEzVunUk3
	 7AHIbygFqmB1/38u59GVfMmprDhLMw0c0/SAGXt1MvOkiG4TKS66P79qwNvUhmuSwL
	 0lTetE4+pLQcd7t+TE6TF32q7LH0c0KREnf7LrnoH0X8IZiN9L3CI9zm8lxMEE1aMe
	 UeAnw9eSfl7/ZQn5t8HJNwNwBIiqlxAEjpchpbiZ+r5mB+72eH4YDWLiK21ed0N75h
	 8hVOSk9qg6tlg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D0970380CEF0;
	Sun, 30 Aug 2026 21:40:38 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] sctp: validate chunk length in the inqueue parser
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178812603739.3466124.2035019259212704477.git-patchwork-notify@kernel.org>
Date: Sun, 30 Aug 2026 21:40:37 +0000
References: <20260827-sctp-zero-chunk-inqueue-v2-1-2e7669c6a6cb@gmail.com>
In-Reply-To: <20260827-sctp-zero-chunk-inqueue-v2-1-2e7669c6a6cb@gmail.com>
To: Charles Vosburgh <theminershive@gmail.com>
Cc: marcelo.leitner@gmail.com, lucien.xin@gmail.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 vladislav.yasevich@hp.com, linux-sctp@vger.kernel.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, security@kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 27 Aug 2026 17:32:53 -0400 you wrote:
> From: Charles Vosburgh <theminershive@gmail.com>
> 
> SCTP chunks always include a four-byte generic header, but
> sctp_inq_pop() currently accepts shorter declared lengths. A zero-length
> chunk leaves chunk_end at the current header.
> 
> When ASCONF is covered by the association's SCTP-AUTH policy,
> sctp_assoc_bh_rcv() can continue before the state machine performs its
> normal chunk-length check. sctp_inq_pop() then returns the same malformed
> chunk repeatedly and the receive softirq can lock up.
> 
> [...]

Here is the summary with links:
  - [net,v2] sctp: validate chunk length in the inqueue parser
    https://git.kernel.org/netdev/net/c/6cfc1b90cb86

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


