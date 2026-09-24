Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C41497B87
	for <linux-sctp@vger.kernel.org>; Thu, 24 Sep 2026 18:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790275330; cv=pass; b=LDkrZtN6U1/yMsxkHMY1Vdvp8jnG9OMLh2Dd7BdGs8uitruSlJQyJITuBlAsW8ICxokW7fILzzgs0yMUQrikkAscfjQAS6y4BEN1uOeYoHyXEuuWCiAxjdm9L70ZnAe59dogZjZA7Y/7w8LknyMhWwIu3hFnXxpv9cQ1QtEzDBM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790275330; c=relaxed/simple;
	bh=a1+M2nqlK/ZhoVJb/YUYrssmHwXM7ChJkAv3CzqMLRY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ow+CD3xBNssNrOMySI73SjM3lJntWB9Cui0MdKQlU8G/TTU/UqOt+676lS5ZRgQjNV/L6+BWSf/wsz2ikOOYQlApMdLF/8mXUfLOsWCFm0ZRB0GzlCuRwbXuh/KazKOKWO8gh9w205TvFUMZ1tEom1rg8QiIKA8W/6BAX/BeV7Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Q5i4BqVE; arc=pass smtp.client-ip=74.125.228.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q5i4BqVE"
Received: by mail-pz2-f12.google.com with SMTP id d2e1a72fcca58-8633a38df87so117650b3a.2
        for <linux-sctp@vger.kernel.org>; Thu, 24 Sep 2026 11:42:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790275319; cv=none;
        d=google.com; s=arc-20260327;
        b=ckzP8MgmAQdxccFYStB/bZObwmiUf3xheCAa4H9bD66ebRogRnJ5MxR3RilgV54dLr
         /UCb0v/KRGyebh4UfMiLb4D33rq4azjYc4qa/HN/FUydLCirDo4BXTgB5du3U/QffVQI
         McCHdA+SMRwmevvGpjmaX7Bhgxtk4rvoj4ZhYZtkY0HT1IsWQxNBHn/ztTgU3R1rzJIB
         u2b2/XjSYKESM4AuUhZvh1MxNvdo/6JSyFisUQCHYBeSEJEm8ny0o07D9cVta44rwm25
         fApiFXYZA5Fd7qIa19+OnVSn8NkLR1p5bCDSsWls8zhj+0u15hKo1AV80v8AR1FuI2Al
         5lWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Q77KuLpE+oIvbADaLPu5DaDb6SG+K0Y0OUtgLbqd2OA=;
        fh=wqrXy9PvOrPkN9N8GPaZs2xTPbi0SHkiALPzWps/IEA=;
        b=rxNkbBGusKb83fdC5REysaDJh01TAMV9Fv7PG5mS9EmpbXEsssGIB6Pvdp7o45+3hF
         inWNioX6+Pvv0APqEmcZxAgdMdLbF8ufuotmZJQDHFAajrUEw3D9BGkqlVDRQn3NKERx
         HfkyUqGhBVOPwf1uwncaYd8zMmXNkDsNcJNz9Cqg3fjtg69LLu70dGZzYtXpBORtZ0R1
         D+3fyEEehP2rGlVkcdVn8FtQKq0C/N2Khi90yVpha9TFbljvTE/LcQ5LifEidq1odcbe
         Uq3MLt33RNyld/qt8CdE5T9lE+MkQl1QVJw7K3i3YlLMrDc/SmEFBu47s9QXeRrh0Hyg
         zMgQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790275319; x=1790880119; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Q77KuLpE+oIvbADaLPu5DaDb6SG+K0Y0OUtgLbqd2OA=;
        b=Q5i4BqVERy5wqd6rj6aaEB1HiU2xkmdWnvOcA90iV+4qJotGV1Nn1S5zudOoLY+Zpb
         IzAB4bYHFYccjaW6T4y/+Kz5gBOykMpyYpXpR4WpP0Rln5DmCEN5LDWh4CNATKF0oH+C
         CZ5sPtSknuYjYmoSlnlQXo1ZefaFEBXTyoUYkBb6lG1itSkZFMlKixJaHpNm4nzWtBnm
         hp1d9Y0g5prcTUOUg6jJMTyNGoYHNFnLkfdkX285tL+Jmuk/w2nQhu+1WFa4iOszcEpw
         cRCB/A24QArhVJNv5uDYzMjUXon+GogHOxNSm7OYoGPQUydfQm5x1JLYqH7SlPRRpjO9
         uLOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790275319; x=1790880119;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Q77KuLpE+oIvbADaLPu5DaDb6SG+K0Y0OUtgLbqd2OA=;
        b=sOXrDyR/VOZ+aqtO5f+NUfUe58WRdumlDO4ULi6UX3fbuo8A/1veblV6lQpK+TQaTf
         vOvoY3L0LUloHmTuMzSCnYDJgvJWr1D+0c2YQqvvz2Lh6RXXcoRW9WPUZZcvJzup4PSo
         +fIxYoIqTWsKHlsdhV672HBL5lW1ttn9wyv4qFnTjyJQ2l40sYhninDnl4zs66FRLlCE
         UsVHAjCl0U5+WJ/3Gcmezmsgp1NpdPWw5uEhX4DzeTOlNDuEaCNswgqCdteCoSxPS2in
         jlljptZBgSJlJylxMbWYNi1kfDM9keE3AQKIsQ9kMkPIlbT4qRF16wGjMiWtxykue+nO
         q5qA==
X-Forwarded-Encrypted: i=1; AKwUvBx0M9Y501dDLfuRk8hlneXV/TUfK+7sx1LvTSujZwJmDyM5IsT2/XTgImysbSpibmB8PTJ2asUfcmSd@vger.kernel.org
X-Gm-Message-State: AFuF++n+56+9s8bg+azihDKDRbuEYUUZbuDWol5ZFRrcRaZN3eo1lgza
	TtsH+HCAstvYAQ9wg3dsapFLa2+0+IvlyDv9Po1A9+xQ8MiZv2TuohqeJZOMKaPPsL3sYO53ZQW
	AYMXSfDAo+exBSdrl6ZsTjHXzu09kPLxfSXF1IiE=
X-Gm-Gg: AYBFou1ql7F3N2TxS32nAUhMoRYdRIrfUE2WVJFo/lVwW52ebHxU5iRmcii++22tUlV
	IJ3WdaiIwzt3XbrtgglmxntTNMArEdkBj+xiJPX8SmB1CmHp6xLy/Ep+Ft0g+HlxHw9wl1fMitz
	8i7xE9IKyjJ8cL+WShJTXFal/Y5q4Il5qayF2MW+DD7q5WK/i/vXeDYSgr0BakjxVdK5CzB8kVp
	IpD+uYpg88YAjoglqevk3UwaKOkPjuB8Z2rKRUkkKc/JGBoRX1OyAX2OoWzf3ZAcHQlDVjWrdfu
	hAHInsSlcdyUhskhiwI5WKaHvOVAV/ZwrRj+G7Dh0RqukgM068KFyrhkyQjVySGsOsOxTFhmt9C
	Qp5MPlvPdO/YPnIgIO1YiIGKK89fEA+l1ojNMhWoxT9+n27GXC0HL01RfMrj+mhCjAGnvb4aCrY
	655iFA8ZIMxnwWxfKD7YZMzGw=
X-Received: by 2002:a05:6a00:1c8e:b0:871:c970:cf37 with SMTP id
 d2e1a72fcca58-87e9b79bdb6mr2949251b3a.24.1790275318834; Thu, 24 Sep 2026
 11:41:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260921135733.577647-1-wbriggs@cellusys.com> <179021514567.2160803.16218616091479610626@kernel.org>
In-Reply-To: <179021514567.2160803.16218616091479610626@kernel.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 24 Sep 2026 14:41:45 -0400
X-Gm-Features: AclHuK8z6qUlFPySpQuVxa2B36vqznwgXhIE0LtaQcRcr51cD7D7-DsVZXtcS1c
Message-ID: <CADvbK_c2P-qxJJ3sCDLJMpCQ4g6PaKVN3kiLTiXYx8UREmCZWw@mail.gmail.com>
Subject: Re: [PATCH net v3] sctp: carry peer capabilities across an INIT collision
To: netdev-bot+sashiko@kernel.org
Cc: wbriggs@cellusys.com, marcelo.leitner@gmail.com, davem@davemloft.net, 
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, 
	linux-sctp@vger.kernel.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 23, 2026 at 9:59=E2=80=AFPM <netdev-bot+sashiko@kernel.org> wro=
te:
>
> Thank you for your contribution! Sashiko AI review found 2 potential
> issue(s) to consider.
>
> Critical: 0 =C2=B7 High: 2 =C2=B7 Medium: 0 (1) =C2=B7 Low: 0
>
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwor=
k
> know by including "pw-bot: cr" as a separate line at the end of your repl=
y
> (one such reply per series is enough).
>
> - [High] sctp_assoc_update() (net/sctp/associola.c:1114) now copies
>   new->peer.intl_capable into the surviving association but never re-=E2=
=80=A6
> - [High] sctp_assoc_update() now enables peer.asconf_capable
>   (net/sctp/associola.c:1112) and peer.reconf_capable (associola.c:1113)=
=E2=80=A6
>
> Pre-existing issues:
> - [Medium] The collision merge still does not carry
>   asoc->peer.adaptation_ind.
>
> --
>
> sctp: carry peer capabilities across an INIT collision
>
> sctp_assoc_update() folds a temporary association into an existing one wh=
en
> an INIT collision is resolved, and today it only copies asoc->c, peer.rwn=
d,
> peer.sack_needed, peer.auth_capable and peer.i.  This patch extends the c=
opy
> block with prsctp_capable, ecn_capable, asconf_capable, reconf_capable,
> intl_capable, ipv4_address and ipv6_address so the surviving association
> reflects what the peer advertised in the colliding INIT.
>
> A few questions about the state that is derived from those bits but is no=
t
> refreshed by the merge.
>
> > diff --git a/net/sctp/associola.c b/net/sctp/associola.c
> > index 4521be3bd85aa..0bd0a662b5463 100644
> > --- a/net/sctp/associola.c
> > +++ b/net/sctp/associola.c
> > @@ -1107,6 +1107,13 @@ int sctp_assoc_update(struct sctp_association *a=
soc,
> >       asoc->peer.rwnd =3D new->peer.rwnd;
> >       asoc->peer.sack_needed =3D new->peer.sack_needed;
> >       asoc->peer.auth_capable =3D new->peer.auth_capable;
> > +     asoc->peer.prsctp_capable =3D new->peer.prsctp_capable;
> > +     asoc->peer.ecn_capable =3D new->peer.ecn_capable;
> > +     asoc->peer.asconf_capable =3D new->peer.asconf_capable;
> > +     asoc->peer.reconf_capable =3D new->peer.reconf_capable;
>
> [Severity: High]
>
> Turning these two bits on lets the surviving association accept inbound
> ASCONF and RE-CONFIG, but the receive-side sequence counters those featur=
es
> compare against are still the survivor's own.
>
> Both are derived from the peer's Initial TSN in sctp_process_init(), whic=
h in
> a collision runs on the temporary association only:
>
> net/sctp/sm_make_chunk.c:sctp_process_init() {
>         ...
>         asoc->strreset_inseq =3D asoc->peer.i.initial_tsn;
>         ...
>         asoc->peer.addip_serial =3D asoc->peer.i.initial_tsn - 1;
> }
>
> sctp_assoc_update() copies asoc->peer.i but leaves peer.addip_serial and
> strreset_inseq untouched, so a COOKIE_WAIT survivor keeps zero for both.
>
> Can the peer's ASCONF then never be processed?  sctp_sf_do_asconf() now
> clears the capability gate and reaches:
>
> net/sctp/sm_statefuns.c:sctp_sf_do_asconf() {
>         ...
>         if (serial =3D=3D asoc->peer.addip_serial + 1) {
>         ...
>         } else if (serial < asoc->peer.addip_serial + 1) {
>         ...
>         } else {
>                 /* discarded */
>         }
> }
>
> With the peer's serial equal to its Initial TSN and peer.addip_serial at =
0,
> neither arm matches and the chunk lands in the final else, so no ASCONF-A=
CK
> is sent.  Does the peer then retransmit until its T4 limit and give up on
> ASCONF entirely?
>
> The RE-CONFIG side has the same shape.  sctp_process_strreset_outreq(), a=
nd
> equally the inreq/tsnreq/addstrm_out/addstrm_in handlers, validate agains=
t
> the stale strreset_inseq:
>
> net/sctp/stream.c:sctp_process_strreset_outreq() {
>         ...
>         if (TSN_lt(asoc->strreset_inseq, request_seq) ||
>             TSN_lt(request_seq, asoc->strreset_inseq - 2)) {
>                 result =3D SCTP_STRRESET_ERR_BAD_SEQNO;
>                 goto err;
>         }
> }
>
> The testing notes describe ASCONF and RE-CONFIG appearing on the wire, wh=
ich
> exercises the outbound counters (addip_serial and strreset_outseq, both s=
et
> locally from asoc->c.initial_tsn).  Was the inbound direction tested too?
>
> Should the merge also carry strreset_inseq and peer.addip_serial, or
> re-derive them from new->peer.i.initial_tsn the way sctp_process_init() d=
oes?

Makes sense, please follow the suggestion, and add something like:

+       /* Re-derive sequence counters from the peer's Initial TSN */
+       asoc->peer.addip_serial =3D asoc->peer.i.initial_tsn - 1;
+       asoc->strreset_inseq =3D asoc->peer.i.initial_tsn;


>
> > +     asoc->peer.intl_capable =3D new->peer.intl_capable;
>
> [Severity: High]
>
> This bit selects the chunk operation set, and the merge copies the bit
> without re-selecting it.  The only place asoc->stream.si is derived from =
it
> is sctp_stream_interleave_init(), reached from sctp_stream_init():
>
> net/sctp/stream_interleave.c:sctp_stream_interleave_init() {
>         ...
>         stream->si =3D asoc->peer.intl_capable ? &sctp_stream_interleave_=
1
>                                              : &sctp_stream_interleave_0;
> }
>
> In a collision that ran on the temporary association.  Neither branch of
> sctp_assoc_update() refreshes it on the survivor: sctp_stream_update() co=
pies
> out/in/outcnt/incnt and leaves stream->si alone, sctp_stream_clear() only
> zeroes mid/mid_uo, and the COOKIE_ECHOED case calls neither.  asoc->frag_=
point
> is not recomputed either, although normal negotiation pairs the two:
>
> net/sctp/sm_make_chunk.c:sctp_process_init() {
>         ...
>         if (sctp_stream_init(&asoc->stream, ...))
>                 goto clean_up;
>
>         /* Update frag_point when stream_interleave may get changed. */
>         sctp_assoc_update_frag_point(asoc);
> }
>
> So after the merge peer.intl_capable is 1 while stream.si is still
> &sctp_stream_interleave_0.  The INIT-ACK extension list is built from
> peer.intl_capable, so the peer is told I-DATA is in use.  What happens wh=
en
> it sends one?
>
> net/sctp/sm_statefuns.c:sctp_eat_data() {
>         ...
>         if (!asoc->stream.si->validate_data(chunk))
>                 return SCTP_IERROR_PROTO_VIOLATION;
> }
>
> sctp_validate_data() returns false for anything that is not SCTP_CID_DATA=
,
> and the callers turn SCTP_IERROR_PROTO_VIOLATION into
> sctp_sf_abort_violation().  Can a peer that legitimately follows the
> negotiated extension abort the association this way?
>
> There is a second effect in the send path, which branches directly on the
> bit rather than on stream.si:
>
> net/sctp/stream_sched.c:sctp_sched_dequeue_done() {
>         ...
>         if (!list_is_last(&ch->frag_list, &ch->msg->chunks) &&
>             !q->asoc->peer.intl_capable) {
>                 /* pin stream.out_curr */
>         }
> }
>
> With the bit set but plain DATA chunks being dequeued, stream.out_curr is=
 no
> longer pinned mid-message.  Can the PRIO/RR schedulers then interleave
> fragments of different streams on the wire?  Before this patch the surviv=
or
> kept intl_capable at 0 and the pin was taken.
>
> The reverse case looks reachable too: a restart where the new INIT no lon=
ger
> advertises I-DATA now clears the bit while stream.si stays
> &sctp_stream_interleave_1, leaving I-DATA and I-FORWARD-TSN installed for=
 a
> peer that did not negotiate them.
>
> Would calling sctp_stream_interleave_init() and sctp_assoc_update_frag_po=
int()
> on the surviving association after the copy address both directions?

Outqueue may already have data at the time, we can't just call
sctp_stream_interleave_init(). Let's drop the intl_capable update from
this patch and address it separately in another patch.

You may add a note for this in the commit message, so that the AI review
won't report intl_capable update missing.

>
> > +     asoc->peer.ipv4_address =3D new->peer.ipv4_address;
> > +     asoc->peer.ipv6_address =3D new->peer.ipv6_address;
> >       asoc->peer.i =3D new->peer.i;
>
> [Severity: Medium]
>
> This is a pre-existing issue and not introduced by this patch, but since =
the
> copy block is being extended: peer.adaptation_ind is still not carried.
>
> sctp_process_param() records the peer's Adaptation Layer Indication on th=
e
> association it is processing, which in a collision is the temporary one:
>
> net/sctp/sm_make_chunk.c:sctp_process_param() {
>         ...
>         case SCTP_PARAM_ADAPTATION_LAYER_IND:
>                 asoc->peer.adaptation_ind =3D ntohl(param.aind->adaptatio=
n_ind);
> }
>
> and the completion path reads the survivor's copy right after the merge:
>
> net/sctp/sm_statefuns.c:sctp_sf_do_dupcook_b() {
>         ...
>         if (asoc->peer.adaptation_ind)
>                 sctp_add_cmd_sf(commands, SCTP_CMD_ADAPTATION_IND, SCTP_N=
ULL());
> }
>
> For a COOKIE_WAIT survivor the field is still 0, so is the
> SCTP_ADAPTATION_INDICATION notification dropped even though the peer aske=
d
> for it, and on a restart is an older non-zero value reported instead of t=
he
> new one?  asoc->c =3D new->c does update c.adaptation_ind, but nothing co=
pies
> that into peer.adaptation_ind after the merge.
>
> Note this field is a separate __u32 rather than part of the bitfield bloc=
k
> the changelog calls "the rest of the block", so it is outside what the pa=
tch
> sets out to fix.
>

Please address this one as well by adding:

+       asoc->peer.adaptation_ind =3D new->peer.adaptation_ind;

either in this patch or a separate one.

Thanks.
