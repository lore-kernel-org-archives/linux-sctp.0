Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E97A41DDE3;
	Tue,  1 Sep 2026 16:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788278465; cv=none; b=IBdTYne7QcS0CaSM7sbR78lXPDMuDAbT1tI0enEc5egSZcygToKf4YEvfuw0OZvG/GtxLJBwTtPfYpowi+DFXYYXkSKH9AKVbDP+2nAtwXdoneKHNm8N6GCKD3MGPCi4ToNF+HrF76mqg8V15CvyUVFPvOHZ7GsOywUiNOnUqa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788278465; c=relaxed/simple;
	bh=23IX0L/IYlRtvlF8jKzUBJ1l6aTsu1TIgr+UqcEB2sA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dDPrG7x5y9BsVp1/RqHSwIpnP3kOe/7RwNSvaQY43gk956ccOVrQ9mnJuBv8PRoY+fQu5n7+P4UyMzepLHlNPry5OlxTOa1uMoUcdSwDKEJh+mimMf1Xj9Mf7QPTxZSQJNrILKxd04oVo0Y/2zbSdvRNc85mjGMIWbY6bvpXVBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=lTDxnXxh; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=LztLxJnU; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="lTDxnXxh";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="LztLxJnU"
Date: Tue, 1 Sep 2026 18:01:00 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1788278461;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kVbZaHZB2UoG7nxTrsvCQq3Yn4HBjnRnCLNdDUnj4As=;
	b=lTDxnXxhlhwbcgcIcDbRw2LGt2y2H+vVhAgVPR6Fmpfiyf2Ax2arNgQcIQBJeco2MvtN5R
	16NDw+MdFPqG7iGN36cHBNCOeKqivM1frIE4883jI1KynKoQB7lQyvyI5B8Xu6OreX4YGK
	AlXjDIOpAhgU7oVbn51RmU9RsxiGo+xCn/GDkx4Lbhdnm2TH4xSebEgRwuBEgv9UPI489l
	6V4SOrp3LpctmVyePvqmXFDB/0SyL9K5onCbgJoxlHTUmQW68y79jdV1c8aUMvw2gbEOIf
	2ji73oAXi0z8p2FUXo1kqW80QALU/dWEvJZhnZsVCVq2OFcuAE/QrYwKus4VKA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1788278461;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kVbZaHZB2UoG7nxTrsvCQq3Yn4HBjnRnCLNdDUnj4As=;
	b=LztLxJnUMSmoTI1m+GOzgcR4o453Iz+FRfzrLecpbxx3cKPdb/Kqwtm2PNuqt21iEtfor2
	4ZgaEMhdFi7PodBg==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Oliver Hartkopp <socketcan@hartkopp.net>
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
	Paolo Abeni <pabeni@redhat.com>,
	Remi Denis-Courmont <courmisch@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	Xin Long <lucien.xin@gmail.com>, Petr Mladek <pmladek@suse.com>,
	Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Kees Cook <kees@kernel.org>
Subject: Re: [PATCH net-next v4] net: Replace %pK output with 0
Message-ID: <20260901160100.ATjnom7K@linutronix.de>
References: <20260901153706.RKMS7kBY@linutronix.de>
 <9e18a5a0-33c7-482b-9edc-972de9954453@hartkopp.net>
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <9e18a5a0-33c7-482b-9edc-972de9954453@hartkopp.net>

On 2026-09-01 17:51:10 [+0200], Oliver Hartkopp wrote:
> > ---
> > v3=E2=80=A6v4: https://lore.kernel.org/all/20260812110531.ITPqiY2O@linu=
tronix.de/
> >   - The CAN changes have been dropped.
>=20
> No. They are still part of your patch - in the former way.

unbelievable. So I just resent v3 and though that I forgot to update the
patch description so I stripped the can bits.

> Would you like to integrate my patch into yours or do you want me to reba=
se
> my code once it shows up in net-next?
>=20
> https://lore.kernel.org/linux-can/20260815103400.117175-1-socketcan@hartk=
opp.net/

No, it is too big for my taste. Please route it your usual way. The plan
is to get rid of %pK once all users are gone so there is no need to have
it merged as part of this one.

> Best regards,
> Oliver

Sebastian
