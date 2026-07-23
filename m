Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D67F34029E;
	Thu, 23 Jul 2026 14:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784816914; cv=none; b=aqCEQ5XCHaAxHhJRCTGWGTk2tdMLYJG0RYnHeFWXPwJkAEMwmARjhHxz27+huwyGa/9oLkQB0yHdRNOky11m1QTT58ChxXk2vMWMivTXaCLz/CyhROpV1kfUcu3ivrYJX+CfOj3MRRAzw1HpT1pfniUHemIjXELY3IJfmJ45URU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784816914; c=relaxed/simple;
	bh=9oI249Oa0/m+oXKarquT5wvENouAVSdsO+6TQs6Qm7g=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GYCzziAlby/Eb3/fXNUtcrTPxfY/IiWDAi8ighnrASH+k2j5HHN8HYqlbz2ol2ViECNpg/trtEABzZ6TvHxjmaj0RCYUs32/2WpdmDdbodw8asnvn6lQwHjLaRhcuMZ00u0N6erg99a2CBcU2UDcGW5PCIM3KlA3xkCM9XU/mj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E75851F000E9;
	Thu, 23 Jul 2026 14:28:32 +0000 (UTC)
Date: Thu, 23 Jul 2026 07:28:32 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Jason Xing <kerneljasonxing@gmail.com>
Cc: =?UTF-8?B?5pyx6ZuA6JOd5YabQUlHQm906YKu566x?= <aigbot@tencent.com>,
 netdev@vger.kernel.org, Marcelo Ricardo Leitner
 <marcelo.leitner@gmail.com>, Xin Long <lucien.xin@gmail.com>, "David S .
 Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Paolo
 Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org, Jun Yang
 <junvyyang@tencent.com>, stable@kernel.org
Subject: Re: [PATCH] sctp: don't free the ASCONF's own transport in DEL-IP
 processing
Message-ID: <20260723072832.2ea0969d@kernel.org>
In-Reply-To: <CAL+tcoD_BH0xhyAJ1p=TcX8KW8_heVjN8wHeVwWzkMKS4MMgNA@mail.gmail.com>
References: <80818E6580896D22+20260716091212.43126-1-junvyyang@tencent.com>
	<CAL+tcoD_BH0xhyAJ1p=TcX8KW8_heVjN8wHeVwWzkMKS4MMgNA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 16 Jul 2026 13:12:10 +0200 Jason Xing wrote:
> > Fixes: 42e30bf3463c ("[SCTP]: Handle the wildcard ADD-IP Address parameter")
> > Cc: stable@kernel.org
> > Signed-off-by: Jun Yang <junvyyang@tencent.com>
> > Acked-by: Xin Long <lucien.xin@gmail.com>  
> 
> It should explicitly target the net branch?

Jason, per netdev docs we discourage such trivial process complaints.
