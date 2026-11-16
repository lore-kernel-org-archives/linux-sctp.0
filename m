Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794844047;
	b=P2PR6wk6Jun4O7O5j2Zy0Gjgc+DyK1m1PdiU8BDws+cTX1vSEHTqflYipqdO7xIpzY78
	 VBKU37wtYGFlai51V7eEl5UQeR2r+YMYMBVkocsZm0KTS3Pn2yIallusrHI5sZQbIH5EF
	 xOLYtUliqJq5Hwu10CgL1CtA8MVGxOFsPt42kScFVrgcVWwNaYSbsVWccW5tE1bSZ/07+
	 PrDgcdzHV8/DTmWvyBdfPlRcCBDm6d7lAjAVBY8V0Mj8E2GvUc+aEF3Z/kBJ1WaQZqFMG
	 y1NGdRxJlrttsn5kZ72Y+Oc2m2JvxpvdfNeiUKnUOGow0Y4mCQbdQYlGT0ah0V9FIvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794844047;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=apEKwoPRE6JoJwbqa4rnx2OGO6+8FaVn4MLdk1yzOiU=;
	b=0x8VzTkv+zvN6aEe67R+DD63XGJPuwWwYD3waeIpnUpz/SanyN2kyD6V/5TavgW/l5mr
	 BwChPV2zD29ZLmob3SqFlWjwR6tg+Rj/XGnNWvXQe2rB439damLaMcBFrTldvyfwwgr5e
	 AaL/T0jI3RyGCLDOvslRrFfBhrq4oJPtKUVvYTLkiIel4AQ87ooxlTXVHGD7aTrpEHO/0
	 opqEt+CIfAAOmbGRhZkY8ao9vX2n9InP6SqS6cd87CfmwtliJ69RsiIEJ8oK/xSjDiXyT
	 PPGaFigs33AB4260Tb7EIA0eEXg5aapa2+kyHEK2B1fgFNdBsmXCfiHDEQCQbcDmW/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hq2x06CJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43A49606A31C;
	Mon, 16 Nov 2026 15:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hq2x06CJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BAC71F000C4;
	Mon, 16 Nov 2026 15:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794844046;
	bh=apEKwoPRE6JoJwbqa4rnx2OGO6+8FaVn4MLdk1yzOiU=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=hq2x06CJKAegzbvnCEsYO5yM6U5/xBbYS7BlOem95b4IEXtO4Hm5IJftisawKkdEY
	 1TmevO1soXSrbCg0L7xweCT1eRjUIytY/1Dub4kg2JP3NSZAA2ZbL9O/SQnAIIM7ll
	 B3D8/ZKHtpcXLmGNdNtTUvu5e59g7Zfpn0Nt4lrNxttmuVCOHLyysVR0YscKRIEel6
	 UUektaLS1NoNIS8CjXZv26HvWeGxjOBpbsBmaOtthSdk/Z/4uxX5+xLBmo2Hka3fcA
	 E2vGtHXo6Ik4QxITnilCK7xDiodx+OEmt7I3mpbY8sZHWF8GqU50sWYTg9pCpzlTHd
	 Z2Qko/soXONnA==
Subject: Re: [PATCH net 1/5] ipv6: gro: limit the number of extension headers
From: netdev-bot+sashiko@kernel.org
To: edumazet@kernel.org
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 dsahern@kernel.org, idosch@nvidia.com, willemdebruijn.kernel@gmail.com,
 marcelo.leitner@gmail.com, lucien.xin@gmail.com, aconole@redhat.com,
 echaudro@redhat.com, i.maximets@ovn.org, daniel@iogearbox.net,
 justin.iurman@gmail.com, linus.luessing@c0d3.blue, sd@queasysnail.net,
 sbrivio@redhat.com, imv4bel@gmail.com, netdev@vger.kernel.org,
 linux-sctp@vger.kernel.org, dev@openvswitch.org, stable@vger.kernel.org
Date: Mon, 16 Nov 2026 15:47:25 +0000
Message-ID: <179484404508.3136.1665023994705750300@kernel.org>
In-Reply-To: <20261113124625.4010206-2-edumazet@kernel.org>
References: <20261113124625.4010206-2-edumazet@kernel.org>
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

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 0 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] This patch caps extension headers per IPv6 GRO layer.

--

ipv6: gro: limit the number of extension headers

The patch caps the number of extension headers that
ipv6_gro_pull_exthdrs() walks at IP6_MAX_EXT_HDRS_CNT, matching
ip6_protocol_deliver_rcu(). The goal is to keep the GRO transport header
offset from overflowing the 16-bit skb->transport_header and causing an
out-of-bounds read in gro_receive_network_flush().

Link: https://lore.kernel.org/netdev/avTTQNyvwPP6LtGx@v4bel/

> diff --git a/net/ipv6/ip6_offload.c b/net/ipv6/ip6_offload.c
> index 700f1861d8eb7..01642900c0fa3 100644
> --- a/net/ipv6/ip6_offload.c
> +++ b/net/ipv6/ip6_offload.c
> @@ -26,6 +26,7 @@ static int ipv6_gro_pull_exthdrs(struct sk_buff *skb, int off, int proto)
>  {
>  	const struct net_offload *ops = NULL;
>  	struct ipv6_opt_hdr *opth;
> +	int exthdr_cnt = 0;
>
>  	for (;;) {
>  		int len;
> @@ -38,6 +39,13 @@ static int ipv6_gro_pull_exthdrs(struct sk_buff *skb, int off, int proto)
>  		if (!(ops->flags & INET6_PROTO_GSO_EXTHDR))
>  			break;
>
> +		/* Same limit as ip6_protocol_deliver_rcu().
> +		 * @proto is left pointing to an extension header,
> +		 * so that the caller does not aggregate this packet.
> +		 */
> +		if (unlikely(exthdr_cnt++ >= IP6_MAX_EXT_HDRS_CNT))
> +			break;

[Severity: High]
Does this fully close the out-of-bounds read in
gro_receive_network_flush()?

exthdr_cnt is local and starts at 0 on every call. That bounds each
ipv6_gro_receive() pass to roughly 40 + 12 * 2048 bytes, but it does not
bound the transport offset of the whole packet.

Within a single GRO pass, sit_ip6ip6_gro_receive() sets encap_mark and
calls back into ipv6_gro_receive() for an inner IPv6 header. Each
layer's ipv6_gro_pull_exthdrs() call is allowed another 12 extension
headers:

ipv6_gro_receive()
  ipv6_gro_pull_exthdrs()        /* up to 12 exthdrs */
  sit_ip6ip6_gro_receive()
    ipv6_gro_receive()
      ipv6_gro_pull_exthdrs()    /* another 12 exthdrs */

skb->transport_header is also measured from skb->head, so headroom
counts toward it. __ip6_tnl_rcv() in net/ipv6/ip6_tunnel.c hands the
decapsulated skb back to GRO:

    gro_cells_receive(&tunnel->gro_cells, skb);

The outer headers stay in the buffer as headroom. That outer layer was
only checked by ip6_protocol_deliver_rcu(), which also allows 12
extension headers.

Put together, headroom + outer + inner + inner-inner headers can add up
to more than 65535 bytes inside one IPv6 datagram. At that point, this
store in ipv6_gro_receive() silently wraps the __u16:

    skb_set_transport_header(skb, skb_gro_offset(skb));

inet_gro_receive() in net/ipv4/af_inet.c has the same pattern for an
inner IPv4 header.

Suppose a second packet of the same flow then arrives. tcp_gro_receive()
takes th2 = tcp_hdr(p) at the wrapped offset. That offset lands in outer
header bytes the sender controls, so the port check in tcp_gro_lookup()
can be made to match. gro_receive_network_flush() then runs:

    int off = skb_transport_offset(p);
    ...
    flush = __gro_receive_network_flush(th, th2, p, off - NAPI_GRO_CB(p)->network_offset, false);

off is negative here, so the u16 diff ends up large. In
__gro_receive_network_flush(), nh2 = th2 - diff then points tens of KB
before p->head. Isn't that the same out-of-bounds read this patch is
meant to fix?

The commit message notes that "offsets can still accumulate over nested
encapsulations, so the places storing them should be hardened
separately". The rest of the series adds
skb_set_transport_header_careful() in ipv6_mc_check_exthdrs(),
parse_ipv6hdr(), sctp_v6_err() and __udp6_lib_err_encap(). It does not
touch the two GRO store sites in ipv6_gro_receive() and
inet_gro_receive() that feed gro_receive_network_flush().

The patch carries Fixes: and Cc: stable. Should those two GRO sites also
use skb_set_transport_header_careful(), and flush when it fails, so that
backports close the reported read as well?

>  		opth = skb_gro_header(skb, off + sizeof(*opth), off);
>  		if (unlikely(!opth))
>  			break;

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261113124625.4010206-1-edumazet%40kernel.org
