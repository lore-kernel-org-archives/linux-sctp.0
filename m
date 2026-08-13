Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D06F380FEC;
	Thu, 13 Aug 2026 16:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786639784; cv=none; b=rPCxg2dr8kkUGZDLzOBxEBEY+/iRx3IviwGaPx8+Hnfmtd2gSxhDiabFyYWQ85fCtpE9lFMyVAt6okU2m/oQzpshOwYv/lWJ3cgdHkSzFRjUarzigBYDkfbTBkVm/+T7cL060evXxWaIDfCOdDcN8NNR6wumNYQCveZSgME68oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786639784; c=relaxed/simple;
	bh=lBoN8LZr7USo6wsCmncxwNdxRlJ/IqqsuOKtiqx1pQQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AjJOVkertuBgxOb6pLSPK2c1YtRJC6ttecTaCVnVX9CE6w3t96uByDcILWaXV/e3Y8djrqrH5gVF98Z3Ly2rNRkX7G5sTmyaRkUslfn9qrjxUWRR6mOiC9qmD83ezbgqstXmyshRtWL66Ed2Xnug6J5RI1DKJGH7c4T+1PSt/CQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GRSGVXHq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GRSGVXHq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51AAA1F000E9;
	Thu, 13 Aug 2026 16:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786639783;
	bh=2i7/Mi/2ScY3ECi/mayRtWV4BESZL62I9XwQ0I+ivFg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GRSGVXHqds/t3EhBOJk6qaNKzeiOgS4+50Q2tm6ausN88Q5l6JmJ7qyAYfu7opuvA
	 QCwhzeabiExWNdVPr95cnbtf8HyuH9GlZ7Mgktht4xegPAfpKNxZ9RL8NS6lKvS5vB
	 6VohVgOAYAUe9aHz6vw9Lec8CUjYgyD7a5NNCCUZ+d7/FVh7UJTeTqzTOUPjF09oru
	 pn0k2QbODcF116bXa2WAylIZXs8m9/sCvXa6TkDJZVKA9YUViTRO/2Hro7q+Zcph3P
	 Jz8EBoAbApB/htOdjUVfzD7x9g8VrvgXfDqpi615fIREhV2MzRuhqCaOg9fUjbvg0q
	 eMkVXCAqv9vVw==
Date: Thu, 13 Aug 2026 09:49:43 -0700
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
Subject: Re: [PATCH net-next v3] net: Replace %pK output with 0
Message-ID: <202608130949.A391CBF6@keescook>
References: <20260812110531.ITPqiY2O@linutronix.de>
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260812110531.ITPqiY2O@linutronix.de>

On Wed, Aug 12, 2026 at 01:05:31PM +0200, Sebastian Andrzej Siewior wrote:
> Commit 71338aa7d050c ("net: convert %p usage to %pK") which is from
> 2011 and changed the %p annotation for pointer to %pK. Back then the
> default behaviour for %p was to print the pointer. The %pK modifier was
> introduced to able to control the behaviour of specific pointer values
> without changing the behaviour of %p for everyone. It was dedicated to
> avoid leaking pointers via /proc.
> 
> There was also the idea to remove the check from formatting the string
> and move to the open callback with some helpers but this did not happen.
> 
> Things changed over time. The default behaviour for %p is now to print a
> hash pointer which does not leak the address but allows to correlate if
> two pointers are equal.
> The policy on %p is to not introduce new ones. This is somehow in
> between since it already exists. The pointer are usually socket pointers
> and I don't see any value in exposing them. Therefore I am following the
> recommendation of removing them. Since their usage in /proc/ can be
> considered ABI I replace the pointer with a 0.
> 
> Replace the %pK annotation with 0 value. Correct the spacing for the
> cases where pointer is at the beginning. Use %ps in CAN where the read
> callback is used.
> 
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

I love this kind of replacement. :)

Reviewed-by: Kees Cook <kees@kernel.org>

-- 
Kees Cook
