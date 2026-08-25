Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1687437858;
	Tue, 25 Aug 2026 12:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787661072; cv=none; b=ZZhCoeprOdQa5dvDbvyHM5GiT5DgXd5Go6Cho4HhefICs4o45YCoX7PDUWrb6k8q9VMiNCaxQv0jqFnLkEzCX7lmwxc/iMmoc+UyeU9HYJ2WaXA5Z3KTsdorZg/wHbSy9EXHmX3i9B0ZPlxe5WM5kVYCOPm1risW117MPtPieSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787661072; c=relaxed/simple;
	bh=8uwfoixJT3xBCN3Xhh+sDdkplxxTKwBDPJRg89wCmFo=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=kIFfzYPJB6ih9s9MvztMo0EGM7sOrAkMBRCZltI6Rl+WiQFF6+aPvWlAeChqBgyaINIP9qA5z8EDd/YlnIgCmgJtyfVHQ1qJq4MeVcaUE1SGVOQNJIt37a7o1tYFZUri2lZbWHifkd6+9KycjH5z+ZcTkfAlJXF9elt79iEidq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hGJr9Sov; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hGJr9Sov"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E282E1F000E9;
	Tue, 25 Aug 2026 12:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787661061;
	bh=0Jp5d2j+Dly4Qlbl54/NNZxMqGajMtiaXj9h6j4r+L4=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=hGJr9SovVt5Wq/l8mzZmKzO15P8bTSEdrb4wdRMBmvUo/pV5BTB9Ka4Z7MxMi9NVE
	 REy7ZrZ8BV8sYNFEMLtzS48IJJBhFPb8pQ7HIWJ+Q0m9oiYRaIU5VZZa6dZamuvaco
	 VH9f50rDl6fMAEhvd+th/C+JUgx7+cKB777hSWqWisLIg/gfzvSAb4G5SiXXUeluEZ
	 h5pTuGOZAkrXXwa5I2pSDEUMqhBFTWrqG8+cskAnz7NC/jDMm+R+6bI8zEVn9eXhqo
	 ZKw+tk9Idx1ckiDXYCt4pbx3sgilf50xlTsOEiYd9QxdMKMTk+h3niq4qHR4L6c2h4
	 +an+8rQ2uVanA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 198363924FD7;
	Tue, 25 Aug 2026 12:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v4 0/2] sctp: handle wrapped and duplicate RECONF
 responses
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178766100864.3428215.18068978210796260872.git-patchwork-notify@kernel.org>
Date: Tue, 25 Aug 2026 12:30:08 +0000
References: <20260824081832.98717-1-juny24602@gmail.com>
In-Reply-To: <20260824081832.98717-1-juny24602@gmail.com>
To: Jun Yang <juny24602@gmail.com>
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
 marcelo.leitner@gmail.com, lucien.xin@gmail.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 junvyyang@tencent.com

Hello:

This series was applied to netdev/net.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 24 Aug 2026 16:18:18 +0800 you wrote:
> From: Jun Yang <junvyyang@tencent.com>
> 
> Fix response sequence zero lookup first, then make RECONF response
> handling idempotent with an outstanding-request bitmask.
> 
> Jun Yang (2):
>   sctp: distinguish sequence zero from wildcard in reconf lookup
>   sctp: fix stream->outcnt underflow on duplicate RECONF responses
> 
> [...]

Here is the summary with links:
  - [net,v4,1/2] sctp: distinguish sequence zero from wildcard in reconf lookup
    https://git.kernel.org/netdev/net/c/63f44178f0a0
  - [net,v4,2/2] sctp: fix stream->outcnt underflow on duplicate RECONF responses
    https://git.kernel.org/netdev/net/c/3faf13aff243

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


