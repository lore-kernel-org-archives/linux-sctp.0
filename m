Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAF36DF76;
	Wed, 30 Sep 2026 00:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790726818; cv=none; b=I808rZ4TTjIP04htGEKp5wz+EpZ8/RDjZyAeQXnyEnY2tuZaQgs1f3y6Yv0XMcW23B/FO/r4E+VtRBc7W62gvhnK+y3lrkfUYDmVKR2FAHWbc8oaUpf6uhy1tHb4833usDI371wrR7D7XEBi944TRUCcqGcNTvh+kq40oGLU86A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790726818; c=relaxed/simple;
	bh=YYSyXtWdD275z6fqGlOddT3wsa+RIztJFYp78T4WzuU=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=fVcgyY6WKpN2r549dchcDSzrX8cC6ep4J4xoiziKvpIuXiHaQ0Ouzvrg7sIz2CnxJZMUtK5vjkDI4q4u+7QeQQ91yFyxZF7/K3AXKZTQytX+n1pCz/YONYZH6RhhqVpveAER5xJgdRWkYBz4TTdK60iVyy4xFRcn+HTbmStpzEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SDa8FnjZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SDa8FnjZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1EBF1F00893;
	Wed, 30 Sep 2026 00:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790726816;
	bh=AG0GoBCZhCbz8iUunpySvqwquWUcYAUnrfmVfCubudE=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=SDa8FnjZ6CpNFuTntbLEVqdM+StZ6GUnAsku1aiK/g0sTo63HVgt4TpCcJzYWW6aj
	 waEMWT5V5aHzhPD1vSoT9//gGKilvp/BqMG7DyaJx8f3bWNbePdFi+lNSZ3n91oMiT
	 M5UoGiBg9UcZVB3lJN5ftFoZUQg/xHLJoU39+Va0xMAV2Eyh565N+TTBYwYLMXVNnz
	 VabONp5HLTR8pfP8sjjn4WWhq6U414Lncw2+fEYGuerrZY8Co+n5GsZM36Ca99BfX3
	 Viz8rbGcjkx8jY7RaGY3gFpKhgA5qgFseWR4gZfjZCodqPqv965kVQ6HSFjVCY0ODG
	 yDEL9pTCVs1kg==
Subject: Re: [PATCH net v3 2/2] sctp: re-point retained control chunks on
 association migration
From: netdev-bot+sashiko@kernel.org
To: juny24602@gmail.com
Cc: marcelo.leitner@gmail.com, lucien.xin@gmail.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 linux-sctp@vger.kernel.org, netdev@vger.kernel.org, david.lee@trailofbits.com,
 kylebot@openai.com, junvyyang@tencent.com, stable@kernel.org,
 corvus@tencent.com
Date: Wed, 30 Sep 2026 00:06:55 +0000
Message-ID: <179072681524.434549.16395137413640226954@kernel.org>
In-Reply-To: <20260926100359.78731-3-juny24602@gmail.com>
References: <20260926100359.78731-3-juny24602@gmail.com>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 1 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] In net/sctp/socket.c, sctp_for_each_tx_chunk() walks the control
  chunks with a bare cb(chunk) on q->control_chunk_list,…
- [Medium] sctp_set_owner_w_migrate() passes control chunks to
  sctp_control_set_owner_w().

--

sctp: re-point retained control chunks on association migration

This patch extends the tx walk in sctp_sock_migrate() to cover retained
control chunks as well: control_chunk_list, asconf_ack_list,
addip_chunk_list, strreset_chunk and addip_last_asconf. Their owner is
moved to the new socket. It exports sctp_control_set_owner_w() for chunks
that have no datamsg, and saves the old chunk->shkey so that key can be
released after the new owner is set.

> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index 4a08023d52aae..efee9e3e671ef 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -155,9 +155,15 @@ static void sctp_clear_owner_w(struct sctp_chunk *chunk)
>  
>  static void sctp_set_owner_w_migrate(struct sctp_chunk *chunk)
>  {
> -	sctp_set_owner_w(chunk);
> -	if (chunk->shkey)
> -		sctp_auth_shkey_release(chunk->shkey);
> +	struct sctp_shared_key *shkey = chunk->shkey;
> +
> +	if (chunk->msg)
> +		sctp_set_owner_w(chunk);
> +	else
> +		sctp_control_set_owner_w(chunk);
> +
> +	if (shkey)
> +		sctp_auth_shkey_release(shkey);
>  }

[Severity: Medium]

For control chunks with chunk->auth set, sctp_control_set_owner_w() always
does this:

	if (chunk->auth) {
		chunk->shkey = asoc->shkey;
		sctp_auth_shkey_hold(chunk->shkey);
	}

After peeloff/accept, a retained control chunk (an ASCONF-ACK,
addip_last_asconf or strreset_chunk) that was built under key K is
switched to whatever key is active at migration time. Is that intended?

The DATA path through sctp_set_owner_w() keeps the key that was already
selected. The prerequisite shkey patch also describes the transfer as
keeping the selected authentication key.

The commit message says:

  "since sctp_control_set_owner_w() may select a different asoc->shkey."

It doesn't mention that retransmissions of these chunks would then be
authenticated with a different key id.

Can this also lose the SCTP_AUTH_FREE_KEY event for K? Suppose K was
deactivated while chunk C still holds it, so K's refcnt is 2. K cannot
be the active key at that point, per sctp_auth_deact_key_id():

clear pass:
  sctp_clear_owner_w()
    sctp_auth_shkey_hold(K)            K refcnt 3
    skb_orphan()
      sctp_control_release_owner()     sees refcnt 3, no event
        sctp_auth_shkey_release(K)     K refcnt 2

set pass:
  sctp_set_owner_w_migrate()
    sctp_control_set_owner_w()         C->shkey = K', hold K'
    sctp_auth_shkey_release(K)         K refcnt 1

The last chunk reference on K is dropped by the plain
sctp_auth_shkey_release() in sctp_set_owner_w_migrate(). That call skips
the refcnt == 2 check, so no later code path sends SCTP_AUTH_FREE_KEY
for K.

[ ... ]

> @@ -198,6 +204,21 @@ static void sctp_for_each_tx_datachunk(struct sctp_association *asoc,
>  
>  	list_for_each_entry(chunk, &q->out_chunk_list, list)
>  		traverse_and_process();
> +
> +	list_for_each_entry(chunk, &q->control_chunk_list, list)
> +		cb(chunk);
> +
> +	list_for_each_entry(chunk, &asoc->asconf_ack_list, transmitted_list)
> +		cb(chunk);
> +
> +	list_for_each_entry(chunk, &asoc->addip_chunk_list, list)
> +		cb(chunk);
> +
> +	if (asoc->strreset_chunk)
> +		cb(asoc->strreset_chunk);
> +
> +	if (asoc->addip_last_asconf)
> +		cb(asoc->addip_last_asconf);
>  }

[Severity: High]

These new walks call cb() without any filter. The DATA walks go through
traverse_and_process(), which checks c->skb->sk against asoc->base.sk so
each chunk is processed only once. Can a retained control chunk be
reachable from more than one of these lists or pointers at once?

sctp_process_asconf() links the ASCONF-ACK on asconf_ack_list through
transmitted_list:

	sctp_chunk_hold(asconf_ack);
	list_add_tail(&asconf_ack->transmitted_list,
		      &asoc->asconf_ack_list);

sctp_sf_do_asconf() then queues the same chunk on control_chunk_list
through ->list with SCTP_CMD_REPLY. sctp_assoc_lookup_asconf_ack()
already skips entries where sctp_chunk_pending() is true, so being on
both lists is an expected state.

strreset_chunk and addip_last_asconf are also queued on
control_chunk_list while the pointer is still held.

These chunks can stay on control_chunk_list across a flush.
sctp_outq_flush_ctrl() skips them while src_out_of_asoc_ok is set, which
userspace can trigger through sctp_send_asconf_del_ip():

		if (ctx->asoc->src_out_of_asoc_ok &&
		    chunk->chunk_hdr->type != SCTP_CID_ASCONF)
			continue;

It also puts back chunks that fail to transmit:

			if (status != SCTP_XMIT_OK) {
				/* put the chunk back */
				list_add(&chunk->list, &ctx->q->control_chunk_list);

Take such a chunk with chunk->auth set, old key K and new key K'. The
refcounts go like this:

clear pass, first visit:
  sctp_clear_owner_w()        hold K
    skb_orphan()              destructor releases K, clears destructor
clear pass, second visit:
  sctp_clear_owner_w()        hold K
    skb_orphan()              no destructor, nothing released
set pass, first visit:
  sctp_set_owner_w_migrate()  hold K', release K
set pass, second visit:
  sctp_set_owner_w_migrate()  hold K', release K' (chunk->shkey is K')

Does this leak a reference on K? The net change is +1 on K. The struct
sctp_shared_key and its sctp_auth_bytes would then never be freed, and
the refcnt == 2 check in sctp_control_release_owner() could never fire
for K.

A local user who controls both ends over loopback could repeat this for
each association.

Could these walks skip chunks that were already handled, for example
with the same skb->sk check that traverse_and_process() uses?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260926100359.78731-1-juny24602%40gmail.com
