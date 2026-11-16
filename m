Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794870606;
	b=eqCwK56xLqr70uNSAmcHou80OWMe4kBtZfIl3yuZLkKZBANuwLBN/bqirSEw9/UcFLnR
	 6rfe/jieu/vlJBY+ucisQz8VqQrUxwyG4nQ0Y/QHeZBpQbf8vw2fD78caQ6Du2QfS0Gsz
	 RKC0eeE/6dmM3wgYgI59UkSU8VEEgTKH73V36LHCwFvOBVbvwaYkfJWrnjxokQ2UJ662Q
	 G6NKoABEWm9q4WPXIFBcufewU/CsFnekZQzKophfidpVzlRvYnzyklhhA/3toDrWESxee
	 6BAoAa7y5TLzusctO2VURY8pX8NzYINS+N+xtw6N4doXIQDs8RX98AeVQ6n3gPgsiRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794870606;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=Zi0Vngr2PvlZn4luk9kaLbwPJqqQcYvA4fkK7cWps3c=;
	b=oe1nDaQf9tgdtakMzntNp3ewdpcwYI3MArIi5W6NnguPzBBYWo7YCKRozxforCId59X6
	 PJQ6/Iv6rsYGBk3/6sPfS+SEK3LlBUdVF81SRio2vdoBq+EmBC1/p6emxi0/KW7FdWe+B
	 deljQzcpTuvyA8aECRclsY/jesk8Ykemp8PS8uVcB9fZ4cnvmVGsxWEUDEPXeRBwmvtFn
	 +TV/2+5y+GH3ee3FzeFUXfXxeAcNbv3TvlEq8u8UfUteiJf99m8N2SG/K+jfV+Ev2fo45
	 KqujDHD9+3Wk4A62v0Rz+JaKnMQkkyGBI4lms2I/oadCYMiGkcNtr+F1K3WrGP3THow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XHRmkP7E;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81E73606A31C;
	Mon, 16 Nov 2026 23:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XHRmkP7E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0786B1F000C4;
	Mon, 16 Nov 2026 23:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794870606;
	bh=Zi0Vngr2PvlZn4luk9kaLbwPJqqQcYvA4fkK7cWps3c=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=XHRmkP7E3u8GRTwkbU/efM5VpMjPiTll04nP+Z4IgcpFqtpmayHSQ+9OSpcjrcGqv
	 U2nByBR9vEi/XR6gPjsYaemlNQX1kMb3YCgbtcIZtusL2KI8kH60qjYPnAKu4fsRbW
	 M2as74L1wayluX//LvxZo3oClUAI2xb78ywQDt3AEmw4DPFIB2L4zvV/SViYjdloaG
	 ddU9FAWBdbM9WTLehN8gq7yAEv4eK5R+YM3Sw2mIqG0oOuKurC9Z/aYv+/i7Q0magZ
	 Nf4dneL2sAaXgpVZAdY/GGgyN686UP6+BZ7D1hp3Gio5zfp4mKF0FybDZHLceqyVEe
	 UkHJrF4HaER+A==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id F1694391AFF3;
	Mon, 16 Nov 2026 23:10:05 +0000 (UTC)
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
Subject: Re: [PATCH v2] sctp: fix skb_over_panic when adding addresses with a
 pending delete of another family
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179487060478.226679.13357855318133838071.git-patchwork-notify@kernel.org>
Date: Mon, 16 Nov 2026 23:10:04 +0000
References: <20261111082313.1606366-1-bsdhenrymartin@gmail.com>
In-Reply-To: <20261111082313.1606366-1-bsdhenrymartin@gmail.com>
To: Henry Martin <bsdhenrymartin@gmail.com>
Cc: lucien.xin@gmail.com, marcelo.leitner@gmail.com, davem@davemloft.net,
 kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, edumazet@kernel.org,
 linux-sctp@vger.kernel.org, netdev@vger.kernel.org, stable@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 11 Nov 2026 16:23:13 +0800 you wrote:
> sctp_make_asconf_update_ip() accounts for a pending DEL_IP
> parameter by reusing the length of the address being added. The
> write-back side instead serializes the pending address itself,
> with its own address family. If the pending delete is IPv6
> (20-byte parameter) while the added addresses are IPv4 (8-byte),
> the chunk is allocated 12 bytes short and sctp_addto_chunk()
> writes past the end of the skb. E.g. on mainline (05441d697f7f):
> 
> [...]

Here is the summary with links:
  - [v2] sctp: fix skb_over_panic when adding addresses with a pending delete of another family
    https://git.kernel.org/netdev/net/c/ce09d8c13a15

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


