Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621667;
	b=rScLCcY4NOh8+6q3azYqz6i1uLcaMrIN8vJTS4GQtxVUXEDa78l/nBaZ1+JeBZaQJQCc
	 9Xrzy2IRFg1vU0e8nZ+R43M1kk2FInZ/NC3bEpq0r5uuGvg5ejsRSwl8SCBNaW7zQ3qQc
	 YvA2UeVYe+4ys6Rxk3LTN7W/2bMHQpzZuUEFtwZ+nZVz8q+c+ouQXgxiVrMEWMLm6YzXm
	 ar36wF/FKKgfD0h8n0ZXthAzgPpRjf9U9BcEBezYWOS3LXJTG1u2JSH0qCbOGtdfweoCL
	 O5o7o31jeSGOaeiak93t2xuPHmFFyibRuhkvlPCoYRROWF0fw5Q7YI0ikHhHPQxN6Rg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621667;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:Auto-Submitted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=oj2zs7YpNjut+Fle9NDI2/nVbuq1xcuWOh/20pAlrQ0=;
	b=easgEoOoHB+2SXPpOc1QLwPv9U3QgkyZpr2PIX352zgX/05a2FWRsuUXuBUw17ciboLN
	 G6a1bwezPiAvhdHhK0ey4NOLdYE8Ff2M3mRSqBhUNDqa8wA8/tSSb2mx4ey9lJhMNkqLq
	 WCcLz75dg4iDpl2LbIhNR9lclNTl2+1XnVn9wyJ8Y7nZJlBAdFmzDS3HQU/Mqkz315E/g
	 LnNPPcpBiylosesn6Kdae626FGyFrM3xoyq2+FGyemc2INA0YyGoJxgzR/E37zW9kP5Dj
	 YvYULrXqyCMmUp9FuG9F6QNv2AmfwXgRsW4tvw8iNKdd75YBrSwgaq5SoCuC6THH0PQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Ug8ie/o5";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 254C1606A338;
	Wed, 25 Nov 2026 15:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ug8ie/o5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8095C1F000D2;
	Wed, 25 Nov 2026 15:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795621667;
	bh=oj2zs7YpNjut+Fle9NDI2/nVbuq1xcuWOh/20pAlrQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ug8ie/o5G+4qOG/qUwTDD8Sh0KbsUP8Y25X2YGSUxV65bo3xOa2SraeOApc2YMpoe
	 TBOb1vbPXicGWcrMLsRJkLnwSzwn/zNNoZrquc3uXT+E/6wykyXEsdHdaIXhgkNF1e
	 eZPrp+hkLsijahVkZ+W+wliUq/Pjcd0k4hF1vHz9At8lU5qhtQ9q5AiYqquqwsujQx
	 3M8sfDzSOUInpu0Uf9dXaD9GmxI6sKjOxleCDSbL3q2kEIxD55e/FjJUklgv4eynVM
	 ANCrtnwEDlCZVGQET9wNflfxdEjySojGllGSthyu1Pg9mxLUj4FW329f8H5jOp2yBF
	 4pzzPPjWqJ/8Q==
From: netdev-bot+sinfo@kernel.org
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
 davem@davemloft.net, kuba@kernel.org, Eric Dumazet <edumazet@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: Re: [PATCH net v2] sctp: copy endpoint settings to accepted and
 peeled-off sockets
Date: Wed, 25 Nov 2026 15:47:46 +0000
Message-ID: <179562166605.3294.13036046575262313708@kernel.org>
In-Reply-To: =?utf-8?q?=3Cad53ffafc3285da03f3b6a888981a9b30f8c3ff2=2E1795621?=
 =?utf-8?q?528=2Egit=2Elucien=2Exin=40gmail=2Ecom=3E?=
References: =?utf-8?q?=3Cad53ffafc3285da03f3b6a888981a9b30f8c3ff2=2E17956215?=
 =?utf-8?q?28=2Egit=2Elucien=2Exin=40gmail=2Ecom=3E?=
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
