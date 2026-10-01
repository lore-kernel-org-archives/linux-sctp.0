Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47B7C298CAB;
	Thu,  1 Oct 2026 07:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790838359; cv=none; b=u7tItq6mNbxsrYrTWxPe1Evyu9hV9UbwZk1HguCj94MdD2SmAQkerSD0cNvyeR0TUeBH4d0B6rnFirOjeWOX2cjI5YLqthXIdvsN5J4d+4cAtxLpTZaeQibq3Q+cWvFrA6id9F1b7lkVHed2Y0DBxa1wMMlEFC6dBGoiYY3CACo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790838359; c=relaxed/simple;
	bh=KMS03m/NAjJfoi/8vVu8r9NU6TQW/KraJjkVGMLR0hQ=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ET7Ru3qnk2wtk3yg6A8Tuak+AJHq108mGq7PvjRR1T28CVCVEybxRTgl+5Yr1b6X1lbEfR8jiWvgVvqOGZFZY8qnc7/pTVeQHHneG5eJOq/G7vif+r0Tbk7avQbDMXgpf1oUHxnYIOFDyTwzBQ7fp1zq36nQwIho170WW9V3998=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l0AfuLkt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l0AfuLkt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 866721F00899;
	Thu,  1 Oct 2026 07:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790838353;
	bh=LE28Wslnln6jTbla+tFlg2O4uy2oIiAm1gHMrEpU0jM=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=l0AfuLkt6nDp/G7dS6ylLVxdxUGrDwlazLHeQUWzd8SaDLkiQcWtjr+R+sk3aHU82
	 +7epnAXh47VpjjVKp/aeCFpsDuR/9t/riEt/TAS4nLmovHBjTjef7/THNhwMVPlP73
	 adHB09J22FDmQkEHRapy5AXOd5323a00nQm7u9D2NmGaLi3M8aeROaD5hCRqUUxZtf
	 EXhsf9xivV1lJXgZ1l0TH8L7SV/Gpj9r3XDNQ4jea2kxdYZv/tiNsT+dk5ZEa3ZHqW
	 g6uIxAW8TDLCPTO1ESRLOHZ3NBXr0bbJSWF0/+NyR1YqxO8yS6V8pY7CuxwBQ8xB86
	 6G3RZ3hX3qpfQ==
Subject:
 Re: [PATCH net v4] sctp: carry peer capabilities across an INIT collision
From: netdev-bot+sashiko@kernel.org
To: wbriggs@cellusys.com
Cc: marcelo.leitner@gmail.com, lucien.xin@gmail.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
Date: Thu, 01 Oct 2026 07:05:52 +0000
Message-ID: <179083835206.434549.7959555054670908229@kernel.org>
In-Reply-To: <20260928190401.1641260-1-wbriggs@cellusys.com>
References: <20260928190401.1641260-1-wbriggs@cellusys.com>
X-sashiko-severity: Medium
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

Critical: 0 · High: 0 · Medium: 1 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] On a peer restart (sctp_sf_do_dupcook_a -> sctp_assoc_update,
  ESTABLISHED branch), the patch re-derives only the inbound counters…
- [Low] The commit message says the change only affects INIT collisions
  (Table 2 action B), but it also changes behaviour when the peer…

--

sctp: carry peer capabilities across an INIT collision

When an INIT collision is resolved, this patch makes sctp_assoc_update()
also copy the peer's prsctp, ecn, asconf and reconf capability bits, the
ipv4/ipv6 address flags and adaptation_ind from the temporary
association. It also re-derives the inbound ASCONF and RE-CONFIG sequence
counters (peer.addip_serial and strreset_inseq) from the copied
peer.i.initial_tsn.

> diff --git a/net/sctp/associola.c b/net/sctp/associola.c
> index 4521be3bd85a..77ac155fdb70 100644
> --- a/net/sctp/associola.c
> +++ b/net/sctp/associola.c
> @@ -1107,8 +1107,19 @@ int sctp_assoc_update(struct sctp_association *asoc,
>  	asoc->peer.rwnd = new->peer.rwnd;
>  	asoc->peer.sack_needed = new->peer.sack_needed;
>  	asoc->peer.auth_capable = new->peer.auth_capable;
> +	asoc->peer.prsctp_capable = new->peer.prsctp_capable;
> +	asoc->peer.ecn_capable = new->peer.ecn_capable;
> +	asoc->peer.asconf_capable = new->peer.asconf_capable;
> +	asoc->peer.reconf_capable = new->peer.reconf_capable;
> +	asoc->peer.ipv4_address = new->peer.ipv4_address;
> +	asoc->peer.ipv6_address = new->peer.ipv6_address;
> +	asoc->peer.adaptation_ind = new->peer.adaptation_ind;
>  	asoc->peer.i = new->peer.i;

[Severity: Low]
The commit message describes this as an INIT collision fix, but doesn't
the same code also run on a peer restart?

sctp_assoc_update() has one caller, sctp_sf_do_assoc_update(). That is
called from sctp_sf_do_dupcook_b() for the collision case, and also from
sctp_sf_do_dupcook_a() for the peer restart case:

net/sctp/sm_statefuns.c:sctp_sf_do_dupcook_a() {
    ...
	/* Update the content of current association. */
	if (sctp_sf_do_assoc_update((struct sctp_association *)asoc, new_asoc, commands))
		goto nomem;
    ...
}

These new assignments, and the counter resets below, have no state
check. On every peer restart, a live association in ESTABLISHED,
SHUTDOWN_PENDING or a similar state will now:

  - replace its prsctp, ecn, asconf and reconf capabilities
  - replace its ipv4_address and ipv6_address flags
  - replace peer.adaptation_ind
  - reset peer.addip_serial and strreset_inseq

The restart behaviour may well be correct, but the commit message doesn't
mention it, and the testing only covers a COOKIE_WAIT collision. With
Fixes: 1da177e4c3f4, this goes to all stable trees.

Could the commit message describe the restart path too, and could that
path be tested?

>  
> +	/* Re-derive sequence counters from the peer's Initial TSN */
> +	asoc->peer.addip_serial = asoc->peer.i.initial_tsn - 1;
> +	asoc->strreset_inseq = asoc->peer.i.initial_tsn;
> +

[Severity: Medium]
On the peer restart path (sctp_sf_do_dupcook_a()->sctp_assoc_update(),
state >= SCTP_STATE_ESTABLISHED), only the inbound counters are
re-derived here. Shouldn't the outbound counters asoc->addip_serial and
asoc->strreset_outseq be updated as well?

On restart, sctp_tietags_populate() reuses our Initial TSN:

	new_asoc->c.initial_tsn         = asoc->c.initial_tsn;

and sctp_unpack_cookie() bases the temporary association's outbound
counters on it:

	retval->next_tsn = retval->c.initial_tsn;
	retval->ctsn_ack_point = retval->next_tsn - 1;
	retval->addip_serial = retval->c.initial_tsn;
	retval->strreset_outseq = retval->c.initial_tsn;

The restarted peer runs sctp_process_init() on our INIT-ACK, so it now
expects serials starting from our initial_tsn. The ESTABLISHED branch of
sctp_assoc_update() copies next_tsn, ctsn_ack_point and
adv_peer_ack_point from new. It does not copy new->addip_serial or
new->strreset_outseq.

If N ASCONFs were sent before the restart, sctp_make_asconf() builds the
next one with:

	asconf.serial = htonl(asoc->addip_serial++);

and that serial is initial_tsn + N. The peer's sctp_sf_do_asconf() then
discards it silently, because it is above peer.addip_serial + 1:

	} else {
		return SCTP_DISPOSITION_DISCARD;

Would T4 then keep retransmitting this ASCONF, with every later ASCONF
queued behind it, until sctp_sf_t4_timer_expire() aborts the association
at max_retrans? RE-CONFIG requests would carry a stale strreset_outseq in
the same way, and the peer would answer SCTP_STRRESET_ERR_BAD_SEQNO.

Most of this mismatch predates the patch for associations that already
had asconf_capable or reconf_capable set. However, the patch adds a new
trigger. sctp_cmd_process_operr() clears asconf_capable after an ASCONF
has already used a serial:

	asoc->peer.asconf_capable = 0;

The copy above now sets it back to 1 when the restarted peer advertises
ASCONF. Before this patch, such an association never sent another ASCONF.
Now it sends one with a stale serial.

The COOKIE_WAIT collision case doesn't appear to be affected, because the
local outbound counters have not moved yet at that point.

Should the ESTABLISHED branch take addip_serial and strreset_outseq from
new, next to next_tsn?

>  	if (!sctp_tsnmap_init(&asoc->peer.tsn_map, SCTP_TSN_MAP_INITIAL,
>  			      asoc->peer.i.initial_tsn, GFP_ATOMIC))
>  		return -ENOMEM;

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260928190401.1641260-1-wbriggs%40cellusys.com
