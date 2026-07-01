Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39C05125AA;
	Wed,  1 Jul 2026 00:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782864623; cv=none; b=E6KKpS2k6+eiaWSVDX+50CFcOd6fQtbDIn8OPZ2/8sOQM/QAe2lHik3JqFoNo0tlwBMnxAcMC4YxKKBJp/ZKiEL6CDlYepOF9oQBsTd/9Rnw4auQWSWwDHnpY14yHLp9amfhBZ36FucndS7Sxp8oBWdImBctLwYT6D637+9Xd1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782864623; c=relaxed/simple;
	bh=9ZH4Ff2UgFsKkmK5tefRkwwzer7+c9WXPQlxLKvyGZQ=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=b+XJ4WTeNSNJRl6wyCGjpQm1jaW+53tJgVQ8sBrM9otNPs8DDoRpUg+Lr4pO3nQFhJ8H2YbDMl3SiaGzL3HBzFoJMfgjhc53xStkeDbXyGxA6HkzPxaphXNKwFSwsi1a8XSR7aC7p1Dnua3ygeQljRi85vwaZoVWJFDm8zxoq5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R7qVBkmX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R7qVBkmX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA1941F000E9;
	Wed,  1 Jul 2026 00:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782864621;
	bh=5eK2h5zT0huQPCIKoKHlO4e6xJbMU/UtAu/ACXXiick=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=R7qVBkmXs0a8nkFpQBsqm+vimuROR/Wv7uAZbYkF/r6m0W1QJ7N7cpf8nJ2GhIdFG
	 6vpw2JqNz1weUgdpYx+FTkrmR6FiOFYVOIYnzc/kettUTVe8APMR/i/vHktoHxkZxQ
	 sznuuaYZb29jVbdnlaiOLuIsbN7YfFk95vvY4w7BT9S5XTy7POEKH5J/BS0OwFBwAK
	 jQIwIz+lO+g+/eBHgtencZx5IlkthjKhWBbzN7JOhDM749xUyvK5EPsufcqF0JrnD2
	 5lXB0yiR0XOT+SfyN5MBCnvi+LRJEZYYmY0oidR0Q0klIQRhDMy2P23DfTVPMuUx8N
	 H1QoSSuqFYUlQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D0C1B393A963;
	Wed,  1 Jul 2026 00:10:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] sctp: fix addr_wq_timer race in sctp_free_addr_wq()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178286460539.344657.15416227618301274929.git-patchwork-notify@kernel.org>
Date: Wed, 01 Jul 2026 00:10:05 +0000
References: 
 <5dc95f295bdb5c3f60e880dd9aa5112dc5c071cc.1782757874.git.lucien.xin@gmail.com>
In-Reply-To: 
 <5dc95f295bdb5c3f60e880dd9aa5112dc5c071cc.1782757874.git.lucien.xin@gmail.com>
To: Xin Long <lucien.xin@gmail.com>
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, davem@davemloft.net,
 kuba@kernel.org, edumazet@google.com, pabeni@redhat.com, horms@kernel.org,
 marcelo.leitner@gmail.com, ebiederm@xmission.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 29 Jun 2026 14:31:14 -0400 you wrote:
> sctp_free_addr_wq() previously removed addr_wq_timer using timer_delete()
> while holding addr_wq_lock. However, timer_delete() does not guarantee that
> a currently running timer handler has completed.
> 
> This allows a race with sctp_addr_wq_timeout_handler(), where the handler
> may still run after addr_waitq has been freed, acquire addr_wq_lock, and
> access freed memory, leading to a use-after-free.
> 
> [...]

Here is the summary with links:
  - [net] sctp: fix addr_wq_timer race in sctp_free_addr_wq()
    https://git.kernel.org/netdev/net/c/976c19de0f22

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


