Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B14A23382F4;
	Wed, 23 Sep 2026 02:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790128882; cv=none; b=VwBrUyd3AVIJOUZi2g/BOpAcBObMRyGmCm3fDQtpZiyB/dNd7ks7MPWGqFVzQ3k9HWbUYZK6GzMpSeRh/IuMP941ek7f0y1VKSEa1VFX11JaQnHduHfo7SvNEmBXbn+IwXXAb8/lZ02DCMRBrvXmDEoYSGOfLlQ+Uin1ykiNMrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790128882; c=relaxed/simple;
	bh=erlovEg+RBxYD6j1mIKSEMPDXZWwa4KM2ZJHoJ+RBvw=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=PG+bBko4khG57JUtjrEh9CUymLPOgJ2rFipF0CDYT1vLOEKRaZPqmgJ1Hdfdir8maIvxK/MEzuPANTVk8JVqNX2ZdebOTKG61tjbTlkaJw7hKl5FGilZxBJQC/lAOw7J7i79qFaW4nqB4KquTUp4xz9VerujEaR7BJKW3VSMoso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gdf/7TnJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gdf/7TnJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83C6D1F00893;
	Wed, 23 Sep 2026 02:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790128880;
	bh=p0eSKQwZuR1W7wr66uDz4jriAOIbItiLXfic+9X3DnU=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=gdf/7TnJR89gN6p9CVKpMXdt+euP9glUw+53ISItXxDwKjTSzEFSLpiDaW32dT9C6
	 VsgtFhV3omlgHnpP8OHWzBM628ngdflpvcvg814h/YS7HPORo3M0d0nVpLU7o11ATe
	 qb4AHpm2kUkSB763QKRm0k0l86u8fe0U/PHB8W5BtPAiZ21KntTAQYtOq/heC+cgw6
	 SVX3OpFjS5xfc9ip+c6xgqOixwSUCzJi+vI8NrE/Aj/4vK/0VGnlE0cbOQ6rQAVp2J
	 i2GbgJtR9sW2HDNWJVk/WLGv7f+57TJVhyD2UbNX8kmgt8OJ+Yt9xvs/M5kLSpxXS/
	 ElAol22XeuZWg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 5676E3924472;
	Wed, 23 Sep 2026 02:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] sctp: hold asoc or transport before mod_timer() in
 timer
 handlers
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179012881076.173471.14609989532981341601.git-patchwork-notify@kernel.org>
Date: Wed, 23 Sep 2026 02:00:10 +0000
References: 
 <c31b5e3ee2b7274e804f5eba2f21e2412e7eef7a.1790013825.git.lucien.xin@gmail.com>
In-Reply-To: 
 <c31b5e3ee2b7274e804f5eba2f21e2412e7eef7a.1790013825.git.lucien.xin@gmail.com>
To: Xin Long <lucien.xin@gmail.com>
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, davem@davemloft.net,
 kuba@kernel.org, edumazet@google.com, pabeni@redhat.com, horms@kernel.org,
 marcelo.leitner@gmail.com, xietangxin@h-partners.com,
 david.laight.linux@gmail.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 21 Sep 2026 14:03:45 -0400 you wrote:
> Take the association or transport reference before rearming a timer in the
> timer handlers.
> 
> The existing code calls mod_timer() before taking the reference needed by
> the rearmed timer without holding the sock lock. This creates a race with
> timer cleanup: if the timer is deleted after mod_timer() returns but before
> the reference is taken, the cleanup path can drop the timer's reference and
> destroy the transport or association. The timer handler then takes a
> reference on the already freed object and eventually drops it, causing a
> refcount underflow.
> 
> [...]

Here is the summary with links:
  - [net] sctp: hold asoc or transport before mod_timer() in timer handlers
    https://git.kernel.org/netdev/net/c/cae23ae3f788

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


