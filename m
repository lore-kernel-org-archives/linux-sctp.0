Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1E5333936A
	for <linux-sctp@vger.kernel.org>; Thu, 23 Jul 2026 08:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784797060; cv=pass; b=kzp0MHRxezGvVnvSjtQsCyj1cI6Wo9+nU1p/EySgc9oqb8a8GEhYHIU4qOzFFzJVq63lW1fMwCPk66h6UKDACq+mfhrHVXZQ8g7j+kNti+IODmGfqfqu1sst1no3AXdWX3xt8PENX3EO5kP7JH3+QfpY7ONzt2uvD3dzNj6xDVk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784797060; c=relaxed/simple;
	bh=k+mAbwDpC7Nt3eygOUnsr+pIas5Ut/V4Zucp+rzEMoc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=n8iOlP2b2KQrY8iSiSgDJvfeHaic7RPKVf2PvIujByNxCI/CaXlqJuZIl0VNttvT6ntCnrU3Sw6bYHMDvUdg+6Vjhz1qCbhJpMZk8uUOZivtic6kCiXQFF9iTQEK5lrts05lNF19Be/EFaDgihK2bOfPVjQ3TndKHDpAUuaM7bs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nkqizbe6; arc=pass smtp.client-ip=209.85.222.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nkqizbe6"
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-92e512a9a6bso30270285a.2
        for <linux-sctp@vger.kernel.org>; Thu, 23 Jul 2026 01:57:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784797057; cv=none;
        d=google.com; s=arc-20260327;
        b=P7esMyeLaOw0DOgXxy4Fs47v5532Xqb74WdEMQk2TmZOCA8O1eTHg/I22YRBjoZAvv
         y8sOig4nMufH8QI+Qcapa/74QwLrHvHmsfeIPZALXJqOh20bkUO2xLlTAzONsejzKcHP
         sQJNDw7x7h5FKjvzfnbBN7bOfCiP2aD5hSlvtzCuTKwDOeevQjNM90PH99syG6ChUMtc
         ikMlYt34wXHW1qkNjR20An8pBrqOnLF23swjiLUnSS7t4mq1QDR5o06zSUr7d8Zsjsb8
         zS6y9nRh4faOYT9FBuv0Zp3MWVnWW6YavDxlu9Fcz6zMVNwKaXLxkLtKPdEvfYF5TqWJ
         Nx1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=k+mAbwDpC7Nt3eygOUnsr+pIas5Ut/V4Zucp+rzEMoc=;
        fh=SYKPgmBLcW7fkNO64nZ7J3R+Pc2veiaZLYfAU6oMSL0=;
        b=hamT0uj7NGICbibKOHTBmE9TDU46h0NYu+NdJgXGc3Rmr3n0ImItPZ11tg5JzQsFWE
         oqcrtulFkY0LrM5yhFqVNilqNl3GH6wG856FFay2TC22CbWRytdV6B3CUAe+DckRy1zU
         VZQnwxrmIiuWz5VEKFFm44GhGJlofq7XUSISdYPiqePg9fZeAsxWESCtgR31sadG1yne
         CnDjsNpBnVG225GcfnC9UNYeQ2QROduxUghl6V6qBwWrQoOMJXCZ98ZVk1cp+5HLswIZ
         jNhCno9SydNdcoIzoL3KHDeqjCzsxq2ReG/6LRPiRM64t1+qouwA9y7tOexVosVztNVL
         FXHA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784797057; x=1785401857; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=k+mAbwDpC7Nt3eygOUnsr+pIas5Ut/V4Zucp+rzEMoc=;
        b=nkqizbe6io3Z+qQ7pDq3p2DrYUB1jpV3ZQ/3bahMEOrR172doFdTXbQpioW56i0MDi
         DxlC/F5Lpe7PCcsWElRseepPLcHrzYpQsJsOAOKAhiYeEJ+Q8FWLRw62ZyjBcRa/PdTD
         pco49e6FpR7J71KwQDLPffi7lrUe6WJY2/42K3a0N0U7rfbYX8EBizvhKr+Ya+vdxTnH
         RwOCft20Hu9aR6OKIOJiLmG3ySnZGS12T3uhXLvSgIZtV74E0LK31QPPcPz/Y+CrWMo2
         7d/p6WIQ8wdpHqZ22JbY843c/IW8na9HpTVuowM4b4Iw/142jgm0+FchtNllfc4HbTTM
         AXgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784797057; x=1785401857;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=k+mAbwDpC7Nt3eygOUnsr+pIas5Ut/V4Zucp+rzEMoc=;
        b=OqgqjCqH1Tv6s0v3CpqlX762sWtK7hZt/4o/W/jsdw4pvTKi0HGK3JYFfF1kk/yXnr
         0NVGgXo3IiyMpkn3w4slp6LjD72QHlqwz2wJpVzmD6wg1TRfISiViOTv+5gctFO+9yEb
         bvPqjOq6cZXIfSxmoR3JjMVHwtXaqpoAJwN2vbAp5astSvGOnP8JCD4kTpTy4XW2K+Fd
         C11f0Yj4wg35YRHdBJIK87E7EW9HETWt7EuG+l3R+7cmw5vAElx3N5A/lagbzOYgiwGG
         g9KPnvm574pnRcV8EJI9Xg5kcsLMYQIZNicFBmnIHe5fdz6Wy05HJNqwWCDa4reTQ09T
         ouzw==
X-Forwarded-Encrypted: i=1; AHgh+Rq0zS4QLD+mkAqsB3wcKVxTvdwnswqptE7TxABnlCJrsSqdMQp1XWpooI9J3dE7ZfvZp4CzoL6NS9bi@vger.kernel.org
X-Gm-Message-State: AOJu0Yzy4vykF3B17QzVt0TXpiuroGQj+ZIvTrv3ttK0V8XoCflP9xTf
	K1KFDDod188KW5srDieyd21+bDmFOfXXT+JPnl+qGSqgHY00swLmzlqAvkOIBxsvdF/gnWKFSkM
	RdiUkLJrFqL1UQgkS0aAOmiZZqLt/uwAyYuuKtWK0
X-Gm-Gg: AR+sD13XuMEnssEC332agGmgUq/dvKoT9yYz0VnJbcmbCnCCuKRjAMj9UNjt86JET8N
	Zd8hqOGInfnFpfXjzRmTlDHNPn578WNl3O1MVVDGkrlSdULN8f6fjcOHGNHtDBsxyoqj54i+asK
	/Cn8Ne0R+I3ZoPPWbgiPzbyu29iB5ALA76m+TcHD3q2Eoc5iSqGYCdU9B/D5TjADbceAZt06X6F
	iDzeYKAlQhewbaXSqtsOYl/3bVlj8X/5HtsXndVsTQIk0kDP1Kr6XWeaR0HvGC5uWpKY1po4qM1
	/w4wmhjoXrm1DJ3h6wopQpNguo2x4IX/YvmIKXBUOWzXKzfXtLey1KVOWCMxS92g7b6VxBBDXEz
	DcNoqVZj+
X-Received: by 2002:a05:620a:7002:b0:91d:6ac3:565a with SMTP id
 af79cd13be357-9310384ea71mr224800485a.12.1784797056679; Thu, 23 Jul 2026
 01:57:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260714013940.4068189-4-srikar@linux.ibm.com>
 <20260722100842.602fd5d2@kernel.org> <CANn89i+o3rT6Jnx_6SK2vdmeuHVkZwTJXD++Kua9ZCJb-wVFHg@mail.gmail.com>
 <amHVtLnO7R2snG4L@linux.ibm.com>
In-Reply-To: <amHVtLnO7R2snG4L@linux.ibm.com>
From: Eric Dumazet <edumazet@google.com>
Date: Thu, 23 Jul 2026 10:57:24 +0200
X-Gm-Features: AUfX_mxWlHYNLqiASSsj3rGfpcdsrPcMJJIzd9oToDn-9kvT9hgRQbrZdMm_ISg
Message-ID: <CANn89iLBzPOL=9oRAn-+RJncL+0By80gfvVqVe9RAwY2XJh3yA@mail.gmail.com>
Subject: Re: [PATCH 0/2] net: Use synchronous wakeups selectively
To: Srikar Dronamraju <srikar@linux.ibm.com>
Cc: Jakub Kicinski <kuba@kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	netdev@vger.kernel.org, David S Miller <davem@davemloft.net>, 
	Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Dust Li <dust.li@linux.alibaba.com>, 
	D Wythe <alibuda@linux.alibaba.com>, Jon Maloy <jmaloy@redhat.com>, 
	Kuniyuki Iwashima <kuniyu@google.com>, linux-sctp@vger.kernel.org, 
	Mahanta Jambigi <mjambigi@linux.ibm.com>, 
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Paolo Abeni <pabeni@redhat.com>, 
	Sidraya Jayagond <sidraya@linux.ibm.com>, Simon Horman <horms@kernel.org>, 
	Tony Lu <tonylu@linux.alibaba.com>, Wen Gu <guwen@linux.alibaba.com>, 
	Wenjia Zhang <wenjia@linux.ibm.com>, Willem de Bruijn <willemb@google.com>, 
	Xin Long <lucien.xin@gmail.com>, Shrikanth Hegde <sshegde@linux.ibm.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 23, 2026 at 10:50=E2=80=AFAM Srikar Dronamraju <srikar@linux.ib=
m.com> wrote:
>
> * Eric Dumazet <edumazet@google.com> [2026-07-23 05:17:08]:
>
> > On Wed, Jul 22, 2026 at 7:08=E2=80=AFPM Jakub Kicinski <kuba@kernel.org=
> wrote:
> > >
> > > On Tue, 14 Jul 2026 07:09:41 +0530 Srikar Dronamraju wrote:
> > > > The scheduler assumes in several wakeup paths that a task using WF_=
SYNC
> > > > is likely to yield the CPU shortly. However several networking wake=
up
> > > > paths unconditionally use synchronous wakeups even when the waking =
task
> > > > continues execution.
> > >
> > > Somewhat related recent patch:
> > >
> > > https://lore.kernel.org/all/20260708133815.3419465-1-usama.arif@linux=
.dev/
> > >
> > > Maybe other maintainers will chime in, but I'm not convinced
> > > by the heuristics you're adding. The behavior will be workload
> > > specific. The extent of networking involvement should be letting
> > > the scheduler know that we're waking from IO, not leaking scheduler
> > > heuristics into networking.
> > > --
> > > pw-bot: cr
> >
> > In any case, adding code to the fast path in every network system call
> > is undesirable.
>
> Yes, I understand adding code in fast path is undesirable. However as
> mentioned previous reply, we need to differentiate between blocking and
> non-blocking API. Doing unconditional nonblocking, is probably even worse=
.

I suggested that applications choose what they prefer for each socket,
once and for all.
(This can also be a cgroup/BPF setting)

Flipping a socket bit at each recvmsg()/sendmsg() is a bad idea, you
might break old application expectations.
