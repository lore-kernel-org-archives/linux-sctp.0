Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6340E339872;
	Fri, 14 Aug 2026 13:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786715748; cv=none; b=MyFwaDA8jT63ECBCxEI65h9loVZQBatRf5ZqAyuBdD5kjQ7nuR14heZ2aZFlipehQR2En6bTAGEum5g0QEVDzi8IIvuDUq95YBlE+3/eRZfagsX5JPvzek7SisffnsHXT1Xq9i0DUrAtYj4HoyPjpnQr7BB4exy1D0qfh9162x0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786715748; c=relaxed/simple;
	bh=U3lcz08uC2WsdjDvSvMxjlIjJL+1C671zA7wboh6RVI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EzX9PSbnYzniV9k0j3qA+zKNKv/5f5igGoB1x/KK/FNWDFFquh2H4mqYAdAupTlSfmsJuFg3AUYtxZrRny91NQgeS3iwFEfwXdwYPriiGybVlRq+1Oa3di9OeVXaLlLGLmDe0zsRXD7/n9+ufy/fajl6JiCfuTAh0177RLg/Gy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ebpuNp4A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ebpuNp4A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C78F11F000E9;
	Fri, 14 Aug 2026 13:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786715743;
	bh=vbORsfkwDlwoveKPSqiO1X/rR7z+fG2mgY8O20bprJI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ebpuNp4AaqqZ0N9fWIUoKqryOLMrIqxhWzjQXReTDO5WR9jL0wmFo6+PKruC6awSu
	 LA6B6U7nmD4zqfvFitt60d7cSPMS7NvOpRmNv1tepnS8hzCHo2uzJCLw9Ctx8Oj1Z1
	 wpdsW//ywag4Iw3WH5hoNIENbOtUeI9uuViZVU0GTIsd3ZZtSJPo6hmWvbD4wOsb06
	 GZoMjF1X/cRptbVQUIhHTXm7QTopabSel3FB5hPbskPLdBVnhJ/733SihT/B9u0uzC
	 iigEGqnpSoyDIV1cNyr9DwCumxkD5BnzMAIZvIl0rtCaesttMn38oADXvq01Z5mYgH
	 yjAMpIufmO40w==
Date: Fri, 14 Aug 2026 06:55:42 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>, kees@kernel.org
Cc: linux-atm-general@lists.sourceforge.net, linux-can@vger.kernel.org,
 linux-sctp@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
 edumazet@google.com, herbert@gondor.apana.org.au, kuniyu@google.com,
 mkl@pengutronix.de, marcelo.leitner@gmail.com, ncardwell@google.com,
 socketcan@hartkopp.net, pabeni@redhat.com, courmisch@gmail.com,
 horms@kernel.org, steffen.klassert@secunet.com,
 willemdebruijn.kernel@gmail.com, lucien.xin@gmail.com, pmladek@suse.com,
 thomas.weissschuh@linutronix.de
Subject: Re: [PATCH net-next v3] net: Replace %pK output with 0
Message-ID: <20260814065542.64696672@kernel.org>
In-Reply-To: <20260814105812.mwsdgu5m@linutronix.de>
References: <20260812110531.ITPqiY2O@linutronix.de>
	<20260814015800.2837019-2-kuba@kernel.org>
	<20260814105812.mwsdgu5m@linutronix.de>
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 14 Aug 2026 12:58:12 +0200 Sebastian Andrzej Siewior wrote:
> > We have upgraded the slop...itifier since v2, it has more comments now...
> > The one about %ps potentially leaking more rather than less looks legit?  
> 
> It complains about %ps leaking the pointer if kallsym is switched off.
> This isn't unique to can and I pointed this out to Kees. 
> Oliver Hartkopp mentioned that he wanted to rework the can output.
> 
> I'm going to tell vsprintf to route the %ps output the same as %p for
> !kallsym so this goes away. 
> 
> Depending on what you prefer we can keep it as it or I drop the can bits
> and repost everything else as-it. And then address later the other
> sashiko bits where the documentation mentions "location of socket in
> memory".

Not my expertise, TBH, I'd err on the side of caution since these are
security/hardening measures. IDK how much this all matters, or if
anyone uses !kallsym. 

Note that any rework has a solid chance of missing 7.3.

It should be most expedient to take the controversial part out and
repost. Or we can ask Kees for a recommendation?
