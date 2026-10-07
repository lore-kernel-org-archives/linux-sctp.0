Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52CA4339365;
	Wed,  7 Oct 2026 01:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791336609; cv=none; b=KXGBoXMgIcpeHkVzPmmpUIXs64E58EVFEPaOBk9HmwRwrEeIYbz6vzAcdFpXTpCnwc3SzEFbhia8kpd6akJpiHVBtLEtMmSMwPUH7xK1gKueJ8T45NERSmiWND4smccTz1sBRXjaf4YQVc8BQsuiU7Js32rhOZ0ELtFZ544wgGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791336609; c=relaxed/simple;
	bh=YXwP2o8+49HU53RVpfm8A2P5h8faqhs2rUDkEh4xF5A=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=svaEmwpyKbM/Qbtqsn0ci9kympOSO+C/lRZSfRuWZ9SvejayqTR7COvfF/0GXMeJne8ApEspZMEhSykJAt9yt9srxhvq+37f8boaR1AFlp6HKODJu148SVYSN5eyzPr5CmQJTwl3FwyKvSqG/VMUVAjd4Kvv0qobRp/3iG4bi7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EMbYX1es; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EMbYX1es"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 062151F0089B;
	Wed,  7 Oct 2026 01:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791336608;
	bh=3/h0gGJVE/g2n0Ey6QOrFNqMGQlhbzlPioWY2FNK9Dw=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=EMbYX1esnN3nI6pP2LzPgB6pTbd2IE6ZLjekV+A5gQehfWtm9REAnIfNnMozbdo/a
	 k9uC8cAiSZKRA1v0GnOAlPGHsMpz9WapGwdPRnxUUOdvWcrRMOjrFUGlzQYxJVGmp5
	 6EJSRFsOin1rrbqtuJHMkRC1KDJIii/IIakf1BiI5gXL0p3csgAUeFnhSo/tOgoVhQ
	 cdrm3duUk1o8QkSQlfz1yFUqSe++x9khIMdLZUmzSNF6S9jVquUKliHVFMLrgEhDuB
	 IOdtUe4Ln8knkPE/ZGOBcxa6yQQ4v0Y/ykJNsvpJKwKzc9i6+igsdpu+jlSz5L6lXb
	 pC54CpXc625jQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id F15A23806541;
	Wed,  7 Oct 2026 01:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] sctp: copy zeroed stats to user in
 sctp_getsockopt_pr_streamstatus() when !streamoute
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179133660652.2858290.14740048670060140108.git-patchwork-notify@kernel.org>
Date: Wed, 07 Oct 2026 01:30:06 +0000
References: <20260930044611.204739-1-benquike@gmail.com>
In-Reply-To: <20260930044611.204739-1-benquike@gmail.com>
To: Hui Peng <benquike@gmail.com>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, lucien.xin@gmail.com, vyasevich@gmail.com,
 nhorman@tuxdriver.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 30 Sep 2026 04:46:11 +0000 you wrote:
> When an SCTP stream output extension structure (streamoute) has not yet
> been allocated, sctp_getsockopt_pr_streamstatus() sets the local stack
> variables params.sprstat_abandoned_unsent = 0 and
> params.sprstat_abandoned_sent = 0, but then immediately jumps to 'out:',
> bypassing copy_to_user(). As a result, when an uninitialized user buffer
> is passed to getsockopt(SCTP_PR_STREAM_STATUS), the kernel returns
> success (0) without copying the zeroed stats back to user space, leaving
> uninitialized data in the user buffer.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] sctp: copy zeroed stats to user in sctp_getsockopt_pr_streamstatus() when !streamoute
    https://git.kernel.org/netdev/net/c/538b529509c7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


