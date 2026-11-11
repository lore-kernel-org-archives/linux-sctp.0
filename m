Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794391213;
	b=OwiyLUdrAUTviLgPl96Fx1+PnuUNChdB2sR8ioNRRfb9QZqt1IkkS+0QAJ54VhIJPmBQ
	 RxaViK5N3uuwFzxjyG4oDe0oaCsUTG5dA2pQfWD86fnQa4AOBdC0txmS8HjWlMtDSp9Jv
	 wUQcbeVAk8oxl7MGUQ5Up1cOTc2BJvY+DoqMnekw7dGw1ZOILDj02BnI14OkCNuhvraj/
	 8OVW0glHM67PHsOfKcjp/cdMesAep4Mj7IkgJwQYLl7XOQAZNJ7PpPSfFxsczLuta+Zqe
	 HkvZUMiEy3hDhoWvpAt+IT9IZeNc8Man5R1aM29hrfYq/50dY0iwzkTXet3EAIvCqGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794391213;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=erVicnyjczVKlKp332KmmkcaVpFm/vkH+cMMIWc4UWs=;
	b=X99I0oQjvOWgM/rIL1oOsZ3Afgoh5iO0AB/t46GC1SKqbodeIscsfD5LGEGcnMJTT2K8
	 WvrPFmgXtE24PeU8ULN0l9xHwbp/ugAVJgbIAtNG3u3AuDLN88nKpphk3BU9y9FPaM4Kz
	 CoRXdET++/Eq7fxKSkr138FdvwbL1vHAVI6oPfl3ydB+yLvlmYzeco9lUEdUCikeWvYx3
	 Z+Pv+jAqkVqVQI+c5wccPxv3KXJUJUyh/0Icrz5E7GXFi6AWNc6sjX0ktdiAuhX1g6Hhc
	 j/12lKMy7FpccSNTmJOy/wlNr3uhxvgQ+ONFNcrMARMTCjESU5vD86Oloq0EkwIfITw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iJ4W6S9E;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 193CA60A2602;
	Wed, 11 Nov 2026 10:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iJ4W6S9E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A68E01F00A05;
	Wed, 11 Nov 2026 10:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794391212;
	bh=erVicnyjczVKlKp332KmmkcaVpFm/vkH+cMMIWc4UWs=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=iJ4W6S9E3fB7xmJN1PqrBfF7/XtlKxHmKlYXHhBt/8b7jdBu0A2NyNBmbqti4qQZK
	 Hz06Tznkkc/gAigTWncKjg5Z9IgxZTc09gHBfr3ls4JD5FJVJ+9YM84M7eElOFfG4S
	 7D+lIml68xSB7yJek5kNHTIZZmzAsceG7guuV6hXTlOgj4hT7XIeNs1lr1u6afg687
	 7l7K981FgpNUxrGVno9zkMBJQwO7h/nbEQ3yZkWoPXdYezoVqVjsVufwYUuxFIdd7e
	 Kyrq0VQFre0awKtnTcM8wVjBBReYzNyOWI/EJC8H0w+d4ralPzYu/K1QXZAawZQKfx
	 gujdwn9KJxdGg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 9B23C38007EB;
	Wed, 11 Nov 2026 10:00:12 +0000 (UTC)
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
Subject: Re: [PATCH net v3] sctp: fix ASCONF address change on single-homed
 hosts
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179439121114.835340.17836695367484494934.git-patchwork-notify@kernel.org>
Date: Wed, 11 Nov 2026 10:00:11 +0000
References: <20261106195126.1563231-1-andrey.misyrov@gmail.com>
In-Reply-To: <20261106195126.1563231-1-andrey.misyrov@gmail.com>
To: Andrey Misiurov <andrey.misyrov@gmail.com>
Cc: marcelo.leitner@gmail.com, lucien.xin@gmail.com, junvyyang@tencent.com,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 horms@kernel.org, linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>:

On Fri,  6 Nov 2026 20:51:26 +0100 you wrote:
> Commit 9b2854f86f0b ("sctp: don't free the ASCONF's own transport in
> DEL-IP processing") refuses a DEL-IP of the transport the ASCONF was
> located by, so that a later wildcard DEL-IP cannot use it after free.
> 
> This also breaks the single-homed address change (RFC 5061 5.3.2). The
> host sends [Address Parameter L] [ADD-IP S] [DEL-IP L], the association
> is located by L, and DEL-IP L is now refused. The sender never gets an
> all-success ASCONF-ACK, keeps src_out_of_asoc_ok set and stops sending
> data, so the association stalls.
> 
> [...]

Here is the summary with links:
  - [net,v3] sctp: fix ASCONF address change on single-homed hosts
    https://git.kernel.org/netdev/net/c/5175b2fb34c7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


