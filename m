Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 639144B2CC6
	for <linux-sctp@vger.kernel.org>; Thu,  3 Sep 2026 14:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788444048; cv=pass; b=F3COVtyBW2kLHXZULf1f8xbg/4jPo4ASNGAyDcGhuHchA/X/1ETdAca1j1qWCTkMsRIQsi0Pn+vLSR1CopiBfNINtCL31MT+4FZWe1oodu2tS/wYiilmxYKs3bl43hsO7CU3V9qNJR1b3mjN0HxRvlRCiEeXzG6E/x7OSix30Ks=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788444048; c=relaxed/simple;
	bh=d+nV/y5gzHZQbqpaWid3gzG6rgbMOVarLaEROjaG5PM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DXpVgxCY/an/v56huo3BeethQeRjfl/vKGkEjt24c7KBs6jU3WX/u4mnsvhgwyc0HENuQ/7+laZkR2lBm0sYnq0BQdIAaStnYXNnfixveegjOcCYnKnttuz1nHYV5g7zjtwP8f62/NLmN+cx0IBDRFa0CJhIGl1PkU/7xOsgrjI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=r8p5L1OD; arc=pass smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="r8p5L1OD"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-8534d507f59so3035709b3a.0
        for <linux-sctp@vger.kernel.org>; Thu, 03 Sep 2026 07:00:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788444039; cv=none;
        d=google.com; s=arc-20260327;
        b=CsE2T5ZX50IpXjSbs7amKMTKlPl5cLLwd/zU1B8qoZIds3frAs5rll3h/mIIqmIVqI
         8bxnsiZdTpip/KLze/AR/1Fi+0xqNRDnB0BSRkUfLuEIeYkheCJEbzs+xpXOQB3zdKJF
         tKrvR4yhszVTfoRMkbYaeOSNhZDVjW/vYuiVbB6lPuyUUy11aGJC1AAQwU1rVtrH8CUx
         hB2cK55h+hZBO+rlGtAc7NBrnjjLNkKjCWn8w393USe5gVhD7x9UViA3ZzptAwBR+C4G
         kmhi1JFNTavQ8TP3kPL+/YyzCiHnrxXUToU2gqFfEXz3rXWchNPAa74mQMMRhnElmaCe
         jALQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=EZlAVxnc61vhxXdUOKLatLp9Jvhf8iA3Pl5Y4/hX8c0=;
        fh=zGt3DpZqjitw+WXx8dyG8W0O5yKxr+1Wfhp/vI3+9V0=;
        b=Gk3Jpl6tiTlP2DQSW46rKJOiVV9J/is9XScnggTBKkSP+851nGaqwXRrgJZmOAuswO
         KwuLhPDMhqupe+OkO1h6J1biC1boQEiHjXXaywLxxDU9aL+fTPm4SjW/xBNzcmT+6L7G
         DdCLUu/MY8zhnL8wPyWFyPf+laWf1c2W+CGxJaTkt0UA6u7Y4o2F45LymMgcZI6DTD1B
         xrcSMvxsdy6gcwAswg/HG+w5S92/Xq0L9VARw5ptJOJwxJkbVIakPCbZbygisd31cJWD
         SxLmszEaMRu/c6fBVlG1F8BIqTxTsUcP8eLU96mcJbx05P4VJugC6OfLPndF3CUWuPZC
         w2gQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788444039; x=1789048839; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=EZlAVxnc61vhxXdUOKLatLp9Jvhf8iA3Pl5Y4/hX8c0=;
        b=r8p5L1OD1zg2BEvoWoFE6FQelMcJX4eTXDhsmg8c4+zW9SFVHqTMj460yDYBK9546Y
         EZOVuowRo6oSWMcJBSxiIIrKdUwDgRMxQfVK83+v54CGvvmjSBee4yUsW+WwNtNRIO7l
         didwu6gogazquktaeH4IHhe2udrlidgvPZ4yAzu+wK8GVNauEe6DAxF1LMPR0r/JRD8L
         6rhaLKwktFgSGat8Lf701vYST43eJeh2XcL4oqHeFtc9T28ErP5jWV61jrElGdhIxI5p
         XdJVaWqO82yPTVsHPf2cuT0IEiwhh4P/NqziedbtcN7XhfbC3E0nCCMqNDSlvZOfUKxo
         fF9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788444039; x=1789048839;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EZlAVxnc61vhxXdUOKLatLp9Jvhf8iA3Pl5Y4/hX8c0=;
        b=sccs9ui9DEDIhMOyMkvcINYCFn+Ss3LEb7chME7dVtTgrr4lNM1SjwgeWo1w8lWnlg
         cfGabu6WuLCNXyrs5AxwUDsT5FQRCYScB4RLZOyBOpmYZZhuXd9+xsOX3beaplFUgePB
         bsj5zShsYNm5OENOLZFH8xoKl9P3FaWr3KG8IWF9FCOcc9MYRFZ7UVDT9q7kKyVMRFPZ
         C2LYEEHHDMx+R0rfrjyZpd1nPN6xPlImUbaV/uCP2TuqvAez5evyvyae3A0epT+jyLAD
         Ko6E9FYZJJM+xJmRWuouVEIBvbAaquLwdzrUYN2m0jqbgDWalC0t69QCDM7lQdhXT4aN
         K/Iw==
X-Forwarded-Encrypted: i=1; AKwUvBwKg3QeMLxZ2JT4l02WY9hCTloBOHmH/UD/KIzimJF0VN+HHCEMoE7NEoWPYDs4jvN/ZYEaXagQE39o@vger.kernel.org
X-Gm-Message-State: AFuF++mXLsTVnJTIfos4ahpuwVX5vLm0owZkAImHNG7TPquaGrpxHTMU
	vYkN7K0WDvTW7ae+jTIQWPojjK95CAQKRjCba9nbYDMS2Ccal/dc1EyQ7joSBlkr4T0G+zqpMeO
	k6Q+w/QKq9COqxFzysCKcRXzFIJNPoxDblMzh
X-Gm-Gg: AYBFou0Ha5gWH3ETOIFh9Rql6AmQ17Pg1npKk5O2xt8C3qffZhGWeW4CYbuEVysoaRT
	YVgsU7ZFUtSXEJjiEGA2dPNPejUYuO+wo1bJW4PT2t2JnPC3YF1qMdvIIyWVQGs8zbQ0ARilyJB
	yOLcHy+eNw/v8pVR8Zh85cmJucDOehkTS8TKXBzWNgdZO3Qa/yOHs0P5K+40mMXWYtECvUWXYQn
	Ng6GVHjGqolxE1x6vr7fl9uDTkC8ryFdOK0cFVZhUpw/tZxDCXjt+Qi+ufnVcKSrZL5OoKP3aOZ
	NZ44quff+nw02+Qi5xzkSjota4KJYFuGxo0TsgDWLFJ2nWK/O0ozu08Neb7qhbzcx2xVY00qbtI
	Y5sSg6s+dZCmTVwivpuKitDTfdrEDVrqrxoEMmArR+U0b
X-Received: by 2002:a05:6a00:88a:b0:848:56ff:6ced with SMTP id
 d2e1a72fcca58-85ed7d20475mr15597002b3a.8.1788444038911; Thu, 03 Sep 2026
 07:00:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <6a7d8773.c5ad36c8.12f49d.002e.GAE@google.com> <68cb4941-3668-44f1-a889-6b2f023b2a08@h-partners.com>
 <CADvbK_eY4S1HbdNHuNq9b=Va-TA_6rNFvnCvtOUZ0sF-AWN67A@mail.gmail.com>
 <20260901153524.3e92df3a@pumpkin> <CADvbK_esKpvPWK0xipKeiDr6KDiAL2_uPOhrREOMMVjJ_ndK7A@mail.gmail.com>
 <20260901224645.7c5bd2e6@pumpkin> <057c057f-be11-4bf7-9403-f454bb2864c9@h-partners.com>
In-Reply-To: <057c057f-be11-4bf7-9403-f454bb2864c9@h-partners.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 3 Sep 2026 10:00:27 -0400
X-Gm-Features: AcwNN1XUrJ_FTmvwVEbrN9-ZuqD8a_Bm6_RE7fP6GlRGhmJiGfJcoIWsRw_q3mI
Message-ID: <CADvbK_eBx0AicxxWXE1ZOqeNUJtU2YPgTynthBkhq3_1jks9iw@mail.gmail.com>
Subject: Re: [syzbot] [sctp?] WARNING: refcount bug in sctp_transport_put (6)
To: xietangxin <xietangxin@h-partners.com>
Cc: David Laight <david.laight.linux@gmail.com>, 
	syzbot+80dfcb1a2235b3efc877@syzkaller.appspotmail.com, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Simon Horman <horms@kernel.org>, Jakub Kicinski <kuba@kernel.org>, marcelo.leitner@gmail.com, 
	Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org, 
	linux-sctp@vger.kernel.org, netdev@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com, gaoxingwang <gaoxingwang1@huawei.com>, 
	huyizhen2@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 2, 2026 at 11:23=E2=80=AFPM xietangxin <xietangxin@h-partners.c=
om> wrote:
>
>
>
> On 9/2/2026 5:46 AM, David Laight wrote:
> > On Tue, 1 Sep 2026 11:06:31 -0400
> > Xin Long <lucien.xin@gmail.com> wrote:
> >
> >> On Tue, Sep 1, 2026 at 10:35=E2=80=AFAM David Laight
> >> <david.laight.linux@gmail.com> wrote:
> >>>
> >>> On Tue, 1 Sep 2026 09:45:42 -0400
> >>> Xin Long <lucien.xin@gmail.com> wrote:
> >>>
> >>>> On Mon, Aug 31, 2026 at 11:47=E2=80=AFPM xietangxin <xietangxin@h-pa=
rtners.com> wrote:
> >>>>>
> >>>>> Hi,
> >>>>>
> >>>>> I have analyzed this issue and successfully reproduced locally.
> >>>>> The race occurs between the timer callback (`sctp_generate_heartbea=
t_event`) and
> >>>>> the transport cleanup path (`sctp_transport_free`):
> >>>>>
> >>>>> Task 1(Timer Softirq)               Task 2(sctp_transport_free)
> >>>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D              =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >>>>> sctp_generate_heartbeat_event()
> >>>>>   refcnt =3D 2
> >>>>>
> >>>>>   bh_lock_sock(sk)
> >>>>>   sock_owned_by_user(sk)
> >>>>>   mod_timer(&hb_timer) -> returns 0
> >>>>>                                           sctp_transport_free()
> >>>>>                                             transport->dead =3D 1
> >>>>>                                             del_timer(&hb_timer) ->=
 returns 1!
> >>>>>                                               sctp_transport_put() =
(2 -> 1)
> >>>>>                                             sctp_transport_put() (1=
 -> 0)
> >>>>>                                               sctp_transport_destro=
y()
> >>>>>
> >>>>>   sctp_transport_hold()
> >>>>>     -> refcnt is 0, increment fails
> >>>>
> >>>> This should not be 0, as the transport must hold a refcnt to start t=
he
> >>>> hb_timer.
> >>>
> >>> Isn't there one hold sctp_generate_heartbeat_event() and a second for
> >>> whatever 'task 2' is doing.
> >> Right,
> >>
> >>> When hb_timer is started it is given another hold (does it actually n=
eed one??).
> >> You mean mod_timer() in sctp_generate_heartbeat_event()?  Yes, as it w=
ill
> >> release the last one in out_unlock, it must hold a new one.
> >
> > But can that ever be the last 'hold' that actually calls sctp_transport=
_destroy().
Sorry, by =E2=80=9Crelease the last one=E2=80=9D above, I meant releasing t=
he previous
=E2=80=9Chold.=E2=80=9D

If the hold succeeds after mod_timer(), it can never be the last/final hold
that calls sctp_transport_destroy().

However, in the current code, there's a window between mod_timer() and
sctp_transport_hold() at [1], sctp_transport_destroy() can be called
to  delete the newly enqueued timer and release the previous hold.
The hold at [2] for the newly enqueuing has not been taken yet.

  if (!mod_timer(&transport->hb_timer, jiffies + (HZ/20))) {
          mdelay(1);  /* [1] */
          sctp_transport_hold(transport); /* [2] */
  }

> > It the timer is always deleted (as task 2 above) it doesn't need one it=
self.
> > Might need to be del_timer_sync() so that it waits for the completion f=
unction
> > to terminate.
> >
Unfortunately, del_timer_sync() can only be used in sleepable contexts.

> >>
> >>> So when hb_timer is deleted it's hold is removed.
> >>> But the del_timer() is happening before the the extra hold is obtaine=
d.
> >>>
> >> Ahh, I can see the race now.
> >>
> >> I remember you mentioned holding it before mod_reduce() in a previous
> >> patch, maybe it will work here, like:
> >>
> >>                 sctp_transport_hold(transport);
> >>                 if (mod_timer(&transport->hb_timer, jiffies + (HZ/20))=
)
> >>                         sctp_transport_put(transport);
> >>
> >> Does it make sense?
> >
> > That should close the timing window, but is probably inefficient.
> > Rather depends on how often the 'put' ends up being done.
> >
Each timer enqueue must have a corresponding hold. As long as we take the
hold before enqueueing the timer, there is no race.

> > David
> >
> >>
> >> Thanks.
> >>
> >>> The RHS (task 2) would need to hold bh_lock_sock().
> >>>
> >>> Try giving sctp_generate_heartbeat_event() two holds.
> >>>
> >>> David
> >>>
> >>>
> >>>>
> >>>> Also, the delay below is under bh_lock_sock(), so it should not be t=
he
> >>>> real cause of the issue.
> >>>>
> >>>> Could you share the PoC for this issue?
> >>>>
> >>>> Thanks.
> >>>>
> >>>>>   out_unlock:
> >>>>>     sctp_transport_put() (0 -> -1)
> >>>>>     -> refcount underflow warning!
> >>>>>
> >>>>>
> >>>>>
> >>>>> Adding a small delay  after `mod_timer()` increases the reproductio=
n rate:
> >>>>>
> >>>>> --- a/net/sctp/sm_sideeffect.c
> >>>>> +++ b/net/sctp/sm_sideeffect.c
> >>>>> @@ -373,8 +373,10 @@ void sctp_generate_heartbeat_event(struct time=
r_list *t)
> >>>>>                 pr_debug("%s: sock is busy\n", __func__);
> >>>>>
> >>>>>                 /* Try again later.  */
> >>>>> -               if (!mod_timer(&transport->hb_timer, jiffies + (HZ/=
20)))
> >>>>> +               if (!mod_timer(&transport->hb_timer, jiffies + (HZ/=
20))) {
> >>>>> +                       mdelay(1);
> >>>>>                         sctp_transport_hold(transport);
> >>>>> +               }
> >>>>>                 goto out_unlock;
> >>>>>         }
> >>>>>
> >>>>> Any feedback or guidance would be greatly appreciated.
> >>>>>
> >>>>> --
> >>>>> Best regards,
> >>>>> Tangxin Xie
> >>>>>
> >>>>
> >>>
> >>
> >
>
> Hi Xin, David,
>
> I have a syzkaller execution log that can trigger this issue.
> Please let me know if there is anything else I can do.

Hi, Tangxin,

Can you try if the change below will fix the race?
(You may add mdelay() back for reproducing)

diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
index 94716406d602..c0fddd5e8097 100644
--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -378,8 +378,9 @@ void sctp_generate_heartbeat_event(struct timer_list *t=
)
                pr_debug("%s: sock is busy\n", __func__);

                /* Try again later.  */
-               if (!mod_timer(&transport->hb_timer, jiffies + (HZ/20)))
-                       sctp_transport_hold(transport);
+               sctp_transport_hold(transport);
+               if (mod_timer(&transport->hb_timer, jiffies + (HZ/20)))
+                       sctp_transport_put(transport);
                goto out_unlock;
        }

Thanks.
