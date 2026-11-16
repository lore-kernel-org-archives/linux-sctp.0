Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794844048;
	b=c9b5euQWwbkjv+7jQ6tq+2dqUB7DF+BOBrALSC7ctzlAsRY/uHnzbWi1+UTIarCIBZLh
	 seAY6hicTzkAEJgZ3ZemYvW5PUbCW44LpZ0ClI5VaE+gp6lHXmolrnWXDqiCBzsvP7m9G
	 zzN2jnWgAfd5UAicUHiGASEwLIf6DPa8ADoIrObxb2VQR5YXjlxwue/LArUg6djd/P4YR
	 xHZ6ubHv5OHeO/sb/LOxqytyKS3rCwtwfijQ674vxwlDmIt6daq5frfLrdxScSqDbs+Bl
	 pG03DUc4aN0EyUaXzyge+tBEsxh7G3nHOy7sieyYpAXjx5OHB+7K0ajl7Q2I+QKwINw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794844048;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=DgvSdpgqo/6Q3DRzr9oY0yJxYdWV9SFCTzt1+TEwysk=;
	b=AmuYB4Zfn96tdQ9zY55TDwiebgC9+J69+i36Bv6Fp4GYZ2wdzXu7EM+axwJpPQjauySM
	 2enlsaSHRlyOgHzX5RC+7lVrK18CW/A40KOQFWfCgzhBvNZcxm+Le0FOmJwt3qTr5/hb8
	 bgOPbWno3q1bGDN7TKM9u1PozvMeFL5rK9Hm8yKPMd0NpBXN/0gLtzPOwX3KqMVG2qBeZ
	 ZHgiA0YOwR8l14hfzgJ4l8RDSuqMZe6TIeiKKK99rSlgGYcB/1kP+La2Z8ZzDr0hMC4IN
	 +5RW1zeFAe7NeKl/6mOC+FWCJGYdXlp7ZZq8uJmiTAPd/G3oNR59eSZJb1G9OQfNdUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CpviVmx5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0568606A331;
	Mon, 16 Nov 2026 15:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CpviVmx5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6663D1F000C4;
	Mon, 16 Nov 2026 15:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794844048;
	bh=DgvSdpgqo/6Q3DRzr9oY0yJxYdWV9SFCTzt1+TEwysk=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=CpviVmx5WDFRPf6kQ6D3wx0B3aUGQUHdHqQSopd9+w6X+t033cN22DD5HxXSrHy/L
	 qwwGTNXF9rh8SDCuBS9C140u4DxW13BOqILYvnWGky/PYA5VlI93c/dh5EJvIRIacv
	 3MonQy5Gtf+xSWe2m5ifpVaz+1qnMyG73ezmC7gROMXLrM2c4YJNHS6Zie3HZG0ZW3
	 KuAOh+Tp+4gbpWA6m/wFGfALRrul9jC27DpMFJBYbmLRLJIpIQYTVxxEDhUaMprk9l
	 14XPOLVmT96NGnln6NHdAaPYHB2pQW4EJhFwYtKDeuISGHnVyMQ5xqPxY+97Maqy/Z
	 Hm2M6gL4/BhQQ==
Subject: Re: [PATCH net 4/5] sctp: use skb_set_transport_header_careful() in
 sctp_v6_err()
From: netdev-bot+sashiko@kernel.org
To: edumazet@kernel.org
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 dsahern@kernel.org, idosch@nvidia.com, willemdebruijn.kernel@gmail.com,
 marcelo.leitner@gmail.com, lucien.xin@gmail.com, aconole@redhat.com,
 echaudro@redhat.com, i.maximets@ovn.org, daniel@iogearbox.net,
 justin.iurman@gmail.com, linus.luessing@c0d3.blue, sd@queasysnail.net,
 sbrivio@redhat.com, imv4bel@gmail.com, netdev@vger.kernel.org,
 linux-sctp@vger.kernel.org, dev@openvswitch.org, stable@vger.kernel.org
Date: Mon, 16 Nov 2026 15:47:26 +0000
Message-ID: <179484404697.3136.10852363970744263229@kernel.org>
In-Reply-To: <20261113124625.4010206-5-edumazet@kernel.org>
References: <20261113124625.4010206-5-edumazet@kernel.org>
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

- [Medium] The main part of this concern is fixed later in the series.

--

sctp: use skb_set_transport_header_careful() in sctp_v6_err()

sctp_v6_err() now stores the ICMPv6 inner transport offset with
skb_set_transport_header_careful(). If the offset does not fit in the
16-bit skb->transport_header field, the ICMPv6 error is ignored. Before,
the offset was silently truncated and sctp_err_lookup() read the SCTP
header from the wrong place.

> diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
> index 97390569c4bdc..ad5c951efdf06 100644
> --- a/net/sctp/ipv6.c
> +++ b/net/sctp/ipv6.c
> @@ -170,8 +170,11 @@ static int sctp_v6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
>  	/* Fix up skb to look at the embedded net header. */
>  	saveip	 = skb->network_header;
>  	savesctp = skb->transport_header;
> +	if (unlikely(!skb_set_transport_header_careful(skb, offset))) {
> +		__ICMP6_INC_STATS(net, __in6_dev_get(skb->dev), ICMP6_MIB_INERRORS);
> +		return -EINVAL;
> +	}
>  	skb_reset_network_header(skb);
> -	skb_set_transport_header(skb, offset);
>  	sk = sctp_err_lookup(net, AF_INET6, skb, sctp_hdr(skb), &asoc, &transport);

[Severity: Medium]

This covers native SCTP. Can the SCTP-over-UDPv6 handler in the same file
still hand a wrapped transport header to sctp_err_lookup()?

sctp_udp_v6_err() is installed as encap_err_lookup. It still does an
unchecked 16-bit add:

net/sctp/ipv6.c:sctp_udp_v6_err() {
    ...
	skb->transport_header += sizeof(struct udphdr);
	sk = sctp_err_lookup(net, AF_INET6, skb, sctp_hdr(skb), &asoc, &t);
    ...
}

A later patch in this series ("udp: use skb_set_transport_header_careful()
in __udp6_lib_err_encap()") makes __udp6_lib_err_encap() store the UDP
header offset carefully. That check only makes sure the UDP header offset
itself fits and is not U16_MAX, so transport_header can still be as high
as 0xFFFE when sctp_udp_v6_err() runs.

For a UDP header offset between 0xFFF7 and 0xFFFE, adding 8 gives a bad
value:

  - 0xFFF7 becomes 0xFFFF, the "not set" value. With CONFIG_DEBUG_NET this
    trips the DEBUG_NET_WARN_ON_ONCE() in skb_transport_header().
  - 0xFFF8 to 0xFFFE wrap to 0..6, so sctp_hdr(skb) points at
    skb->head + 0..6.

In the wrapped case, sctp_err_lookup() reads vtag from the wrong bytes.
sctp_v6_from_skb(), called through af->from_skb, also reads sh->source and
sh->dest from there for the association lookup. When vtag == 0, the INIT
chunk is read with skb_header_pointer() at a negative
skb_transport_offset().

The commit message says "Should the value be truncated, sctp_err_lookup()
would read the SCTP header at the wrong place". Would it make sense to
also check, before the += in sctp_udp_v6_err(), that transport_header +
sizeof(struct udphdr) fits in 16 bits and is not U16_MAX? Another option
is for __udp6_lib_err_encap() to reserve room for the payload header.

This needs the same large skb->data - skb->head precondition the series
describes, and there is no reproducer.

>  	/* Put back, the original pointers. */
>  	skb->network_header   = saveip;

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261113124625.4010206-1-edumazet%40kernel.org
