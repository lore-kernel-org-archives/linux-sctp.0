Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88323484243;
	Fri, 24 Jul 2026 23:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784937583; cv=none; b=blqFKUjzFz8TWgQ6MXqw3hNuNhgqS75BpHkGe9d8gR3Ynrg1rweCYz6cZH/XrpRVOceByScoyB9bFAtiNMjoxWFuiHa3OTH7zxW0wA7Jld4E391Mzhs18Qtk3G6jwxk4AZO5asb31o2VOHXptjcqMZ6dDzqO+BOGcn5rh9hXkZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784937583; c=relaxed/simple;
	bh=wHC1ldsrNkfapDk20vdeXeLt0/v6MTMD6tEy1BZYV7A=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bLanj3DLo3H9YaiscBK1CRi5jh+BEUXUn9oSiTgMuD7C7Hb5AeypUBMPtZ4dX157PWrApD/AqIntWVPrwGMUcfCcXy6DsP4ZvygyIxVVPtJ8OHpqdDZrYhp/JuBSROJAJn9nSvekw98TdRna0byaphXsXoQ/8On0TWei7Ppiix4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZQmZLomC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZQmZLomC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A2481F000E9;
	Fri, 24 Jul 2026 23:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784937581;
	bh=UbFgowPbazdNSotuwixcNtQVi/Kc+8tZrKv2YdXLOc4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ZQmZLomCh+9rG1lTUA8hn/qeSVdoZ39hcrWlM2e+lOE8wIhLbaCDTtHWmGhRfKHgm
	 +mmxNF0EiLpDcvzsL77UvcK2wRaYuMM6ZQMkd1g4Ud3H1Z5sEYT6elmtBv1pBJMbJ0
	 H/eG+tLPuKma0HUdVvsxwJbTOWKEV/u5Q/tKoPlKpRq/Fuh4rIwK+yaubQaUKUuZhv
	 FMZhYqz1FOQcboLU21Bq90IEMuigiFRiylb0Nbc1Ys9WY8O62dH8JSSktZ/HZtawox
	 7VN3saps8x4Bvrq//jCwFv5gGimAx4krKRefyJghTwlBSyAG4LKlVW5K67Ejdfd9Gk
	 p9t0bDj6J18lw==
Date: Fri, 24 Jul 2026 16:59:39 -0700
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
Subject: Re: [PATCH net-next v2] net: Replace %pK output with 0
Message-ID: <20260724165939.2d30f0d3@kernel.org>
In-Reply-To: <20260720144031.oU6azheV@linutronix.de>
References: <20260720144031.oU6azheV@linutronix.de>
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 20 Jul 2026 16:40:31 +0200 Sebastian Andrzej Siewior wrote:
> @@ -2209,7 +2209,7 @@ static void get_timewait6_sock(struct seq_file *seq,
>  
>  	seq_printf(seq,
>  		   "%4d: %08X%08X%08X%08X:%04X %08X%08X%08X%08X:%04X "
> -		   "%02X %08X:%08X %02X:%08lX %08X %5d %8d %d %d %pK\n",
> +		   "%02X %08X:%08X %02X:%08lX %08X %5d %8d %d %d\n",

You ate one here?

>  		   i,
>  		   src->s6_addr32[0], src->s6_addr32[1],
>  		   src->s6_addr32[2], src->s6_addr32[3], srcp,
> @@ -2217,7 +2217,7 @@ static void get_timewait6_sock(struct seq_file *seq,
>  		   dest->s6_addr32[2], dest->s6_addr32[3], destp,
>  		   READ_ONCE(tw->tw_substate), 0, 0,
>  		   3, jiffies_delta_to_clock_t(delta), 0, 0, 0, 0,
> -		   refcount_read(&tw->tw_refcnt), tw);
> +		   refcount_read(&tw->tw_refcnt));
