Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56C872ECD1D
	for <linux-sctp@vger.kernel.org>; Sun, 23 Aug 2026 17:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787506607; cv=pass; b=HGCbWMa9KYoGD2veDjyZp0/CcSaP1FO4b1ZXRYOYMkMlhASN1XLZI35hmfL8wKwwwMCug3RXc9O2cf6QyJOB7aWKHNzEap9bs/qFaM0TaW8YIQ+5Vfqfi/iiRjScZfnt7D4V3NebHEi+zv61TJqxfjdudiLspNdA0iUf6TKZz8s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787506607; c=relaxed/simple;
	bh=ZTG7jVjcTi86l5dazmQruPuJYLfOT+grKua4hiNOklI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=amhWDiADfyC3cnQ6Tzg6QFj4oJ7SauiooSZz0CKMcJ7OeT/Iz271QS8As7ecjAYISCL9/LanArY5DMI1vFM/OPKp0nna8IZdhD/zdmUTslLh6C6HkKkh75ttnhfi6a0DDDOW5RJ+AvJgNKj/dY/ukEJhGiMesCgYZPpPcETTE/E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BXbUKvpV; arc=pass smtp.client-ip=209.85.128.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BXbUKvpV"
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-836eac5682bso49162497b3.0
        for <linux-sctp@vger.kernel.org>; Sun, 23 Aug 2026 10:36:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787506604; cv=none;
        d=google.com; s=arc-20260327;
        b=LPK045Opya4asHw832R9QvY5GDe6vNn43H7dSHcmtmoFx50LkRh5qFvOPexn8eQD+K
         PFhzc078uyNHigaS80du4YRzPnqDQ2E6NBPPuL2hJC3EicWkTZJuReDaJSRAQhQJxIqq
         OONUB8lE/RvvpVYhea1SE64YxpNGuCgujsInlh/7stFtyoe9Jo3Be5xOyFBPcSMaYgJM
         Xr48S0DRyh8d02OuExul+R9QgRlLoHAViky9UMixOvFD4AaNp7rFKaToVzrI9RfFQwmv
         eME6jQUrOc/rvesnSXR7viMzqatD/r8jXnzrWcdpvN5p4VzzigK2eGnGliWYWas2HAy8
         1O1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ZFaM240eicHlNZGsa1WgcDYHiUAJ1fjLwFBjJU8YruQ=;
        fh=PqklQ3Cpi/86+2oyEwkSslY+lHNP2fMG96ZcJYTw1sM=;
        b=PpGczmQbZ5SEDE1FLJ7GpIkRlX718zHhuwX9QmQB7csj79L7nyxfg6B1vnqDnwcZEH
         ZBN2GFDpOQNHUZxeUlY6w170OsDIyI1/DNfYbqnVetqkj5N+Ns/ycacDyt0/BE0Z4YI0
         y0vDwRa7rFHsK7OZt0a0b7rjhiTsTZr8occwW+sDnCJuI309QFoStA/vSJvGP82U+ZGz
         4idpOr1iwpzUhNhHyTtJORUUyBjo9TgkqYRRbVO9Yy85KPF/FFepUpoDh1mJrsjJN9Pw
         V76o0llBJmsO0++wK9GxpauMFmpYyXEKAPzQ1lCUiU0iJUE9gPHDm7Jt4QQiFQ1C/gVz
         ftVA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787506604; x=1788111404; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ZFaM240eicHlNZGsa1WgcDYHiUAJ1fjLwFBjJU8YruQ=;
        b=BXbUKvpV/z6rXuQY3VQAy6sfXCLy1kHi+aXn/KYA7tPA8erh6cdD+DZfXV2HKtCjXh
         B5KS5By+XLiyYrdzpklJWKhBmf3EW3GIjWs16FAdaOqNkcvQVMM/T4lkdxZCc4Tnr7o6
         9CCg2WHPHWFHZ77BLtLwLy2+BtNEe/IUNrj8sv6RQ40WhAB8B3bnf32085EvfeGI7IDV
         UcypRMHgq4/BMBxAMoVOVuhJAsVy4t1wFGi6c2dr/q/yz4o9/IxVU0emAIut7CNQTPJi
         Myph8ZIQiCU//TNtQkDqz0VLvr3H5BeEFm2Az6eHyjdfx6xkAMSgfldTVQGgKlnPLLYS
         VNUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787506604; x=1788111404;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZFaM240eicHlNZGsa1WgcDYHiUAJ1fjLwFBjJU8YruQ=;
        b=Hjg0PRxXAl3sNkjPkxRc5tSk9QlkQ0gBKKyucfV9Qnife/SdswkeDRqjigmd71EUcK
         XZZUxca1M+Ri083fHdKJ/mmY74mKzLd3vVHvAD8qwN7LcEFAN7vLNVuhiCkBe6dYQHBM
         8G4Jg/PxbO3INnAYNBz5E61ShbbmKmjcOPG33eS0P9xCA7BMq2i22q2ZKuaPHJDwe318
         zpbMEWldSXbU+ztk5oX7UgGuVYCXllrUFkojY4klskxgKogs4KHKwjFjSWMrvbg0oItF
         6yckfjZG/qksn8qTGqumDy17bXxWccZjj9n3b6hUonopnukyCVLlWTQ6v1124P9CqXzi
         UUEA==
X-Forwarded-Encrypted: i=1; AHgh+Rp/Ox8xjWE4IWbt/M5q9heJX5uvS6c/VYBnzPCImaTAG2L/nYes4sCt4ReB3TFqefK4yRcTo0tb0Sro@vger.kernel.org
X-Gm-Message-State: AFuF++nZz6DyakvblzLwn6/vkd0d0EtBiyPeF3WUV2TUJijMM2l8vPCS
	9nJg8A/MFILWUatbGbQFYKMayKmtrbnRJWrGWipsJVaCWtLYyFFEKP5dn+CY+d/q+nQJWYrFGHI
	cc8PaK6M5h4v+G3VCLc+EcJPoljhzl1I=
X-Gm-Gg: AR+sD12eWwGTFNlePWcjrpzew2P5nTxvkSrSzljXzDlRnq2R5+Yi62bHlY/ya9P5D7Y
	VbNd/VqyVSBXaEospe2fm7rMhv1RP20vSHxBPKZclDvq19LtTrus3JuLGOWHV3e3laix6fCtIRD
	j6Sn+jJxr7B9pPY/VkM3pGADhm19IwOZQgP/geiTAPRLRQkUun1UuxuUINDtK3zber4h4dBSazk
	7ltZp2RiReK/XSe2FfbI9nQGy0DNXEe13lFv+IdsO1lu3LexVwYAGMDsVlj/kZXuSL8i7HPOyob
	V4t7g1hlANhqZejN6LbdtRcAailvSgGpC22SpfGCMtx6IT1duM75FZpqSEaKDFa6+qC98XiPK74
	=
X-Received: by 2002:a05:690c:e1c6:10b0:826:f78b:8462 with SMTP id
 00721157ae682-847091daa5amr80352677b3.7.1787506604304; Sun, 23 Aug 2026
 10:36:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260820162235.2668698-2-bestswngs@gmail.com> <CADvbK_cC8A3vjV0mweyBX_RyHFk_-ruyQ-Wp6UDmWpeAvNMvTQ@mail.gmail.com>
In-Reply-To: <CADvbK_cC8A3vjV0mweyBX_RyHFk_-ruyQ-Wp6UDmWpeAvNMvTQ@mail.gmail.com>
From: Weiming Shi <thebestswings@gmail.com>
Date: Mon, 24 Aug 2026 01:36:05 +0800
X-Gm-Features: AcwNN1WIN7ZamSxeHE9CfMftmz0TsLLVundqqXQL6dY4xi55zsOABCO5R4pkbyQ
Message-ID: <CANgPUi1KkHNn=BeEG32B6kbYNArn0XV1rgeF3A6-wR7+oELpyA@mail.gmail.com>
Subject: Re: [PATCH net] sctp: fix NULL deref on untransmitted RECONF completion
To: Xin Long <lucien.xin@gmail.com>
Cc: marcelo.leitner@gmail.com, linux-sctp@vger.kernel.org, 
	netdev@vger.kernel.org, horms@kernel.org, davem@davemloft.net, 
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, xmei5@asu.edu, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Xin Long <lucien.xin@gmail.com> =E4=BA=8E2026=E5=B9=B48=E6=9C=8821=E6=97=A5=
=E5=91=A8=E4=BA=94 23:28=E5=86=99=E9=81=93=EF=BC=9A
>
> On Thu, Aug 20, 2026 at 12:23=E2=80=AFPM <bestswngs@gmail.com> wrote:
> >
> > From: Weiming Shi <bestswngs@gmail.com>
> >
> > sctp_process_strreset_outreq(), sctp_process_strreset_addstrm_out() and
> > sctp_process_strreset_resp() finish a pending stream reconfiguration
> > request by stopping the reconf timer on the transport the request was
> > sent on:
> >
> >         t =3D asoc->strreset_chunk->transport;
> >         if (timer_delete(&t->reconf_timer))
> >                 sctp_transport_put(t);
> >
> > On the transmit path chunk->transport is assigned by
> > __sctp_packet_append_chunk(), that is, when the chunk is actually
> > appended to an outbound packet. A RECONF chunk that was queued but neve=
r
> > transmitted keeps transport =3D=3D NULL, and its reconf timer is never =
armed
> > either, since that too only happens once the chunk has been appended.
> >
> > sctp_outq_flush_ctrl() skips every non-ASCONF control chunk while
> > asoc->src_out_of_asoc_ok is set and leaves it on control_chunk_list, so
> > in that state a RECONF is never put on the wire. The sender side has
> > already published the chunk in asoc->strreset_chunk and armed
> > asoc->strreset_outstanding, so an incoming RECONF that drives
> > strreset_outstanding down to 0 dereferences the NULL transport.
> >
> > sctp_send_asconf_del_ip() reaches that state without any peer
> > interaction: when the address being removed is the association's last
> > one it stashes the address in asoc->asconf_addr_del_pending, sets
> > src_out_of_asoc_ok and skips chunk creation and transmission
> > ("stored =3D 1; goto skip_mkasconf"). As only sctp_process_asconf_ack()
> > clears the flag, it stays set until a later bindx() ADD picks the pendi=
ng
> > delete up. An unprivileged process that removes the last address of an
> > ASCONF-enabled association and then asks for a stream reset panics the
> > kernel from softirq:
> >
> >   Oops: general protection fault, probably for non-canonical address
> >   0xdffffc000000003d: 0000 [#1] SMP KASAN NOPTI
> >   KASAN: null-ptr-deref in range [0x00000000000001e8-0x00000000000001ef=
]
> >   RIP: 0010:timer_delete+0x67/0x110
> >   Call Trace:
> >    <IRQ>
> >    sctp_process_strreset_addstrm_out (net/sctp/stream.c:832)
> >    sctp_sf_do_reconf (net/sctp/sm_statefuns.c:4212)
> >    sctp_do_sm (net/sctp/sm_sideeffect.c:1172)
> >    sctp_assoc_bh_rcv (net/sctp/associola.c:1044)
> >    sctp_rcv (net/sctp/input.c:243)
> >    ip_protocol_deliver_rcu (net/ipv4/ip_input.c:207)
> >    ip_local_deliver (net/ipv4/ip_input.c:262)
> >    ip_rcv (net/ipv4/ip_input.c:612)
> >    process_backlog (net/core/dev.c:6680)
> >    net_rx_action (net/core/dev.c:7959)
> >    handle_softirqs (kernel/softirq.c:622)
> >    </IRQ>
> >   Kernel panic - not syncing: Fatal exception in interrupt
> >
> > Skip the timer deletion when the RECONF chunk never reached a packet:
> > there is no armed reconf timer and no transport reference to drop.
> >
> > Fixes: 810544764536 ("sctp: implement receiver-side procedures for the =
Outgoing SSN Reset Request Parameter")
> > Cc: stable@vger.kernel.org
> > Reported-by: Xiang Mei <xmei5@asu.edu>
> > Assisted-by: Claude:claude-opus-5
> > Signed-off-by: Weiming Shi <bestswngs@gmail.com>
> > ---
> > Note to reviewers: this only stops the crash, and I want to be upfront =
that it
> > does not remove the state that produces it.
> >
> > That state has exactly one producer. sctp_send_asconf_del_ip() latches
> > src_out_of_asoc_ok on the branch that stashes the association's last ad=
dress
> > without building or sending an ASCONF, and sctp_process_asconf_ack() is=
 the
> > only place that clears it -- so the flag survives until the application=
 issues
> > the follow-up bindx() ADD that sctp_make_asconf_update_ip()'s del_picku=
p needs.
> > 8a07eb0a50ae ("sctp: Add ASCONF operation on the single-homed host") de=
scribes
> > this as a transient state ("the other chunks cannot be transmitted in t=
his
> > state"), but nothing bounds how long it lasts: an application that neve=
r adds a
> > replacement address leaves the association unable to send any DATA or
> > non-ASCONF control chunk for the rest of its life, with the RECONF sitt=
ing on
> > control_chunk_list and strreset_outstanding armed.
> >
> > I kept this patch to the dereference because it is what the rest of net=
/sctp
> > already does -- every other chunk->transport dereference is NULL-checke=
d -- and
> > because it backports cleanly. But would you prefer the latch itself to =
be
> > addressed, or the reconf request to be abandoned here rather than compl=
eted
> > against a chunk that never went out? Happy to follow up with either for
> > net-next. net/sctp/stream.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/net/sctp/stream.c b/net/sctp/stream.c
> > index 34ffe6c945a4..1cb30def2eb9 100644
> > --- a/net/sctp/stream.c
> > +++ b/net/sctp/stream.c
> > @@ -577,7 +577,7 @@ struct sctp_chunk *sctp_process_strreset_outreq(
> >                         struct sctp_transport *t;
> >
> >                         t =3D asoc->strreset_chunk->transport;
> > -                       if (timer_delete(&t->reconf_timer))
> > +                       if (t && timer_delete(&t->reconf_timer))
> >                                 sctp_transport_put(t);
> >
> >                         sctp_chunk_put(asoc->strreset_chunk);
> > @@ -829,7 +829,7 @@ struct sctp_chunk *sctp_process_strreset_addstrm_ou=
t(
> >                         struct sctp_transport *t;
> >
> >                         t =3D asoc->strreset_chunk->transport;
> > -                       if (timer_delete(&t->reconf_timer))
> > +                       if (t && timer_delete(&t->reconf_timer))
> >                                 sctp_transport_put(t);
> >
> >                         sctp_chunk_put(asoc->strreset_chunk);
> > @@ -1084,7 +1084,7 @@ struct sctp_chunk *sctp_process_strreset_resp(
> >         /* remove everything for this reconf request */
> >         if (!asoc->strreset_outstanding) {
> >                 t =3D asoc->strreset_chunk->transport;
> > -               if (timer_delete(&t->reconf_timer))
> > +               if (t && timer_delete(&t->reconf_timer))
> >                         sctp_transport_put(t);
> >
> >                 sctp_chunk_put(asoc->strreset_chunk);
> > --
> > 2.55.0
> >
> If the STRRESETSTRRESET chunk has never been sent, we should NOT allow an=
 incoming
> chunk to =E2=80=9CACK=E2=80=9D it.
>
> Could you try fixing this by returning NULL from
> sctp_chunk_lookup_strreset_param() if the STRRESETSTRRESET chunk has not =
been
> transmitted yet? like:
>
> @@ -488,7 +488,7 @@ static struct sctp_paramhdr
> *sctp_chunk_lookup_strreset_param(
>         struct sctp_reconf_chunk *hdr;
>         union sctp_params param;
>
> -       if (!chunk)
> +       if (!chunk || !chunk->transport)
>                 return NULL;
>
> Please also share the PoC with the maintainers, if there is one.
>
> Thanks.

Hi,

Thanks for your review. Updated patch and PoC are sent.
