Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D7E427CCE0;
	Thu, 30 Jul 2026 00:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785369671; cv=none; b=bTkmUxsGQ0UT/eaKOWlekZm9vTO6sDF08+2X06N3DRwA0RR+fUiMPd2hEebQbWKGvYhz3PD6yvXTkAI363WcH6oQaYXSkwPwxHErkSj3zMpKBRVrunbIu0sjxZOEIdpAvWRtAsS9bIr3uuq391UB44dp2dmvhXIxWH+Jte6G+Mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785369671; c=relaxed/simple;
	bh=EpRhwSYgpESXJjya2Yzkp09DFvB2EmzLt4aIsX2OJ4c=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=hW49aHmjWBWs0RQ6RAZxUU75qNvVvynYNU40pI3AzDMorTrQWYy/LG39vFiApGuFSY3K4WgFV0c9OuS0u4l+K2A3iPPlOu+OYtJqwNeG2sd72UZ0t/NRoZ6EEEHRgW6AwKRC4E/tDLqRl0iIuQ0czR87l8uN2SWGxKF5OoiM8ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kZ/lPTiT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kZ/lPTiT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F32F1F000E9;
	Thu, 30 Jul 2026 00:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785369665;
	bh=RxPePaYyxmfcOjfPbZP8t8xBhLGpbEIK55rNafHTvks=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=kZ/lPTiTCkfGHAUqDn0gsQf6fNv+przKI9urwMD6gpfs6Nop0N43aOLNX1NWgLlev
	 lWhoZAKDnyvfdQmcbLtvoJp68fnLlsXFSsSIihu25k1ck0iJBoj/M1EXhmGRVX5wzT
	 9AnEUtGkxGb2OVUMjEo1YRAkqacbXLl+OKRVXPmuFeLCjRpw4h2iZY+cYCiUtcpidy
	 mEIel6qU++yoJZjiAha43V7zZpbj9akWOBwSpLnpJTLfJWTjpWQEPDDcZOuc8KLw1j
	 sTgAoRRyvTb2DspN8QeWual+HJBW2ORvsM8vTjUEcBwmVstIQ3wRPo0DVQ9ikT9ta/
	 V+Yp4EGTB91qQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D0EAD3926250;
	Thu, 30 Jul 2026 00:00:30 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v5] sctp: auth: discard auth_chunk when skb_clone
 fails
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178536962939.3288516.14815450014088322700.git-patchwork-notify@kernel.org>
Date: Thu, 30 Jul 2026 00:00:29 +0000
References: <20260723061107.384106-1-l1138897701@163.com>
In-Reply-To: <20260723061107.384106-1-l1138897701@163.com>
To: luoqing <l1138897701@163.com>
Cc: lucien.xin@gmail.com, davem@davemloft.net, edumazet@google.com,
 horms@kernel.org, kuba@kernel.org, linux-kernel@vger.kernel.org,
 linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com,
 netdev@vger.kernel.org, pabeni@redhat.com

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 23 Jul 2026 14:11:07 +0800 you wrote:
> From: Qing Luo <luoqing@kylinos.cn>
> 
> When processing AUTH + COOKIE-ECHO packets, if skb_clone() fails
> due to memory pressure, chunk->auth_chunk is NULL. The original
> code still sets chunk->auth = 1 and continues, leaving the
> COOKIE-ECHO to be processed without a valid auth_chunk for
> deferred verification.
> 
> [...]

Here is the summary with links:
  - [net-next,v5] sctp: auth: discard auth_chunk when skb_clone fails
    https://git.kernel.org/netdev/net-next/c/9ae7ed101cf2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


