Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.49
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794207198;
	b=KfldH2ankayfR/46zByPNSZ/tImLw3WRjyvPU1VjtxuW6cyDyNsJx7xXXzRxcDfth5uO
	 pnxhAzhGuRGQKtbkm1QrYvLdI+03/Tvh+ecEmxJFjGjt+yBj6bqDN3G5uAWp3EZ2WD6ri
	 KyBRL3nj3ChbfMI2jAOXEndgTsz7OZdIwodYp3RHPYsLNz7gS68xxZEpTyounHlW15CNh
	 tkehElhhJbv2XE6Qyzf/sAo6J2BtWLVTVw95M/BzrqVOvZHLUL75VNEzkpZyR6llUSs8q
	 2wmeFYuavo33QPTS/KQI5Pz1Rd46auOtvF8BXG9x9h5Z1gCRPLm5qHOb7+TIy246M7A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794207198;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=kdfSMn5qmUAvXVccrNmls1DypVGRaJ++jbiwGI14+kg=;
	b=d96DlUm36/PZioHXiImlS8GfCP+qniIOmgan05moTnzt+LXXiKno72LGK1CH6n2KTgR3
	 3Cusci5uWLUi7OCCQis9D/tzmTceq9CWbjt/DtGgZzJIr67HfoegARGRV+OXHoI5Z3QH1
	 9oEgzUBaZW7dqh3CcjEfsS0E26txysN7/YIVqj+Byz66Vyg72fI+Bt8pm+rKU3U1IwtFR
	 MnD1ZSh1fLyaOhtTvDjAuadD+nrKfZmTC2lIbcI9pgpNzAdE3bZUJWYtbQfrDs4OKWbmt
	 ii82iBk/3o394jasrFApw785H87x37Kzu8DdRLNhjeigLFJlOXUZRt3ZfvjVmHDB6cg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=sgWujCEB;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.49
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C23C606A331
	for <linux-sctp@vger.kernel.org>; Mon,  9 Nov 2026 06:53:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5C23C606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=sgWujCEB
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5c14f6f58aeso329661e87.2
        for <linux-sctp@vger.kernel.org>; Sun, 08 Nov 2026 22:53:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794207196; cv=none;
        d=google.com; s=arc-20260327;
        b=faQ2f7KmnilwuK5J+E9p0CrmaI8HhiaZEpy2Kq9oz6VK+B2kkoVdr9pDs6Yqbk9s8I
         ZzQTq9KRG50tes7ZZs2l84/ogJFc1pIEidrNp8mQmWrU51ZUSwk7J6yoY+qeH1zTy2RQ
         MEfPqlup98jhfg/LR3pHTjjdl5CFpmkDOrF4EbGc0lBtowumwVZqDHBEwJiGD9gybdOQ
         hH8Bf7FaM0eTgXo9sLuDTTOB0mWFXIRhMawKbiv5ISVoq+VM9NbmnxBt7n5m224uW2hB
         ZLDiPgdDcRlv0ibBBnOg7PDp6Q3XPM7c+AEFoxSNLSFtAECwu1kc5lMX3gAUOg6zlGcI
         KTig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=kdfSMn5qmUAvXVccrNmls1DypVGRaJ++jbiwGI14+kg=;
        fh=rD9TtbsXpMB4J4z3b8Usft+x2r0sPNEkoTHlC+uF50I=;
        b=E9Dlj6LNhkvG1mRXT/ilFCtzZXHELRhGfeqduvETScZzfyUxwOfqNHPrV8bcxrlpeL
         IHIadYWgHWndP7Z8k85z/Lv1awjDK4OhNCPr7w8OQQ9bokP4mWkx5J4SI/FX6BBkHjAA
         plMMZ7Z9BPGO7YnFSReBIXdUCRwTJxRhwcjZC0PhLBSHbS2R9M0aG7jvMChQYk8GkakR
         2c1DWoxqKD0qhlbpgmGbQ4ex0dzJ3DgYRCgr2T7AcpvHwGH9OdRTAysr6RcR7s00lAvl
         +kIrNfHrG3MEFU5Pqld1CpmNwgSfQt/yAI5eN+vWacQJxZW9ZXG6coRL58XLsfp/k/X+
         nzkg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794207196; x=1794811996; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kdfSMn5qmUAvXVccrNmls1DypVGRaJ++jbiwGI14+kg=;
        b=sgWujCEBcLnI2rCZx2+HrV0hdHuKHGWZkbP/T95hfWdHOsdro1qJU1Fvk+8OO9MdfB
         0BqsBZTh492PGUlz+uiD5cFVvZc+vlVmSZhYzi+w/tlD80Sl6tEzuWFCWZhv/N6pbH35
         rLWt1UHkkGkHK24Z/h6vBhtLRJVzr1jbqDl3LlT+eJtmAmj2BiR6ABZnJcxKkIEwjeuj
         rKb8qVeksOei/N1ZYTOxCXuIYcRzPS0XXno11fSFmwYvkRxmBZ3+yYmHEczZNKiPx5RZ
         oHt9g8LUVuNFkbZtPXFWBtwsCaMo3xAJFO6XAxUED9WmEkoDJbCWdP6YC+ZT/ijPGBxT
         E53A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794207196; x=1794811996;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kdfSMn5qmUAvXVccrNmls1DypVGRaJ++jbiwGI14+kg=;
        b=HM3pvHYZLx7EuCE7bfZYX/YHcujVqkZtaaV6d+c0Ylx5THyXL07F/sTpgKSH79xGUj
         wribAe5oHWjMkuxulymlCJjsWl5VetOhkKRRuGViq+BkfCivdKJEF7crBb5YMGtvYEXf
         6tnyYBFSpsUY1KUYvg+RzUi+sftgUBTYcNT274rm7yw2WUKxUlJ1en+vwD7SIuc/FOYZ
         2vNA6iLC5d/zMzsez5miBeNUekrqtYfIbXgodAgY/g+T9b9ZYKClInkJzWbGzVZFe1Hw
         tfJFfrkjSVErNZ9YN3dKQ7/Bz7ChE/YGP6gCsqNSt6+MN7mYJctIs8KGPMPOyHkCr+kM
         +O7w==
X-Forwarded-Encrypted: i=1; AL+hErHeX7TxWB5fzuHYzugsq15v6MKYOqhZhO3GEP9OSuibKKg4g1UFmnTXQGz3AGgtdhM1SmZ1ohXx56Hy@vger.kernel.org
X-Gm-Message-State: APuU4Z+EkTX4GqpBbb1keh5lNB++cJ+P26Z6oWpvihuCjOonHVyQoUbF
	RICc2RxMd2YGOk17z+nyzNfarGPlvvAACUnmHy9XrEQp0d161x1kH1CD1s+YyNHgkhnuEZOr9OQ
	vPna2OXKypeLH/gLOtB99XBSxDeG4zh8=
X-Gm-Gg: AYBFou2PjqBdmqQW7ibbUDgW5wvWjBl44L7zhyOSYBPQNJucnsPG6bZf27cm7Gdu637
	eTsnvfDKT2ppJsBjGkDETBortZ8eKoR1vUdYVNTQFT1W8Idz6IngM81Gg6xE/gtIX9OTXYt4xr+
	WwZVQIjJmK0TBNfmC/CEIgq4OLlEXjBTvc0QlhVtw8Xyj45NzIVl5E64ioAkA+g9YyCLJgw0ZWj
	CfLWeU7rFUb8Hv8joaPf5hXzW3ymEIWwZxgdE7Ei8idxmXuQmQQXLYZn+Q3Z2/jMf3PbxirlHHe
	lMS3+04ZrHhrwi3hU56WO8SLkdLx80T8QDnfdkZlFjY7lKVvWGfZeTPijinr7r4efx2EzrDrPXB
	fAsNMNGHsALjVh3+hKsaKt83VCKdjFEAlryeFpza3DBK1tbZExFvsc6KNgaVAUDgt289dEIGuv2
	s3zJ3PTh6wyW9FgRBSlBCLzu40rayJCxfdoi+uyPw1roVDOHEMpPI=
X-Received: by 2002:a05:6512:3e1c:b0:5c1:4a48:c2db with SMTP id
 2adb3069b0e04-5c14c01f805mr810751e87.43.1794207196170; Sun, 08 Nov 2026
 22:53:16 -0800 (PST)
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Post: <mailto:linux-sctp@vger.kernel.org>
List-Help: <mailto:linux-sctp+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sctp+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261109025425.328445-1-jiayuan.chen@linux.dev>
 <CAL+tcoDvFNAZubOjw9+Z1eyaVeiBzt_Xg3KMNucY879bg-ZLow@mail.gmail.com> <dbdb9385-89cd-4e4f-bfb8-b72510e8801b@linux.dev>
In-Reply-To: <dbdb9385-89cd-4e4f-bfb8-b72510e8801b@linux.dev>
From: Jason Xing <kerneljasonxing@gmail.com>
Date: Mon, 9 Nov 2026 14:52:37 +0800
X-Gm-Features: AclHuK9hO_h4FFhel_M7AacjBweA615sygy6vgIfEMNG5ukVHhzyCYoysXzMOxw
Message-ID: <CAL+tcoA6_gROiprd7YgxvwbaiuzEUPfuWTNMjKu6vDkbUJ5KPw@mail.gmail.com>
Subject: Re: [PATCH net-next 00/14] net: annotate data-races around sysctl knobs
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>, 
	Ido Schimmel <idosch@nvidia.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>, 
	Phil Sutter <phil@nwl.cc>, Nikolay Aleksandrov <razor@blackwall.org>, Paul Moore <paul@paul-moore.com>, 
	Matthieu Baerts <matttbe@kernel.org>, Mat Martineau <martineau@kernel.org>, 
	Geliang Tang <geliang@kernel.org>, Julian Anastasov <ja@ssi.bg>, Allison Henderson <achender@kernel.org>, 
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Xin Long <lucien.xin@gmail.com>, 
	"D. Wythe" <alibuda@linux.alibaba.com>, Dust Li <dust.li@linux.alibaba.com>, 
	Sidraya Jayagond <sidraya@linux.ibm.com>, Mahanta Jambigi <mjambigi@linux.ibm.com>, 
	Tony Lu <tonylu@linux.alibaba.com>, Wen Gu <guwen@linux.alibaba.com>, 
	linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	coreteam@netfilter.org, bridge@lists.linux.dev, 
	linux-security-module@vger.kernel.org, mptcp@lists.linux.dev, 
	lvs-devel@vger.kernel.org, linux-rdma@vger.kernel.org, 
	rds-devel@oss.oracle.com, linux-sctp@vger.kernel.org, 
	linux-s390@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 9, 2026 at 11:33=E2=80=AFAM Jiayuan Chen <jiayuan.chen@linux.de=
v> wrote:
>
>
> On 11/9/26 11:11 AM, Jason Xing wrote:
> > On Mon, Nov 9, 2026 at 10:55=E2=80=AFAM Jiayuan Chen <jiayuan.chen@linu=
x.dev> wrote:
> >> While testing the recent sysctl range fixes I noticed that a lot of ou=
r
> >> sysctl knobs are read with plain loads while the handlers update them
> >> with WRITE_ONCE() and no lock, so KCSAN reports them as data races. I
> >> then used an LLM to go through every ctl_table under net/ and list the
> >> readers that were left behind. This series annotates them with
> >> READ_ONCE(), and adds WRITE_ONCE() to a few custom handlers and netlin=
k
> >> paths that store to the same fields with plain writes. Most of it is a
> >> plain READ_ONCE() at each read; where a function reads the same knob
> >> twice to make one decision, it now reads it once into a local, so the
> >> comparison and the value it acts on cannot come from two different
> >> writes.
> >>
> >> There are no Fixes tags. Done one knob per patch this would be well ov=
er
> >> a hundred commits, so I grouped them by subsystem and feature instead =
to
> >> keep the review manageable. If maintainers prefer, I can split it up
> >> further with a Fixes tag on each one, as several smaller series.
> > Over the last year, I've been thinking about the annotation stuff
> > especially around sysctls, which, I suppose, shouldn't actually affect
> > the real workload but does affect the outcome of the syzbot.
> >
> > Out of sheer curiosity, my question would be what is the point of
> > trying to change all of them? Or what kind of benefits can we get from
> > the big series?
>
>
> Three things:
>
> 1. A plain load may be emitted twice by the compiler. ip_error() compares
> peer->rate_tokens against ip_rt_error_cost and then subtracts it again;
> if the sysctl changes in between, the u32 wraps. A few readers have that
> shape and now read the knob once into a local.
>
> 2. Tearing is not involved here, all the fields are at most word sized.
>
> 3. The rest is the memory model: a lockless read of a field written with
> WRITE_ONCE() is a data race unless it is marked
> (tools/memory-model/Documentation/access-marking.txt). That is what KCSAN
> reports, and why most of the series is plain READ_ONCE().
>
>
> I think the benefit is doing it in one pass.
>
>

I was curious about the REAL impact. If this thing really matters, we
have a lot of work to do even not only in the networking subsystem.
Sorry, I still think none of those points are convincing enough, but
that doesn't mean I object to this series. Anyway, it's just my
2-cents.

Thanks,
Jason
