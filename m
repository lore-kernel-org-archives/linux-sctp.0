Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.175
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794880762;
	b=pVw72xJIAbZZPzOYSCLAIY9PIR+qMWttHbcezWIXohBFqZk0sJ6YZ8EuDl9nnCWRZFhU
	 Kf4zHnHFKlkizk4W4J9uOAt28h+QOU212biUP8rmhzm2HxJ8id14LV3ghAcdGYvQqghCA
	 1kImlNDxiBy2R+AsJot4cofMJiFLfq1pwGopxXrdoQ/fNt1Ydz0usKEXWpxAOm3vSgB2O
	 ONTaUpTpo2TpLGFiy72cuH7EGnji9rnht1uGlPD7sRsIPqFw/GW00TrfJjTWnhQoXFEwf
	 /nJ+DmD4yGDR9alfjl5d05ClIaF5C0Di6uhg6trF5CCH8cUxUnd2K+Xdg66z0+Xasyg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794880762;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=88J4YdBdkt+GoqrMDEy8FKRRTjOaDrfPJo+wbtg/xiw=;
	b=v+Fm4vfCpgTCVTLIXUNSidWR4RnHYic7Oap8eQ/T6iCuve4oyaRX8fO7Ayer4ukVTMpE
	 /uQ1ZfCXRUqAxtx/c+EdkGrj61M85vesPbKUfgu/53kzfZssiiAneqboJOzfPlWDulROG
	 xmYvsz5Cr822zYcpTrLON2wjvJ6QbSKvms5J6ygu2ZjnCDfgtz4ZYAMkiwJuy7NpjQecZ
	 FL1hTgJgevUu6y2qx+W4DSLJcDdTzYFpXIl7F5G2dp0Xp5kQri+o7RgpDoQ0kOqFY6mio
	 Z1zgoVPdTcWjrquoPeMxEvlN7NbnjI7XhaBJ3blK28qse7uH+xfZoK9tUE53H4xK8Fw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=T7gWSw78;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.175
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0069606A32A
	for <linux-sctp@vger.kernel.org>; Tue, 17 Nov 2026 01:59:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C0069606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=T7gWSw78
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-8a594d313a3so2954727b3a.1
        for <linux-sctp@vger.kernel.org>; Mon, 16 Nov 2026 17:59:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794880761; cv=none;
        d=google.com; s=arc-20260327;
        b=lHLsjpr3KTHsTpxkpNTbFlJ7g6yNBPdMP1EfS5QF38pJBN6QbkpAw6Xy0DB/VmbPQ4
         qDBaRc1OxyPOfJ7BpHwViMs3KUdqAj6rq/TW5ENzgaRxPhJVb4RpYMdY550GMSZ8pR0d
         /5PXw4+tepKRKKXz5QJt8sUQlw72aX7ZQb8bToFde8YmMlA1m0URZgrFBlZJPXLDVwmB
         PXFPTT+wzB21nRJiPWBggKmxMCPrBv1hZ4+0jSoZlROcdkHhNq4JNzKqydnwaW+Xvwhb
         da4388FJdRIxLxmAGGJg3VncF2PwbP7vs9VrWtp/uE4VoYQN1V4zc0pWd54pg27x4BkZ
         YDQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=88J4YdBdkt+GoqrMDEy8FKRRTjOaDrfPJo+wbtg/xiw=;
        fh=4vSMPkYYuSFsHVYg0o47sQITPDIoq3LuAd2ZUcG5H60=;
        b=s2lDmSZbQ4qqSQxipaO/O1HJww/FdCFx1UGBrqkogBRXnGRr0DXFG2zL52MGrGon1G
         gMev+TRfdiV8O+IYqMZWlETzsZEVcIp3hONYSMbrk3aNb9mXILPaNZCNumAb/W5vF3SF
         zelIt0t3Grk2BCMcPsyU9fvtHTUFsL+ASENw6kCRVE+mJ9/Bf7W6r2d5ik1g1A+eZNK9
         fnDoXTs57M/tnF1Ck0efv3BMYK+6DzOBcSjhyD6MnrvvUGWyiswzMVavRiOupk/QUaV2
         5gTjYC7zHNCRSrX7X182gQ52gZbxrG4ZBiRTj2ENpcWIgumV/OQA6YlNrATMXW7JfYX8
         Nzgg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794880761; x=1795485561; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=88J4YdBdkt+GoqrMDEy8FKRRTjOaDrfPJo+wbtg/xiw=;
        b=T7gWSw78lGMzFYCcz7Czk6YfLjZVacf7Cc+TvBjANCCGpZ/+aEKwvBjqoue9GeweJo
         LfMSO5A9vfIsEkqHuzLUwTJUn2q7otmbgUah6yJQPq+5r+NuK+0tmO+lH864d1/ZO/eL
         57Xyjxb5lUDuH8L8zZsRpVU+WXmPKvVbVs9m2GTiF/0XtLT194isM+ehQdKw51a+uikk
         Wl3S2LzIKC6gx9d+kgCAaD3wGeJDD882teGGM4MXagOWGwOMFBniGsnAIs6BE5XxQA3T
         9l3jIQce+buFjDrK6G/Na4yj2WFAQWcIdZHB5I4jEejiukH47tfc9w0nA+2Ivb1pSCQN
         JmDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794880761; x=1795485561;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=88J4YdBdkt+GoqrMDEy8FKRRTjOaDrfPJo+wbtg/xiw=;
        b=Wm/tR0kNIqLscf4uMSbwzavaDaSjvIhgGcW+XUDwPSJTwy9h/ANEIWw33NsyJaXSZD
         c35oy12bx3Jma9D5Zq1V5GYjm+x3xlhSZuwcZmoWVOnJHiNDsmmn5CnbMIrRJbf8BHen
         jVE2hjUmPUsv4YsDFIEsarkvg4v3UqvztziIEwTAZ/B9A7kaj5g9BcbHjKgGFbJnpi2c
         oW+evNjp14bsl7ZynoDFzVkxC1nB4cD4r1nubNiW8kvcVMz8EbUxA2QRP9nkz8qcoi9D
         p2scfJt/GCzfLy3np/0cmqjd5XM1/vQ6s3BDGUMYL5evPBoYhZeB0WUdHaxTyAP9dV/8
         BrzA==
X-Forwarded-Encrypted: i=1; AL+hErFn6fQEWfF7suKBEwL1SLi0CDYDYfQs62HxGQ6k3SRe32MNbpgVgEX0tmGzzOzUutm5H2tH+12IKN+X@vger.kernel.org
X-Gm-Message-State: APuU4Z/2kUym+qaAkTFdkAM9QsZ//wfUC3BJwxNGLJzMCZt15ZZBo/48
	t5bvU5OVOdrDW5MTugKn3ZXp4tbkHsGs/kbEaS9f408nl/wlVAFQCUxC1myUTHn5uRMofCrfevv
	H7M4Sp954Z0UlkNPKkc1Bryw24Xzwz3s=
X-Gm-Gg: AYBFou0um5qtLrsMs87m/TctWRaV1Ph7KVuSwDHzMPQdL1ocT9YfyAbG8FjJPG8fc9x
	4AxGXQsEBqWxkjao/A+XfefsCeZ2IqrDe9boDePgOds17uNgykL3Lty+unsxjd3ZfE2T61gzgBp
	0LGltsWzVhz3JwG7kHXaUmOMLOCLs2HAtQDQdE5outeHUi/kLsLGWKLr+jU0fs0kVFACdVFdN6d
	o6QrLtk09mlpN+RHzn8GWIncW4rHb0T6wal5q3PopZrAqtlHzECg2yqqYzwXZtGmeWGNvTu8pM6
	5Qfz35dNKZyL87trFRQtRar5wfT+gZyXcfPuT2D/V0r6wWGEBNz7bWxyucc3gn3B9lR12nT99bX
	k2RMvoz1EEOX3O6YSF6hwEd6DmaACRJXfgqGeuHpVkMKJYCDl/8AIWBwSN+iktC4d7ZusQkduFd
	ShywN1AnNa/AW+KkZ2Vp90QzGoymBYHrEOoQ==
X-Received: by 2002:a05:6a00:1a8f:b0:899:21db:3f6c with SMTP id
 d2e1a72fcca58-8beb21cb506mr11014368b3a.1.1794880760919; Mon, 16 Nov 2026
 17:59:20 -0800 (PST)
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Post: <mailto:linux-sctp@vger.kernel.org>
List-Help: <mailto:linux-sctp+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sctp+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261112092114.12458-1-ljp1205831794@gmail.com> <179482095589.3136.2362257339716532422@kernel.org>
In-Reply-To: <179482095589.3136.2362257339716532422@kernel.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 16 Nov 2026 20:59:09 -0500
X-Gm-Features: AclHuK_War1T5zrgB_Ouw4Ktq31IpAlp_uIzGk8Kbj4QLzA7noWfu4odgJ7Twvk
Message-ID: <CADvbK_diB=3u2mdX9NkeCW8h8NJPpsO2nfufP4+gvS=tCm9DOw@mail.gmail.com>
Subject: Re: [PATCH net] sctp: preserve the last transport during INIT error cleanup
To: netdev-bot+sashiko@kernel.org
Cc: ljp1205831794@gmail.com, netdev@vger.kernel.org, jiapenglin@tencent.com, 
	marcelo.leitner@gmail.com, davem@davemloft.net, edumazet@kernel.org, 
	kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, 
	vladislav.yasevich@hp.com, linux-sctp@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 16, 2026 at 4:22=E2=80=AFAM <netdev-bot+sashiko@kernel.org> wro=
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
> - [Medium] When cleanup fails, the new `!list_is_singular()` guard in
>   sctp_process_init() (net/sctp/sm_make_chunk.c) keeps whichever non-=E2=
=80=A6
> - [Low] The commit message says "The retained transport is freed when the
>   association is destroyed", which suggests the kept non-ACTIVE=E2=80=A6
> - [Low] The comment at the clean_up label of sctp_process_init()
>   (net/sctp/sm_make_chunk.c) still reads "/* Release the transport=E2=80=
=A6
>
> --
>
> sctp: preserve the last transport during INIT error cleanup
>
> This patch changes the clean_up path of sctp_process_init() so that the
> loop removing non-ACTIVE peer transports always keeps the last one. That
> stops sctp_assoc_rm_peer() from using the empty list head as the
> replacement transport and crashing in sctp_assoc_set_primary().
>
> > Keep the last transport during cleanup so sctp_assoc_rm_peer() has a
> > valid replacement. The retained transport is freed when the association
> > is destroyed.
>
> [Severity: Low]
> Is this description accurate for the path in the oops trace above?
>
> The trace shows sctp_do_sm()->sctp_process_init() with no sctp_sf_*
> frame. That is the SCTP_CMD_PEER_INIT path through sctp_cmd_process_init(=
).
> The sm_statefuns.c callers pass a new or temporary association and free i=
t
> on failure. This caller instead runs on the live COOKIE_WAIT association:
>
> net/sctp/sm_sideeffect.c:sctp_cmd_process_init() {
>     ...
>         if (!sctp_process_init(asoc, chunk, sctp_source(chunk), peer_init=
, gfp))
>                 error =3D -ENOMEM;
>     ...
> }
>
> In sctp_sf_do_5_1C_ack(), SCTP_CMD_PEER_INIT is queued before the
> TIMER_STOP(T1_INIT) and NEW_STATE(COOKIE_ECHOED) commands. Those commands
> are dropped when the interpreter bails out. The association stays in
> COOKIE_WAIT with T1-init armed, and primary_path, active_path and
> retran_path all point at the retained non-ACTIVE transport. Later T1-init
> retransmissions use that transport.
>
> Before this patch, every transport left after a failed sctp_process_init(=
)
> was ACTIVE.
>
> Could the commit message describe this new state, where a live associatio=
n
> keeps running on a single non-ACTIVE transport?
>
> > diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
> > index 15c2d87575a8a..e4b7dacf174e6 100644
> > --- a/net/sctp/sm_make_chunk.c
> > +++ b/net/sctp/sm_make_chunk.c
> > @@ -2528,7 +2528,8 @@ int sctp_process_init(struct sctp_association *as=
oc, struct sctp_chunk *chunk,
> >       /* Release the transport structures. */
>
> [Severity: Low]
> This isn't a bug, but the comment no longer matches the loop, which now
> keeps the last transport on purpose, whatever its state.
>
> Could the comment say that one transport has to remain because
> sctp_assoc_rm_peer() takes the first list entry as the replacement path?
> Without that, the list_is_singular() check could later look redundant.
>
> >       list_for_each_safe(pos, temp, &asoc->peer.transport_addr_list) {
> >               transport =3D list_entry(pos, struct sctp_transport, tran=
sports);
> > -             if (transport->state !=3D SCTP_ACTIVE)
> > +             if (transport->state !=3D SCTP_ACTIVE &&
> > +                 !list_is_singular(&asoc->peer.transport_addr_list))
> >                       sctp_assoc_rm_peer(asoc, transport);
>
> [Severity: Medium]
> Does this keep the right transport? The guard keeps whichever non-ACTIVE
> transport the walk reaches last, which is the tail of
> asoc->peer.transport_addr_list. That is not necessarily the transport for
> peer_addr, the address the INIT-ACK came from.
>
> For an existing peer, sctp_assoc_add_peer() only promotes SCTP_UNKNOWN:
>
> net/sctp/associola.c:sctp_assoc_add_peer() {
>     ...
>                 if (peer->state =3D=3D SCTP_UNKNOWN) {
>                         peer->state =3D SCTP_ACTIVE;
>                 }
>                 return peer;
>     ...
> }
>
> New transports are appended with list_add_tail_rcu(), and
> sctp_process_param() adds the INIT-ACK address parameters as
> SCTP_UNCONFIRMED.
>
> Consider this sequence:
>
> 1. The peer_addr transport X is UNCONFIRMED and is primary. This can
>    happen through sctp_setsockopt_primary_addr() or through an INIT-ACK
>    SET_PRIMARY parameter. A Stale Cookie error then runs
>    sctp_cmd_del_non_primary(), which leaves only X and returns the
>    association to COOKIE_WAIT.
>
> 2. A new INIT-ACK from X carries address parameters Y1 and Y2, which are
>    appended as UNCONFIRMED. The list is now [X, Y1, Y2].
>
> 3. The packet reaches clean_up. One way is an address that collides with
>    a transport of another association on the endpoint, so
>    sctp_hash_transport() returns -EEXIST. Another is the ADD-IP without
>    AUTH check.
>
> The loop then removes X (primary moves to Y1), then Y1 (paths move to Y2)=
,
> and keeps Y2. Y2 is an unverified address from the INIT-ACK that was just
> rejected.
>
> sctp_assoc_rm_peer() has set init_last_sent_to to NULL, so when T1-init
> fires:
>
> net/sctp/sm_sideeffect.c:sctp_cmd_interpreter() {
>     ...
>                 case SCTP_CMD_INIT_CHOOSE_TRANSPORT:
>                         chunk =3D cmd->obj.chunk;
>                         t =3D sctp_assoc_choose_alter_transport(asoc,
>                                                 asoc->init_last_sent_to);
>                         asoc->init_last_sent_to =3D t;
>                         chunk->transport =3D t;
>                         t->init_sent_count++;
>                         /* Set the new transport as primary */
>                         sctp_assoc_set_primary(asoc, t);
>     ...
> }
>
> INITs go to Y2 and Y2 becomes primary. Y2 also stays hashed in
> sctp_transport_hashtable, so packets from it still match this association=
.
> If X had been ACTIVE, X would have been kept and Y1 and Y2 removed instea=
d.
>
> Would it be more deterministic to keep the transport returned by the firs=
t
> sctp_assoc_add_peer(asoc, peer_addr, ...) call, or the current
> primary_path?

Please try to fix it by using a check like:

  !sctp_cmp_addr_exact(&transport->ipaddr, peer_addr)

instead of

  !list_is_singular(&asoc->peer.transport_addr_list)

Thanks.

pw-bot: cr

>
> >       }
> >
>
> --
> Sashiko AI review =C2=B7 https://netdev-ai.bots.linux.dev/sashiko/#/patch=
set/20261112092114.12458-1-ljp1205831794%40gmail.com
