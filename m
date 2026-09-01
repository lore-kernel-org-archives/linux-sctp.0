Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEFAD3B71D8
	for <linux-sctp@vger.kernel.org>; Tue,  1 Sep 2026 13:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788270356; cv=pass; b=oBzFn7jdkNrk2Q5Mpmi9IUxOfWgNYrtxgESHvDE3NjlP5xoGAXDD/T2WoUbdrMaPuNCvH9jXSYOCrvDSgx1Dli0f9FZ3ozPxAS/3lYwdY5izfMCJbniUlujW7g8g8OIh0C9v/ErWN0LNWzU3tpvRZNngfQuRdTq8F3F/wX1AIdk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788270356; c=relaxed/simple;
	bh=tKDbMMYPaNcmLVO2tAPonX0ljJNkNnM7cJ7pRD/D8BU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QORZqVuvYFloxqwFSm5UdTTEQ2wSrobpfk4hPiZNeOciPuzrJ4T1OAxNkYuqdNOJSrAKtUxwRrl4RheHwWmdLQ1TGx02s5zYoicpI/QuiBSlDXfZUrK+i+/RidNX9Vuyl90qfHJ/lVNwfbIToG/hgAGH03d8xM2HwSfw/84X6FI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=p19Ux4+A; arc=pass smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="p19Ux4+A"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-8568e3ed034so775637b3a.0
        for <linux-sctp@vger.kernel.org>; Tue, 01 Sep 2026 06:45:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788270354; cv=none;
        d=google.com; s=arc-20260327;
        b=gZhdq1yNinlt/XsDNfy2f/M9bH0YmfhRNkcKsoxMTvvAqitDrdvis6IpPemtQZX3Wj
         E/pywlyOWAtQ9zbfNxXEIv1R92DT9RnNtrtjSMJ2cEEFii8vcsD6qJf4f5DqnxPacJNc
         0IfALhZH1geScrc+KBWfgI+UcUQJ8d1dmrMlZ0JINseCN/yyGa8Y4FqludL7kntl4k7R
         6Q4ekRV030hPVQ2Gg1omw0dVlZR+pVlznp4IraQXx9bUsqBS5PJKG5zDgE4ChgCKXK5q
         SvhlpX73sZIgqv3hsjaUDKJ79ZAkNJ7PDxgnilrIDZXLxjac49CGIQdKvKjGy8Djsj8y
         m/oQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2cbbAFC+L3aZiwOHrWcyMK0kiQRKZziM6pyyIH5XpR8=;
        fh=Cm9iOF0xYqBMoJphlvRMJg90v3cPvW5nAqjYuhhI/Ig=;
        b=ORJV3johUaYgo+31zosFwfglKDARr8J08PQ44DlBYfa/npPkLgZk9oUzjE91NfB3//
         WqGEnLmKZ358/kvD2G4OrqUOM0aoTFnVAiZCMAIXNNuAXh69/LncM11s0CF3rjz/rZiv
         FN+OuFyYWZht4yH3gTHg/8ccbIQzvEByvqi0Z76CBNak2RNyn24b65vWkjvUQCB1TUkf
         s4aw3JCxJ9GPXaGf8SOf2l6IKtiR64KAUj5b8sJx3NixQ0cipoRshWJPHCa23Ejten5g
         izABHo8Ohxfy5+j9dyRn63T1D1k66+eMgH4+yfScdqnHOGGhQJPegohnmbiPb2fKgMXo
         f1jg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788270354; x=1788875154; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2cbbAFC+L3aZiwOHrWcyMK0kiQRKZziM6pyyIH5XpR8=;
        b=p19Ux4+AIz9zm+mK6ME3VWxsjulezrSOBl/G4hum6mIVNhfP1QBGtJLbO5WfDxlcCi
         OsWginCRDOkTt/Zpbw9B/QZzi5voytUVrzcv5Dwn0S0n1/AsOOYt5KinpdBDdcfPpfsV
         m2JVD0X3d0vhkbC4TwoRE3GRw9tnzbpBFDz9KueWtW+eE3TpAnDmsDO6uPMgs/cYv5mC
         2yatkeUmGi3pb8USsL1UtayNvzAuxc9+EDxi8ez+viuG/U5vDaF/COzlRbSH5B8agOKh
         9DR78R1vya7RMStOugohc/sf/RB/qN9zqZGQtPs6p2hs5l0skc7MMkbrnS4uq1KwWtI/
         TDnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788270354; x=1788875154;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2cbbAFC+L3aZiwOHrWcyMK0kiQRKZziM6pyyIH5XpR8=;
        b=Ffhg6izCQTiUXzhY0a4eInaGPRRuqgBUKXZ+bmQyD2oe3zkdS2UKa8qDMUMNJTumwD
         ogZ5CpR51PpnfuICrpmJCtg51zxf1AP2t7XUdM/+8HMOlfhqgrwSEtY7DI9WziejgUs4
         H9H0QQvKBfvFzeSHW98mObFXdiaMepKtS2ma64I57+KUohnQ9tT5r97dkjjWUafWSkp9
         lRWTdWsMcnP70VSOgBOYHhb3TeectjKKO/hJxoc2BL5qkjQ4E9/nUi49XftWfXkj25vi
         6JDSu0jtxCn/tADNIxc7a3kCuBdiYTH1/EZepMVoamPFEm2hZmr/ZnLETPgtgX938CID
         QRWw==
X-Forwarded-Encrypted: i=1; AHgh+Ro8PLHRuGyAnZT9YfaRCesalhr6Bjzdzc2zngXVksRgLiXSHxe6gpte0dhETEJApvBLLykNBwq87pbQ@vger.kernel.org
X-Gm-Message-State: AFuF++nlQDXIi73rMut1xlE9F6+Q2EzWlN2qWvpd6Un+4AiNwKhSnD2d
	VCwnpN36ds3KW9gZAqo9I1P8Ts818nNPvpsGpXbggTdDJfK7iiM/SkEt08NtbH3K3RSzjUcHTNG
	se0tUG5XLQ63UU+X8hu1Lco8vNSTsAvI=
X-Gm-Gg: AR+sD10q5A6ZkEeBTE5Yfvu/h7r3bjWx69hQr44gUtD7y4l7fYnzZeEEd9yxz8gaFFR
	peMrZ1vp8GtRBrWOfSNOVJt9qX7tEPlY7kdnJqtoaYAFEj+Zb5UnnfdyIK8Q8jJmDoF8bhp7vlo
	TEjbp/c+t0WzqRXRl9y2LCaoZ1UZGhAm0jkYOD4PJ81pqWdC8pYnecYvT/6RzAGJTzsluq1xAyF
	K0Cbs3JIP31G8su89bLeiqWGmFX3cXsvXJqxmXuQlHPHg6q8HWdFDPehF4VRAPutSP2yzR3EMdc
	qrI0L06pgivV5/22VQxbnoAYuoL/AMZ7qmwwGkqKN+xwzgBdCds/NtRfizRqxLpsLNI93K3Is1w
	tygOkx0ly08pKUMxwrN0iEqxsDZi4nIWuQInxQuEUCJ4g
X-Received: by 2002:a05:6a00:f94:b0:857:7317:cff4 with SMTP id
 d2e1a72fcca58-8577317d1bcmr39805907b3a.21.1788270354048; Tue, 01 Sep 2026
 06:45:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <6a7d8773.c5ad36c8.12f49d.002e.GAE@google.com> <68cb4941-3668-44f1-a889-6b2f023b2a08@h-partners.com>
In-Reply-To: <68cb4941-3668-44f1-a889-6b2f023b2a08@h-partners.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 1 Sep 2026 09:45:42 -0400
X-Gm-Features: AcwNN1WwADgnUO1qZ-igRAeF08FDzlcxT49ayOLVDUIzmVUCK8ZfNwVQ9ZdAm-c
Message-ID: <CADvbK_eY4S1HbdNHuNq9b=Va-TA_6rNFvnCvtOUZ0sF-AWN67A@mail.gmail.com>
Subject: Re: [syzbot] [sctp?] WARNING: refcount bug in sctp_transport_put (6)
To: xietangxin <xietangxin@h-partners.com>
Cc: syzbot+80dfcb1a2235b3efc877@syzkaller.appspotmail.com, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Simon Horman <horms@kernel.org>, Jakub Kicinski <kuba@kernel.org>, marcelo.leitner@gmail.com, 
	Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org, 
	linux-sctp@vger.kernel.org, netdev@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com, gaoxingwang <gaoxingwang1@huawei.com>, 
	huyizhen2@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 31, 2026 at 11:47=E2=80=AFPM xietangxin <xietangxin@h-partners.=
com> wrote:
>
> Hi,
>
> I have analyzed this issue and successfully reproduced locally.
> The race occurs between the timer callback (`sctp_generate_heartbeat_even=
t`) and
> the transport cleanup path (`sctp_transport_free`):
>
> Task 1(Timer Softirq)               Task 2(sctp_transport_free)
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D              =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> sctp_generate_heartbeat_event()
>   refcnt =3D 2
>
>   bh_lock_sock(sk)
>   sock_owned_by_user(sk)
>   mod_timer(&hb_timer) -> returns 0
>                                           sctp_transport_free()
>                                             transport->dead =3D 1
>                                             del_timer(&hb_timer) -> retur=
ns 1!
>                                               sctp_transport_put() (2 -> =
1)
>                                             sctp_transport_put() (1 -> 0)
>                                               sctp_transport_destroy()
>
>   sctp_transport_hold()
>     -> refcnt is 0, increment fails

This should not be 0, as the transport must hold a refcnt to start the
hb_timer.

Also, the delay below is under bh_lock_sock(), so it should not be the
real cause of the issue.

Could you share the PoC for this issue?

Thanks.

>   out_unlock:
>     sctp_transport_put() (0 -> -1)
>     -> refcount underflow warning!
>
>
>
> Adding a small delay  after `mod_timer()` increases the reproduction rate=
:
>
> --- a/net/sctp/sm_sideeffect.c
> +++ b/net/sctp/sm_sideeffect.c
> @@ -373,8 +373,10 @@ void sctp_generate_heartbeat_event(struct timer_list=
 *t)
>                 pr_debug("%s: sock is busy\n", __func__);
>
>                 /* Try again later.  */
> -               if (!mod_timer(&transport->hb_timer, jiffies + (HZ/20)))
> +               if (!mod_timer(&transport->hb_timer, jiffies + (HZ/20))) =
{
> +                       mdelay(1);
>                         sctp_transport_hold(transport);
> +               }
>                 goto out_unlock;
>         }
>
> Any feedback or guidance would be greatly appreciated.
>
> --
> Best regards,
> Tangxin Xie
>
