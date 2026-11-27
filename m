Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795750783;
	b=b4uSwgtS7YSIMsXwAaJLWNt0/dxjj+njqV5ohVPHS890kNjvYVwO5EjGI11GjejH0h3y
	 40NMIzdlns92r4u3TV1+pOQD1SBCGVDQlstzdcaJ4Tvm4253Duh7YWlOb3D2zHwDlQGOS
	 Z/lNjB+IS8XZz6B83klUhJ5qur8pnUAWJ3v66waCDA48dS1+N2doMCJ8xGtvyyRr9mjyd
	 DdeqoBLwaXeA3zZVKs+PG9ov0a8usDxxDrqvT4b/U+1g3xdHxT+qaT9PbIM5oMeFY/kP9
	 57KJKecSmTh8NY5hc+08eDZwiGq8ybvD+6BkBf6KuTGe9debCfJ/XrlUmyOtlNjnrng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795750783;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:Auto-Submitted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=oj2zs7YpNjut+Fle9NDI2/nVbuq1xcuWOh/20pAlrQ0=;
	b=p2bprj3U5Bqg4p6XrdsTGVEJsKEndxhUVGDaaV9aM1CeIDjy+uMemID2qBUeX8UuoJdg
	 svJN+mQSq+YAmXtWJw/L4KRxI8LrbyKANeZHXJRVcpVy2XOzWQKcTq5CvCG8tmW6W9/rr
	 0R79SN3aUwylQ2eLfgaJOP3FRMPOLqfSwYBmWESnegrHm9XRXQOYw9CpQQLhDrmrElnKg
	 fV5s2pyyB/o16DPPM7R/0UkzL0DPSHz3OQikTl9n9Wx4AwapLcXt/EI/28+Vzco/SEFFH
	 lJB6mQRR8pkMFjDop/Xj2t9jZgx+jqg4fu5NaOcqzenLygrD+IfoDZrJ5DeVvvSbRbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Bahv4YN1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 594A8606A31C;
	Fri, 27 Nov 2026 03:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Bahv4YN1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 443E61F00899;
	Fri, 27 Nov 2026 03:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795750782;
	bh=oj2zs7YpNjut+Fle9NDI2/nVbuq1xcuWOh/20pAlrQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bahv4YN19Qp2EBe6mSQtqDMoJ7rY0VYPd7KjOe+n6OrqCLMFq97AdWNNNURw0SBR3
	 QhXRrbjvXSX8XOD5uyOc9Qm+D6E1L12cwJSO16oRg+eWg1qUvAB5RaXqp0GCY4UuNL
	 SzIptbuarehYxJq7Q6OrJQEd0WDN73ZDPOuGZl5URE4CRxbd6lzFXHJI5xORf2Q+/A
	 naH4pjjwyA3TI9VQm+Cuj77tVfYyAdbl8JQOENMwL7xxUJbc7g48ZsZN0MLHUHevc0
	 vpATkyG9G92DoJp4aN7o5SG3fyYdhavaW/RZWfln03ISfX6XnIGAz8tofot3UDt2wW
	 z7LaUWaAGg72A==
From: netdev-bot+sinfo@kernel.org
To: Sun Yiqi <sunyiqi2@huawei.com>
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
 marcelo.leitner@gmail.com, lucien.xin@gmail.com, davem@davemloft.net,
 edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com, willemb@google.com,
 horms@kernel.org, trilobyte777@gmail.com, luoxiaoxing@huawei.com
Subject: Re: [PATCH net] sctp: validate Cookie Preservative in the first pass
Date: Fri, 27 Nov 2026 03:39:41 +0000
Message-ID: <179575078181.3294.2500218795739226970@kernel.org>
In-Reply-To: <20261127033534.175-1-sunyiqi2@huawei.com>
References: <20261127033534.175-1-sunyiqi2@huawei.com>
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
   (e.g. found by LLM and not proven at runtime). If it was triggered
   please include the symptoms, like the stack trace or kernel messages.

Please do not repost the series just to address the above. Instead,
reply to this email with the missing information, so that reviewers
can take it into account.

*IMPORTANT*: If you do repost (for other reasons) - please include
the relevant info in the cover letter or commit messages.
-- 
The evaluation is done by an LLM so it may be wrong, if you think
that is the case please reply and explain.
