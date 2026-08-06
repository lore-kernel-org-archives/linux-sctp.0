Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B196380FC3;
	Thu,  6 Aug 2026 16:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786035077; cv=none; b=NwDw8lgV8Ov9ZepFGeHDXT0YXBBk4LC5DjyqjEFZwpdFSdI8RuE6Toze1aE+CF8r+H9t6PovwhaJUSD3tAlIvLvW5LLparp/8yejlKl9VA0OrSQx7syxTAaArQ3xRZOtsrivL4+UwaxgklWsh+Bu+blZo4d3xHXSz1qIAIbvne4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786035077; c=relaxed/simple;
	bh=V28Zn9l07PnyvCbOXsDBt1/jIaK0FKq/uN9FQhJyYng=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=XFJRzoAUIy3/tCiLZvdCNyX4ZKgQ0/ffiWptIaw/u9EF9auIybsMULIl3u2o5yJ3bkV/rWldKE3kYWGUsg1e6pa8GSnmo+IkDB7E4vRDK3JvlH9AQRAGrJNF02ONU+NVeMbjrJT9l8m340PnOQWcK91ytf1ZoZ9xxNiT+WQg05g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SbqWDj3w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SbqWDj3w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 913451F00A3E;
	Thu,  6 Aug 2026 16:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786035064;
	bh=vxolka/MWL4H+ALKSuwKFt5z/S49G+LJW4ab/ImI8k0=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=SbqWDj3wUasGqcRsd0FAqFM/XOoPWvI5z3JzzeKyIq3q13IuSlNARb0lLw2OiqcLJ
	 nFkr8VuPKyqsCeD+4/74IhZBZPxR0czrsLuePdaDpzIzU/G4AbsgLTZLptJEBLw9OV
	 YMLzkZTxtcB76b/YiPlhvok238U90tCBosiy6NvjF05o9eEumSeyB+izk8iyvP8Dks
	 fzSiXYeodYXw7sonerKhu3Op6BrYvCktk3SNoTdPWPCQ/yOrHkou7eo9Iv+X6wDkL3
	 /9CEkKgCNiBCkNR0vh1J5ZnzntVdLHaZJP6Ds8XYJO23X/bbB6d788+1H8+g1aUTNH
	 yRV/hTPTmAZ7A==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 198B5380820D;
	Thu,  6 Aug 2026 16:50:25 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] sctp: clear control chunk transport if it is being
 removed
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178603502364.1375455.4324945153303168941.git-patchwork-notify@kernel.org>
Date: Thu, 06 Aug 2026 16:50:23 +0000
References: 
 <7e1168cb722132152a29d47e5eafaeac4a3bf6f3.1785943120.git.lucien.xin@gmail.com>
In-Reply-To: 
 <7e1168cb722132152a29d47e5eafaeac4a3bf6f3.1785943120.git.lucien.xin@gmail.com>
To: Xin Long <lucien.xin@gmail.com>
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, davem@davemloft.net,
 kuba@kernel.org, edumazet@google.com, pabeni@redhat.com, horms@kernel.org,
 marcelo.leitner@gmail.com, danielelinguaglossa@gmail.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  5 Aug 2026 11:18:40 -0400 you wrote:
> sctp_make_heartbeat_ack() caches the destination transport in
> chunk->transport without taking a reference. When src_out_of_asoc_ok is
> enabled, the HEARTBEAT ACK may remain queued on control_chunk_list instead
> of being transmitted immediately.
> 
> If the peer transport is removed while the chunk is still queued,
> sctp_assoc_rm_peer() drops the transport and schedules it for RCU freeing,
> but only clears cached transport pointers in out_chunk_list.  The queued
> control chunk therefore retains a dangling transport pointer.
> 
> [...]

Here is the summary with links:
  - [net] sctp: clear control chunk transport if it is being removed
    https://git.kernel.org/netdev/net/c/c9158ceaf277

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


