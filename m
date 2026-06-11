Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A59863CF025;
	Thu, 11 Jun 2026 22:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781217025; cv=none; b=GUD2XrM6IvIn4usVxP4xC4/+mJtO9GtbtCqkxqruQ3KBg0KVYxy3MYzsOX5MUNCrz2n2u22pEHmtBvYnXhDfewO87WFb1qSU0U/Qqt3dGDP1dQu8UzVaFvz1Bvaps3fyg1VKcZCTuhFiU8n1GQC8w+ijB+eXW3JIjLNniQKEhKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781217025; c=relaxed/simple;
	bh=Q7QX7aOuVpFHWd23Lgvjq/uXtFI7WY/mskuHCNmlphw=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=pOzEYfcTs5rawixv/UD11I0ershRS+AhfPNk48r9uOVVX5tOWMFXLw/67EGp94MURlPWsBhlscYp5U/zoPI/hNW3rF/ACsmsrWdXxjSkznZhBrC39sZ+KqeZgYIeaXywNqZBsPkMNlLm0fuj55PJX9FyC7noB3f+c9XLHELK+Tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GrzOLSYh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GrzOLSYh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EB491F000E9;
	Thu, 11 Jun 2026 22:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781217023;
	bh=RIlIDUHGcKjCHfmOtBGc3q5oHD7TDpjiPKi+UKNilgk=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=GrzOLSYhOwaXh1r19ps6AYaVvkk/MDmkZG5zWWAhb5UU+IV2Al97uz+gV1059x5aT
	 /gmZQNP7hsYg1IVAhVXn9K9X9YQdSQRBmjOSzqJNTmROWElOcUjIiwHTLF1L8kTM4Q
	 OJkKdPGnWdFBq9FdM74HjQguyXEv8VI7GAR3NzxQZAobXrxscZeb8nXHNBND6ekXzb
	 JNayBYmxLSe3CZR5LY8dLPAT8agqD4//F5Gl1AFVrYPQP8smp8+6VX2I3UNYTMuglt
	 I9NSZ6iL5YW7Qru8lcyuESNAoX4XkiCxC58TrcpGId53B+Nm0Rp1gLmzThc/lj7LKo
	 5uY975ez22vZQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 9389D3930FAD;
	Thu, 11 Jun 2026 22:30:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] sctp: validate embedded address parameter length
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178121702013.389578.4099391378396702786.git-patchwork-notify@kernel.org>
Date: Thu, 11 Jun 2026 22:30:20 +0000
References: 
 <7838b86b69f52add28808fb59034c8f992e97b2d.1781043268.git.lucien.xin@gmail.com>
In-Reply-To: 
 <7838b86b69f52add28808fb59034c8f992e97b2d.1781043268.git.lucien.xin@gmail.com>
To: Xin Long <lucien.xin@gmail.com>
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, davem@davemloft.net,
 kuba@kernel.org, edumazet@google.com, pabeni@redhat.com, horms@kernel.org,
 marcelo.leitner@gmail.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  9 Jun 2026 18:14:28 -0400 you wrote:
> sctp_verify_asconf() and sctp_verify_param() only validate ADD_IP, DEL_IP,
> and SET_PRIMARY parameters against a fixed minimum size of sizeof(struct
> sctp_addip_param) + sizeof(struct sctp_paramhdr). This ensures the outer
> parameter is large enough to contain an embedded address parameter header,
> but does not verify that the embedded address parameter's declared length
> fits within the bounds of the outer parameter.
> 
> [...]

Here is the summary with links:
  - [net] sctp: validate embedded address parameter length
    https://git.kernel.org/netdev/net/c/e9361d0ca55c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


