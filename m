Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4112E2D3725;
	Thu, 30 Jul 2026 00:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785369659; cv=none; b=IQp2c1wWbNkm9T2BxMr699e5M/6hlX0Kx1XXEhti3EREI+LQaAvUo6/JbG/r9/XqaeGo4Rlv+5jV8BqIhDtg5IlohJlnu5oT//NpY+lFgd/PV+f+JB5+HTI4oqbrCmWJrggak9W0no3LiRLpjG+9DSA6EbZxQG5iklt1XfQX2uA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785369659; c=relaxed/simple;
	bh=sybty8jTfU5PonJgsH5PfTUuX5cssVmkVv/U2qx7UCY=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=oQTRfKbus6VjaTWt2j1/FhDcvSF7XPGn4l1u3IZuCaCV7UN92Kvx+nBWzmgPuaBNxRAC4jOrHd2mGZzEHRjX/E3EQVJiGimyOrlXuvTLe4nAFlrn7wJkEooKX/pC+Y2nhXCsy0BwFFs89QYGru0dJecOecFMCnXfv/0C6+CpU1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qb/dgLXV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qb/dgLXV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 260621F000E9;
	Thu, 30 Jul 2026 00:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785369658;
	bh=Jtcm2foB59NzaOWEEVfF+6Bq1aS1xVP/bEJOD++z0hs=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=Qb/dgLXVE0uMa6d0kmfuX53563IKC6IXK3LIhy/WogJRYBMQLz/GXhdiVEXO1m5IE
	 XUahzoCPKVJw3xFyn7wuBE9+GNfj+tpgC0Cg7sxSsTxcGTkt1TOmdLP4FglA5LDc3l
	 VteonEeYXQtEyD3RGlTt++pibi6v/fc5QiXHVAP6bxULD2LdZaSJYu8zP58vdX9hft
	 irsW6TwF5Jx0kewRpvvFXSX5miloDXdK4UWpOH5/LXZ+iEPsOZXo5h78piK886WAzk
	 EteoZXsXvhkzc8vf+v2sl/r745RW8pNG90BILLzHwefAUN3/MY3K5qK8qFzb9BRw+o
	 PgWyZ2R8deZQQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 56EB13926250;
	Thu, 30 Jul 2026 00:00:23 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] sctp: validate Adaptation Indication parameter length
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178536962190.3288516.17824582484008131483.git-patchwork-notify@kernel.org>
Date: Thu, 30 Jul 2026 00:00:21 +0000
References: <20260727-sctp-adaptation-length-v1-1-0ab58b2810a5@gmail.com>
In-Reply-To: <20260727-sctp-adaptation-length-v1-1-0ab58b2810a5@gmail.com>
To: Charles Vosburgh <trilobyte777@gmail.com>
Cc: marcelo.leitner@gmail.com, lucien.xin@gmail.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 27 Jul 2026 19:17:30 -0400 you wrote:
> From: Charles Vosburgh <trilobyte777@gmail.com>
> 
> The Adaptation Layer Indication parameter contains a fixed 32-bit
> Adaptation Code Point after its parameter header. However,
> sctp_verify_param() accepts a header-only parameter because the generic
> parameter walker only requires the header to be present.
> 
> [...]

Here is the summary with links:
  - [net] sctp: validate Adaptation Indication parameter length
    https://git.kernel.org/netdev/net/c/74b21f52c5c5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


