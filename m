Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED96D477E27
	for <linux-sctp@vger.kernel.org>; Thu, 27 Aug 2026 14:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787840378; cv=pass; b=mGIHcqqsmz2cThZrQegzPKrYdtSDbiUpP5oR7tzx0/WbfIKWYSy+OWHosO5k7UenD7bH4TaR8nPF6gvMlKSOJO1YqTOYv1xHpedc1q52Yf+FarILp2rM9s4pD+8b8dp8OY8Ei//l5omYp5NrPqOMwoqWa0WMtevWOiVR2HDlZDk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787840378; c=relaxed/simple;
	bh=QtxNEICUuVV2reThy90iPgzc7cB3MRqI07zvy61G5KU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FKV3cP7VTI8eT0lymwf4MG8KKCzIJUwAVQ5EiEq2fT/WUNv285O8nZU6No0tNuO9db6Qic7EUFNFoW4CUIvXqPRgxO4svoalHVWO6LB5ysvJDL+CZkq5cifdWrfWZ77S35/zHbgKuCKRP0iFiIr3xa4VXkWdpOHeMJDOoq1Ik5E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dXb+Aa/E; arc=pass smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dXb+Aa/E"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-85377c8bc96so2179956b3a.3
        for <linux-sctp@vger.kernel.org>; Thu, 27 Aug 2026 07:19:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787840374; cv=none;
        d=google.com; s=arc-20260327;
        b=sgMcDhdpHaUseDwy5IhJrPjwgesKeNKnVUqUxRS6ZuXf4dHaf31Zd+OjU7OAqgRg53
         9M2wXawKMZMhj3lqsx9FXrm6EfRAP1iKcM5d1cBsHnQOQ1Oml4XmCmYs6QiVKr5GfyO3
         WZ7tRmOsoU3qlf5R2JDZ/rNdXvNsDrhNbIiHgKkOrcYZeJxlz5NwP+q93QapuWF1FZwc
         Htqtinw97zBlrjTRffwZObM54onWn03wzAet1fASmPMTO34e8KfuIb4X1s19ru0koaxE
         vyBmYuNCbdvqC3cxCxeEaDvbJoeD4MWQYku6UwsdbUu09B5Bv+wN2XN6vxPCPfOYOoEn
         GeVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=h4d/vcw+yA61mLR5Pt1YmaCECp8LcVjEoxXcC2sGDmY=;
        fh=qgt9BWvtYVIDfTvrqz6LOWEG3b15Tfl/2OtHjGSXQ1o=;
        b=gywABhRiFQNFUWU/1IWoy4KPdP67fiO1WJFW8+7U3RAyYB7aMCDkV2G+SI9nIFG7lg
         9Ng5n2v8kHCwROYB0MMymtUODhZf3iNuZmIPmc++92DcXsWTfnFE8rE5siT6R/Lx9l4n
         ntA2LmZm+RZiwP/m03wgMQXhyBL+McH2BaG2qht3CkhjTWEYCU0mm8tEG8rrgT3MBu8+
         mt63TiPtwa2kw8EopIZTEPwnkFjNWIoZQyChq8Ijpgh4VsxwVYj48akXZ/UvwvTyU2is
         0/a1skb5QzUOeMVNt1O9AIJAPrzhsOUXsSujYoY8S00fgpSKp2WfJ/+cEI1urx5RsQno
         cA7Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787840374; x=1788445174; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=h4d/vcw+yA61mLR5Pt1YmaCECp8LcVjEoxXcC2sGDmY=;
        b=dXb+Aa/EPMm9wmzDkua7QBv/9qOL3GyKrZV6gpnroPrYtnl6gsoEgonTrE5iqcxyF1
         jW7+ZtFE9ndbZJBX6F5tzdVgqSgWFEsUIeMRHLkdcAP9udf3jVTldVYM11WxSYPObtW2
         6DHWt7paaoSEozueeepV0T5QNKlf+fspp7PKcWfWkW6T74c9s2HLm4RnwJ6LFF9AacCB
         EQdjjDuRCzGUDjhKuuFcTJyRlBhrOTRcyfFS7Q9mf+7rGUcB0o3IQ2/Htq4XV136/PmM
         vfGG7Ottj66p6uCeOfkWm5tq2FcuI4017aSLfx+NIw27MLoUzXZcMqtlXEBmtinFjpyW
         fC/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787840374; x=1788445174;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=h4d/vcw+yA61mLR5Pt1YmaCECp8LcVjEoxXcC2sGDmY=;
        b=eQG1JvX7Oiw4sryHSD0tr4f3namM16SCPkDUNZwgS/TzAtK1YFEIznMriZrCPlYS6j
         0qac2td8YqGMw9DKoBJXXybPdsw7FS30OsfM7J/yqH/+reKKpNOFA5Epf25HmzJoAhyD
         QmIYo1qaLn141ubNEVNXN3iDsF0RhCGK9mFy3kPfmUFFsJc2MXbXYGUJoZjZjGotZ1Ve
         Yv2YzMKmOPUMvqxazzXc/hkQsKS2gHSMpg8KffGiByxD3COF6K3y5QZ77A1AV7VhTwPr
         lV2BB22jUA9lMdmqp11N6TapE4QK+4w7U1L7pP/YHa/0BqnGlOseIiidyiG6jIJRVoVe
         ARbw==
X-Forwarded-Encrypted: i=1; AHgh+Rr9ycscRRH7n9FH3lMHxhP7CYvHrPBuDD6m9ZUFevD6ojwsnnh91WtLvwiPzkmm9xH/swEaq+KbCVT0@vger.kernel.org
X-Gm-Message-State: AFuF++kqT+Ao5rxBGqwJqwjR1ZytHojalgh9GA/zcaCAUgE36BM2lgud
	IpJSvz6v3DyJJzTQJzLfqXTOwXhQDrMloutDjIldLTV2bivzxxGyLCuidMCNrIHp/IcD48wSu/0
	HbwRFpiepDxbaoX+LFRL6W4oFxMKlowE=
X-Gm-Gg: AR+sD13YiMFmqU21l/Bcs2fhbn6EqHo3yo4Hh9quA66hOEcKvGu9uBIDuBOvtoA5AG8
	CfCkr5iXxJZQo3lfh6mQ7GeGa4FHeyMX6wQKnxMcIMcf8k1IhWSuCzat1U/LSeTh7kw9psZAsW0
	6jPGvLxuorNfPpilbL89UG/z+NjWIo0InUQp+ty/qK7/6a6Z4SFv+DOxSywUm5zaBXzxJwtWpbG
	WEyx1FH0SRzc96RlKWuVpDmySgvZM9LhXNbx/17WU2lHll/oUm7oXW8uDKphEFS33ZDizX4IoAL
	neP/F4a5lvcTTzsUfJjqHiWuFXzLqt/BvlxveqgGPfwnC1Llx0FCXhYhXpuezZ9GNPdTPok2cVS
	G6JRMKS7bM+sdQ4Dge7VxFgg3XpVvHxrJA2pbRlmJg9Qb5I/tOXYIRtg=
X-Received: by 2002:a05:6a00:950a:b0:851:bf92:34c9 with SMTP id
 d2e1a72fcca58-85373eb97d7mr24687161b3a.9.1787840374212; Thu, 27 Aug 2026
 07:19:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <9d8f1b5c50329d5ea7c642128d35681abaa9ed20.1787773744.git.lucien.xin@gmail.com>
 <20260827102735.4fa9a5f3@pumpkin>
In-Reply-To: <20260827102735.4fa9a5f3@pumpkin>
From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 27 Aug 2026 10:19:22 -0400
X-Gm-Features: AcwNN1UANhyaulJdVsY59prG875XDb6OWfc-w6zafGOQOQaIyiyqPi412UfruUc
Message-ID: <CADvbK_cmjQ_B=P2Ahm=xLNTmtAi-RvR8ugFrjqz8pranK4c0HA@mail.gmail.com>
Subject: Re: [PATCH net] sctp: fix a TOCTOU race in SCTP_CMD_TIMER_START
To: David Laight <david.laight.linux@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem@davemloft.net, 
	kuba@kernel.org, Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, 
	zdi-disclosures@trendmicro.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 27, 2026 at 5:27=E2=80=AFAM David Laight
<david.laight.linux@gmail.com> wrote:
>
> On Wed, 26 Aug 2026 15:49:04 -0400
> Xin Long <lucien.xin@gmail.com> wrote:
>
> > The SCTP_CMD_TIMER_START handler checks timer_pending() before calling
> > timer_reduce(). The timer can expire and detach between these operation=
s,
> > causing timer_reduce() to rearm the timer without taking the associatio=
n
> > reference required for the newly armed timer.
> >
> > The timer callback later unconditionally drops its association referenc=
e,
> > which can leave the association reference count unbalanced and result i=
n
> > use-after-free during association teardown.
> >
> > Use the return value of timer_reduce() to determine whether the timer w=
as
> > actually armed. Take the association reference only when timer_reduce()
> > successfully starts a new timer, closing the race between checking the
> > timer state and rearming it.
> >
> > This issue was reported by Nico Yip (@_cyeaa_) working with TrendAI Zer=
o
> > Day Initiative.
> >
> > Fixes: 20a785aa52c8 ("sctp: Don't add the shutdown timer if its already=
 been added")
> > Reported-by: Zero Day Initiative <zdi-disclosures@trendmicro.com>
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > ---
> >  net/sctp/sm_sideeffect.c | 11 +----------
> >  1 file changed, 1 insertion(+), 10 deletions(-)
> >
> > diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
> > index 94716406d602..0d99b7e8c082 100644
> > --- a/net/sctp/sm_sideeffect.c
> > +++ b/net/sctp/sm_sideeffect.c
> > @@ -1545,17 +1545,8 @@ static int sctp_cmd_interpreter(enum sctp_event_=
type event_type,
> >                       timeout =3D asoc->timeouts[cmd->obj.to];
> >                       BUG_ON(!timeout);
> >
> > -                     /*
> > -                      * SCTP has a hard time with timer starts.  Becau=
se we process
> > -                      * timer starts as side effects, it can be hard t=
o tell if we
> > -                      * have already started a timer or not, which lea=
ds to BUG
> > -                      * halts when we call add_timer. So here, instead=
 of just starting
> > -                      * a timer, if the timer is already started, and =
just mod
> > -                      * the timer with the shorter of the two expirati=
on times
> > -                      */
> > -                     if (!timer_pending(timer))
> > +                     if (!timer_reduce(timer, jiffies + timeout))
> >                               sctp_association_hold(asoc);
> > -                     timer_reduce(timer, jiffies + timeout);
>
> Doesn't that just add a different timing window?
> If the timer expires before the hold() it will release the reference the
> calling code owns.
Yes, but I think it will be harmless, since this path holds the sock lock,
and the timer handler will restart the timer and take another reference to
the asoc before releasing it in sctp_generate_timeout_event().

I've seen similar behavior in the SCTP_CMD_TIMER_RESTART case, so I would
keep it consistent with that for now.

Thanks.

> So you either need:
>                         sctp_association_hold(asoc);
>                         if (timer_reduce(timer, jiffies + timeout))
>                                 sctp_association_release(asoc);
> or to hold two references across all the code.
>
> David
>
> >                       break;
> >
> >               case SCTP_CMD_TIMER_RESTART:
>
