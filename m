Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795837025;
	b=SmvmJTEDpWDIRiEW4M64yK9SlduY4zGcER4ifqunny1CeKFJrlrUSan16bCEl8CCneHo
	 QSnFVTLsjCADgQbYD54L+doXD2VPXUHbKFSmJDVN3+WLBZdr5iPK1rI47Iwl5mwPa49Tj
	 /tZVMNC6sZ0H+o5ANsX9n4gWooYRIIs48cR6oeDA+LfaeU2Wsd7Ap71p9HGFCnBcsBN3h
	 oAx6jdY9j4kWckSOVNnEAs/OIfs/5vMQiIdAHoN93DRpK6RJhXevbp4SBzGnPnC+1z2Sh
	 SpE3kPqA/7E8R5+aUgwsKHg+2QNxsxA3wbhYmuHzSCL0EY2rr74dzlq/QZ6DmyfOGrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795837025;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=umri0wGVOp6EjZGjfBMAhWDZPVdQFdgQPgw3pddiSsg=;
	b=SyuYV3+ppZLcQmfOg4oKLirxTNrvQcbFakg3oZ2AT2EHNxvj9AXXo/xfClBbnmp+44Z5
	 A70rb8KKqEWF2qwwANlZdnBnGKmVcWGS8zYm2Ml8x5dAglPIYz75dstK7HWh3RzsE9mRm
	 SuD0GHQm7Ms8HYU8cnpp30p5CsUegzzO2Xz8AFNCgQPn16xPI/moSf+opZ4FpYb3d+LB/
	 3EhVBhccXiQ8oZH6Ena6YkuIHtVhc+5jtf8E7pfTjg1JTsHkKQEGSuZLE66kobRA27sRN
	 rRaR/Fecdny2C5rUPpeUFQTil/gZf7oz0J33eBuuCPo6zlz4d/s6pSW1pnHakzBnFyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f2hgCn4h;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E21B606A31C;
	Sat, 28 Nov 2026 03:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f2hgCn4h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 661621F00893;
	Sat, 28 Nov 2026 03:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795837025;
	bh=umri0wGVOp6EjZGjfBMAhWDZPVdQFdgQPgw3pddiSsg=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=f2hgCn4hwFktXSy/kAg24lEmmtOfuvFZbDuL1jDjSVEcGNeIT3HJAcq7S4s4qBcWi
	 35cQtOZTFYkUckXY8vDo/2r/fSJzASWVDxqDKDwAg73r+h8NdDpMdXisoIuOh23pAy
	 h1O5cTMQ5bgloI1sUMQbcvY85/J8HRVBfPZ0Uw8cZLeR3HnYMdu5GNJHdWRv7Glebs
	 qa7LnnNwao9jfwb6yEjyZoXHrPP9RId/XzBK1AlZlmRjvEPTgtIOFmk9Kat+SkD+iy
	 s64++sSf7uewEsuUWdp/6uLvBNWv8IuKkrUGKtETkz24j84g6ZLcbcHXwduEu1bbbO
	 2phwpkPdaSvMw==
Subject: Re: [PATCH net] sctp: validate Cookie Preservative in the first pass
From: netdev-bot+sashiko@kernel.org
To: sunyiqi2@huawei.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
 marcelo.leitner@gmail.com, lucien.xin@gmail.com, davem@davemloft.net,
 edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com, willemb@google.com,
 horms@kernel.org, trilobyte777@gmail.com, luoxiaoxing@huawei.com
Date: Sat, 28 Nov 2026 03:37:03 +0000
Message-ID: <179583702392.3135.14690679679244034273@kernel.org>
In-Reply-To: <20261127033534.175-1-sunyiqi2@huawei.com>
References: <20261127033534.175-1-sunyiqi2@huawei.com>
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

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 0 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The fix is incomplete.
- [Low] The lines added to sctp_verify_init() are badly indented.

--

sctp: validate Cookie Preservative in the first pass

This commit adds a length check for the Cookie Preservative parameter to
the first parameter walk in sctp_verify_init(). A mismatched length is
reported through sctp_process_inv_paramlength(). The goal is to stop
sctp_process_param() from reading past a short parameter, even when the
second verification pass returns early.

Link: https://lists.openwall.net/netdev/2026/07/29/316

> diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
> index ba0474c2a0bc8..01b1eea0222c4 100644
> --- a/net/sctp/sm_make_chunk.c
> +++ b/net/sctp/sm_make_chunk.c
> @@ -2317,6 +2317,12 @@ int sctp_verify_init(struct net *net, const struct sctp_endpoint *ep,
>  		return sctp_process_inv_mandatory(asoc, chunk, errp);
>  
>  	sctp_walk_params(param, peer_init) {
> +		/* Validate the length even if the second pass stops early. */
> +		if (param.p->type == SCTP_PARAM_COOKIE_PRESERVATIVE &&
> +			ntohs(param.p->length) != sizeof(*param.life))

[Severity: High]

Other fixed-length parameters have the same problem. Does this patch
cover them?

This check only handles SCTP_PARAM_COOKIE_PRESERVATIVE. The length checks
for SCTP_PARAM_ADAPTATION_LAYER_IND and SCTP_PARAM_SET_PRIMARY are still
only in sctp_verify_param(), which runs in the second pass.

As the commit message says, the second pass can stop early. An
unrecognized parameter with action bits 00 or 01 makes
sctp_process_unk_param() return SCTP_IERROR_ERROR:

net/sctp/sm_make_chunk.c:sctp_process_unk_param() {
    ...
	case SCTP_PARAM_ACTION_DISCARD:
		retval =  SCTP_IERROR_ERROR;
		break;
    ...
}

sctp_verify_init() then returns 1 before it checks any of the later
parameters:

		case SCTP_IERROR_ERROR:
			return 1;

Say a peer sends an INIT that has an unknown parameter (action 00 or 01)
followed by a 4-byte ADAPTATION_LAYER_IND. This check in
sctp_verify_param() is never reached:

	case SCTP_PARAM_ADAPTATION_LAYER_IND:
		if (ntohs(param.p->length) != sizeof(*param.aind)) {

The path then continues:

sctp_sf_do_5_1B_init()
  sctp_verify_init()       returns 1 at the unknown parameter
  sctp_process_init()      walks every parameter
    sctp_process_param()
      asoc->peer.adaptation_ind = ntohl(param.aind->adaptation_ind);

This reads 4 bytes past the end of the parameter. sctp_pack_cookie() then
copies the value into the State Cookie:

	cookie->c.adaptation_ind = asoc->peer.adaptation_ind;

The cookie is sent back to the peer in the INIT-ACK. Isn't that the same
disclosure to the peer that the commit message describes?

SET_PRIMARY (with asconf_enable set) seems to get past the checks the
same way. For a parameter length of 4 to 7, this check in
sctp_process_param() is computed in size_t and wraps:

		addr_param = param.v + sizeof(struct sctp_addip_param);
		if (ntohs(addr_param->p.length) >
		    ntohs(param.p->length) - sizeof(struct sctp_addip_param))
			break;

The out-of-bounds addr_param is then read through addr_param->p and
af->from_addr_param().

Would one of these options work instead?

  - validate every fixed-length parameter in the first pass
  - have sctp_process_init() and sctp_process_param() check bounds
    themselves
  - have sctp_process_init() stop where the second verify pass stopped

> +				return sctp_process_inv_paramlength(asoc, param.p,
> +													chunk, errp);

[Severity: Low]

This isn't a bug, but the indentation of the added lines doesn't follow
kernel coding style or match the rest of sctp_verify_init(). The condition
continuation and the return are indented too far. Also, "chunk, errp);"
doesn't line up with the open parenthesis. checkpatch will probably warn
about this.

> +
>  		if (param.p->type == SCTP_PARAM_STATE_COOKIE)
>  			has_cookie = true;
>  	}

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261127033534.175-1-sunyiqi2%40huawei.com
