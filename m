Received: from mail-pz2-f42.google.com (mail-pz2-f42.google.com [74.125.228.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF14349739C
	for <linux-sctp@vger.kernel.org>; Fri, 18 Sep 2026 19:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789759007; cv=pass; b=lbrX0XxAnxOkSI1+7cGuAZmD1dblNPPtRBeuJMoOeSfgHihFsnEb9BSRo68VXXVlCSyP687n9kbdsWQz3/7dX/MLRzq82zapBADTkDygVZaY6Pdv7V9ZQ9VFkfCmPk0MFy7AcPOb4KwUGvNK6ZBmRR8bTdBxa8nyAyb1fNceQjA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789759007; c=relaxed/simple;
	bh=+kE6pypIWaqxLT8QpMKE9tCP/YFqBTg1ofu50nK/3P0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cA/WsHO4CBqNUCwVpTthRYHEu6pZ7tZ5V8on7ckGgPevW2W2cTH3rKt+D1uD0sHavX8s5ujE3KTbzG0MJ9glWmONgtWBFSYu0HKBvpAPAUvWSBh91eniboL9bbxHn4VaL3iwIQCrCJfngSQNmtGfEPC/p7tA4puGcWiBMKozK+M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Erf9Ykr5; arc=pass smtp.client-ip=74.125.228.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Erf9Ykr5"
Received: by mail-pz2-f42.google.com with SMTP id d2e1a72fcca58-86efece610cso976992b3a.0
        for <linux-sctp@vger.kernel.org>; Fri, 18 Sep 2026 12:16:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789759001; cv=none;
        d=google.com; s=arc-20260327;
        b=sNIYScma25/6+eWnOOotFdV5Owfgw0HlBb9IEOvunancvm1wXRTE/mxiBEj1XUvs5n
         +xHXQ9JL2X6k50LV2l/dlF4w9faO64NrQKERod7PDoRIebdg4tVaMGR29jQqCti+iuE8
         aNG4bWQskRYw2RxqUYOgN/KkBRJXgoZHYVKdyuznJPb23oeqT1oMToSzEefmTCuaTD9e
         DLtXslRE7YmFtKZUbsqYGYWkG/RIKVC30GFsufgY49xkS8Jb5lcbluWPZoZLfufkg/1s
         CzgnrkIc6H1c6PiVehykFQ7lwNCV9bezm4HaYyTLy2aDKJXi9j7pIysEVY1Ib8lZcZWD
         3ePQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=MJwwvlLAahzc9A5+UQqMnavkFy6oQ6Danu/5kn4VbWM=;
        fh=Xo6/qAYnt+81/TS+p28BSZhC1/HaWU+bEedopGQ41ms=;
        b=mkFW+wJDyqPD8g1FsbU+xkm7U7MvdxV++A30l2BEVq9thDkmPNlH9ObamTlcM1ngwp
         ksu3PgVR8n9StH6yCRlvzdzG/M6KL+t0xhiSSVmN3TDTOYKjNTx6l9e5FoDKJaZY+2Ys
         vV3i+ZfQShjc9l0st+pElVSRhhXi0nvsRl6y2NPz30aaRj+zGxl1ousVIE7kyTBIuG0P
         vkcAZazxpEdegCmx5drX13a2hxl6JwaYfQgTMwuUDeNYJW9JPi7wQIMMA00wqBxcLeTB
         xUnbD3OJ2NL6FSnyD69XuX72aJnrmGEmKY3O7xXh059GfpMBcKsB3+K+pImw55NrVCXO
         5I4g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789759001; x=1790363801; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=MJwwvlLAahzc9A5+UQqMnavkFy6oQ6Danu/5kn4VbWM=;
        b=Erf9Ykr52vavvtDfAakUcqixfTvtOpyvQGK9cr/dhywTqihcIlnzOxpBa+WJ2Jn3J4
         cf4IvkwWgJHIsn0IrsCPvwB478Bcg1xvJ1C27Z8Jf8E9R7Fse4OfWCgbLgahclmfjugq
         R+HlCrlzZfO8eDuT3BZYD3Q3Hj41TsVBuHVM4UZDjp45ui7VRGeaHiSxWAeYZ5TFd7UZ
         iCvs6kjUcGYDcd5nBrMXBCc7fpcUq6BJ8u96ZF0jX0NGjEHzM3zoXpEEeKXprH8KWr4g
         8gqriqQy1kM86QQn3vMxrJSznXq9RGKflNZu8YfHRpM9nbE5CgO5tVsX2H3AS7oaJvsz
         5ZVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789759001; x=1790363801;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MJwwvlLAahzc9A5+UQqMnavkFy6oQ6Danu/5kn4VbWM=;
        b=nXq/M7dqn3xybyB5yweuSsVEVB9AknZl342ghIFjxQYEbrRZ1spq5BRcSNfPNKlGsX
         IvmxCGSrOBuUBv72f7lOmwN0A5c1FnNX+XcyARLx9D+dn0ljRVcuSMs3ODKbFK5T6aXb
         9KD2MoiSPZmb7hiEFN2PhT9czxHWOuaMvOcffJTAI/7wAS0bZ7skS9eIQJJWu6bd2BhI
         WDIgXXyAcZcWoYidWhcAIx9YzJhdDPbODBYdm4FObCiJ39jjsi0+crxNUsI8m6NsJK+g
         h+75afPjOlfTI3V8+6Vk/iXF/rhg8HZpOs+dxpyfCwhhVjfOGzVDGfxArlf3jrJAlkga
         rZAg==
X-Forwarded-Encrypted: i=1; AKwUvBzmwsD52FK/oxGqdh6Gyvrk/x06RZMu4ZvrcZji0YsKzSOIZAeofFqnMOLcilGh2iUzyQQnTlenLGkD@vger.kernel.org
X-Gm-Message-State: AFuF++lYheRNmPxdQBQDn+69yN21UcurXSHzdsHr/qqYUCTYCCeUqdtn
	UT9qI0/D7/OptuZTOqdIBXoUn/55lZSA1M8I5AztCt48RnDB6jF0wOkNXqpXfSglitl4dHCJrok
	KNVVOYC/ByPC0dFsmw8iqp99kLRvR+t0=
X-Gm-Gg: AYBFou2i2TnIJvapZUXajlZsjdHWDhguvBuoS15hfABLlAr0LWVaPth9wbqFz4wqpDC
	UhKHbm+W4KQXKJjHRXJEdzLkg4sCaX5Ga80cLapPz5ZGA9PG7R2zPGrKoE7UxdeFtkwsVIH3zZQ
	lWYWp+mEhqBRNFOaaXrNsrXYj/be/fktO2AD80iA1udzrl58O4WzYcmzB0agydBc2Gvew4tEDJF
	gST4d+qH6/5NvSFJU2kO770o8SG6Prn9dk8uRUVIPWaLO8uOFfPivbra315oRplNyOP9CFESTNw
	z/U2LIyvgnrWWfwUJJxp5YRkvK+V7ZPC8nvhWoSJMySd1dy+gm2AnEZFzIpGLYRNLowujHjL5he
	qszY2ZkRioBiTsHxIks1gNXn75gLUGS/RMQRa3Wfip+yrK8dcERcXtY/e
X-Received: by 2002:a05:6a00:4309:b0:874:708d:b636 with SMTP id
 d2e1a72fcca58-874df60bf54mr7154912b3a.34.1789759000656; Fri, 18 Sep 2026
 12:16:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260916080955.1019050-1-ljp1205831794@gmail.com> <178968660727.22033.2420657272100663531@kernel.org>
In-Reply-To: <178968660727.22033.2420657272100663531@kernel.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 18 Sep 2026 15:16:29 -0400
X-Gm-Features: AcwNN1XDv7Km9mboXfGTYLkpsRcDPj4Flu2sSn8LplciIDY6w4j_L8AObWcQMWE
Message-ID: <CADvbK_eQjfg_-HLT3zJ5Bt5LWbUTx_+fLG5ggLPNY1Ah+sF9GA@mail.gmail.com>
Subject: Re: [PATCH net] sctp: don't re-register a removed transport as last_data_from
To: netdev-bot+sashiko@kernel.org
Cc: ljp1205831794@gmail.com, netdev@vger.kernel.org, 
	linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, imv4bel@gmail.com, 
	henrymei@tencent.com, corvus@tencent.com, stable@vger.kernel.org, 
	kuba@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 17, 2026 at 7:10=E2=80=AFPM <netdev-bot+sashiko@kernel.org> wro=
te:
>
> Thank you for your contribution! Sashiko AI review found 2 potential
> issue(s) to consider:
>
> Critical: 0 =C2=B7 High: 1 =C2=B7 Medium: 1 =C2=B7 Low: 0
>
> - [High] Incomplete fix: the patch only sanitizes the two
>   `asoc->peer.last_data_from` re-registration sites, but leaves the=E2=80=
=A6
> - [Medium] The new use-after-free guard reads `transport->dead`, which is
>   bit 0 of an unlocked, non-atomically updated `__u32` bitfield in=E2=80=
=A6
>
> --
>
> sctp: don't re-register a removed transport as last_data_from
>
> This patch stops sctp_assoc_bh_rcv() and sctp_endpoint_bh_rcv() from stor=
ing
> a transport into asoc->peer.last_data_from when that transport has alread=
y
> been marked dead, which happens when an earlier chunk of the same packet
> removes the transport the packet arrived on. The intent is to preserve th=
e
> redirection that sctp_assoc_rm_peer() performed, so last_data_from is not
> left pointing at a transport that gets RCU-freed at the end of sctp_rcv()=
.
>
> A couple of questions below.
>
> > diff --git a/net/sctp/associola.c b/net/sctp/associola.c
> > index c0512c827d0f5..e14fd88e69d6b 100644
> > --- a/net/sctp/associola.c
> > +++ b/net/sctp/associola.c
> > @@ -1030,11 +1030,19 @@ static void sctp_assoc_bh_rcv(struct work_struc=
t *work)
> >                       continue;
> >
> >               /* Remember where the last DATA chunk came from so we
> > -              * know where to send the SACK.
> > +              * know where to send the SACK.  chunk->transport may hav=
e
> > +              * been removed while processing an earlier chunk of this
> > +              * same packet (e.g. a stale-cookie ERROR chunk queues
> > +              * SCTP_CMD_DEL_NON_PRIMARY, which removes the non-primar=
y
> > +              * transport this packet arrived on), so never register a
> > +              * dead transport; otherwise last_data_from would be left
> > +              * dangling once the receive reference is dropped and the
> > +              * transport is freed.
> >                */
> > -             if (sctp_chunk_is_data(chunk))
> > -                     asoc->peer.last_data_from =3D chunk->transport;
> > -             else {
> > +             if (sctp_chunk_is_data(chunk)) {
> > +                     if (!chunk->transport || !chunk->transport->dead)
> > +                             asoc->peer.last_data_from =3D chunk->tran=
sport;
> > +             } else {
>
> [Severity: High]
>
> Is guarding only the last_data_from store enough here?  After the earlier
> chunk removed the arrival transport, the rest of this same loop iteration=
 in
> sctp_assoc_bh_rcv() still uses the dead transport:
>
>         if (chunk->transport)
>                 chunk->transport->last_time_heard =3D ktime_get();
>
>         error =3D sctp_do_sm(net, SCTP_EVENT_T_CHUNK, subtype,
>                            state, ep, asoc, chunk, GFP_ATOMIC);
>
> so chunk->transport is handed to the state machine for every remaining ch=
unk
> of the packet, and other sinks copy it into association-lifetime state.
>
> The redirection in sctp_assoc_rm_peer() looks like a one-shot snapshot:
>
>         if (asoc->peer.last_data_from =3D=3D peer)
>                 asoc->peer.last_data_from =3D transport;
>         ...
>         list_for_each_entry(ch, &asoc->outqueue.control_chunk_list, list)
>                 if (ch->transport =3D=3D peer)
>                         ch->transport =3D NULL;
>
> Only references that already exist at removal time are rewritten, so any
> reference created by a later chunk of the same packet is never cleaned,
> because the transport is already unhashed and off the transport list.
>
> One such later reference is in sctp_cmd_setup_t2(), which has no dead tes=
t:
>
>         if (chunk->transport)
>                 t =3D chunk->transport;
>         ...
>         asoc->shutdown_last_sent_to =3D t;
>         asoc->timeouts[SCTP_EVENT_TIMEOUT_T2_SHUTDOWN] =3D t->rto;
>
> sctp_sf_t2_timer_expire() later does SCTP_CMD_STRIKE on
> asoc->shutdown_last_sent_to, and sctp_do_8_2_transport_strike() reads and
> writes the transport from timer context, after the receive reference is g=
one.
>
> Is that path reachable mid-packet?  sctp_assoc_rm_peer() is also called f=
rom
> sctp_assoc_update() on the COOKIE-ECHO restart path, and that leaves the
> association ESTABLISHED for the following bundled chunks, so a bundled
> [COOKIE ECHO][SHUTDOWN] appears to reach sctp_sf_do_9_2_shutdown() and th=
en
> SCTP_CMD_SETUP_T2 with the removed transport.
>
> A second sink is the reply chunks, for example sctp_make_heartbeat_ack():
>
>         if (chunk)
>                 retval->transport =3D chunk->transport;
>
> The same assignment exists in sctp_make_op_error(), sctp_make_abort*(),
> sctp_make_shutdown*(), sctp_make_cookie_echo() and sctp_make_cwr().  Such=
 a
> chunk is queued on asoc->outqueue.control_chunk_list after
> sctp_assoc_rm_peer() already sanitized that list, so it is not covered by=
 the
> redirection.
>
> Can that chunk outlive the packet?  In sctp_outq_flush_ctrl() a one_packe=
t
> control chunk that returns SCTP_XMIT_PMTU_FULL is put back:
>
>                         if (status !=3D SCTP_XMIT_OK) {
>                                 /* put the chunk back */
>                                 list_add(&chunk->list, &ctx->q->control_c=
hunk_list);
>
> and the src_out_of_asoc_ok branch skips non-ASCONF chunks:
>
>                 if (ctx->asoc->src_out_of_asoc_ok && chunk->chunk_hdr->ty=
pe !=3D SCTP_CID_ASCONF)
>                         continue;
>
> sctp_packet_will_fit() returns PMTU_FULL for an oversized control chunk o=
nce
> the packet is non-empty, and the peer controls the HEARTBEAT payload size=
.
> On the next flush, sctp_outq_select_transport() reads new_transport->stat=
e
> with no dead check, keeps the transport for HEARTBEAT/HEARTBEAT_ACK/
> ASCONF_ACK, then writes into it and links it into the live list:
>
>                 if (list_empty(&ctx->transport->send_ready))
>                         list_add_tail(&ctx->transport->send_ready, &ctx->=
transport_list);
>                 sctp_packet_config(ctx->packet, ...);
>                 sctp_transport_burst_limited(ctx->transport);
>
> That is the same read/write plus live-list linking the commit message
> describes for the reported case.
>
> This also seems to go against the policy the commit message cites from co=
mmit
> 03a9d10ecf71, where sctp_inq_push() frees such a chunk outright:
>
>         if (chunk->rcvr->dead ||
>             (chunk->transport && chunk->transport->dead)) {
>                 sctp_chunk_free(chunk);
>                 return;
>         }
>
> Would discarding the remaining chunks of the packet, or clearing
> chunk->transport when the arrival transport is removed mid-packet, be mor=
e
> consistent with that and cover the other sinks too?  Note that the ASCONF
> DEL-IP path already refuses to remove the arrival transport at all:
>
>         if (peer =3D=3D asconf->transport)
>                 return SCTP_ERROR_REQ_REFUSED;
>
> Related to that, the commit message says the fix works because "both
> re-registration sites (the association and the endpoint backlog paths) ca=
n
> simply skip it, keeping the redirection done by sctp_assoc_rm_peer() in
> effect".  Is that accurate for anything other than last_data_from?  The
> sctp_cmd_setup_t2() and reply-chunk references above are created after
> sctp_assoc_rm_peer() has run and are not redirected by it.
>
> > diff --git a/net/sctp/endpointola.c b/net/sctp/endpointola.c
> > index a15b599b20b76..f1e2acf8d9bcb 100644
> > --- a/net/sctp/endpointola.c
> > +++ b/net/sctp/endpointola.c
> > @@ -396,11 +396,13 @@ static void sctp_endpoint_bh_rcv(struct work_stru=
ct *work)
> >                       continue;
> >
> >               /* Remember where the last DATA chunk came from so we
> > -              * know where to send the SACK.
> > +              * know where to send the SACK.  As in sctp_assoc_bh_rcv(=
),
> > +              * never register a dead (already removed) transport.
> >                */
> > -             if (asoc && sctp_chunk_is_data(chunk))
> > -                     asoc->peer.last_data_from =3D chunk->transport;
> > -             else {
> > +             if (asoc && sctp_chunk_is_data(chunk)) {
> > +                     if (!chunk->transport || !chunk->transport->dead)
> > +                             asoc->peer.last_data_from =3D chunk->tran=
sport;
> > +             } else {
>
> [Severity: Medium]
>
> Can the dead bit read by this new guard, in both sctp_endpoint_bh_rcv() a=
nd
> sctp_assoc_bh_rcv(), be lost to a concurrent bitfield update?  In
> struct sctp_transport the flag shares one storage unit with the others:
>
>         __u32   dead:1,
>                 rto_pending:1,
>                 hb_sent:1,
>                 pmtu_pending:1,
>                 dst_pending_confirm:1,
>                 sack_generation:1;
>
> The two writers of that word do not share a lock.  sctp_transport_free()
> does transport->dead =3D 1, reached in the scenario of this commit from
> sctp_assoc_bh_rcv() -> sctp_do_sm() -> sctp_cmd_del_non_primary() ->
> sctp_assoc_rm_peer().  When that runs from backlog processing,
> __release_sock() has already dropped sk->sk_lock.slock before calling
> sk_backlog_rcv(), so only the owned flag is held.
>
> Meanwhile sctp_icmp_frag_needed(), from sctp_v4_err()/sctp_v6_err() in
> softirq, holds only bh_lock_sock() and writes another bit of the same wor=
d,
> in exactly the branch taken when a process-context owner is running:
>
>         if (sock_owned_by_user(sk)) {
>                 atomic_set(&t->mtu_info, pmtu);
>                 asoc->pmtu_pending =3D 1;
>                 t->pmtu_pending =3D 1;
>                 return;
>         }
>
> sctp_err_lookup() holds a transport reference from
> __sctp_lookup_association(), so both CPUs can legitimately be touching th=
e
> same object.  A single-bit assignment compiles to a non-atomic
> read-modify-write of the containing byte or word, so the softirq store ca=
n
> write back a copy loaded before dead =3D 1 became visible.
>
> If dead is reset that way, this guard evaluates to true, the removed
> transport is re-registered in asoc->peer.last_data_from, and the
> use-after-free is back; the existing sctp_inq_push() drop on the same fla=
g
> would be defeated the same way.  The neighbouring atomic_set() on t->mtu_=
info
> suggests this field is already known to be touched cross-context.
>
> Would putting dead in its own word with WRITE_ONCE()/READ_ONCE(), or a fi=
x
> that does not read the flag at all (clearing chunk->transport when the
> arrival transport is removed mid-packet), avoid depending on this?
>
> --
> Sashiko AI review =C2=B7 https://netdev-ai.bots.linux.dev/sashiko/#/patch=
set/20260916080955.1019050-1-ljp1205831794%40gmail.com

Can you try to fix this issue by discarding the packet in
sctp_sf_do_5_2_6_stale() instead? like:

@@ -2653,6 +2653,7 @@ static enum sctp_disposition sctp_sf_do_5_2_6_stale(
                        SCTP_TO(SCTP_EVENT_TIMEOUT_T1_INIT));

        sctp_add_cmd_sf(commands, SCTP_CMD_REPLY, SCTP_CHUNK(reply));
+       sctp_add_cmd_sf(commands, SCTP_CMD_DISCARD_PACKET, SCTP_NULL());

        return SCTP_DISPOSITION_CONSUME;

Please also share the PoC with the maintainers if there's one.

Thanks.
