Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0FA036A02E;
	Tue, 21 Jul 2026 06:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784614834; cv=none; b=hq2EFiAyPNpAg7jnu9Bdz1GjNSdg/kfvvpCXlWqyyMbZRt7PxhcXaANtTT5WJN8frWcC7A4o6y1MfDXe8H6+v0I0SrMqhDEfZysy/gLLW/ZHE8LzIIhK7tHAABu9x6LEirlhB97MkB19FW/JEsCbxAcUZWh6Q7DrCINwKYlpVg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784614834; c=relaxed/simple;
	bh=xnF9ym18mcoLVQSQ7HIU1OgRduSlc3+jkVUInTCbCo0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L0UmlbrkEXPKyofK1kUF6F427KQt2NFU6Fo/7qPCwft07burxFewihbOgQQxIqM62yy8TaMV0cGUSe2xFJSdRi78mnyxDeOAZn9LzzwXbDZ6bHgoN0eKlT/086GgVNuZcSxekfEUmK1Zn8PVoLnzrXcRS0XsYz5HZOFhWTDyHoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=B/A8iOwN; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=LywDI5XV; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="B/A8iOwN";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="LywDI5XV"
Date: Tue, 21 Jul 2026 08:20:28 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1784614830;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LkxIZgS1JjTsoFLGyjCJfnYDdXx3i0clAMZf3S8e5N8=;
	b=B/A8iOwNrjEaPUHISxKTwcZO6Suxie+sjjXZRd3zqQc9ZaYI2kvFWpQVbm6PqIxzPcwj4Y
	vLDj+/vMkDxhxVCmdLUch58YOHWW9bi4rVH0BjrU6RTyx3WY8jooLBOYAwQhyP6ojNBBJn
	nq/0dtGnhZKy5iYBNhQragwdmIq+4zzKm5ORCJQX1j7nFZzoPBbfXeQjYADSzRlqaQGXk8
	x2nbHms1xQVubaOT01PhryFDp35IFyvFDJYu53hWmoG+53GwPPLLEnE90JrrZlPMbT/Xt+
	w5x9ldUdLfgzXXwa2MojYZAKlzkb7XkaL8WJ2IoAwlx7SRv6olmtdnZhT2o12g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1784614830;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LkxIZgS1JjTsoFLGyjCJfnYDdXx3i0clAMZf3S8e5N8=;
	b=LywDI5XVXa6Vb3QSWlyGfmMNUms8tjMN6wPvJtCZVlG9fMTZfRSnLdCfS8qp71z0Jvwwit
	ZHKazPx+vJblEHCA==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Jakub Kicinski <kuba@kernel.org>
Cc: linux-atm-general@lists.sourceforge.net, linux-can@vger.kernel.org,
	linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Neal Cardwell <ncardwell@google.com>,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Paolo Abeni <pabeni@redhat.com>,
	Remi Denis-Courmont <courmisch@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	Xin Long <lucien.xin@gmail.com>, Petr Mladek <pmladek@suse.com>,
	Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Kees Cook <kees@kernel.org>
Subject: Re: [PATCH net-next] net: Convert %pK back to %p
Message-ID: <20260721062028.pUFnC1Ei@linutronix.de>
References: <20260706073824.xixrLxoD@linutronix.de>
 <20260720173926.766b2ddd@kernel.org>
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260720173926.766b2ddd@kernel.org>

On 2026-07-20 17:39:26 [-0700], Jakub Kicinski wrote:
> The netdev patch queue has overflown.
> If these patches are still relevant you'll have to repost them.

There was no other feedback and I posted an updated version based on
Kees' suggestion (yesterday).
	https://lore.kernel.org/all/20260720144031.oU6azheV@linutronix.de/

Sebastian
