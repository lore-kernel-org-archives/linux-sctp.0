Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F80E433E82;
	Mon,  3 Aug 2026 21:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785792652; cv=none; b=OknJ7qeOpyQCkkQuLOV25rmpC92vVZtRLWzmuhXwgsrY5nYaelVIEHa/2mJPbAbcv+9gWiwAuhvU53V2gSao1CS91GDLSxW66T4XdlZrRolIb+YgytXhMruAHorKrvwiUFkFtPGNsTF3EtGc/nFWqyApKUMkZHrK5UOg+87+kCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785792652; c=relaxed/simple;
	bh=83XJ2oakS6IXJ20a13utpRBfPPTBvZGpaGuIZu7kHMk=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=g007rf9fniTpIKbTSkn+70wYOJ7ycMWOKhU0m38XKBxnirTixdlVOar04i8hDJzUPZKVshCI077JrGS3DVsrZImTDjFy9YKLgapv7B8XHwGwABhc9Q1JByMJhNpgj8ecuF3RJcD/z9FAH/GmXQa3mygcVptvNUZsW5LtUPei5i4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GS6bKAnH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GS6bKAnH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FFC91F000E9;
	Mon,  3 Aug 2026 21:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785792651;
	bh=nBhFgjrJYnroj/LF5RKHM/CBbE3eZcuH1TEu0uButts=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=GS6bKAnHQJEa0sSg3i4LzemTw5xQLe1Mdhr+9Qo/VTzASIoY0GA+I2EIrX+jcj7tl
	 fFsvVdSKFb1kgMeDeZTJFo9J9fAc+Q+nvZcROtbn0bJyIfn6SnR7BWhf3xFMnARuv1
	 HyvhHyeEs7CPiIAYBB59KF7EGHRW+waCCT6+8NG1yOEkyd9jmlYnQZWAuPt/L3GkPg
	 eIqbyIz8abv1mo7V1yJKHgSvzJVqJjj5z0GsNbdjNdAgEvYd/DAQgCLmGTAorxHpjy
	 g0+g8Qz4wvoA5JbbL0RLtvGRxMAmth/ASjijsX36s3zL7PIagfqp69UB1LSpRTM25v
	 hrWCOGBSU9h5g==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 5691C3924461;
	Mon,  3 Aug 2026 21:30:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3] sctp: keep chunk->transport in step with the list
 it
 is queued on
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178579261188.2840566.3318214381652988676.git-patchwork-notify@kernel.org>
Date: Mon, 03 Aug 2026 21:30:11 +0000
References: <20260729160028.54546-1-baul.lee@xbow.com>
In-Reply-To: <20260729160028.54546-1-baul.lee@xbow.com>
To: Baul Lee <baul.lee@xbow.com>
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
 linux-kernel@vger.kernel.org, marcelo.leitner@gmail.com,
 lucien.xin@gmail.com, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, stable@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 30 Jul 2026 01:00:28 +0900 you wrote:
> __sctp_outq_flush_rtx() moves a gap-acked chunk onto another transport's
> transmitted list without updating chunk->transport:
> 
> 	if (chunk->tsn_gap_acked) {
> 		list_move_tail(&chunk->transmitted_list,
> 			       &transport->transmitted);
> 		continue;
> 	}
> 
> [...]

Here is the summary with links:
  - [net,v3] sctp: keep chunk->transport in step with the list it is queued on
    https://git.kernel.org/netdev/net/c/9f2cf069a9a7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


