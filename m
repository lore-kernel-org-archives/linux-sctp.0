Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75FFB341650;
	Sat, 29 Aug 2026 05:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787981469; cv=none; b=LT9qEmqs43EEWGJsjnzboXMeHsCud6m+UDPWM3vc2pHjq4eIvnNDxLRaP4urxG0DuCEudgT8WLmKnvA1Cqh/UJXbZIaSlFcrOuI1lWP7DWB8XU5yc+Lr26K211J8z1QW/em6U6UMwGYDCYU/ek3ZBjLWnQi3PIGAaN+/Vk+q5GU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787981469; c=relaxed/simple;
	bh=b82psDUIi2qOn3bm1nujE2u/Q6bosrXcl5ToU5K67Ns=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=HOp6+1TDd/4lYGn3JC/Qco4xCxoCaCkKMcJgRDMjA/lY9he2ijJ+X022oEk1nN9Z9g8NSRr9sFbKH6a1CI/Cd7W2eM6TuCdj8+mvEIVIkCa9lPl8BYdHjalJxQYovz3dvD5aQSQk0xQg1dV4CKMVfm+SVzKHB5lvwXgy90bBpMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jMgNSG4r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jMgNSG4r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CDFF1F00A3D;
	Sat, 29 Aug 2026 05:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787981468;
	bh=6Y9smdtBakaL1e4Wvih4nJi5BGEbyPSbIdMY202VLUk=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=jMgNSG4rgm5ZjT0jR+6GqgE8Kii95JMzzTcirxNtjAEXFGnD0imIVO/U/fKGImXaA
	 czCbO2cybLslaZbkdHlMxE/HOaBTfXRLOziegtpNFnYnKs7a16wvnLJzVRZ8DJPstp
	 3HkDPu/5ntqJETuJG0phkW63PPgffk7XMes8eJSAuKX9T3kiOc5ZAmrRD6dT4aOKuu
	 rU1CMsT58LpOCkYushNaMFPrEpXnV5nwZ6K/OLh9D0KImPfJSZT4DJt84V8R9sKij6
	 PFWlGnqf7K3x+vHo2rXa8d+4HIsiuNbOBWhNcefGkcoWwDCTuYn4q/d2MytcEpUQ6/
	 92Ey+sIwYd90w==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D09B8380AAD2;
	Sat, 29 Aug 2026 05:30:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] sctp: fix a TOCTOU race in SCTP_CMD_TIMER_START
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178798141239.2932800.13798843916535751547.git-patchwork-notify@kernel.org>
Date: Sat, 29 Aug 2026 05:30:12 +0000
References: 
 <9d8f1b5c50329d5ea7c642128d35681abaa9ed20.1787773744.git.lucien.xin@gmail.com>
In-Reply-To: 
 <9d8f1b5c50329d5ea7c642128d35681abaa9ed20.1787773744.git.lucien.xin@gmail.com>
To: Xin Long <lucien.xin@gmail.com>
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, davem@davemloft.net,
 kuba@kernel.org, edumazet@google.com, pabeni@redhat.com, horms@kernel.org,
 marcelo.leitner@gmail.com, zdi-disclosures@trendmicro.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 26 Aug 2026 15:49:04 -0400 you wrote:
> The SCTP_CMD_TIMER_START handler checks timer_pending() before calling
> timer_reduce(). The timer can expire and detach between these operations,
> causing timer_reduce() to rearm the timer without taking the association
> reference required for the newly armed timer.
> 
> The timer callback later unconditionally drops its association reference,
> which can leave the association reference count unbalanced and result in
> use-after-free during association teardown.
> 
> [...]

Here is the summary with links:
  - [net] sctp: fix a TOCTOU race in SCTP_CMD_TIMER_START
    https://git.kernel.org/netdev/net/c/2188569e7e1b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


