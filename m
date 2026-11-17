Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794874808;
	b=IjKdcd88WRrj2dkzs/aM8KN48yG+CmLpByBrs3twCTuv7eBb8vxbBWCHqSd75HfhHbc+
	 33MR89K/Yn9k82gNaUxQTtPihHL1IfIBGN+93NVLuBUay/os8K6OsnfvS0sfvLOCTzCpz
	 Y45G9StKICLk88klvwPNEmidkXQ78ny7DUvaxyFvqI5RjV5sSRaBQuMmTe/kBAOmQSa9U
	 uPE8f7dNeeGMwwGz6GpP1kQc1o/dwtilivd6WQuygbBaouNZueysnkL99MMpKoMA6EW4H
	 XB1ARNAIETHOwzdex3jahRzXOQ8Rqcdr1w3vbbxV+wXyeMWQlOM4OkikkliIK22fO+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794874808;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=4C+hHaQoI/htJ4th9nKPEWiUVD7EJpf5lUFg3nSpV5g=;
	b=Jee2wk3CywPMb7vm+7Drq23zmfGMd8YqF34G1uFdTsMQXMOSRBcy5kqyhIF40wA5tV/O
	 IRf20M0NEmGw4N74akFkqadJw5NVa7Y42YR5+dqEGm+6x+994Xq+AefdM309dw5GB5dwZ
	 8rgs8Serw7LgrNd+srtRIciDL5yC2pTkFPJtkwO20Jettzux6xGbT3RsRNGNrcq4gGIJ6
	 srNkyc46t/Y0mDhWwIHw51I/+8C/Nxbk108uBJ8J7rVKLDYm0bT2+XjhNxqkxUKcqP630
	 qIyZ8p4Lu8bV8Hzuwu2Gvh90N+uepJp06v5sei2SeFBmNbo3aQrMPBqn8kJp9waQxfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AUXXjp6v;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4675A606A884;
	Tue, 17 Nov 2026 00:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AUXXjp6v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 077821F000C5;
	Tue, 17 Nov 2026 00:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794874808;
	bh=4C+hHaQoI/htJ4th9nKPEWiUVD7EJpf5lUFg3nSpV5g=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=AUXXjp6v0MbRnT8sZm9LoaSiwSaiXGcUsJo1UKVHnudai2g8He9Zjf7PjMo/0NkvG
	 XGKEl/TijQMHDMi/FARlWEXUbd+UTpiHGmbyV01Ljjx3sPUexHy30FCjn81C/sILN3
	 TYBeYZYi+04mt0ah2TbMLwa5QO+CYTDywOntKJ1LPrk6eoRGaQHW3vZUJQddvxjuiB
	 FZPrhw1d7lDd8Ztd4VLmEpa0c8hqaOF9n6TauTrCI4mRPqNw/4YtQM4PXem3r3tMsT
	 BMuz2BmcWUulnwwGtua2DsHXmCUOQnNlYVS6Fq2B0FYGsQ3OTxa53AQ/0Xl+ku6zlE
	 ZRgxpJS6ZsVyw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id F16BC391AFE7;
	Tue, 17 Nov 2026 00:20:07 +0000 (UTC)
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
Subject: Re: [PATCH net] sctp: validate SACK pull length against chunk length,
 not skb length
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179487480652.257811.15441708488067706931.git-patchwork-notify@kernel.org>
Date: Tue, 17 Nov 2026 00:20:06 +0000
References: 
 <3fbf59d17a91c46098e3d4115e06987918b68c45.1794495702.git.lucien.xin@gmail.com>
In-Reply-To: 
 <3fbf59d17a91c46098e3d4115e06987918b68c45.1794495702.git.lucien.xin@gmail.com>
To: Xin Long <lucien.xin@gmail.com>
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, davem@davemloft.net,
 kuba@kernel.org, edumazet@google.com, pabeni@redhat.com, horms@kernel.org,
 marcelo.leitner@gmail.com, tlatkdgus1@gmail.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 12 Nov 2026 10:01:42 -0500 you wrote:
> sctp_sm_pull_sack() derives its pull length from the num_gap_ack_blocks
> and num_dup_tsns fields in the SACK body, but validates it against
> chunk->skb->len (the remaining packet data) rather than the SACK chunk's
> declared length. A malformed SACK with an inflated num_dup_tsns can pass
> this check when subsequent chunks pad the skb, advancing skb->data past
> the SACK boundary into later chunks.
> 
> [...]

Here is the summary with links:
  - [net] sctp: validate SACK pull length against chunk length, not skb length
    https://git.kernel.org/netdev/net/c/533ec433efdc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


