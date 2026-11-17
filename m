Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794913640;
	b=R+YlHzaM1IUMOVsMHJzXRF9A+9HeF7lyUn2sUWcPQOcinsWkrIosmromIbe267A096Rb
	 EO+2Ejbn2bXgzl06sfKYrHxdg+NhxA8NM5B7w69uzoWFB7UHh74E/n++rfobpbiFWX6XJ
	 i8nTpjXtERSaWJMYqYKAZE9M+pui3I2JGX4J0gsPOgWCu/pKoLTU1hAcHDfrq2o5iqz13
	 VAdZwuXt6wI8mnAASLqRQB9x2l0is3aeoSgn0j+vuHmMocwTKz6mJSn4BHnQv1pHVKa5p
	 uWGZen9MmqPiJ5YYLzLG2NTuY1R0uS0XU2liUviUfZmxCOnSfJ8v/6Q1BB6StBN6eWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794913640;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:Auto-Submitted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=Ps3dmenyy5Kz+Ld8FFyPnRbKN1BblcpmGxOsdgzLlkg=;
	b=XGckoe5/+dHnLvmvjstFRykjt95fHOYzBfhOlWYr4ppajmK1xBqmmjO/j7gdRlf+xGL+
	 LaXU84BKZl4an0tbRFD68AIrTXjeAGBQ6fQvIqzMSj2xcxob9v6CpUJR34/IChKxF5hw4
	 2+i7G1uRMLEK9zBBVq9NqDEixQHR6Hf9eneKB57wvB/zNgbwEJh1eWzKQKHp6iWrxzdkl
	 SoZfqv+m5gtK/OzRy8l2xB9z0e8m3SCSB9y1PR8aYwVjnDaKm9fLiyiEHR2RAgZt2BFUC
	 lci7AoVYykeFEJzBEdnmdPZNzTR6Yr7fDsoufMJHAB7iGMc0L08LEyXxJNGvyIVKgVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f00ofgLb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1823606A31C;
	Tue, 17 Nov 2026 11:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f00ofgLb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 119A31F000C4;
	Tue, 17 Nov 2026 11:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794913639;
	bh=Ps3dmenyy5Kz+Ld8FFyPnRbKN1BblcpmGxOsdgzLlkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f00ofgLbl067ayrxVgiNg+zZgiegsNW566qd8epi7vasjz2yhaIQ8hhmMyEPEZD0H
	 VDz1PA51WmUuMholJB1kY+HuICkjksvCcuzKuaIdu8u0a32Gmk72AbucpQjbRmXpZb
	 M+FwTR2OxlmNKKIUGdV9kmNs65yLUVT2n2YNLw0sAA9c2JeTpANDNUpMf91yeHiEWC
	 zVqkABHeGetUVff7t26hFDzlsIxxXY0ERZ0G/VQ3NQpOTDTOf9daOaMYSuthYNSsrU
	 M0rluhuUA32nSwZD+ll1wcjzb1YWmh/XXMa6HwDp+GdUzw/VfpCag8gypzAF+HKzTk
	 YKset1oQlAheA==
From: netdev-bot+sinfo@kernel.org
To: Jun Yang <juny24602@gmail.com>
Cc: lucien.xin@gmail.com, marcelo.leitner@gmail.com, davem@davemloft.net,
 edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 linux-sctp@vger.kernel.org, netdev@vger.kernel.org, junvyyang@tencent.com,
 corvus@tencent.com, stable@kernel.org
Subject: 
 Re: [PATCH net v2] sctp: preserve stream scheduler across outq teardown
Date: Tue, 17 Nov 2026 11:07:18 +0000
Message-ID: <179491363856.3291.5557479713761009412@kernel.org>
In-Reply-To: <20261117110459.44083-1-juny24602@gmail.com>
References: <20261117110459.44083-1-juny24602@gmail.com>
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
