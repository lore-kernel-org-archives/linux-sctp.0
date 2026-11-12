Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794447012;
	b=vwSwPTX8v9g24Miz/MElRHi9S8GAWFlwVzGBURl9f1ipL9el2dR8E9/XaJv+uUnuQmDY
	 ZfURe8ZbeTeXPnkO3ZuPCAJNQ/ZVhTK9ud4ePupodiMe6O21yYbs303T+OYk/kntXNKbq
	 gHkv9o+1pJNONXLTmZFqGcuWOt6duq75Vk/pQ9MRdDK7ESUPt+iOVUPms3xZ5BdmYueQw
	 zCaYs6of9Ct5t4jnAqCaRwRWhp8S4FrJ1Vbki147HImihzSf0uHxSxN1jOxipb3YQx7mC
	 aH0vmpM5rU0tKaTrACY4MQfkQRnRP36PhGRW1FwF0GS1/g0+YeIXf4bj2a+9OY1+LjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794447012;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=qnDiwghou9b4hL/o+S0CML8wXd5T0Muu0ICUHeawXmk=;
	b=b82L0Da1on1pUWMqloXZ6ZW7W2dSdFfCOzd2bHfd3qGQ9J+KzPLBn1jjaLBzFAVwyywE
	 5K+UiTpQQVfcbhplBqLCsrYhv0jBPUP2BeKFfBLW/WgV3/8Gf18B1tu4BfezIu1wC8f4+
	 noElAKbL5K4hFTsVRVSKgCXKJvAhoLUkEho9uF+J1T922YySZ26ohRA1C3CA6iL0y4Chi
	 /gZTIvkLXB8Y8F0c23L5oXYmQwSmsdeY3WoX9zXcuHemVjoVNvi56xrrP89ejFkhx7nOj
	 ogeGpYIX29I4rc0QghSYq1S/jtlmbDmBq4eF/pGdvT+yIdUH5eGaT+nYl753GGZzfrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KwUSAxwt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BC836074E68;
	Thu, 12 Nov 2026 01:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KwUSAxwt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67A0E1F00A05;
	Thu, 12 Nov 2026 01:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794447012;
	bh=qnDiwghou9b4hL/o+S0CML8wXd5T0Muu0ICUHeawXmk=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=KwUSAxwtPrNsGHq8xFxSnGbKhnaZDI04485lYkaZDgWmSyw5ugGaLyYe4Q8Jgrwhb
	 exUnkVCHKRwW5NKrKYBzHO8VZc3mPs4A4QflAy6xPcwm5S6GruP5xLXVoe21TVFert
	 T1sknXa6bejcTFEqNmsDVVa6C1EUbhMPToQegr0IEWOxNDeTr/6H+/Drx3dAnGR2ql
	 /MH9hJm8Qo66mLjA3jBksW0rJobMiWV1ljzOONkirAn3AgPtxPBMbqY3+d3wGtxpnB
	 PNtCczVYfaE60iCiEefOnJWnoIJV7sU49sMZF8LkFFpAzwjG9Gq8MfnfZBUyrrTdRf
	 utnjfciZRlLjQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 5E184391AFCF;
	Thu, 12 Nov 2026 01:30:12 +0000 (UTC)
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
Subject: Re: [PATCH net v3] sctp: avoid requeueing pending control chunks
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179444701092.1753823.11388298782522084673.git-patchwork-notify@kernel.org>
Date: Thu, 12 Nov 2026 01:30:10 +0000
References: <20261107030532.32310-1-kylebot@openai.com>
In-Reply-To: <20261107030532.32310-1-kylebot@openai.com>
To: Kyle Zeng <kylebot@openai.com>
Cc: linux-sctp@vger.kernel.org, lucien.xin@gmail.com,
 marcelo.leitner@gmail.com, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Fri,  6 Nov 2026 19:05:32 -0800 you wrote:
> The T4 and RE-CONFIG timeout handlers take a reference to their cached
> control chunk and submit it through SCTP_CMD_REPLY. A previous
> transmission can still be on the control outqueue when output is corked
> or suppressed, or when sctp_packet_transmit_chunk() could not append the
> chunk.
> 
> sctp_outq_tail() then adds the same list node a second time. Re-adding a
> non-tail entry can corrupt the list without being caught by the
> insertion-time list checks. A subsequent flush or association teardown
> can access an already freed chunk. The ASCONF path is reproducible by an
> unprivileged SCTP socket owner in a user/network namespace, with KASAN
> reporting a use-after-free in __sctp_outq_teardown().
> 
> [...]

Here is the summary with links:
  - [net,v3] sctp: avoid requeueing pending control chunks
    https://git.kernel.org/netdev/net/c/665b4149e91b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


