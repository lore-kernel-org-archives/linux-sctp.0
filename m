Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3268F34041B;
	Sat, 19 Sep 2026 00:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789779081; cv=none; b=jcxRa5T8KYtnftv+L3klmjoURt0wSmIa6Y61SrH3/4FdE+HPGpvGJh/Kfbrl98K/saOrntbMdOzxGRhMi9eF+Jd/OYLYoxP/U3OJdP0M1yn4iPNnDK4wgNVPAOiMvV5HXCEGW0cxyuVmXplbPQL8xHSqxEJ+ARhHKBs5EQ+dZzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789779081; c=relaxed/simple;
	bh=DyVehS0txZ7oFOo+S0bMk7v9RZOvRvFwjkMQ3VSSDUE=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=hipLW9IbZHTeVH8N+PVagPfmhe+Ww2dwoHbYbJwn/RRGwEXi2mnlxXPKTeQ30qw16d4CwM4DpK6crxSDg/2F/ZFJUn/nLlYvLmzR67Efvp8alN3Fi+HtzT0lHm7llqPIua/XIvjvlBtKd1Y7NVIyMTSPg3NrmjexOJDfNPI+LKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jWu4wBpC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jWu4wBpC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA29C1F00899;
	Sat, 19 Sep 2026 00:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789779077;
	bh=rc7y5122sbWh1tOA4lDgYnN7hntOUg/sYT6sc2pWEpk=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=jWu4wBpCq+qHMcVf+CrPyi+Fh8bwoQW32qpdpCsS4QyzwEGKn3dm+FGoSqA1s2bER
	 lEDXSqLe8nw8kGJj7/E6oQln1gJTh9dwgzO2M2z1RtL1ecoO6dRXxTY/s4L8SwJCwm
	 owQNuU1IwvygGhHFSKemW7zD9ISe5JJ6aL30lmlyFHOjHRBlaPXL3qVyFad91ib9ef
	 zpwOtymU4YzcXpZ/TJ8zQyVzEeJFtvSsi/m4DTHUikCywewj3D9M1ufhChALNLZLpW
	 HXJDvoTSg9IZMUxYLRolDUEWd+J2bZakhE4eBi+6WQKCILOp+eq2AtrUOBvvv7JUgl
	 aSBGXaRlY03EQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D0A353811978;
	Sat, 19 Sep 2026 00:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 net] sctp: avoid livelock while updating retransmit
 path
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178977901039.1211687.5015867154963492333.git-patchwork-notify@kernel.org>
Date: Sat, 19 Sep 2026 00:50:10 +0000
References: <20260915095017.942213-1-sunyiqixm@gmail.com>
In-Reply-To: <20260915095017.942213-1-sunyiqixm@gmail.com>
To: Yiqi Sun <sunyiqixm@gmail.com>
Cc: lucien.xin@gmail.com, marcelo.leitner@gmail.com, davem@davemloft.net,
 edumazet@google.com, horms@kernel.org, kuba@kernel.org,
 linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org,
 netdev@vger.kernel.org, pabeni@redhat.com, stable@vger.kernel.org,
 sunyiqixm@hotmai.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 15 Sep 2026 17:50:17 +0800 you wrote:
> sctp_assoc_update_retran_path() can loop forever when every remaining
> transport, including retran_path, is SCTP_UNCONFIRMED: the state check
> runs before the wraparound test, so the loop cannot observe that it has
> completed a full pass.
> 
> Fix this by considering a transport only when it is not UNCONFIRMED,
> then checking whether the walk has returned to retran_path. This makes
> the full-pass termination independent of the transport state while
> preserving the existing fallback selection semantics.
> 
> [...]

Here is the summary with links:
  - [v3,net] sctp: avoid livelock while updating retransmit path
    https://git.kernel.org/netdev/net/c/d2c31b837406

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


