Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5818E46F4A1;
	Tue, 21 Jul 2026 19:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662846; cv=none; b=Ryjgdfu/CtpzpqAWmM4381ceNuuPzTiELmoAt0BKM+ympFhDswJVzXvyBX2+P4NPf/4pINj/KueCm6n8U9izSv9gF7bjycCGYBYyroND9djj+xeaU1A2FYN/CimAz5H3hGQRGU6KUNyEQR0nBtvKzlgoXyCi5jZ1g9Lw5BcxXr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662846; c=relaxed/simple;
	bh=5NdRsbTtt/4XvR/G+8VxtbMWGB/G8X2RrrrbY0XzykY=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=LQtB84lL1RxXSE6X50AKVQe/45D2FXd3RvNGmWXY0NwG2hm0fULgQo4/vdPXVMelivBZv/2iQK2bAVgc/GFVdyvVk1mtQ4Ag11oJX8qsLJ+eDU2j0yltW/MNhLv3l/r1uWboGg23Sf1q2xYTxgRtvVysqQm7IozP7VoL154e7IA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FNmfAPWo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FNmfAPWo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 261A71F000E9;
	Tue, 21 Jul 2026 19:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784662845;
	bh=Hp3bTm4d4EZBLFQx37jpkl59nUqeTEwwKA644dPxurA=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=FNmfAPWoJoC8p1wHxn5C5Uzw9TatMC3/ADFGxipxojBISSlNqEw6k/MCyJvkoSV8q
	 Xgaw8+ZWymEE62HUyM12e1aFvzvY05bL0tqa0lhZHzmELTYsGr7v6UVZgX3xNy+teJ
	 tdry/2jiZmvZv7BhMvxmGmZsuuEAEMubToVIU5gZcCwot7tphvrIYy9IsxDMKiERdf
	 C9W/YNCsMxBqjxiKuqaDegC0RWk6e1a4Id00Il78Ul6icg9xzOKUZE0n7QiQchrEv0
	 bdCK9LxCRbzERY3nJDgBwCcio4ubOtBfvXbWKPe2W6DjxBht3zZXdngvjoeiqhtcLA
	 T0amhXyL0fEgA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D0BDD39253FD;
	Tue, 21 Jul 2026 19:40:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] sctp: fix auth_chunk_list capacity check in
 sctp_auth_ep_add_chunkid
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178466281438.1001510.4994731581512846995.git-patchwork-notify@kernel.org>
Date: Tue, 21 Jul 2026 19:40:14 +0000
References: <20260713032021.3491702-1-zhoujian.zja@antgroup.com>
In-Reply-To: <20260713032021.3491702-1-zhoujian.zja@antgroup.com>
To: =?utf-8?b?5a+S5rOJIDxlaWxhaW1lbWVkc25haW1lbEBnbWFpbC5jb20+?=@aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org
Cc: marcelo.leitner@gmail.com, lucien.xin@gmail.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 13 Jul 2026 03:20:21 +0000 you wrote:
> From: HanQuan <eilaimemedsnaimel@gmail.com>
> 
> sctp_auth_ep_add_chunkid() uses SCTP_NUM_CHUNK_TYPES (20) as the
> capacity limit for ep->auth_chunk_list, allowing it to hold up to
> 20 chunk entries (param_hdr.length up to 24). However, the copy
> destination asoc->c.auth_chunks in struct sctp_cookie is only
> SCTP_AUTH_MAX_CHUNKS (16) entries (20 bytes). When more than 16
> chunks are added, sctp_association_init() memcpy overflows the
> destination by up to 4 bytes.
> 
> [...]

Here is the summary with links:
  - [v2] sctp: fix auth_chunk_list capacity check in sctp_auth_ep_add_chunkid
    https://git.kernel.org/netdev/net/c/ff04b26794a1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


