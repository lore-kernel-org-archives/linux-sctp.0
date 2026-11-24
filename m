Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795486207;
	b=SEmK5RC2L/Gsjy4IBBi1uxTqPGp508dc+5r87bmime/cRC3rL98qjuFs6vj0+bsUI7mi
	 uFRrIIzzWHJNEzoy8jj64r1cHBLfYyQ6YLlbjroL1EFZCTWJSOZ4GTfvJDrZ97fcaC0KL
	 mdoOffSCZ23NHcDDdfog36WKAWKLD15tTKDhmYfaks0vSsuUs89W9vfPmcHwGtXJOQudi
	 Mkxgag4ZXsTXFa1k+NwhhFaczs3sqdruv3fPk/g3odGayatV+rue3RoFSrDQnVJAzlk47
	 77EKln55Qp9B5H/25Kjo4fNC0nqIsoWG4PLnAmqR9nwevLBq3v5CiIZ3lfrYUIO6KNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795486207;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=2iNLMDhcXMyMzA1kXRmhZcr/mPMwV/crxAQ80P3XDsM=;
	b=ubDmS7/X3Ri62OmvbTXciOXL+n8mCVXrdZFHBVkyvSYjhRIc32hjmdZCX1pFF7PJVUaz
	 hhgrc07vmRwQx/l8gayt5PfTGkB6arWZN91Mc8VJ+DKi2GcsXIQbCrY1kcKqRtKxH2Pd5
	 s9DnHnF+Dhgp7UELun+W2wy5ane2tfIELP6vXhKfgW1hw3affUNajviZuSCt1fluM33zv
	 /D7JrTnoqYJCo73ZswaR/WJr28I65dJ5UWtlsCV/XvJVyI2OydJJ5pAp+x8eLCoBYaVfh
	 /XUTrqqZ5wb68uXLNjAb8U9vdsEOFOHabcoPes8M6Q4uMnWJFSG6jNnZM5WNeNJRkyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JzMyA8j8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 165B6606A31E;
	Tue, 24 Nov 2026 02:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JzMyA8j8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 426941F000C4;
	Tue, 24 Nov 2026 02:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795486206;
	bh=2iNLMDhcXMyMzA1kXRmhZcr/mPMwV/crxAQ80P3XDsM=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=JzMyA8j8NPbo6EoZUlY5cpzVkEBb/ERN0TUam5x9NlpjLo8QeH3AFiPbyAMr4JkFR
	 Pw+cX9k5Em2em8zWupBka9bRwCjdW3/EE/z30ggwjdmHfh9Zsxozj1WH4StZ8rMABq
	 8nDwq5ZxkXx2su7/l3142Xe7vbCv2icYkP0FP+6+FJW9wiOZMLCn9toIlgnsS9pNHp
	 1xez/rAH5XHR8Ncm6H+G3byM+jDOpNQIqV/so+qcMcOhnEF2Jjia6aG5ruXYTyJpzs
	 qjWROgSp56exeS833D2YsQ7mFA3ve7k38wIpJ8b5qKXgwPAJc8TkDIWTcbhbQeIJCI
	 Gyw3KV+nbRhPw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3A39839302C8;
	Tue, 24 Nov 2026 02:10:06 +0000 (UTC)
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
Subject: Re: [PATCH net v2] sctp: preserve stream scheduler across outq
 teardown
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179548620503.3232529.10063854745620488260.git-patchwork-notify@kernel.org>
Date: Tue, 24 Nov 2026 02:10:05 +0000
References: <20261117110459.44083-1-juny24602@gmail.com>
In-Reply-To: <20261117110459.44083-1-juny24602@gmail.com>
To: Jun Yang <juny24602@gmail.com>
Cc: lucien.xin@gmail.com, marcelo.leitner@gmail.com, davem@davemloft.net,
 edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 linux-sctp@vger.kernel.org, netdev@vger.kernel.org, junvyyang@tencent.com,
 corvus@tencent.com, stable@kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 17 Nov 2026 19:04:49 +0800 you wrote:
> From: Jun Yang <junvyyang@tencent.com>
> 
> sctp_outq_init() clears the installed scheduler when it reinitializes
> an outqueue after teardown. The streams still have scheduler-specific
> state that the old scheduler needs to release if the scheduler changes.
> 
> Initialize the queue counters and flags individually so that
> sctp_sched_set_sched() can use the installed scheduler. A new
> association is zero-allocated and starts with the socket's default
> scheduler as before.
> 
> [...]

Here is the summary with links:
  - [net,v2] sctp: preserve stream scheduler across outq teardown
    https://git.kernel.org/netdev/net/c/d1be830de8cb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


