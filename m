Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794347408;
	b=o7eQdVfv7qlLaSg5HpgyVxwIVGb7ujIknVBYTrODIa+y7MXab8UX2PZZX16j66XNDOfv
	 rBU49AXPCBCJYFFuYaIo7gMqtKE7FFeah8NiyEU1zOvkMm2EDW/eBeYJXr9jGHmKcY2tR
	 laXHDD1RLXZc9qHXREN2hVmCZ9DMZowQRt16IqmhNXo9tRmnnH0F8zMiNaRifDIukD8IF
	 dmAL6SwULKkU0+Z9DjTycTLQpqtcP97KJxaKG164KSKd6fQJL+nE9vb4TOkpUasaUnem2
	 oggP6hghtII6Cmb79ZC18RkktZpeJOS2S597jitEcN3d5TisdBRFIT6wFM4SEgWktTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794347408;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=Zfnbv4NHqZ/iJ6yvPkwCqRhv/U/5TwJHeVQPxKTt8gU=;
	b=fjEt3iCphXurUnFbhxaJXu2Y04vnmBVeMme3KLVqkdsBLf8ePU3oePFV7AW0J1gfU8N0
	 DF7C8zD3IhkUxajyNjp+cxslr3+Z6v5khWaY9KuDJw/gHQmLTL7/SsnhnSLhYLWQOM+3k
	 +Di2uQg/oQoBPhgfurE/Ggw4g0JnrvLH60K3oB8jS5MLAHtD3YnCsbdKKi876AhqQO8Zw
	 t0xB24AQhD9mZI7cqrM/JpD4qb6tQWvKcW6yXetp3ynkMzJcFCvl81d6eke9q4dcirbPz
	 F7ZaNVpMN5OCsNe4OBjGApu8UyptCxtQGkw45ups6ACWVSQLQ8BZW0V9Lhs8Y0INgRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f692PXHP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B14A606A327;
	Tue, 10 Nov 2026 21:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f692PXHP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3FE71F0089F;
	Tue, 10 Nov 2026 21:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794347407;
	bh=Zfnbv4NHqZ/iJ6yvPkwCqRhv/U/5TwJHeVQPxKTt8gU=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=f692PXHPHu6rw3PRVyBHXqz0Yh+iZeR78VniGOUaZRgCveM74Js9pJHB10fS+iDPO
	 3gKYToGLfOzn8LASgXrtmwvm5Hsu5HhMfyo2v/+DZHBEAk9AeaKJF3ER63GE1970G0
	 et0THMjvzaVcZa/u9ZFiC5LrFcKa4Z2GNk4QznI4DmWeENUvUQxgoaXHJ9qO07suSh
	 WGgkb7s2Y/EpL1rJImbhAX7LfSNGoxf6YCxGnLylolElvcdktNjQ66hjnx525cLfjZ
	 WvpIE077sGekedHGpozvBiL/y73iavAruleJ0QgtaNLcH6mMYZIIw0vFQe5hmqRARs
	 HXP+GBz/oby1g==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 9B0AF39E8A40;
	Tue, 10 Nov 2026 21:50:07 +0000 (UTC)
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
Subject: Re: [PATCH net v2 0/4] sctp: fix I-FORWARD-TSN handling with user
 message
 interleaving
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179434740642.75434.13080099921012201899.git-patchwork-notify@kernel.org>
Date: Tue, 10 Nov 2026 21:50:06 +0000
References: <20261105050225.49292-1-tim.budding@gmail.com>
In-Reply-To: <20261105050225.49292-1-tim.budding@gmail.com>
To: Tim Budding <tim.budding@gmail.com>
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, lucien.xin@gmail.com,
 marcelo.leitner@gmail.com, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, shuah@kernel.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  4 Nov 2026 21:02:21 -0800 you wrote:
> With user message interleaving (RFC 8260), fragments of messages on
> different streams share the TSN space. When a PR-SCTP message is
> abandoned, the receiver still frees queued fragments by the
> I-FORWARD-TSN's New Cumulative TSN, which loses fragments of messages
> still being received on other streams:
> 
>   TSN  stream  MID
>     0    0      0    B   64KB reliable message on stream 0
>   ...
>     5    0      0
>     6    1      0    BE  PR-SCTP message on stream 1, lost, abandoned
>     7    0      0
>   ...
>   I-FORWARD-TSN new_cum=6 skip=[sid=1 mid=0]
> 
> [...]

Here is the summary with links:
  - [net,v2,1/4] sctp: abort unordered partial delivery when its message is skipped
    https://git.kernel.org/netdev/net/c/05852c8b70f2
  - [net,v2,2/4] sctp: report the partially delivered MID in PARTIAL_DELIVERY_ABORTED
    https://git.kernel.org/netdev/net/c/3097fba86801
  - [net,v2,3/4] sctp: fix I-FORWARD-TSN handling of fragments on other streams
    https://git.kernel.org/netdev/net/c/5b9cfc6491a6
  - [net,v2,4/4] selftests: net: add SCTP I-FORWARD-TSN tests with message interleaving
    https://git.kernel.org/netdev/net/c/ee8568a834ac

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


