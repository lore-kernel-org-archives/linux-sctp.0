Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622019;
	b=p8zmCY/z8WDWzH4bVAt+dEN0XLRfls4uzuSMbc+JzK9RoaNxFWYf+bk4dhyKmSiogtd/
	 NBeYf4jlU6vFrQ4f5IYdn3Cpz0IJLkpdlIsKm8jT7n0PVyibncyT4gNwG3togpRxDvSvt
	 YNNXbKoDUujrvZ4AWcSfJ4RcDdZWPtOsNFwVNGZxj42BXjlhPjW4l3PJSx3ov7MGprx6T
	 NqoYir6DoAlVH/IjmL83un4a3Zx1OVIZ31doitGa3VosnBn32QbiepszZ8UOG5Rw+QK6l
	 ehwJ9QQxbvwywmN3Y7ZvUF8u6jA5Mx074nHeRniZn7yArRnCPFlsC893KkkM1EaSMyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622019;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:Auto-Submitted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=Ps3dmenyy5Kz+Ld8FFyPnRbKN1BblcpmGxOsdgzLlkg=;
	b=uFmKDiYUtCoI/WtSBl1yg8g1n532U7AgWIY8xAOKAowLNJ1xfhPJlLMXd3kj/Ik8WX5d
	 sdYXK3mcDWxZ6iAiZ7eqIv1DKxhMHhJveU6k62q1e+rkNoK6mXJBd6QOoKYL+zITWzLmn
	 q7jnZzV+v+NwFp8LRdTZa2KEUaGLMRgAtFU4YcR5zewS5aRCku6bYjcEhCCTVuw+VZOnq
	 q0MJ1Oo7cStYtqwJ6WnHUQiVCqHCGmXyAHsV5MOtI9BPXe6lQfuQOTA4HruVD3fskXuem
	 XM766O0TdFu8KLSfX6JrbF+e8MtWPDsJhKBr3DcoczoVMA83WFOiXNLyxELZdJGibrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aUlsk8V5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C41C4606A326;
	Wed, 25 Nov 2026 15:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aUlsk8V5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 308C01F000C6;
	Wed, 25 Nov 2026 15:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795622019;
	bh=Ps3dmenyy5Kz+Ld8FFyPnRbKN1BblcpmGxOsdgzLlkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aUlsk8V5/CfoIERl1OWycCYzo613VamsR34MK+T15Fi8OIKV7wSJShH4rty+lj/5f
	 SUMrm+vmgmDFIBa9vxJjT/WRTnhBGTEZFJe0WDkfao4Tjo10LnPLObiRXXJQjZ7K/r
	 2oU9ypaoddvctX+0XhBX1mUQMtlthE32FAYLeM4BxlTUaOH1Yu3+N8mr5gca/ZSAAq
	 HIQirLzsKCarsV82czrkmP9a33RTPQwpUvCsWL8dpmeGZJvAX/tqye9owCPHoIPW+C
	 vN6trFrqzrBTU6UZPHVMySJi0TluZUaGVbCkp33pl0Cw6FqEQRm1/qda9mhrOY3JvX
	 W6xptqGohPRjg==
From: netdev-bot+sinfo@kernel.org
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
 davem@davemloft.net, kuba@kernel.org, Eric Dumazet <edumazet@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: Re: [PATCH net v2] sctp: diag: fix stack garbage in IPv6 scope_id
 during dump_one lookup
Date: Wed, 25 Nov 2026 15:53:38 +0000
Message-ID: <179562201873.3294.17417133735520831419@kernel.org>
In-Reply-To: =?utf-8?q?=3C7cc69548f249ff63527a663c22d9dc918d3c3e84=2E1795621?=
 =?utf-8?q?751=2Egit=2Elucien=2Exin=40gmail=2Ecom=3E?=
References: =?utf-8?q?=3C7cc69548f249ff63527a663c22d9dc918d3c3e84=2E17956217?=
 =?utf-8?q?51=2Egit=2Elucien=2Exin=40gmail=2Ecom=3E?=
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
