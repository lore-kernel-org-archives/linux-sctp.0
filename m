Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83333395AD1;
	Fri, 16 Oct 2026 02:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792116609; cv=none; b=dg2KClj1Ph4GrHc1mDOJIRJJLUsgb/s09lyqAp77PEw8GlJ/UK7hZLFljXanJ7OUpEK6J1Jtjzua9m1yIBSIDRXi2gBbXLtLb9/rxffr9kbBCGRIBmWZboPF9vb/fBbdBHpIFwp3iDTpAVtNcSIJWNDPmnOV+LefpOH+kZW2lIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792116609; c=relaxed/simple;
	bh=Thx/QXZP53cUGeYkfebhaPvrjgU0lQTD8ZxDZ1v1NGU=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=nkAoJjZsOeC/yGnz9CKR1UH7neMXEmsMlSdRMKCwv/jB4WbMRij4dYJem2Kn4okZrKL04Jebv+2K0yKVArTxh8fmBnEIMlQXQjoPgwGaPQWR2CajyG6BkWOMtdWwPD7aRNy1y7Ne4kELLIOxOkZIOWGZ4qNL4VUSaHZqx6uevxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n/65av8O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n/65av8O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 070041F000C4;
	Fri, 16 Oct 2026 02:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792116608;
	bh=gxfYagp3axy9cqxCmHLr7Vq0FLJUqYkO7jGhBmT8Cnc=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=n/65av8O0Hb3WoZxsnGqv1ssUBoRv0SbeG1WZj9QLKrXtSAulPaOau1BaPgjve/Je
	 J1JS1+wUi3ad6lYXOzuZuv4SuX5iRbwhMlQ1XFZGEGFOnUywSkL2Hy/9oZfvla+d8Y
	 ypcQAh556kKGA19xZ4zqqwojSLXsUr2xZgXA93AgwW6EsosltLBiovuaBkt21X8MKs
	 vB583rOWbMZGCYd5J3TpJlOaOVc32S1Ut4nBd68geuIgC53e4F6ZMIDBeCkKE0hJTj
	 eUyD7mpWH6EgEqk6PZhy9fT5/e0rY4hnXNlSKslHtxlDgVEwT5a0LF77FYizi8tKEB
	 28cut4wjoRJvQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id F14E53808209;
	Fri, 16 Oct 2026 02:10:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] sctp: hold transport reference across connect wait
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179211660652.15365.9258742477536896308.git-patchwork-notify@kernel.org>
Date: Fri, 16 Oct 2026 02:10:06 +0000
References: <20261011162750.1529631-1-guncraft2000@naver.com>
In-Reply-To: <20261011162750.1529631-1-guncraft2000@naver.com>
To: Seung Min Shin <guncraft2000@naver.com>
Cc: marcelo.leitner@gmail.com, lucien.xin@gmail.com, davem@davemloft.net,
 edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Sun, 11 Oct 2026 16:27:50 +0000 you wrote:
> sctp_sendmsg_to_asoc() selects a transport before waiting for a new
> interleaved association to become established. sctp_wait_for_connect()
> drops the socket lock while sleeping.
> 
> While the lock is dropped, backlog processing can handle a COOKIE ACK and
> an ASCONF DEL-IP that removes the selected transport. sctp_assoc_rm_peer()
> then marks the transport dead and drops its association-owned reference.
> The transport can be freed through RCU before the send path resumes.
> 
> [...]

Here is the summary with links:
  - [net,v2] sctp: hold transport reference across connect wait
    https://git.kernel.org/netdev/net/c/5bef8649bb9a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


