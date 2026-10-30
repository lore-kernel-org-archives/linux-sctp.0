Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793398206;
	b=pCssJuyouW9/b5h5KqsI/958dte4w3/N9A5Rynmr/6DP3zi5FYotfXzOmg3lK9Po1lU6
	 /7MZq8uYPGS8v8jjBkBzeJ2WxJ/iIS9HdwavHpSjJqy4Gx2vHtlyl/ku8VtTTayNxwy/m
	 maT9K2qnI8We3gjWczATPn/XkZKicKzDWCNUc7ghjMNdFLsway9LrQK2XcLtPqTX/Gwtg
	 lKwzEZFDDADmN6eg+vq9Vqz7gLxLBR9gJsbQ7DJN8SfqnaOvyb/qzFaguswYxFCvswIPe
	 qmGPmEztMTMDY30xGI6g+RJ71wadwEG4J088jtvHDVZ2g95oL3cstkBSVaCu8MN8KsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793398206;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=CacpoIiwxOW4aqpf4E7cdOUOSLNbY/mAK7YBQamRQ+I=;
	b=5tDgsFzErIYNMq/gPhe3eKcqymbACxChhnobH9QyDtjn5/bQvASxVx2pqlBoyNITltTJ
	 Paievapg0jIBdTKYhZ8hLr2BbDY0L55fpeLQd2SWBbqk6Wo9oS1x4Zab5yFk/sB2WBjhW
	 OTpXjm4upglCkc9/3CASl6If4QNMKwZ6n1tSU+S6LxaqMIqVu9EfegoIH/NAbN0CENU/d
	 5kts3WmM7TsuifVYI+Qmls74zz/bpdFEy3g4ggeIKIiB5ZP+CvUFJminfMBNsu0YrgmJT
	 3UtP62T0ANk8wVd/ugSerU3ALZdiXzQLC5y1P/yRWquPqK9KxHYUGnNWwjB7+Zg9xdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LqGBxai3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46F58606A31A;
	Fri, 30 Oct 2026 22:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LqGBxai3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C60181F0093A;
	Fri, 30 Oct 2026 22:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793398205;
	bh=CacpoIiwxOW4aqpf4E7cdOUOSLNbY/mAK7YBQamRQ+I=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=LqGBxai3uwM/30lxdhdBhrx6t56DkrPZUdbX9baeXbLJFQjj90xSha58D9meY30aw
	 B4CYQhb9SYt8+4yJ9MewYj9k/eXAgXCEdC+aQP3Ea95N1zbZMgSIr2oW8m3++n10g3
	 Ayvowi0RPQWkQWBCc8CqQq/wwto3zq5ZytfVIcKw2VlLGH677tGXB3UYW1XbbQoNw3
	 o9+3Bw2arMfNe5faj4OjqnCntdgmrGyeWY2nkQ/HXOYKD/illcVj/H8cSqU89BimgU
	 2PQgF01Ap6Q+1pdg+GpsGZh4BE/n6GZGv7ZO3V8+vkzMZttSoZ3WiOVf8MOKbcrv9r
	 s/81IXNvoSAXA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id BA3D43800478;
	Fri, 30 Oct 2026 22:10:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Post: <mailto:linux-sctp@vger.kernel.org>
List-Help: <mailto:linux-sctp+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sctp+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] sctp: account for chunk padding in sctp_init_cause()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179339820455.1798442.18307539223937960628.git-patchwork-notify@kernel.org>
Date: Fri, 30 Oct 2026 22:10:04 +0000
References: <20261027082405.1297-1-shengshilingmu97@gmail.com>
In-Reply-To: <20261027082405.1297-1-shengshilingmu97@gmail.com>
To: =?utf-8?b?44K944O844K544OI44Oe44OIIDxzaGVuZ3NoaWxpbmdtdTk3QGdtYWlsLmNvbT4=?=@aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org
Cc: marcelo.leitner@gmail.com, lucien.xin@gmail.com, davem@davemloft.net,
 edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 27 Oct 2026 17:24:05 +0900 you wrote:
> sctp_init_cause() accepts a chunk when skb_tailroom() can hold the
> cause header and the payload. sctp_addto_chunk() then writes 0-3
> bytes of padding before that header so the chunk stays 4-byte
> aligned. The check does not include the padding, and the following
> skb_put() calls skb_over_panic() from softirq.
> 
> Count the padding sctp_addto_chunk() is about to write. The cause
> length on the wire stays the header plus the payload.
> 
> [...]

Here is the summary with links:
  - [net] sctp: account for chunk padding in sctp_init_cause()
    https://git.kernel.org/netdev/net/c/ed6c53b27be4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


