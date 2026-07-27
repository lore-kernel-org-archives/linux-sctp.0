Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F0EC3F44CA;
	Mon, 27 Jul 2026 22:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785192647; cv=none; b=lmTkZKNuxhoffAzZ17fiydSTpgpwQkZSICoASt0IYCNku0U39BlJhMBm2lMvc+2CK1c+0Ny2EEYaUCe3VmOtwU3SitwoW7ofmB+CQaO2HPXJkNRYbzTzt7kxjCS9xqYJExDwxh8YptDzWYCcM3cvQC7ih6jIcFjm8q2Ehka9JZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785192647; c=relaxed/simple;
	bh=scMDA9+Ln5FAr13Q67rlt1o4Xp9RW8o+26Ofgqixgng=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=NSOJ8VF+Kk824VYRCM7nTZHYlinfYlL/mm2TKiidFkxBQW8xceSSKOF/tvBaion6FyVTxTUBIvyfu9D9KT9HvZbdVM4ahgu+vqw7j3gTttE6TwGJgQdcpXMY3asngcaGRFUl0G82uAdHgemQp4iyjymlgNxsYjLt2ejIq/CWHu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gTC2V5Vq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gTC2V5Vq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B6661F000E9;
	Mon, 27 Jul 2026 22:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785192646;
	bh=0x3InU/rgqjopbusm/hTxJS/Q4IqWHNHrLcKBNf0Iow=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=gTC2V5Vqt5ZDx9txdbsQuV/UxkxLlGyqTkY7Cau1TTxOGA0fzOr+hXrBcwNBYu24r
	 RhBTjt6vzpMYg8gCY3GHudrWa8ulk5sjEHlWdJdCM4QpIuQJL3uZcvzJUBKENISPcr
	 YJwogN94ZagsEdUa9nMkODlRSwgVipEW+5oSijvMf9PWHiakchra1/2v9hPqD6B1AR
	 95hV/VLXbilwQ/2kcpRzQEjHlnhs935uludrFJWs7we2HgcRIjR256VwuiLN4TBi6P
	 N33jdHFTPItqv0z4N/J5hPLlroBCc2slyj3s6k+dsl5PDmVY2b28kkhOYjRPZztiV8
	 WurCXi7dab6Ng==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D0A62380CED0;
	Mon, 27 Jul 2026 22:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] sctp: prevent peer transport count overflow
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178519261138.1445878.7643540029600367640.git-patchwork-notify@kernel.org>
Date: Mon, 27 Jul 2026 22:50:11 +0000
References: <20260725032053.521705-1-manizada@pm.me>
In-Reply-To: <20260725032053.521705-1-manizada@pm.me>
To: Asim Viladi Oglu Manizada <manizada@pm.me>
Cc: netdev@vger.kernel.org, marcelo.leitner@gmail.com, lucien.xin@gmail.com,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 horms@kernel.org, linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Sat, 25 Jul 2026 03:21:06 +0000 you wrote:
> sctp_assoc_add_peer() increments the association's 16-bit transport_count
> for every new unique peer. Adding the 65,536th transport wraps the count to
> zero.
> 
> SCTP sock_diag uses transport_count to reserve the INET_DIAG_PEERS payload,
> then copies one sockaddr_storage for every entry in transport_addr_list.
> After the wrap, a diagnostic dump reserves an empty payload and writes
> 8 MiB of peer addresses past the skb tail.
> 
> [...]

Here is the summary with links:
  - [net] sctp: prevent peer transport count overflow
    https://git.kernel.org/netdev/net/c/bd0e9289e264

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


