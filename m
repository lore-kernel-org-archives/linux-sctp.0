Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13B4D3911BC;
	Mon, 10 Aug 2026 23:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786405321; cv=none; b=mxLAlyeQ8EIAhRPkoVkdSFW2QINV9dAfKsAkCOllioUpBT9nrv+Arbc7WXKmxAWIrUWupodzwmHEuZhwB5S/8OuHoHCp69650LYnMjVtU0qMap/wm8Iqgr6l6kAQEL1X9UdVjGPW9mdy5+ixldjEJAYBb5TO9+LkesCGN6vy3J4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786405321; c=relaxed/simple;
	bh=qLyxSzN97QHVb6VuTcPQa3U6LscXmeTlUMccSgeQ0/c=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T23Oin/aEUf5cqa86zLLR+xWb4x2zEocD6Y+XBUc4/CNIPfRqa961gHk2iXFl8Cj6iaIbcYqxvtZBGf1c1mnpL7ovM2gisB/k7ANnrCbQC96EJtPofaxTWckbioJqxCrUO+MtZn3syid39FPJ1GgUgGx7YJyEpjGLoyoW7e8RA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MV3sZwKj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MV3sZwKj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 239311F000E9;
	Mon, 10 Aug 2026 23:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786405319;
	bh=qLyxSzN97QHVb6VuTcPQa3U6LscXmeTlUMccSgeQ0/c=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=MV3sZwKjYN7vu90UtfVp50/xk7Gz0ikGhhS9QIwEcAYJHduFQu2T66MiFuv6CdLNP
	 5qBINs2HRCNTuAO7XRPRSFiwXAOPSNAy8UPGsTri+mdUUDSuYOhsSd/+5isriA5tXF
	 0eCOFpQuKJEue8QC5eMHjg1pBT3BHkue0oZo4HCcxp8+bxyvZyptlRvxu29KQRnszI
	 A9mAWU2sx+VaR4gGGXSNaYOuiV6VLB/30PX0Y95tUDnt97i4A6hG7dkGjes/gkyhdQ
	 ik3vDcRIWuzaU3b2QG4fhqWt/B7WIQvTvLsReqhKdLdYGl67B3fVnzvJo4XZAygLXJ
	 Wjw6W9/iztkKA==
Date: Mon, 10 Aug 2026 16:41:58 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Xin Long <lucien.xin@gmail.com>
Cc: Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>,
 linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
 marcelo.leitner@gmail.com, davem@davemloft.net, edumazet@google.com,
 pabeni@redhat.com, horms@kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>, Ao
 Wang <wangao@seu.edu.cn>, Xuewei Feng <fengxw06@126.com>, Qi Li
 <qli01@tsinghua.edu.cn>, Ke Xu <xuke@tsinghua.edu.cn>, yyxroy22@gmail.com
Subject: Re: [PATCH net v3] sctp: fix use-after-free of cached ASCONF chunk
Message-ID: <20260810164158.2c6821b3@kernel.org>
In-Reply-To: <CADvbK_cv+Wkb5r-8_sGnKsuA5tfErvLoiPZYVN=yXALbWfBOGw@mail.gmail.com>
References: <20260809043806.2768302-1-yangyx22@mails.tsinghua.edu.cn>
	<CADvbK_cv+Wkb5r-8_sGnKsuA5tfErvLoiPZYVN=yXALbWfBOGw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 10 Aug 2026 09:09:15 -0400 Xin Long wrote:
> On Sun, Aug 9, 2026 at 12:38=E2=80=AFAM Yuxiang Yang
> <yangyx22@mails.tsinghua.edu.cn> wrote:
> >
> > addip_last_asconf caches the outstanding outbound ASCONF chunk. The nor=
mal
> > ASCONF-ACK completion path releases the chunk and clears the pointer.
> >
> > However, sctp_asconf_queue_teardown() releases the cached chunk without
> > clearing addip_last_asconf. During peer restart handling,
> > sctp_sf_do_dupcook_a() queues SCTP_CMD_PURGE_ASCONF_QUEUE, which invokes
> > sctp_asconf_queue_teardown() while the association remains alive and le=
aves
> > the pointer dangling.
> >
> > A delayed authenticated ASCONF-ACK can then reach sctp_sf_do_asconf_ack=
(),
> > which accesses the stale chunk and passes it to sctp_process_asconf_ack=
(),
> > causing a use-after-free and a second release.
> >
> > Clearing the pointer exposes a race with T4 expiry. Peer restart handli=
ng
> > queues the timer stop before the purge, but SCTP_CMD_TIMER_STOP uses
> > timer_delete(), which does not wait for a callback already running on
> > another CPU. Such a callback can reach sctp_sf_t4_timer_expire() after
> > the purge and dereference NULL.
> >
> > Clear addip_last_asconf after releasing the cached chunk, and make
> > sctp_sf_t4_timer_expire() consume a stale T4 expiry if no outstanding
> > ASCONF remains.
>=20
> Acked-by: Xin Long <lucien.xin@gmail.com>

Hi! I think *shiko has a different suggestion which it thinks covers
more cases. Does it make sense?

https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260809043806.2768302-=
1-yangyx22@mails.tsinghua.edu.cn
