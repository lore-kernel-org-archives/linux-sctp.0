Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0450F192590;
	Fri, 10 Apr 2026 03:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775790653; cv=none; b=rr6+2dPLCxs1X4jo8HnJ7Dcg8OG3tXIt3yF7Pqd7sf7IaLRbo+0k10XS4UWmTNo+vw4p+oHpx2ACdRHQPZQinsDPKoSDcFpAKmedXT0FZwMAPHRxLwmJOeOaSXXvpoSM1fzbqUv0U7OWowLkWo0wMnEcWAJ2EEO7lcHEgZDmOWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775790653; c=relaxed/simple;
	bh=bZMexQwpHbjXFeqi6uLP4EmIoR8cjmfGSYMJHlfpauw=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=LUcw4iex1hqceYX7gWV23Pr9qvQOzS0RHsfg8hiovs2zMu0tEEuCh1xkQBym6icxxl672qMiSyTs8QyZrIsXNMaG644uG2U/fZ5l3tJ+sD9jt7qYdyrFJNlyyeeZnXivm6C00bdhApC8KskI+UVmZXQGG4QAIqcell08AhyRoHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h+LtoBkW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h+LtoBkW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EA8AC4CEF7;
	Fri, 10 Apr 2026 03:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775790650;
	bh=bZMexQwpHbjXFeqi6uLP4EmIoR8cjmfGSYMJHlfpauw=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=h+LtoBkWzTbr31O1rpGN1//Q8IRQ3m40Re957Bys2TvgzaDru7cna039SnS0thfdw
	 3owAZIPMpUd2bNciLs+lysEEE4LGEIS8hP0mLPUzp4nVCfDz1Taa2LKI5JrVwEGADT
	 sIhBq0p9NN6PjnhD+0N4pw4r9Ki0B4cpJDsJvrGf3F1A59TfNtI6C4XUkKAZ0jH8Xd
	 s3s0K6f6CHZTABr5xKx8Xaa3Lco0B16bECTSaB1rvDLsUTmFyjj+SvezDuP1Ev0dSL
	 jvimzdqGmpviwjHtZ4Yxea956CwuqXd5WJTmQB4l2cOHjHtKCcwy23k4cHsx5Wm+fI
	 1dBIAJT7085Sw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 02BCE3809A22;
	Fri, 10 Apr 2026 03:10:27 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4 net-next] net: use get_random_u{16,32,64}() where
 appropriate
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <177579062579.1844106.10045449114687370106.git-patchwork-notify@kernel.org>
Date: Fri, 10 Apr 2026 03:10:25 +0000
References: <20260407150758.5889-1-devnexen@gmail.com>
In-Reply-To: <20260407150758.5889-1-devnexen@gmail.com>
To: David CARLIER <devnexen@gmail.com>
Cc: kuba@kernel.org, davem@davemloft.net, edumazet@google.com,
 pabeni@redhat.com, andrew+netdev@lunn.ch, horms@kernel.org,
 idryomov@gmail.com, johannes@sipsolutions.net, matttbe@kernel.org,
 martineau@kernel.org, geliang@kernel.org, aconole@redhat.com,
 i.maximets@ovn.org, marcelo.leitner@gmail.com, lucien.xin@gmail.com,
 jmaloy@redhat.com, netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
 mptcp@lists.linux.dev, dev@openvswitch.org, linux-sctp@vger.kernel.org,
 tipc-discussion@lists.sourceforge.net, linux-kernel@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  7 Apr 2026 16:07:58 +0100 you wrote:
> Use the typed random integer helpers instead of
> get_random_bytes() when filling a single integer variable.
> The helpers return the value directly, require no pointer
> or size argument, and better express intent.
> 
> Skipped sites writing into __be16 (netdevsim) and __le64
> (ceph) fields where a direct assignment would trigger
> sparse endianness warnings.
> 
> [...]

Here is the summary with links:
  - [v4,net-next] net: use get_random_u{16,32,64}() where appropriate
    https://git.kernel.org/netdev/net-next/c/9addea5d44b6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


