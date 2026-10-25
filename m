Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792930130;
	b=olWNhmKPdnmIbLy0AVgxv1x4lkY3U8M+mqo8WDWKrlg/Pi/8wbnDdwKZXwiOq6G1s0te
	 x3b0anJt7LnCrCmCxYBkhhaHDOWcFGluL43a+qRxI7MtOB9wXse28/cTaDvzyohKB7aML
	 rad7O/y+pCehwEQddBsZEQmj4JLZ3WQy+du4Xcg4wlkZx1sY9pXpxEpjEQcnxu2D0Oa6F
	 SEo3LbYFXNCoO65C3bPNy5K0S33brQbe2gEAPTRFmlxLsPcXmOdbviiAoegAdpvyyoeOs
	 1zooKM/DjaFs8Lmgv2Q+CNCz42zReejy0Vr0zRalee1MUaJpR7lRSLK558LE6ebWzDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792930130;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=Ba9CBmQwi5y96QRPkue7MMDE25GM5KbimpwxuGajWCg=;
	b=3hyQbQ2NrXJhtefFhiAhF2EVvNAEQQoGUrHJAThTMxXs4mnkuwzSdV5dTIID+/agZEnX
	 hhJ6rqELOMc7NWr1A9xolLyZPSQnJeaUTXUbO2nttkzVDGyPQXGcSppnO9Oxwkde46ITb
	 bCFQwCiK0WRbMxa5HtnjdAHLzFQebO7OgZGSY4J/K1AZ38jijTP8BrZ8tRsp+Wiym/dT5
	 XLIq/o3OltHdR0bi8F+1TsiRw+qETO4dD+ngbajw6FdA6ggbogGUg9aIbXlhjzayJn85Q
	 tQOG6u4gVbdSTqq0OcSHGUFIhskFX96KwWaBc2Fx+JQ8Po+zQY3Sxl8xB++0aWJ+ZNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h4Vuslut;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37665606A324;
	Sun, 25 Oct 2026 12:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h4Vuslut
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16AA51F01829;
	Sun, 25 Oct 2026 12:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792930129;
	bh=Ba9CBmQwi5y96QRPkue7MMDE25GM5KbimpwxuGajWCg=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=h4VuslutDmzIWQX4kAl4o+mwCroE1L/bljhd6V8aJ4Y3tfH6THRszthcyt3qWBqMQ
	 rD0h03O/ynEx6xITZlFKyx3vJD6tZNNsr701QQ7b4HmYTgbf2rvZeQwQkNZ4hFFZaR
	 0XogsWU9uMMB826b1anuwP4WsOOP/MJfbrNnUZoMb6/xVCNoYCtQwGxDIEO+6RwH4u
	 QaKP7YiahQ5G0NdZhJQw1mOHjzaLJTsyRRysmn9/+biiOv3qpIuVmUZ+JpEwV+rARo
	 BHxRAq4ss3ypE82WBzxGQm9AUqnvMgritGqwtnT8ci7edJforxxs8DKNba9Ev86oNa
	 FMU5T2JmxMYAA==
Subject: Re: [PATCH net 3/4] sctp: don't treat an I-FORWARD-TSN as an
 association reset
From: netdev-bot+sashiko@kernel.org
To: tim.budding@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, lucien.xin@gmail.com,
 marcelo.leitner@gmail.com, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, shuah@kernel.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Date: Sun, 25 Oct 2026 12:08:48 +0000
Message-ID: <179293012867.3134.16497481637722705271@kernel.org>
In-Reply-To: <20261024120627.837568-4-tim.budding@gmail.com>
References: <20261024120627.837568-4-tim.budding@gmail.com>
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

- [Medium] After this patch, sctp_intl_skip() is the only code that emits
  SCTP_PARTIAL_DELIVERY_ABORTED when an I-FORWARD-TSN reaches the…

--

sctp: don't treat an I-FORWARD-TSN as an association reset

This commit removes the ftsn == max_tsn_seen check from
sctp_report_iftsn(). That check made every I-FORWARD-TSN reaching the
leading edge abort partial delivery on all streams and flush the ulpq.
The SSN/TSN reset paths in stream.c now call abort_pd() explicitly, and
the leading-edge abort is left to sctp_intl_skip().

> diff --git a/net/sctp/stream_interleave.c b/net/sctp/stream_interleave.c
> index 77fe0db5ff774..f49b534ff78fd 100644
> --- a/net/sctp/stream_interleave.c
> +++ b/net/sctp/stream_interleave.c
> @@ -1225,9 +1225,6 @@ static void sctp_report_iftsn(struct sctp_ulpq *ulpq, __u32 ftsn)
>  {
>  	/* Move the Cumulattive TSN Ack ahead. */
>  	sctp_tsnmap_skip(&ulpq->asoc->peer.tsn_map, ftsn);
> -	/* abort only when it's for all data */
> -	if (ftsn == sctp_tsnmap_get_max_tsn_seen(&ulpq->asoc->peer.tsn_map))
> -		sctp_intl_abort_pd(ulpq, GFP_ATOMIC);
>  }

[Severity: Medium]
With this call gone, sctp_intl_skip() now sends
SCTP_PARTIAL_DELIVERY_ABORTED for an I-FORWARD-TSN at the leading edge.
Is the pdapi_seq it reports still the message that was being partially
delivered?

The removed path, sctp_intl_abort_pd(), reported the in-progress MID:

net/sctp/stream_interleave.c:sctp_intl_abort_pd() {
    ...
		if (sin->pd_mode_uo) {
			sin->pd_mode_uo = 0;

			mid = sin->mid_uo;
			sctp_intl_stream_abort_pd(ulpq, sid, mid, 0x1, gfp);
		}

		if (sin->pd_mode) {
			sin->pd_mode = 0;

			mid = sin->mid;
			sctp_intl_stream_abort_pd(ulpq, sid, mid, 0, gfp);
    ...
}

sctp_intl_skip() passes the skip entry MID instead:

net/sctp/stream_interleave.c:sctp_intl_skip() {
    ...
		if (sin->pd_mode_uo && !MID_lt(mid, sin->mid_uo)) {
			sin->pd_mode_uo = 0;
			sctp_intl_stream_abort_pd(ulpq, sid, mid, 0x1,
						  GFP_ATOMIC);
		}
    ...
	if (sin->pd_mode) {
		sin->pd_mode = 0;
		sctp_intl_stream_abort_pd(ulpq, sid, mid, 0x0, GFP_ATOMIC);
	}
    ...
}

The skip MID is the largest MID skipped on that stream, so it can be
greater than the in-progress MID. sctp_generate_iftsn() merges abandoned
chunks with the same stream and U flag into one entry and keeps the last
MID:

	skip_pos = sctp_get_skip_pos(&ftsn_skip_arr[0], nskips,
				     sid, flags);
	...
	ftsn_skip_arr[skip_pos].mid = mid;

sctp_ulpevent_make_pdapi() then copies this value into the user-visible
field with pd->pdapi_seq = seq.

Here is an example. The receiver is partially delivering ordered MID 3
on stream S. The sender abandons MIDs 3 and 4 on S and sends nothing
after them. The I-FORWARD-TSN then carries a single entry {S, mid=4}.
Before this patch userspace got pdapi_seq=3. Now it gets pdapi_seq=4,
a message that was never partially delivered.

sctp_intl_skip() already reported the skip MID for I-FORWARD-TSNs that
do not reach the leading edge. This patch extends that to the
leading-edge case, which the commit message describes as common. The
code is still the same at the end of the series.

Could sctp_intl_skip() pass sin->mid_uo (unordered) or sin->mid
(ordered) to sctp_intl_stream_abort_pd() for the notification, and
keep using the skip MID for the flush and sctp_mid_skip()?

>  
>  static void sctp_handle_fwdtsn(struct sctp_ulpq *ulpq, struct sctp_chunk *chunk)

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261024120627.837568-1-tim.budding%40gmail.com
