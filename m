Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CEB4374A1E;
	Thu, 23 Jul 2026 17:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784828443; cv=none; b=cGw3FtWETVPVh/IZpc8SXHR6kanT5JRFit8HJt4GZxr7YylLnfybe6gilUZUB7P/XngUorspXZ42wHVJbUdtx+5ehJ8bvdCd+YX8ugK9vt5MGbxDTtNZmEoDzTD6NB/qNUF7bl80rgrtCdlX3VLSiikoIC6EKQhNGWNTPjzV6R0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784828443; c=relaxed/simple;
	bh=SnFlvyaseEncJm2aLtYY+o5ev+phymTzaCYxZHe7roA=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=HdA5d5sRImJb1nlyjz3BPD1+bbPdPJHnlxPnE5N3TWI5ZyKw+2ZnocM32OPcj0V6XHQbRBqY3xJ86r03K6J0OowcNh0jZZKxF27Ct+TOFYIQg5NBfxXKSZ241YiS0NkzE2qXNNRWPiWxFo737v5PCyRFniPm8MnHtS9Q4PdDwQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b+jq+xza; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b+jq+xza"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A859D1F000E9;
	Thu, 23 Jul 2026 17:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784828439;
	bh=KK9sSOVTD/vTJ9FSoose45zkXPuXl2YBf0g+LbFukLI=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=b+jq+xzavsJd9IJ3MFHuYti7vRYVSbum1hiP1LGFAy/t0se0PIP5vD5wZuMbOMEDX
	 6qrVc99g2ThqQJRDyZjdEfpzlbFoIpmwi07fI4iNwenJCUjX75dykIXfCTHgwnXEK3
	 o4qtSoWb0QvKeBczikqJey3xheyi5XpK69ZqR71F/KrV862bYaRhQ+syZJ9hcKnNCZ
	 NS7CRBm2giKg2ZDkUvtB2ORE09qOs20YvgPDw/qE06+SeCWUBja8O7+/vZN9kAzM5N
	 JLHajK1/iGROcOwworgCYygX3RzMsXsFWJKywLmj2BWJXkhDSe82wYNlVzPh0pDT7f
	 jmHCFBYFuDEzA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EA3DB39244CA;
	Thu, 23 Jul 2026 17:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3] sctp: don't free the ASCONF's own transport in
 DEL-IP
 processing
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178482840779.2802214.4496095044368060549.git-patchwork-notify@kernel.org>
Date: Thu, 23 Jul 2026 17:40:07 +0000
References: <tencent_73762ED1DF08CC9D5F5F61954B01350CFE0A@qq.com>
In-Reply-To: <tencent_73762ED1DF08CC9D5F5F61954B01350CFE0A@qq.com>
To: Jun Yang <1753810072@qq.com>
Cc: netdev@vger.kernel.org, marcelo.leitner@gmail.com, lucien.xin@gmail.com,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 horms@kernel.org, linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org,
 junvyyang@tencent.com, stable@kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 21 Jul 2026 21:14:05 +0800 you wrote:
> From: Jun Yang <junvyyang@tencent.com>
> 
> sctp_process_asconf() caches the transport the ASCONF chunk is processed
> against in asconf->transport (== chunk->transport, set once in sctp_rcv()).
> For an ASCONF located through its Address Parameter by
> __sctp_rcv_asconf_lookup(), that cached transport corresponds to the
> Address Parameter, which need not be the packet's source address.
> 
> [...]

Here is the summary with links:
  - [net,v3] sctp: don't free the ASCONF's own transport in DEL-IP processing
    https://git.kernel.org/netdev/net/c/9b2854f86f0b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


