Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CFC93C1986;
	Thu, 20 Aug 2026 20:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787258463; cv=none; b=PpREFYzDekZoRudmO93IWznXETTLZPrRgQ5RGuwlOhhFqwWKkxx3s7s6lIo4c4Anlm/4hZKz/kgOvHFsFgNiclCfDyAseGY6iquAwoe8eg6uTk4NX58Q6rzF5YTBAMEd7nZuBahPPJODEuUCF85T8JpcMB90wcdPGRP9ZBz9b30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787258463; c=relaxed/simple;
	bh=KMp3omua7junaeYsVb4GV5ipdQ4dC6UamU5R//CzASs=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=sCsqXFfQJtkn9DrXL+dH+20HO1WPZkBwOG9oK/eWjPAW2PETxl1RDBBjgZ480Q+1S7Du522/1oUCOtfXLqTC2D+aTikZ53VYTTtKYzIGVeOlAclSbHNnE47B8T7we7N+QVBuaV67jawTQkUCnKjcHLfhXJrfastAfbvlbqJ0OKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o1BTX4Uy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o1BTX4Uy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31C341F000E9;
	Thu, 20 Aug 2026 20:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787258462;
	bh=ClKmVoNo++xFj1/WJ06cFSbF2icYtPV7q3avznw4Xwo=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=o1BTX4UyzGgkK42qxYseoDsaQDqGC1rL42zdZ2XLjkOJ/xBcG3pv9jF5Ht3J88lIT
	 QLxOMJE0NXBoVnMBZYiDWxCJnCOxeaBTJYflk7KD0K8jCHf4DEQ3RbHFnjBrwcnzZJ
	 9hZf2xFnu3i/isOYQDP+j7RjA3zb/i29LcMQjn/XVOWiBnYJLQHON75ISfvh9mNsSC
	 wh4N7WO23jhfQ3nfYlqlJf0lu5CK5UyS6PIoxMwgP2GTvM3PilhUfE7Zos3ZVatkCe
	 kdOfuUdRtPJcg0tclo1moL+aJa+LLpkqWFYiyi3qXu762hKTC9vQ0ytbjOz2g152RS
	 yz09qa0eTjpZA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 93968392445E;
	Thu, 20 Aug 2026 20:40:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] sctp: drop a chunk if its transport was removed
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178725841213.473641.18430300045813272256.git-patchwork-notify@kernel.org>
Date: Thu, 20 Aug 2026 20:40:12 +0000
References: <aoUJHQmxL0LFIMCw@v4bel>
In-Reply-To: <aoUJHQmxL0LFIMCw@v4bel>
To: Hyunwoo Kim <imv4bel@gmail.com>
Cc: marcelo.leitner@gmail.com, lucien.xin@gmail.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 linux-sctp@vger.kernel.org, netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 19 Aug 2026 10:38:37 +0900 you wrote:
> sctp_rcv() resolves the transport once per packet and leaves it in
> chunk->transport. The lookup reference, or the one sctp_add_backlog() takes
> if the socket is owned by userspace, keeps it around until the chunk has
> been processed.
> 
> An authenticated ASCONF DEL-IP can remove it in the meantime.
> sctp_assoc_rm_peer() takes the transport out of the association and calls
> sctp_transport_free(), which tags it dead and drops the reference the
> association held. There is a window on both paths: the packet can sit on
> the socket backlog, and on the direct path the lookup completes before
> bh_lock_sock().
> 
> [...]

Here is the summary with links:
  - [net,v2] sctp: drop a chunk if its transport was removed
    https://git.kernel.org/netdev/net/c/03a9d10ecf71

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


