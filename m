Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3427B3655E7;
	Sat, 19 Sep 2026 01:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789781765; cv=none; b=TIoNyn5IwbySFe2uWLU6mK61yuHB190z/9DpMinLqHUgdcnp6UbEaiLmF41fdp/Pp7ZEjyYbfxZxjPjvv1fzdriM+u0GwrhBGm6hXkv6NQjYCP7b34GXxFRJ4QCwJnKPpDrAc75V1/ZTk0zLg/QbDAnsI5usIyUtnawCdxtDT2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789781765; c=relaxed/simple;
	bh=BAMiR6tp93WASoGoxHg/aBeR8oZOVZJ3PZE6l8BJ+jM=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jZ5ua3FwEvvzYm/mxPwu3SrhQf9lJ1QLWjf2iFGRtjM/7C7UlaEPhNNa6MRlUX2CGKKJlNGAW0faVqjNLfBZTyTFUhdkqANIEAW4kd3fqlCqh+LtAoDGUmLPq7khx+bFZO3t0U66lyQUqRdSmjB6/FRpm65PsKJXUYkJxhlrWHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oBflS+DE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oBflS+DE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42CF61F000FF;
	Sat, 19 Sep 2026 01:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789781763;
	bh=30x3fHrbxxBoNEK9Z3zN2LcmYvaag8uQUpJ6QuBN6as=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=oBflS+DE1B2l5i/M3Oe73M+TANTUfqQZwTyTWuJkBZIB/KKudM2z7aYp5pXTS6XlI
	 f044W59LgJByQPHQ1r/8h9ULzQ3FoiOWwzXqLnOtwFDtis4ndLiieTnjyKY8/3ISSG
	 cZ9XOEBAPmShWJVuy0t7M/FGg0B1HhQFiI0gUNbV+aDkkL6cdrf0N4WQkrdrKBxbq+
	 CSiXWEN2qnbUNVAT82Tq3QwNz4XQz6OEI9vqnH7mwM5wCMwDRbLN/2J/Xe9Z0AwINl
	 EH2JbLqpOCl97cLmr9OX/rlXp+tQcgFzgWwA4xheeIQ0MclWR6ThxBVXM4i2uzrhue
	 zqteYXFugfzuw==
Subject: Re: [PATCH v2] sctp: reject forged cookie peer_addr with unknown
 address family
From: netdev-bot+sashiko@kernel.org
To: hdthky0@gmail.com
Cc: marcelo.leitner@gmail.com, lucien.xin@gmail.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Date: Sat, 19 Sep 2026 01:36:02 +0000
Message-ID: <178978176279.22033.12808363523640510762@kernel.org>
In-Reply-To: <20260915212917.3775248-1-hdthky0@gmail.com>
References: <20260915212917.3775248-1-hdthky0@gmail.com>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 3 potential
issue(s) to consider:

Critical: 0 · High: 0 · Medium: 2 · Low: 1

- [Medium] sctp_unpack_cookie() validates a *copy* (`paddr`) of the
  attacker-controlled `bear_cookie->peer_addr` and then discards it.
- [Medium] The new `if (sp && sctp_opt2sk(sp)->sk_family != PF_INET6)
  return 0;` is placed *before* the IPV6_ADDR_MAPPED handling in…
- [Low] A minimal crash fix (validate the attacker-controlled cookie
  peer_addr, guard the missing af_specific) is bundled with a semantic…

--

sctp: reject forged cookie peer_addr with unknown address family

This validates the attacker-controlled COOKIE-ECHO peer_addr with
af->addr_valid() in sctp_unpack_cookie(), makes sctp_v6_addr_valid()
return 0 for non-PF_INET6 sockets, reuses addr_valid() in
sctp_process_param(), and adds missing sctp_get_af_specific() NULL
checks in sctp_process_init() and sctp_transport_new().

Previous posting: https://lore.kernel.org/netdev/20260913113522.2674588-1-hdthky0@gmail.com/

> diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
> index ef26878f1282a..c45ac15f3b79d 100644
> --- a/net/sctp/ipv6.c
> +++ b/net/sctp/ipv6.c
> @@ -734,6 +734,9 @@ static int sctp_v6_addr_valid(union sctp_addr *addr,
>  {
>  	int ret = ipv6_addr_type(&addr->v6.sin6_addr);
>  
> +	if (sp && sctp_opt2sk(sp)->sk_family != PF_INET6)
> +		return 0;
> +
>  	/* Support v4-mapped-v6 address. */
>  	if (ret == IPV6_ADDR_MAPPED) {
>  		/* Note: This routine is used in input, so v4-mapped-v6

[Severity: Medium]

The new test runs before the IPV6_ADDR_MAPPED branch, so it also rejects
v4-mapped addresses that used to be normalised to AF_INET and accepted.
Can this change the return value of two existing socket option paths that
take the address family straight from user data?

sctp_setsockopt_bindx() only checks sctp_get_af_specific() on the buffer
walk (there is no sctp_sockaddr_af()/af_supported() gate on the remove
path), and then sctp_bindx_rem() does:

	af = sctp_get_af_specific(sa_addr->sa.sa_family);
	if (!af) {
		retval = -EINVAL;
		goto err_bindx_rem;
	}

	if (!af->addr_valid(sa_addr, sp, NULL)) {
		retval = -EADDRNOTAVAIL;

sctp_setsockopt_primary_addr() has the same shape:

	af = sctp_get_af_specific(prim->sspp_addr.ss_family);
	if (!af)
		return -EINVAL;

	if (!af->addr_valid((union sctp_addr *)&prim->sspp_addr, sp, NULL))
		return -EADDRNOTAVAIL;

On a PF_INET socket with a v4-mapped AF_INET6 sockaddr, the old code took
the IPV6_ADDR_MAPPED branch, rewrote the kernel copy with sctp_v6_map_v4()
and returned sctp_v4_addr_valid() == 1, so sctp_del_bind_addr() and
sctp_assoc_lookup_laddr() matched the real AF_INET address.  With the new
test firing first (sk_family == PF_INET), do SCTP_BINDX_REM_ADDR and
SCTP_SET_PEER_PRIMARY_ADDR now return -EADDRNOTAVAIL where they used to
succeed?

Note that simply moving the new test below the IPV6_ADDR_MAPPED block does
not look sufficient on its own, given the cookie path validates a throw-away
copy (see below): a v4-mapped AF_INET6 cookie peer_addr on an IPv4 socket
would then be accepted un-normalised and reach sctp_v6_get_dst(), where
inet6_sk() returns NULL for an AF_INET socket.  Would restricting the
socket-family test to the new caller, or propagating the normalised address
to the consumer, avoid touching the setsockopt paths?

> diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
> index 84a4c97d0f755..cfc4973f4d4ac 100644
> --- a/net/sctp/sm_make_chunk.c
> +++ b/net/sctp/sm_make_chunk.c

[ ... ]

> @@ -1841,6 +1843,15 @@ struct sctp_association *sctp_unpack_cookie(
>  		goto fail;
>  	}
>  
> +	/* peer_addr is peer-controlled when cookie authentication is
> +	 * disabled.  Validate a copy, as addr_valid() may rewrite a
> +	 * v4-mapped address in place.
> +	 */
> +	paddr = bear_cookie->peer_addr;
> +	af = sctp_get_af_specific(paddr.sa.sa_family);
> +	if (!af || !af->addr_valid(&paddr, sctp_sk(ep->base.sk), NULL))
> +		goto malformed;
> +

[Severity: Medium]

Is the value that gets validated here the value that is actually used?

paddr is a local copy and is dropped after the check, so only the accept or
reject decision survives.  For an AF_INET6 peer_addr holding a v4-mapped
address on a dual-stack (PF_INET6, non v6only) listener, sctp_v6_addr_valid()
accepts it only because it rewrites the copy:

net/sctp/ipv6.c:sctp_v6_addr_valid() {
	if (ret == IPV6_ADDR_MAPPED) {
		if (sp && ipv6_only_sock(sctp_opt2sk(sp)))
			return 0;
		sctp_v6_map_v4(addr);
		return sctp_get_af_specific(AF_INET)->addr_valid(addr, sp, skb);
	}

	/* Is this a non-unicast address */
	if (!(ret & IPV6_ADDR_UNICAST))
		return 0;

Without that rewrite the same address would be rejected by the
!(ret & IPV6_ADDR_UNICAST) test.

The AF_INET6 form is what the rest of the path consumes:

	memcpy(&retval->c, bear_cookie, sizeof(*bear_cookie));

and sctp_sf_do_5_1D_ce() feeds the raw in-skb cookie address to
sctp_process_init():

	if (!sctp_process_init(new_asoc, chunk,
			       &chunk->subh.cookie_hdr->c.peer_addr,
			       peer_init, GFP_ATOMIC))

which reaches sctp_assoc_add_peer() -> sctp_transport_new().  Does the
resulting transport therefore end up with af_specific = sctp_af_v6_specific
and the peer-supplied sin6_flowinfo as its flowlabel, from a representation
that was never validated as-is?

	if (addr->sa.sa_family == AF_INET6) {
		__be32 info = addr->v6.sin6_flowinfo;

		if (info) {
			peer->flowlabel = ntohl(info & IPV6_FLOWLABEL_MASK);

The new sctp_get_af_specific() guard in sctp_transport_new() only rejects
unknown families, so it does not catch this case either.

The sibling path fixed in the same patch (sctp_process_param(), below) keeps
the normalised AF_INET address it hands to sctp_assoc_add_peer().  Can the
two peer-controlled feeders of sctp_assoc_add_peer() then disagree on the
stored representation, so sctp_cmp_addr_exact() and
sctp_assoc_lookup_paddr() produce two transports for one peer address, and
asoc->c.peer_addr keeps a family that does not match the wire?

Would propagating paddr into retval->c.peer_addr (with sctp_sf_do_5_1D_ce()
using the association copy), or rejecting v4-mapped cookie addresses
outright, be a way to keep the validated and the used value identical?

[ ... ]

> @@ -2554,18 +2567,14 @@ static int sctp_process_param(struct sctp_association *asoc,
>  	 */
>  	switch (param.p->type) {
>  	case SCTP_PARAM_IPV6_ADDRESS:
> -		if (PF_INET6 != asoc->base.sk->sk_family)
> -			break;
> -		goto do_addr_param;
> -
>  	case SCTP_PARAM_IPV4_ADDRESS:
> -		/* v4 addresses are not allowed on v6-only socket */
> -		if (ipv6_only_sock(asoc->base.sk))
> -			break;
> -do_addr_param:
>  		af = sctp_get_af_specific(param_type2af(param.p->type));
> +		if (!af)
> +			break;
>  		if (!af->from_addr_param(&addr, param.addr, htons(asoc->peer.port), 0))
>  			break;
> +		if (!af->addr_valid(&addr, sctp_sk(asoc->base.sk), NULL))
> +			break;
>  		scope = sctp_scope(peer_addr);
>  		if (sctp_in_scope(net, &addr, scope))
>  			if (!sctp_assoc_add_peer(asoc, &addr, gfp, SCTP_UNCONFIRMED))

[Severity: Low]

This isn't a bug, but could the crash fix and this rework be split into
separate patches?

The crash fix itself is the peer_addr validation in sctp_unpack_cookie()
plus the missing af_specific checks.  This hunk additionally changes what
happens on the wire for INIT and INIT-ACK address parameters:

 - a v4-mapped value in an SCTP_PARAM_IPV6_ADDRESS is now rewritten in
   place to AF_INET by sctp_v6_map_v4() before sctp_assoc_add_peer(), so
   the created transport's family, its af_specific and route selection,
   and getpaddrs() output change
 - a v4-mapped value on an ipv6-only socket and IPv6 non-unicast
   parameters are now dropped instead of creating a transport, where
   before sctp_v6_scope() could return SCTP_SCOPE_LINK for a multicast
   parameter and sctp_in_scope() could accept it

The change to sctp_v6_addr_valid() also alters the meaning of the generic
sctp_af::addr_valid() callback for all existing callers: its comment says
"Return 0 - If the address is a non-unicast or an illegal address", and it
is now also a socket-policy predicate.

With Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2") the whole series will be
picked up by every stable tree, including the normalisation change and the
setsockopt behaviour change noted above.  Would keeping the fix minimal and
sending the addr_valid() reuse as a follow-up on top make the stable
backport safer?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260915212917.3775248-1-hdthky0%40gmail.com
