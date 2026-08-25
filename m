Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E39DE3EAC6D;
	Tue, 25 Aug 2026 09:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787649063; cv=none; b=OhRmLtottHeapd2oqZGRXcYzMHpRNjFhqHxFyCUUUj2Gd1xPbJZ8we+PUStnxL7649IuPm3i815CLX/NbT/lbXs2H5j98DdjNvg8i42PYlb2k+Gd7TYfR8iubHa7aNJS3E3awJZk3CAO6kL9cuUydAEiYT1TnHAhUcN6sWGHxTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787649063; c=relaxed/simple;
	bh=y2o0OnwC6jrVGWgzIXGqD1iIKejFda1MtFL2bWoaKvI=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=Df/vKVBy9VuA2UndoOFgcVH1UpVc/P6czNi2z8a3NcvyeRv1ier6rtqsiHR8f9raZgt+MlRJivCsS2YArdT0orG3exFj9sOM6yUW6izOpxC8tdZhCNDtzYURlzDOFvcuZGU+jO5JM0rizlbO5S35brxzM0PgPpP9i+9/ib5vXxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kDx7MRtQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kDx7MRtQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 850651F000E9;
	Tue, 25 Aug 2026 09:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787649062;
	bh=z3dMN3TWHIZI8df4I6nsAXJ3q+Cd8tMxiRx2fIyjOKY=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=kDx7MRtQVQ7knhiTvQSjWUsnQfHJX77W91pHnIKK9vKKei3V2uMcMaFDVPl1HvSBc
	 pSkgc3IZkTKYWCYWr0SXNKOYFQzB8WKxoq4TXIWp4dlo2MOCOnJqZrv3CMEnDTo1AT
	 JVw7G8UefWBhP+Q7rs3MQXXBwTU3BuyM0jniJjKBtMdinkgH/sCQ0QUvMYYSxhgBZs
	 UVbpu4wJTNWEW1hWtmxrhCuHmqck/Gk92zOurrktPKaBy3exlshZgAQClRq2KSCjPh
	 OTfAJLxAWSvBuNNtpK/PQBjle/htfA5e4fICj2AyuP00Fkwr4qiWK6HZSGGyaFeG/t
	 2OWR+AKKJ04Iw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D0A8D3924A77;
	Tue, 25 Aug 2026 09:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3] sctp: fix NULL deref on untransmitted RECONF
 completion
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178764900938.3343118.190077942408834584.git-patchwork-notify@kernel.org>
Date: Tue, 25 Aug 2026 09:10:09 +0000
References: <20260823172857.896146-2-bestswngs@gmail.com>
In-Reply-To: <20260823172857.896146-2-bestswngs@gmail.com>
To: Weiming Shi <bestswngs@gmail.com>
Cc: marcelo.leitner@gmail.com, lucien.xin@gmail.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, xmei5@asu.edu, stable@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 24 Aug 2026 01:28:58 +0800 you wrote:
> sctp_process_strreset_outreq(), sctp_process_strreset_addstrm_out() and
> sctp_process_strreset_resp() complete a pending stream reconfiguration
> request by stopping the reconf timer on the transport it was sent on:
> 
> 	t = asoc->strreset_chunk->transport;
> 	if (timer_delete(&t->reconf_timer))
> 		sctp_transport_put(t);
> 
> [...]

Here is the summary with links:
  - [net,v3] sctp: fix NULL deref on untransmitted RECONF completion
    https://git.kernel.org/netdev/net/c/2db9bfa3e27b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


