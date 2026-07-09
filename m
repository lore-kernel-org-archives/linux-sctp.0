Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB8B24252C6;
	Thu,  9 Jul 2026 16:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783613933; cv=none; b=Hs2eJZk14O2ZBbJhHUGwf/tp9yKoQhrPNBDnOoojIpfWf+FdHZ4UeTNRRFI+bF6M39Yw8EXRpo9X/X0tU/XEv927GHfPpd4L2gCKInJQyOinTGRv/vUUBEVc9s89+xee3tEBfEWq74GVP43fIWfX4Ra6W9EGhs+qRPxtemwFCTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783613933; c=relaxed/simple;
	bh=AsailK8F37XDf6dcGFjdUTsjDgb9MVOWzdP5r9LYmHM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U64rbnHJkGop/QEbzpfTjcfLIdf9NF/zD9OQwOqcbjUhmi0+M43xsNlGt+o9n0fqinsy+LicStJj4/hXu33Ut041iHa72mIDx48IXMWH/sBQA24vxI7xW1JBOi0y9AbjG0egH38p+AkS6XgTRtPwPSC/ZdIBTS7jPPYCiSnhstY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ReI3OB5Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ReI3OB5Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C91221F000E9;
	Thu,  9 Jul 2026 16:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783613924;
	bh=+c800ITVYyf0HQortvRIAgN2/p9RkJsrk68oS9gg2HE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ReI3OB5YQQMOrVPAHVH9nU9vT0kJx40oXUtXWU3yZRmSuSycR8b2uG9TiG58WMMb3
	 pRz2BDgimBsUcM0L+vlcMoxQYENYIYCjYo7XhvIRSPYMHHiutilz6dOFm2v3vkNO/B
	 syFeuOgoboklXNnQpz6GUaeCi3fbiDJiLJqqseX9TeNfB8Bq7R9XO9GAOnd4PiXjbz
	 8Rqur66twNmP535APYhnaDdaLTTn6WyKDzhIV0uXSF1+f4z5P6hDdO5N+ByN/EUukL
	 yDEqM+A8xapUb0F419oNc3kWJ4+3klSi6S+R6mv7ADyE5koVq1qKXPHdfH3gYamWMC
	 Z46muTatq1BDA==
Date: Thu, 9 Jul 2026 09:18:44 -0700
From: Kees Cook <kees@kernel.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-atm-general@lists.sourceforge.net, linux-can@vger.kernel.org,
	linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jakub Kicinski <kuba@kernel.org>,
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
	Thomas =?iso-8859-1?Q?Wei=DFschuh?= <thomas.weissschuh@linutronix.de>
Subject: Re: [PATCH net-next] net: Convert %pK back to %p
Message-ID: <202607090916.7731D36D@keescook>
References: <20260706073824.xixrLxoD@linutronix.de>
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260706073824.xixrLxoD@linutronix.de>

On Mon, Jul 06, 2026 at 09:38:24AM +0200, Sebastian Andrzej Siewior wrote:
> This is a revert of commit 71338aa7d050c ("net: convert %p usage to
> %pK") which is from 2011. Back then the default behaviour for %p was to
> print the pointer. The %pK modifier was introduced to be able to control
> the behaviour of specific pointer output without changing the behaviour
> of %p for everyone. It was dedicated to avoid leaking pointers via
> /proc.

Given the policy on bare %p, and that there are so few in this list (15
files), how about review those that can just simply be removed or
switched to %pS, etc:
https://docs.kernel.org/process/deprecated.html#p-format-specifier

-- 
Kees Cook
