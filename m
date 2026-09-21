Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A55B282F2A;
	Mon, 21 Sep 2026 03:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789961159; cv=none; b=ZNGMHDoYGS2goCbI5ozpW26k2sIgA06nMlyv0C5a0Q/IH/WJvpLIDJrI0Se/WcrHkC6Rgxr80QSaPd7x6ucZex/fIr3YDWeVyFBbCiZaQmSRV3pTJu4eIWCc3HevXqAUPFQKkAQ3NxiV5FisOkK9jgM/ivf6cnDwZ4HJvJTQaIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789961159; c=relaxed/simple;
	bh=neI+Lu8LmFyP+5kIdgowmy4yKGqMXYjUM09vlPZMpnY=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=NDziawyF3UNTYzSG/DSe3oV15kn5ZI7nFipIvoV1ANb83aSzvGmbZF5N/M326mtmIAEF2t+8tLVCLbiwPyNhQ/OGav+qsPL5bPZGdfKu01VutULAdo9POQZk8sskXUGnq020/vN4a/aMTwFfA34OKKKRLiwTW4CAR/SFx0hAAk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SekrnlTR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SekrnlTR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECDCF1F000FF;
	Mon, 21 Sep 2026 03:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789961157;
	bh=12ublRLj27LOs/h6Qh62B3fPGXwvC4+pwxrc7Lg1DGo=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=SekrnlTRnTeCwprB9LH7E6xFSuTGx19xzo4PIhRv3ZPBEyax8S5WskATY4Je3FrKU
	 eckkDJbeswsBWh8xvgYktSwFHSRWXndhBU4KpQFnGEBSdkSJf0P9z3twFJ9uoFPnLW
	 FUg4dx5Z1Vr3W6qNrpqggEdh/nwwTkBqlSmHVZXoIg/a5qvmeU6x3ifITiIcBdZIGj
	 bzZYzx8WbnemcbSVOn16D15javChHhG1jYVbbGJoxLfaYjw93f310mrYPNixvpYwxT
	 KJauhnvQKYDR55aoPEXsyqstwbEjz/HxfDGoeffRkPOa+S4QUjw0empQslN3kVtdYY
	 x/6DEI9S6/4CA==
Subject: Re: [PATCH v3] sctp: reject forged cookie peer_addr with unknown
 address family
From: netdev-bot+sashiko@kernel.org
To: hdthky0@gmail.com
Cc: marcelo.leitner@gmail.com, lucien.xin@gmail.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Date: Mon, 21 Sep 2026 03:25:56 +0000
Message-ID: <178996115646.2160803.7706206745490493314@kernel.org>
In-Reply-To: <20260917030505.4176635-1-hdthky0@gmail.com>
References: <20260917030505.4176635-1-hdthky0@gmail.com>
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
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 2 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] Undisclosed UAPI/behavioural regression on two socket-option
  paths.
- [Medium] sctp_unpack_cookie() validates a stack *copy* of the attacker-
  controlled cookie peer_addr (`paddr = bear_cookie->peer_addr; ...…
- [Low] The kernel-doc block above sctp_v6_addr_valid()
  (net/sctp/ipv6.c:724-730) documents the return value purely as a…

--

sctp: reject forged cookie peer_addr with unknown address family

This validates the attacker-controlled COOKIE-ECHO peer_addr in
sctp_unpack_cookie() with af->addr_valid() on a stack copy, makes
sctp_v6_addr_valid() reject non-PF_INET6 sockets, and reuses
addr_valid() in sctp_process_param() while adding the missing !af
checks.

A few questions below.

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

[Severity: Medium]
Should this gate sit before the IPV6_ADDR_MAPPED branch?  Placed here it
also rejects a v4-mapped sockaddr_in6 on an AF_INET socket, not only
genuine IPv6 addresses, and it fires for every caller that passes a
non-NULL sctp_sock.

Two socket option callers build af straight from the user-supplied
sa_family with no pf->af_supported() cross-check first, unlike
sctp_verify_addr() which goes through sctp_sockaddr_af() ->
opt->pf->af_supported().

net/sctp/socket.c:sctp_bindx_rem() {
	...
	af = sctp_get_af_specific(sa_addr->sa.sa_family);
	if (!af) {
		retval = -EINVAL;
		goto err_bindx_rem;
	}

	if (!af->addr_valid(sa_addr, sp, NULL)) {
		retval = -EADDRNOTAVAIL;
		goto err_bindx_rem;
	}
	...
}

net/sctp/socket.c:sctp_setsockopt_peer_primary_addr() {
	...
	if (!af->addr_valid((union sctp_addr *)&prim->sspp_addr, sp, NULL))
		return -EADDRNOTAVAIL;
	...
}

Before this change, a v4-mapped sockaddr_in6 handed to a non-v6only
PF_INET socket was rewritten in place by sctp_v6_map_v4() and validated
as IPv4, so sctp_del_bind_addr() and sctp_assoc_lookup_laddr() then
operated on the normalised AF_INET address and could succeed.  With the
new early return, do SCTP_SOCKOPT_BINDX_REM and
SCTP_SET_PEER_PRIMARY_ADDR with ::ffff:a.b.c.d now return -EADDRNOTAVAIL
where they previously worked?

The changelog describes the helper change only in terms of the cookie and
INIT paths ("so that IPv6 addresses are never used on IPv4 sockets") and
does not mention the socket API side effect.  Since the patch carries
Fixes: 1da177e4c3f4 and will be picked up for stable, could this be either
described in the changelog or scoped to the paths that need it?

[Severity: Low]
This isn't a bug, but the comment block above sctp_v6_addr_valid() still
documents the verdict as a property of the address alone:

/* This function checks if the address is a valid address to be used for
 * SCTP.
 *
 * Output:
 * Return 0 - If the address is a non-unicast or an illegal address.
 * Return 1 - If the address is a unicast.
 */

A legal global unicast IPv6 address now returns 0 whenever the supplied
sctp_sock is not PF_INET6, and the callers above turn that into
-EADDRNOTAVAIL.  Could the comment gain a line about the socket family
rejection?

>  	/* Support v4-mapped-v6 address. */
>  	if (ret == IPV6_ADDR_MAPPED) {
>  		/* Note: This routine is used in input, so v4-mapped-v6

> diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
> index 84a4c97d0f755..20c0938948843 100644
> --- a/net/sctp/sm_make_chunk.c
> +++ b/net/sctp/sm_make_chunk.c

[ ... ]

> @@ -1841,6 +1843,11 @@ struct sctp_association *sctp_unpack_cookie(
>  		goto fail;
>  	}
>  
> +	paddr = bear_cookie->peer_addr;
> +	af = sctp_get_af_specific(paddr.sa.sa_family);
> +	if (!af || !af->addr_valid(&paddr, sctp_sk(ep->base.sk), NULL))
> +		goto malformed;
> +

[Severity: Medium]
Is the object that gets validated here the same one that is later used?

sctp_v6_addr_valid() only declares a v4-mapped AF_INET6 address valid
after rewriting it in place:

net/sctp/ipv6.c:sctp_v6_addr_valid() {
	...
	if (ret == IPV6_ADDR_MAPPED) {
		...
		sctp_v6_map_v4(addr);
		return sctp_get_af_specific(AF_INET)->addr_valid(addr, sp, skb);
	}
	...
}

The rewrite lands in the throw-away stack copy paddr, which is then
discarded.  The association and its primary transport are built from the
original in-skb address:

net/sctp/sm_statefuns.c:sctp_sf_do_5_1D_ce() {
	...
	if (!sctp_process_init(new_asoc, chunk,
			       &chunk->subh.cookie_hdr->c.peer_addr,
			       peer_init, GFP_ATOMIC))
	...
}

and memcpy(&retval->c, bear_cookie, sizeof(*bear_cookie)) copies the
un-normalised address into the association.

So for a forged cookie carrying sa_family = AF_INET6 with ::ffff:a.b.c.d
on a dual-stack PF_INET6 listener, the check passes (validated as IPv4)
while sctp_assoc_add_peer() -> sctp_transport_new() installs an AF_INET6
v4-mapped primary with af_specific = IPv6, and the primary path is then
driven through sctp_v6_get_dst() with a v4-mapped destination.  The IPv4
address parameters from the same forged INIT are normalised to AF_INET, so
the same peer ends up with transports of two different families.

The sibling call site added by the same patch does consume the normalised
address:

net/sctp/sm_make_chunk.c:sctp_process_param() {
	...
		if (!af || !af->from_addr_param(&addr, param.addr,
						htons(asoc->peer.port), 0) ||
		    !af->addr_valid(&addr, sctp_sk(asoc->base.sk), NULL))
			break;
		scope = sctp_scope(peer_addr);
		if (sctp_in_scope(net, &addr, scope))
			if (!sctp_assoc_add_peer(asoc, &addr, gfp, SCTP_UNCONFIRMED))
	...
}

Could the two new users of addr_valid() be made to agree, for instance by
storing the validated copy into retval->c.peer_addr and having the state
function pass that instead of re-reading the raw cookie, so nothing is
written into the possibly shared skb?

>  	/* Make a new base association.  */
>  	scope = sctp_scope(sctp_source(chunk));
>  	retval = sctp_association_new(ep, ep->base.sk, scope, gfp);

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260917030505.4176635-1-hdthky0%40gmail.com
