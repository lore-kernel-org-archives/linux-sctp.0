Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCEF123392A;
	Wed, 10 Jun 2026 01:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781055609; cv=none; b=EgVQiyD+m9t0aV0WycF8ffeoxFMjwOqazOOvgpJxEfU+3PwTmq+GSAmSgn/BTO9EVeChZx6E7dVis0DSMsnXBLPRawvW+3AQiL8C0NejDeDkuUNBBhad9iO6uW0ZCNqxROowvChzCK1oCdYJBGCTJNYpF5p+LZRrYdnNeK2IVaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781055609; c=relaxed/simple;
	bh=RibFigk3XLuMM4KOyyIyM9kw9MXv45GspJfa43PER2c=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=DDWft0wEzqr78WAUOKUKA6XMd50JPzNQq5veyO+Qzxs8vSjk9hTrkk1lptG0tSfzWv00lU/Nnp30E8Bz2Dg27InnU3D+lnt0x4HDrSuBK5Xu1kgVYPWiw9u6POAB5AJLcooOtkIEcJuGecDbThqNy+LeFR7PzxRzwfO7X5/hYck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z5fRbbuR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z5fRbbuR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 779A51F00893;
	Wed, 10 Jun 2026 01:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781055608;
	bh=5M9wnUeAnxwja/i6gtrTW7y0VShjurUeslGrRTQtbug=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=Z5fRbbuRGeIYkoTCDs+9TJz/boXxJNXvSzRzSHA6YmHqaj4mPK1QCBxrbMXu3vEnz
	 Fk3WqQMZ85u0dNhEtqD7nXzZ282ANSXFdeiZVSh24txeYrc0qdrUD74gj0SOyaWRmn
	 jfWeVthbNWsD/2rlSjp87TTe18pzen8zXoFjdSG23jaA6YDmALiWrW//ZOAwbCc5Np
	 kVp0+kFHKW1P/YDUccW50vMC2I6BTb9ZuvbZSEke998TrpzuyxJ8NmkNaz9jEsh99f
	 SLV/qAYE7eekqpgUa9dNYvXkTl/uWak+w4b9alwpFE9t607YBV0RHZvFf0b4jCWbMI
	 xDAgMb6TtBcbQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D0A813930A1F;
	Wed, 10 Jun 2026 01:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] sctp: validate embedded INIT chunk and address list
 lengths in cookie
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178105560664.2786170.13328779773204365683.git-patchwork-notify@kernel.org>
Date: Wed, 10 Jun 2026 01:40:06 +0000
References: 
 <75af23a89adf881a0895d511775e4770da367cbf.1780873427.git.lucien.xin@gmail.com>
In-Reply-To: 
 <75af23a89adf881a0895d511775e4770da367cbf.1780873427.git.lucien.xin@gmail.com>
To: Xin Long <lucien.xin@gmail.com>
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, davem@davemloft.net,
 kuba@kernel.org, edumazet@google.com, pabeni@redhat.com, horms@kernel.org,
 marcelo.leitner@gmail.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Sun,  7 Jun 2026 19:03:47 -0400 you wrote:
> sctp_unpack_cookie() only checked that the embedded INIT chunk length
> did not exceed the remaining cookie payload, but did not ensure that the
> INIT chunk is large enough to contain a complete INIT header.
> 
> A malformed COOKIE_ECHO can therefore carry a truncated INIT chunk whose
> length field is smaller than sizeof(struct sctp_init_chunk).  Later,
> sctp_process_init() accesses INIT parameters unconditionally, which may
> lead to out-of-bounds reads.
> 
> [...]

Here is the summary with links:
  - [net] sctp: validate embedded INIT chunk and address list lengths in cookie
    https://git.kernel.org/netdev/net/c/6f4c80a2a7e6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


