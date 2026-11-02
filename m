Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793650712;
	b=KN9ZhcgENmLAKw3rPskg8WfxBPTsE7N+gzEcSIRxrZlDWq1LWcp8ERN4rO1dTx/Qtve1
	 vbMN7Vk1//Laq0It8yxV5aNftDaYn2nNDIqsANP4IqrpvptP2uypG8jWRZktkY2F8wMvm
	 hAAOBE57ngH1bv4rkVtknH3rQy9vsYvwPM3HaU3y1wkP6nRErwTzDIweIkReU2c0uEQO8
	 S90mepQefdfNFK1glSJS4BoUiq2X98eJR8eXo9b98L57O/EmfWzJ0fzO63jRW9zONq4gs
	 HumrJqqaq97bx4g58NK6LB7ezzJAyGe9hp04pg8vEDHNWY9pz8bP6ou4KMd1+KrSW4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793650712;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=XtPu0mJvLzJB/kXcPz+Euv1Kfgd+jX4p007a6SDTuCA=;
	b=BW3H+z2/eQNAMW4Ba7L/IFOnPqgEjYit90NmtT4H6xeDoowZHeoTmnZpgDXFzOGGv9Ro
	 OHcYzMCUFiLh2HLx5pCJ9T42ya95Q+qOFs/UidbXmj+WdZ68uaB6ge+cNUh8joOD6Eiao
	 6ObEvANBt5PtJghb7veGFyFhQDq6/Nmnv2m3MDJsy9kofScmeAjJNnO8git72MPexZB7t
	 SmSGmfFTTluQ/lbClwfv35lGMcIGymoBpX2+iavQJOl/rRQ4BxL2C1Qyj0JOAVggBV2F9
	 UxxUL5NyEQJvlQTs8YZng5MuDODfS+r5ajFbzSIlkP7xHabTRJXftyoxqK3lojUQ3rQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Hb9nvU5I;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AE6E606A324;
	Mon,  2 Nov 2026 20:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Hb9nvU5I
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C3591F00A16;
	Mon,  2 Nov 2026 20:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793650712;
	bh=XtPu0mJvLzJB/kXcPz+Euv1Kfgd+jX4p007a6SDTuCA=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=Hb9nvU5IXiJp3kwnKKL7/id3L6is52oH2bg2oz4u1hujENfJU9A/j/i9BSMioELOz
	 XVMpWxb64M35hP2p43YDltY/QJ1SeCBrASakwu959fSsIS3GoG+zF5pOQE/BrCqFXJ
	 7DfyeweANPbPc7VT6/o/QdgDATjUmpC8MmaQ2i76mhTFCzaFty6O1NhAdrabI8pEWc
	 WX/94FJ5FiflKAHl9d8XUHTfg5PXyacnEsK93d0w6KqnDRnBuvbj++KZO8PzqLWb+z
	 XbuFoqr8Yyg1fXqZT9CqOZcgvW5SXyGULoeS7adwe9xvajxFwUHQG/rGgl5b4OBbju
	 SzLoXKLu6FnSA==
Subject:
 Re: [PATCH net v2] sctp: fix ASCONF address change on single-homed hosts
From: netdev-bot+sashiko@kernel.org
To: andrey.misyrov@gmail.com
Cc: marcelo.leitner@gmail.com, lucien.xin@gmail.com, junvyyang@tencent.com,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 horms@kernel.org, linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Mon, 02 Nov 2026 20:18:31 +0000
Message-ID: <179365071111.3131.11060798860349203804@kernel.org>
In-Reply-To: <20261029193454.1028626-1-andrey.misyrov@gmail.com>
References: <20261029193454.1028626-1-andrey.misyrov@gmail.com>
X-sashiko-severity: Critical
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

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider.

Critical: 1 · High: 0 · Medium: 0 (1) · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Critical] sctp: NULL pointer dereference in sctp_vtag_verify() after
  plain DEL-IP

Pre-existing issues:
- [Medium] This problem was not introduced by this patch, but the
  wildcard SET_PRIMARY branch of sctp_process_asconf_param() does not…

--

sctp: fix ASCONF address change on single-homed hosts

This patch changes DEL-IP handling in sctp_process_asconf_param(). A plain
DEL-IP of the transport that located the ASCONF is no longer refused, so
the single-homed renumber case from RFC 5061 5.3.2 works again. The
wildcard DEL-IP now looks up the peer by the packet source, and
asconf->transport is either cleared or pointed at the surviving peer, so
no freed transport is left behind.

> diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
> index d64c3ae33298f..0f9538f8040f2 100644
> --- a/net/sctp/sm_make_chunk.c
> +++ b/net/sctp/sm_make_chunk.c
> @@ -3153,9 +3153,12 @@ static __be16 sctp_process_asconf_param(struct sctp_association *asoc,
>  		 * packet MUST be deleted.
>  		 */
>  		if (af->is_any(&addr)) {
> -			sctp_assoc_set_primary(asoc, asconf->transport);
> -			sctp_assoc_del_nonprimary_peers(asoc,
> -							asconf->transport);
> +			peer = sctp_assoc_lookup_paddr(asoc, &asconf->source);
> +			if (!peer)
> +				return SCTP_ERROR_REQ_REFUSED;
> +			sctp_assoc_set_primary(asoc, peer);
> +			sctp_assoc_del_nonprimary_peers(asoc, peer);
> +			asconf->transport = peer;
>  			return SCTP_ERROR_NO_ERROR;
>  		}
>  
> @@ -3168,13 +3171,9 @@ static __be16 sctp_process_asconf_param(struct sctp_association *asoc,
>  		if (!peer)
>  			return SCTP_ERROR_DNS_FAILED;
>  
> -		/* Don't free asconf->transport; a later wildcard DEL-IP
> -		 * parameter reuses it.
> -		 */
> -		if (peer == asconf->transport)
> -			return SCTP_ERROR_REQ_REFUSED;
> -
>  		sctp_assoc_rm_peer(asoc, peer);
> +		if (asconf->transport == peer)
> +			asconf->transport = NULL;
>  		break;
>  	case SCTP_PARAM_SET_PRIMARY:
>  		/* ADDIP Section 4.2.4

[Severity: Critical]
Clearing asconf->transport here can leave a NULL transport for any
chunk bundled after the ASCONF in the same packet.

sctp_rcv() allocates one struct sctp_chunk per packet. sctp_inq_pop()
reuses queue->in_progress for every bundled chunk and does not reset
chunk->transport. The asconf seen here through sctp_sf_do_asconf()
and sctp_process_asconf() is therefore the same object that
sctp_assoc_bh_rcv() passes to sctp_do_sm() for the next chunk.

Once this branch sets asconf->transport to NULL, the next bundled
chunk reaches a handler that calls sctp_vtag_verify(). That covers
DATA, SACK, HEARTBEAT, a second ASCONF, or even an unknown chunk.
sctp_vtag_verify() does this:

include/net/sctp/sm.h:sctp_vtag_verify() {
	if (ntohl(chunk->sctp_hdr->vtag) != asoc->c.my_vtag)
		return 0;

	chunk->transport->encap_port =
		SCTP_INPUT_CB(chunk->skb)->encap_port;
	return 1;
}

The vtag matches for a legitimate peer, so this is a NULL pointer
dereference in softirq context. For a bundled DATA chunk,
sctp_assoc_bh_rcv() also stores the NULL into
asoc->peer.last_data_from just before that.

The trigger is the case this patch is meant to fix. The peer
renumbers from L to S and sends [Address Parameter L] [ADD-IP S]
[DEL-IP L] from S. __sctp_rcv_asconf_lookup() locates the association
by L, so asconf->transport is the transport for L. The ADD-IP raises
transport_count to 2, so D7 does not refuse the request, and the
plain DEL-IP now removes L. Any peer of an established association
can bundle another chunk after that ASCONF, so a remote peer can
trigger this.

Before 9b2854f86f0b this path left a freed transport in
asconf->transport. The patch replaces that use-after-free with a
NULL dereference for the same bundled chunks rather than closing it.

The v2 notes already handle the bundled DATA/SACK concern for the
wildcard branch by retargeting asconf->transport to the surviving
peer. Should the plain DEL-IP do the same? One option is the
transport for asconf->source when it exists, which it will after
ADD-IP S. Otherwise asoc->peer.primary_path could be used, since
sctp_assoc_rm_peer() has just updated it. Or do you prefer to make
the receive-path users of chunk->transport, starting with
sctp_vtag_verify(), tolerate NULL?

[Severity: Medium]
This is a pre-existing issue, and this patch did not introduce it. The v2
notes already put it out of scope. It does interact with the new
asconf->transport updates above, though.

The wildcard SET_PRIMARY branch just below says it uses the packet source:

	case SCTP_PARAM_SET_PRIMARY:
		/* ADDIP Section 4.2.4
		 * If the address 0.0.0.0 or ::0 is provided, the receiver
		 * MAY mark the source address of the packet as its
		 * primary.
		 */
		if (af->is_any(&addr))
			memcpy(&addr, sctp_source(asconf), sizeof(addr));

However, sctp_source() returns the transport address whenever one is set:

net/sctp/sm_make_chunk.c:sctp_source() {
	if (chunk->transport) {
		return &chunk->transport->ipaddr;
	} else {
		/* Otherwise, extract it from the IP header.  */
		return &chunk->source;
	}
}

If the ASCONF was matched by its Address Parameter in
__sctp_rcv_asconf_lookup(), asconf->transport is the transport for L, while
asconf->source is the real packet source S.

So if [Addr L][ADD-IP S][SET-PRIMARY 0.0.0.0] is sent from S, wouldn't L
become primary instead of S?

The ADD-IP wildcard branch, the D8 check and the reworked DEL-IP wildcard
branch all use &asconf->source. That leaves "source" with two meanings
inside sctp_process_asconf_param().

This patch now rewrites asconf->transport partway through the chunk. As a
result, the wildcard SET_PRIMARY result depends on parameter order:

  - after a plain DEL-IP of asconf->transport (now NULL), it picks S
  - after a wildcard DEL-IP (retargeted to the peer for S), it picks S
  - otherwise it still picks L

None of these orderings uses a freed transport. Where the result changes,
it moves toward the behaviour the comment describes.

Would it make sense to have the wildcard SET_PRIMARY branch use
&asconf->source directly, like the other wildcard branches, either here or
in a follow-up? That would make the result independent of parameter order.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261029193454.1028626-1-andrey.misyrov%40gmail.com
