Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793090147;
	b=WwRX3uFqZPOWTQiLC2m/qwO1Ch9b0S6qCMjo+W279KFOnsCHR92l5GFIgG4j1Re5j/Lr
	 1pP4y4AzkC5aJ+E1E4jy5h97epJve2fZxcvjjDEE8mohJ2G6MvGMORLm9iPt2lVWZPTZ3
	 fUAdg0CeRJyCNkJDTTC68xti7SxtKKDV8v0X8VNDRXAsztET7bdkIrTcUqhFxiDs9zRAm
	 ivPVi0nlaesAF0rOtiS0vVVrdspmJpNJQqNib92/Y9uzC/qC7isleA0EM2yt75T3L7AEI
	 lyBvjUaMD3En1/i0ZvX9Lw4wvX3GwYof0tlbQ04Jb9nI2Z1VA4xhzaLgEhYN2S0YUng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793090147;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:Auto-Submitted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=Z9zRtXHe/J1k/4/9wAeq1n+PwAt+ioXmV3zyjSNrjDw=;
	b=M60tV5tqFFVvSNeopr7JqnkypPnpKA5BKh5EusEyzbaceenhEb7k/IH0AN7kd2fGrfY/
	 okU1nmC5rpoEqN8kUUs/8ScZSWIW2KFSSfqgEeTvJWkycMrns9cqUQcL2EzMIOMhI8GSX
	 qbCVCMGtU0FdqbfGi9YFqhSaeGKjTkcqHy1ut/HGkoIuvheC3jpgZ3+TY2f3xG6WQAODS
	 8OB24gIcf1GuncpasQh2BVSLlWob0WCRytPOBwPfloblEUA5SekzFRmEJI6qP04WuNuqM
	 ydACwF6IeXSG3/0iFrGj9ey0CEu1AYOOQ6ldYImErslTqqo4CHS0ng4vcxAK+YDr9BA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="X/8upzhD";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C277606A31A;
	Tue, 27 Oct 2026 08:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X/8upzhD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CB321F01825;
	Tue, 27 Oct 2026 08:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793090147;
	bh=Z9zRtXHe/J1k/4/9wAeq1n+PwAt+ioXmV3zyjSNrjDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X/8upzhDfHiSban0HHGahglNVOjKvSn/ndgxhqAob78uxyCATI22Ed60Nuvgz32tm
	 lnjnFqomEsJLTVsAp+tF1SCQc4IXD+it/kdV9tYbzrDw6mIj/FPI6EU+qdsAkO2d+U
	 4KnbQSfx/RN1mKbx6MHjGj7XncmH2DyZH2/PHhZ4hzAICpRh1vdbaxZ0LVnGAIRHqy
	 w1i87AehGaeatv3own8Ncw3BslMCBTOZeBmXi4GwYhJJdF/G7IDTW3QifS8Yyi7YjF
	 A3BsKa3qe9nv2s7CU0SkeFQEcn5BZ0cHZp8dRkA/YYUYP/0h6VtyKoPDZ4/tzkMjAX
	 K2aJ5xazArZ0g==
From: netdev-bot+sinfo@kernel.org
To: Masafumi Suzuki <shengshilingmu97@gmail.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
 Xin Long <lucien.xin@gmail.com>, "David S . Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH net] sctp: account for chunk padding in sctp_init_cause()
Date: Tue, 27 Oct 2026 08:35:45 +0000
Message-ID: <179309014594.3327.16979359855381839184@kernel.org>
In-Reply-To: <20261027082405.1297-1-shengshilingmu97@gmail.com>
References: <20261027082405.1297-1-shengshilingmu97@gmail.com>
Auto-Submitted: auto-generated
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Post: <mailto:linux-sctp@vger.kernel.org>
List-Help: <mailto:linux-sctp+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sctp+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Hi!

This is an automated message. This series looks like a fix, but its
commit messages seem to be missing some information:

 - How the issue was discovered, e.g. hit in production, hit during
   development, syzbot report, manual code inspection, LLM or static
   analysis tool scan.

 - Whether the issue was actually triggered, or is only theoretical
   (e.g. found by code inspection). If it was triggered please include
   the symptoms, like the stack trace or error messages.

Please do not repost the series just to address the above. Instead,
reply to this email with the missing information, so that reviewers
can take it into account. If the series needs another revision for
other reasons, please include the information in the commit messages
then.

The evaluation is done by an LLM so it may be wrong, if you think
that is the case please reply and explain.
