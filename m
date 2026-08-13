Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16EE623395C;
	Thu, 13 Aug 2026 00:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786581052; cv=none; b=iXESXzvrXGFBvi8+gO6pbYj4s9TPtfETXrUB5nBKTd1LLqFmKgGokJawLuaxqbYVL37R1QIWdnnXPnMKNf+5aHKQIC1lfHh65vjLeNvZeeyqcJ0jRjKim838dr8i/H0+HXFErzf4iWF+YFP10FYcjIZjyjU8dcdzJLB37py5OOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786581052; c=relaxed/simple;
	bh=y9LJ+EajaZrHX3AYpWcyMHyC87hSBd3MwTKiEePucrY=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=Y447DWSDHLWHBvF5QU6IocEA6LFzN1denp4zuSdi7Jutk5cf05AEmi8ZczleBugI1UGRxILbpZzjp45InFpDeKNlSHEhYhZsulVWOG6UDS2PUoWn6OBJEJc6pvVocgu0a2CGiffvfT8LvMll2nXMdduSbPGEhbxGHptVoQmXSS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gE+hVvPu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gE+hVvPu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD26A1F000E9;
	Thu, 13 Aug 2026 00:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786581050;
	bh=jkgvi0vXB8SoTD85Ii6RpmXAUgHLBYU9ikgIHhWCVvA=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=gE+hVvPuqFvthLw5K09cdiIW/SBusLt/3OmZGaA+IHbreFMs+0Wn/ksbTlx00uLVo
	 jlWBFzOjNVetWSas7eSaqorvbSCAY3Q+bUamQvAdTjR/zGyLZQEOXo6K7ZCPjxQUGe
	 gkKQ73Di4T6kg/HlrBVEMcFhCjxx3wGrTfraGdjDbg0lT545eF8s7pXI3i2mUVt4fh
	 VHd3ycXcbIPRO+WQvMDotB44y96mIMmCckReEHJgyXu7OOxbhfOKb0iaHAHRrHBdXG
	 8VQ49IV6xXBV4m5PH6A3wKJBbmjtn2U+FA9SZElKGSolaBv7VfPreps80A+gtP32hY
	 nPzUAeeoiM+nQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 19842380CED0;
	Thu, 13 Aug 2026 00:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] sctp: clear new_transport when removing a peer
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178658100564.2163205.1648818920929690023.git-patchwork-notify@kernel.org>
Date: Thu, 13 Aug 2026 00:30:05 +0000
References: <20260811152803.5629-1-a0yami@mailbox.org>
In-Reply-To: <20260811152803.5629-1-a0yami@mailbox.org>
To: Qing Ming <a0yami@mailbox.org>
Cc: marcelo.leitner@gmail.com, lucien.xin@gmail.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 micchie@sfc.wide.ad.jp, linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 11 Aug 2026 23:28:03 +0800 you wrote:
> sctp_process_asconf_param() stores a newly added peer transport in
> asoc->new_transport. After all parameters in the ASCONF chunk have been
> processed, sctp_sf_do_asconf() uses this pointer to send a HEARTBEAT to the
> new transport.
> 
> An authenticated ASCONF from a remote SCTP peer can add a transport and
> remove it again with a wildcard DEL-IP parameter in the same chunk. The
> wildcard deletion preserves the transport on which the ASCONF arrived, but
> removes the newly added transport through
> sctp_assoc_del_nonprimary_peers(). The removal does not clear
> asoc->new_transport, leaving it pointing to the removed transport.
> 
> [...]

Here is the summary with links:
  - [net] sctp: clear new_transport when removing a peer
    https://git.kernel.org/netdev/net/c/beb33f8ee1ca

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


