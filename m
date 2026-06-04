Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3649D2C11FA;
	Thu,  4 Jun 2026 16:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780590022; cv=none; b=RL9MuG//jAFPqyRY0rPl/y+mJaQZXqbZULoUWr1XLEdDyKtKPbRXe/TuhsvFa5vvQ4RcTgEvn2clGTK9QY7Wa98gn0oqpz6nZ16q/QAlHksW6CqKfQ6TfxV1Gvi3NMUPNq8NQWTFUYHmGx0J/IRFKhtB1H7cDYcHZsQAlhUhIig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780590022; c=relaxed/simple;
	bh=iq+ni599eOdwgPQ91V8xvsCHsD7V86D88tIQfeEhKHU=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=Ief9p15NGqMNJv4m3jGUqeQxW5NpbN2F/Ci8PowMeQO94sXz7BOSvLi+sGvguUE+6SGm2vD9gaeoOM2MeK0qq6z4yAlYjS42u3koDSYcpsY2FJCDLCL5FMEu2t/PNfVC7EYrhpbqvA/9ajQvBUpUgNdZEEMAxnx+5X6UbGuiXN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gO1LsM8s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gO1LsM8s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5F211F00898;
	Thu,  4 Jun 2026 16:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780590018;
	bh=0iZUxqEK+ViJWTJOCRa9D/05WrOB3xf1jaBtFVoEDm0=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=gO1LsM8sLvOVAlJaKlGcrH3b4IKF/X+pP7OuGZcFL7VZnUEm2uzMElKtqmFsenLEA
	 TU+idbCBU6smNSIde/Hu2cp6lWIo5tXRRxEhmqYw1w8GZVXyaVjGEd6ZrgASvcAZxA
	 4vXDx7sHQICpwFEScaQD0V3VxPzcvGpiFRQ5To8K0XkntzOCIqscEZIJlzrc3EeZcD
	 KXjZM0gzUeQ7DO4sviLTuuYk6DlfDbqr4BBccCdw0cjt4xZWfIA3ijWkgshbBci44M
	 m4LhmumSJm8PsF5dfcH8Con6+Qe2YIEvzSM846vgPIUutH5E9yY2kryuVXLdhqP6Vo
	 7NXsuZgQr9NWg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D0B6C39309B7;
	Thu,  4 Jun 2026 16:20:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] sctp: purge outqueue on stale COOKIE-ECHO handling
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178059001964.2502005.1832706734432444090.git-patchwork-notify@kernel.org>
Date: Thu, 04 Jun 2026 16:20:19 +0000
References: 
 <94318159b9052907a6cbb7256aee8b5f8dfbfccb.1780510304.git.lucien.xin@gmail.com>
In-Reply-To: 
 <94318159b9052907a6cbb7256aee8b5f8dfbfccb.1780510304.git.lucien.xin@gmail.com>
To: Xin Long <lucien.xin@gmail.com>
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, davem@davemloft.net,
 kuba@kernel.org, edumazet@google.com, pabeni@redhat.com, horms@kernel.org,
 marcelo.leitner@gmail.com, yuantan098@gmail.com, yifanwucs@gmail.com,
 tomapufckgml@gmail.com, zcliangcn@gmail.com, bird@lzu.edu.cn,
 xuyq21@lenovo.com, n05ec@lzu.edu.cn

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  3 Jun 2026 14:11:44 -0400 you wrote:
> sctp_stream_update() is only invoked when the association is moved into
> COOKIE_WAIT during association setup/reconfiguration. In this path, the
> outbound stream scheduler state (stream->out_curr) is expected to be
> clean, since no user data should have been transmitted yet unless the
> state machine has already partially progressed.
> 
> However, a corner case exists in sctp_sf_do_5_2_6_stale(): when a
> Stale Cookie ERROR is received, the association is rolled back from
> COOKIE_ECHOED to COOKIE_WAIT. In this scenario, user data may already
> have been queued and even bundled with the COOKIE-ECHO chunk.
> 
> [...]

Here is the summary with links:
  - [net] sctp: purge outqueue on stale COOKIE-ECHO handling
    https://git.kernel.org/netdev/net/c/e374b22e9b07

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


