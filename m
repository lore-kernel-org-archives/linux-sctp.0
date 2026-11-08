Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794171714;
	b=1UImwF6dMGmRl+BrT/PJkCfNp4pYYxyC5ydshbB+3iVM/cWulaIfBb/wqSxQFQXS3NP1
	 YE7+Uh1j2U9mjvpAgdzQywxPaO69gtt/PHdTXOiI88UWc7rZwaSpbS8cN60F5NPzzbynO
	 ecBOeU7iFBqPF+Vu/RXhHIlA6x49EleTFdGdDlC2sl/loezy09jR+dZZ0VNb/kKltOb0X
	 rq3CZJ6haIfq7W5WW36vVQVqj42Pe+GiERqRwSz4BdGU1Y0YchcSRNzoko1wk6kgKdq+x
	 Es3SWGHZ/pxKH1odIoVRP4ijFu0n7x1UCXM31LwHO6zzrFrsBUevN6VbYcbfERe6+Hg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794171714;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=61lcyeN+fR5ohV0iDvNp+XpkFOW3xkBVHyTuHv2TNXA=;
	b=xEP93417m1uKWCGCr3maTwQy8tQF3oJ7U0ppAxwKPav0OIeMFswxQuPZb5LQmhdul/N4
	 LVSdzxY/b2reSjXCRKU0vwKBZ1fJ5TTzL4tkxnPel7abV4sh0EU5ib1ejMI4PFg42IjlN
	 RtaiS5SkRuKkAMZFORLGxOvebNzD/7F+LCFTAEV+fIwEv9m3ZuTvglhGTPqBgKJaLmjvo
	 gmmi8omJPm6hse7ttb8C4MSy9u4R0uMMFctzvrNvdCzPDvcBCXziU8RPNd37X0UxhDgPc
	 6Xx1s5WMSbJ0/nsTgLwbocfrAdk+SIo0Q5pf/59qmo+t73oMhlaIsi4rq78pENmZBAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DV88OfcA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5457A606A333;
	Sun,  8 Nov 2026 21:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DV88OfcA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 508BF1F0089F;
	Sun,  8 Nov 2026 21:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794171713;
	bh=61lcyeN+fR5ohV0iDvNp+XpkFOW3xkBVHyTuHv2TNXA=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=DV88OfcA7SzB4bNhTuotM542YZ0UVrXMI6p/ykJIbO+vE49JAGvjFTutrEDSF3j39
	 Z1EqOjNkxopKYrB8xOpBKjFFVr5wNVHMiRbWB7VwoVWzB9HfW14+yzsEJJKmdZUgeY
	 mHAbUaYISZ5z5+Fw6h2ta9L7YAcq2tbE+/t8Isac2QkSCxYT0+9jXdIEL7EU+jKdQq
	 tRx431gN1AtbQqJraPtf3qsHLrUEk+EENHN60W+47BDBDVAsdieFtCz09GOMElQLWf
	 DJiQS8EN5ruTjdZlTb0xIjRm9+x2g4YmWGAGO9fmedz7O32WB0mH8CUOSVhxLkAYVZ
	 r4b/zC2pDtixA==
Subject:
 Re: [PATCH net] sctp: linearize GSO skb when frag_list skbs are shared
From: netdev-bot+sashiko@kernel.org
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, davem@davemloft.net,
 kuba@kernel.org, edumazet@google.com, pabeni@redhat.com, horms@kernel.org,
 marcelo.leitner@gmail.com
Date: Sun, 08 Nov 2026 21:01:52 +0000
Message-ID: <179417171282.994134.16986580743973805142@kernel.org>
In-Reply-To: <9997493edadfe9faa713c73de9c70e36cee9ffea.1793902911.git.lucien.xin@gmail.com>
References: <9997493edadfe9faa713c73de9c70e36cee9ffea.1793902911.git.lucien.xin@gmail.com>
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

Critical: 0 · High: 1 · Medium: 1 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The fix is incomplete because sctp_rcv() only tests the first
  frag_list member for sharing.
- [Medium] sctp: skb_linearize() on GSO skb in sctp_rcv() breaks SCTP-
  AUTH verification
- [Low] The comment above the changed condition in sctp_rcv()
  (net/sctp/input.c:116-119, from 4c2f24549644) gives CRC cost as the…

--

sctp: linearize GSO skb when frag_list skbs are shared

This patch widens the linearization condition in sctp_rcv(). GSO packets
whose frag_list head skb is shared are now linearized as well. The aim is
to stop SCTP from working in place on frag_list skbs shared through
pskb_copy() (for example by the TEE target), which can end in a BUG_ON in
__pskb_pull_tail().

> diff --git a/net/sctp/input.c b/net/sctp/input.c
> index 9494cfa51106c..db3c7818724b8 100644
> --- a/net/sctp/input.c
> +++ b/net/sctp/input.c
> @@ -117,8 +117,13 @@ int sctp_rcv(struct sk_buff *skb)
>  	 * it's better to just linearize it otherwise crc computing
>  	 * takes longer.
>  	 */

[Severity: Low]
This isn't a bug, but the comment above this block still gives CRC cost
as the only reason to linearize:

    /* If the packet is fragmented and we need to do crc checking,
     * it's better to just linearize it otherwise crc computing
     * takes longer.
     */

The new frag_list clause only matters when is_gso is true. In that case
sctp_rcv_checksum() is skipped anyway. The clause is there for
correctness, not for CRC speed.

Could the comment be updated to say that GSO packets with shared frag_list
skbs must be linearized?

> -	if (((!is_gso || skb_cloned(skb)) && skb_linearize(skb)) ||
> -	    !pskb_may_pull(skb, sizeof(struct sctphdr)))
> +	if (!is_gso || skb_cloned(skb) ||
> +	    (skb_has_frag_list(skb) && skb_shared(skb_shinfo(skb)->frag_list))) {

[Severity: High]
Is it enough to check only the first frag_list member here?

pskb_copy() goes through __pskb_copy_fclone()->skb_clone_fraglist(),
which takes a reference on every member of the chain:

net/core/skbuff.c:skb_clone_fraglist() {
	skb_walk_frags(skb, list)
		skb_get(list);
}

So after nf_dup_ipv4()->pskb_copy() in the TEE target, every frag_list
member is shared, not only the head.

Something may pull into the frag_list before sctp_rcv() runs. Examples
are nft_payload_set_eval() or tcf_pedit_act() through
skb_ensure_writable(), and bpf_skb_pull_data(). In that case
__pskb_pull_tail() forks a partially eaten shared head:

net/core/skbuff.c:__pskb_pull_tail() {
    ...
				if (skb_shared(list)) {
					/* Sucks! We need to fork list. :-( */
					clone = skb_clone(list, GFP_ATOMIC);
					...
					insp = list->next;
					list = clone;
				}
    ...
		/* Free pulled out fragments. */
		while ((list = skb_shinfo(skb)->frag_list) != insp) {
			skb_shinfo(skb)->frag_list = list->next;
			consume_skb(list);
		}
		/* And insert new clone at head. */
		if (clone) {
			clone->next = list;
			skb_shinfo(skb)->frag_list = clone;
		}
    ...
}

The pulled copy then has a private clone at the head of its frag_list,
while the later members still have users == 2. Because consume_skb() drops
a reference on the old head, the twin skb's head also goes back to
users == 1. An eat that consumes whole leading members ends in the same
state.

Both outer skbs stay uncloned with is_gso true. The new check therefore
returns false in both of them and skb_linearize() is skipped.

sctp_inq_pop() then walks the chain and calls skb_pull() on each member:

net/sctp/inqueue.c:sctp_inq_pop() {
    ...
			if (chunk->skb->next) {
				chunk->skb = chunk->skb->next;
				goto new_skb;
			}
    ...
			skb_pull(chunk->skb, chunk->chunk_end - chunk->skb->data);
    ...
	skb_pull(chunk->skb, sizeof(*ch));
    ...
}

It also writes SCTP_INPUT_CB() into those members. Can the two SCTP
receive paths, possibly on different CPUs, end up changing data, len and
cb of the same shared sk_buff structs?

Suppose either copy is linearized later, for example because a tap made
it skb_cloned(), or because of another pull into the frag_list. Then
__pskb_pull_tail()->skb_copy_bits() walks members whose len has already
been reduced. Would that still return -EFAULT and hit
BUG_ON(skb_copy_bits(...)), the same panic this patch is meant to fix?

The commit message talks about sharing of "the frag_list skbs" in general,
but the check only looks at the head. Should this walk every member with
skb_walk_frags() and linearize if any of them is skb_shared()?

> +		if (skb_linearize(skb))
> +			goto discard_it;
> +	}
> +
> +	if (!pskb_may_pull(skb, sizeof(struct sctphdr)))
>  		goto discard_it;
>  
>  	/* Pull up the IP header. */

[Severity: Medium]
Does linearizing an SCTP GSO skb here lose the per-segment boundaries
that the SCTP-AUTH check depends on?

On transmit, sctp_packet_pack() builds each GSO segment in its own nskb
and appends it to skb_shinfo(head)->frag_list. When the association
uses AUTH, the HMAC is computed over that single nskb only:

net/sctp/output.c:sctp_packet_pack() {
    ...
		if (auth) {
			if (sctp_auth_calculate_hmac(tp->asoc, nskb, auth,
						     packet->auth->shkey, gfp)) {
    ...
}

After skb_linearize() the frag_list is gone. sctp_inq_pop() then no
longer sets chunk->head_skb, and it treats all the concatenated
segments as one SCTP packet. When sctp_sf_authenticate() checks the
first AUTH chunk, it passes chunk->skb to sctp_auth_calculate_hmac(),
which hashes up to the tail of the whole linear buffer:

net/sctp/auth.c:sctp_auth_calculate_hmac() {
    ...
	data_len = skb_tail_pointer(skb) - (unsigned char *)auth;
    ...
}

That range now covers every following segment as well, so the digest
cannot match. sctp_sf_authenticate() returns SCTP_IERROR_BAD_SIG, and
sctp_sf_pdiscard() discards the remaining chunks, which now means all
segments of the GSO packet.

The existing skb_cloned() leg already behaves this way. The new clause
extends it to every GSO packet whose frag_list was shared by
pskb_copy(). If I read nf_dup_ipv4() right, with the TEE target that
includes the original skb that keeps going to the local socket, not
only the duplicate. skb_clone_fraglist() takes a reference on members
that both skbs point to, so both see a shared frag_list head. On
loopback or veth with AUTH enabled, a TEE rule would then turn the
BUG_ON into silent drops of authenticated traffic.

Would it be better to unshare the frag_list members instead, for
example by replacing each shared member with a private copy, so the
segments stay separate? Or is there another way to get an exclusive
copy without merging the segments into one SCTP packet?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/9997493edadfe9faa713c73de9c70e36cee9ffea.1793902911.git.lucien.xin%40gmail.com
