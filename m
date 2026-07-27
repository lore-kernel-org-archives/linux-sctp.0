Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F26883F0A96;
	Mon, 27 Jul 2026 22:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785192058; cv=none; b=olxmwWtMUWxTklatFJXrkdAR7fgvErtRbs4lR8Vsp2rASvhkpTrMmiYxgg6nTKf6J/k6g+q+TUEbZqxqDMOkiuggw3VkiLwhYLyQAkwdBQIOnYd32FT8OGCewjjpmRgGQda+gL1E2JIuJOhcqw3zDqMAqWRs/ObqH0zu3Ej9nuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785192058; c=relaxed/simple;
	bh=frMhtuGAGFz7Jr01EuK3supEewgClBXFQ3kT/DhM3ec=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=QGzJa74tzbORmscnUQi46TwnTB9Jvkd4b7CWKsp1LDiTXwqSCy1OcaS7dLHY1KOvzaV8Arueu2vGyLrGQCULb1v5VbFS72qxKxpCEy3M6lSHDHVNxDEsiJvLWaTzeM8UD69435Uk6otth0rVIQpw9YS7dZku0O4e2sWuszUf1Zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FCbuefT8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FCbuefT8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97CE41F000E9;
	Mon, 27 Jul 2026 22:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785192056;
	bh=cPVNc368CLdd8nLRfved4tc6G3uNu+AjaBCI6WnD3QU=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=FCbuefT8osJ+JAZwyYwLIB88V7d8BaGH8YPTvQd+yVjChDseCRabd0vGn4ORMtiBa
	 5hmQ05SfToSOWNAwJZb8fMIeXcGZEv4QsfDAe/ONE+vAio1xu4LDtGAzWkKqwMHPYT
	 jds5GwbnPt/92yXAn7fFENks2TW6o8mzEF3CcNewso4BRqNyPJknsptItLGCBAZaIl
	 645Bi+n3/GIhs0gZrV4i1gNyS7QhB0y5PgvDfczX3zR6Ev7zRLXXZsKPBVjUyEc0eF
	 F6jjMraustrXitsulcsF2+D4Q8ya2SXo0MpYeEulYg9GUDRX0LJJzRWEJuTuIfGLln
	 pvYIiEXhkKgNg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 19A4A380CECF;
	Mon, 27 Jul 2026 22:40:23 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] sctp: reject stale cookies with mismatched
 verification
 tags
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178519202164.1443317.5985248760486883047.git-patchwork-notify@kernel.org>
Date: Mon, 27 Jul 2026 22:40:21 +0000
References: <20260723225623.2658868-1-yangyx22@mails.tsinghua.edu.cn>
In-Reply-To: <20260723225623.2658868-1-yangyx22@mails.tsinghua.edu.cn>
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

On Thu, 23 Jul 2026 22:56:23 +0000 you wrote:
> sctp_unpack_cookie() skips cookie expiration checks whenever an
> association already exists.  This is broader than the exception in
> RFC 9260 Section 5.2.4.
> 
> For an existing association, Section 5.2.4 permits an expired State
> Cookie only when both Verification Tags in the cookie match the current
> association.  Otherwise, the packet SHOULD be discarded and a Stale
> Cookie ERROR MUST be sent.
> 
> [...]

Here is the summary with links:
  - [net] sctp: reject stale cookies with mismatched verification tags
    https://git.kernel.org/netdev/net/c/9d8da8e0a9bc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


