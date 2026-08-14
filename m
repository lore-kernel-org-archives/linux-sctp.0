Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 744F2381E98;
	Fri, 14 Aug 2026 14:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786716142; cv=none; b=dTUwYHH8WGvHHZJWocGc6oAz4jASwiBmniHBMHwS7CkDEZ0jWRSd874BWt9ZymrnDUltEXP0V0vbLVYF9swnok3D6oejaZ6T5DEfoepUEybimVaOdNf/Wf7DGMoF//a3t1oDFIKYFPEhihWDpmMdo58BNJUqGr8nPV3Eu5PnEWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786716142; c=relaxed/simple;
	bh=67r/AqcycdlDys69xSZ4xb9Ja9P0s0WOwGxcmYtAlW4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NW84525xXoC27XATSWVTXbO2eRKls740+R+Ezv5Gw82qOku0mR+uCGuVKM5JaRchoVNIf4ATeEqbIAXtpBPRo8UG5nrfJs2XeOPVkkiuQLtpDvF6/eDkoUmagQxKIt4VIX6Qa+rkP3DCt22B9Hudnh7/PSuOEATi3QBDzl0MoL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=r5n+KV2X; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=mQBc+/lZ; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="r5n+KV2X";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="mQBc+/lZ"
Date: Fri, 14 Aug 2026 16:02:15 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1786716136;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4Bvm8EgqIy6wMJqZSSvNDQXj5/Ed3LjcyKq5hAnk8AA=;
	b=r5n+KV2XiYnll9YkNCzSmGIWh4K8YLFMUzsyE/Ehy+L0cMXpL59F0aE89e2wEYeFcgAIg7
	N4jx0xad/8QrJuPIznLbcyRc93SIVS7LfRiMmPDXHnMFp4my1iDvOB6GTCiW76HwkMJqpf
	wAd8HKIPXftUXaQdo7k35YsQH2nerSt3twLW9P7zOR72e+aUGi0cGg+YWNgrEQoV9Frzbr
	XydA9PgvmKY2ZHUfdUqE37Da+LpZdpLGUVMLAbarRPWZ0I7ejLaBhVR+m791u+bsW+DXmi
	9Qn4dHRdp7g+pSfCLi4ejnFmcz794edCqgY1QP2z7G70voY5pM+KOryfC4ZJPw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1786716136;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4Bvm8EgqIy6wMJqZSSvNDQXj5/Ed3LjcyKq5hAnk8AA=;
	b=mQBc+/lZl7s1j9G4DnAv9OGwsnOYKGdaM+xF7DorWNlZQ/UtdekpIQl4/eszNeKelVYT92
	Ulbad86DEHq0H/DA==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Jakub Kicinski <kuba@kernel.org>
Cc: kees@kernel.org, linux-atm-general@lists.sourceforge.net,
	linux-can@vger.kernel.org, linux-sctp@vger.kernel.org,
	netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
	herbert@gondor.apana.org.au, kuniyu@google.com, mkl@pengutronix.de,
	marcelo.leitner@gmail.com, ncardwell@google.com,
	socketcan@hartkopp.net, pabeni@redhat.com, courmisch@gmail.com,
	horms@kernel.org, steffen.klassert@secunet.com,
	willemdebruijn.kernel@gmail.com, lucien.xin@gmail.com,
	pmladek@suse.com, thomas.weissschuh@linutronix.de
Subject: Re: [PATCH net-next v3] net: Replace %pK output with 0
Message-ID: <20260814140215.jJ71m_Pw@linutronix.de>
References: <20260812110531.ITPqiY2O@linutronix.de>
 <20260814015800.2837019-2-kuba@kernel.org>
 <20260814105812.mwsdgu5m@linutronix.de>
 <20260814065542.64696672@kernel.org>
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260814065542.64696672@kernel.org>

On 2026-08-14 06:55:42 [-0700], Jakub Kicinski wrote:
> Not my expertise, TBH, I'd err on the side of caution since these are
> security/hardening measures. IDK how much this all matters, or if
> anyone uses !kallsym. 
> 
> Note that any rework has a solid chance of missing 7.3.
> 
> It should be most expedient to take the controversial part out and
> repost. Or we can ask Kees for a recommendation?

I dropped the can bits in the meantime since Oliver posted his rework
already. So I would repost it if it is okay. If you say it will miss
7.3 anyway then can of course wait until net-next opens again.

Sebastian
