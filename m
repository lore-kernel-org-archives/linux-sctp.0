Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A5EE31AA87;
	Tue, 18 Aug 2026 17:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787073115; cv=none; b=iV6aFm0wQ7KZ7Y3fMmQ5H6kz2zn7lSFWGVfCMjZvtu6qZJVo8odG1+8GVk+jBbrV5FOh+1GrZqIcN/BDEymADfk9vUumeR8BNEkzTp94UTPri9Y8xbs6smsnSBzdZBECKcqjVRY+vAXhATWLFDJ34YWrEPGIEyYlMSIZGRU778g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787073115; c=relaxed/simple;
	bh=gYy2PWBCq4tfc9QEBmlWwXlaBncOfLXLxuJYzrDQ1v4=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=M3fX4b+BEvv8CemQFFlnSp93CwuMoPwEZTjmF9sbpBJcAvVd4TKqNWQNIMvrNCfiWGmuHtp0d3Vk2YqyoRKxRSKc4vrFlbdPNcu6P0/1QW1k/NXcHaNR9z3L6n6D9pKdzy9x2MVMI0QG8yM3I6z/NXkiDP7QYkBcQwkYfqLwltg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XAqC8cdp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XAqC8cdp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFF451F000E9;
	Tue, 18 Aug 2026 17:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787073113;
	bh=aUYZ41CN/OH6RXJob8Ma9lo1EGQaTAoP9kRoVIn8ZSU=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=XAqC8cdp6bvipClTnVyakORVZrwToCakV+LGTByo/6roI6ofRsbKe9LX90oZ+0PHc
	 rRkWOEDkVTJR4h7hxfXLb3O9jTJrBlXr8tkt0y6YLjWEcLvcf2aba/4sNK7KxxlvSS
	 2Zm+7WVRkOKu41VAk5qiznwqWxkA8zRSW546O3GPbmO+k9k0m8DnrzhcxfIEFXtOun
	 xZwa54phAl0Vyf76CX2WNVKaBFcJDy/wcmzROUL/tUnzl26VDwe/gxyuLgE08uyy6g
	 q4oInHCm6h2bgD3hIkjn3peGg9ckWCtLF/xp4UPyzNyzkpEtLhrznXstVmkrBQ84Kq
	 42jwDB9VfCL+Q==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 93A3B3927043;
	Tue, 18 Aug 2026 17:11:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] sctp: stop processing a packet once its association
 is
 deleted
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178707306518.2185737.16796804623334377893.git-patchwork-notify@kernel.org>
Date: Tue, 18 Aug 2026 17:11:05 +0000
References: <an-YYtoqw1QpTXUL@v4bel>
In-Reply-To: <an-YYtoqw1QpTXUL@v4bel>
To: Hyunwoo Kim <imv4bel@gmail.com>
Cc: marcelo.leitner@gmail.com, lucien.xin@gmail.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 linux-sctp@vger.kernel.org, netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Sat, 15 Aug 2026 07:36:18 +0900 you wrote:
> sctp_endpoint_bh_rcv() looks the association up only when chunk->asoc is
> NULL, and caches the result in chunk->asoc and chunk->transport without
> taking a reference.
> 
> A packet that matches no association is handed to the endpoint, so a peer
> can bundle COOKIE ECHO, SHUTDOWN and SHUTDOWN ACK in one packet. The
> COOKIE ECHO creates the association, the SHUTDOWN chunk caches it, and
> with the outqueue empty the SHUTDOWN ACK reaches sctp_sf_do_9_2_final(),
> so the association and its transports are freed.
> 
> [...]

Here is the summary with links:
  - [net] sctp: stop processing a packet once its association is deleted
    https://git.kernel.org/netdev/net/c/47e15a8d12e3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


