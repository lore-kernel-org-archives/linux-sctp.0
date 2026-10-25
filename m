Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792930129;
	b=YxpniJO/AirYzGz5kN3zRdiiMFpbr82jFgYApYMtRYFKMLsqfrQW9n8otm1GbTrHv1C7
	 A4VtIW4tJ57hoSm36Gq773vP0vQNktwts8/305f7SCGuYieF7luQA9SM/wnaqbqfSA1vE
	 +mPYD46w9M/dpiGndeSc8rHbaPYFko8uXDVdI28vYOiKpJwl8FioDiYESnXcqTYLRLtcD
	 XLilm5VCBuku2k/scnN9jT+IPOPecyaJJlqPgOp8erSkNS2h3RQ3BMR5qLIUlMVRWvzOB
	 T329j3jR9TH7A8XEGRWoXv4jx3roSSlUuYfuOW1Ms9Z21NwrX8BrsU9+MmZDtVApeow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792930129;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=jEdiyZlJ+/oAvhvg41KxZRLja8J+nxepgrMTWSEfLXo=;
	b=l8MiK6+OE6HBaCxY0TDRHhIGh6AHyWuS5MvxYtL+WTZG34IlRnUMHjVjWF6LaNxCi26H
	 wp1RFPsu/0IxDx6owwgkl6hEg6bf000a53iDbv1R456McwN1uN2QDXi78sZvdc8lOljrf
	 TElTTJej/aR2N+bjjpm/YjkxkYuoaWb2zKhHTdsfdl8ebjKBbijgD86Gl42lVkWqR/Yw4
	 0cIQHJAWwUUXkxtaxWeLOL3ujG91MkvFgVCYAAZgNxc5tWu5W4/1UA3Pe9LpX+Uf2Aov8
	 C3cMJEU9LP21qtgqehq2R2PkqUuM8x4wBN1Mo9SZ3LbnQbtPZdsdsuNH74DyBbd3pOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="LN4eh/Ze";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7AA9606A31A;
	Sun, 25 Oct 2026 12:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LN4eh/Ze
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7DFA1F01825;
	Sun, 25 Oct 2026 12:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792930128;
	bh=jEdiyZlJ+/oAvhvg41KxZRLja8J+nxepgrMTWSEfLXo=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=LN4eh/ZewxHKn1CKGaf4Kf8Eb7TQ/OSPwf+ECi4UhL5W5nOUAf97YXWHQaY2Em+Fn
	 l0sBfvaMmZJxt9eqdAysjh7JYLQLi+a2kDJELizsF/MRyVzxaL6EU0a1nHVOwi4unH
	 TfscV2pffXfgM9RxeuiAiLa/Q+agsTCQkISwyhxlShlQrX7/pahbj7r+jsE8rNx/Rd
	 SRzPmU/YH2x9lycDv8YufD7cQO4E1peYsuUkrYlsMlbIzlr9SIF9I4jEPUipw93DYd
	 GoZQ2lEgEWhcBufxJFbu4WVi+z1ALH1HR+mYThBlX1Cjke7jyYifCrx6+TBYxfiBym
	 DzJNsXZLirWvw==
Subject: Re: [PATCH net 1/4] sctp: purge abandoned I-DATA fragments by stream
 and MID, not by TSN
From: netdev-bot+sashiko@kernel.org
To: tim.budding@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, lucien.xin@gmail.com,
 marcelo.leitner@gmail.com, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, shuah@kernel.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Date: Sun, 25 Oct 2026 12:08:47 +0000
Message-ID: <179293012722.3134.13316596865856977030@kernel.org>
In-Reply-To: <20261024120627.837568-2-tim.budding@gmail.com>
References: <20261024120627.837568-2-tim.budding@gmail.com>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Post: <mailto:linux-sctp@vger.kernel.org>
List-Help: <mailto:linux-sctp+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sctp+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 3 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 1 (1) · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] At this commit, sctp_report_iftsn()
  (net/sctp/stream_interleave.c:1224-1231) still contains the branch `if…
- [Medium] Removing the TSN-based purge from sctp_report_iftsn() also
  removes the only non-teardown cleanup for unordered I-DATA fragments…
- [Low] Previously, an I-FORWARD-TSN chunk walked reasm and reasm_uo once
  each (sctp_intl_reasm_flushtsn), and a U-bit skip entry did O(1) work.

Pre-existing issues:
- [Medium] At this commit, the unordered branch of sctp_intl_skip()
  (net/sctp/stream_interleave.c:1249) aborts unordered partial delivery…

--

sctp: purge abandoned I-DATA fragments by stream and MID, not by TSN

This commit removes the TSN-based purge of the I-DATA reassembly queues
from sctp_report_iftsn(). In its place, sctp_intl_skip() frees fragments
on reasm or reasm_uo based on the stream, U bit and MID of each
I-FORWARD-TSN skip entry. The walk stops once it is past the named
stream and MID.

> diff --git a/net/sctp/stream_interleave.c b/net/sctp/stream_interleave.c
> index 840f24045ae2e..f8c818a5533c1 100644
> --- a/net/sctp/stream_interleave.c
> +++ b/net/sctp/stream_interleave.c
> @@ -1203,28 +1203,21 @@ static void sctp_report_fwdtsn(struct sctp_ulpq *ulpq, __u32 ftsn)
>  	sctp_ulpq_abort_pd(ulpq, GFP_ATOMIC);
>  }
>  
> -static void sctp_intl_reasm_flushtsn(struct sctp_ulpq *ulpq, __u32 ftsn)
> +static void sctp_intl_reasm_flush_mid(struct sk_buff_head *reasm, __u16 sid,
> +				      __u32 mid)
>  {
>  	struct sk_buff *pos, *tmp;
>  
> -	skb_queue_walk_safe(&ulpq->reasm, pos, tmp) {
> +	skb_queue_walk_safe(reasm, pos, tmp) {
>  		struct sctp_ulpevent *event = sctp_skb2event(pos);
> -		__u32 tsn = event->tsn;
>  
> -		if (TSN_lte(tsn, ftsn)) {
> -			__skb_unlink(pos, &ulpq->reasm);
> -			sctp_ulpevent_free(event);
> -		}
> -	}
> -
> -	skb_queue_walk_safe(&ulpq->reasm_uo, pos, tmp) {
> -		struct sctp_ulpevent *event = sctp_skb2event(pos);
> -		__u32 tsn = event->tsn;
> +		if (event->stream < sid)
> +			continue;

[Severity: Low]
Each call to sctp_intl_reasm_flush_mid() starts at the head of the queue.
It steps over every fragment of a lower-numbered stream without freeing
anything. sctp_intl_skip() now calls it once for every U-bit skip entry
(on reasm_uo) and once for every ordered entry (on reasm). Before this
patch, an I-FORWARD-TSN walked each queue only once.

sctp_validate_iftsn() only checks the stream bound, so it accepts
duplicate entries:

	sctp_walk_ifwdtsn(skip, chunk)
		if (ntohs(skip->stream) >= incnt)
			return false;

sctp_sf_eat_fwd_tsn() only discards a chunk when sctp_tsnmap_check()
returns < 0, so a chunk with an old or duplicate cumulative TSN is still
processed.

Suppose a peer keeps reasm_uo full of incomplete unordered fragments on
low streams. It then sends I-FORWARD-TSN chunks with thousands of U-bit
entries for a high sid. Could each such chunk cost O(entries x
fragments) list iterations in softirq with the socket lock held?

sctp_intl_reap_ordered() already walks the lobby this way for ordered
entries, so the pattern itself is not new. This patch adds another
instance of it.

[ ... ]

> @@ -1232,8 +1225,6 @@ static void sctp_report_iftsn(struct sctp_ulpq *ulpq, __u32 ftsn)
>  {
>  	/* Move the Cumulattive TSN Ack ahead. */
>  	sctp_tsnmap_skip(&ulpq->asoc->peer.tsn_map, ftsn);
> -	/* purge the fragmentation queue */
> -	sctp_intl_reasm_flushtsn(ulpq, ftsn);

[Severity: Medium]
With the TSN-based purge removed, what frees an unordered fragment of an
abandoned message that arrives after the I-FORWARD-TSN naming that
message has been processed?

sctp_validate_idata() accepts unordered I-DATA without any MID check:

	if (chunk->chunk_hdr->flags & SCTP_DATA_UNORDERED)
		return true;

So a late fragment with a TSN above the New Cumulative TSN is stored in
reasm_uo by sctp_intl_reasm_uo(). Its siblings were already freed by
sctp_intl_reasm_flush_mid(), so it can never be reassembled.

For example:

- Unordered message M on stream S has fragments at TSN 10 and 12. TSN 11
  belongs to another stream.
- The sender abandons M and sends I-FORWARD-TSN(cum=10, {S, U, M}).
- Fragment 12 arrives late, for example on another path.
- TSN 11 arrives, so ctsn moves to 12.
- The sender drops M from q->abandoned and does not name {S, U, M}
  again.

>From then on, the fragment is only freed by a later unordered skip on
stream S with MID >= M, by an association reset, or at teardown. Before
this patch, any later I-FORWARD-TSN covering its TSN would have freed it.

While it stays queued, it keeps its sctp_assoc_rwnd_decrease() charge,
its rmem charges, and the association reference taken in
sctp_ulpevent_receive_data(). sctp_ulpq_renege_list() won't reclaim it
either:

	if (TSN_lte(tsn, sctp_tsnmap_get_ctsn(tsnmap)))
		break;

Renege walks from the tail. If a stuck fragment sits at the tail of
reasm_uo, it also blocks reneging of every other reasm_uo entry.

The commit message says:

  "Fragments that no skip entry names, such as a late copy of an
  abandoned fragment, are no longer freed by an unrelated I-FORWARD-TSN;
  they stay until the association is freed."

Should the commit message also mention the lost rwnd and receive buffer
space? Alternatively, could these fragments be dropped when they arrive,
or when the cumulative TSN moves past them?

>  	/* abort only when it's for all data */
>  	if (ftsn == sctp_tsnmap_get_max_tsn_seen(&ulpq->asoc->peer.tsn_map))
>  		sctp_intl_abort_pd(ulpq, GFP_ATOMIC);

[Severity: High]
Can this branch still flush the whole ulpq for an ordinary I-FORWARD-TSN?

Just above, sctp_tsnmap_skip() raises max_tsn_seen to ftsn whenever
ftsn is higher:

	if (TSN_lt(map->max_tsn_seen, tsn))
		map->max_tsn_seen = tsn;

So the equality holds whenever the New Cumulative TSN is at or above the
highest TSN received. That happens, for example, when the abandoned
message was the last one sent, or when later data is still in flight.

sctp_intl_abort_pd() then aborts partial delivery on every stream. It
also frees everything in reasm, reasm_uo and lobby, whatever the stream
or MID:

	/* intl abort pd happens only when all data needs to be cleaned */
	sctp_ulpq_flush(ulpq);

sctp_sf_eat_fwd_tsn() queues SCTP_CMD_REPORT_FWDTSN before
SCTP_CMD_PROCESS_FWDTSN. So this flush also runs before the new per-MID
handling in sctp_intl_skip().

Wouldn't this still free the already-acked fragments of an in-progress
message on another stream? That is the loss this patch sets out to fix.
The commit message describes this branch only in terms of the reset
paths:

  "The association reset paths that also call sctp_report_iftsn() are
  not affected: they pass the highest TSN seen, so sctp_intl_abort_pd()
  still flushes the whole ulpq for them."

A later patch in this series, "sctp: don't treat an I-FORWARD-TSN as an
association reset", seems to address this. It drops the max_tsn_seen
check from sctp_report_iftsn() and makes the stream reset paths call
si->abort_pd() directly. This patch is tagged for stable on its own.
Should that change be folded in here, or should the two be backported
together?

> @@ -1260,6 +1251,7 @@ static void sctp_intl_skip(struct sctp_ulpq *ulpq, __u16 sid, __u32 mid,
>  			sctp_intl_stream_abort_pd(ulpq, sid, mid, 0x1,
>  						  GFP_ATOMIC);
>  		}
> +		sctp_intl_reasm_flush_mid(&ulpq->reasm_uo, sid, mid);

[Severity: Medium]
This is a pre-existing issue, not one introduced by this patch. Does the
new flush leave unordered partial delivery stuck when the skipped MID is
the message currently being partially delivered?

The check just above in sctp_intl_skip() uses a strict comparison:

	if (sin->pd_mode_uo && MID_lt(sin->mid_uo, mid)) {

When mid == sin->mid_uo, pd_mode_uo stays set and no
SCTP_PARTIAL_DELIVERY_ABORTED event is queued.
sctp_intl_reasm_flush_mid() then frees all remaining fragments of that
MID, because it only stops on MID_lt(mid, event->mid).

The stream is left in unordered partial delivery with nothing left to
deliver. sctp_intl_retrieve_first_uo() and
sctp_intl_retrieve_reassembled_uo() skip that stream, and the
application never gets the abort notification.

The strict comparison comes from the original code. The next patch in
this series, "sctp: abort unordered partial delivery when its message is
skipped", changes it to !MID_lt(mid, sin->mid_uo).

>  		return;
>  	}

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261024120627.837568-1-tim.budding%40gmail.com
