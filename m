Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792430919;
	b=a0w2lzFn5DzCFOCqYE1/8dpAz7PAsAB2xzAkiAhC+Cy3itO0IigbADTBNGO7+4Kvwh4I
	 EnagcQA8xpjGDlb/zlGuqVBqc1s91EwP8WrNZRV76wbgRplUlcWB9Y9Pv1lK/Kx1u1dNN
	 1m4jSi+tv1J5dR2ynsXoO7sn1+CXGlylUJDyqo0STcV1TRFGzVRrkxMJusyChAtIU4VEf
	 oEz0l/QEX2exxAeZA19Aby9IL8bMXrUu+dvWZkTkA93hJmmX6FSby+Z+E9SfuGRmlYUIl
	 2wK7tNfK3WDWWAf9aTwBpmp4H5JEolv0YI+XRHuRM1wXvSINnjOI1ca6CDf764wE4wg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792430919;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=chIHKvbVEbhi7HTR+gPAb0jDIEI9Uj7AOMpnMg1T2wM=;
	b=CaWlP6TrggDxHs+61RkPjrNzAgVleQAXohi5QeNnmPjyMDgka9gkzTdjrL3BSoRXebeC
	 rnCMYwZmX8FRZE3DknV03Vi1BAi4qq70I5AW9u9tT3/ipLsuii1bwvin2o/+Xl1Se4rwV
	 VqXglrQ5yIz6rvVHoi/4IDTRisxUzWLXW+ZbkSehYWylW+k8mgaFEHUGTS4zKrUZo8Uvv
	 pWJ88jtE6V6kgZyMNO6GTgo1N5HDuHuNU/JBrV8AYYJX+X3zl2+wQIUd0IFckhHAXpqaK
	 rTXaxrYevkqSYPeZA3OOnP1jyDvqM1BG2FSqpG3zgc8UsICtB6VNWi0+3cL+LTUW9lA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YqH87YJQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9B09606A319;
	Mon, 19 Oct 2026 17:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YqH87YJQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5438D1F000C4;
	Mon, 19 Oct 2026 17:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792430918;
	bh=chIHKvbVEbhi7HTR+gPAb0jDIEI9Uj7AOMpnMg1T2wM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YqH87YJQpZ5IkgPFuqlTY2et4g0VSwoMxtSgQuLdq4spZiTR2HRq/t2r7SKyKOnn8
	 S06MwrqG492Ipe59HiuFVYjcsaaA/rP1F4CijZ0+HdbtHaU13dAVpqFbHybGq5J7D2
	 xhIU51zhvWTtbDyZidINTtRMtPuvw8y7XmQoY7Whs7agc88+KfX/G4iINUP6LAupAx
	 B+sg++ZDAgfeXf8MLzWL2NAz98SQDZHd4AsCBd4deYdBgCkaOYq6awR/BlPlLljMQB
	 IxaHNlZjiGZw2/jxYchYgB4ZB+Pd5n+G8FqgKtwz4u2p7i5LNbCOaQTo77ljuTgX/x
	 BFFyncy1Kf1lg==
Date: Mon, 19 Oct 2026 10:28:36 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, stable@vger.kernel.org,
	Qing Luo <luoqing@kylinos.cn>, Xin Long <lucien.xin@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>, marcelo.leitner@gmail.com,
	davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org,
	linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.18-5.10] sctp: auth: propagate HMAC calculation
 errors to callers
Message-ID: <20261019172836.GA1885@quark>
References: <20261019135441.1420968-1-sashal@kernel.org>
 <20261019135441.1420968-252-sashal@kernel.org>
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Post: <mailto:linux-sctp@vger.kernel.org>
List-Help: <mailto:linux-sctp+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sctp+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261019135441.1420968-252-sashal@kernel.org>

On Mon, Oct 19, 2026 at 09:49:03AM -0400, Sasha Levin wrote:
> - Residual in this tree: `crypto_shash_setkey()` failure still `goto
>   free` without an error (mainline HMAC helpers no longer have that
>   path). That is preexisting and outside this commit.

I don't think this backport can be considered complete without handling
that case.

- Eric
