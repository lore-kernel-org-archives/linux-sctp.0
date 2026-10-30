Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793334612;
	b=quGcGUSMXveGhQ6s8QDeFTsUHz7cA6zL9yeIRa8QG761L89umwstSI71pJOJtv+5wkUl
	 PzoqPxNDawbgw6jqSL51rX6/nB3XVpJ2PBhW1ipFo4U1s665hyAIxTJJn9pOQ+ukRnBeq
	 wf49gnnOjLGs7XcsDazUE0kalDhXIGQkAoObmxTKhnkFIOHeFG+w38aoeU4BXjEtIGt9E
	 jrXMKKjI4fWLQe0oKE63pWc4J/7GYsn0PfWj1+ppFfSeNd4Xhd/3QpJyoj+Iv+vvfT3ie
	 NtM84n1EuRHhD3gTmTIRZRnVjFh9ex+V1I2f2BavPTxPjmlANhfs2MxmImoYI3J00tg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793334612;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:Auto-Submitted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=PJRu7W6/Or1we5Gv3BgoLEtby0D0Y0UGgfjBHfRc5+k=;
	b=UZir8dfWZCOHJA6DwJucR/HEDVzDOQIWr1eM1F/OTK8VmSu5gYurPDyw5jfbmBSmoc55
	 huDlhp25jNDUmCoDqmLievHdzx9dian2iFg9/+9sr/jcoeqSBoLVb/amqO0QwVjH7Z/c6
	 GzRPsfOKovG+JTfistWk68sZU9fc6CwCPPvo0pqPqcgdbZLuNYOA0GFhbCSBUhc3tjII/
	 LgMg8X707DJ5hOMboy2X8oahO/s8lDUmfEHP8iLRtE+vKYuJSdN0nQdv6TdhzVUcSkCNX
	 0NnPyiOdBWfap72c/GsTlSW9kmWC60gNgQXlsHRk5voXISdInZMNpOYhwlGHMeaBrZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XCHhO0zO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68091606A321;
	Fri, 30 Oct 2026 04:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XCHhO0zO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE6E21F00A02;
	Fri, 30 Oct 2026 04:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793334612;
	bh=PJRu7W6/Or1we5Gv3BgoLEtby0D0Y0UGgfjBHfRc5+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XCHhO0zOHVN4z+PCznEAdN0ppbn2CGuyLn0bHOM9//ksWigleJ0w+V0X2mtM4XY8C
	 +Xkb4njGyNnlA9OpmTkfvPH5gC7vy3BMNAmNRQfx8a8vgm8d+niYGznM1dPDmpzTHS
	 KdOmHSrgfDpJwT7GK02ufIk+niYngLNR7pOllyW6tmETZTVBf/U//7IfuxRvcP+vbC
	 w6SHXjKoEfX8fhQqGx/GW2+cWGicb+JyQWN3IjFozuXrhfsq3CVDiWR9sng+O9LBUo
	 hCLu7mioJqR/ioffNNrAB5NXC2ilorrL+c1YRyDWGxMNYhrTvXgf4NM7ucLpWJCMgZ
	 GaHWyu1MP6Pww==
From: netdev-bot+sinfo@kernel.org
To: Kyle Zeng <kylebot@openai.com>
Cc: linux-sctp@vger.kernel.org,
 Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
 Xin Long <lucien.xin@gmail.com>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, outbounddisclosures@openai.com
Subject: Re: [PATCH] sctp: avoid requeueing pending control chunks
Date: Fri, 30 Oct 2026 04:30:11 +0000
Message-ID: <179333461128.3327.12481045034504784232@kernel.org>
In-Reply-To: <20261030042321.74407-1-kylebot@openai.com>
References: <20261030042321.74407-1-kylebot@openai.com>
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
