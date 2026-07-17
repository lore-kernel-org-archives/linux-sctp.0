Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 701C2391845;
	Fri, 17 Jul 2026 10:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784284834; cv=none; b=k1jmX65Qmzn3WPN5aiwx7zVfdUmXL0x9MLAmyGUTQ/HRgVhGJCHk95JvdrK7OZ47r+AlcLXE2pN7ZMFvyXaLANEe3vGV1NXQL/wTCt9N5NAxpCUzwpe6vSUXtLR/tCtJ/ilxJwUS53oYeBJRShlaLil6KHnX3Gx05FJF26C4vUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784284834; c=relaxed/simple;
	bh=wDRQjV2NWv+nT+IRrzmnAoPonHbUnUqHReVqdFQD+64=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=o/JDNaEwVEWtvXnbLBTVE8hmLfozrSZhWYr0zpNUOHjM26OVKdLvQNii53nstKU9O9YRk/uv2/cVqpqOgK++PYR1EeDQMt9TRE2lDg3gj4cUNQ6VdQeMGqtkIW641TGHnkYKJSe50l3xyQX30kmpyQLbqSn+ZBkrQd1uJfnvlUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PJbJRj5C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PJbJRj5C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15FCF1F00A3A;
	Fri, 17 Jul 2026 10:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784284833;
	bh=UVs96BpTZpRGCPh9xaWllTLgXRHMkfolXoaMiUYKhAQ=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=PJbJRj5COBOBxPirwYVpL3VH15D07TI9ZPydNRCs6gXHoultSZPe7VdAY4w9/8Czp
	 OuuJvvsi5nOQAbnMs6N6KKLrOLxK6rSo7apBKTiQaFISY/RQ8A4Sfacq4z4CZgroy5
	 jxebB0q2jveMSF7PNOI4X1AbpyANYGePoxapV7m1lNEBMXnZTC2sMXW5SImoehPVOU
	 aGF8MDq2mCa4PGfrOvwj2+MoPmguaQr8YLRwDAtM63r9+mDQg5YrYnqaPUMDuVZ7FS
	 M7dI4O6bfkDbqqYR4h5h3QYX4ZTJxUYSsCd5nYRKWppfI4DOpWzfyXkcJXEmuAPvco
	 Z/KuX6zfSW0XQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D0A90380CED3;
	Fri, 17 Jul 2026 10:40:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] sctp: fix auth_hmacs array size in struct sctp_cookie
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178428480540.1657856.6779398853994856564.git-patchwork-notify@kernel.org>
Date: Fri, 17 Jul 2026 10:40:05 +0000
References: 
 <634a0de0d5de29532915e6d47c92a0cbc206e03f.1783707155.git.lucien.xin@gmail.com>
In-Reply-To: 
 <634a0de0d5de29532915e6d47c92a0cbc206e03f.1783707155.git.lucien.xin@gmail.com>
To: Xin Long <lucien.xin@gmail.com>
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, davem@davemloft.net,
 kuba@kernel.org, edumazet@google.com, pabeni@redhat.com, horms@kernel.org,
 marcelo.leitner@gmail.com, yuantan098@gmail.com, dstsmallbird@foxmail.com,
 xizh2024@lzu.edu.cn, enjou1224z@gmail.com

Hello:

This patch was applied to netdev/net.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Fri, 10 Jul 2026 14:12:35 -0400 you wrote:
> The auth_hmacs array in struct sctp_cookie is supposed to store a complete
> SCTP_AUTH_HMAC_ALGO parameter, which consists of a struct sctp_paramhdr
> followed by N HMAC identifiers.
> 
> However, the array size was calculated using an extra 2 bytes instead of
> sizeof(struct sctp_paramhdr), which is 4 bytes. When four HMAC identifiers
> are configured, the HMAC-ALGO parameter stored in the endpoint is larger
> than the auth_hmacs buffer in the cookie.
> 
> [...]

Here is the summary with links:
  - [net] sctp: fix auth_hmacs array size in struct sctp_cookie
    https://git.kernel.org/netdev/net/c/e0b5252a5938

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


