Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D58A4476683;
	Thu, 23 Jul 2026 17:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784828118; cv=none; b=rg8Fj5txMuYwGP42Y3wpVZgA6WhUAaLyBrdPFwE7PWQuQCzKBxF3aK4jGRklu7LEAxPOLO2pwlsoT3QtBakZRNlGDyu607j1Bg2Im+KorVoFFqsIQI+yPpRmA+z3R0P6iAj2ShDvXeOyYdInD4UEjDf2jf0ikLA4N1elgt6mfd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784828118; c=relaxed/simple;
	bh=hwYkFA9PmV36Y59djeb2A8n0ZG+KGIq27JcB5qEKDkk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eZzJEF40SusZZgo2BrnMhFxdB0kgoLIiKYMUfINCSTNJh8J/drNVN/0mX5yDR9RfOlHiDXymENkQbO2OyYFZobB+rRjDRRHBjOfbAp6t5OYDk8cbkV1996pZ4t1j0taR/+etTDlYq5rPFjCIYFPSP6a/3Rpuqn7Uv9nHJOdFafo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h1gOqKna; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h1gOqKna"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1EC41F000E9;
	Thu, 23 Jul 2026 17:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784828116;
	bh=hwYkFA9PmV36Y59djeb2A8n0ZG+KGIq27JcB5qEKDkk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=h1gOqKna/suqeipdwQ8jNPKww5cNCKo5orZl33s/ivROnDX51C7cNAyDOx0kLlWde
	 fyxVieZSIgU+drqGfAUFfcg5oEpAbxviqJudylxXzpMalBajm/jGfbHvASBE8Jjfw6
	 MDupXhWRZq7u/K3aqVszSv14wqhol3WKEJxWif9JeDTHkGatKg+E2/+4AgiAQvZLoc
	 Q42TWzMW2mUT5MuOvnsaWvfVB4lxyN4ew1Pdpc353XumBONozgMiBNuMSl78jwbZ28
	 wFkBWLEXzmdcTL8utYLujseRvP89jvvHnRWbvj6fyqSEjnpyrIkeHoc12NvV7RS9EQ
	 0tTh8PZnQe8tw==
Date: Thu, 23 Jul 2026 10:35:15 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Xin Long <lucien.xin@gmail.com>
Cc: Jun Yang <1753810072@qq.com>, netdev@vger.kernel.org, Marcelo Ricardo
 Leitner <marcelo.leitner@gmail.com>, "David S . Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Paolo Abeni
 <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org, Jun Yang
 <junvyyang@tencent.com>, stable@kernel.org
Subject: Re: [PATCH net v3] sctp: don't free the ASCONF's own transport in
 DEL-IP processing
Message-ID: <20260723103515.0059802b@kernel.org>
In-Reply-To: <CADvbK_fjH_XGMVjZGXAk_Zj6_GOHu3u2bj9wOSMRymwNMK-k5g@mail.gmail.com>
References: <tencent_73762ED1DF08CC9D5F5F61954B01350CFE0A@qq.com>
	<20260723072924.7db6b065@kernel.org>
	<CADvbK_fjH_XGMVjZGXAk_Zj6_GOHu3u2bj9wOSMRymwNMK-k5g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 23 Jul 2026 11:33:27 -0400 Xin Long wrote:
> On Thu, Jul 23, 2026 at 10:29=E2=80=AFAM Jakub Kicinski <kuba@kernel.org>=
 wrote:
> >
> > On Tue, 21 Jul 2026 21:14:05 +0800 Jun Yang wrote: =20
> > > Acked-by: Xin Long <lucien.xin@gmail.com> =20
> >
> > Could you point me to where Xin Long acked this?
> > I don't see the ack in replies to v1 or v2. =20
>=20
> He initially sent the patch to security@kernel.org, and I asked him to
> submit it to netdev with my Ack.

Got it, thanks!

> By the way, there's a question about whether patches for security fixes
> should include the PoC in the patch/cover-letter when they're posted to
> the netdev ML?

Not sure if there's an official policy on this but IMHO they should be
easily accessible to reviewers / maintainers. If a frontier LLM can
generate an exploit for the problem based on the patch, hiding the
repro buys us nothing. And often the repro is useful during review.

For me an ideal submission would contain just a description of how the
bug was triggered in testing in the commit message, and a link to the
repro / PoC under the --- marker.
