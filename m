Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BD7A33A9F8;
	Mon, 27 Jul 2026 23:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785194987; cv=none; b=N+2HJGxkjMeXZ8G7f11A5hD+yPfQOcQ1A5Do7Z4mixMOfVLxv5Hs8Z9Oye9g0Iv6RfmkzgTTcgwDi5DKZjp5XkYbTnknI+wU3rRZgPjPTYqE6LzTy2J5dORlV1e6/dMO95R3QbZ7T+fgPz2IPPM9Y0lGIpKEIjlhJLriHum+SCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785194987; c=relaxed/simple;
	bh=N/iF9oMHYhDMZsXRu874S4TLmF3AQ2WoGz4MCO6oOto=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xcl/DeUWQr+zQjIvMzaGoTBoGuiGp2aJC5FgF09PpzRWHgXfnlWxy1SzgVv1Es1NSnR693h1R7ODyKHs+LXbizpP3IESg2We7MfhmarfyzjT6+xV2TbxPyO90dntsRquKIh075K//kZoir+pXwb3+4QUW1JkwJy1dhRhHmw62T8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HIgQ6RjK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HIgQ6RjK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AB381F000E9;
	Mon, 27 Jul 2026 23:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785194985;
	bh=NOVeJ6rLUpt8bO4hQ0Zn1My6HwzKDAisC08cw8aqaZc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=HIgQ6RjKu5ZSOrDyX5UPsxXTWLwPVzMS3fqL9Ax6T/XWmNSWaL5eStOh154Mw1t9w
	 BXdrMp2qCdOgONZ/pkUDIFWmGJLCxiDZcbWz6WwXSMFcaoEGxogmf9vPu3vbEcFi7G
	 s8BmKMCAn6x758ZTWHsaY92f26AQAwr+WjfxlpruWtrxOtwfyiLmg8N14EEb2YCjrP
	 M5ivyhwOwtkGvbSlPtVDH0KPrWrLckc++fkFr9NPHlsDEd2AI+5jyTQ2igJUuHb966
	 pogtkIV9qiysqpDMG/f1fxqvOspPAi0E002Dsl6CfJ7K2ZqOGDouIY+lXRGeQQheU0
	 N2wIw/zEUgEtA==
Date: Mon, 27 Jul 2026 16:29:44 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: luoqing <l1138897701@163.com>
Cc: marcelo.leitner@gmail.com, lucien.xin@gmail.com, davem@davemloft.net,
 edumazet@google.com, pabeni@redhat.com, horms@kernel.org,
 linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v4] sctp: socket: set *err = 0 on receive
 shutdown
Message-ID: <20260727162944.64697fba@kernel.org>
In-Reply-To: <20260721022522.178618-1-l1138897701@163.com>
References: <20260721022522.178618-1-l1138897701@163.com>
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 21 Jul 2026 10:25:22 +0800 luoqing wrote:
> From: Qing Luo <luoqing@kylinos.cn>
> 
> When sctp_skb_recv_datagram() detects RCV_SHUTDOWN, it breaks out
> of the loop and returns NULL without setting *err. While current
> callers happen to work correctly (sctp_recvmsg pre-initializes
> err to 0, sctp_ulpevent_read_nxtinfo doesn't use err), this is
> inconsistent with the generic __skb_wait_for_more_packets() in
> net/core/datagram.c which explicitly sets *err = 0 on shutdown.
> 
> Set *err = 0 explicitly for correctness and robustness against
> future callers.
> 
> Signed-off-by: Qing Luo <luoqing@kylinos.cn>

AFAICT Xin Long asked you to toss this patch:

https://lore.kernel.org/all/CADvbK_e4StN7-vSRjYC_FPMN-_3xjwhCxYUb+Jddz-akO-ryPw@mail.gmail.com/

so I'm dropping it from our queue.
