Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89EDF3B52FA;
	Sat, 10 Oct 2026 08:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791621626; cv=none; b=ZeN5tvbsUTmttAuF7IqVwBZNtTH+K6tQ9CRH4XKLL7wiT9kSabRmWxTeAONATq/kj56pNyacLttYdH4dHd0AaDkV/j++uOTDsTsDtHvojwXofqz7E/CcatHZlBGoKLWqAQT7ji+rRr7heO3CuFFUBON9E7lsR1hZXQRLhWhLjo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791621626; c=relaxed/simple;
	bh=HdbbUhqbjD/1QW1enFmmU1Du7vzcRxNechaRIsb3oWU=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jt3QFpTT0Zl0q2f8OrfcTPpSaqNJQw2T44nDGnhGro0viJ+6cLVLIt4T8MCfn/0vLETNxuKdAKrqAbHaNxGJR1lZOynCAg+tpIprAmDn1dikiVgKqEN7d9fmVrNEukGO3R7i45iPMonulc6y9QEW0ffwMsLBAfAr0JsXaboS8HY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fESpfesU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fESpfesU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97C571F000FF;
	Sat, 10 Oct 2026 08:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791621621;
	bh=GigaAgksWe+Wzj8d5hU/p7crR3OdI1UHqkxncEzre6U=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=fESpfesUOr2nZHPalfZQlngsZeaSPaSJV31vxCDh5UgOARroUgSRC13HVHs7f1RNC
	 IsqKPl3mr0FEGXjw1KZG+7UDFyiNkqXuuxQHBIrDZFTucLT8AQSLJU04CEvvHazFhc
	 1Jk928k5A21igS8l83UmMbOVk7Pe0DBxuCOyeH7zOheFfA56jnZzF6enlJ89vnuVZC
	 oGjnBqONVxfobwuCDZuCgwxMuB/8VbADoQwsLwMBV67YVa7JWP/HGHIb1gSn10sNLg
	 vQTLuy2fXSTwfKyQXtFVDqDnzDsVbZzVmGii+8ZVf5AlAk7uFCs0h1GekP11W1Vz1j
	 +lFQyj5V7TAxg==
Subject: Re: [PATCH v4] sctp: reject forged cookie peer_addr with unknown
 address family
From: netdev-bot+sashiko@kernel.org
To: hdthky0@gmail.com
Cc: marcelo.leitner@gmail.com, lucien.xin@gmail.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Date: Sat, 10 Oct 2026 08:40:20 +0000
Message-ID: <179162162010.434549.13276446555925201942@kernel.org>
In-Reply-To: <20261009074601.3954275-1-hdthky0@gmail.com>
References: <20261009074601.3954275-1-hdthky0@gmail.com>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 0 (1)

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] The patch now validates peer_addr in place.

Pre-existing issues:
- [Low] Two comments next to the code this patch changes contradict the
  implementation.

--

sctp: reject forged cookie peer_addr with unknown address family

This patch validates the COOKIE-ECHO peer_addr with af->addr_valid() in
sctp_unpack_cookie(). Bad families are rejected, and v4-mapped addresses
are normalised in place. It also makes sctp_v6_addr_valid() reject
non-v4-mapped addresses on non-PF_INET6 sockets, uses addr_valid() to
simplify sctp_process_param(), and adds a missing !af check in
sctp_process_init().

> diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
> index ef26878f1282a..97390569c4bdc 100644
> --- a/net/sctp/ipv6.c
> +++ b/net/sctp/ipv6.c
> @@ -725,7 +725,8 @@ static int sctp_v6_available(union sctp_addr *addr, struct sctp_sock *sp)
>   * SCTP.
>   *
>   * Output:
> - * Return 0 - If the address is a non-unicast or an illegal address.
> + * Return 0 - If the address is a non-unicast or an illegal address,
> + *            or a non-v4-mapped address on a non-PF_INET6 socket.
>   * Return 1 - If the address is a unicast.
>   */
>  static int sctp_v6_addr_valid(union sctp_addr *addr,

[Severity: Low]

This isn't a bug introduced by this patch, but two nearby comments
don't match the code that this patch now relies on.

The v4-mapped branch of sctp_v6_addr_valid() says:

	/* Note: This routine is used in input, so v4-mapped-v6
	 * are disallowed here when there is no sctp_sock.
	 */
	if (sp && ipv6_only_sock(sctp_opt2sk(sp)))
		return 0;
	sctp_v6_map_v4(addr);

When sp is NULL, as in the sctp_rcv() input path, the code maps and
accepts the address instead of rejecting it.

The header comment of sctp_v4_addr_valid() in net/sctp/protocol.c only
lists non-unicast or illegal addresses as reasons to return 0. The
function also returns 0 for any IPv4 address on an IPV6_V6ONLY socket:

	/* IPv4 addresses not allowed */
	if (sp && ipv6_only_sock(sctp_opt2sk(sp)))
		return 0;

This patch removes the explicit ipv6_only_sock() test from
sctp_process_param(), so that function now depends on this check.

The sctp_v6_addr_valid() header comment is already being updated here.
Could these two comments be updated as well?

[ ... ]

> diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
> index 84a4c97d0f755..175dbb242e1cb 100644
> --- a/net/sctp/sm_make_chunk.c
> +++ b/net/sctp/sm_make_chunk.c

[ ... ]

> @@ -1841,6 +1843,11 @@ struct sctp_association *sctp_unpack_cookie(
>  		goto fail;
>  	}
>  
> +	paddr = &bear_cookie->peer_addr;
> +	af = sctp_get_af_specific(paddr->sa.sa_family);
> +	if (!af || !af->addr_valid(paddr, sctp_sk(ep->base.sk), NULL))
> +		goto malformed;
> +

[Severity: Medium]

Can this modify packet data that is shared with a clone? bear_cookie
points into the received skb. sctp_sf_do_5_1D_ce() and
sctp_sf_do_5_2_4_dupcook() both set:

	chunk->subh.cookie_hdr =
		(struct sctp_signed_cookie *)chunk->skb->data;

For an AF_INET6 v4-mapped peer_addr, sctp_v6_addr_valid() calls
sctp_v6_map_v4(), which writes directly into that buffer:

	addr->v4.sin_family = AF_INET;
	addr->v4.sin_port = addr->v6.sin6_port;
	addr->v4.sin_addr.s_addr = addr->v6.sin6_addr.s6_addr32[3];

No skb_cloned() or skb_unshare() check happens before this write.

If an AUTH chunk is bundled before the COOKIE-ECHO,
sctp_endpoint_bh_rcv() and sctp_assoc_bh_rcv() do:

	chunk->auth_chunk = skb_clone(chunk->skb,
				GFP_ATOMIC);

The clone shares the same data.

sctp_sf_do_5_1D_ce() calls sctp_unpack_cookie() first. AUTH is verified
only afterwards:

sctp_auth_chunk_verify()
  sctp_sf_authenticate()
    sctp_auth_calculate_hmac()
      data_len = skb_tail_pointer(skb) - (unsigned char *)auth;

That HMAC covers the COOKIE-ECHO body, including the rewritten
peer_addr. The peer computed its HMAC over the original bytes. Would
verification then fail and the COOKIE-ECHO be dropped through
sctp_sf_pdiscard()? The duplicate-cookie handlers use the same order:
unpack first, then verify AUTH.

Other holders of a clone, such as raw IPPROTO_SCTP sockets and non-mmap
AF_PACKET readers, would also see the changed bytes. sctp_rcv() doesn't
prevent this, because skb_linearize() does nothing to an skb that is
already linear but cloned.

A v4-mapped peer_addr doesn't have to be forged. For an INIT that
arrives over IPv6 from a ::ffff:a.b.c.d source, sctp_make_temp_asoc()
stores the raw source in the signed cookie:

	SCTP_INPUT_CB(skb)->af->from_skb(&asoc->c.peer_addr, skb, 1);

It can also be forged directly when cookie authentication is disabled.

In that case, the commit message statement "peer_addr is validated in
place, so a v4-mapped v6 address is normalised to AF_INET before the
association and its primary transport are built from it" would not hold
when AUTH is bundled.

Would it work to validate and normalise a stack copy of peer_addr, and
pass that copy to the association and transport setup, instead of
writing into the packet buffer?

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261009074601.3954275-1-hdthky0%40gmail.com
