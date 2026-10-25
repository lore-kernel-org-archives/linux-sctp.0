Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792930131;
	b=00h3i8rmkw4PmuRsoT9NigllfU//k2nUCXlNUEIKpydUhPrHI43SPU4OGxCX9DlneQJs
	 00aq72OkC5VnZyXSNSEXXiI2jf1GoMeY1A+OKYnsbWHIrkXPB/FkU644rZNcylUq8IcCG
	 AXxwFI+r076bajfhYpKRTS3mjSWgm8K8nW5QJhWQ4oLsALT1ireimppaCwcsxYR15kWQB
	 ZOu6KNnzpKtmCcZtpH3fBdk2dxQObBdspxeylwIs9iceWzlmXu7LtNl5h1dbMXh6jo648
	 bQuKCjJxKCLimiPweKY7PKOLkwBNNJakM+8kwA1H7zb1+LU/nS2hui0vyCrBKOXcnNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792930131;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=1Srkchyn4UP9Lvo3MOvIyy2y34GPOiLZ1IITzWOyA74=;
	b=wHDXzoA4AgdREnhXU7JKvyAc/v3nlRaPkBtJjnwnEbAODYpaOG34OLFqPWQwEK6IANMe
	 pmX1f0pbBOwZ4eLUoJVmMIzqVtM18AbuZ8rzPNgHS2/xK6WPT4R3aohC2myCRY3pvxvg1
	 PCSsXivrnj2aH/MoWsnSAU/Vxf0cmSTxF3Jb+sROdjhHvqEnyy+E4UzYOdeWDXQEr0o24
	 du0kCKar3bQdvumiLfnyPlZxSv48cYKk2bSEijLxjwn4gMpcrmsyK6+v9KHbw9q0ENtJ2
	 0mGPg2Fwuc3y/ledufawrUNvkdUqzbnF1uc1+Fxyvg4eXQLhPyBtmzztz57cT42OHlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=c5hObA53;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86D72606A32D;
	Sun, 25 Oct 2026 12:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=c5hObA53
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65B271F01825;
	Sun, 25 Oct 2026 12:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792930131;
	bh=1Srkchyn4UP9Lvo3MOvIyy2y34GPOiLZ1IITzWOyA74=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=c5hObA53LgwcX3sPE5T1Gu6yEY72mbPOWf0Ys3JwLM021JYmObfWEvu+j2IL9pxXA
	 Ckm6bpEoU6nYkMIpjjkH+6nt962ggb2X5hF8LtXP6pR1O09hT170lx2N9VN8jxhLxG
	 bp3tMXeNymMsAFRa//A1YHHrk+VakL11mAwjucSZ+R+yzP+66DLDIe3wP4liYV4egf
	 CbzpoLDFjKdDECw33hO/F4BQi9p4siCqAHdDfU4y+JMWI7eFXbuVEPHGnO5wxnqmuz
	 xmIgoapdzUMraw8pHV2n8oLpX0qUk5Aju+Cp8UvkjAcwkgO76MBi/omtouLv2TiTkt
	 O7kwkIfaSbO7Q==
Subject: Re: [PATCH net 4/4] selftests: net: add SCTP I-FORWARD-TSN tests with
 message interleaving
From: netdev-bot+sashiko@kernel.org
To: tim.budding@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, lucien.xin@gmail.com,
 marcelo.leitner@gmail.com, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, shuah@kernel.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Date: Sun, 25 Oct 2026 12:08:49 +0000
Message-ID: <179293012994.3134.15218902499880345860@kernel.org>
In-Reply-To: <20261024120627.837568-5-tim.budding@gmail.com>
References: <20261024120627.837568-5-tim.budding@gmail.com>
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

- [Medium] In the ordered and unordered tests, main() in
  tools/testing/selftests/net/sctp_ifwdtsn.c samples the server…
- [Low] The reset case in tools/testing/selftests/net/sctp_ifwdtsn.c (`{
  .name = "reset", .reset = true }` at line 66, the reset branch of…
- [Low] wait_event() in tools/testing/selftests/net/sctp_ifwdtsn.c checks
  the deadline with `while (now_ms() < end)` (line 245), then reads the…

--

selftests: net: add SCTP I-FORWARD-TSN tests with message interleaving

This adds a helper and a script that test the receiver side of
I-FORWARD-TSN with RFC 8260 interleaving and PR-SCTP. Four cases send a
64KB reliable message interleaved with a PR-SCTP message that nft drops
and the sender abandons. A fifth case runs an SSN/TSN association reset.

> diff --git a/tools/testing/selftests/net/sctp_ifwdtsn.c b/tools/testing/selftests/net/sctp_ifwdtsn.c
> new file mode 100644
> index 0000000000000..15346aca10ef0
> --- /dev/null
> +++ b/tools/testing/selftests/net/sctp_ifwdtsn.c
> @@ -0,0 +1,538 @@

[ ... ]

> +/* Wait for a notification of @type on @fd, discarding anything else. */
> +static bool wait_event(int fd, int type)
> +{
> +	long long end = now_ms() + TIMEOUT_MS;
> +	char buf[256];
> +
> +	while (now_ms() < end) {
> +		struct pollfd pfd = { .fd = fd, .events = POLLIN };
> +		struct iovec iov = { buf, sizeof(buf) };
> +		struct msghdr msg = { .msg_iov = &iov, .msg_iovlen = 1 };
> +		union sctp_notification *sn = (void *)buf;
> +
> +		if (poll(&pfd, 1, end - now_ms()) <= 0)

[Severity: Low]
This isn't a bug, but the deadline check and the poll() timeout use two
separate now_ms() samples. If end - now_ms() comes out negative, poll()
blocks with no timeout. The helper would then hang until the kselftest
runner timeout instead of printing "client: no association reset event".

As the code stands this doesn't look reachable. wait_event() is only
called on the client socket in the reset test. That socket only
subscribes to SCTP_ASSOC_RESET_EVENT and gets no user data, so the loop
never runs a second time.

Could this compute the remaining time once and check left <= 0, as
server_recv() does, in case wait_event() is reused later?

> +			break;

[ ... ]

> +	send_msg(cfd, 0, t->big_uo, big, BIG_LEN, false);
> +	if (t->small_len)
> +		send_msg(cfd, 1, t->small_uo, small, t->small_len, true);
> +
> +	if (t->reset) {
> +		ok = server_recv(sfd, &s, got_big);
> +		if (ok && setsockopt(sfd, SOL_SCTP, SCTP_RESET_ASSOC, &id,
> +				     sizeof(id)))
> +			die("SCTP_RESET_ASSOC");

[Severity: Low]
Does the reset case check that queued I-DATA is discarded on reset?

The tests[] entry is:

	{ .name = "reset", .reset = true },

So no PR-SCTP message is sent and no partial delivery point is set.
SCTP_RESET_ASSOC is only issued after server_recv(got_big) has received
the whole 64KB message.

At that point sctp_process_strreset_tsnreq() runs on the client and
sctp_process_strreset_resp() handles PERFORMED on the server. On both
sides the reasm, reasm_uo and lobby queues are empty, and no stream is
in partial delivery. The previous patch in this series adds this call
on both paths:

	asoc->stream.si->abort_pd(&asoc->ulpq, GFP_ATOMIC);

Here it does nothing. The test would still pass if either call were
removed, or if sctp_intl_abort_pd() stopped flushing.

After "sctp: don't treat an I-FORWARD-TSN as an association reset",
sctp_report_iftsn() only calls sctp_tsnmap_skip(). These abort_pd()
calls are now the only place queued I-DATA is discarded on reset. That
patch says "For I-DATA the reset paths still discard everything as
before" and cites this test as its check.

The test does show that MIDs restart at 0, because the marker is
delivered. Could the test leave stale fragments, or a message in partial
delivery, pending on the server when the reset is issued?

[ ... ]

> +	send_msg(cfd, 0, false, MARKER, sizeof(MARKER), false);
> +
> +	if (t->small_len && !wait_abandoned(cfd)) {
> +		printf("client: small message was not abandoned\n");
> +		return KSFT_FAIL;
> +	}
> +	if (t->uo_marker)
> +		send_msg(cfd, 1, true, UO_MARKER, sizeof(UO_MARKER), false);
> +
> +	ok = server_recv(sfd, &s, got_all);
> +	rxq = assoc_rx_queue();

[Severity: Medium]
Can the RX_QUEUE check fail on a correct kernel in the ordered and
unordered tests?

For those tests got_all() only needs s->big && s->marker.
wait_abandoned() only polls the client's local abandoned_sent counter.
sctp_chunk_abandoned() increments that counter when the sender decides
to abandon. At that point the I-FORWARD-TSN still has at least the 50ms
netem delay ahead of it.

Until sctp_intl_skip() runs on the server, the received middle and end
fragments of the small message stay in the reasm queue and count toward
rmem_alloc. If the tail of big and the marker arrive before the
I-FORWARD-TSN, server_recv() returns at once. The test then reports
"... bytes left queued on the association".

With default sysctls nothing explicitly prevents this ordering. The B
fragment of small goes out early, and the client abandons it on the
first SACK after the fast retransmit, long before the tail of big is
sent.

What happens if net.core.wmem_default is lowered? sk_sndbuf can be
large enough for the 64KB sendmsg but smaller than the memory charged
for the ~66 big chunks. Then sendmsg(small) looks like it would block
here:

net/sctp/socket.c:sctp_sendmsg_to_asoc() {
    ...
	if (sctp_wspace(asoc) <= 0 || !sk_wmem_schedule(sk, msg_len)) {
		timeo = sock_sndtimeo(sk, msg->msg_flags & MSG_DONTWAIT);
		err = sctp_wait_for_sndbuf(asoc, transport, &timeo, msg_len);
    ...
}

Small and then the marker would be sent after all of big. The SACK for
the marker supplies the third miss report that triggers the fast
retransmit. So the marker would always reach the server before the
I-FORWARD-TSN.

Should this poll assoc_rx_queue() until it reaches 0, with a timeout?
Or wait for some sign on the server that the I-FORWARD-TSN was
processed? leading_edge and uo_pd already have such a barrier: the nft
rule, and the uo-marker that is sent after abandonment.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261024120627.837568-1-tim.budding%40gmail.com
