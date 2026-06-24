Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35C862F7EF8;
	Wed, 24 Jun 2026 02:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782267659; cv=none; b=fBGDDdQiixJ6s0Bx+n/xUNtIWsyWdRmG36bUffNZPvN3YSimQdX4stRh3enJOxvW0NMVdKSmnlwRzttk6NHqFsGYAetpesokK7ZJMF1dcQZAIwKSZIR5iwe8cJNMmA+V+soHKUEC0x2KWzXSNwmYD9b9nMwl9X+77Lrgq8Gx6es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782267659; c=relaxed/simple;
	bh=S8mQWUG2xdWqD0xKmTxiVna4Q2173cdbX3sJgid8E0w=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=Ef+RFtnXIllEYg3fHa9/oXT4MX7Qg8byKjucAKaxoItem/A15KETLFY5C0Dlm+RLkW2mLGtEk242hugBLUoJw5VjSzCkk3OoXaamPR8h6gphw17kJPszxB7ILJao4jgBpDwBgvT9NAsKpsO/r9COl2q3KtmDmIAxrp4d1HmIyvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NCaqVmmQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NCaqVmmQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E02CE1F000E9;
	Wed, 24 Jun 2026 02:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782267657;
	bh=20qhPFs4jfS6A2FZHHt9pJpxY+Ulu5XXoPBBKDJcdHs=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=NCaqVmmQmAOd7/v9XIjsFrOKoZyv8UVia1oCSIJYhPCq6+VxPITgSOh7Rw7Wuycr7
	 gfp0yGaMjMhlqkvEvSv9F8yPQ/qaxtNWddg2KW9fNB0XpeFUaCsVHEYoERAFZ5l3S0
	 3j5u145fMOTZzg4DNvR962p8zRIjihhSe1vYfMKclmbEu2J/qciYluWv7rEEA2hu90
	 7UaoftLsmQhyBA1LyipixaUH8f8gbIYlOd5SOzYs3vh0GS+e4BJvEZ9SGTFqBW2e13
	 NE5Dd/v1beddo9WiSHBDGAGBR7We3J1K8ALUxV9zMs0c3OvlCY1KHpm8Vunelw960W
	 98FT4czApFbBw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 568DB393102A;
	Wed, 24 Jun 2026 02:20:48 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] sctp: fix err_chunk memory leaks in INIT handling
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178226764683.2513445.821387304486136433.git-patchwork-notify@kernel.org>
Date: Wed, 24 Jun 2026 02:20:46 +0000
References: 
 <0656704f1b0158287c98aec09ba36c83e4a537ab.1781970534.git.lucien.xin@gmail.com>
In-Reply-To: 
 <0656704f1b0158287c98aec09ba36c83e4a537ab.1781970534.git.lucien.xin@gmail.com>
To: Xin Long <lucien.xin@gmail.com>
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, davem@davemloft.net,
 kuba@kernel.org, edumazet@google.com, pabeni@redhat.com, horms@kernel.org,
 marcelo.leitner@gmail.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Sat, 20 Jun 2026 11:48:54 -0400 you wrote:
> When sctp_verify_init() encounters unrecognized parameters, it allocates an
> err_chunk to report them. However, this chunk is leaked in several code
> paths:
> 
> 1. In sctp_sf_do_5_1B_init(), if security_sctp_assoc_request() fails after
>    sctp_verify_init() has populated err_chunk, the function returns
>    immediately without freeing it.
> 
> [...]

Here is the summary with links:
  - [net] sctp: fix err_chunk memory leaks in INIT handling
    https://git.kernel.org/netdev/net/c/9f58a0a4d6c2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


