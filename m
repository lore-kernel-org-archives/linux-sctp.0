Received: from mail-lr2-f35.google.com (mail-lr2-f35.google.com [74.125.230.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BC3F48B386
	for <linux-sctp@vger.kernel.org>; Mon,  5 Oct 2026 13:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.230.99
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791206750; cv=pass; b=qh2bNzmYvKX66n76KRGIEFwx0ho3UxW7xb09f6FFC0wMFxqeeInlBbWfeYMukHDOEjOyF/+e22l3VvY/7T4Yrwi9XzQqf7Sq2UxF5M0zn2ZPSqRLp2hakdRB2UIHzkFBs1m7t5bpT7BSWDlHyjLVVchD8Kdvduf1Y1BR2nA3iG4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791206750; c=relaxed/simple;
	bh=wMm4+8IRfPPcvvBENvkGYtZvw+exf4jHBcuNGRKviqk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QXak+oFuOgvl5sqIFr0coBkQyMJ21a72XrqIlg5KIMCxR/4wNpQtKFq2ogWuXcQD0vuROe1q1YiSuo7l6nBFOtrY/PkrSTrxZ1iNd+yePPkPx4wMH3V5hupGpFxWNpSgKvU7fztzP6GdANhkCRIHjpDO0bYhzfMjA74zbp7eiyg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cellusys.com; spf=pass smtp.mailfrom=cellusys.com; dkim=pass (2048-bit key) header.d=cellusys.com header.i=@cellusys.com header.b=cFyvQCLj; arc=pass smtp.client-ip=74.125.230.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cellusys.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cellusys.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cellusys.com header.i=@cellusys.com header.b="cFyvQCLj"
Received: by mail-lr2-f35.google.com with SMTP id 38308e7fff4ca-3a6124046f0so18214261fa.3
        for <linux-sctp@vger.kernel.org>; Mon, 05 Oct 2026 06:25:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791206677; cv=none;
        d=google.com; s=arc-20260327;
        b=kdDYoced54QlkKokfWWyUKy8sIWQ5ahdTCba/YrJo8p7lq+V78f4dXMhqwnbQvxDZb
         ebEptuCXsZD0v3A6yHMGHOjLH87rJUW3otNQkL/GR1IgLgPSxqmvVjWS2UQlnyiAEqIm
         nKzlxdwniGcYOyIssA0yiiXyYQQ0Simm1qJYBXyxudC8KQwlMukeqMdi7gj9wa7o5nHt
         8oUEyuSpEN7ZLolZb5/coOsbSBcg6N/kv7z/vFCiGkHGbn6xLbcjUFW/SAHcZDrAtI5Y
         ZSPRZ/ndFyIkDUaBSjRNs2Fci3hhI+daMOl1E+0Mw9+1+bK7YvbXUlwm8cSZwgGEa6gy
         2vqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=wMm4+8IRfPPcvvBENvkGYtZvw+exf4jHBcuNGRKviqk=;
        fh=qTdtGt+0Eg1tzzuym3a3g7YQ8DlaMm5Z2El5oKWHrHs=;
        b=l/6qBMErnLHArnJCciqmSFXbljQ5hGB4rp8trq+UO2QGHIBYtX89SeqF/c5EenAcJv
         mkE9vlL77zr8Bjr6WWUYM/8Nga7J0H86xuvK82kxXnWFxWmF+f9CFox8IsgTbOCRmPKv
         cb2iS421KsIKfqddIuuB/BItQcX6bzCMVgXxyCw/qvlU50ZJJUe0N1P48Yrwz2eRiMRv
         X+lDwTPhl5NBkiOqSZYHYiu07tjuAim+pNUYLgDVovSFDdj8m1JBPMEdi59u/Acl+aB3
         982g2idBzN2e3uYQ1311zdouo9m+y3PvNEcqz9Wc861/XC1Rn8F8yVOzzxNGcXoBLq3K
         780Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cellusys.com; s=google; t=1791206677; x=1791811477; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wMm4+8IRfPPcvvBENvkGYtZvw+exf4jHBcuNGRKviqk=;
        b=cFyvQCLjUypgXcmsl0fZCDaFYajMu8sADXXu+TiJuRALLKmP4XgkIenuBaNzG9ZeDL
         Cf35oe1gO321Dr/V/lBNdtIAdmTyqHtDI8t7XResfKJXkfjV+Me+M0j04p2QzynGF22A
         g4oA0O4cbiH0QTEDQBonFdhxR9HibewcM7T7EGt6fv214ieZyYsm+GQa7UaglUXVrUmo
         4R1PoBuSsgeXkn0m3jH5X8Jnguywjz9NBKHuu6KKJElwZh6FUykY3jkz4d+jzR/ELplv
         Y9YdmJJ1r1W0uTBventWqIoWnGbkpW1DcewtD9fCvy5qUEBaRs7SWHj4j6dBwwS+YX66
         xdjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791206677; x=1791811477;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wMm4+8IRfPPcvvBENvkGYtZvw+exf4jHBcuNGRKviqk=;
        b=lsCh54jm2jxAW3EevFcP5I8syN/mOZ6XfkACzblM4PmAU1cG2nrnWmZqlKXlCg0SrC
         VphFZiYCYaDzX3v1r1dVkazHR3luW+YEv6NB27UvEQSBP78iN5pQjt7jgRxJaARdpWTl
         ih24KJJEmHJTTGIgGW715CE5Y3KJQYWfmeA3Z31Fr8MW5id7t7E1nO3urw9tIvHgZaY8
         CZogV6y3so3LdbNg6CYVXU0eGTA/Flrq/2YvZPfHIwYkPFeQnPMsAStfLkmxaPjagoBS
         RcTJ+6f8y7VRRPtgEDgxz+K/s9Uk0uyoEb5lVXas4Yb2KGmt0/TmBC+fav4+5SNBCsBW
         AC9Q==
X-Forwarded-Encrypted: i=1; AKwUvBwCHDyqdZw3Nq8c071m71VD249wELadS/TzRzE+ijTHw+/gcq6btpKLwz9OkgCjOJHe+urQV9LyUYX4@vger.kernel.org
X-Gm-Message-State: AFq9FYINsONTY2HO4Bx9RvqdEHLW0Rs7pvEQb8v98azxCHrgf/G6o32Z
	BDH8z3N26mRkeMqH60Xp+4UkyxaLL4I7cbMubh0cV7PfpiMLVGZhODoxPmpIvIzjqDf0+8xqr60
	gDVzhZqj+H9yR4CZGo8Kqv04LPuhhrKYeVuRqsGg6aA==
X-Gm-Gg: AYBFou191WyFlBbYzp1DF266eUgF2fxmoAyFpC9ZWvzvR249tsTYp4TkqSKbR0tV/Qn
	V4MXXWZaRLD2eflbIQRnOghVfjuRPBOj7JM+7YmeoBIqulrS/zH71Yg63GQd2JHQxOCXaexZJC0
	JuPuQN71FtKiUgd4JZvX2tLdzThazbvrsMjhFgz/w9Yh/G8Q/+Man39uTgJdI6psqPSqBTfjf5V
	ty844HzLhYkLPtgyBN1T+V+hj+XkMI+49x155eRNQhHIJSbbfoF4tPIUAR7pxkEkQHHxfS+3Bfb
	jsSCwd7hH2/wWUtB3CIBVqCR7whBnMRq2Ia1JI8Jw/U9l5h4jmzfqDshTmNw9CB4uw==
X-Received: by 2002:a05:651c:15c1:10b0:3a9:8546:ee13 with SMTP id
 38308e7fff4ca-3a98546efc0mr6805921fa.19.1791206677180; Mon, 05 Oct 2026
 06:24:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260928190401.1641260-1-wbriggs@cellusys.com>
 <179083835206.434549.7959555054670908229@kernel.org> <CADvbK_fps4LrNX36j-MBpFmc-S5bQXhqkBgz+HC2RRuCvhdBXg@mail.gmail.com>
In-Reply-To: <CADvbK_fps4LrNX36j-MBpFmc-S5bQXhqkBgz+HC2RRuCvhdBXg@mail.gmail.com>
From: Warren Briggs <wbriggs@cellusys.com>
Date: Mon, 5 Oct 2026 09:24:26 -0400
X-Gm-Features: AclHuK8ql_DkcT0uZ-eQZibVFIA9uOYVqWoejjFf20pjZd3FIRsV8Zs4rsgIXHg
Message-ID: <CACjaXw61gk_5OFcaq4SxNCWqZJEx9j0U80_J7F83BAmHRxkD0A@mail.gmail.com>
Subject: Re: [PATCH net v4] sctp: carry peer capabilities across an INIT collision
To: Xin Long <lucien.xin@gmail.com>
Cc: netdev-bot+sashiko@kernel.org, marcelo.leitner@gmail.com, 
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, 
	horms@kernel.org, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Xin,

On Thu, 1 Oct 2026 at 12:11, Xin Long <lucien.xin@gmail.com> wrote:
>
> On Thu, Oct 1, 2026 at 3:05=E2=80=AFAM <netdev-bot+sashiko@kernel.org> wr=
ote:
> >
> > [Severity: Low]
> > The commit message describes this as an INIT collision fix, but doesn't
> > the same code also run on a peer restart?
> >
> > Could the commit message describe the restart path too, and could that
> > path be tested?

Yes. The commit message will cover both callers, the INIT collision
(dupcook_b) and the peer restart (dupcook_a). The v4 testing covered the
collision only; v5 will add a peer restart test, with ASCONF and
RE-CONFIG sent from the surviving association after the restart, and v4
run as the control. I may need a couple of weeks to get to this.

> > [Severity: Medium]
> > On the peer restart path (sctp_sf_do_dupcook_a()->sctp_assoc_update(),
> > state >=3D SCTP_STATE_ESTABLISHED), only the inbound counters are
> > re-derived here. Shouldn't the outbound counters asoc->addip_serial and
> > asoc->strreset_outseq be updated as well?
> >
> > Should the ESTABLISHED branch take addip_serial and strreset_outseq fro=
m
> > new, next to next_tsn?
> >
> This looks a legit one.
>
> Since asoc->peer.asconf_capable and asoc->peer.reconf_capable are updated=
,
> we should address it in the same patch.
>
> So please follow the report above to update addip_serial and strreset_out=
seq in
> the ESTABLISHED branch.

Agreed. v5 will take asoc->addip_serial and asoc->strreset_outseq from
new in the ESTABLISHED branch, next to next_tsn. On restart
sctp_tietags_populate() keeps our initial_tsn and sctp_unpack_cookie()
bases both counters on it, so new already holds the values the
restarted peer expects.

pw-bot: cr

Warren
