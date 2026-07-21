Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 045723E95A0;
	Tue, 21 Jul 2026 00:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784594369; cv=none; b=HI1bp9J225U4wMWuJoNkCPAYP7rpiIAR4O+c5KGnvkhqrCtn6SCgqJpfGvz2EKOJEuhPC3RHyrrkKBa32Tp9ZCYZOn/35buys2k/2XwPSf3j9Qwh72h5wwUrbgXSutpSG/be5vY1Kt6E16poaSmm3pBKbLuXBYhoTMLdQNhWCms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784594369; c=relaxed/simple;
	bh=xplnZIzfishlzyA4FPPfaGsQ4wjjS1a8iBqmxxR5QUI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BtBhNSlpDqv2r43IUrkqVlv/wZsiQ+jvGm/ZNlk8AxHV3J1HdI7Fjh0EF4OUo3pJQCEO7EmZ9ktr5zsiehmMW9+VxeLrVwuTzCh+NRuMeCUkwg222p4zGJjzAnouipPft7tjPThWDpS0XOqq/10Yh8Pl1qV+NLm421lAbC5QIvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HTED1Rah; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HTED1Rah"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 028B61F000E9;
	Tue, 21 Jul 2026 00:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784594368;
	bh=xplnZIzfishlzyA4FPPfaGsQ4wjjS1a8iBqmxxR5QUI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=HTED1RahDd2rGHu8Umo4BDRbQHQhJJ/1I/++kispKdTlq8QR3nhSd3ja2zvu1830Q
	 yi7GnqqT5T9TLSK/tD3JsBk89uBArIbG1B/FtIpZ2VTnbP9Lnw+voK9zEyXESAq78A
	 0vhcp80dPjPczWDYiA9nbGYvd4BCsPtrYdtotMBS9XqAVYlYP2vL06ulEngTCm9nX/
	 hhX61X4eD33Juoec29/1EAS8sORibScnQt1ANimLLE7sN+bKFdbh/oMRIYa+kC6Sne
	 hSV6MpAJo+lMshxow/o9FoUmuJZpm2HeoxR50AjnsfPp5CWPfCORbxnUNo/84RvI6K
	 3/5x9IkNfUUKA==
Date: Mon, 20 Jul 2026 17:39:26 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-atm-general@lists.sourceforge.net, linux-can@vger.kernel.org,
 linux-sctp@vger.kernel.org, netdev@vger.kernel.org, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Herbert Xu
 <herbert@gondor.apana.org.au>, Kuniyuki Iwashima <kuniyu@google.com>, Marc
 Kleine-Budde <mkl@pengutronix.de>, Marcelo Ricardo Leitner
 <marcelo.leitner@gmail.com>, Neal Cardwell <ncardwell@google.com>, Oliver
 Hartkopp <socketcan@hartkopp.net>, Paolo Abeni <pabeni@redhat.com>, Remi
 Denis-Courmont <courmisch@gmail.com>, Simon Horman <horms@kernel.org>,
 Steffen Klassert <steffen.klassert@secunet.com>, Willem de Bruijn
 <willemdebruijn.kernel@gmail.com>, Xin Long <lucien.xin@gmail.com>, Petr
 Mladek <pmladek@suse.com>, Thomas =?UTF-8?B?V2Vpw59zY2h1aA==?=
 <thomas.weissschuh@linutronix.de>, Kees Cook <kees@kernel.org>
Subject: Re: [PATCH net-next] net: Convert %pK back to %p
Message-ID: <20260720173926.766b2ddd@kernel.org>
In-Reply-To: <20260706073824.xixrLxoD@linutronix.de>
References: <20260706073824.xixrLxoD@linutronix.de>
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 6 Jul 2026 09:38:24 +0200 Sebastian Andrzej Siewior wrote:
> This is a revert of commit 71338aa7d050c ("net: convert %p usage to
> %pK") which is from 2011. Back then the default behaviour for %p was to
> print the pointer. The %pK modifier was introduced to be able to control
> the behaviour of specific pointer output without changing the behaviour
> of %p for everyone. It was dedicated to avoid leaking pointers via
> /proc.
> There was also the idea to remove the check from formatting the string
> and move to the open callback (of the /proc file) with some helpers but
> this did not happen.

The netdev patch queue has overflown.
If these patches are still relevant you'll have to repost them.
