Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0E7B42E8C2;
	Fri, 14 Aug 2026 10:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786705112; cv=none; b=QHmFzn1ov2GV1y2NWtVZgeC0NTMxl5ysY5Hkz1Ye3acepu7dexBFO3iGCTzztWyM8H7ucKa7hVQKof4MPbkPm6+ETcTcGSCL7D6Nz+3akczvkEswM7iualM/LUYcY2oYIqa30TKbU12GYWQIxDJ+IwKlsqB8VKoNIIkNV7kPvEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786705112; c=relaxed/simple;
	bh=BdxzVRD/tDun2kP6MUbSQj3CDSwRIZo56NRnuBBaiyk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aOS5bxkdPurNvxovmNKZF+OIRUH0DPrxbng2Sp0Winf6XMk5woaRuqBbVJJ3m/EolRgdfB9ffSGAnNLld0h8jKrLNPT3p/XijNVxuJjPyflSYg9q2fNImoxtrwb67uU9hJIbCfdOA2+VSnXjvo9Uoiw5W2Vq4J1b28f8pQKiZSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=JCx409qU; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=E+NDhCHA; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="JCx409qU";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="E+NDhCHA"
Date: Fri, 14 Aug 2026 12:58:12 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1786705094;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=atGYebWIHE6oJfRsylhUJ221uYmQeT6OPEvxObbJ4Js=;
	b=JCx409qUc4TZnP4BifPsWHonw8TCRztTWKPkWLOr5ccLtxePdpKOaPqQqbx4cnYeUjj68x
	94NJCjE9PTI4EHdCqac6mbUSXkFs96JsXc3j0gIipW7wx5NntG2HEsluK0ZL3V2ppQv8Pm
	LFgAzClqgxMDgHtXZGSxlbAP6at9iNGkZINXnKmj8L2lTU7sch42Hzgm2eIp3q4MpoYU3C
	V4fAOBbUES4eIkVyRvxKV/AEgb0IhOjoYXlvbDWA2JlsD2K3PudbmIuB+/EdC6iA/3RR44
	rrMzrppWIc3TuyQTjYj6e3bFXSVOmjyS+3VQgV1Bs09FOb2wGTkxJESMthfDjQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1786705094;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=atGYebWIHE6oJfRsylhUJ221uYmQeT6OPEvxObbJ4Js=;
	b=E+NDhCHAQaah8KQpLl8NuiSMsidjr65Y2S44xwHVtztR3fKFEBnaXvpY0BAJaxXn/RbsAk
	65xzPTmd7vEHSCCg==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Jakub Kicinski <kuba@kernel.org>
Cc: linux-atm-general@lists.sourceforge.net, linux-can@vger.kernel.org,
	linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
	davem@davemloft.net, edumazet@google.com,
	herbert@gondor.apana.org.au, kuniyu@google.com, mkl@pengutronix.de,
	marcelo.leitner@gmail.com, ncardwell@google.com,
	socketcan@hartkopp.net, pabeni@redhat.com, courmisch@gmail.com,
	horms@kernel.org, steffen.klassert@secunet.com,
	willemdebruijn.kernel@gmail.com, lucien.xin@gmail.com,
	pmladek@suse.com, thomas.weissschuh@linutronix.de, kees@kernel.org
Subject: Re: [PATCH net-next v3] net: Replace %pK output with 0
Message-ID: <20260814105812.mwsdgu5m@linutronix.de>
References: <20260812110531.ITPqiY2O@linutronix.de>
 <20260814015800.2837019-2-kuba@kernel.org>
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260814015800.2837019-2-kuba@kernel.org>

On 2026-08-13 18:58:01 [-0700], Jakub Kicinski wrote:
> Hi Sebastian!
Hi Jakub,

> We have upgraded the slop...itifier since v2, it has more comments now...
> The one about %ps potentially leaking more rather than less looks legit?

It complains about %ps leaking the pointer if kallsym is switched off.
This isn't unique to can and I pointed this out to Kees. 
Oliver Hartkopp mentioned that he wanted to rework the can output.

I'm going to tell vsprintf to route the %ps output the same as %p for
!kallsym so this goes away. 

Depending on what you prefer we can keep it as it or I drop the can bits
and repost everything else as-it. And then address later the other
sashiko bits where the documentation mentions "location of socket in
memory".

Sebastian
