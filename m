Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9794A41379B;
	Mon, 14 Sep 2026 12:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789388001; cv=none; b=V5CEhS8k7jAKxYxShwTTQmtsZEJ+jpWeP8GgklDd5PLcnFUkFE8W7yTUdG94TM8VSfSUf1OUPtlW49INURkZknZfCWHX5DYQhWs+lR8eonULYqhBRsKrBrQXaF1duucmiMg5XtwOc79DWYJg46u99oqHZCVmQTlqhvWFpnIYU/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789388001; c=relaxed/simple;
	bh=OVFnmZKwc5JG2arFFobKobXgI1OI2m0tQQP6/sC/Tf8=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=M9U6j829IcFjvCyyjM7tY31vQTHE2JjPoyhmveYtWt4CnH6jRAtkpp4d+y9XryiQ/wcXiyQgc57QOomFCTOofEdyGEH0inyplN59dSvzsPrcJkGw3d2VuMPeyiyPf46dXSgElDt9V9UMxVwJukDzWR3tD+PPYhDD57wl1ldml8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YwFlI3JG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YwFlI3JG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7E351F00893;
	Mon, 14 Sep 2026 12:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789387999;
	bh=XqJijOSpqjaHfQHBCqnKGARYfLI7f7pFTVt8sbLAm+E=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=YwFlI3JGCqPCwJIHX/GKy4I+FssuGwxHOpcciNB/joMZx+sWK5jBJt00Y8saGsxox
	 9tv0mPBGgJmbPiWIBCEL4ngynKNA2uaDtbuTNjnOesvyEeAVUnR1Mj/ctvlpwQ806Q
	 AG6e7j0U7XcIB0aziT0hprZ3LP4CaKu8fm6T+dC4CgCJHRH50YqzyS6hU7t7dWgo2B
	 IzrsL5zaweo2fXKj2pldcI/VvRvbxQVeR/YWLWRzeZqq5KOQAvWtAn6XYGXiyDzSMr
	 iFpGwWNYA5Q4wgswIE2wgL1BxyHQKOP18D12jwe+VhbLMZbdmNehvLZwqMxas8pZ2P
	 tT4VH7DITSzrw==
Subject:
 Re: [PATCH] sctp: reject forged cookie peer_addr with unknown address family
From: netdev-bot+sashiko@kernel.org
To: hdthky0@gmail.com
Cc: marcelo.leitner@gmail.com, lucien.xin@gmail.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Date: Mon, 14 Sep 2026 12:13:18 +0000
Message-ID: <178938799829.22033.13386158820091728844@kernel.org>
In-Reply-To: <20260913113522.2674588-1-hdthky0@gmail.com>
References: <20260913113522.2674588-1-hdthky0@gmail.com>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider:

Critical: 0 · High: 1 (1) · Medium: 0 · Low: 0

- [High] Incomplete fix: sctp_unpack_cookie()
  (net/sctp/sm_make_chunk.c:1858-1860) only checks that the forged…

Pre-existing issues:
- [High] This problem wasn't introduced by this patch, but the patch
  establishes the NULL-check contract for sctp_get_af_specific() at one…

--

sctp: reject forged cookie peer_addr with unknown address family

This adds a family whitelist for the COOKIE-ECHO cookie peer_addr in
sctp_unpack_cookie(), and makes sctp_transport_new() bail out when
sctp_get_af_specific() has no implementation for the requested family.
Both changes target the null dereference seen from sctp_transport_init().

> diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
> index 84a4c97d0f755..7c8fe4b38cd1c 100644
> --- a/net/sctp/sm_make_chunk.c
> +++ b/net/sctp/sm_make_chunk.c
> @@ -1855,6 +1855,10 @@ struct sctp_association *sctp_unpack_cookie(
>  	if (!sctp_auth_verify_cookie_params(ep, bear_cookie))
>  		goto malformed;
>  
> +	if (bear_cookie->peer_addr.sa.sa_family != AF_INET &&
> +	    bear_cookie->peer_addr.sa.sa_family != AF_INET6)
> +		goto malformed;
> +

[Severity: High]
Does this check still leave the mismatched-family case open?  It only asks
whether sa_family is one of AF_INET or AF_INET6, it never relates that family
to the family of the endpoint that received the packet.

On a PF_INET listener with cookie authentication disabled the cookie contents
are attacker supplied, so sa_family can be AF_INET6.  The new guard in
sctp_transport_new() passes as well, since sctp_get_af_specific(AF_INET6) is
non-NULL on CONFIG_IPV6 kernels, and the transport ends up with
af_specific = sctp_af_inet6.

sctp_assoc_add_peer() then routes that transport using the IPv4 socket:

net/sctp/associola.c:sctp_assoc_add_peer() {
	sp = sctp_sk(asoc->base.sk);
	...
	/* Initialize the pmtu of the transport. */
	sctp_transport_route(peer, NULL, sp);
}

sctp_transport_route() calls af->get_dst(), which is sctp_v6_get_dst() here:

net/sctp/ipv6.c:sctp_v6_get_dst() {
	struct ipv6_pinfo *np = inet6_sk(sk);
	...
	final_p = fl6_update_dst(fl6, rcu_dereference(np->opt), &final);
}

inet6_sk() returns inet_sk(sk)->pinet6, which is only populated by
inet6_create(), so np is NULL for an AF_INET socket and np->opt is
dereferenced with no guard.

Isn't that the same remotely triggered null dereference in softirq context
that this patch is meant to close, only at a different offset?

For comparison, sctp_process_param() already refuses IPv6 addresses on
sockets that are not PF_INET6:

	case SCTP_PARAM_IPV6_ADDRESS:
		if (PF_INET6 != asoc->base.sk->sk_family)
			break;

Would it make more sense to validate the cookie family against the receiving
socket family, or against SCTP_INPUT_CB(skb)->af->sa_family, rather than
accepting AF_INET6 unconditionally?

>  	/* Populate the association from the cookie.  */
>  	memcpy(&retval->c, bear_cookie, sizeof(*bear_cookie));
>  
> diff --git a/net/sctp/transport.c b/net/sctp/transport.c
> index 6ea55b9fbde45..cd1a604d6f8e3 100644
> --- a/net/sctp/transport.c
> +++ b/net/sctp/transport.c
> @@ -92,6 +92,9 @@ struct sctp_transport *sctp_transport_new(struct net *net,
>  {
>  	struct sctp_transport *transport;
>  
> +	if (!sctp_get_af_specific(addr->sa.sa_family))
> +		return NULL;
> +

[Severity: High]
This isn't a bug introduced by this patch, but the same
sctp_get_af_specific() result is used unchecked a little further along the
same COOKIE-ECHO path, in sctp_process_init():

net/sctp/sm_make_chunk.c:sctp_process_init() {
	sctp_walk_params(param, peer_init) {
		if (!src_match &&
		    (param.p->type == SCTP_PARAM_IPV4_ADDRESS ||
		     param.p->type == SCTP_PARAM_IPV6_ADDRESS)) {
			af = sctp_get_af_specific(param_type2af(param.p->type));
			if (!af->from_addr_param(&addr, param.addr,
						 chunk->sctp_hdr->source, 0))
				continue;
	...
}

The five other sctp_get_af_specific() callers in sm_make_chunk.c,
bind_addr.c and input.c all test the result for NULL first.

On a CONFIG_IPV6=n build sctp_get_af_specific(AF_INET6) is permanently NULL,
and sctp_verify_param() accepts SCTP_PARAM_IPV6_ADDRESS with a bare break, so
an attacker supplied IPv6 address parameter reaches af->from_addr_param with
af == NULL.

That block only runs when src_match is 0, and sctp_sf_do_5_1D_ce() is the one
sctp_process_init() caller that does not pass sctp_source(chunk) as peer_addr:

net/sctp/sm_statefuns.c:sctp_sf_do_5_1D_ce() {
	if (!sctp_process_init(new_asoc, chunk,
			       &chunk->subh.cookie_hdr->c.peer_addr,
			       peer_init, GFP_ATOMIC))
	...
}

So src_match stays 0 whenever the COOKIE-ECHO source address differs from the
cookie peer_addr, which is attacker chosen with cookie authentication
disabled, and also reachable with cookie authentication enabled by replaying a
legitimately obtained cookie from another source address while keeping the
same source port.

Since this is the same failure mode the patch hardens in sctp_transport_new(),
would it be worth adding the missing !af check in sctp_process_init() in the
same series?

>  	transport = kzalloc_obj(*transport, gfp);
>  	if (!transport)
>  		return NULL;

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260913113522.2674588-1-hdthky0%40gmail.com
