Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.169
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795535405;
	b=c7DvlzRLOEKPX1khdqtngZvJ5WHG4PG7HwIyVxHx0eCQ3HV55JuQ/zaeMq67F+tQq1hR
	 lNbV4IiwjAtXea9ssLoQ+u0+F6W0C1Bsoxuh60AhKreWMUEAOooa4h33ASVWv9syp6zzy
	 Ht6DpZOBDHkU3wYHBgqQgW7DY+sqBi1U/STY23CBG58QLr6Tj19ddKguX/2RNglvLjEdi
	 /RKuMudihMLngq3jOCUWqi8hHrDaV5M9SG2tyORIFZzR4gWfPqzRsa1v2ynhqkDTcXMNu
	 zEtaUo7ZHSBERSGg9ospOxEiJC3EDmRQLDdxvFymGUCNXrcDSLNfBycmtOwidGaxPoA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795535405;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=RV67tSyDZn0xZW7mF0uAthhaVtVBN7CmTIVclI2472Q=;
	b=eLDRKrFvYd7JDKsQSDmkF4euSEn02Mbd6JciQORlJKbKi63yFfnrc4QLcB/3h3R1+oPY
	 daZIOwlfrTNsVbTgcWhmVVuP2Fj1L8kmlscupRNTYoGtqsptGuuv0qRzspRfdVAHHNi3a
	 og0poBVzF2Y7o7j0c4fyoF1SJf5l8u3MESL+eDS9HDg+Iexn7ePw99+g1PMAe7SUPYpXY
	 EKfB/auAHScU7QlWFzw85N21SY8g/Shvi7VR5WnLpKnwkf8m8e0eKn47ppy/az2Fnz5fj
	 uQyo+trh3tTDznx8iWkjRv0bBlqKneP4EFZwciw8uEZgtqcw5jedoABq5z4sLCNMLxw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=tpvzfX62;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.169
Received: from mail-vk1-f169.google.com (mail-vk1-f169.google.com [209.85.221.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 230F5606A31E
	for <linux-sctp@vger.kernel.org>; Tue, 24 Nov 2026 15:50:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 230F5606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=tpvzfX62
Received: by mail-vk1-f169.google.com with SMTP id 71dfb90a1353d-5c9e7731b34so2959707e0c.2
        for <linux-sctp@vger.kernel.org>; Tue, 24 Nov 2026 07:50:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795535404; cv=none;
        d=google.com; s=arc-20260327;
        b=GlXbMZUJw0I2u5Bu1KlycErGLSsANKESl9qvhlO8zdLgLlwMplmoGnAxl1F0yQaiHM
         Y1cgG+m1nCrJLfUZ5XgWMc2oaiCBQgJnUdA5xu4iT6tjwSEU+3xwCbvyqUjSHA8x5n2z
         clB6zT08MDvG94V92FArwdWrJhRF5AsyfjT+cG4wXjo3SsPvCRlCPJ3FD7NevXF8EIUi
         E0GjmSf5eQ7FWIVBP7x6HZEL+pzjS2QBOLH/3RoGKKVK9G+/382rc+/jdbaXQL0wIyF1
         vwwjB/94oyhLYe7sOOAqdFQK+spDWi5zpcs14amx+OgwoGZBhasz7F9FcGXa7Sr7vux3
         1gmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=RV67tSyDZn0xZW7mF0uAthhaVtVBN7CmTIVclI2472Q=;
        fh=mkw61MfSzDkAIK/M6yV31nIIaelohT1NYLBd7PljLYM=;
        b=YpU3Jdw+Z/oH3obtjbSFuFrI7kZhEdDy1wzfpkhAn46qcrVhPx/pPE18gQ0t8Cy1r7
         X/3XabQ28TkVVPVRJejCB7Q+MkrWYcq17KIvq9TCMvS7ZZcgKB21g4R+74woCm4AtOA9
         9URXIBfKS12I8XwnQQQOZzHZdmQEe3Uc5X/lsKg6/T3KJGiIft3M62yhqJdXUZJBRV8H
         lvbXgJXIV9pwV09nzthE4xE2xebIGpUF723vk4tBpxqvp/4A2LIUC08ZcCxjQCyYFr+G
         k/2HhRhUnyObPzLBDnDSlsfg4iUXYaRWg7+nOdJ7nv6T3IZe/Om1NU3VnWN6HLeocJlL
         RC5Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795535404; x=1796140204; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=RV67tSyDZn0xZW7mF0uAthhaVtVBN7CmTIVclI2472Q=;
        b=tpvzfX62PIzNzokRcG5NmsnWakxto1N3TzhM2ftdLhXZHi8SvOKdrw+3wgkH75LU+Y
         AA8VkTK61xnBQ0OzC+oyjo2vkQTGWgOf2NzLrOGXt1yOQxgKTzn444w7M25Ofc+0NLTz
         GmoXUBafQ75I+7PY65nwTBXf2VTNbXjNTYMvR7cAmDZpXqD0tdi/9YJXXmBCownmBxpA
         R7OSfA02voezIiyXBs8Rc53xV321PkF3Q26vkduZlqrev1hCGSnEzM0/FxX7L6Xq5l6F
         MzXRiE5px9Irt7majSmfIrOjGRbd9YW3VaWnL+yjaMS23tsOEuxfue/n7+Nhr+pdVVWc
         6gQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795535404; x=1796140204;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RV67tSyDZn0xZW7mF0uAthhaVtVBN7CmTIVclI2472Q=;
        b=DDt0DLZtPLZvJG2glUIx6/nE8XDSvLa2xPIu3dmDOr1bQLN/UjVSnw9pxs0Hw5KEuQ
         H2tSUKvcM0WM2kse6aSEAxA3BlZ1kqTyRctLiPuKdgA9ym/WfFQKYsusVZQ2GW6LDSH6
         TKRULRNEGudsEkqS8hRHgFahHFogaj2SJOV9wHpTTkJGCWWOQotbk+L9KE25jqb2REWT
         6S3gIWivC0LbCYv0ASw2hctlCMVK0wxeh0aCQ1sfIs0oQOzcKCF/u0A3/2dtkqY48R5h
         ohAN6cnJ96YHrdYgrBdo0UdfSKtnyTU7f1YaQY6LN96FXQxeBDxfpqo9G1RabJouSD8+
         OK8A==
X-Forwarded-Encrypted: i=1; AL+hErGrKJ6d0WyD2qw/RSpClEoAy7COCU4WfJiH8XFib5+lsKi6tMDj3NUhlDrjjFfzmc5IvPES4fHclXBX@vger.kernel.org
X-Gm-Message-State: APuU4Z869DxpulPSr3+NiLV27ynNoceA7Pz1vBTzI9NJCfUEwXnvyHRg
	iQjMvK+4K4jMDcQzzkz5p36t5ySMz5T2iY2IsjyiiloBOBIW5Mx+iv2g5SiWLv3ZGm/Y/Zgr0JW
	Spe6LoUGvmVQqYws2GyEaILLFS4FmRTM=
X-Gm-Gg: AZFdTZftWv715I7Xeh+H8vsnQxTug7njSFa4RJW8q/h9qItXYdaqqGpIpvvsRzCqN9M
	Tz0v00X5EbaVY6rZyZbvbX37tSxoCh7NLcxo7U+5unosyaPZcHHv21SZ8QCcOGV9Gtc2OkkJCMK
	sBR1UTWAlyz1Q/i8iZROH1GYKkSUazebLqqDH1t+ewZ20CqIgQIF68lBoTa6W3OyqI8tsDU1RIZ
	NF0OpI3JppIBgOmUx5VA+KZqaBykTAOrJ9A695eU/2uYnqo6kqgev2F3YUjxZy5yA1tfbS0iX5x
	Vcpo8zry9uJFBlRTdgNkvTo+r7TnU3GtjugbDt/WJ89J4wcchbIUVQCDS/EVLx4YpC4a+YT5hSn
	AKq8DhgF33zAmHi0EELDpH/BIjf3BxHk7I9dKJQVi2vjuqcENVT2CoQz+ONS1WLe/nMX40ydcsy
	czV3r1mfyiVNoksiGtG59IFggDnnl+ApYl6My8iQ==
X-Received: by 2002:a05:6122:3b84:b0:5ea:ea07:b119 with SMTP id
 71dfb90a1353d-5ee8af7df7bmr8866936e0c.16.1795535403955; Tue, 24 Nov 2026
 07:50:03 -0800 (PST)
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Post: <mailto:linux-sctp@vger.kernel.org>
List-Help: <mailto:linux-sctp+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sctp+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <48580ca6a02b588e9c24444801109506da11a9d2.1795396989.git.lucien.xin@gmail.com>
 <179548588251.3135.10014340190099201603@kernel.org>
In-Reply-To: <179548588251.3135.10014340190099201603@kernel.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 24 Nov 2026 10:49:50 -0500
X-Gm-Features: Aa3M54osN_faTySIAtHk7Iwt6hDIqaWDaoWsCgd8DBofHvamK0vLPqfo9enUAFk
Message-ID: <CADvbK_fYFGtLq2H0-7p9J=nM8wVAH51SvVhzgMXzivn+YdXYfw@mail.gmail.com>
Subject: Re: [PATCH net-next] sctp: copy endpoint settings to accepted and
 peeled-off sockets
To: netdev-bot+sashiko@kernel.org
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, davem@davemloft.net, 
	kuba@kernel.org, edumazet@kernel.org, pabeni@redhat.com, horms@kernel.org, 
	marcelo.leitner@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 23, 2026 at 9:04=E2=80=AFPM <netdev-bot+sashiko@kernel.org> wro=
te:
>
> Thank you for your contribution! Sashiko AI review found 3 potential
> issue(s) to consider.
>
> Critical: 0 =C2=B7 High: 0 =C2=B7 Medium: 1 =C2=B7 Low: 2
>
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwor=
k
> know by including "pw-bot: cr" as a separate line at the end of your repl=
y
> (one such reply per series is enough).
>
> - [Medium] In sctp_auth_ep_copy() (net/sctp/auth.c), the per-key copy is
>   incomplete: the source key's `deactivated` flag is not copied.
> - [Low] The commit message says the change only affects restart
>   negotiation and lists PR-SCTP, ECN, RECONF, ASCONF, I-DATA and AUTH.
> - [Low] The commit fixes a wire-visible bug: an association restart on an
>   accepted or peeled-off socket negotiates capabilities (PR-SCTP, ECN,=E2=
=80=A6
>
> --
>
> sctp: copy endpoint settings to accepted and peeled-off sockets
>
> This patch makes sctp_sock_migrate() copy the feature flags and AUTH
> configuration from the listening socket's endpoint to the new endpoint.
> Association restarts on accepted and peeled-off sockets then negotiate th=
e
> same capabilities as the listener. It adds sctp_auth_ep_copy(), which
> deep-copies the HMAC list, the chunk list and the shared keys.
>
> > As gomaja noticed, when accept() or SCTP_SOCKOPT_PEELOFF creates a new
> > socket, sctp_endpoint_new() initialises the new endpoint from the netwo=
rk
>
> [ ... ]
>
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
>
> [Severity: Low]
> This fixes a restart negotiation problem that is visible on the wire.
> There is no Fixes: tag to tell stable tooling which commit introduced it.
> Could one be added?
>
> The reporter is credited in prose ("As gomaja noticed"), but there is no
> Reported-by: or Closes: trailer. Should one be included?
>
> > diff --git a/net/sctp/auth.c b/net/sctp/auth.c
> > index cbeb8a87a17a7..e075297b9ead1 100644
> > --- a/net/sctp/auth.c
> > +++ b/net/sctp/auth.c
> > @@ -1056,3 +1056,50 @@ void sctp_auth_free(struct sctp_endpoint *ep)
> >       ep->auth_hmacs_list =3D NULL;
> >       ep->auth_chunk_list =3D NULL;
> >  }
> > +
> > +int sctp_auth_ep_copy(struct sctp_endpoint *dst,
> > +                   const struct sctp_endpoint *src, gfp_t gfp)
> > +{
> > +     struct sctp_shared_key *sh_key, *new_key;
> > +
>
> [ ... ]
>
> > +     key_for_each(sh_key, &src->endpoint_shared_keys) {
> > +             new_key =3D sctp_auth_shkey_create(sh_key->key_id, gfp);
> > +             if (!new_key)
> > +                     goto nomem;
> > +             new_key->key =3D sh_key->key;
> > +             sctp_auth_key_hold(new_key->key);
> > +             list_add_tail(&new_key->key_list, &dst->endpoint_shared_k=
eys);
> > +     }
>
> [Severity: Medium]
> Should sh_key->deactivated be copied into new_key here too?
>
> sctp_auth_shkey_create() returns a zeroed container. Only key_id, refcnt
> and key_list are set, and this loop never reads sh_key->deactivated.
>
> For endpoint keys, sctp_auth_deact_key_id() leaves the key on
> ep->endpoint_shared_keys and only marks it:
>
> net/sctp/auth.c:sctp_auth_deact_key_id() {
>     ...
>         key->deactivated =3D 1;
>     ...
> }
>
> After accept() or peeloff, a key that was deactivated on the listening
> socket therefore looks active again on the new endpoint. This check in
> sctp_auth_set_active_key() no longer fires for it:
>
>         if (!found || key->deactivated)
>                 return -EINVAL;
>
> An endpoint-level SCTP_AUTH_ACTIVE_KEY for a retired key id returns
> -EINVAL on the listener but succeeds on the new socket. That lets
> newep->active_key_id point at the retired key. Associations created later
> on the new endpoint, for example on restart, would then inherit it.
>
> Would something like this be needed?
>
>         new_key->deactivated =3D sh_key->deactivated;
>
Makes sense, will add it as suggested.

And also target this at net.git as a fix.

pw-bot: cr

> sctp_auth_asoc_copy_shkeys() also drops this flag when it copies keys
> into associations. That part is existing behaviour, not something this
> patch adds.
>
> [ ... ]
>
> > diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> > index bc68af88e2710..bfd87be8ed54c 100644
> > --- a/net/sctp/socket.c
> > +++ b/net/sctp/socket.c
> > @@ -9623,6 +9623,23 @@ static int sctp_sock_migrate(struct sock *oldsk,=
 struct sock *newsk,
> >       if (err)
> >               return err;
> >
> > +     /* Copy the endpoint's feature flags and AUTH settings from the o=
riginal
> > +      * endpoint so that restarts on the accepted or peeled-off socket
> > +      * negotiate the same capabilities.
> > +      */
> > +     newep->prsctp_enable =3D oldsp->ep->prsctp_enable;
> > +     newep->ecn_enable =3D oldsp->ep->ecn_enable;
> > +     newep->reconf_enable =3D oldsp->ep->reconf_enable;
> > +     newep->asconf_enable =3D oldsp->ep->asconf_enable;
> > +     newep->intl_enable =3D oldsp->ep->intl_enable;
> > +     newep->strreset_enable =3D oldsp->ep->strreset_enable;
> > +     newep->sndbuf_policy =3D oldsp->ep->sndbuf_policy;
> > +     newep->rcvbuf_policy =3D oldsp->ep->rcvbuf_policy;
>
> [Severity: Low]
> The commit message only covers restart negotiation of PR-SCTP, ECN,
> RECONF, ASCONF, I-DATA and AUTH. It doesn't mention these last three
> copies.
>
> sndbuf_policy and rcvbuf_policy are not negotiated. sctp_endpoint_init()
> sets them only from net->sctp.sndbuf_policy and net->sctp.rcvbuf_policy.
>
> Once sctp_assoc_migrate() sets asoc->ep =3D newep, the live association
> reads them in these functions:
>
>   sctp_wspace()
>   sctp_wake_up_waiters()
>   sctp_assoc_rwnd_decrease()
>   sctp_ulpevent_make_rcvmsg()
>   inet_sctp_diag_fill()
>
> If the sysctls changed between creating the listener and accept() or
> peeloff, this changes which buffer accounting model the migrated
> association uses.
>
> strreset_enable is also copied without mention. New associations inherit
> it, and getsockopt(SCTP_ENABLE_STREAM_RESET) reports it.
>
> Could the commit message describe these copies as well?
>
> [ ... ]
>
> --
> Sashiko AI review =C2=B7 https://netdev-ai.bots.linux.dev/sashiko/#/patch=
set/48580ca6a02b588e9c24444801109506da11a9d2.1795396989.git.lucien.xin%40gm=
ail.com
