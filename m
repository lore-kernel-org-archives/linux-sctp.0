Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795477533;
	b=25TQdxLKmS2QiaRLFNYzF4q4ccW1dwt5AC+2R3e+n8FXwdCFCoxaDn5GfveRJqIvX2LJ
	 bAca6yTjfkG8+ckRWP6GBV8mrYzRXfK6tjIVYaMmMv810yC2TPfTGEVTqCOR67td4Unzb
	 DeYTq9giG/YIro0ccNeuTo0QXR7J9aneqqqQU5mySrh5+7SCtLEYrKV27YujHlFWQblx4
	 bzeN5fF9R8y5bQYFErjZd+MfXHobTGSkNQyt0M4MutBlMiGi1BNHoas5rRszvHi9BVUYh
	 KwVq/rGzE7i7dHU3DQcntU/YFZVIM5N47R4MTq223sZfgEri7G9tTrSJHvX3IQgNQOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795477533;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=r5+OgPsCyjeC9MKv74G7YxKH+Z743Xl2jrS1zHnIGuU=;
	b=Gu/9gzle9jC2bbiAuPbDoczZbFO5S6GdFqE3Pz+AJJUX4wvCYm/FwFnEu5xuWy6l9G2E
	 mAuQTuMqqH78EOjnmiOht02/4fEm1jQSiXzmCYtZVGYfXxWEcevEGkZ38sdFg/mnO/uOp
	 AIM9lF1zEeeosCHMKhWSLVYZuHvElqwlU6xYqjmJqud2qM4Rc+YgoN4KQ1IYAMxnTzGxW
	 TYnfnom+mYRV4QQM7SmXUB2Vu8vVVumzdR03p67NXo3n/vheKw9lKZp5/+pXvhVeQWJI6
	 8SoSTlU4ACqagiNGAIwRRF6wp8Px+/kEWxJn/RyALApJNEEIE0j9+6fYmTqLWpTa3ng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d87XWevT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C010D606A326;
	Mon, 23 Nov 2026 23:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d87XWevT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77ABE1F000D0;
	Mon, 23 Nov 2026 23:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795477532;
	bh=r5+OgPsCyjeC9MKv74G7YxKH+Z743Xl2jrS1zHnIGuU=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=d87XWevTeVnp1yyijNQj/o/rxb3ELz5hwQm3F4PdqWKidGP+W8YOykjpBMWgDGC44
	 PxOpGJU96C/zcUxmmyxFguw/3/g9ioF7r+z6zwflHvRgIUfhd8wTb/7Mf0RSVJtog2
	 0SUvDW2KdzWDXNiBRhwVhoCtzLcJB2H57DqTV2niAMkc1s2NJVF1qw9bbI0UWmsig2
	 +iZp9IhYj7VMCb1JAFN04bHOERB8Q0KzjwnA+5OfNcf0YAxZx+Zr2EPE7uWJev9BeA
	 xN8BPmoaOpZRyf49FJ9WLIpzmSxu7vdreGJQsNt7NAkDXg6f5n7VA3Fx8woF+sLtGR
	 f5oXsA/JJXciw==
Subject: Re: [PATCH net] sctp: unshare GSO skb frag_list members instead of
 linearizing
From: netdev-bot+sashiko@kernel.org
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, davem@davemloft.net,
 kuba@kernel.org, edumazet@google.com, pabeni@redhat.com, horms@kernel.org,
 marcelo.leitner@gmail.com
Date: Mon, 23 Nov 2026 23:45:32 +0000
Message-ID: <179547753202.3135.11036747479037466293@kernel.org>
In-Reply-To: <20e1d469385153bcfa766080453e8d9c1d64c339.1795388574.git.lucien.xin@gmail.com>
References: <20e1d469385153bcfa766080453e8d9c1d64c339.1795388574.git.lucien.xin@gmail.com>
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

- [High] sctp_gso_unshare() (net/sctp/input.c) does not give SCTP
  exclusive ownership of frag_list members, even though its comment says…
- [Medium] sctp_rcv() now skips skb_linearize() for every GSO-SCTP skb,
  including nonlinear ones that have no frag_list.
- [Low] The commit message misstates the history and the mechanism.

--

sctp: unshare GSO skb frag_list members instead of linearizing

This patch stops sctp_rcv() from linearizing cloned SCTP GSO skbs. It adds
sctp_gso_unshare() instead. That helper calls skb_unclone() on the outer
skb and replaces each shared frag_list member with a private skb_clone().
The aim is to avoid races on shared frag_list headers after a TEE
pskb_copy(), and to keep per-segment boundaries so that SCTP-AUTH works.

> The previous fix in commit fd60d8a08619 ("sctp: linearize cloned gso
> packets in sctp_rcv") checked skb_cloned() on the outer skb and
> linearized the entire GSO packet. This is insufficient for two reasons:
>
>  - A partial pull into the frag_list can privatize the head while later
>    members stay shared.

[Severity: Low]

Does this match the TEE case? The TEE target goes through
nf_dup_ipv4()/nf_dup_ipv6() and pskb_copy(). __pskb_copy_fclone() gives
the new skb a private head and shares the frag_list:

net/core/skbuff.c:__pskb_copy_fclone() {
    ...
	if (skb_has_frag_list(skb)) {
		skb_shinfo(n)->frag_list = skb_shinfo(skb)->frag_list;
		skb_clone_fraglist(n);
	}
    ...
}

Neither skb is marked cloned. So the skb_cloned() check added by
fd60d8a08619 never fired here, and no partial pull is involved.

If that's right, the bug goes back to commit 90017accff61 ("sctp: Add GSO
support"). Should the Fixes: tag point there instead of fd60d8a08619?

>  1. Calls skb_unclone() to unshare the outer skb header without
>     flattening the frag_list.

skb_unclone() only acts when skb_cloned() is true. It then calls
pskb_expand_head(), which reallocates the data head and shared info. The
sk_buff header is already private at that point.

For the pskb_copy()/TEE skb, skb_cloned() is false, so skb_unclone() does
nothing. Could this step be described more precisely?

> diff --git a/net/sctp/input.c b/net/sctp/input.c
> index 9494cfa51106c..cd84ee44b9f24 100644
> --- a/net/sctp/input.c
> +++ b/net/sctp/input.c
> @@ -82,6 +82,38 @@ static inline int sctp_rcv_checksum(struct net *net, struct sk_buff *skb)
>  	return 0;
>  }
>
> +/* Ensure exclusive ownership of frag_list members for GSO skbs.
> + * pskb_copy() shares them by reference; unshare by cloning in place.
> + */
> +static int sctp_gso_unshare(struct sk_buff *skb)
> +{
> +	struct sk_buff **pp, *p;
> +
> +	if (skb_unclone(skb, GFP_ATOMIC))
> +		return -ENOMEM;
> +
> +	if (!skb_has_frag_list(skb))
> +		return 0;
> +
> +	pp = &skb_shinfo(skb)->frag_list;
> +	skb_walk_frags(skb, p) {
> +		if (skb_shared(p)) {
> +			struct sk_buff *clone;
> +
> +			clone = skb_clone(p, GFP_ATOMIC);

[Severity: High]

Does this give SCTP exclusive ownership of the frag_list member, as the
comment above says? skb_clone() makes the sk_buff private. The data buffer
stays shared: dataref is bumped and both skbs are marked cloned.

The SCTP receive path then writes into that shared data. For a
cover-letter GSO skb, sctp_inq_pop() points chunk->skb at the frag_list
member:

net/sctp/inqueue.c:sctp_inq_pop() {
    ...
			if (chunk->head_skb && chunk->skb->data_len == chunk->skb->len) {
				...
				chunk->skb = skb_shinfo(chunk->skb)->frag_list;
    ...
}

sctp_sf_authenticate() then changes the digest in place:

net/sctp/sm_statefuns.c:sctp_sf_authenticate() {
    ...
	save_digest = kmemdup(digest, sig_len, GFP_ATOMIC);
	...
	memset(digest, 0, sig_len);

	if (sctp_auth_calculate_hmac(asoc, chunk->skb,
				     (struct sctp_auth_chunk *)chunk->chunk_hdr,
				     sh_key, GFP_ATOMIC)) {
    ...
}

sctp_auth_calculate_hmac() writes the HMAC it computes back into the same
digest location in the packet.

In the TEE scenario from the commit message, both copies share the same
frag_list data. Can this sequence let an unauthenticated packet through
on the second copy?

receiver A (first copy, on-wire digest D does not match)
  sctp_sf_authenticate()
    save_digest = D
    memset(digest, 0, sig_len)
    sctp_auth_calculate_hmac() writes valid H into the shared bytes
    compare fails -> BAD_SIG

receiver B (second copy)
  sctp_sf_authenticate()
    save_digest = H     <- read from the shared bytes
    memset, then recompute H
    compare(H, H) succeeds -> chunk->auth = 1

If the two copies are processed at the same time, can valid packets also
fail verification? The HMAC input would include the other receiver's
partial writes.

The cloned-outer case looks affected too, for example an AF_PACKET tap on
lo. packet_rcv() clones the skb, and then
skb_unclone()->pskb_expand_head()->skb_clone_fraglist() leaves the members
shared. Before this patch, skb_linearize() gave SCTP a private copy of the
data.

With this patch, don't the memset() and the HMAC write land in data the
tap's queued clone still references? The packet socket reader would then
see zeroed or recomputed digest bytes instead of the bytes received on the
wire.

Would it work to make the data private for the members SCTP writes to?
That could be skb_copy() or pskb_expand_head() on shared or cloned members,
at least those carrying AUTH. Another option is to compute the HMAC into a
private buffer instead of the packet.

> +			if (!clone)
> +				return -ENOMEM;
> +			clone->next = p->next;
> +			consume_skb(p);
> +			p = clone;
> +			*pp = p;
> +		}
> +		pp = &p->next;
> +	}
> +
> +	return 0;
> +}
> +

[ ... ]

> @@ -117,8 +149,14 @@ int sctp_rcv(struct sk_buff *skb)
>  	 * it's better to just linearize it otherwise crc computing
>  	 * takes longer.
>  	 */
> -	if (((!is_gso || skb_cloned(skb)) && skb_linearize(skb)) ||
> -	    !pskb_may_pull(skb, sizeof(struct sctphdr)))
> +	if (!is_gso) {
> +		if (skb_linearize(skb))
> +			goto discard_it;
> +	} else if (sctp_gso_unshare(skb)) {
> +		goto discard_it;
> +	}

[Severity: Medium]

What happens to a nonlinear GSO-SCTP skb that has page frags but no
frag_list? sctp_gso_unshare() returns early for it:

	if (!skb_has_frag_list(skb))
		return 0;

So it reaches sctp_inq_pop() still nonlinear. There, head_skb is only set
when frag_list is non-NULL. Otherwise chunks are bounded by
skb_tail_pointer(), which covers only the linear area:

	} else if (chunk->chunk_end > skb_tail_pointer(chunk->skb)) {
		/* Discard inside state machine. */
		chunk->pdiscard = 1;

Such skbs can come from generic XDP with a frags-capable program:

netif_receive_generic_xdp()
  netif_skb_check_for_xdp()
    skb_cow_data_for_xdp()
      skb_pp_cow_data()

veth native XDP can produce them as well. skb_copy_header() keeps gso_type
as SKB_GSO_SCTP, and the payload ends up in page frags with no frag_list.

If an AF_PACKET tap then clones the skb, the old skb_cloned() condition
linearized it. With this change, are the chunks past the linear head now
pdiscarded?

The AUTH reasoning in the commit message only applies when a frag_list
exists. Could the code still linearize when !skb_has_frag_list(skb)?

> +
> +	if (!pskb_may_pull(skb, sizeof(struct sctphdr)))
>  		goto discard_it;
>
>  	/* Pull up the IP header. */

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20e1d469385153bcfa766080453e8d9c1d64c339.1795388574.git.lucien.xin%40gmail.com
