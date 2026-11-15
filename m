Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794766175;
	b=hNFaNuhmfh6Hv6eoNdb1oGf0/kMOwLLc33Ax1MjDfD9yNHyusLz2903Vff4oa6Z7j/8+
	 7e3e9I/4OwIzTca6qn93FZjqveo0tF+si5sowxMlvPMBPCdM8cX8aqKG+kfT4hPLsUs7o
	 e1Hm0GQPtUZ1y1ndFEIquwU1qJH+kVfVbk2UYMXQnBzRect5Rc4hgv6bCbqA9lcm7+e6Q
	 sn70B4moVLNRAQu+2C5LqHKC+TLsrKdWn8sbRmhsKb4rJHGpOUdHn8yc7Gst5sSQYutVX
	 4yy8YmCCzcqGjb3gSATEWj8XQS/wndQJKi3znyXmQwnnWL893fW5sDRt5H4f1bw75Cg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794766175;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=D2+Svi0kHYvgSG9q/RUfK7SbfgBZOy38SUfssP6B2Jc=;
	b=qTojWlFS+ksXh7ZxVEFkQBYj7+AVzFt16sE3cSFKqj+KRNsYbTCnHZgAsMssdpe/btSk
	 93v3TNCtF1KyJnC1qyQEZycs2bY2zmUtXcNzU5832onWw0j1CvOuLCPW84mGLOIud0NXL
	 LLPljLbK65kLQKZ76rgKS8Pg+S5VQLo6M1Kz70RMLq6kqdjy6QzHZGVlgNIbrHSWsxL/g
	 R5FhtyWjsGvQW75VyNQc1uzstxmptQz3xfG38OuS5Kbd4lUNyvouCej5THGwmAShudPhs
	 bOH3c+Ps3qmNp/kmtUb7LQifkILT2PvhNaFSSIAMQ1BJPFqBpeZNe4WChtDrs6N4BoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ECemnQF1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DDA5606A31E;
	Sun, 15 Nov 2026 18:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ECemnQF1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83E861F000C4;
	Sun, 15 Nov 2026 18:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794766174;
	bh=D2+Svi0kHYvgSG9q/RUfK7SbfgBZOy38SUfssP6B2Jc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ECemnQF13rWc22V0N9rtbYuj/f2QbXhKatASZsROFbBaynD+9hFW3EaUgdWXhsntm
	 vZfkNRtOrUmu/1zZ5MOg0k27df0F/+F1MB9DByeGozv3Ks3JF+pxBgtyBijKBvo3Lk
	 ifs8N1YTQO2EN1T2LAgBrFyVc9HmRSoqBVCi9dObTIhNTRgnYitKena8HG7+XLzenq
	 PWssUW3E9Pj/5fptolIRR4dMoHl/x5H2YEPAHAqOi1yGljLlsf2CO00KjXGy1GG762
	 z9oWCd2o/J17FwHGjaMFnQC6xz8wTXuZMyFthsU1sUgzqiUPGpQCGnlzFXx+C1uq2b
	 Fc8WfLMflz6tw==
Date: Sun, 15 Nov 2026 10:09:33 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Yong Liu <pkfxxxing@gmail.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Xin Long
 <lucien.xin@gmail.com>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2] sctp: revalidate association sockets after
 locking
Message-ID: <20261115100933.75ae0534@kernel.org>
In-Reply-To: <20261113032805.1447885-1-pkfxxxing@gmail.com>
References: <20261110120212.1110283-1-pkfxxxing@gmail.com>
	<20261110120212.1110283-2-pkfxxxing@gmail.com>
	<20261113032805.1447885-1-pkfxxxing@gmail.com>
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Post: <mailto:linux-sctp@vger.kernel.org>
List-Help: <mailto:linux-sctp+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sctp+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 13 Nov 2026 11:28:02 +0800 Yong Liu wrote:
> Subject: [PATCH net v2] sctp: revalidate association sockets after locking

1. please use the problem you're solving for the subject, don't
describe the code change, so that the subject doesn't change between
revisions
2. please don't send new versions in reply to old ones

> SCTP timer callbacks and ICMP error lookup cache asoc->base.sk before
> acquiring its BH lock. An accept or peeloff can move the association to
> a new socket in between. Processing under the old socket lock can then
> race with an abort on the new socket that tears down the association's
> queues. Transport and association references do not keep those queues
> alive. With mdelay() instrumentation widening the race, KASAN reported a
> slab-use-after-free in sctp_chunk_abandoned() from the T3 retransmit path.
> 
> The ICMP error handlers also reread asoc->base.sk after lookup, so they
> can use the new socket without holding its BH lock. In particular, the
> PMTU handler can reach the same retransmit path, while protocol-unreachable
> handling can run the state machine directly.
> 
> Recheck the association's socket after locking it in the timer callbacks.
> Treat a mismatch like a busy socket and use the existing reference-counted
> retry path. Pass the socket locked by sctp_err_lookup() to both IPv4 and
> IPv6 error handlers, including their UDP encapsulation callers. Defer PMTU
> and protocol-unreachable processing and ignore redirects when that socket
> no longer matches the association. Require a matching socket for immediate
> error reports as well.
> 
> Use READ_ONCE() for the socket pointer reads in the timer, ICMP, receive
> and backlog paths, paired with WRITE_ONCE() in sctp_assoc_migrate(). Take
> the new socket reference before publishing its pointer. The cached socket
> is protected by BH context and the endpoint's RCU-deferred sock_put().
> 
> The issue was discovered and fixed by Qihoo 360's Tulongfeng multi-agent
> system.

3. please remove this, there's no place in commit message for
advertising
-- 
pw-bot: cr
