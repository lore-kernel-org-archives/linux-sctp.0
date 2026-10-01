Received: from mail-pz2-f41.google.com (mail-pz2-f41.google.com [74.125.228.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA6AC3D9672
	for <linux-sctp@vger.kernel.org>; Thu,  1 Oct 2026 16:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790871120; cv=pass; b=VoNfx5boUOJAMnigLxpOhmOjorscu6ReemsQifn58yxelfcCsR/53UYaB1TRDZHDrExBXbImr+yTA8Sz6OY0k2f0zpDogQiyQxiBrJuHlZpEBik9+zQauTYFPe6oNPilI8qvm+by960OE+qmsdAdGM2iHoBh6OHHheIhvrgPHLw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790871120; c=relaxed/simple;
	bh=S0r0cGZ7NaesTXmp6HeI9s5W1vfRGs1p6GRplXqhx5M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZEw/QNZIGMlDg2odJ4xeG7Ovz9+7kOEVAg4Tt6HY8G8zBfl46qtRHiP6do/GLFmUEMqP0NyP//Kf/g0niBmmQN72ZiErjr53Fa4s91nvHkoK2s2sOSPBTzpm7mcYJmtEpXJ797qwlRDdgTKVN/Wrx0cF1Erml38jtNTPIjYRTM4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D7ehH5yj; arc=pass smtp.client-ip=74.125.228.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D7ehH5yj"
Received: by mail-pz2-f41.google.com with SMTP id d2e1a72fcca58-86e6d007703so3295934b3a.0
        for <linux-sctp@vger.kernel.org>; Thu, 01 Oct 2026 09:11:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790871118; cv=none;
        d=google.com; s=arc-20260327;
        b=oWps59uhu3XKgY9PwrDh0hYQkcqDxI/oUgxT7C2EM+bGbsqL7r9SG+5Xg1bYZeyzK3
         adBWwfVw8Cby23YnrANKCkbxRcnVjK8IDXPwpB9yKMooUy9ITnZj/qDrKzePzwgL2fZ3
         f4V646144eQVtTuLQECL/JtF598a6/ElAPX3gC4yPi+dTGyPq88Jtbb12JvzbhWl4bYw
         Rt2QOjn+vJdDQ5XPgfFLtXlXrtZKkv13dptiJKfcbrhisqB7nyS8gnDHP09pEGvMvnYu
         KfAXynIQb8nxi1wE/sC00bjzGm+VyUctc49H5JxCx2QN8DCSFtSL7xfFbIhrEUXR5IUf
         EDZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5hKfE8YeFUB2v4D0quTu6qsZ47v3trhdTivuK/VDgPs=;
        fh=mPvKAKWalGj/RXthm2H/shswEcwp5wlZWsAz9OQ76Qo=;
        b=Ekh+y5igci+5+6Imnh2oXngTULIr3lvENYW6WT+4diLXN7EEgJ6WW83MOD+ZOJ9mnp
         4HH38wkSf7UIz2SYNRZC/2IbUAhZG6cACZepQ8yJKT/OiLN6jxRP67xooh4lF+jw1a0C
         7NonOx1mQdFQ+n6MeNd5769Uthu68mzmeEBurvexbpSyIj3F0BFgoVDg5ljz3a1VZ9Le
         7mLjLxL6DGbEf6vEyfrVADDuxrrKMAoP6/bOFXLcM7z0smfIlwEXKVqTV5Wa2EkFmnD5
         SfgDh9NFesCBAmYxn+VrU83FeQ6pdS7DXpZWkgBpNe6ezY8ltdqhKZEWOcIYKna/mLbF
         y1Yw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790871118; x=1791475918; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5hKfE8YeFUB2v4D0quTu6qsZ47v3trhdTivuK/VDgPs=;
        b=D7ehH5yjaPP3+GLQjDa8spEsW8WBXQIs3PK2wUXyhskiEZH9pmBCXR1ayOe+J8lyrw
         dVyfUCygNN26Bs/BS1USW1LbVAKA60KCGrc+25C2ykiiePW7I79PDUlsdT6xT/ZuI7rA
         JpZfPthI+A0RVFK5xjAnZG252fbVh33DUeIH6y9096aZ9YNsxQXDrpAS5VW8k1BU08KW
         9aGdhwTBk/bZ4zgiO4F4DB3YcunNmHrsVYqfD4diK7TWxX/3JuorZfPmY3xoSFGy+zKJ
         XS1oi0peDkE9lfGAd8jK3sjdydikU06p4+iU00aAqSJOSbDiQ4UMjy6uet2tAZsrjMtT
         liDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790871118; x=1791475918;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5hKfE8YeFUB2v4D0quTu6qsZ47v3trhdTivuK/VDgPs=;
        b=QkvnhMnZBdxlerTYq0p/m3wRo3J4409gtR4D440Dx3S607nCIGJIF/jtUVzh5iEXHc
         BS6059c55sFMjHuK0OCDzYmjci7kc+xK9eqrYdbj6NG83qaiUNhRlP/weHGRQP3bDJeJ
         SZ8Lq0WTQ900ZEKsVTlnaFZ4+P7gR+xXh5/V13c/1rC5q8QNk8dOFNkhJwRLn5g7QXqr
         IL8QMYroTOlww8kzWU1b1yRZV8j+R8Vw/zzXBlme0KxmCJJyKM39mkZmSs/SiHVfZNTo
         ZeFX6i5RExoEs4xg+sR5hnx0ra1FsDbFyVETL+3qT2mjJp5wXSl7N2NGmPOQGoXUEEmv
         1NaQ==
X-Forwarded-Encrypted: i=1; AKwUvByDjkIQ45q4OVjGKBkYvG66Ng27Y0Qt7vzkjWT3JMlAAdUPMhoqO70mRZ0FIpTtMXjTJ1XU/Bqxdr8q@vger.kernel.org
X-Gm-Message-State: AFuF++k0xrpolG2CTj4gBdqJ7Pc/4NcSfxkOHm/xMLA126bL5WfrVjja
	cAq1z0hQTi50WzTCVXWXMKMAskCeIh8l8QgXF/zbDfsXzDjPxzFJ82vJYYqQrtQq79lK5WVrmbW
	z6Nwg5/Yplcf8B9hAfIkkzfGCOHFQEqI=
X-Gm-Gg: AYBFou2CQ191EUTdq7nKbhUVmZm+ThOpYsPzpaPt3zKYWmpDc3In2+fwq83fuOugVyJ
	M4cVjHEArdr2XswTJmBnTj1IeP7dP2ic3YHKMB09FIWlD+Duwehzky5B7K6xrJ40iPfhqXls4DF
	bv8k0lWeHuW5PCyF1i7pbXg7vEpCM0YQNzTRKzsBnONPRLmOHawnmCT4boVv1hT89tjaoaZv6dH
	qlte6R2V7cc6vXY7pWQ/pKA1jXdH8Xbhnq4QcqyztWL7zZSpFwWQe8m62i2FM6vHzqFLUrfUNc1
	q+jeHbAv/lGcabsL9bbqzg7bm8hV/iRP4HBjuSObzWheWv0gfid6scQv6R4QIG+sKoi9MGEPlMI
	lBTKrh1wCPjycIZo+Zu9cHcwR0slvmwNpe+3e8JhzzjFXdz8nAT33iQ==
X-Received: by 2002:a05:6a00:2451:b0:878:1aee:fa43 with SMTP id
 d2e1a72fcca58-88af5e9e0b8mr66237b3a.33.1790871117648; Thu, 01 Oct 2026
 09:11:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260928190401.1641260-1-wbriggs@cellusys.com> <179083835206.434549.7959555054670908229@kernel.org>
In-Reply-To: <179083835206.434549.7959555054670908229@kernel.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 1 Oct 2026 12:11:46 -0400
X-Gm-Features: AclHuK-SE6KAyYVWH0zHyC1WoWJwVISfzWpNwt0v8Yvh6tmXfkow1wJu9vjLJXM
Message-ID: <CADvbK_fps4LrNX36j-MBpFmc-S5bQXhqkBgz+HC2RRuCvhdBXg@mail.gmail.com>
Subject: Re: [PATCH net v4] sctp: carry peer capabilities across an INIT collision
To: netdev-bot+sashiko@kernel.org
Cc: wbriggs@cellusys.com, marcelo.leitner@gmail.com, davem@davemloft.net, 
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, 
	linux-sctp@vger.kernel.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 1, 2026 at 3:05=E2=80=AFAM <netdev-bot+sashiko@kernel.org> wrot=
e:
>
> Thank you for your contribution! Sashiko AI review found 2 potential
> issue(s) to consider.
>
> Critical: 0 =C2=B7 High: 0 =C2=B7 Medium: 1 =C2=B7 Low: 1
>
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwor=
k
> know by including "pw-bot: cr" as a separate line at the end of your repl=
y
> (one such reply per series is enough).
>
> - [Medium] On a peer restart (sctp_sf_do_dupcook_a -> sctp_assoc_update,
>   ESTABLISHED branch), the patch re-derives only the inbound counters=E2=
=80=A6
> - [Low] The commit message says the change only affects INIT collisions
>   (Table 2 action B), but it also changes behaviour when the peer=E2=80=
=A6
>
> --
>
> sctp: carry peer capabilities across an INIT collision
>
> When an INIT collision is resolved, this patch makes sctp_assoc_update()
> also copy the peer's prsctp, ecn, asconf and reconf capability bits, the
> ipv4/ipv6 address flags and adaptation_ind from the temporary
> association. It also re-derives the inbound ASCONF and RE-CONFIG sequence
> counters (peer.addip_serial and strreset_inseq) from the copied
> peer.i.initial_tsn.
>
> > diff --git a/net/sctp/associola.c b/net/sctp/associola.c
> > index 4521be3bd85a..77ac155fdb70 100644
> > --- a/net/sctp/associola.c
> > +++ b/net/sctp/associola.c
> > @@ -1107,8 +1107,19 @@ int sctp_assoc_update(struct sctp_association *a=
soc,
> >       asoc->peer.rwnd =3D new->peer.rwnd;
> >       asoc->peer.sack_needed =3D new->peer.sack_needed;
> >       asoc->peer.auth_capable =3D new->peer.auth_capable;
> > +     asoc->peer.prsctp_capable =3D new->peer.prsctp_capable;
> > +     asoc->peer.ecn_capable =3D new->peer.ecn_capable;
> > +     asoc->peer.asconf_capable =3D new->peer.asconf_capable;
> > +     asoc->peer.reconf_capable =3D new->peer.reconf_capable;
> > +     asoc->peer.ipv4_address =3D new->peer.ipv4_address;
> > +     asoc->peer.ipv6_address =3D new->peer.ipv6_address;
> > +     asoc->peer.adaptation_ind =3D new->peer.adaptation_ind;
> >       asoc->peer.i =3D new->peer.i;
>
> [Severity: Low]
> The commit message describes this as an INIT collision fix, but doesn't
> the same code also run on a peer restart?
>
> sctp_assoc_update() has one caller, sctp_sf_do_assoc_update(). That is
> called from sctp_sf_do_dupcook_b() for the collision case, and also from
> sctp_sf_do_dupcook_a() for the peer restart case:
>
> net/sctp/sm_statefuns.c:sctp_sf_do_dupcook_a() {
>     ...
>         /* Update the content of current association. */
>         if (sctp_sf_do_assoc_update((struct sctp_association *)asoc, new_=
asoc, commands))
>                 goto nomem;
>     ...
> }
>
> These new assignments, and the counter resets below, have no state
> check. On every peer restart, a live association in ESTABLISHED,
> SHUTDOWN_PENDING or a similar state will now:
>
>   - replace its prsctp, ecn, asconf and reconf capabilities
>   - replace its ipv4_address and ipv6_address flags
>   - replace peer.adaptation_ind
>   - reset peer.addip_serial and strreset_inseq
>
> The restart behaviour may well be correct, but the commit message doesn't
> mention it, and the testing only covers a COOKIE_WAIT collision. With
> Fixes: 1da177e4c3f4, this goes to all stable trees.
>
> Could the commit message describe the restart path too, and could that
> path be tested?
>
> >
> > +     /* Re-derive sequence counters from the peer's Initial TSN */
> > +     asoc->peer.addip_serial =3D asoc->peer.i.initial_tsn - 1;
> > +     asoc->strreset_inseq =3D asoc->peer.i.initial_tsn;
> > +
>
> [Severity: Medium]
> On the peer restart path (sctp_sf_do_dupcook_a()->sctp_assoc_update(),
> state >=3D SCTP_STATE_ESTABLISHED), only the inbound counters are
> re-derived here. Shouldn't the outbound counters asoc->addip_serial and
> asoc->strreset_outseq be updated as well?
>
> On restart, sctp_tietags_populate() reuses our Initial TSN:
>
>         new_asoc->c.initial_tsn         =3D asoc->c.initial_tsn;
>
> and sctp_unpack_cookie() bases the temporary association's outbound
> counters on it:
>
>         retval->next_tsn =3D retval->c.initial_tsn;
>         retval->ctsn_ack_point =3D retval->next_tsn - 1;
>         retval->addip_serial =3D retval->c.initial_tsn;
>         retval->strreset_outseq =3D retval->c.initial_tsn;
>
> The restarted peer runs sctp_process_init() on our INIT-ACK, so it now
> expects serials starting from our initial_tsn. The ESTABLISHED branch of
> sctp_assoc_update() copies next_tsn, ctsn_ack_point and
> adv_peer_ack_point from new. It does not copy new->addip_serial or
> new->strreset_outseq.
>
> If N ASCONFs were sent before the restart, sctp_make_asconf() builds the
> next one with:
>
>         asconf.serial =3D htonl(asoc->addip_serial++);
>
> and that serial is initial_tsn + N. The peer's sctp_sf_do_asconf() then
> discards it silently, because it is above peer.addip_serial + 1:
>
>         } else {
>                 return SCTP_DISPOSITION_DISCARD;
>
> Would T4 then keep retransmitting this ASCONF, with every later ASCONF
> queued behind it, until sctp_sf_t4_timer_expire() aborts the association
> at max_retrans? RE-CONFIG requests would carry a stale strreset_outseq in
> the same way, and the peer would answer SCTP_STRRESET_ERR_BAD_SEQNO.
>
> Most of this mismatch predates the patch for associations that already
> had asconf_capable or reconf_capable set. However, the patch adds a new
> trigger. sctp_cmd_process_operr() clears asconf_capable after an ASCONF
> has already used a serial:
>
>         asoc->peer.asconf_capable =3D 0;
>
> The copy above now sets it back to 1 when the restarted peer advertises
> ASCONF. Before this patch, such an association never sent another ASCONF.
> Now it sends one with a stale serial.
>
> The COOKIE_WAIT collision case doesn't appear to be affected, because the
> local outbound counters have not moved yet at that point.
>
> Should the ESTABLISHED branch take addip_serial and strreset_outseq from
> new, next to next_tsn?
>
This looks a legit one.

Since asoc->peer.asconf_capable and asoc->peer.reconf_capable are updated,
we should address it in the same patch.

So please follow the report above to update addip_serial and strreset_outse=
q in
the ESTABLISHED branch.

Thanks.

pw-bot: cr
