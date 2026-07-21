Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5EF846C4AD;
	Tue, 21 Jul 2026 21:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667641; cv=none; b=AZLRmv6f+u7VTf3XifG6Eb6RalbQ/chNPWi9yX4Q+4rkgZw2uJ4UWRtgK0VZnxee0DQjOBeM1YaUB/Hn4xBPZyokO3JYcGCj969c6KHkrZGui/Q9k64szNp6qZZ0zRlDanNNhS7YscNczs4X5oCu9SqN942AG1qzRn0jFoRM+50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667641; c=relaxed/simple;
	bh=tBbOIopgPoNNYfVy6uMuINUs+/R61BbzUyNdwrSRoyg=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=IJ3ibZdgoroUJXzLEv2ONwaUHwwnHeavkqaN0wm1RfCqOikFUDY+r9VS3aVLeyB2g1CfKaMqx48Y3KJezJJB0rUhbvN4pKsmp7ahNaEyOMcE+XD5iIy7MOOpkhS1tWubDdMTCTkTtwCLftVHlZjwNjnihZvbObIZh7Cr7fh0FmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=btBmFyYo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="btBmFyYo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A89211F000E9;
	Tue, 21 Jul 2026 21:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784667639;
	bh=39NGKFYfPZXO2YhPOxptOA1/twHwDAOMudVPLGsLaBQ=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=btBmFyYoA2vlv5yvaCbpiyfkZv5BAgZmO8mrEJw8JvS45NknRAYtg+7ecM30Q7Q69
	 Wk5E7Tl+8iEA3LMiVu7JjTItPGKZ2lGUiXiHMUtV99VlABxe8Tqj5XkDWhquTK4H4d
	 16ESb27TioEaEChs/iw+fUoM+27YvBulj+HdAzv0yhxTTUepsIaeEkZe/e4EJEi7wG
	 tre2ueLqCCYaYt56mwA8DPpMBPturhc/tfiI9deS9TaBfRUDwGY3l/gCENqG/IlZ+6
	 9ITD5yw0GeFKZAa+0bia/e2GrYmBvjoTpKiLMzLhxccw5lIvDhSC783cQmaYzUneNh
	 zzElnTt2qR4KQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 569693926249;
	Tue, 21 Jul 2026 21:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] sctp: validate stream count in
 sctp_process_strreset_inreq()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178466760889.1059197.2799666690554843790.git-patchwork-notify@kernel.org>
Date: Tue, 21 Jul 2026 21:00:08 +0000
References: <20260710010718.20318-1-blbllhy@gmail.com>
In-Reply-To: <20260710010718.20318-1-blbllhy@gmail.com>
To: Cen Zhang (Microsoft) <blbllhy@gmail.com>
Cc: marcelo.leitner@gmail.com, lucien.xin@gmail.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, AutonomousCodeSecurity@microsoft.com,
 tgopinath@linux.microsoft.com, kys@microsoft.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  9 Jul 2026 21:07:18 -0400 you wrote:
> When processing a RESET_IN_REQUEST from a peer,
> sctp_process_strreset_inreq() derives the stream count from the
> parameter length but does not check whether the resulting
> RESET_OUT_REQUEST would exceed SCTP_MAX_CHUNK_LEN.
> 
> The OUT request header (sctp_strreset_outreq, 16 bytes) is 8 bytes
> larger than the IN request header (sctp_strreset_inreq, 8 bytes).
> Generally, the IP payload is bounded to 65535 bytes, so the stream
> list cannot be large enough to trigger the overflow. However, on
> interfaces with MTU > 65535 (e.g., loopback with IPv6 jumbograms), a
> stream list that fits within the incoming IN parameter can cause a
> __u16 overflow in sctp_make_strreset_req() when computing the OUT
> request size, leading to an undersized skb allocation and a kernel
> BUG:
> 
> [...]

Here is the summary with links:
  - [net,v2] sctp: validate stream count in sctp_process_strreset_inreq()
    https://git.kernel.org/netdev/net/c/18ae07691d43

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


