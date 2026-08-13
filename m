Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC1C830ACF6;
	Thu, 13 Aug 2026 01:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786583451; cv=none; b=R3qv3JH43vMWBnj0ULK+lqmsHAl/1PzfNXtaYrw2pH9pRziCw4Bs9vRzs7d6Zl72vb7OE+8oaPd9+ftN4eqwpx1Kvxb8d8SKd/Kyyz3l0be1aMKtQLWjpEqTEYfhTiyEdYK1yM2OI95xF3AEyDP7ed22AvaIUrmatucBWW4ghZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786583451; c=relaxed/simple;
	bh=5tvKCLl58F39O3AEJyimWFGb/dxDhyA7tPjy9wdXwWU=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=Cp/kIhDiUM6lpK++Ta7VzcBTGRTvZ3ZXvVGaWMCbTfLdZb9IfiOYl66U3mZMVvwzS8yUIDu9ta/ENPwATlCGrXRS+2xDc9LxTIsfitX71KcsJQx/w46DVzC/ugkAt0FkCXsxdNdL57orAbxx1v5a1nGZGtRivQsvAp8//9bacEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CjXZujVE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CjXZujVE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 743131F000E9;
	Thu, 13 Aug 2026 01:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786583450;
	bh=MkIZ52XMVC7cJhlUc2hDAoA+fNmkdk5Uav0sbdX/M3Q=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=CjXZujVEKNkqAs/SuNil2WTGkznTeFvhMbUioSyxxDjBznsfFgJvoCsp0gMggQfxH
	 w/fKqDxu9QBUTtfQxdvAb+HRzGj9neVNLMYmLFCD1aN03g3oCN748GBgLok7rWeysn
	 nWaaSqho64X8e76Qcmmv46RyB0NYkeQS+4JhwEidipbEG25j3OeYpzdZAA5D8sBVW3
	 nweDQrUS8ndfCpD6myhHsZ2inBtq1iF4ZWeoXbSMDD5Z5kJMWu8mA+HHqtu6i1fm+M
	 FIgr1/rvoU0hMd26AcT5EeKVgzooNgjHulf3SQc1V7Wlmbpn4wQmdCNPwy12pJP4OZ
	 PJcoLNJrIB/4A==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D0AA8380CED0;
	Thu, 13 Aug 2026 01:10:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3] sctp: fix use-after-free of cached ASCONF chunk
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178658340543.2174045.712435615952714595.git-patchwork-notify@kernel.org>
Date: Thu, 13 Aug 2026 01:10:05 +0000
References: <20260809043806.2768302-1-yangyx22@mails.tsinghua.edu.cn>
In-Reply-To: <20260809043806.2768302-1-yangyx22@mails.tsinghua.edu.cn>
To: Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
 marcelo.leitner@gmail.com, lucien.xin@gmail.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 zhaoyz24@mails.tsinghua.edu.cn, wangao@seu.edu.cn, fengxw06@126.com,
 qli01@tsinghua.edu.cn, xuke@tsinghua.edu.cn, yyxroy22@gmail.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Sun,  9 Aug 2026 12:38:06 +0800 you wrote:
> addip_last_asconf caches the outstanding outbound ASCONF chunk. The normal
> ASCONF-ACK completion path releases the chunk and clears the pointer.
> 
> However, sctp_asconf_queue_teardown() releases the cached chunk without
> clearing addip_last_asconf. During peer restart handling,
> sctp_sf_do_dupcook_a() queues SCTP_CMD_PURGE_ASCONF_QUEUE, which invokes
> sctp_asconf_queue_teardown() while the association remains alive and leaves
> the pointer dangling.
> 
> [...]

Here is the summary with links:
  - [net,v3] sctp: fix use-after-free of cached ASCONF chunk
    https://git.kernel.org/netdev/net/c/8c283e7b56ad

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


