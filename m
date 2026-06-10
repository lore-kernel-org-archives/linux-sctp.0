Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54C6E17A305;
	Wed, 10 Jun 2026 00:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781052008; cv=none; b=TxnrS1xOdftkLJ8xYxbDk9trL24xQVvJaYb5vAWudU3wrjUj+mV/r8kJwK48Yh1YLtCA8IzVwwMWbO7wAA9i3y3wrdLfVZEobI4PbzgwtkQL2nZ6kAmQXUOlakazQj6ZyNKWsHUfHVu9S2dHmMeZ0Y7Ehd3I0pq7cWPPko2BUdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781052008; c=relaxed/simple;
	bh=xvOFjLtPbijbOS5n3eWrAMA3PyhQTzIXElaXHD2l+6o=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=DH5Gulm1yP7uQpCpnZ5XV3pXhSvYkfs1Dcx3x/wvuBCprxcaNPrU+O1gdrPT7k/NKKqYMFb3cLGSSzI6ABpg6IeXtZQHvseFbDaiD6kS8GuHbKCaPeHy0yfZb50yOvVyMHB3YO9TazjMvsmNz3F4BaKBS0nWiDytZ7dyLh9OFXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lqiFIYzQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lqiFIYzQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC1721F00898;
	Wed, 10 Jun 2026 00:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781052007;
	bh=q6+uncKJ085UzeERsTC0FucfvY0boOTO9qT3Iw48cuw=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=lqiFIYzQtmAQVorOPRkxzcL0ZqJPXIbHmf9SvcINe9rDNGOkqpI3aeczttW/SSg2P
	 +rM1CMCzcYzDfq9Q1WKGpHC4PSbLt/cJA3huQooyPhkEdFw4ypQ2IGxfxjR47Axbic
	 NWEhuxSI7d9HTkdv9vmV6zXriPk41ZUQa67LQ5ZJs641pd0UXeEcFF4lLq6PhvdOse
	 0zvAlE0F2hdqltga31ca69l1OByYA5MTUH+R6WRvkwggtJAbqxW2yk7FOvE4pn3eeZ
	 ECNlH4WktYRycgWtlMyAUVkS8PTDfpcVKfyTQXaGN0qxlm5NXPQYlnd8vHPjTd/SJ7
	 ea7YN+EfXUQpA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 568EC3930A0F;
	Wed, 10 Jun 2026 00:40:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 1/1] sctp: stream: fully roll back denied
 add-stream
 state
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178105200514.2767403.6481473743961740562.git-patchwork-notify@kernel.org>
Date: Wed, 10 Jun 2026 00:40:05 +0000
References: 
 <d78954ecd94954653ee299400e98d74a03a6f7d3.1780603399.git.bronzed_45_vested@icloud.com>
In-Reply-To: 
 <d78954ecd94954653ee299400e98d74a03a6f7d3.1780603399.git.bronzed_45_vested@icloud.com>
To: Ren Wei <n05ec@lzu.edu.cn>
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
 marcelo.leitner@gmail.com, lucien.xin@gmail.com, davem@davemloft.net,
 yuantan098@gmail.com, yifanwucs@gmail.com, tomapufckgml@gmail.com,
 zcliangcn@gmail.com, bird@lzu.edu.cn, bronzed_45_vested@icloud.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Fri,  5 Jun 2026 13:53:42 +0800 you wrote:
> From: Wyatt Feng <bronzed_45_vested@icloud.com>
> 
> When ADD_OUT_STREAMS is denied, SCTP only shrinks the queued chunks and
> then lowers outcnt. That leaves removed stream metadata behind, so a
> later re-add can reuse a stale ext and hit a null-pointer dereference in
> the scheduler get path.
> 
> [...]

Here is the summary with links:
  - [net,v2,1/1] sctp: stream: fully roll back denied add-stream state
    https://git.kernel.org/netdev/net/c/a5f8a90ac9f7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


