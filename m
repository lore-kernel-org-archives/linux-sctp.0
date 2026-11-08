Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794154598;
	b=iu4Q0nriCMthJqr1Byni4afh3C414Ef4L1Lm+bw7EstJbgmRucvj+RXlQ1d5jZhjNZon
	 bFMRoLE4rpljNtYvCri6zi9KJQrQsjMQqUOzeTMLhT61z1qly7Ae2ai8O2nrmBYLlz1kR
	 kEv4MZUaSzKpx+4Fwn7qQZEcyr2h6oHrargPFhtmGwrfC8NUAAX5ZyxRLZLZpByRTfHXC
	 jaTDXlsg6SYP/N/OBaYInraOVN5RMF92gUKb20xUxTqtdv3CHqoW8NL5SXTkEz/YXIsT/
	 N7LHp4ONbvSwxZyETRLxWJYMTsosYiIJbokODYqF2kkgNp1SnUvOMkPHQ8FmKL+g+wA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794154598;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:Auto-Submitted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=PJRu7W6/Or1we5Gv3BgoLEtby0D0Y0UGgfjBHfRc5+k=;
	b=oQ6zbyBjz2oNQYpeeien9LKk9u90E5TOxPW8VdsKKxAgjAKj6hmOJMXpD+gSAVndhkzr
	 mMaOQAIwWo5DtaY1Uy8wPiUiPlpigQSyuacMEqafwebT3xPxBTwAFaKj3WsEeevTtpUKT
	 VKEqU8t5HGyGDIuRkGZ28fCuiwkwngZwYmjovkL9wVaUM7WQ93dmQd7aShoWgTPF8fTU2
	 qHp1U6z3YBQJpmquI2Wcrq7apxI71hsv1fcjtgxQlk/NLqf3gj2oWVtT4/tpLyZYWyf/K
	 GF70sd8+Bh9/WDiuXZ87hy8dUnPn0Pq4kL5AOSszikKyp4dtag+akO8SbnG6Xtj0Sdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=H7yLABPo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A32EE606A320;
	Sun,  8 Nov 2026 16:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=H7yLABPo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D8F11F0089F;
	Sun,  8 Nov 2026 16:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794154598;
	bh=PJRu7W6/Or1we5Gv3BgoLEtby0D0Y0UGgfjBHfRc5+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H7yLABPo1HPhpF8t7LpQlFRTmTKFZlu3+qtxar0eUGSxjpAYK22jJ1XcM9B+DBA5P
	 +39ZdY2kyi9y6aTeEWxhOWc9cGc/SNCnVcWZ1BAbMktaALZD/pKv/QxTtGXf68QTOo
	 /x5ZDlOG8GiI6sD2rvj3NSEleGWnlVhaR1/5UKSF8LBvjCTqHmSDxW+OiTn4CNPp2h
	 hbsuUgG1wwxpgGdBSKCdUUd/C/ynn+e59OO1+HsrZgmJomJ3Wa5xwHveCIYdjxc+Ls
	 TQM05OgifmHCCL3sY/QhpC/Q7AZ6GzRHAAE61cWqPo3KN/gt59zljg2z1Wc7NKE9fy
	 iCN+YmRW0Q4zw==
From: netdev-bot+sinfo@kernel.org
To: Weiming Shi <bestswngs@gmail.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
 Xin Long <lucien.xin@gmail.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, Wei Yongjun <yjwei@cn.fujitsu.com>,
 Michio Honda <micchie@sfc.wide.ad.jp>,
 YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>, Xiang Mei <xmei5@asu.edu>,
 stable@vger.kernel.org
Subject: Re: [PATCH net] sctp: reset stored flag for each association
Date: Sun, 08 Nov 2026 16:16:36 +0000
Message-ID: <179415459681.488859.6212097823933198375@kernel.org>
In-Reply-To: <20261108161149.2774119-1-bestswngs@gmail.com>
References: <20261108161149.2774119-1-bestswngs@gmail.com>
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

Please do not repost the series just to address the above. Instead,
reply to this email with the missing information, so that reviewers
can take it into account. If the series needs another revision for
other reasons, please include the information in the commit messages
then.

The evaluation is done by an LLM so it may be wrong, if you think
that is the case please reply and explain.
