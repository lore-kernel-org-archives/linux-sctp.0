Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794138718;
	b=37AqyOHZ+1ejmG7c2cV2Z9DOXLCRd5eSRGv7tJYcfNQfy8l8btrSInh8qIjRGdH3QZjl
	 ok7uf/uiBTQI28tnIiVPVLTmcodMD1n5c5nztzAVVCxUAifdZt5FhidtAUTeL38BU+ua3
	 GpNjbMhTAQKU+LQgH3aOmG1edYQO9b/S7O2+raqXjfJ4AvoAUba5ymoCEJVIFXF7DHowl
	 eVBEpe1/4PhoQoDo8+WnUqyljqFYPAU1SSLfOwpZAdWQGHYXqGvOd5wH3d8lGpHq4f+2b
	 KmZalrhYllLPWUUMrzHqf4OzcGVi787iAjsA6Kpy62pWlmgP7rmUoZWUy73KIMRRwOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794138718;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=6irgwjl0CKnMQ9nS5iLmZ+DUm7sN5bmZr5v1ixkjk2c=;
	b=cATrZN4xMcwReb1FeC3RS73xSSVIUsaXVcmjI4Wcv3bbn0anXToBtDsAID/Z6DCH8nEI
	 NfR3OjuoF/FnXkAysomATxfeK1USN7oViZBydlvpFjg0jreyYEl0sDZtCFLyXdDh155Qv
	 jAa/tFKhzey7115nGqmp5sdbac5UAoAEAu8jVeI3RtR5Z+VjN08aEsla8TRDKQ4YvCj07
	 ohukFsDLAhOiGczDLMU+7E6rlLAbstMwP05wuMR7KOSSQ7dv25itpKCZaetDckm/6rwni
	 a0MjLCsqwDhYdXbc7o6FJwJEM+jiX3zWvAYlpdkb5lcXVtljwdY3MPysKa8oBb8NUvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lumrOjkX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE664606A321;
	Sun,  8 Nov 2026 11:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lumrOjkX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A01151F0089F;
	Sun,  8 Nov 2026 11:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794138717;
	bh=6irgwjl0CKnMQ9nS5iLmZ+DUm7sN5bmZr5v1ixkjk2c=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=lumrOjkXe+QBW/NcP3EhoyY6/YiHed3QJSIQ5VJZFUdwrTn65v9HMVyJilAHFChmo
	 7i2Y2rEn8q4UOxLACRIVgWxg1Jhbt8S+PPpVN5D6O8B5NKUf01vBRsqkzZ+8f9+R4G
	 EaG7tuQ559FUnf2r/sl4BX6WWO2URo0b+Bqw0TkPH4IuMCkbcSX4XJ1kr7vWkrPuV9
	 Tsb5SMYWC8j/RcDynthJ0MUX+sVMXDycjh2Ot6bQmMGEylTkB7j+BqZMPbpsJp7Mov
	 qkcVP/J3DPWguqgfsNtT2r47NgnSqf0WCRd1GFAfkdi7XFqlNTBXEd/jUiSFSAYIRT
	 h6Z1+rFgMekcw==
Subject: Re: [PATCH net] sctp: preserve stream scheduler across outq teardown
From: netdev-bot+sashiko@kernel.org
To: juny24602@gmail.com
Cc: marcelo.leitner@gmail.com, lucien.xin@gmail.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 linux-sctp@vger.kernel.org, netdev@vger.kernel.org, junvyyang@tencent.com,
 stable@kernel.org, corvus@tencent.com
Date: Sun, 08 Nov 2026 11:51:56 +0000
Message-ID: <179413871612.994134.359540125574426236@kernel.org>
In-Reply-To: <20261104105507.62743-1-juny24602@gmail.com>
References: <20261104105507.62743-1-juny24602@gmail.com>
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

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] The patch changes how outqueue teardown behaves in the common
  case, and the commit message does not say so.

--

sctp: preserve stream scheduler across outq teardown

This patch keeps q->sched in sctp_outq_init() across the memset, so that
sctp_sched_set_sched() can free the old scheduler's per-stream state when
sctp_outq_teardown() reinitializes a live outqueue. Without that,
installing a different default scheduler could read stale data through
the shared union in struct sctp_stream_out_ext.

> diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
> index e92fb9da4647a..6cb4b4339d8b7 100644
> --- a/net/sctp/outqueue.c
> +++ b/net/sctp/outqueue.c
> @@ -190,9 +190,13 @@ static inline int sctp_cacc_skip(struct sctp_transport *primary,
>   */
>  void sctp_outq_init(struct sctp_association *asoc, struct sctp_outq *q)
>  {
> +	const struct sctp_sched_ops *sched = q->sched;
> +
>  	memset(q, 0, sizeof(struct sctp_outq));
>
>  	q->asoc = asoc;
> +	/* Retain the scheduler to allow freeing its per-stream state. */
> +	q->sched = sched;

[Severity: Medium]
The commit message only talks about the case where the installed scheduler
differs from sctp_sk(sk)->default_ss. Does this also change behaviour in
the more common case, where the two are the same?

Before this patch, q->sched was NULL after the memset. That meant
sctp_sched_set_sched() never took its early return, and every outqueue
purge ran n->init() and n->init_sid() on each stream:

net/sctp/stream_sched.c:sctp_sched_set_sched() {
    ...
	n = sctp_sched_ops[sched];
	if (old == n)
		return ret;
    ...
	n->init(&asoc->stream);
	for (i = 0; i < asoc->stream.outcnt; i++) {
		...
		ret = n->init_sid(&asoc->stream, i, GFP_ATOMIC);
    ...
}

With q->sched kept, old == n whenever default_ss matches the installed
scheduler, so the per-stream reset is skipped. The init_sid callbacks that
no longer run on teardown are:

net/sctp/stream_sched_prio.c:sctp_sched_prio_init_sid() {
	...
	return sctp_sched_prio_set(stream, sid, 0, gfp);
}

net/sctp/stream_sched_fc.c:sctp_sched_fc_init_sid() {
	...
	soute->fc_length = 0;
	soute->fc_weight = 1;
	...
}

As a result, PRIO priorities and WFQ weights set through
SCTP_STREAM_SCHEDULER_VALUE now survive a peer restart and a stale-cookie
retry. Previously both paths reset them to 0 and 1:

sctp_sf_do_dupcook_a() / sctp_sf_do_5_2_6_stale()
  -> SCTP_CMD_PURGE_OUTQUEUE
    -> sctp_outq_teardown()
      -> sctp_outq_init()
        -> sctp_sched_set_sched()   /* returns early, old == n */

For FC and WFQ there is a second effect. __sctp_outq_teardown() calls
sctp_sched_dequeue_done() on every leftover data chunk it discards:

net/sctp/outqueue.c:__sctp_outq_teardown() {
    ...
	while ((chunk = sctp_outq_dequeue_data(q)) != NULL) {
		sctp_sched_dequeue_done(q, chunk);

		/* Mark as send failure. */
		sctp_chunk_fail(chunk, q->error);
    ...
}

sctp_sched_fc_dequeue_done() then adds ch->skb->len to soute->fc_length.
That used to be cleared by init_sid. Now it isn't, so a stream with a
large unsent backlog at restart begins the restarted association with
fc_length inflated by bytes that were never sent.

Keeping the user-configured values may well be the preferred behaviour.
Since this is going to stable, could the commit message describe it? If
it isn't intended, should teardown reset the per-stream scheduler state
explicitly, or at least the fc_length accumulated from discarded chunks?

>  	INIT_LIST_HEAD(&q->out_chunk_list);
>  	INIT_LIST_HEAD(&q->control_chunk_list);
>  	INIT_LIST_HEAD(&q->retransmit);

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261104105507.62743-1-juny24602%40gmail.com
