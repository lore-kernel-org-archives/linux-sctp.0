Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34AA831578E;
	Thu, 24 Sep 2026 01:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790215148; cv=none; b=pVno7pPYSzZa6KBBJYXRVRol6wt2T0ETbdqMXeje9jKpDA+45HLR2cmk81uhSY71MHRZ1jLZOQYrRJWlOvnOzhyaKgtbeIhQBBMyqlqvF9By4UgZF49PRAgWPkINpwbAwMfLsFrKsubnolmTCulKc0fXBI+xuNihgnFqCxveeTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790215148; c=relaxed/simple;
	bh=ng3NjO7xLm02YelMfX/Z3DVR/wZvosLB8vx7H8B7APE=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=mzj8ILm3/7TQAVZkg195ViztCdiLI1NllDo6PDd/5WsXoJX2ekkEInSsKB4BCwg8z7HXnJY/f4Nm+kPKWAjZ3NHc0/PkSMNtuy6JWpzqCWgnOZdO9jRKxJQB2yIEn9/JSJzxxtogfOpiU6YOYi6tG2av0N9n/HgNpz0Eb1CaCZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XHQa58Pe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XHQa58Pe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 203841F000FF;
	Thu, 24 Sep 2026 01:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790215146;
	bh=l8JNnc2oBRcvuUjWimJY2wugiW93wv8FZSUibAK5Phg=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=XHQa58PeyX8/BRNnOdBaAr3/5o09RQbpSO/tChP123Ks/PUMsaH4iQd8UGDBkl28r
	 ug+H7f3sBf0pzPCLtiI0LBtnnEO5Kd4j/+Hg5U5gW6cX1vsG9xgqeXL2eUxy6xFkLe
	 vYxYcisqVQf0HUL3ujE/+DtDDTDUQ3UtldTgaYDU6ULFvK3X3iAlj+TZRD3AhqOAVB
	 AI+jr8FyMNCOxZqON8WVX57YQZhWvRR4UwdcW7rH1iNOATnFZdISTsJeNF9cAMr7Ql
	 34csEuFuTXQMuqq6lxLEMU1r8dVpmsF1MbQwbCt37aQCRN9NXdfExZAgrxEJK9ovyc
	 9YBA+bkzONCgg==
Subject:
 Re: [PATCH net v3] sctp: carry peer capabilities across an INIT collision
From: netdev-bot+sashiko@kernel.org
To: wbriggs@cellusys.com
Cc: marcelo.leitner@gmail.com, lucien.xin@gmail.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
Date: Thu, 24 Sep 2026 01:59:05 +0000
Message-ID: <179021514567.2160803.16218616091479610626@kernel.org>
In-Reply-To: <20260921135733.577647-1-wbriggs@cellusys.com>
References: <20260921135733.577647-1-wbriggs@cellusys.com>
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
issue(s) to consider.

Critical: 0 · High: 2 · Medium: 0 (1) · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] sctp_assoc_update() (net/sctp/associola.c:1114) now copies
  new->peer.intl_capable into the surviving association but never re-…
- [High] sctp_assoc_update() now enables peer.asconf_capable
  (net/sctp/associola.c:1112) and peer.reconf_capable (associola.c:1113)…

Pre-existing issues:
- [Medium] The collision merge still does not carry
  asoc->peer.adaptation_ind.

--

sctp: carry peer capabilities across an INIT collision

sctp_assoc_update() folds a temporary association into an existing one when
an INIT collision is resolved, and today it only copies asoc->c, peer.rwnd,
peer.sack_needed, peer.auth_capable and peer.i.  This patch extends the copy
block with prsctp_capable, ecn_capable, asconf_capable, reconf_capable,
intl_capable, ipv4_address and ipv6_address so the surviving association
reflects what the peer advertised in the colliding INIT.

A few questions about the state that is derived from those bits but is not
refreshed by the merge.

> diff --git a/net/sctp/associola.c b/net/sctp/associola.c
> index 4521be3bd85aa..0bd0a662b5463 100644
> --- a/net/sctp/associola.c
> +++ b/net/sctp/associola.c
> @@ -1107,6 +1107,13 @@ int sctp_assoc_update(struct sctp_association *asoc,
>  	asoc->peer.rwnd = new->peer.rwnd;
>  	asoc->peer.sack_needed = new->peer.sack_needed;
>  	asoc->peer.auth_capable = new->peer.auth_capable;
> +	asoc->peer.prsctp_capable = new->peer.prsctp_capable;
> +	asoc->peer.ecn_capable = new->peer.ecn_capable;
> +	asoc->peer.asconf_capable = new->peer.asconf_capable;
> +	asoc->peer.reconf_capable = new->peer.reconf_capable;

[Severity: High]

Turning these two bits on lets the surviving association accept inbound
ASCONF and RE-CONFIG, but the receive-side sequence counters those features
compare against are still the survivor's own.

Both are derived from the peer's Initial TSN in sctp_process_init(), which in
a collision runs on the temporary association only:

net/sctp/sm_make_chunk.c:sctp_process_init() {
	...
	asoc->strreset_inseq = asoc->peer.i.initial_tsn;
	...
	asoc->peer.addip_serial = asoc->peer.i.initial_tsn - 1;
}

sctp_assoc_update() copies asoc->peer.i but leaves peer.addip_serial and
strreset_inseq untouched, so a COOKIE_WAIT survivor keeps zero for both.

Can the peer's ASCONF then never be processed?  sctp_sf_do_asconf() now
clears the capability gate and reaches:

net/sctp/sm_statefuns.c:sctp_sf_do_asconf() {
	...
	if (serial == asoc->peer.addip_serial + 1) {
	...
	} else if (serial < asoc->peer.addip_serial + 1) {
	...
	} else {
		/* discarded */
	}
}

With the peer's serial equal to its Initial TSN and peer.addip_serial at 0,
neither arm matches and the chunk lands in the final else, so no ASCONF-ACK
is sent.  Does the peer then retransmit until its T4 limit and give up on
ASCONF entirely?

The RE-CONFIG side has the same shape.  sctp_process_strreset_outreq(), and
equally the inreq/tsnreq/addstrm_out/addstrm_in handlers, validate against
the stale strreset_inseq:

net/sctp/stream.c:sctp_process_strreset_outreq() {
	...
	if (TSN_lt(asoc->strreset_inseq, request_seq) ||
	    TSN_lt(request_seq, asoc->strreset_inseq - 2)) {
		result = SCTP_STRRESET_ERR_BAD_SEQNO;
		goto err;
	}
}

The testing notes describe ASCONF and RE-CONFIG appearing on the wire, which
exercises the outbound counters (addip_serial and strreset_outseq, both set
locally from asoc->c.initial_tsn).  Was the inbound direction tested too?

Should the merge also carry strreset_inseq and peer.addip_serial, or
re-derive them from new->peer.i.initial_tsn the way sctp_process_init() does?

> +	asoc->peer.intl_capable = new->peer.intl_capable;

[Severity: High]

This bit selects the chunk operation set, and the merge copies the bit
without re-selecting it.  The only place asoc->stream.si is derived from it
is sctp_stream_interleave_init(), reached from sctp_stream_init():

net/sctp/stream_interleave.c:sctp_stream_interleave_init() {
	...
	stream->si = asoc->peer.intl_capable ? &sctp_stream_interleave_1
					     : &sctp_stream_interleave_0;
}

In a collision that ran on the temporary association.  Neither branch of
sctp_assoc_update() refreshes it on the survivor: sctp_stream_update() copies
out/in/outcnt/incnt and leaves stream->si alone, sctp_stream_clear() only
zeroes mid/mid_uo, and the COOKIE_ECHOED case calls neither.  asoc->frag_point
is not recomputed either, although normal negotiation pairs the two:

net/sctp/sm_make_chunk.c:sctp_process_init() {
	...
	if (sctp_stream_init(&asoc->stream, ...))
		goto clean_up;

	/* Update frag_point when stream_interleave may get changed. */
	sctp_assoc_update_frag_point(asoc);
}

So after the merge peer.intl_capable is 1 while stream.si is still
&sctp_stream_interleave_0.  The INIT-ACK extension list is built from
peer.intl_capable, so the peer is told I-DATA is in use.  What happens when
it sends one?

net/sctp/sm_statefuns.c:sctp_eat_data() {
	...
	if (!asoc->stream.si->validate_data(chunk))
		return SCTP_IERROR_PROTO_VIOLATION;
}

sctp_validate_data() returns false for anything that is not SCTP_CID_DATA,
and the callers turn SCTP_IERROR_PROTO_VIOLATION into
sctp_sf_abort_violation().  Can a peer that legitimately follows the
negotiated extension abort the association this way?

There is a second effect in the send path, which branches directly on the
bit rather than on stream.si:

net/sctp/stream_sched.c:sctp_sched_dequeue_done() {
	...
	if (!list_is_last(&ch->frag_list, &ch->msg->chunks) &&
	    !q->asoc->peer.intl_capable) {
		/* pin stream.out_curr */
	}
}

With the bit set but plain DATA chunks being dequeued, stream.out_curr is no
longer pinned mid-message.  Can the PRIO/RR schedulers then interleave
fragments of different streams on the wire?  Before this patch the survivor
kept intl_capable at 0 and the pin was taken.

The reverse case looks reachable too: a restart where the new INIT no longer
advertises I-DATA now clears the bit while stream.si stays
&sctp_stream_interleave_1, leaving I-DATA and I-FORWARD-TSN installed for a
peer that did not negotiate them.

Would calling sctp_stream_interleave_init() and sctp_assoc_update_frag_point()
on the surviving association after the copy address both directions?

> +	asoc->peer.ipv4_address = new->peer.ipv4_address;
> +	asoc->peer.ipv6_address = new->peer.ipv6_address;
>  	asoc->peer.i = new->peer.i;

[Severity: Medium]

This is a pre-existing issue and not introduced by this patch, but since the
copy block is being extended: peer.adaptation_ind is still not carried.

sctp_process_param() records the peer's Adaptation Layer Indication on the
association it is processing, which in a collision is the temporary one:

net/sctp/sm_make_chunk.c:sctp_process_param() {
	...
	case SCTP_PARAM_ADAPTATION_LAYER_IND:
		asoc->peer.adaptation_ind = ntohl(param.aind->adaptation_ind);
}

and the completion path reads the survivor's copy right after the merge:

net/sctp/sm_statefuns.c:sctp_sf_do_dupcook_b() {
	...
	if (asoc->peer.adaptation_ind)
		sctp_add_cmd_sf(commands, SCTP_CMD_ADAPTATION_IND, SCTP_NULL());
}

For a COOKIE_WAIT survivor the field is still 0, so is the
SCTP_ADAPTATION_INDICATION notification dropped even though the peer asked
for it, and on a restart is an older non-zero value reported instead of the
new one?  asoc->c = new->c does update c.adaptation_ind, but nothing copies
that into peer.adaptation_ind after the merge.

Note this field is a separate __u32 rather than part of the bitfield block
the changelog calls "the rest of the block", so it is outside what the patch
sets out to fix.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260921135733.577647-1-wbriggs%40cellusys.com
