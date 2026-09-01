Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B2FA302767
	for <linux-sctp@vger.kernel.org>; Tue,  1 Sep 2026 21:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788299213; cv=none; b=CrTgf/mef8Dr9uiulfOuBvgMPN4yeDpjou3WMPjLKO+WmmznHP0rOBZmO1pHmrbkQxUUq9dKFmLHHCqsbw1BMUz/hOAj87Ursu0hUWR07cRYmtlA68PQzKFJo9uNcTaqRwQF0H53oiB6wrkhiW43UYMLSKff1ioDUxd8F21f+1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788299213; c=relaxed/simple;
	bh=jmfSF6dxUryNe4T1LYMS8m4yFoccuA1A7bhBIUV88Uc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=upXPsfvp/iSnyO+ikU5yTMcKfWYw2Qd7idrhGxekidbLy9d8h9hPynzMBIBILLfgM/mu4u+cIxd2+H6uwjmjsUwRAntiLpscpHRJjKQ2I5bHftZLWmQbrzKAs9ORF7kAW0Wd6pZEiy6srD/znpOMF/2jYi442UUKzWa1S+xMGg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ONv9fX+/; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ONv9fX+/"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-484362f5c4aso359451f8f.3
        for <linux-sctp@vger.kernel.org>; Tue, 01 Sep 2026 14:46:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788299207; x=1788904007; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/krwhGVvNlFUK9rEUnuWIIMml0OFZGsSeO3Euc5tLjE=;
        b=ONv9fX+/WoRwyqbqvOkpLBHzYDrkNG0/nQf4aZ6vIZLA2tpSa7VyrbIwF6fzwKYmO6
         tbT0AN2aXZtJeFrnicf9RX3MJa+o3PaYWVgRmXg4m/zhNx1Jkw6pBuBdCyNuhVdhL1bM
         jVAS77yYtVblgZjhhWedFkkAloU13x90P5eIoSzNlhz+XMAZ4GsPYYleaZhiFE8ksndD
         LNS10Y5+AxXs71+Olnj3BRjEogzqkmFaSjiI1hn0Ty4pXoZDDdvM4M67cY0k4OMzNLwC
         ZM4M1sZOQ8Mqn1xyvpTXqPZ4/XyS3WEqLoG+4qgYK/Duef+f31z5fvU+yk+m+e03v2VK
         BKBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788299207; x=1788904007;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/krwhGVvNlFUK9rEUnuWIIMml0OFZGsSeO3Euc5tLjE=;
        b=eNqf1osY8BgLaHA9lB4+3yvYAqMtjzEE3/6QcMBrr6TsOXyehQ2CrgXxPoJPHSpZC/
         qt9wgMI8P/iU7Z5x8JS8DcKww+Ll5owdZUUwdbRZSSOYwxGb7SE/euy72jQub52GUiHB
         Al9uHmGZcx/CHaYou5/Qu18T++o9HljlYKwbg0mAw/fRVywdXi362BpOyulbPXrVnoL+
         sUOd7FtZ3AGcvNQtGi/khmOo8uQax03h/K/LWWXNGS9QkQSGka/c9mFttekaM69EQJ3e
         AmVFmEBmnoo8FVOcktXMesiygmbuyBSjrqjNONG9Pc3vRuyqFZCEumqmLaxRlxBvT/YU
         uskA==
X-Forwarded-Encrypted: i=1; AKwUvByIPEFy8unKZco4SCFYggNhw5UnxEAkqcDy+/aElzjTRsZgMb3+6RYdMLH1erh2GjF7oiMNL5516MFL@vger.kernel.org
X-Gm-Message-State: AFuF++l/c1yfU/4fWmeCkniQVr3fekY6zCSgLzmjTdn9vMgDGFRsvTyz
	mIvBjwyW0eplpt9R13pQqpnWFCSiqZ7qBVIAtCGwDcYmMOZwXjHhxEnl
X-Gm-Gg: AYBFou0vfeR6G9yZS9umhZsQ19336Ay4zT2QxptKbjYbK14waBA4D2pcZexZXRFrjM6
	g3tl9Qoo9M37XOotkDVTldLYwj+buyycGNqc2t8edTvUnL4j2FurFaOQE+C1MLr83nNYal2UNx3
	wMEza4OijAR00FsYTteVo+cAJOF2MIQx2py9AAsBSuXWMq2rVWQlImXR93laz7nbg6yxAV/8++u
	A7CGasUraQxUgJVOTE7vaT7zdQj8JpRxoyRBz9xq5gEWo+Wnz++qrhVvZX+4kU00uXCvCTmPRFO
	Ltrl7yZEcwTDgPVyaAxxqyP5D25G4C84vttgz5+6THhpuxLkjBxjTmICNHVtQM0GaUBDuhiGcRk
	vSyajw1ekMjEbmV3dJ44Oq7jHQlHms5pRXYmmJH3uEF/7iMNEHpSddOAry5mEV8CMESXsXHxUO9
	0HKt5d01y6hFvu3vE4pBrrMg3UouSRNfb4dLs8KkJBqt5rvEbciVF4Otbb7+13YORLYjEuF+PSN
	OuZS+0msxWvMiw3RsIsR6NgIg==
X-Received: by 2002:a05:6000:4a17:b0:482:a9d7:7ced with SMTP id ffacd0b85a97d-48488f1b24amr475206f8f.14.1788299206730;
        Tue, 01 Sep 2026 14:46:46 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48448e81718sm1739241f8f.16.2026.09.01.14.46.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 14:46:46 -0700 (PDT)
Date: Tue, 1 Sep 2026 22:46:45 +0100
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
Message-ID: <20260901224645.7c5bd2e6@pumpkin>
In-Reply-To: <CADvbK_esKpvPWK0xipKeiDr6KDiAL2_uPOhrREOMMVjJ_ndK7A@mail.gmail.com>
References: <6a7d8773.c5ad36c8.12f49d.002e.GAE@google.com>
	<68cb4941-3668-44f1-a889-6b2f023b2a08@h-partners.com>
	<CADvbK_eY4S1HbdNHuNq9b=Va-TA_6rNFvnCvtOUZ0sF-AWN67A@mail.gmail.com>
	<20260901153524.3e92df3a@pumpkin>
	<CADvbK_esKpvPWK0xipKeiDr6KDiAL2_uPOhrREOMMVjJ_ndK7A@mail.gmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 1 Sep 2026 11:06:31 -0400
Xin Long <lucien.xin@gmail.com> wrote:

> On Tue, Sep 1, 2026 at 10:35=E2=80=AFAM David Laight
> <david.laight.linux@gmail.com> wrote:
> >
> > On Tue, 1 Sep 2026 09:45:42 -0400
> > Xin Long <lucien.xin@gmail.com> wrote:
> > =20
> > > On Mon, Aug 31, 2026 at 11:47=E2=80=AFPM xietangxin <xietangxin@h-par=
tners.com> wrote: =20
> > > >
> > > > Hi,
> > > >
> > > > I have analyzed this issue and successfully reproduced locally.
> > > > The race occurs between the timer callback (`sctp_generate_heartbea=
t_event`) and
> > > > the transport cleanup path (`sctp_transport_free`):
> > > >
> > > > Task 1(Timer Softirq)               Task 2(sctp_transport_free)
> > > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D              =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > > sctp_generate_heartbeat_event()
> > > >   refcnt =3D 2
> > > >
> > > >   bh_lock_sock(sk)
> > > >   sock_owned_by_user(sk)
> > > >   mod_timer(&hb_timer) -> returns 0
> > > >                                           sctp_transport_free()
> > > >                                             transport->dead =3D 1
> > > >                                             del_timer(&hb_timer) ->=
 returns 1!
> > > >                                               sctp_transport_put() =
(2 -> 1)
> > > >                                             sctp_transport_put() (1=
 -> 0)
> > > >                                               sctp_transport_destro=
y()
> > > >
> > > >   sctp_transport_hold() =20
> > > >     -> refcnt is 0, increment fails =20
> > >
> > > This should not be 0, as the transport must hold a refcnt to start the
> > > hb_timer. =20
> >
> > Isn't there one hold sctp_generate_heartbeat_event() and a second for
> > whatever 'task 2' is doing. =20
> Right,
>=20
> > When hb_timer is started it is given another hold (does it actually nee=
d one??). =20
> You mean mod_timer() in sctp_generate_heartbeat_event()?  Yes, as it will
> release the last one in out_unlock, it must hold a new one.

But can that ever be the last 'hold' that actually calls sctp_transport_des=
troy().
It the timer is always deleted (as task 2 above) it doesn't need one itself.
Might need to be del_timer_sync() so that it waits for the completion funct=
ion
to terminate.

>=20
> > So when hb_timer is deleted it's hold is removed.
> > But the del_timer() is happening before the the extra hold is obtained.
> > =20
> Ahh, I can see the race now.
>=20
> I remember you mentioned holding it before mod_reduce() in a previous
> patch, maybe it will work here, like:
>=20
>                 sctp_transport_hold(transport);
>                 if (mod_timer(&transport->hb_timer, jiffies + (HZ/20)))
>                         sctp_transport_put(transport);
>=20
> Does it make sense?

That should close the timing window, but is probably inefficient.
Rather depends on how often the 'put' ends up being done.

David

>=20
> Thanks.
>=20
> > The RHS (task 2) would need to hold bh_lock_sock().
> >
> > Try giving sctp_generate_heartbeat_event() two holds.
> >
> > David
> >
> > =20
> > >
> > > Also, the delay below is under bh_lock_sock(), so it should not be the
> > > real cause of the issue.
> > >
> > > Could you share the PoC for this issue?
> > >
> > > Thanks.
> > > =20
> > > >   out_unlock:
> > > >     sctp_transport_put() (0 -> -1) =20
> > > >     -> refcount underflow warning! =20
> > > >
> > > >
> > > >
> > > > Adding a small delay  after `mod_timer()` increases the reproductio=
n rate:
> > > >
> > > > --- a/net/sctp/sm_sideeffect.c
> > > > +++ b/net/sctp/sm_sideeffect.c
> > > > @@ -373,8 +373,10 @@ void sctp_generate_heartbeat_event(struct time=
r_list *t)
> > > >                 pr_debug("%s: sock is busy\n", __func__);
> > > >
> > > >                 /* Try again later.  */
> > > > -               if (!mod_timer(&transport->hb_timer, jiffies + (HZ/=
20)))
> > > > +               if (!mod_timer(&transport->hb_timer, jiffies + (HZ/=
20))) {
> > > > +                       mdelay(1);
> > > >                         sctp_transport_hold(transport);
> > > > +               }
> > > >                 goto out_unlock;
> > > >         }
> > > >
> > > > Any feedback or guidance would be greatly appreciated.
> > > >
> > > > --
> > > > Best regards,
> > > > Tangxin Xie
> > > > =20
> > > =20
> > =20
>=20

