Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77E4D3B776D
	for <linux-sctp@vger.kernel.org>; Tue,  1 Sep 2026 14:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788273333; cv=none; b=hgrpJ4GsHUv6lyEbS4JLWWVlQH0QcaL4AZuVrsH5nREWE73kJbtPx1DmSaQAJmV99Io5A/abTUB/Kmo0XuGCy3kVMEuTmJQUNV8HeMiqnue4eZk8Ywhw9Unb2Cylmick8Efuk9kNvhOuajwOmOt1LOHfBebjAIziEjvqDswcUis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788273333; c=relaxed/simple;
	bh=337HFZz+bQ1i1VtRCTa9268AZ4iIQczmq7C/N3wjRoY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R1mntB8kbTGgpSQvQ++CNJQ37EmOETqscs1ovkf+ALuKJ2+LoRgQBr/p2zxr+CRWLep/Tm1bGs+7kYUpby2Wqg26EInwSKKPyYQ/Xm9Bb5BsdiDKYrcfEAJgdjWXO47MkRfW86jXWCb6BHos9OyBwaqRwzEqChY7y66rLHl2HSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kWvQhX+d; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kWvQhX+d"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4953e04ef16so9562565e9.2
        for <linux-sctp@vger.kernel.org>; Tue, 01 Sep 2026 07:35:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788273329; x=1788878129; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ybO/GPr2/hJm9IOXOpb1c3apJ1A9Dmdvx+NqcPUdbWE=;
        b=kWvQhX+dm20cmZd71GlJ/SNjjr3GJDQkseI+JaUXyAf7sVmjLhE3I1W52hu97/ySnG
         iCjRgN9vpxrUu08I+UZTPtOynKtoehoV/CL1TH8hk5ksOXA6LwYmgf/4sB7O2IPPSNej
         UwVnolzIqKyYotsMdigsxjnu2ooMO/wV9riEmKDuGKMF42xSoQqEPNqn10Xg8K6lAUyU
         8yjVnBZ7ywHY9l8kwv023ziAOMJ2ffcJ9wbVRdsP0K+uKasl1MBvyk79mwGUvz57ZljP
         TQ1hioEe1lwnR6YbIz+zpjR057pJmYUbSC58RAGjixZ1Wyl9iZMlwf3y9qwE3R+R8iU6
         gFmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788273329; x=1788878129;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ybO/GPr2/hJm9IOXOpb1c3apJ1A9Dmdvx+NqcPUdbWE=;
        b=AyOW88QhLBiq5NmlbH+uwKnsp7hdBZ8zhODvTT92g/Zqrt5NFRJDx2H9mJUDxaIwrb
         KjV+F4ak/J9S80s+F48izTmUUgjwA92WCUvCu6LlL42wqameSCbES1ra+JVAGuoahaOA
         SeCClg3GEvXavU5jBL+cbFgJA6spMan/zTgLvogDlgN0eG1Y77m1Km5s5Jd6g8wpXiaS
         be29FABNvqUAtYNuxNhOoa+HAyqX6m2TKev6SJub+t4bDCtwISCDIThxF6Jne8Rem+Ja
         mCIFEWl1Uyrwx9kPUbDLZ6ttfOVqNrheaviqhNhDZ1VrVPV/KO3BRXRkjuBXN9A1BKgS
         dmTw==
X-Forwarded-Encrypted: i=1; AHgh+RqaAKrBW6UnVm2djT0KPn6SbNlW9byR2xswEVPELthuw34oWSqjqDUf+Rl2nrGGTDUJu1N2T9crK0xI@vger.kernel.org
X-Gm-Message-State: AFuF++kr4m6XtgieZBSoyzW1iki+qOiXJc6arNJVTMQAfbFNOlzF1kqL
	FOayZTtALJBgHYKORrF0CUjQzVkgbiBe22xonG4805TzoLcclzddM5Qz
X-Gm-Gg: AR+sD10dQaKw54FgDpUU1y2DYpyTGI0gnRe+0CoDhhnaO2q3QDyZJw9di1WbYF5/eGG
	No2SkD7+2cdPY6TkfGnYZfpmUgcpOmhKbQX+0dfdWW5vymGBbsC7OMFC/AloetySS1pVDyvHG6v
	i2INXTiJ+cVgEegcevl0O70+ThSm863HWQr8gLzoy4FpGWa74SxUJITVLxwfUvGSHj8z2GQJFZc
	Lnt4Hrt10wt9tENRVHjTpFPe3wtRozPhmq9OtfupVsXCUg9gntJfYOm1+84iDgtui0Edi4XSnDw
	XF2LAJVeLF241e+S4C5snA2rfaSbMuSRMOIwvK98IJqUSr15oZSsLv8fFDDFpKjspL6YiMFleQ8
	tkKU6zhPHg5ZaSudCO2cHQa80CT3Ng/eUs4M22Ccazym/VdPUhd0trgtR4j3D7+9xF9P3Qnmjvk
	LXI57uN1IDMpODm7J8jAKhpOXYyb1aGuxbSuwR64RFhywN2HXEyIN7IQLftuHa6An7AZZZz8wzn
	+xlgfjBgIsnatpB3+/F+VVPAg==
X-Received: by 2002:a05:600c:1d1d:b0:49b:d45:703e with SMTP id 5b1f17b1804b1-49b91c2dfecmr525571945e9.8.1788273329280;
        Tue, 01 Sep 2026 07:35:29 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49b926874fdsm360366475e9.4.2026.09.01.07.35.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 07:35:28 -0700 (PDT)
Date: Tue, 1 Sep 2026 15:35:24 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Xin Long <lucien.xin@gmail.com>
Cc: xietangxin <xietangxin@h-partners.com>,
 syzbot+80dfcb1a2235b3efc877@syzkaller.appspotmail.com, "David S . Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Simon Horman
 <horms@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
 marcelo.leitner@gmail.com, Paolo Abeni <pabeni@redhat.com>,
 linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org,
 netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com, gaoxingwang
 <gaoxingwang1@huawei.com>, huyizhen2@huawei.com
Subject: Re: [syzbot] [sctp?] WARNING: refcount bug in sctp_transport_put
 (6)
Message-ID: <20260901153524.3e92df3a@pumpkin>
In-Reply-To: <CADvbK_eY4S1HbdNHuNq9b=Va-TA_6rNFvnCvtOUZ0sF-AWN67A@mail.gmail.com>
References: <6a7d8773.c5ad36c8.12f49d.002e.GAE@google.com>
	<68cb4941-3668-44f1-a889-6b2f023b2a08@h-partners.com>
	<CADvbK_eY4S1HbdNHuNq9b=Va-TA_6rNFvnCvtOUZ0sF-AWN67A@mail.gmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 1 Sep 2026 09:45:42 -0400
Xin Long <lucien.xin@gmail.com> wrote:

> On Mon, Aug 31, 2026 at 11:47=E2=80=AFPM xietangxin <xietangxin@h-partner=
s.com> wrote:
> >
> > Hi,
> >
> > I have analyzed this issue and successfully reproduced locally.
> > The race occurs between the timer callback (`sctp_generate_heartbeat_ev=
ent`) and
> > the transport cleanup path (`sctp_transport_free`):
> >
> > Task 1(Timer Softirq)               Task 2(sctp_transport_free)
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D              =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > sctp_generate_heartbeat_event()
> >   refcnt =3D 2
> >
> >   bh_lock_sock(sk)
> >   sock_owned_by_user(sk)
> >   mod_timer(&hb_timer) -> returns 0
> >                                           sctp_transport_free()
> >                                             transport->dead =3D 1
> >                                             del_timer(&hb_timer) -> ret=
urns 1!
> >                                               sctp_transport_put() (2 -=
> 1)
> >                                             sctp_transport_put() (1 -> =
0)
> >                                               sctp_transport_destroy()
> >
> >   sctp_transport_hold() =20
> >     -> refcnt is 0, increment fails =20
>=20
> This should not be 0, as the transport must hold a refcnt to start the
> hb_timer.

Isn't there one hold sctp_generate_heartbeat_event() and a second for
whatever 'task 2' is doing.
When hb_timer is started it is given another hold (does it actually need on=
e??).
So when hb_timer is deleted it's hold is removed.
But the del_timer() is happening before the the extra hold is obtained.

The RHS (task 2) would need to hold bh_lock_sock().

Try giving sctp_generate_heartbeat_event() two holds.

David


>=20
> Also, the delay below is under bh_lock_sock(), so it should not be the
> real cause of the issue.
>=20
> Could you share the PoC for this issue?
>=20
> Thanks.
>=20
> >   out_unlock:
> >     sctp_transport_put() (0 -> -1) =20
> >     -> refcount underflow warning! =20
> >
> >
> >
> > Adding a small delay  after `mod_timer()` increases the reproduction ra=
te:
> >
> > --- a/net/sctp/sm_sideeffect.c
> > +++ b/net/sctp/sm_sideeffect.c
> > @@ -373,8 +373,10 @@ void sctp_generate_heartbeat_event(struct timer_li=
st *t)
> >                 pr_debug("%s: sock is busy\n", __func__);
> >
> >                 /* Try again later.  */
> > -               if (!mod_timer(&transport->hb_timer, jiffies + (HZ/20)))
> > +               if (!mod_timer(&transport->hb_timer, jiffies + (HZ/20))=
) {
> > +                       mdelay(1);
> >                         sctp_transport_hold(transport);
> > +               }
> >                 goto out_unlock;
> >         }
> >
> > Any feedback or guidance would be greatly appreciated.
> >
> > --
> > Best regards,
> > Tangxin Xie
> > =20
>=20

