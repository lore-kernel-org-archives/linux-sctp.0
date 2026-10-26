Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793036753;
	b=g69Orc95YqwcGYJRqA7eBON8mnFq/zXgQc1IcrUG7S7DwKs27lKQj6kR3VLXoLnaXGLl
	 gz95AJbL7Zk3boVkYE0YbIPuiD48oHAHGaUBivAZEedSjpVhoueZLkrzmRQSe+HXOSe8/
	 uDO99iRuEU+JlTLwane97e5Jawh70wVh4isSPSuiQcnWv+jlnygM3aFg5AUDGY2/EWOoV
	 +w6jPGHDa2zQPw4TZei9sCYKl8W6qS53ZaARTEBIkc7ggN/Y0yajMomDO5n+LYwObgguZ
	 ZLch4k2J4HOHHFOs74462Nenl5tfkrEebT+fOcnW8t00kmAcmKKX0M9CtJyIC48nFow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793036753;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=5IWVNWzcWZ7/GsRgxjWRJKgZOwK5XXA78Ujm2BtrSno=;
	b=vmvhb/+ioMyvPXfWEHoxHMR/moswSbxs2OZ2uRLnYcB46COBO68VR684QrcZYWlqaF0O
	 HObLZYT8Mgx2/dF5flhmUD2mNAqlEW0ahVysINzInDxFiDvbm+JEeePww1sc/Xha0scPd
	 vJCZcf8SfR/3kTwjlzDyk35WGg+6B/HoTqN3Dvo30Huvp7EjuVumjVBnjR3LqsEjcm/xV
	 jsue077t9OWnR6RxAUjhdptSMzPZyHwD0XPyVr9YepFZPbtqST2pOI1V6ncTOTFFesQ8f
	 0Q6oFfSerz3+0iViInYgPPB2n9xun9YaOaTes/8OstuWhzLe86zC8QvigcakuCrRHbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=j6opAFdH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 537BE606A320;
	Mon, 26 Oct 2026 17:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=j6opAFdH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AA4E1F01825;
	Mon, 26 Oct 2026 17:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793036752;
	bh=5IWVNWzcWZ7/GsRgxjWRJKgZOwK5XXA78Ujm2BtrSno=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=j6opAFdHGTFw3fY8Z5qzGqRZIe4yMxwbyAs2wwsyrvXGve2gsnIT/guUhKJO2/Frq
	 JI0/SsX5Jj4lRaN5CEXoBVSzyB6f2SyOGTJGYP+cuml26IJGKb4du8wTuoGAQtB/zT
	 BkydhsgwCS1Nl0aATTX83VKuhvQj77pjf8r1sWnsHMrsq1SnaKrEpvsBV0ma0HRHP3
	 mBs2TPFQjLGjM0jO1/9Ejo8i/n9GZ4sx5uig9KoIqIRwWx0OWmuSkKvLTSDNvzyjbj
	 CCxBb7qykPQ6YiujRUB1gG+Qkz2db9Wypff+w/ukUZCuBlzZgQCOx7fcNfKy097A96
	 HlSalAZl5WHGQ==
Subject: Re: [PATCH net] sctp: fix ASCONF address change on single-homed hosts
From: netdev-bot+sashiko@kernel.org
To: andrey.misyrov@gmail.com
Cc: marcelo.leitner@gmail.com, lucien.xin@gmail.com, junvyyang@tencent.com,
 davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com,
 horms@kernel.org, linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Mon, 26 Oct 2026 17:45:51 +0000
Message-ID: <179303675173.3134.11217955296529787762@kernel.org>
In-Reply-To: <20261022163639.2566945-1-andrey.misyrov@gmail.com>
References: <20261022163639.2566945-1-andrey.misyrov@gmail.com>
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

Critical: 1 · High: 0 · Medium: 0 · Low: 0 (1)

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Critical] The patch rewrites the wildcard DEL-IP (0.0.0.0) branch of
  sctp_process_asconf_param() (net/sctp/sm_make_chunk.c:3153-3159) to…

Pre-existing issues:
- [Low] The wildcard SET_PRIMARY branch of sctp_process_asconf_param()
  (net/sctp/sm_make_chunk.c:3182) takes the packet source address from…

--

sctp: fix ASCONF address change on single-homed hosts

This patch drops the refusal of a plain DEL-IP of asconf->transport that
commit 9b2854f86f0b added, so the RFC 5061 5.3.2 single-homed address
change works again. The wildcard DEL-IP branch now looks up the
transport of the packet source instead of reusing asconf->transport. The
plain DEL-IP branch now clears asconf->transport when it removes that
peer.

> diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
> index ddc31a5dbad32..2b76e451d5cb0 100644
> --- a/net/sctp/sm_make_chunk.c
> +++ b/net/sctp/sm_make_chunk.c
> @@ -3151,9 +3151,11 @@ static __be16 sctp_process_asconf_param(struct sctp_association *asoc,
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
>  			return SCTP_ERROR_NO_ERROR;
>  		}

[Severity: Critical]

Can this leave asconf->transport pointing at a freed transport?

Suppose __sctp_rcv_asconf_lookup() found the association through the
ASCONF Address Parameter L. Then asconf->transport is T(L), while
asconf->source is the packet source S. Take a packet from a new source S
like this:

  [AUTH][ASCONF: AddrParam L, ADD-IP S (or ADD-IP 0.0.0.0), DEL-IP 0.0.0.0][DATA]

ADD-IP S creates T(S). The wildcard DEL-IP then keeps T(S) and removes
everything else, including T(L):

sctp_assoc_del_nonprimary_peers(asoc, T(S))
  sctp_assoc_rm_peer(asoc, T(L))
    sctp_transport_free(T(L))

Nothing in this branch clears or retargets asconf->transport. Only the
plain DEL-IP branch below does that.

sctp_inq_pop() reuses the same chunk struct for the bundled DATA chunk.
sctp_assoc_bh_rcv() then runs:

	if (sctp_chunk_is_data(chunk))
		asoc->peer.last_data_from = chunk->transport;

This stores the removed T(L). The last_data_from fixup in
sctp_assoc_rm_peer() has already run, so it does not catch this.
sctp_rcv() then drops its lookup reference, and T(L) is freed after the
RCU grace period.

When the delayed SACK timer fires:

sctp_gen_sack()
  trans = asoc->peer.last_data_from
  sctp_make_sack()
    retval->transport = asoc->peer.last_data_from;
  ...
  sctp_outq_select_transport()
    reads new_transport->state
    list_add_tail(&ctx->transport->send_ready, &ctx->transport_list)

Is that a use-after-free read and write of the transport?

Before this patch, the wildcard branch always kept asconf->transport, and
9b2854f86f0b refused a plain DEL-IP of it. So asconf->transport could not
be freed during ASCONF processing.

Any peer of an association with ASCONF enabled appears able to reach
this, including a well-behaved peer following the RFC 5061 wildcard
procedure.

Would it close this to set asconf->transport = peer after
sctp_assoc_del_nonprimary_peers(), or to clear it whenever it is not the
surviving transport?

> @@ -3166,13 +3168,9 @@ static __be16 sctp_process_asconf_param(struct sctp_association *asoc,
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

[Severity: Low]

This is a pre-existing issue and was not introduced by this patch. The
wildcard SET_PRIMARY handling in sctp_process_asconf_param() uses
sctp_source() instead of &asconf->source:

	if (af->is_any(&addr))
		memcpy(&addr, sctp_source(asconf), sizeof(addr));

sctp_source() returns &chunk->transport->ipaddr whenever chunk->transport
is set. When the association was located via the Address Parameter
(transport T(L), source S), SET_PRIMARY 0.0.0.0 makes L primary instead
of the packet source S. That doesn't match the comment. The ADD-IP and
DEL-IP wildcard branches both use &asconf->source.

With this patch the result also depends on parameter order:

- After a plain DEL-IP L clears asconf->transport, sctp_source() returns
  S.
- After a wildcard DEL-IP, it returns the ipaddr of the removed T(L), the
  dangling pointer described above. The lookup then fails and the
  parameter gets SCTP_ERROR_DNS_FAILED.

Should this branch use &asconf->source like the other two?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261022163639.2566945-1-andrey.misyrov%40gmail.com
