Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1D0644AB82;
	Tue, 21 Jul 2026 21:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667754; cv=none; b=niCghK1GEmuPF30X3ufg6oAw36nphYpVMM6s3chQvs8EL2BhYibEYLkvWTduBuyXXr1ka30Ns9mxiq/tzCol3DwElJJQ+4FbEs3Peiae7WVA7NLSQIaRRAnv8OqDffRPiyF1M8vHMyzlJBVAtaWJ4L9d3MqDeF8dT+hrAdt/XNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667754; c=relaxed/simple;
	bh=35s5opSaN9LUwfRsQavnrpUKF49zokDfGp+sZ9xftl0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L3YuUSeGwV5SV0+cKlG8jwn8JrQ+t94yYT2pCM77j0KjhqWI5s47P49Og+Gz1tWaNydFLOj2nfBNyrRvNxBYTuyXcXmZyOyQQ9fXT1/nwAA8G2hHbCs/kiAbuM0DFDfBYUTNdPXSWP4OsTpjiQH56n1IqK6KhNfCJMQpJuwIbU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jZuGKcDe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jZuGKcDe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C6FA1F00A3D;
	Tue, 21 Jul 2026 21:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784667748;
	bh=Bfs9um8/mWup01VGWzj4zn4GD0jKC5U+6bXKXLRYKRQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=jZuGKcDexa0RO5XbwO4w8s+YbYZv3estGO5hXB1wdRdxazy5rVY8bED9NzDSyY6yR
	 BsMEztm1kitDOL25tKO/oQXF6nl6V3Q9EeDzJ2kPmFHGSy6vlRKnAyEH0Is2Sk3+wa
	 hI4A3AJXHI4KS6h3qxG2w80Q3el8BCc8lF7zf/TMoBuIAf0eX8mgwZZMUaTnLbDp/C
	 q9b+ihubKh8UOG+5pQa6EyhL9pRnMXgQTa9bxxEcNI4CvaXnSj7ZMdbiDjyTLYbl9t
	 SluMK964LcBcrTgwthNc9YsXe+d3Y4GIPRBZ277FLj9rfYbdmwPloX3LItt0HI7l4s
	 iLH5UIfJchKJw==
Date: Tue, 21 Jul 2026 14:02:27 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
 davem@davemloft.net, Eric Dumazet <edumazet@google.com>, Paolo Abeni
 <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, Marcelo Ricardo
 Leitner <marcelo.leitner@gmail.com>
Subject: Re: [PATCH net] sctp: fix addr_wq_timer race in sctp_free_addr_wq()
Message-ID: <20260721140227.538ce6b3@kernel.org>
In-Reply-To: <5dc95f295bdb5c3f60e880dd9aa5112dc5c071cc.1783707823.git.lucien.xin@gmail.com>
References: <5dc95f295bdb5c3f60e880dd9aa5112dc5c071cc.1783707823.git.lucien.xin@gmail.com>
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 10 Jul 2026 14:23:43 -0400 Xin Long wrote:
> sctp_free_addr_wq() previously removed addr_wq_timer using timer_delete()
> while holding addr_wq_lock. However, timer_delete() does not guarantee that
> a currently running timer handler has completed.
> 
> This allows a race with sctp_addr_wq_timeout_handler(), where the handler
> may still run after addr_waitq has been freed, acquire addr_wq_lock, and
> access freed memory, leading to a use-after-free.
> 
> Fix this by calling timer_shutdown_sync() before taking addr_wq_lock.  This
> guarantees that any in-flight timer handler has finished and prevents the
> timer from being re-armed during teardown, making subsequent cleanup safe.

This version did not apply when it was posted (IDK if it applies now)
Please rebase and repost if it's still needed?
-- 
pw-bot: cr
