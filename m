Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794081143;
	b=PGNLcMPrqvHsJQN7LpkoPPy0Zv3CVHR4Gv/7P9gigG7QGTNKcQiG278tfHELeQIOdbee
	 49F162Tv0rmrMxrAOo0/9uM7wGR95as3oXBRy+TmYLjkIImDOG3kTTNfJJAcmHncFS/Hj
	 dXHnycYC1qYM1ixfbFPe+3U6Qpjo8+ym/tDTDW585GGjoqBWMlCC4Y6IZMlgibAPKjLEa
	 rjlXkem7bDtJ4X7BaUumSUYQ4nHHQP4DwazfWvGp3u7uxm1jGtTmmr4gkvLdIqXcfzIDU
	 /H+KxSB7GVx8Ahmny1AYMNQfSwIVrqAHG3yiqgCMd0pSBWGMle/I0ov5a5fxSiFAy2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794081143;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=7v5w7Y/6lP7RhD+lVR/dnms1QkLIxcaWJVP5wnw756I=;
	b=RMb21QL48a0TLtu8dWGL2YCZGq8Vuar42N6ANyHm4E4zvHe/Ls69lcvINEKKf0+2ksfT
	 3nGey8KzBoeGOAYdOrGQb7nZyichgZMQGWWOZbrqtgJBEikU++aseBPwy6/r2yD5eKOqs
	 nQ4jTqICOF8wcMeWTSHWPq6SMQaKq6JqzLv3LpXicKSO4nRaXXTfT+ziG3nWHXG5YTQWw
	 100D6iXbMs3qrvm8HBSXYd/Lb7fVsrQhN2eADJ4bqF+HROT7dIC82g5mJPwIaXo+YsNkS
	 qvkCuUER6TM47ISdfLMUBM/lglRWcJG1eW6rlrHAIp7ejKpgQQ9m3vC8BQnRt8JUmkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cySyJAnr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43B93606A32C;
	Sat,  7 Nov 2026 19:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cySyJAnr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 464BF1F0089F;
	Sat,  7 Nov 2026 19:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794081142;
	bh=7v5w7Y/6lP7RhD+lVR/dnms1QkLIxcaWJVP5wnw756I=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=cySyJAnrsYJPX2lE5ZiXqPcroCO8YC3N2Mtux7eFxYPwuTbJj5RMB4Q2RJ5IHpnM+
	 aFMcMovHc0xfyW4WbxlLeSGMazZIlhmut+4q0JbszsPKtH5/0q8jTdtJ+SgLEVf4Ja
	 iqrinofny/Cieoc0GxzjQf0i2gk7aRBoIHcleB29TsBAtbg2nsWNm+tqAKjUJCj3Pv
	 2rgX82jRhQsAhAvWf7GxRcpfwb+ejOc3LDk9ja+z832phVbnMH9ixv1fviexfnQXa0
	 4iWttSmtSje2087OXhE5retArgWDth9msvYb1Fl3CnRZO/A7sGX1Uf++8mpeuGSlSY
	 UW8rjYfGqNK4w==
Subject:
 Re: [PATCH net v3] sctp: fix ASCONF address change on single-homed hosts
From: netdev-bot+sashiko@kernel.org
To: andrey.misyrov@gmail.com
Cc: marcelo.leitner@gmail.com, lucien.xin@gmail.com, junvyyang@tencent.com,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 horms@kernel.org, linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Sat, 07 Nov 2026 19:52:21 +0000
Message-ID: <179408114179.994134.782467837057730523@kernel.org>
In-Reply-To: <20261106195126.1563231-1-andrey.misyrov@gmail.com>
References: <20261106195126.1563231-1-andrey.misyrov@gmail.com>
X-sashiko-severity: Medium
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

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] In sctp_process_asconf_param()
  (net/sctp/sm_make_chunk.c:3181-3183), a plain DEL-IP that removes…
- [Low] The rewritten wildcard DEL-IP branch in
  sctp_process_asconf_param() (net/sctp/sm_make_chunk.c:3162-3170)…

--

sctp: fix ASCONF address change on single-homed hosts

This patch removes the refusal of a DEL-IP for the ASCONF's own transport
that commit 9b2854f86f0b added, since that refusal broke the RFC 5061
single-homed renumber sequence. The wildcard DEL-IP now looks up the
transport for the packet source, and both DEL-IP paths retarget
asconf->transport to a surviving transport.

> diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
> index 90de272842512..15c2d87575a8a 100644
> --- a/net/sctp/sm_make_chunk.c
> +++ b/net/sctp/sm_make_chunk.c
> @@ -3160,9 +3160,12 @@ static __be16 sctp_process_asconf_param(struct sctp_association *asoc,
>  		 * packet MUST be deleted.
>  		 */
>  		if (af->is_any(&addr)) {
> -			sctp_assoc_set_primary(asoc, asconf->transport);
> -			sctp_assoc_del_nonprimary_peers(asoc,
> -							asconf->transport);
> +			peer = sctp_assoc_lookup_paddr(asoc, &asconf->source);
> +			if (!peer)
> +				return SCTP_ERROR_REQ_REFUSED;

[Severity: Low]

This changes how a wildcard DEL-IP behaves on the wire. Before, this
branch always made asconf->transport primary, removed every other peer
address and returned SCTP_ERROR_NO_ERROR.

Now the request is refused if the packet source is not already a
transport of the association. That can happen when the ASCONF was found
through its Address Parameter and no earlier ADD-IP in the same chunk
added the source. For example:

    [Addr L] [DEL-IP 0.0.0.0] [ADD-IP S]

The delete used to succeed here. Now it returns an error cause and all
the other peer addresses stay.

Refusing may well be more correct. However, the commit message only says
the branch now "look[s] up the transport of the packet source rather than
reusing asconf->transport". Since this is tagged for stable, could the
changelog mention the new SCTP_ERROR_REQ_REFUSED case?

> +			sctp_assoc_set_primary(asoc, peer);
> +			sctp_assoc_del_nonprimary_peers(asoc, peer);
> +			asconf->transport = peer;
>  			return SCTP_ERROR_NO_ERROR;
>  		}
>  
> @@ -3175,13 +3178,9 @@ static __be16 sctp_process_asconf_param(struct sctp_association *asoc,
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
> +			asconf->transport = asoc->peer.primary_path;

[Severity: Medium]

Can primary_path be a transport other than the packet source here?

The D8 check earlier in sctp_process_asconf_param() returns
SCTP_ERROR_DEL_SRC_IP, so this branch only removes asconf->transport when
two things are true. The association was found through the Address
Parameter L, and the packet came from a different address S.

In that case a transport for S exists only if an earlier ADD-IP S in the
same chunk created it. That is the [Addr L] [ADD-IP S] [DEL-IP L]
sequence this patch fixes.

With two peer addresses after the ADD, sctp_assoc_rm_peer() makes the
first remaining entry (T_S) primary, so this works. With three or more
addresses it does not seem to. For example, with peer addresses
{A (primary), L}:

    ADD-IP S  -> {A (primary), L, S}
    DEL-IP L  -> sctp_assoc_rm_peer(asoc, T_L), primary stays T_A
                 asconf->transport = T_A

This happens even though T_S exists.

sctp_inq_pop() reuses the same sctp_chunk for every chunk bundled after
the ASCONF and does not reset chunk->transport. Those chunks are then
credited to T_A in three places.

First, sctp_vtag_verify() copies the packet's encap_port into T_A:

    chunk->transport->encap_port = SCTP_INPUT_CB(chunk->skb)->encap_port;

Second, sctp_assoc_bh_rcv() updates last_data_from and last_time_heard
on T_A, so the SACK for bundled DATA goes to A:

    if (sctp_chunk_is_data(chunk))
        asoc->peer.last_data_from = chunk->transport;
    ...
    if (chunk->transport)
        chunk->transport->last_time_heard = ktime_get();

Third, a wildcard SET_PRIMARY later in the same ASCONF resolves
sctp_source(asconf) to T_A->ipaddr. A then becomes primary instead of
the packet source, and the request is still acked as a success.

Before this patch, bundled chunks in this case were credited to T_L,
which was not the source either. Still, the new code picks a transport
other than S even when T_S exists.

The wildcard branch in this same patch already calls
sctp_assoc_lookup_paddr(asoc, &asconf->source). Would it make sense to
do that here too, and fall back to asoc->peer.primary_path only when
there is no transport for the source? That would also match the
"Remember where we came from" meaning that sctp_rcv() gives
chunk->transport.

>  		break;
>  	case SCTP_PARAM_SET_PRIMARY:
>  		/* ADDIP Section 4.2.4

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261106195126.1563231-1-andrey.misyrov%40gmail.com
