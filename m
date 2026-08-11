Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 014853321AA;
	Tue, 11 Aug 2026 08:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786438253; cv=none; b=u02PTw2vk7A/e9iA/tCTgZJnEoiRVKv21iZhXrJ1f9OUgc5osrfb2t+LSL0Cp2DzTmt1z6JKV9i5KuLxgB9fGWNkQP2PLo6iFLJgAWL4b/aT4WnCNoP/M8yIhUz1j1rqo+a9riK7CpMnPwLNlMjBS37H6AmFLAwedZFKp7+xuOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786438253; c=relaxed/simple;
	bh=aVAo9CmAAXwrGETWyxS+V5r1ohMERtS5qvXwh+PSkNE=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=XtqaDwDmTwtTJksmd+ehk0oaRnvLs5TLdMFpbFh3D3O0yi+FHzJv75rw/KzxFJPdrJOeaTw12cuXDlLJcctw1rDGH2QVf+C+hketIC7f/R1CTrRew3NjCzdahVk2LNc8jrVDJ5tcvlWRJ5LwmS73s5O08AmvAywdtBWIptRySQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YUcPOFT0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YUcPOFT0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98A9E1F000E9;
	Tue, 11 Aug 2026 08:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786438249;
	bh=5UocxeE9GKA7J/KNPfU4n9zD0ezNRNnPPHq5hsk4nZ8=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=YUcPOFT0MGQxKLAF1mWSD4Ds+7i3uHvzjSGsMInGpZbse5s21VGCkckqAgFoViGVz
	 nnPX1hgDAWXnGnabM763VzynRkpaWbYxCN6A5s3EZ3adeHAF1frFdm7Blp98e1Luw7
	 qUtPcJT5QmxRl3W4gGJaFuEoRATAUWX+L3ovw1CbzHFQrJLajSMAZaNN68kbJo79um
	 EjT7LJ9D5u1zjFyzcDNDD9bV1+HH1t2lRJYSX/XW+j3ee1JxsY8/p8s1ReyAoSuwSX
	 GWDlm0XOaT8Xz+SROa7/EST5QG69cNs213T8jX0L/qTzh8UemJQTbbL8k/OZKZK7i5
	 /HKQO5e8HQNtw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 1985439263A3;
	Tue, 11 Aug 2026 08:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v4] sctp: auth: propagate HMAC calculation errors
 to
 callers
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178643820565.420670.8744676396455318240.git-patchwork-notify@kernel.org>
Date: Tue, 11 Aug 2026 08:50:05 +0000
References: <20260807064314.500742-1-l1138897701@163.com>
In-Reply-To: <20260807064314.500742-1-l1138897701@163.com>
To: luoqing <l1138897701@163.com>
Cc: lucien.xin@gmail.com, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Fri,  7 Aug 2026 14:43:14 +0800 you wrote:
> From: Qing Luo <luoqing@kylinos.cn>
> 
> sctp_auth_calculate_hmac() can fail when building the association secret
> under memory pressure, but its void return silently leaves the HMAC digest
> zeroed.  On the receive path, sctp_sf_authenticate() compares this zeroed
> digest against the peer-supplied one using crypto_memneq(), potentially
> accepting an all-zero HMAC from the peer if the allocation failed.  On the
> send path, sctp_packet_pack() transmits a packet with a zeroed HMAC that
> the peer would reject.
> 
> [...]

Here is the summary with links:
  - [net-next,v4] sctp: auth: propagate HMAC calculation errors to callers
    https://git.kernel.org/netdev/net-next/c/5d3ae80ecdde

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


