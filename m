Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2CEE412C0F
	for <linux-sctp@vger.kernel.org>; Tue,  1 Sep 2026 15:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788275205; cv=pass; b=YVpk4dCxzkKReWl6Sv87khdp8yTS8tWSz3xUcbDDo9eLgQ9yOonJm6VjLdcrI9pyY/FdPPOfFOVxWLULc72UKW4pwtfBvWbnymb5g+2uRayzI90kisUVkx8GfMpTdX1bst2StIkXsRi4if+BaUf8ncgsWk56iEuPOcl2ULQ6sp0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788275205; c=relaxed/simple;
	bh=4+HIZ4Q5IIrpnindsFnWn35HmY9FmNfg/yZtpPmaAQY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HbSF0wnsqEiECi1b/s1X7V4lj+5Roy88XSGIt9ccaNYPoEUO9F5E1mjigVV9QCpCzT+lL/caygXJbJxWSA+bn/VY7dx7U9Qwntnzrp11aVn1ZINd0e0Ds57gixni872APH2LXLDgMtwUjdq+BYWMQS4u3UpM1LHKt+mBWBrzIkE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TY2Abr0o; arc=pass smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TY2Abr0o"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-851cbd64814so2425871b3a.1
        for <linux-sctp@vger.kernel.org>; Tue, 01 Sep 2026 08:06:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788275203; cv=none;
        d=google.com; s=arc-20260327;
        b=aeYXbA61yY2HvRnWxxcvp10hPsT2TRJPIhBgw664s+KTnjgPY70jCq+RZ4Zlui6MDC
         xvMRUNC++Zye0va/GtzFnnWkStRgwWd9YxeFyTZjlJHKPl4lLaYGk8Q2Aw9DtSWWtkfG
         yM5PBhqj3s00Br8+PGQJbrftEZD5thyhcnZNXJ0odJeCEPEvpR6oHXf3O77A+DKqm+MM
         g9vK3n6DNzBX4qLv4llRtR+lBujzJ50RycMJQyojqKAheQgv3dc1dyRTAg3oVJ4I3Rsi
         6iw4cQzCUSOMS0EjlvXJElE/E8bs4DWiRNwsrv90d9dCWXgwVNQBETa0efgzOOAoT7so
         HnfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5uGLU8oCfbV8VIHqIo2ClQTYY5+lTlorDlDnLTyOTzY=;
        fh=X48lu1eAHl3d0YIqRjQD2Hg2lrdeFina8u8yThmzOTQ=;
        b=Fir3p7p+OxN4OK5V3jBNjj1RCjBWQKBenhMv/KZVAgDSiB1ucphwqPYkOEQQy5UZT8
         ilz7U7tih/QP5fgpqL4XxEKD7npodkRng2eMPhDL2P8+F85wZ0POVKBng8GQOVJiXrEe
         XblOBtXioclt4v0iUXj4v99i2UmbZXctFLU+Dc4rilKVDA8B/ief3f0CGw3aDAR8foE8
         q17kYCZloTOa2+U2kv9SIdgsNM7sf28+FrYyF2OdONeQamGHhrNlFdLzNmK13PFq3rk6
         1dygmB4Jom+ZRmWTJus+w+N9XEHDzNgT5OmVR+nu3vfJls/p/Dp8ASLfeOHlg5ZqdryD
         7KDg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788275203; x=1788880003; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5uGLU8oCfbV8VIHqIo2ClQTYY5+lTlorDlDnLTyOTzY=;
        b=TY2Abr0oQout+xARnahnvunuRPGpdGWoItGL/AvegbvEOWMuvEODSewe4nwRgoZpia
         94FYxkhKX06v6x8jzko0+9MBTPZ0zhZgGYk4qDBJKBrxvaF1TdsTOfV6JtWJ3flI3zRr
         NyDnHVegkDOgLnKuj8WPzSgad4PqW6msi4JO7lc2EVOa6s3XGLFuDvIa71bVSl3pSaI2
         Dm8geBAE0JAXt488GA3daN8tJ2ET6ZcTPQsDBtySXVl7/Ugq89TIExsbLG2BlqU1FJTe
         V7ZuM6wepKCsrrL/z4+5dxA0YP3TKCYVV47fI4jhGN2sQpy6WRh2wv0F2dIOF3DxPqQ6
         OJXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788275203; x=1788880003;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5uGLU8oCfbV8VIHqIo2ClQTYY5+lTlorDlDnLTyOTzY=;
        b=LNV6cCGPMqt+NYz523v3BbbDTXmPVhHrl+lnCoBa/xjVc1fxXujtffVSI4zpohCQ51
         Fe0ZyZwjMDvCGT983g6T1n4jlkPXIf/UNfDvsY/xyK5DzauURBlkVRzdOI1A7542O8HL
         8vIT9M8j9YmujBLCEnx56cZOX4Cy2e60j6zzf8NZ4+VgfPBaz9ISwLquQgl5x9Fz/xHW
         O+Gj+5x15hvPxRruTCWG+D395aqWKoC2E7dk2EA7DogbqzxDi3uPZjh+OFU2fqtQvW4p
         ODNCPNocVYoHH5KKNPh0oEDMdVGqNXtJdq9FEdHbzpU7XoyzB+hB8G6nIm1wpwoVOOBm
         xAgw==
X-Forwarded-Encrypted: i=1; AHgh+RoXaHBhSeMuRKx5EP2er+BoKx01qzedWrUNQg9eHciWDnIuWYaBB+Ny5DQYClCrf7msr/MvXl9U6wFI@vger.kernel.org
X-Gm-Message-State: AFuF++kGZW300vfRWSyBMAmRuzUuWIgFmdVxYGF89PLrt9BMJa9nnpKy
	nXAt4MYdg3oo/jwutlCh1RlygGH+Me7AvFr9BeVOeOVNEgZu5DTSZ0iha4EcvNDKAaJbJEabnkH
	Z1OsfkEVXBPvsL+2ZM/55NcLhu8KNuUY=
X-Gm-Gg: AR+sD11LRTZS1CEaV1vE9jf2Ee9P3LKhLbbC7cgXUvWQC+83BcZKcpAPhF1E6H67uOU
	ykzLotJ4Q+CPIDYb2AqcqPHI+Dmg9p7v1IIAkjz4yF6hbhbZP/osLrawI3HximC98GWJmw3B207
	HR6J5oLsp82GSq/HwTPEMUOA0SPMYwUrccZ8K5r57vyGaWl4ghK9XKXP3alyxtoN2WnBSu9X1R0
	q23h1KODzL42874AS9IQBzsKPk3ZmykRxkzP6pdEKAWwthxLa1CNoGhN/Bw/gn5c2HVYVgbDmRU
	DynuQohGpMh1rSlIy/l+nTAXjq9LrNnjB454sanC8OkwTAXeVcoQvJk7DymuArPsan3pD7jrXMO
	d1ef6VuMQcOzk3QfZbGUZHaZReX5YlVOU0dysHsRHJroX
X-Received: by 2002:a05:6a00:1143:b0:842:2419:6bfe with SMTP id
 d2e1a72fcca58-8562a1f7635mr48366362b3a.7.1788275202771; Tue, 01 Sep 2026
 08:06:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <6a7d8773.c5ad36c8.12f49d.002e.GAE@google.com> <68cb4941-3668-44f1-a889-6b2f023b2a08@h-partners.com>
 <CADvbK_eY4S1HbdNHuNq9b=Va-TA_6rNFvnCvtOUZ0sF-AWN67A@mail.gmail.com> <20260901153524.3e92df3a@pumpkin>
In-Reply-To: <20260901153524.3e92df3a@pumpkin>
From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 1 Sep 2026 11:06:31 -0400
X-Gm-Features: AcwNN1U9hNLddzkdHknmS9iBL9g_3nFvkL-mCp26Qy2kZ2_LJCi6sU3R5oK_nX8
Message-ID: <CADvbK_esKpvPWK0xipKeiDr6KDiAL2_uPOhrREOMMVjJ_ndK7A@mail.gmail.com>
Subject: Re: [syzbot] [sctp?] WARNING: refcount bug in sctp_transport_put (6)
To: David Laight <david.laight.linux@gmail.com>
Cc: xietangxin <xietangxin@h-partners.com>, 
	syzbot+80dfcb1a2235b3efc877@syzkaller.appspotmail.com, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Simon Horman <horms@kernel.org>, Jakub Kicinski <kuba@kernel.org>, marcelo.leitner@gmail.com, 
	Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org, 
	linux-sctp@vger.kernel.org, netdev@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com, gaoxingwang <gaoxingwang1@huawei.com>, 
	huyizhen2@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 1, 2026 at 10:35=E2=80=AFAM David Laight
<david.laight.linux@gmail.com> wrote:
>
> On Tue, 1 Sep 2026 09:45:42 -0400
> Xin Long <lucien.xin@gmail.com> wrote:
>
> > On Mon, Aug 31, 2026 at 11:47=E2=80=AFPM xietangxin <xietangxin@h-partn=
ers.com> wrote:
> > >
> > > Hi,
> > >
> > > I have analyzed this issue and successfully reproduced locally.
> > > The race occurs between the timer callback (`sctp_generate_heartbeat_=
event`) and
> > > the transport cleanup path (`sctp_transport_free`):
> > >
> > > Task 1(Timer Softirq)               Task 2(sctp_transport_free)
> > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D              =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > sctp_generate_heartbeat_event()
> > >   refcnt =3D 2
> > >
> > >   bh_lock_sock(sk)
> > >   sock_owned_by_user(sk)
> > >   mod_timer(&hb_timer) -> returns 0
> > >                                           sctp_transport_free()
> > >                                             transport->dead =3D 1
> > >                                             del_timer(&hb_timer) -> r=
eturns 1!
> > >                                               sctp_transport_put() (2=
 -> 1)
> > >                                             sctp_transport_put() (1 -=
> 0)
> > >                                               sctp_transport_destroy(=
)
> > >
> > >   sctp_transport_hold()
> > >     -> refcnt is 0, increment fails
> >
> > This should not be 0, as the transport must hold a refcnt to start the
> > hb_timer.
>
> Isn't there one hold sctp_generate_heartbeat_event() and a second for
> whatever 'task 2' is doing.
Right,

> When hb_timer is started it is given another hold (does it actually need =
one??).
You mean mod_timer() in sctp_generate_heartbeat_event()?  Yes, as it will
release the last one in out_unlock, it must hold a new one.

> So when hb_timer is deleted it's hold is removed.
> But the del_timer() is happening before the the extra hold is obtained.
>
Ahh, I can see the race now.

I remember you mentioned holding it before mod_reduce() in a previous
patch, maybe it will work here, like:

                sctp_transport_hold(transport);
                if (mod_timer(&transport->hb_timer, jiffies + (HZ/20)))
                        sctp_transport_put(transport);

Does it make sense?

Thanks.

> The RHS (task 2) would need to hold bh_lock_sock().
>
> Try giving sctp_generate_heartbeat_event() two holds.
>
> David
>
>
> >
> > Also, the delay below is under bh_lock_sock(), so it should not be the
> > real cause of the issue.
> >
> > Could you share the PoC for this issue?
> >
> > Thanks.
> >
> > >   out_unlock:
> > >     sctp_transport_put() (0 -> -1)
> > >     -> refcount underflow warning!
> > >
> > >
> > >
> > > Adding a small delay  after `mod_timer()` increases the reproduction =
rate:
> > >
> > > --- a/net/sctp/sm_sideeffect.c
> > > +++ b/net/sctp/sm_sideeffect.c
> > > @@ -373,8 +373,10 @@ void sctp_generate_heartbeat_event(struct timer_=
list *t)
> > >                 pr_debug("%s: sock is busy\n", __func__);
> > >
> > >                 /* Try again later.  */
> > > -               if (!mod_timer(&transport->hb_timer, jiffies + (HZ/20=
)))
> > > +               if (!mod_timer(&transport->hb_timer, jiffies + (HZ/20=
))) {
> > > +                       mdelay(1);
> > >                         sctp_transport_hold(transport);
> > > +               }
> > >                 goto out_unlock;
> > >         }
> > >
> > > Any feedback or guidance would be greatly appreciated.
> > >
> > > --
> > > Best regards,
> > > Tangxin Xie
> > >
> >
>
