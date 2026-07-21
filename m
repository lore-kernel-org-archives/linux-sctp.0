Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C72635C686;
	Tue, 21 Jul 2026 21:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668841; cv=none; b=rYTnyk9WznZgma35LL4j57lC/8JnW/bwPC4xq7c3R/kDc/pXerrt2OgWXmhm4J7YA/gtcGgXYzxB+pdKeDT9qCoBE+Il2dyQKel8nCHGWMDNHFCZNuJ4iJKSUmx2MPz8Rb/LVNaAjVs1NAQT1V5mpggPyzmiDQFT0A6Tsqe+fic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668841; c=relaxed/simple;
	bh=utR2Mf+2ttUa1aXk+89H9+4GZKkUaXQJrRW6m2j89Yg=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=Sfd++v063WSPQl+H6n/QFppIq9OAsBGI88Cyn5RoBlK2cWsV6mGPmyT0DpLbVvCz0mftvNmF3LNU2ABbjtpf3ncP1lOmoIh7ZfMckdB51Lg/ec2HiD3k6uJ8/Sp1SnMg2yswlgk6w5XfxUpGF1OJMf6UEWY7EyJ9QpRoCGV8F2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cGi6MFv7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cGi6MFv7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D6741F000E9;
	Tue, 21 Jul 2026 21:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784668840;
	bh=qIDjTTHCreGhpZYlRWgVAtLeKCRxHqlNhx/bjhdmH6Q=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=cGi6MFv7RK9L6LwA2PHucOWzOYJ+Lc4mEOnygN0BhJ/Qq9wMiZw0IDQ5d38avvdCu
	 u4lz385S5Z+nHy+vplgVcptEISbrvS+bFtvrPXUO/8w23DEMfe7rpo3QLK+tT78baa
	 MLKpl28BBPSYrDZvh975PQOqz0KPGb++LLtwB+KkiBhHbJou84GczJJVTOc53ulX1T
	 7uaAlxgMJK/MLJjmzbbqirQIcAqLUbJau1XPfFDN8whftwJg63FxMT35QnkkGhrhDD
	 8+dthRBzx9nNHopl9y6MbLJr0aN/QSmsw+9nSd9OP2MM08cP5YXEDbvspuKAzpmzT5
	 QSDN+2KXGsp9Q==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 19C39380820D;
	Tue, 21 Jul 2026 21:20:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3 1/2] sctp: avoid auth_enable sysctl UAF during
 netns
 teardown
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178466880964.1074610.10488001680438401853.git-patchwork-notify@kernel.org>
Date: Tue, 21 Jul 2026 21:20:09 +0000
References: 
 <390cd5e91ed60eea27b0b64d0468301a9e73b808.1784033357.git.roxy520tt@gmail.com>
In-Reply-To: 
 <390cd5e91ed60eea27b0b64d0468301a9e73b808.1784033357.git.roxy520tt@gmail.com>
To: Ren Wei <n05ec@lzu.edu.cn>
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
 marcelo.leitner@gmail.com, lucien.xin@gmail.com, davem@davemloft.net,
 edumazet@google.com, pabeni@redhat.com, horms@kernel.org, matttbe@kernel.org,
 yuantan098@gmail.com, yifanwucs@gmail.com, tomapufckgml@gmail.com,
 bird@lzu.edu.cn, tpluszz77@gmail.com, roxy520tt@gmail.com,
 sashiko-bot@kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 15 Jul 2026 09:50:10 +0800 you wrote:
> From: Zhiling Zou <roxy520tt@gmail.com>
> 
> proc_sctp_do_auth() updates the SCTP control socket after changing
> net.sctp.auth_enable. The handler gets the per-net SCTP state from
> ctl->data, so an already opened sysctl file can still target a network
> namespace while that namespace is being torn down.
> 
> [...]

Here is the summary with links:
  - [net,v3,1/2] sctp: avoid auth_enable sysctl UAF during netns teardown
    https://git.kernel.org/netdev/net/c/f8d5e7846025
  - [net,v3,2/2] sctp: close UDP tunnel sockets during netns teardown
    https://git.kernel.org/netdev/net/c/ffb2bd7ade36

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


