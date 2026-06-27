Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CE153382C3;
	Sat, 27 Jun 2026 22:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782600645; cv=none; b=X76uqtaDvk/cAjGLIb8vhMJVSqL+tHJl9msxfgBYnMhbUUtu+OtHjiSGLd7+q55A1v6n/NGRP53KChlrQmZwuHKkbFKw1LAKVIgpARVeAYXH2bylMhWwoxFW1aPI8acdjOnnGpz3kKh61kOVONqMga06INdBYdgHe/PbXiKFWS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782600645; c=relaxed/simple;
	bh=VPbByZTz4o6v7d2qqbjnnWNqfon2vk7aJ1+5njU26Lc=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=PI4yUDc1oxPa5OAqDUt+OJ0VBeK+y6bdU9atUjDa3WHs6C2HLgfhDXvXRDNWURra85Hl9mg0kvrQofNjU7Qvrs9rBTWHTzRyb1pnYJLGJhwJtAusT5CoMwDLPgnUuvz6rN70029/ZgNFbLqX0kay3yT9wMOMYc4Vmsocr0PK5CQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WPrapY6t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WPrapY6t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51ED51F000E9;
	Sat, 27 Jun 2026 22:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782600644;
	bh=y9FfX3Vp8fyXMgEKD/UXYtqQyJcSdJlLB+h7grRajcE=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=WPrapY6tTTc8VCQBqyxzmPF0cbLHHa596JmV4DT5zz6ruEj6+OLapPaLwRCuAVsmO
	 HCmVhL1985Yc1RPUe4yF8oD9wgH0IU8veqYdE5dPpe5nWWU+T0Xi4QfvMXHiNYl/QI
	 dRQRmEcdbZdnq9aOKJBdwWRrNF60YvMjPFsDqSn4szF39R0PsbBg+MZFu5N8/mja1m
	 RP7Uh1WQ5JMzcArgE3AR4fDHfrUDkKU5WvEi+r43WN5iDIVxIsgpn8cPxNV8+5hSQs
	 HGxWgBUWsjQMdGkdaPUQmoPNHLhHBCuOWLCBgpGEMP+4M/7efsOtHGh9spmuUAjAAs
	 bessVmp85zdLQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 56B603938452;
	Sat, 27 Jun 2026 22:50:31 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] sctp: fix SCTP_RESET_STREAMS stream list length
 limit
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178260063002.1451849.3159177824439756962.git-patchwork-notify@kernel.org>
Date: Sat, 27 Jun 2026 22:50:30 +0000
References: <20260625142354.2600-1-alhouseenyousef@gmail.com>
In-Reply-To: <20260625142354.2600-1-alhouseenyousef@gmail.com>
To: Yousef Alhouseen <alhouseenyousef@gmail.com>
Cc: marcelo.leitner@gmail.com, lucien.xin@gmail.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 25 Jun 2026 16:23:54 +0200 you wrote:
> SCTP_RESET_STREAMS carries a flexible array of u16 stream IDs, but the
> optlen clamps treat USHRT_MAX as a byte count and then multiply
> sizeof(__u16) by the fixed header size.
> 
> That caps the copied and validated option buffer at about 64 KiB, which
> rejects valid requests containing more than about half of the u16 stream
> ID range.
> 
> [...]

Here is the summary with links:
  - [net,v2] sctp: fix SCTP_RESET_STREAMS stream list length limit
    https://git.kernel.org/netdev/net/c/2b9f5ef53418

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


