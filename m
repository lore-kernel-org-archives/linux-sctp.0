Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792783807;
	b=HLnZ3DcKNeVXWiIrUhkf7SykjmrXmdVG6HktJFacpmgNb85f9ZNrI1FUrXX5gVo22c0P
	 RYjb5ZOV3An8MKqwMKSl/xAbBauSPN95pwTR5wiQ635/3XJOW+4TJt0bfX1DnqKRYFwnC
	 bEU5zurnfSmI6A3agCh2kknZPIn+Bjdf45giFTSFO9JnA3ajr03KscHh+fW7IuWPWPIgT
	 E/jb8/2gn0KLRfEox4oxh9IYRlxmbRAKGukw6jcaLL0ap87mItwrAe7mJ8y4m7PhWqbBw
	 ADHmK12yx7EURzyMB6rRinspABE+wDynqS2AadxPk7Rbtn3uAAedCgz1v6aX+GqLxNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792783807;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=Awlx3j9nTCCze7NhMfrT6cxk8XyydYWqaAK3fkXJVy0=;
	b=YIWOAv+agy/jgOupAvdB42WcshwOMAI1ogqj2OQKRzNRB5ctXw6Q2U2TgGTQ4xcK7I+a
	 xiG4k0hic428lBhroEv6Rsr/7eZi93Vv353HVxLtyyElaW6Vd31NMOTl1AZ62WqXumGZ/
	 0KjAj3iEAXW6P61MKDe14ChFag5Ab82Ap54sabMr1FlyDzslTmocUPDz5eKSXjmxfkRow
	 Jv0DR4RwBNjHCOxEKRoHL4MNzGHGIGIyUhh5M8C4KHJV1p7RDwngihc3uOHsSrktDHglA
	 BiKAqDFi0lHgWFALGvFUytMbl6VPRt2pnkilq1RtSFrMxalg5yaKzQxc0pYPk7hBz5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Y84eeUa/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F16E5606A31E;
	Fri, 23 Oct 2026 19:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y84eeUa/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BE671F01825;
	Fri, 23 Oct 2026 19:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792783806;
	bh=Awlx3j9nTCCze7NhMfrT6cxk8XyydYWqaAK3fkXJVy0=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=Y84eeUa/wCzRDtNKakgHk2A3pAdJ2vinXjYLtmACtztqwrXQjh9q6FIqkHwnXhVQ0
	 F+3PvLqwD99+TyPaTbOssKgNUDsKiLK1hiPlZn6jsehg3vY183V2vmqqBtXNYwrZi6
	 uQTI6Mi/AclOsz0L823Vh4bjg8DjUMv7V+/OY5ARGI1JyKGpYiwB4mIAPzc4KhGiO5
	 G2jaCrbTgjqGYkDVEuTuyfLhcCmUERO/R46sg9a3DzZHYBrkQVBPu/SzfAUtk9WD/5
	 PC0FnPU3AKyO07B7h5yEoeTdmzWh9moFvYeelo36sdohyEuV5U1gprzOiL9DNUu/Bg
	 dOL4nWDl7GS+A==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 81706391B14F;
	Fri, 23 Oct 2026 19:30:06 +0000 (UTC)
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
Subject: Re: [PATCH v5] sctp: reject forged cookie peer_addr with unknown
 address
 family
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179278380532.1224496.16148284450790135756.git-patchwork-notify@kernel.org>
Date: Fri, 23 Oct 2026 19:30:05 +0000
References: <20261019073747.178626-1-hdthky0@gmail.com>
In-Reply-To: <20261019073747.178626-1-hdthky0@gmail.com>
To: Xingyuan Mo <hdthky0@gmail.com>
Cc: marcelo.leitner@gmail.com, lucien.xin@gmail.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 linux-sctp@vger.kernel.org, netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 19 Oct 2026 15:37:57 +0800 you wrote:
> When cookie authentication is disabled, COOKIE-ECHO peer_addr is
> attacker-controlled. An invalid sa_family made sctp_get_af_specific()
> return NULL and crash in sctp_transport_init() on
> af_specific->sockaddr_len. Validate it with af->addr_valid() in
> sctp_unpack_cookie(), which also rejects a mismatched family, e.g.
> an AF_INET6 peer_addr on an IPv4 socket that would later crash in
> sctp_v6_get_dst() on inet6_sk(sk)->opt. Validate a copy of peer_addr,
> since addr_valid() rewrites a v4-mapped v6 address in place and the
> cookie still lives in the received skb, which is not guaranteed to
> be unshared. Store the validated copy in the new association and
> pass it to sctp_process_init() instead of the raw cookie, so a
> v4-mapped v6 address is normalised to AF_INET before the association
> and its primary transport are built from it.
> 
> [...]

Here is the summary with links:
  - [v5] sctp: reject forged cookie peer_addr with unknown address family
    https://git.kernel.org/netdev/net/c/9802123ceca8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


