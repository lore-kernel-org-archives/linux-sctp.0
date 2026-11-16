Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794820957;
	b=CwEQcJE0dTKdVOnn1hCON58JfaeQSUEM12/RneH+Od/GC7f06Xi5Qo3eM8o9CYl6qAFC
	 EPDyUcwdv6NM8VS4wTO2fdP3ibBhkmrp6C0LCghlcQRA008a5X3X0IPkW52b4ww3pO+Sz
	 4NCIxScQb0j13ub3MLxYW4yHuhZUSKtVyyLxs2vxwBqn/Wd3f0wRr1UemJgOGDe8EKhoe
	 SdMFwmjYPEQMQIJkTCibW/az+9D/BAIWY1tzrto2JPNuzzcY2RSh5mpaHMiMXJ/bAxG/3
	 mZj95tza0rsaQO8EXV8zBdMWOO1tEXOoZCKYVB0Pie4ati7dTcLXDo1meBeSXvJXSqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794820957;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=3RlmIg6JxxXg267jtA+puhGrh38QA4kd/Mzvm3x/l3E=;
	b=3DtOE34yh6T/+Gp9QvUGPH2jXrKGetfVHG7CnCg5YG9/3RriT7wh0s+KizC0yWjpGfZ3
	 ms8tgX2+MAyKEJ7ThRvox6RVAgZckFkz8DyaT0HwbVV78tw1bJB3p2EpIC7HHfGw1DR4r
	 nXqGpDfR/sEDorEfw/VTkioboIZpImwI+oLZV0Duf2yr3hdJfiHB9YIJF6Q6F+jEdlwtr
	 gGQcujHLIQJ5dHGSmSG3FK75Eb0nQA493tObM5DC7zuDm0G6hvprYUS8SOe68ghx7ZQlj
	 wmEMZFYndmyHmsez5rFUHWs6s8P+liOmwvNL8EO+84shPRjLYXyIiuz0aGrQQHn/l3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bsvYZF5o;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 921C0606A31C;
	Mon, 16 Nov 2026 09:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bsvYZF5o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63E0F1F000C6;
	Mon, 16 Nov 2026 09:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794820957;
	bh=3RlmIg6JxxXg267jtA+puhGrh38QA4kd/Mzvm3x/l3E=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=bsvYZF5oigMQJXCb187HaL08EYdWhy7xgqr3UmpALb3znyBT4WPKXgfoiHu+EegA3
	 rwcKablmjfqWuAZ2DIBdZnSs3Lk6EDx484TjL6v6CzNnIB75Ufp2MNZ+rK0N8Sf7Rb
	 Yn//JWXnI+PK8DmWiJMTI/QMPvdBHnjTS1oshOO7pQqBYqLamu7z/7ohmBuXHmjzYZ
	 Eq2xfOa7mlpJdfMbEKkHnymjiQ77hTbJ7EEKw8tLdiLUMJ4gVkwmXclA0l/rFaDy8R
	 OVSlaG/vmoFjhm2FpTDH/Oz6NN1ZlAibK5ZhXGYYl6FRBhkMFLQfozHCjg+oypDgpr
	 ystvA5nCHFrRg==
Subject:
 Re: [PATCH net] sctp: preserve the last transport during INIT error cleanup
From: netdev-bot+sashiko@kernel.org
To: ljp1205831794@gmail.com
Cc: netdev@vger.kernel.org, jiapenglin@tencent.com, marcelo.leitner@gmail.com,
 lucien.xin@gmail.com, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 vladislav.yasevich@hp.com, linux-sctp@vger.kernel.org,
 linux-kernel@vger.kernel.org
Date: Mon, 16 Nov 2026 09:22:35 +0000
Message-ID: <179482095589.3136.2362257339716532422@kernel.org>
In-Reply-To: <20261112092114.12458-1-ljp1205831794@gmail.com>
References: <20261112092114.12458-1-ljp1205831794@gmail.com>
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

- [Medium] When cleanup fails, the new `!list_is_singular()` guard in
  sctp_process_init() (net/sctp/sm_make_chunk.c) keeps whichever non-…
- [Low] The commit message says "The retained transport is freed when the
  association is destroyed", which suggests the kept non-ACTIVE…
- [Low] The comment at the clean_up label of sctp_process_init()
  (net/sctp/sm_make_chunk.c) still reads "/* Release the transport…

--

sctp: preserve the last transport during INIT error cleanup

This patch changes the clean_up path of sctp_process_init() so that the
loop removing non-ACTIVE peer transports always keeps the last one. That
stops sctp_assoc_rm_peer() from using the empty list head as the
replacement transport and crashing in sctp_assoc_set_primary().

> Keep the last transport during cleanup so sctp_assoc_rm_peer() has a
> valid replacement. The retained transport is freed when the association
> is destroyed.

[Severity: Low]
Is this description accurate for the path in the oops trace above?

The trace shows sctp_do_sm()->sctp_process_init() with no sctp_sf_*
frame. That is the SCTP_CMD_PEER_INIT path through sctp_cmd_process_init().
The sm_statefuns.c callers pass a new or temporary association and free it
on failure. This caller instead runs on the live COOKIE_WAIT association:

net/sctp/sm_sideeffect.c:sctp_cmd_process_init() {
    ...
	if (!sctp_process_init(asoc, chunk, sctp_source(chunk), peer_init, gfp))
		error = -ENOMEM;
    ...
}

In sctp_sf_do_5_1C_ack(), SCTP_CMD_PEER_INIT is queued before the
TIMER_STOP(T1_INIT) and NEW_STATE(COOKIE_ECHOED) commands. Those commands
are dropped when the interpreter bails out. The association stays in
COOKIE_WAIT with T1-init armed, and primary_path, active_path and
retran_path all point at the retained non-ACTIVE transport. Later T1-init
retransmissions use that transport.

Before this patch, every transport left after a failed sctp_process_init()
was ACTIVE.

Could the commit message describe this new state, where a live association
keeps running on a single non-ACTIVE transport?

> diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
> index 15c2d87575a8a..e4b7dacf174e6 100644
> --- a/net/sctp/sm_make_chunk.c
> +++ b/net/sctp/sm_make_chunk.c
> @@ -2528,7 +2528,8 @@ int sctp_process_init(struct sctp_association *asoc, struct sctp_chunk *chunk,
>  	/* Release the transport structures. */

[Severity: Low]
This isn't a bug, but the comment no longer matches the loop, which now
keeps the last transport on purpose, whatever its state.

Could the comment say that one transport has to remain because
sctp_assoc_rm_peer() takes the first list entry as the replacement path?
Without that, the list_is_singular() check could later look redundant.

>  	list_for_each_safe(pos, temp, &asoc->peer.transport_addr_list) {
>  		transport = list_entry(pos, struct sctp_transport, transports);
> -		if (transport->state != SCTP_ACTIVE)
> +		if (transport->state != SCTP_ACTIVE &&
> +		    !list_is_singular(&asoc->peer.transport_addr_list))
>  			sctp_assoc_rm_peer(asoc, transport);

[Severity: Medium]
Does this keep the right transport? The guard keeps whichever non-ACTIVE
transport the walk reaches last, which is the tail of
asoc->peer.transport_addr_list. That is not necessarily the transport for
peer_addr, the address the INIT-ACK came from.

For an existing peer, sctp_assoc_add_peer() only promotes SCTP_UNKNOWN:

net/sctp/associola.c:sctp_assoc_add_peer() {
    ...
		if (peer->state == SCTP_UNKNOWN) {
			peer->state = SCTP_ACTIVE;
		}
		return peer;
    ...
}

New transports are appended with list_add_tail_rcu(), and
sctp_process_param() adds the INIT-ACK address parameters as
SCTP_UNCONFIRMED.

Consider this sequence:

1. The peer_addr transport X is UNCONFIRMED and is primary. This can
   happen through sctp_setsockopt_primary_addr() or through an INIT-ACK
   SET_PRIMARY parameter. A Stale Cookie error then runs
   sctp_cmd_del_non_primary(), which leaves only X and returns the
   association to COOKIE_WAIT.

2. A new INIT-ACK from X carries address parameters Y1 and Y2, which are
   appended as UNCONFIRMED. The list is now [X, Y1, Y2].

3. The packet reaches clean_up. One way is an address that collides with
   a transport of another association on the endpoint, so
   sctp_hash_transport() returns -EEXIST. Another is the ADD-IP without
   AUTH check.

The loop then removes X (primary moves to Y1), then Y1 (paths move to Y2),
and keeps Y2. Y2 is an unverified address from the INIT-ACK that was just
rejected.

sctp_assoc_rm_peer() has set init_last_sent_to to NULL, so when T1-init
fires:

net/sctp/sm_sideeffect.c:sctp_cmd_interpreter() {
    ...
		case SCTP_CMD_INIT_CHOOSE_TRANSPORT:
			chunk = cmd->obj.chunk;
			t = sctp_assoc_choose_alter_transport(asoc,
						asoc->init_last_sent_to);
			asoc->init_last_sent_to = t;
			chunk->transport = t;
			t->init_sent_count++;
			/* Set the new transport as primary */
			sctp_assoc_set_primary(asoc, t);
    ...
}

INITs go to Y2 and Y2 becomes primary. Y2 also stays hashed in
sctp_transport_hashtable, so packets from it still match this association.
If X had been ACTIVE, X would have been kept and Y1 and Y2 removed instead.

Would it be more deterministic to keep the transport returned by the first
sctp_assoc_add_peer(asoc, peer_addr, ...) call, or the current
primary_path?

>  	}
>

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261112092114.12458-1-ljp1205831794%40gmail.com
