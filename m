Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10A95486B80;
	Thu, 23 Jul 2026 17:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784826994; cv=none; b=ZusCQJJG92o/p640SK+jewS1ORmXg7SR4d6ltIJ/Hh65T8ak6TlawioT7jC7n1nlxblRawPhwVbe9fyLN2U65gi+paCC+XmVBKbFIOBzHJwrmk+4MsEqNZ/TVFMWVZv97skWESskXON9aWoweEW33rRRRPxjDOvKGd6JoeR0INg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784826994; c=relaxed/simple;
	bh=+5Y9BlCQLsPsn9xvIOV3o2tPLRlKGrwd8dRijaP+VHE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Htd0si4ga/bXmLO2cRFeDlMp9cT2l+ZxhQIgWiXFVcMHl9fp4wj1zMuHLJeZ1pvIl4kS8ikqd6o9PJTmJ3V8EwB2q1+DiIxaa/J/Bni7nMppsTqYyNRdvvYATTkBWrVPF5KtjPSi5HI1DgX/7G75KI3pZHxdqUvbePxyFe9LgD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mPhhF3Ga; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mPhhF3Ga"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EEF71F000E9;
	Thu, 23 Jul 2026 17:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784826993;
	bh=tDjoiEC1AnRY2H4SoEa6YIUOY/ZqbN8pkxBxp7o0AnY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=mPhhF3Gae+FU0CgE61cwIbAJx0AgCNHXqaUvw13IKbUOQ75ZjWggYzWAAIJjcuLjQ
	 Nk8GS0k9bpXBNR1zDHzioKz0cd7w8g7Rs3VDFDLnOMSr9FL3uVh1W0ohLComTJQ5hi
	 LN71pV7DWMMrz5s3P+mIbmUbIOjE6c6BrcYLUWQhpZMAYQIp2J8wgC8YgYyh44sepM
	 tzap66Q0xzUU6OlCIpqYdpzT+d3gwllWa4DH3Rogzn+pw9xTVFejOt0l1wLdP+myz2
	 p4agXetyVb71UmLSNOTfZZc6Zn6OlmmQHjqmYl3BkHd20VwmVLQlbJg3Okd6EsNH5I
	 iJOblb4hpY8aw==
Date: Thu, 23 Jul 2026 10:16:32 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: luoqing <l1138897701@163.com>
Cc: lucien.xin@gmail.com, davem@davemloft.net, edumazet@google.com,
 horms@kernel.org, linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org,
 marcelo.leitner@gmail.com, netdev@vger.kernel.org, pabeni@redhat.com
Subject: Re: [PATCH net-next v5] sctp: auth: discard auth_chunk when
 skb_clone fails
Message-ID: <20260723101632.77849674@kernel.org>
In-Reply-To: <20260723061107.384106-1-l1138897701@163.com>
References: <CADvbK_cb8Q=9nv5Z5eR3cf=NLb=5=wSg_HKHrtCtPU_bAN=qvg@mail.gmail.com>
	<20260723061107.384106-1-l1138897701@163.com>
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 23 Jul 2026 14:11:07 +0800 luoqing wrote:
> When processing AUTH + COOKIE-ECHO packets, if skb_clone() fails
> due to memory pressure, chunk->auth_chunk is NULL. The original
> code still sets chunk->auth = 1 and continues, leaving the
> COOKIE-ECHO to be processed without a valid auth_chunk for
> deferred verification.
> 
> Discard the AUTH chunk early via pdiscard when skb_clone() fails,
> so that the receive loop can continue processing remaining chunks
> in the inqueue instead of stalling the entire packet.

Please stop sending patches in reply to existing threads.
