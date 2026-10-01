Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1611A4BD376;
	Thu,  1 Oct 2026 00:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790812808; cv=none; b=rt9AyoVF3kve+v/t2rpTOEbXTxQkLaPckqe87umQehT7eAvf4rGtexV8AazivKPYy32UvHaSY0+8ARsh31CV6qU6FlukW2TAQhBMxLaStjIeA8+KN9vSh55iFKmP7n5fxMH63L8Rjum2Jo7MPcm9MWa4izShNgvQFvNZ6fZXs7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790812808; c=relaxed/simple;
	bh=0uMlqgAc7PASYByW/FYTgQKnJv+FLo5lOQVLeqzYCcI=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=UJQBOIcbWYIjEqfRwX9tkbJ7Z91UiYDFWmuWkd6/5rHNanzaJzKC8a97m7uvrLQV38J1RG1nPeyn9XCaT8jT7FoSBsLQVMUzquz59l+/tAAIub1JStet4ACOX+CQpQuvlEpkMgWQLuaNjJ2SQIIRlUPT5+cwpHuCFmk8EYK/+a0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O+hmmyJP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O+hmmyJP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81D0F1F000FF;
	Thu,  1 Oct 2026 00:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790812806;
	bh=uO0/wOrqwi9Rqz5UXxitnrh6nPzgNBviD0J55MblA7A=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=O+hmmyJPKPwESGqqpr6ia1UGpg1HwUvI2jK/7GHPH8k2Kwg+MxRiLTSaGYvU/yaEu
	 oWDENv1ek7mADiIn+6dwyAXrklUHY9LsULntJAUDqL+QrhqnNj4s6Y2vWDsVs0Zm7o
	 V3yTvc/6HtZHQb+G0BHntelgXeahpyAEeX8622wynATwcxgB0EXCuviDQKUa+EbZ2g
	 qfwdaW72Pg1Qn1LCzoVU0aN59FHBPaKmjLgmzpcgHQ4HUNLiBRVxI1xodqhSU6onnl
	 DnwdmJUPImfCRkt67wiFzmqmeksynsW5bdjUgys0oAlni1qpLYmIm0X0Y4X4IzbbAf
	 Hr+ZbmcDV6cGQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 773223AA6A61;
	Thu,  1 Oct 2026 00:00:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3] sctp: check RCV_SHUTDOWN after the sendmsg connect
 wait
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179081280504.2182141.3069907749152791500.git-patchwork-notify@kernel.org>
Date: Thu, 01 Oct 2026 00:00:05 +0000
References: <20260926095606.68601-1-juny24602@gmail.com>
In-Reply-To: <20260926095606.68601-1-juny24602@gmail.com>
To: Jun Yang <juny24602@gmail.com>
Cc: marcelo.leitner@gmail.com, lucien.xin@gmail.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 linux-sctp@vger.kernel.org, netdev@vger.kernel.org, junvyyang@tencent.com,
 stable@vger.kernel.org, corvus@tencent.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Sat, 26 Sep 2026 17:55:15 +0800 you wrote:
> From: Jun Yang <junvyyang@tencent.com>
> 
> sctp_wait_for_connect() drops the socket lock while it sleeps. An
> out-of-the-blue ABORT can then be processed from the socket backlog and
> unlink the association. If a concurrent shutdown(fd, SHUT_RD) sets
> RCV_SHUTDOWN, the waiter breaks with err == 0 before checking
> asoc->base.dead. Its final sctp_association_put() can then free the
> association, leaving sctp_sendmsg_to_asoc() to continue with a dangling
> pointer.
> 
> [...]

Here is the summary with links:
  - [net,v3] sctp: check RCV_SHUTDOWN after the sendmsg connect wait
    https://git.kernel.org/netdev/net/c/4f1da630d13d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


