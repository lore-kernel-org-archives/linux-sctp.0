Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD87B4457A9;
	Wed, 22 Jul 2026 18:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784745525; cv=none; b=ZLo6KihuYVI2dFd832vaRbaPZlEPKIU++QYpiom6q0tfV5vvTXrFLLTRgctCASVTQBDctQAACk81lXciBsMuHXQ7fwGDtWhctEQWCIZnlJsa14cgDKFx0FO1PFd8XuBsVaHB7ljCfw9F/GngV75m9HnOPvsnpuXYmzLVhssJjdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784745525; c=relaxed/simple;
	bh=KqeVKvUmP2JF05QpkawW/sSGD+s1jeXGRcoLfrAHLcI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tWG7I52EkYdxYeOCdABbWspV2N7ZyvMpN2L4c2qGc0PHYy7k+3w8k8yDHrp8hmESVk9caDV5QwG0H0PWgQ0DPpChi+iCB2h9yQ+rSkCr1NCzPAwkWg3QpeEinMZ96kL5ZUzBNzbrGKoaNHswh5Sai+z1552cx3Ivg1cWQW1kBUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X+GTNjOT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X+GTNjOT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 996381F000E9;
	Wed, 22 Jul 2026 18:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784745524;
	bh=KqeVKvUmP2JF05QpkawW/sSGD+s1jeXGRcoLfrAHLcI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=X+GTNjOTWxxedhkot+QIcqTCSSTg3WsNkYWLRs5cAufTui6Z9MQ5W6ExphBYULcpd
	 ppeC/tOp3DDS0aaM0crOqKcJ1lbqJOgJIFqZzH1TkhT/1uVoxKw6VV9fBmqvpW6QIa
	 QMo3+XPJI79Ca/gHIYLOCy0Nm4PmuP/x6sYm+OEZGniuXmH3YjYNvormMT2yWbO395
	 Y0j7NmF1Dzcq3HOIFw1+L00cMSOjk7uqWIxvW59XjXmlQYn/nJbqCXiy5/oRfm0doF
	 Pvlkfuv1y91WJADn3AOdyNgjqSOy4VaIGoixl22IpESRTozTD7Pfdnta4YFmJXw9RG
	 2HQ8b5elT2QOw==
Date: Wed, 22 Jul 2026 11:38:42 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: luoqing <l1138897701@163.com>
Cc: marcelo.leitner@gmail.com, lucien.xin@gmail.com, davem@davemloft.net,
 edumazet@google.com, pabeni@redhat.com, horms@kernel.org,
 linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, luoqing@kylinos.cn
Subject: Re: [PATCH 2/2] sctp: auth: Fix safety issue when skb_clone fails
 in auth_chunk handling
Message-ID: <20260722113842.631d51fa@kernel.org>
In-Reply-To: <20260716065259.872235-2-l1138897701@163.com>
References: <20260716065259.872235-1-l1138897701@163.com>
	<20260716065259.872235-2-l1138897701@163.com>
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 16 Jul 2026 14:52:59 +0800 luoqing wrote:
> When processing AUTH + COOKIE-ECHO packets, if skb_clone fails due to
> memory pressure, chunk->auth_chunk is set to NULL but chunk->auth is
> still set to 1. This causes sctp_auth_chunk_verify to skip the AUTH
> validation (since auth_chunk is NULL), allowing unauthenticated
> COOKIE-ECHO packets to be accepted.

Fixes need Fixes tags; do not send patches in replies to existing
threads.
