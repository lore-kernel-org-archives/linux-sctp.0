Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 834D5330B30;
	Thu,  3 Sep 2026 02:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788400872; cv=none; b=KB/vC9/Mb8enk890ovaWetzsu5TvFnHt9bqmw+ETQHS8qwz47R0EDLxcudVEtRtDuAOA37PoKjEa6K6sTSOlXiKzGfZ3/ETsY/+UU34q3XATI50fwziD8aCbIX3PpftXj8O0A3+uAXB/4HnWo3hYp9iQLFFjlqip6pYA412aa2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788400872; c=relaxed/simple;
	bh=725mPdWOP+Sq2dX2R3Q6VjL2J/t3a15n+txifeovZmI=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=tJcjgWlnuZba3UdbYF70xtgbsJiIzfDDt8WcH6r5tVrIC79Hd0ErAwaKMP1sNEuJLBSS2Z17evlt49qywBImtasTU6ulYD9IC8b//tpWVz0npZ5IPcb3InwMXIlAA6apM9uvCjv4krXPkExdsuyiOojdt2xvPdULnt0kmklHpP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IuCYPTnq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IuCYPTnq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38C591F00A3A;
	Thu,  3 Sep 2026 02:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788400871;
	bh=S2aqjZ69jLwiJTydmdmy+PTMNUSdxt2JavxXRa76SwM=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=IuCYPTnqjBaOAidOYefeGB3y2Omnmp2+QEa3dXPaW2FbaU8YpjYj0U8Yc/KrJpQdA
	 rsUbyLyIPC+1prMMMh1eD0F66pmb39BuMSM9+tOEn5M6R3P8oTgFzcn+oG6jbeOZHo
	 8UBYgvPQgyDr0TN92HzaKzYBSU+3Yv9OKXynEieQW2b/PIHCjvjwbX9oQ6wCNt2K6d
	 JZoczdGfp8IqH0E11VQoDoIU9mRMM5xuitDL8blI5qsaNHFFVYIpm6c+HTwJwYnlpP
	 dk2CeWrOc+c1UcfI/baNnh11l9SqagHERSaDeSAYFTA2p1qWCj5J6BCpjV+nLkFnIJ
	 rHqE2JJPP4HGA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 198473927056;
	Thu,  3 Sep 2026 02:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next real v4] net: Replace %pK output with 0
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178840081264.3041656.2571782134419585155.git-patchwork-notify@kernel.org>
Date: Thu, 03 Sep 2026 02:00:12 +0000
References: <20260901160345.eeknHmY2@linutronix.de>
In-Reply-To: <20260901160345.eeknHmY2@linutronix.de>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: socketcan@hartkopp.net, linux-atm-general@lists.sourceforge.net,
 linux-can@vger.kernel.org, linux-sctp@vger.kernel.org,
 netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
 herbert@gondor.apana.org.au, kuba@kernel.org, kuniyu@google.com,
 mkl@pengutronix.de, marcelo.leitner@gmail.com, ncardwell@google.com,
 pabeni@redhat.com, courmisch@gmail.com, horms@kernel.org,
 steffen.klassert@secunet.com, willemdebruijn.kernel@gmail.com,
 lucien.xin@gmail.com, pmladek@suse.com, thomas.weissschuh@linutronix.de,
 kees@kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 1 Sep 2026 18:03:45 +0200 you wrote:
> Commit 71338aa7d050c ("net: convert %p usage to %pK") which is from
> 2011 and changed the %p annotation for pointer to %pK. Back then the
> default behaviour for %p was to print the pointer. The %pK modifier was
> introduced to able to control the behaviour of specific pointer values
> without changing the behaviour of %p for everyone. It was dedicated to
> avoid leaking pointers via /proc.
> 
> [...]

Here is the summary with links:
  - [net-next,real,v4] net: Replace %pK output with 0
    https://git.kernel.org/netdev/net-next/c/7c0ec6288b49

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


