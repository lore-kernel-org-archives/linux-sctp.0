Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B88D71FDA61;
	Wed, 30 Sep 2026 00:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790729900; cv=none; b=rmpJGHFavZEJ0Tn5DNYVKjoXzxLh16UOD1Z2vrg8neXlJtYgaITfF+GgGnjj1aPwO8tUrNgf3bVITQ7bn/6nFZY6lHQFxME2OmsmbRgVSrtyKSOuYgfeea63bNmf7ubQuq6lYW6xWg8onG0iGYNm6jG5uOtUYo90CBSwKnIV3vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790729900; c=relaxed/simple;
	bh=+shfRr0QfCfi50S4m7hfWOK/QJgS0Coe6LEJVqoDlaM=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=kbh5MbPbbsqupiTU6VjVAK0JyAoRbii6jw6tpU4IlkQwSVqNPtRH7QE+SouF4Yp1IIs+XMRl58/qOObvLMTcHsOSMbhElUK+6Sayo5X5aEG2FIKbx2YRYix44/7qgtARhdK844wYImZtAWu/r8Kk0CuSHHUezfSirQ4RW7Dfjtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VSeUBw+q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VSeUBw+q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95D321F000FF;
	Wed, 30 Sep 2026 00:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790729898;
	bh=77pFl1HSm2gxlWdcA7DHMuiK62uUtmdEEUC5cd4SWDk=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=VSeUBw+qHu70u0JCQrdeweGJjtbCsSe3ZF8jMAO6IQSwYgP/zRTSW93A7yS8+l14G
	 hPBm/hqBI5PHa7ZaRGglfgCJn79vkrSona2mOEZxPH4+8kYtM1/mq17BIKk083dKzP
	 XbBDzyarI5Gv4I5HmNVDw5obWTgjNG6Uavhg9X+2ecDDr+ejAiXb3VZVR8K2hnpeTK
	 wPWSwmclzDuo+3UmWa2vsbPi3uGOEvoYW98zyKmviz7ZwLDcnH+F/AhnqQTemHcDKW
	 0nO5I8qSULnDwYNP0BvFeDgMJjrvRY5/in9eJMaEzWJY3SiCCgbxjUmq06HR2C+3xN
	 eW/Hwyde6YQ1Q==
Subject:
 Re: [PATCH net v3] sctp: check RCV_SHUTDOWN after the sendmsg connect wait
From: netdev-bot+sashiko@kernel.org
To: juny24602@gmail.com
Cc: marcelo.leitner@gmail.com, lucien.xin@gmail.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 linux-sctp@vger.kernel.org, netdev@vger.kernel.org, junvyyang@tencent.com,
 stable@vger.kernel.org, corvus@tencent.com
Date: Wed, 30 Sep 2026 00:58:17 +0000
Message-ID: <179072989710.434549.611689946552220471@kernel.org>
In-Reply-To: <20260926095606.68601-1-juny24602@gmail.com>
References: <20260926095606.68601-1-juny24602@gmail.com>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider.

Critical: 0 (1) · High: 0 · Medium: 1 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] In sctp_sendmsg_to_asoc() (net/sctp/socket.c:1847), the new
  condition `if (err || sk->sk_shutdown & RCV_SHUTDOWN)` returns -ESRCH…

Pre-existing issues:
- [Critical] This problem wasn't introduced by this patch, but it sits on
  the same post-wait path the patch hardens.

--

sctp: check RCV_SHUTDOWN after the sendmsg connect wait

On the intl_enable path of sctp_sendmsg_to_asoc(), this patch checks
sk->sk_shutdown & RCV_SHUTDOWN after sctp_wait_for_connect() and returns
-ESRCH if the bit is set. The aim is to stop the send from continuing with
an association that was freed while the socket lock was dropped. That can
happen when a concurrent SHUT_RD makes the wait break with err == 0.

> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index c7b9e325ec1cd..4652fd90d9a6c 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -1844,7 +1844,7 @@ static int sctp_sendmsg_to_asoc(struct sctp_association *asoc,
>  		if (asoc->ep->intl_enable) {
>  			timeo = sock_sndtimeo(sk, 0);
>  			err = sctp_wait_for_connect(asoc, &timeo);
> -			if (err) {
> +			if (err || sk->sk_shutdown & RCV_SHUTDOWN) {
>  				err = -ESRCH;
>  				goto err;
>  			}

[Severity: Medium]
Can this reject sends where the association is still alive and no race
happened?

The new condition only looks at the socket-wide RCV_SHUTDOWN bit. It does
not check whether the asoc actually died.

One case needs no race: shutdown(fd, SHUT_RD) on an unconnected socket.
inet_shutdown() falls through from TCP_CLOSE and sets the bit permanently,
even though it returns -ENOTCONN:

net/ipv4/af_inet.c:inet_shutdown() {
    ...
	case TCP_CLOSE:
		err = -ENOTCONN;
		fallthrough;
	default:
		WRITE_ONCE(sk->sk_shutdown, sk->sk_shutdown | how);
    ...
}

sctp_shutdown() does nothing for SHUT_RD alone. A later sendmsg() to a
new peer then goes through sctp_primitive_ASSOCIATE(). On its first
iteration, sctp_wait_for_connect() breaks with err == 0 without sleeping:

		if (sk->sk_shutdown & RCV_SHUTDOWN)
			break;

A concurrent SHUT_RD that arrives after the handshake, on a healthy
ESTABLISHED asoc, would also hit this check.

Before this patch, both cases went on to sctp_primitive_SEND() and returned
msg_len. Now the data is dropped and userspace gets ESRCH. sctp_sendmsg()
reads -ESRCH as "the asoc may be gone":

	if (err < 0 && err != -ESRCH && new)
		sctp_association_free(asoc);

So the new asoc stays on ep->asocs with its INIT already sent. A retry then
succeeds because the asoc is no longer CLOSED.

This also looks inconsistent with how other code handles the same wait
result:

- __sctp_connect() returns it as connect() success.
- The non-intl wait_connect branch in this function sends and returns
  msg_len.
- The comment above sctp_shutdown() says SHUT_RD "Disables further
  receive operations. No SCTP protocol action is taken". Disabling sends
  is left to SHUT_WR and SHUT_RDWR.

The commit message only describes closing the concurrent SHUT_RD + ABORT
race. It doesn't mention the new errno from sendmsg() or the association
left behind.

Would a narrower check work here? One option is to hold the asoc across
the wait and test asoc->base.dead. Another is to treat RCV_SHUTDOWN as an
error only when the asoc is actually dead.

[Severity: Critical]
This is a pre-existing issue, but it sits on the same post-wait path this
patch hardens. Can the transport pointer also be stale after this wait?

sctp_wait_for_connect() drops the socket lock but only pins the asoc. It
takes no reference on the caller's transport and never checks
transport->dead afterwards. sctp_wait_for_sndbuf() does both.

When the wait returns 0 because the asoc reached ESTABLISHED,
sctp_sendmsg_to_asoc() goes on to:

	list_for_each_entry(chunk, &datamsg->chunks, frag_list) {
		sctp_chunk_hold(chunk);
		sctp_set_owner_w(chunk);
		chunk->transport = transport;
	}

	err = sctp_primitive_SEND(net, asoc, datamsg);

This sequence appears to free the transport while the lock is dropped:

1. sctp_sendmsg_new_asoc() adds the primary daddr as SCTP_UNKNOWN through
   sctp_connect_new_asoc(). Extra SCTP_DSTADDRV4/V6 cmsg addresses are
   added the same way through sctp_connect_add_peer().

2. sctp_sendmsg() keeps the transport for TCP-style sockets, or when
   SCTP_ADDR_OVER is set.

3. An INIT-ACK arrives from one of the extra addresses with the correct
   vtag. Its address parameters do not list the primary.

4. sctp_process_init() removes every transport still in SCTP_UNKNOWN:

	list_for_each_safe(pos, temp, &asoc->peer.transport_addr_list) {
		transport = list_entry(pos, struct sctp_transport, transports);
		if (transport->state == SCTP_UNKNOWN) {
			sctp_assoc_rm_peer(asoc, transport);
		}
	}

   In COOKIE_WAIT nothing else pins the primary transport. So
   sctp_transport_free() drops the last reference, and the transport is
   freed after an RCU grace period.

5. COOKIE-ACK moves the asoc to ESTABLISHED. The waiter returns 0 with
   RCV_SHUTDOWN clear, so the new check passes.

6. The flush that sctp_primitive_SEND() triggers reaches
   sctp_outq_select_transport(). That function reads new_transport->state,
   then does list_add_tail() on ctx->transport->send_ready and calls
   sctp_packet_config() on the freed transport.

A local socket needs net.sctp.intl_enable, SCTP_FRAGMENT_INTERLEAVE and
SCTP_INTERLEAVING_SUPPORTED for this path. The INIT-ACK contents and source
address are controlled by the remote peer. The problem seems to date back
to when the intl path started waiting for the connection before sending.

Does this path need a sctp_transport_hold() and a transport->dead check
across the wait, as in sctp_wait_for_sndbuf()? Re-deriving the transport
after the wait would be another option.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260926095606.68601-1-juny24602%40gmail.com
