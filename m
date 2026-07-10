Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9BA6223DE7;
	Fri, 10 Jul 2026 15:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783695629; cv=none; b=hTrDpCXGzJwYYg7PIQqQBZeo9vHbeimj+OLDBFohFVj3/4pI8GIq309PzM5aE5nnI/OQYz8MFNutpDiVTIxGJrAexaI4cPlDfLf/GUfA7uUdkXw/O/USnFSCoFUs8s8cjW3yFmVpdIQFl6pCh1RcNFVXAcFLLFvcvhVoT0H3X2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783695629; c=relaxed/simple;
	bh=WIzAkP8OyPVA8uAWxkJkDpECORMBAFVM5Vjg+fymZw8=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=L0F1Q/nsY9UorkNzPR6ggcsFJqjoDM6pi1DjKp/Hb94JFyAFsObCGON3hN2VlOEquFJ0a17lzD6vvngtZ54FXkldvBeRKmo6foS+G0KLDGRrqU7oCwTtRK8aIhYpE2XyJJViHsbdsmp4ZjS5LwEnL1devz63DR7MPYB6nC2F7fA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ikfk9ise; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ikfk9ise"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B00D1F000E9;
	Fri, 10 Jul 2026 15:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783695628;
	bh=gIVfiGDljpqCKA5ERFNw/PTnn3K8M+76q6/Myzas50A=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=ikfk9ise9kwxt7eFSbbJGnpbbhtidHoXuYfeXHSjQXrGODnMTOJNQLcgKnOkwKt20
	 qFdUnyu6cW0EZWm31VVd6nyp7Ljm3kP2l2Fvq5b0HMIM2da4IlCXKoeTtw/8E5vXOR
	 4e3fRg7+rvgq3yJYX1ATtHtdxxDt2fpjt4gHtZ7RjcfPjSpK8zUln9voq/dtcQHz+E
	 l9uLXTiKMr0FGHRcbskNXijPVrPIEEI18VQuG5QxQ0bA+m94XJ/fJDh2d2mcpT/TFj
	 BRefFbpZo6+o0+NpzYQGV+A7MIgddyIe4BSuvIJpSo/+bKTYZcCMHQWm8D3XK4d+Y/
	 pVfFMkxovGFdg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 9397F3924F9B;
	Fri, 10 Jul 2026 15:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] sctp: validate STALE_COOKIE cause length before
 reading
 staleness
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178369560614.725168.2626506030480279304.git-patchwork-notify@kernel.org>
Date: Fri, 10 Jul 2026 15:00:06 +0000
References: <20260704033545.2438373-2-bestswngs@gmail.com>
In-Reply-To: <20260704033545.2438373-2-bestswngs@gmail.com>
To: Weiming Shi <bestswngs@gmail.com>
Cc: linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com,
 lucien.xin@gmail.com, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org, xmei5@asu.edu,
 stable@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Fri,  3 Jul 2026 20:35:46 -0700 you wrote:
> When an ERROR chunk with a STALE_COOKIE cause is received in the
> COOKIE_ECHOED state, sctp_sf_do_5_2_6_stale() reads the 4-byte Measure
> of Staleness that follows the cause header:
> 
> 	err   = (struct sctp_errhdr *)(chunk->skb->data);
> 	stale = ntohl(*(__be32 *)((u8 *)err + sizeof(*err)));
> 
> [...]

Here is the summary with links:
  - [net] sctp: validate STALE_COOKIE cause length before reading staleness
    https://git.kernel.org/netdev/net/c/1cd23ca80784

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


