Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E3553B95E0;
	Tue, 13 Oct 2026 08:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791880806; cv=none; b=dLYQNs8t+uxkQA8IIcV7vzxM+Luwo3lztGoV/VxZapuaAAiRa5Je1BPbGxch5zbZLmf5yop5Xjpo0QWoRwDLoc2oK/r0iZYtdKaEF+NVW7q2cw6FtGzjC5YyrRTMd44bs1MTYx08LvNMqich5ym1LRSheW/OaTjuZXWRqMUO5ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791880806; c=relaxed/simple;
	bh=RzZqVUxCbVCqm7pH/0m+68eaLgZ2H5Ff29183hKc2PU=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=cl4UHKA2VtE684pvUOwaEUeEkRVU3NZ2RmdKd92uweYYrPsyCozOckBEsBdAnZ5/iuVjGEZ6vs6ODh83PdG4q2s3Itm+nN3zypsgjnD3FEzBrilCmLGF4DlDvOJ8q7IjI4SEkByChak61R7jftKGFruVD0gW82ghrdTWe7bJaKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iOz1fxKc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iOz1fxKc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F9911F008A4;
	Tue, 13 Oct 2026 08:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791880805;
	bh=vTscstDQ6HSiS85iFYZJWm3WRbqXbZ9zuUl2BPS9Bbg=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=iOz1fxKciD89U5WL1htpUebUC+y8Q7JNhFE7EkwzhMpmghVgfI08VS2+sJmgpyuKD
	 F6XjBP19rkwvsEMOoGeD+IfH28GV48WM7kq6fFDtLwbREofOmYUJ6tFFlszWChUGz5
	 oPfKRgMuk38e75mcG56hnbvIEeq0lpItTAaZYmANOO7SVdTfq3fUY9lCSzJOt+9zuY
	 4CYLm2eCHeWDUKveyVcXm1/8A5RddDTUlLPsUdIJ/BeRqNNWy4eMfCrGEjkporxps0
	 LJ6AVIrb+nig4DEIkd0iD2JnRpSGqTRIklvJFzvLUFnyJP/QEvrnIWQ8NsdBq/Gbek
	 C0kQBnvF+axiw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 77577392639F;
	Tue, 13 Oct 2026 08:40:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] sctp: revalidate output stream after association
 connect wait
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179188080428.136048.15899244050224483580.git-patchwork-notify@kernel.org>
Date: Tue, 13 Oct 2026 08:40:04 +0000
References: <20261007035739.3472432-1-4ncienth@gmail.com>
In-Reply-To: <20261007035739.3472432-1-4ncienth@gmail.com>
To: Daehyeon Ko <4ncienth@gmail.com>
Cc: marcelo.leitner@gmail.com, lucien.xin@gmail.com, davem@davemloft.net,
 edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Wed,  7 Oct 2026 12:57:39 +0900 you wrote:
> When message interleaving is enabled, the first send waits for association
> establishment before building its data chunks.  The wait drops the socket
> lock, and handshake processing can reduce the output stream count to the
> peer-advertised inbound stream count.  sctp_stream_init() then frees the
> extension of every removed stream.
> 
> The sender resumes with the stream that it checked before the wait.  If the
> peer removed that stream, sctp_outq_tail() later dereferences its NULL
> extension.  Fatal-oops policies then panic the host.
> 
> [...]

Here is the summary with links:
  - [net,v2] sctp: revalidate output stream after association connect wait
    https://git.kernel.org/netdev/net/c/b7ad72414c67

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


