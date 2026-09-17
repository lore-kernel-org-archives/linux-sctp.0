Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 160AD343893;
	Thu, 17 Sep 2026 23:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789686621; cv=none; b=YvYxVui3MyUdV3qmNp+Bpb9KSEm0+3/MKqL5lvmlUGGVzBsialpDhGtyIioicSBFC9sUasMdwnCVDNfPg48YFsiBR9inN04cDDnwaoNOi2gBDFu/mgjJfdHBOnzs7TC3ULkk/IEVuc9ueJsWIQtTeRy6Vl0v3SdBdm/6NxlwZes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789686621; c=relaxed/simple;
	bh=3jyM1EWDFF6E/Am67mfIEhODV3GM6/r28TRHUrOMzko=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jMBDr1hbEjbg+7T50Sxgtedf43o168kSOpCHMRTPF/ygbBuQWDhG0Ologx7AudqJb+nUeaqR94e6TJp5KtV9WEEu/fJFSgTEfTn8rapqC+pz/j4LJJ/UDEko1vdvM6TWi9k0YAAGUvVYR0NK+5VPaCvPXeqZl11sc72gPCSAyG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JZVKPc5R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JZVKPc5R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BED531F000FF;
	Thu, 17 Sep 2026 23:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789686608;
	bh=xIGrAGe/P/RCIwrYkEWKwTAtXfVDVt4zZuCvCF6I428=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=JZVKPc5RKfuo4hWfYA1ibLSLBS7jAb+/kYYrR3NqhmEt09vJ1UU7lML49jzbzkqfd
	 VmXhjVSJoscrcGg/1Pko+/bSlT7PxWGtb4qZbR0mX87LHx31lJG+PWKh8PALa35pnY
	 HUla4jRb6+WnJKXxp8bNmcM7mumqfdKi7k1fz+BKVN+cUSZDbs32juzOy22LdFH8EE
	 oF8bqa2lC2gHjXLr+8pPduy2n31GCC5959J/rCfgaU+yiYl/6ktMI7yedys8EXSdoT
	 RuuiBQ9Gtts0VbIhBC2bNBaD/bbv6J4pczaUOSkNf+ubwVrXBNJbTMNV1BjTlbqoLn
	 lt5efyTzs2ZIg==
Subject:
 Re: [PATCH net] sctp: don't re-register a removed transport as last_data_from
From: netdev-bot+sashiko@kernel.org
To: ljp1205831794@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
 marcelo.leitner@gmail.com, lucien.xin@gmail.com, imv4bel@gmail.com,
 henrymei@tencent.com, corvus@tencent.com, stable@vger.kernel.org,
 kuba@kernel.org
Date: Thu, 17 Sep 2026 23:10:07 +0000
Message-ID: <178968660727.22033.2420657272100663531@kernel.org>
In-Reply-To: <20260916080955.1019050-1-ljp1205831794@gmail.com>
References: <20260916080955.1019050-1-ljp1205831794@gmail.com>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider:

Critical: 0 · High: 1 · Medium: 1 · Low: 0

- [High] Incomplete fix: the patch only sanitizes the two
  `asoc->peer.last_data_from` re-registration sites, but leaves the…
- [Medium] The new use-after-free guard reads `transport->dead`, which is
  bit 0 of an unlocked, non-atomically updated `__u32` bitfield in…

--

sctp: don't re-register a removed transport as last_data_from

This patch stops sctp_assoc_bh_rcv() and sctp_endpoint_bh_rcv() from storing
a transport into asoc->peer.last_data_from when that transport has already
been marked dead, which happens when an earlier chunk of the same packet
removes the transport the packet arrived on. The intent is to preserve the
redirection that sctp_assoc_rm_peer() performed, so last_data_from is not
left pointing at a transport that gets RCU-freed at the end of sctp_rcv().

A couple of questions below.

> diff --git a/net/sctp/associola.c b/net/sctp/associola.c
> index c0512c827d0f5..e14fd88e69d6b 100644
> --- a/net/sctp/associola.c
> +++ b/net/sctp/associola.c
> @@ -1030,11 +1030,19 @@ static void sctp_assoc_bh_rcv(struct work_struct *work)
>  			continue;
>  
>  		/* Remember where the last DATA chunk came from so we
> -		 * know where to send the SACK.
> +		 * know where to send the SACK.  chunk->transport may have
> +		 * been removed while processing an earlier chunk of this
> +		 * same packet (e.g. a stale-cookie ERROR chunk queues
> +		 * SCTP_CMD_DEL_NON_PRIMARY, which removes the non-primary
> +		 * transport this packet arrived on), so never register a
> +		 * dead transport; otherwise last_data_from would be left
> +		 * dangling once the receive reference is dropped and the
> +		 * transport is freed.
>  		 */
> -		if (sctp_chunk_is_data(chunk))
> -			asoc->peer.last_data_from = chunk->transport;
> -		else {
> +		if (sctp_chunk_is_data(chunk)) {
> +			if (!chunk->transport || !chunk->transport->dead)
> +				asoc->peer.last_data_from = chunk->transport;
> +		} else {

[Severity: High]

Is guarding only the last_data_from store enough here?  After the earlier
chunk removed the arrival transport, the rest of this same loop iteration in
sctp_assoc_bh_rcv() still uses the dead transport:

	if (chunk->transport)
		chunk->transport->last_time_heard = ktime_get();

	error = sctp_do_sm(net, SCTP_EVENT_T_CHUNK, subtype,
			   state, ep, asoc, chunk, GFP_ATOMIC);

so chunk->transport is handed to the state machine for every remaining chunk
of the packet, and other sinks copy it into association-lifetime state.

The redirection in sctp_assoc_rm_peer() looks like a one-shot snapshot:

	if (asoc->peer.last_data_from == peer)
		asoc->peer.last_data_from = transport;
	...
	list_for_each_entry(ch, &asoc->outqueue.control_chunk_list, list)
		if (ch->transport == peer)
			ch->transport = NULL;

Only references that already exist at removal time are rewritten, so any
reference created by a later chunk of the same packet is never cleaned,
because the transport is already unhashed and off the transport list.

One such later reference is in sctp_cmd_setup_t2(), which has no dead test:

	if (chunk->transport)
		t = chunk->transport;
	...
	asoc->shutdown_last_sent_to = t;
	asoc->timeouts[SCTP_EVENT_TIMEOUT_T2_SHUTDOWN] = t->rto;

sctp_sf_t2_timer_expire() later does SCTP_CMD_STRIKE on
asoc->shutdown_last_sent_to, and sctp_do_8_2_transport_strike() reads and
writes the transport from timer context, after the receive reference is gone.

Is that path reachable mid-packet?  sctp_assoc_rm_peer() is also called from
sctp_assoc_update() on the COOKIE-ECHO restart path, and that leaves the
association ESTABLISHED for the following bundled chunks, so a bundled
[COOKIE ECHO][SHUTDOWN] appears to reach sctp_sf_do_9_2_shutdown() and then
SCTP_CMD_SETUP_T2 with the removed transport.

A second sink is the reply chunks, for example sctp_make_heartbeat_ack():

	if (chunk)
		retval->transport = chunk->transport;

The same assignment exists in sctp_make_op_error(), sctp_make_abort*(),
sctp_make_shutdown*(), sctp_make_cookie_echo() and sctp_make_cwr().  Such a
chunk is queued on asoc->outqueue.control_chunk_list after
sctp_assoc_rm_peer() already sanitized that list, so it is not covered by the
redirection.

Can that chunk outlive the packet?  In sctp_outq_flush_ctrl() a one_packet
control chunk that returns SCTP_XMIT_PMTU_FULL is put back:

			if (status != SCTP_XMIT_OK) {
				/* put the chunk back */
				list_add(&chunk->list, &ctx->q->control_chunk_list);

and the src_out_of_asoc_ok branch skips non-ASCONF chunks:

		if (ctx->asoc->src_out_of_asoc_ok && chunk->chunk_hdr->type != SCTP_CID_ASCONF)
			continue;

sctp_packet_will_fit() returns PMTU_FULL for an oversized control chunk once
the packet is non-empty, and the peer controls the HEARTBEAT payload size.
On the next flush, sctp_outq_select_transport() reads new_transport->state
with no dead check, keeps the transport for HEARTBEAT/HEARTBEAT_ACK/
ASCONF_ACK, then writes into it and links it into the live list:

		if (list_empty(&ctx->transport->send_ready))
			list_add_tail(&ctx->transport->send_ready, &ctx->transport_list);
		sctp_packet_config(ctx->packet, ...);
		sctp_transport_burst_limited(ctx->transport);

That is the same read/write plus live-list linking the commit message
describes for the reported case.

This also seems to go against the policy the commit message cites from commit
03a9d10ecf71, where sctp_inq_push() frees such a chunk outright:

	if (chunk->rcvr->dead ||
	    (chunk->transport && chunk->transport->dead)) {
		sctp_chunk_free(chunk);
		return;
	}

Would discarding the remaining chunks of the packet, or clearing
chunk->transport when the arrival transport is removed mid-packet, be more
consistent with that and cover the other sinks too?  Note that the ASCONF
DEL-IP path already refuses to remove the arrival transport at all:

	if (peer == asconf->transport)
		return SCTP_ERROR_REQ_REFUSED;

Related to that, the commit message says the fix works because "both
re-registration sites (the association and the endpoint backlog paths) can
simply skip it, keeping the redirection done by sctp_assoc_rm_peer() in
effect".  Is that accurate for anything other than last_data_from?  The
sctp_cmd_setup_t2() and reply-chunk references above are created after
sctp_assoc_rm_peer() has run and are not redirected by it.

> diff --git a/net/sctp/endpointola.c b/net/sctp/endpointola.c
> index a15b599b20b76..f1e2acf8d9bcb 100644
> --- a/net/sctp/endpointola.c
> +++ b/net/sctp/endpointola.c
> @@ -396,11 +396,13 @@ static void sctp_endpoint_bh_rcv(struct work_struct *work)
>  			continue;
>  
>  		/* Remember where the last DATA chunk came from so we
> -		 * know where to send the SACK.
> +		 * know where to send the SACK.  As in sctp_assoc_bh_rcv(),
> +		 * never register a dead (already removed) transport.
>  		 */
> -		if (asoc && sctp_chunk_is_data(chunk))
> -			asoc->peer.last_data_from = chunk->transport;
> -		else {
> +		if (asoc && sctp_chunk_is_data(chunk)) {
> +			if (!chunk->transport || !chunk->transport->dead)
> +				asoc->peer.last_data_from = chunk->transport;
> +		} else {

[Severity: Medium]

Can the dead bit read by this new guard, in both sctp_endpoint_bh_rcv() and
sctp_assoc_bh_rcv(), be lost to a concurrent bitfield update?  In
struct sctp_transport the flag shares one storage unit with the others:

	__u32	dead:1,
		rto_pending:1,
		hb_sent:1,
		pmtu_pending:1,
		dst_pending_confirm:1,
		sack_generation:1;

The two writers of that word do not share a lock.  sctp_transport_free()
does transport->dead = 1, reached in the scenario of this commit from
sctp_assoc_bh_rcv() -> sctp_do_sm() -> sctp_cmd_del_non_primary() ->
sctp_assoc_rm_peer().  When that runs from backlog processing,
__release_sock() has already dropped sk->sk_lock.slock before calling
sk_backlog_rcv(), so only the owned flag is held.

Meanwhile sctp_icmp_frag_needed(), from sctp_v4_err()/sctp_v6_err() in
softirq, holds only bh_lock_sock() and writes another bit of the same word,
in exactly the branch taken when a process-context owner is running:

	if (sock_owned_by_user(sk)) {
		atomic_set(&t->mtu_info, pmtu);
		asoc->pmtu_pending = 1;
		t->pmtu_pending = 1;
		return;
	}

sctp_err_lookup() holds a transport reference from
__sctp_lookup_association(), so both CPUs can legitimately be touching the
same object.  A single-bit assignment compiles to a non-atomic
read-modify-write of the containing byte or word, so the softirq store can
write back a copy loaded before dead = 1 became visible.

If dead is reset that way, this guard evaluates to true, the removed
transport is re-registered in asoc->peer.last_data_from, and the
use-after-free is back; the existing sctp_inq_push() drop on the same flag
would be defeated the same way.  The neighbouring atomic_set() on t->mtu_info
suggests this field is already known to be touched cross-context.

Would putting dead in its own word with WRITE_ONCE()/READ_ONCE(), or a fix
that does not read the flag at all (clearing chunk->transport when the
arrival transport is removed mid-packet), avoid depending on this?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260916080955.1019050-1-ljp1205831794%40gmail.com
