Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795485884;
	b=SFUtgmf6afjSMLWh9EqtLZG0Xkz1e6hkVkEEpTTG8NdAR6rmSj2g9PKsaDO0mxQKqLOs
	 UJkEbBG00AwqdLY5fY0GHIbERKg+IQbDQ69Ki+H/n+fW0V9OMipl+yAHdX7KOjEwLWci3
	 pReK0Ni8ErGlBMAi/nV07tLZm1x8woWqQarb3O25/Ue8P11l9Eqt8psnNR1mtS/dlu3Vb
	 C2D+GgvgbS9CVs5HOKkKeUHVYG3WhqALYj46BaKCbl7zU5lqr+QQ8LcZlRSHQJtAWTTz4
	 oyTWyXS0dFkWUeqqAdESD3yDxQ/9p6lJscoNj54ivCKrzwECkiuAjYT5LMp7j4CV9Yg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795485884;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=+Gl7eprlpv+ZUtOJgjcLpfqTJt8SES8zPLde496oxuw=;
	b=DFxYIdpzThPMxZ7yss5XHPMcWXoIsm2ngXzOe1Q7gyMk0jYeNbpnU5Fw+B4JgWUWsvEn
	 NwxUyUGo4m30mx9hKnnPHF+WjyYLjNvYXjfut0iKncKrS6Q8l5kMWDRMGqGXwE4ylEu5O
	 G4+AJ7na/abihofU9ZV5Cxw+LRGTrkrGc/NcEmy6wvw7jdsB+CNCVIEG0KV1bMsGtdQyZ
	 54rad5Cm8xUDJ6ez1ziM/U/HMBMBXTYMHZiAPBIDGby/F7PoAuBnNzBwGp1s1hMyYvXBm
	 Q6TpfDzj1FZlLz3vwkAwfnSfJpA3imW4BKsie2FcxuG0+pku06bu1nAv+m9Trwji/Ag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NBIZ1yCK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18619606A31E;
	Tue, 24 Nov 2026 02:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NBIZ1yCK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECC431F000CA;
	Tue, 24 Nov 2026 02:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795485883;
	bh=+Gl7eprlpv+ZUtOJgjcLpfqTJt8SES8zPLde496oxuw=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=NBIZ1yCKVUUiAb+KP3zu+CMqbegXtT5JZdE3NmbWKo2rwYlNWQyAtMmYl8O3DjOQY
	 O7XXPCR5pAiLkQzjZ2cbH+0oVnVbalVFDqjaQtsfCgXvTIJKBMm2fSdlM9VzTcNcpF
	 I7E1rl2rJOnO4qIjZH3qU8CpPEapfkxtqojUFEcRlCtFJvB5LJ7soH6GTvDgeL9UT2
	 icGntIvTrjI9LzGZz5kwBg0PwoCCDaGn84ILOiLZoHBg5JWg4ICge7OVYoPGkn+nuq
	 GRuI5NSldFvZKGYZ/zxwFAA++GXCN8cHWDkEpVyYufUTZ7k3rzepc4uDoJ46gMIK/5
	 DJgGEEcP7/Q/w==
Subject: Re: [PATCH net-next] sctp: copy endpoint settings to accepted and
 peeled-off sockets
From: netdev-bot+sashiko@kernel.org
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, davem@davemloft.net,
 kuba@kernel.org, edumazet@kernel.org, pabeni@redhat.com, horms@kernel.org,
 marcelo.leitner@gmail.com
Date: Tue, 24 Nov 2026 02:04:42 +0000
Message-ID: <179548588251.3135.10014340190099201603@kernel.org>
In-Reply-To: <48580ca6a02b588e9c24444801109506da11a9d2.1795396989.git.lucien.xin@gmail.com>
References: <48580ca6a02b588e9c24444801109506da11a9d2.1795396989.git.lucien.xin@gmail.com>
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

Thank you for your contribution! Sashiko AI review found 3 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 2

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] In sctp_auth_ep_copy() (net/sctp/auth.c), the per-key copy is
  incomplete: the source key's `deactivated` flag is not copied.
- [Low] The commit message says the change only affects restart
  negotiation and lists PR-SCTP, ECN, RECONF, ASCONF, I-DATA and AUTH.
- [Low] The commit fixes a wire-visible bug: an association restart on an
  accepted or peeled-off socket negotiates capabilities (PR-SCTP, ECN,…

--

sctp: copy endpoint settings to accepted and peeled-off sockets

This patch makes sctp_sock_migrate() copy the feature flags and AUTH
configuration from the listening socket's endpoint to the new endpoint.
Association restarts on accepted and peeled-off sockets then negotiate the
same capabilities as the listener. It adds sctp_auth_ep_copy(), which
deep-copies the HMAC list, the chunk list and the shared keys.

> As gomaja noticed, when accept() or SCTP_SOCKOPT_PEELOFF creates a new
> socket, sctp_endpoint_new() initialises the new endpoint from the network

[ ... ]

> Signed-off-by: Xin Long <lucien.xin@gmail.com>

[Severity: Low]
This fixes a restart negotiation problem that is visible on the wire.
There is no Fixes: tag to tell stable tooling which commit introduced it.
Could one be added?

The reporter is credited in prose ("As gomaja noticed"), but there is no
Reported-by: or Closes: trailer. Should one be included?

> diff --git a/net/sctp/auth.c b/net/sctp/auth.c
> index cbeb8a87a17a7..e075297b9ead1 100644
> --- a/net/sctp/auth.c
> +++ b/net/sctp/auth.c
> @@ -1056,3 +1056,50 @@ void sctp_auth_free(struct sctp_endpoint *ep)
>  	ep->auth_hmacs_list = NULL;
>  	ep->auth_chunk_list = NULL;
>  }
> +
> +int sctp_auth_ep_copy(struct sctp_endpoint *dst,
> +		      const struct sctp_endpoint *src, gfp_t gfp)
> +{
> +	struct sctp_shared_key *sh_key, *new_key;
> +

[ ... ]

> +	key_for_each(sh_key, &src->endpoint_shared_keys) {
> +		new_key = sctp_auth_shkey_create(sh_key->key_id, gfp);
> +		if (!new_key)
> +			goto nomem;
> +		new_key->key = sh_key->key;
> +		sctp_auth_key_hold(new_key->key);
> +		list_add_tail(&new_key->key_list, &dst->endpoint_shared_keys);
> +	}

[Severity: Medium]
Should sh_key->deactivated be copied into new_key here too?

sctp_auth_shkey_create() returns a zeroed container. Only key_id, refcnt
and key_list are set, and this loop never reads sh_key->deactivated.

For endpoint keys, sctp_auth_deact_key_id() leaves the key on
ep->endpoint_shared_keys and only marks it:

net/sctp/auth.c:sctp_auth_deact_key_id() {
    ...
	key->deactivated = 1;
    ...
}

After accept() or peeloff, a key that was deactivated on the listening
socket therefore looks active again on the new endpoint. This check in
sctp_auth_set_active_key() no longer fires for it:

	if (!found || key->deactivated)
		return -EINVAL;

An endpoint-level SCTP_AUTH_ACTIVE_KEY for a retired key id returns
-EINVAL on the listener but succeeds on the new socket. That lets
newep->active_key_id point at the retired key. Associations created later
on the new endpoint, for example on restart, would then inherit it.

Would something like this be needed?

	new_key->deactivated = sh_key->deactivated;

sctp_auth_asoc_copy_shkeys() also drops this flag when it copies keys
into associations. That part is existing behaviour, not something this
patch adds.

[ ... ]

> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index bc68af88e2710..bfd87be8ed54c 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -9623,6 +9623,23 @@ static int sctp_sock_migrate(struct sock *oldsk, struct sock *newsk,
>  	if (err)
>  		return err;
>  
> +	/* Copy the endpoint's feature flags and AUTH settings from the original
> +	 * endpoint so that restarts on the accepted or peeled-off socket
> +	 * negotiate the same capabilities.
> +	 */
> +	newep->prsctp_enable = oldsp->ep->prsctp_enable;
> +	newep->ecn_enable = oldsp->ep->ecn_enable;
> +	newep->reconf_enable = oldsp->ep->reconf_enable;
> +	newep->asconf_enable = oldsp->ep->asconf_enable;
> +	newep->intl_enable = oldsp->ep->intl_enable;
> +	newep->strreset_enable = oldsp->ep->strreset_enable;
> +	newep->sndbuf_policy = oldsp->ep->sndbuf_policy;
> +	newep->rcvbuf_policy = oldsp->ep->rcvbuf_policy;

[Severity: Low]
The commit message only covers restart negotiation of PR-SCTP, ECN,
RECONF, ASCONF, I-DATA and AUTH. It doesn't mention these last three
copies.

sndbuf_policy and rcvbuf_policy are not negotiated. sctp_endpoint_init()
sets them only from net->sctp.sndbuf_policy and net->sctp.rcvbuf_policy.

Once sctp_assoc_migrate() sets asoc->ep = newep, the live association
reads them in these functions:

  sctp_wspace()
  sctp_wake_up_waiters()
  sctp_assoc_rwnd_decrease()
  sctp_ulpevent_make_rcvmsg()
  inet_sctp_diag_fill()

If the sysctls changed between creating the listener and accept() or
peeloff, this changes which buffer accounting model the migrated
association uses.

strreset_enable is also copied without mention. New associations inherit
it, and getsockopt(SCTP_ENABLE_STREAM_RESET) reports it.

Could the commit message describe these copies as well?

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/48580ca6a02b588e9c24444801109506da11a9d2.1795396989.git.lucien.xin%40gmail.com
