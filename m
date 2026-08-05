Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D3A417B418;
	Wed,  5 Aug 2026 03:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785899447; cv=none; b=FFnfSBHgxEOhup9PvRf9TwW/6/hwAgUUA7BM/hf5T+eWzNh9qlsRGeqbFypOIXCYMMZH6tzeJMwyLHamzgJEeAE6kCfNRo8jOzbHnyaHeBW4X1PIGZHQ/myXfQzjuYnCOiiF0fIqG14hFfmM/55Vn08BqkkTtGqfIR52lmg47no=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785899447; c=relaxed/simple;
	bh=2ZqXvLW/woc8rRZsq+nPVmNHiKeDlXfvIXwmDi7YDFo=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=FgwglROJJ8oOb0p4xEgmiN/8DjKd9XazxVaQjPDZQnTIxnhQPLGOMygia8o1ZaPspVdtmTaGbtnlr/Na3qLvGy8+7jYufbGFujurlBLJ1mYHemZGFIj34HHlQ+JxqxW07CczgMVAhncDcW+4lGWTXP/NeuOr5m7M6d/zxKXooxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MlYPIRO+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MlYPIRO+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E8761F000E9;
	Wed,  5 Aug 2026 03:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785899445;
	bh=bAd+KNzvws+WJv+IEKjgTMtYXw4jVNu1Mj6pVj3+BVw=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=MlYPIRO+mJcmTlZ6wJYn8pNi3xo6mohGnWihLEzi8EDgV4+nCVReQt+jl13p8kJbu
	 mvpromW7jbpZTVNSuM1gI4YE9eTYon1IruAjv+orZcwe4FaiCRmAQ3FKuEPWKVVJqt
	 vlDeBR5SPtLqlDpcJMT9D9fkyklUIgNrIfOJE5/qTy/s++Dajzzap0RDxw/xV1WEC9
	 S6SoxnsSsTIT3b6mWmVZdkERlLYKM6tjHY/5xFKtd2kR/K4uCywF+O5qQv2UyMJG3a
	 xOAltspnUC6gK1wDzY3T5VD69jJYshZd1AacRRMXndGCd569/ynnAOkq9yQEK2GVnH
	 7oHgY6l1yY1Aw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 19837392666B;
	Wed,  5 Aug 2026 03:10:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] sctp: fix addip_serial increment on ASCONF_ACK
 allocation failure
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178589940564.3895134.7592284619866823646.git-patchwork-notify@kernel.org>
Date: Wed, 05 Aug 2026 03:10:05 +0000
References: <20260804025514.241767-1-l1138897701@163.com>
In-Reply-To: <20260804025514.241767-1-l1138897701@163.com>
To: luoqing <l1138897701@163.com>
Cc: davem@davemloft.net, edumazet@google.com, horms@kernel.org,
 kuba@kernel.org, linux-sctp@vger.kernel.org, lucien.xin@gmail.com,
 marcelo.leitner@gmail.com, netdev@vger.kernel.org, pabeni@redhat.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  4 Aug 2026 10:55:14 +0800 you wrote:
> From: Qing Luo <luoqing@kylinos.cn>
> 
> In sctp_process_asconf(), when sctp_make_asconf_ack() fails to allocate
> the ASCONF_ACK chunk due to memory pressure, the code jumps to the
> done label where asoc->peer.addip_serial is unconditionally incremented.
> 
> This leaves the peer's ASCONF (serial N) unacknowledged while the local
> endpoint now expects serial N+1. When the peer retransmits serial N, it
> falls into the serial < addip_serial + 1 branch ,
> which attempts to look up a cached ACK for serial N. No cached ACK
> exists since the allocation failed, so the retransmission is silently
> discarded. The peer eventually times out and ABORTs the association.
> 
> [...]

Here is the summary with links:
  - [net,v2] sctp: fix addip_serial increment on ASCONF_ACK allocation failure
    https://git.kernel.org/netdev/net/c/aa2e13ae8d3c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


