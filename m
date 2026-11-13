Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794574720;
	b=dTsYnBdkpsKUuJo4i2wkhiew+wRjrGm7cwL9IiUgCvLr3rRpTun8gVJz2Oo/DV/FD2Ae
	 XYsQ1LGh30U5WW7T+15SZQujMLX88PebLP9hOmidEJ7alW+VTi8/5qx7AnHI1TQCppQ9P
	 7R8N6Tz6Nt/5BUmoLyO0hj9XO6ezBz6S8clv80l30Delg/1xBoj/s+Pt5Yz7nU5fXHaiO
	 zBq8wjwSnkPKYetcTkleElCrL9+dIfrrxEXQ7SR63OaI8syksNzAAhB18tk1sWOhDc4U8
	 Hg8ssQbhiLkrhUiWTKq/gkogZNSoWAkmC9FTF4grhH24E5qQ1nI/zBn6z+capg6nr5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794574720;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=HbPJR8S7V/lAdH8GEImzC/9dsJwbaq/ITvmKn5PwyDo=;
	b=f8ZwrPZA1WseIWfu73EoMaUxMcOJLzkT1PNGc0R1eyOC1tvgKm9DHKrwgvjPPrjQ268T
	 mT1rt1ybDEtPnFGnyG0qb3BFFdYf6hQzsEeNz5l7zJVfsi5mFzXx3vivszpNL3vregtia
	 V+PVFLLUUj176Cz3CzfNL7ulzX8RWvgTcEsH2HMINuH/UI9skiKDvP0IBMJ9NXv7tnah3
	 w5flKkgeIWA4YYUxIX/1aepdLz4oUfEbIXn8TuD14wDDIO/LF+uG5ilYzwZwCx2RA55d1
	 RcV/ZHUHFpZhQRJxPzX6EJL60iIzMrFc8WHnQw31tVQ5IwzywW+hOaPP7f2Ybw2Nvjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Rcx54Hjr;
	arc=none smtp.remote-ip=209.85.214.169
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01E49606A331
	for <linux-sctp@vger.kernel.org>; Fri, 13 Nov 2026 12:58:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 01E49606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Rcx54Hjr
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2ed0890476fso12634665ad.0
        for <linux-sctp@vger.kernel.org>; Fri, 13 Nov 2026 04:58:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794574719; x=1795179519; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=HbPJR8S7V/lAdH8GEImzC/9dsJwbaq/ITvmKn5PwyDo=;
        b=Rcx54Hjr2g/nu/NUW5elGTukc1iLZ+5oltNqc2lOWpk6GuB3Y8pB5AC3QFUIsqmFt3
         yiefb9JeD4rAM3/InTQ8OmV7s6aVyEMSnht5LtgpC6hUef677ASWreLi6Xw0tiX7MjBV
         RTlsRydF2lphapMMNssZY5wi2gP9u3H7y03GUewD/1iw9SnjZG0WEZbnYO6OQ6dopwOl
         jRvsZ1+H1VN8tDLbxe/VN4Cb/4uqQs47AfCqySFa4O79V7k2ehIZk9kV2U9QshpUn9rf
         TNU39j/DYfJgY7ikXiIx4L1pqsBHib57dIWLyt9DTpy0pPIjdTIcUcYQrnYTiflfDnbE
         svBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794574719; x=1795179519;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HbPJR8S7V/lAdH8GEImzC/9dsJwbaq/ITvmKn5PwyDo=;
        b=uBsC7vk6xfrCLPggEd8WPbBf6TI80VD2lHcW5lehK7ickYz1x2t+TfHheGy61sGNiM
         12chckR7yht5gvdHT1/BrvVhSxxv+t3dgyHERnmn7hHqC/8ZOREa4j2ZZSPkurxJK+1+
         ZE4XMXnGndlwTN5VmMRGe+1RYrV5isGWvjWGfbvRmoqgrcayYoIeibt/M8192cdRYWdA
         8EoCxsM3Q8Mq+5pLaAJtHhHUMcQAVq5HmtlNdUVf1AKUH4x9kVfVdkTSkxtdsb5+0CfB
         bQv1cOkGRAy/vFm6Wf52XInbve/MbDqAIv6kJu35Ark7jsAEhr12u8pv+093qrAMB5qp
         3eOw==
X-Forwarded-Encrypted: i=1; AL+hErGNbn1StZcVkzjQwqvi0Szyhs9yygpxRIzUx7h6vgt4OvGSXN8qalWKNmrfehHC7x2kKAMZD7l92ShI@vger.kernel.org
X-Gm-Message-State: APuU4Z/V6BcGJHf6eoo7YJ7Lclwq4gJEUrfWrBvLuqEimlczZmtL7O7v
	A+w6oSA1U0INhnSQeK+AF0Wha/eD8kzjdbzik84zl3/dVmFQ/wdYQT/B
X-Gm-Gg: AYBFou2y+gKKYQlj03c9s890+x6G9pvzWc3zWZfrfvWmm3Q0+lgPNIENPFjEEGyNBTM
	BEnJyhqYRnzyoueB/boqpp79KTmR3WyGYZlvmnU8zE8CbG6Vq1wO7047aaL/xrittaawjMy01K0
	JLyPyWmFLfFtDz6daulcum4mfR7ZTqHHhFoY2LdHHdw8brgkQwDO8+I01UBhik7GwQmIg6+KQB5
	HkuJztyJ1SZwoq/rsW+BMELWBCzfBw3cJwUU6rKlXTR0UHUeQ9PMU7t8ZC1ExdhZQSUjEb0s975
	PxBmEUn67iZ8i0Pq2V6HsQ/XIaVbhwrZBRYstyrdNzi0dcsZkHnZkmK1aHizyhlwLFuz44TW2F1
	qeMl/a9yU64yVU5jrcvfKv6txJF+hn5rGP819FldcKQvZyPyMXV9RcKBdAMmU69ziYsPdgWgCq9
	1eBscUzgNYTiksjSUhITCaL7ngHRdlJpJ4x3/sJtGFWcWfiPvdY3wZgg89Qhg12Jzo0O6WUTxMY
	f8WM6WWfXE57n84ccBiyhH+FOZGYILgTNNAsh+o48TZIRk4KaYbI7AAuNplsgo+QiVNoYj8ZwLR
	VkwjZXFD+GCyCNN+8/5rR3M/ajkF0lWgEVG77jLcEd6OVaQm9w==
X-Received: by 2002:a17:902:db08:b0:2ed:3be3:c648 with SMTP id d9443c01a7336-2ee0dd9f13emr26553385ad.22.1794574719245;
        Fri, 13 Nov 2026 04:58:39 -0800 (PST)
Received: from v4bel ([58.123.110.97])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ee0f7e4e47sm9461925ad.38.2026.11.13.04.58.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 04:58:38 -0800 (PST)
Date: Fri, 13 Nov 2026 21:58:32 +0900
From: Hyunwoo Kim <imv4bel@gmail.com>
To: Eric Dumazet <edumazet@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, David Ahern <dsahern@kernel.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Xin Long <lucien.xin@gmail.com>, Aaron Conole <aconole@redhat.com>,
	Eelco Chaudron <echaudro@redhat.com>,
	Ilya Maximets <i.maximets@ovn.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Justin Iurman <justin.iurman@gmail.com>,
	Linus =?iso-8859-1?Q?L=FCssing?= <linus.luessing@c0d3.blue>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Stefano Brivio <sbrivio@redhat.com>, netdev@vger.kernel.org,
	linux-sctp@vger.kernel.org, dev@openvswitch.org,
	stable@vger.kernel.org, imv4bel@gmail.com
Subject: Re: [PATCH net 1/5] ipv6: gro: limit the number of extension headers
Message-ID: <avcJeFcatcigXekZ@v4bel>
References: <20261113124625.4010206-1-edumazet@kernel.org>
 <20261113124625.4010206-2-edumazet@kernel.org>
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Post: <mailto:linux-sctp@vger.kernel.org>
List-Help: <mailto:linux-sctp+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sctp+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261113124625.4010206-2-edumazet@kernel.org>

On Fri, Nov 13, 2026 at 01:46:21PM +0100, Eric Dumazet wrote:
> Hyunwoo Kim reported that a long chain of IPv6 extension headers
> can push the transport header offset of a GRO packet beyond what
> the 16-bit skb->transport_header can store. The truncated offset
> is later used by gro_receive_network_flush() to locate the network
> header of a packet held in the GRO list, leading to an out-of-bounds
> read.
> 
> Since commit 3744b0964d52 ("ipv6: Implement limits on extension header
> parsing"), ip6_protocol_deliver_rcu() drops packets carrying more than
> IP6_MAX_EXT_HDRS_CNT extension headers, but ipv6_gro_pull_exthdrs()
> was left unbounded.
> 
> There is no point trying to aggregate packets that the stack is going
> to drop anyway if they are locally delivered. Apply the same limit in
> ipv6_gro_pull_exthdrs().
> 
> When the limit is hit, @proto still designates an extension header.
> Extension header offloads have no gro_receive() callback, so
> ipv6_gro_receive() takes its existing "goto out" path with flush set,
> and the packet is given to the normal receive path. Local delivery
> drops it with SKB_DROP_REASON_IPV6_TOO_MANY_EXTHDRS, while forwarded
> packets are simply not aggregated.
> 
> An extension header being at most 2048 bytes, this bounds a chain
> to 24576 bytes.
> 
> Note that offsets can still accumulate over nested encapsulations,
> so the places storing them should be hardened separately.
> 
> Fixes: 4b0ebbca3e16 ("net: gro: move L3 flush checks to tcp_gro_receive and udp_gro_receive_segment")
> Cc: stable@vger.kernel.org
> Reported-by: Hyunwoo Kim <imv4bel@gmail.com>
> Link: https://lore.kernel.org/netdev/avTTQNyvwPP6LtGx@v4bel/

Tested-by: Hyunwoo Kim <imv4bel@gmail.com>

> Signed-off-by: Eric Dumazet <edumazet@kernel.org>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: David Ahern <dsahern@kernel.org>
> Cc: Ido Schimmel <idosch@nvidia.com>
> ---
>  net/ipv6/ip6_offload.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/net/ipv6/ip6_offload.c b/net/ipv6/ip6_offload.c
> index 700f1861d8eb..01642900c0fa 100644
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
> +
>  		opth = skb_gro_header(skb, off + sizeof(*opth), off);
>  		if (unlikely(!opth))
>  			break;
> -- 
> 2.53.0
> 
