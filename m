Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0BDA7404E;
	Fri, 16 Oct 2026 00:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792109407; cv=none; b=h4SrpSaoMD0vUvicoofss6mEdfdtW4TDxTuMdyv0YUt7GecqT1nkUoZGvunDVk1UL7Fw5FDOgSC4vr72LIj3S+ORnHeENVwtUYdDRgUdgYtbRKXQW4TtvqCtRJq05EIu/endpRICeDOBDNcnPdNMknJ66zRc6Q6ThM4noOT7AnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792109407; c=relaxed/simple;
	bh=30mhsRqF0tGjH6sGp9YAiCb9SFWdSSBIfvBHj3DFB/M=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=jaQSXHstqxGd1wW4O87zWWs5YborD6y91qGAtVdbo59cB8JW74jVvLRX+3VBdC5EKsuwdDnAGW+ZvzR15hosaomY74vutJJYta+7f5gicjlOfk9YDVG9Mw1Z01+y2WpU7p6IeLAM9zWk9SSWvT6Gp4JHGmgwtkEmeDEyxWWKauk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A/9aAGK2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A/9aAGK2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 805C61F000C4;
	Fri, 16 Oct 2026 00:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792109406;
	bh=Lhne4UCmUtr/NUKV3kSKZeBbwv0YEfpONVM/ByBpU0c=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=A/9aAGK2emcnlK0NHiln71EZAfgqDaKv2PZhpDop0YfxIjdf4G8iRLveWZpleoEZz
	 w1OmuTmb4cw9PJymJCr7mFCFoAWIQ16T8RB8VvmRyO8F79Q++JmO1NGOncVu+83TC2
	 BANOXB1WYqieZJg13uZW0+DHsis2PwDYbetaFeq7z+wGMBNwPXmBZ3+faL8yQ7UP6s
	 x26UtftZBCibswnjNC50SAINPVZqyBkfk+kKCrCaCExXUbQzD2ItDjzJV3Hoa5iP0Y
	 yA4Iefy6YvzQRh0yoBCIhBWKt+QJqSIFNAb24spTrBqBnfd+mhvSOUF61+Rk5hII9P
	 vjP9WdRescd0w==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 7773D3808209;
	Fri, 16 Oct 2026 00:10:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v4 0/2] sctp: re-point retained control chunks on
 association migration
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179210940527.4168191.7880710417469627845.git-patchwork-notify@kernel.org>
Date: Fri, 16 Oct 2026 00:10:05 +0000
References: <20261009074244.3718-1-juny24602@gmail.com>
In-Reply-To: <20261009074244.3718-1-juny24602@gmail.com>
To: Jun Yang <juny24602@gmail.com>
Cc: marcelo.leitner@gmail.com, lucien.xin@gmail.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
 david.lee@trailofbits.com, kylebot@openai.com

Hello:

This series was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Fri,  9 Oct 2026 15:42:30 +0800 you wrote:
> This series fixes ownership of retained SCTP control chunks during socket
> migration. Patch 1 carries David Lee's shared-key prerequisite.
> 
> Changes since v3 [1], following Xin Long's review:
>  - Add David Lee's and the forwarding submitter's sign-offs to patch 1.
>  - Restore sctp_process_tx_chunk() to skip duplicate visits.
>  - Preserve a control chunk's existing shared key across migration.
> 
> [...]

Here is the summary with links:
  - [net,v4,1/2] sctp: hold shkey across socket migration
    https://git.kernel.org/netdev/net/c/ad1320865b18
  - [net,v4,2/2] sctp: re-point retained control chunks on association migration
    https://git.kernel.org/netdev/net/c/52ffeaa358d1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


