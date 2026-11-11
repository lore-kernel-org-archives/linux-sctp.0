Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794358208;
	b=lewwO6b4VPI1qO6pbLJ47Xg4hRojn7YwW+o7w9Kezw4jEESN73ke4fzxEoRwIkQnV/L/
	 g5WTkNZDaNebEzy6Sz4yfCEgHK79g1aMvs5uRg2dgc+z2vo/5JQ7x+4J/ySdypWKgRdXz
	 QkrREm+aRvWioVPrE3QHzSmyxka+NtQ1yonhtHcVY4Ji1VO0XR1JSk2hwgWwJ9UOsYrqv
	 nSjFhccFp9I0b5tEpb3whRBiBsWlpOccK2gUkTaTKrG1xwOTvwJ+65cgyW5QEST65uNXr
	 +ba897H2cLElsdQUTl4toH++2RmqSf0SwnMeSTkDXsovVDoPf7hc69ns68kT/KE8RYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794358208;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=+zYwXBSWiIa4Uc/dKRVTAU5d6jEgNZcYQYOhqHVEoS8=;
	b=iylZTu6z0joqG7HyTyo6y8JBTydgXfqfaOxTtAT4ahO31RuQrUl2G9ZtkXMQ2fH86R5z
	 peWTuH3/x6b/9yzcRUppEg0mt+btG++7FnQQubWQkMj9Y8Llk85g9j+VbxJgJedsX+X66
	 sZyg5wGQ9H5DZwIMKlxFYNQFo/hYVwZ9dc95/+Hh81SNUT+238dnpiGaUJR49vH0ySwyc
	 eUKWPoVyRbn+hsU66yJkGF0Nrcatdtno13hNVgzJWADT8QqbdKzW/HyJUoVctrruAcG1S
	 Fo+Mh9WpPZuBiYppm1l9RweMk6zeJGrWetFWLZVuxSP/n/kwUsLw0LWFn8T/LcUqosQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PUH5A4rj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45637606A332;
	Wed, 11 Nov 2026 00:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PUH5A4rj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E41601F0089F;
	Wed, 11 Nov 2026 00:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794358208;
	bh=+zYwXBSWiIa4Uc/dKRVTAU5d6jEgNZcYQYOhqHVEoS8=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=PUH5A4rjgfKNS9JGYASmTxM7TrDfBx/+pGmSly3Xeij0IwTpKFM3oARoiFViNyC9w
	 0AR3ciUs/SD2sNXyYWeB+O4N4qnOhQANJBMowrt3j/QNgMWtDnWO7tWEC/+3uolpSd
	 QgbzCKuat0WcEBBflBJTDW9PjpoGAhAIUek/brTs718uvr3eS3Hi0O7oFm1bGa+gwH
	 4ungAvvns7Ofxc/pZkltj39G3TEnTVbodTWM9Iku1bXrkpBhRCAhMBc4CD8WXnzBoI
	 gBXhd86+6VRIakfXMWAexNoGySFfwY9B1Dmkc30Aeo2Rvlp6imTeeO/pVQtNQAWsDC
	 EPaUzxjaIyjkQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D81C839E8A55;
	Wed, 11 Nov 2026 00:50:07 +0000 (UTC)
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
Subject: Re: [PATCH net] sctp: reset stored flag for each association
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179435820642.142717.18022785803325476057.git-patchwork-notify@kernel.org>
Date: Wed, 11 Nov 2026 00:50:06 +0000
References: <20261108161149.2774119-1-bestswngs@gmail.com>
In-Reply-To: <20261108161149.2774119-1-bestswngs@gmail.com>
To: Weiming Shi <bestswngs@gmail.com>
Cc: marcelo.leitner@gmail.com, lucien.xin@gmail.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, yjwei@cn.fujitsu.com, micchie@sfc.wide.ad.jp,
 yoshfuji@linux-ipv6.org, xmei5@asu.edu, stable@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Sun,  8 Nov 2026 08:11:49 -0800 you wrote:
> sctp_send_asconf_del_ip() walks every association on an endpoint. The
> stored flag records that the current association took the single-homed
> deferral path and therefore did not allocate an ASCONF chunk. It is
> currently scoped to the whole function. Once one association sets it,
> later eligible multihomed associations allocate chunks but skip
> sctp_send_asconf(), leaking each chunk and its skb.
> 
> [...]

Here is the summary with links:
  - [net] sctp: reset stored flag for each association
    https://git.kernel.org/netdev/net/c/173712d868eb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


