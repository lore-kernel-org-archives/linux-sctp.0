Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E23E12D77F5;
	Sun, 30 Aug 2026 21:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788126091; cv=none; b=nTx1DbnRsd/DZE0n6l/jS5G5/+fs4nBZJl7tUvpZ5qOD1gCA9Gt315kuqVZvCdMu3GEmzAws7HYcEtza6kTPlZ+rESyCf29SLk6vOZYCaMO8aaGP2EQnrcLggzw2PTvHO9ewk3XzbuE74qyS/F75ec6g471XSTu5fkVYMeeG0Ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788126091; c=relaxed/simple;
	bh=mMACKwjEfZDQVbElJ20EBKoc2WKl43cpibATr0qQcWc=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=ScaxjEJ5xSfyRm5X8qmk181slccIN2aeFLB+zNagaZJM2QEeZEpCztwyfBVuvvqMq1Jz6s1v8wKRwta+nxq4oz4zfMtLTfh4aj6A+jLgiD00pcaOsOxspca5feyDfybsO0FvVr2JSn59UZ0vApTzaFnwC2sRBDAaiuxbaDimMfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BWAaBHet; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BWAaBHet"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 873F91F000E9;
	Sun, 30 Aug 2026 21:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788126089;
	bh=soBtBSOXcQHg7oVOMevFlrrw5MTLLEfqfnsBTyXWzyg=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=BWAaBHetKKYe6TRCZrCYhggGgCF/CcrBMEbxwYc4kdH3iptWHNDGeOJa/RlWD8nKj
	 cSgC19caxTf+GqdJ22nwC8WbUcbOiwlpvpR/YZyccrTxivZnSqVDbIp+nqNnb3pxi0
	 roiBazeOeFEapW9j9UEHT+IMjS0rZw3v+puY0zh5COScrJb1qQvxallXQeYcDuwz+T
	 viV2+egBV8dGKfJOi8n2lgnNGx6evKWzUHctA0MgyMTts6xqvbC35MfDBFGwKPMnNg
	 YJ0XRtPPTvIy9O9bVsqU0F/R9zVGOu1yiMWX1tzxkBAREYrVYLi4KNf4RTZUiHp33e
	 MmfdywyvoHafQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 568C0380CEF0;
	Sun, 30 Aug 2026 21:40:34 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3] sctp: fix soft lockup from unpadded ASCONF-ACK
 parameter iteration
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178812603290.3466124.8818841222403620605.git-patchwork-notify@kernel.org>
Date: Sun, 30 Aug 2026 21:40:32 +0000
References: <20260828042431.3873725-1-bsdhenrymartin@gmail.com>
In-Reply-To: <20260828042431.3873725-1-bsdhenrymartin@gmail.com>
To: Henry Martin <bsdhenrymartin@gmail.com>
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
 marcelo.leitner@gmail.com, lucien.xin@gmail.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 28 Aug 2026 12:24:25 +0800 you wrote:
> sctp_verify_asconf() walks ASCONF-ACK parameters with
> sctp_walk_params(), which advances by SCTP_PAD4(length), while the
> consumer sctp_get_asconf_response() iterates the same parameters
> advancing by the raw length, without padding. A single odd-length
> parameter desynchronises the two walks and makes the consumer
> interpret attacker-controlled bytes at a misaligned offset.
> 
> [...]

Here is the summary with links:
  - [net,v3] sctp: fix soft lockup from unpadded ASCONF-ACK parameter iteration
    https://git.kernel.org/netdev/net/c/2cb0b0b1ed69

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


