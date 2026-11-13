Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794573999;
	b=XaqDAIpDpa8isxXINxQ4q/mswAQkvfGanXogLzW4KGYERa4HXs+9B67JHTe4Bn5CtJC2
	 F/SsPwEW2nyxACWKKN7S1S4v+ASzn0MPTaZXP8XRqTyPdNritphwxMj0P0hQcO3V2+pwo
	 qaYfagBh2RU1XSVEXQHKdADmEz2i2uYz7Oi9jlV4ZLp6J0ACx10jG6Xf6A5OHrvkhqKS9
	 PUf1BY9Ir5JuB5eYN482R1Yrn/57wA+IvEkN94vy2juBTi1rRbQKjDhFANqMIOox6KMeL
	 YaSPVAPX5uZZTMRkAVRszwCBoRyTCI611xsfGxgxgaNtAkGAOxjJ7vKTc6LdZG1Vl1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794573999;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=A0GM3PZVBKJhqopMld6/zhSyIM92Ig9ChbL4osc7uig=;
	b=VBivGkKVot/SVoWSjYlqjGjkwCs4PQOWn6/4ru3xUc75Qlj0WhkZP5ANYaSUI9o93gRE
	 Lopn7cIUPgMM6aRQwntCuJObItwoVrwDvQfeNSu3ZoxJjh6VxCequQYBR02Oi6GBHPaHe
	 nCq8r4q9fQpIkyGHDF0A1c0vakKQowhK/qFWNoBxIOGD7dP9edo6HRnuK0Mrwyn1O7zY3
	 aCk8IayXnICxPGyKNELRRlr7Z0DDqSoiDH1ejfd5GnxU2VBMDiqgskfnwS7+lA/okkdLO
	 4TkFDoevNg7OyvJP8de7anCqUP+RAWt6MnOplacmL7eqTGSIfL8YcLWY9TYQVIGsVUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gVJsmRfg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD946606A323;
	Fri, 13 Nov 2026 12:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gVJsmRfg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B739A1F000C4;
	Fri, 13 Nov 2026 12:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794573999;
	bh=A0GM3PZVBKJhqopMld6/zhSyIM92Ig9ChbL4osc7uig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gVJsmRfgDPDd9yBBxPqKik+KJ7Rv480wF+yiB7D0miEIh1HjnZOkNvcV886ui9vFf
	 46Vt+LnGKd3x7jgHL/xA3CZtZwzMqHQkhBdicR0y0smKMIw43CjO6lExhJSM4xp+DG
	 pOd8J8z2jHLlSo9twnx43olUyK2z/Y9Q5gJF9PHVvrqR+c7VZrZo8IzcCzC/sUUXtv
	 2UvcHb4LGgK3u/LouzsPpJWc/0DsKmVb/6bzrj7Cjp96rCUaauhSHYore8cn3bJbeF
	 INDGEnJnbLk0xQIgXRpYCARjyALhwhH9/WSP31USxd/kKa2Xcwp6siB/jSR9tYLz+7
	 TqtdZGpKxg3nQ==
From: Eric Dumazet <edumazet@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: Simon Horman <horms@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Aaron Conole <aconole@redhat.com>,
	Eelco Chaudron <echaudro@redhat.com>,
	Ilya Maximets <i.maximets@ovn.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Justin Iurman <justin.iurman@gmail.com>,
	=?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Stefano Brivio <sbrivio@redhat.com>,
	Hyunwoo Kim <imv4bel@gmail.com>,
	netdev@vger.kernel.org,
	linux-sctp@vger.kernel.org,
	dev@openvswitch.org,
	Eric Dumazet <edumazet@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH net 1/5] ipv6: gro: limit the number of extension headers
Date: Fri, 13 Nov 2026 13:46:21 +0100
Message-ID: <20261113124625.4010206-2-edumazet@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261113124625.4010206-1-edumazet@kernel.org>
References: <20261113124625.4010206-1-edumazet@kernel.org>
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Post: <mailto:linux-sctp@vger.kernel.org>
List-Help: <mailto:linux-sctp+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sctp+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hyunwoo Kim reported that a long chain of IPv6 extension headers
can push the transport header offset of a GRO packet beyond what
the 16-bit skb->transport_header can store. The truncated offset
is later used by gro_receive_network_flush() to locate the network
header of a packet held in the GRO list, leading to an out-of-bounds
read.

Since commit 3744b0964d52 ("ipv6: Implement limits on extension header
parsing"), ip6_protocol_deliver_rcu() drops packets carrying more than
IP6_MAX_EXT_HDRS_CNT extension headers, but ipv6_gro_pull_exthdrs()
was left unbounded.

There is no point trying to aggregate packets that the stack is going
to drop anyway if they are locally delivered. Apply the same limit in
ipv6_gro_pull_exthdrs().

When the limit is hit, @proto still designates an extension header.
Extension header offloads have no gro_receive() callback, so
ipv6_gro_receive() takes its existing "goto out" path with flush set,
and the packet is given to the normal receive path. Local delivery
drops it with SKB_DROP_REASON_IPV6_TOO_MANY_EXTHDRS, while forwarded
packets are simply not aggregated.

An extension header being at most 2048 bytes, this bounds a chain
to 24576 bytes.

Note that offsets can still accumulate over nested encapsulations,
so the places storing them should be hardened separately.

Fixes: 4b0ebbca3e16 ("net: gro: move L3 flush checks to tcp_gro_receive and udp_gro_receive_segment")
Cc: stable@vger.kernel.org
Reported-by: Hyunwoo Kim <imv4bel@gmail.com>
Link: https://lore.kernel.org/netdev/avTTQNyvwPP6LtGx@v4bel/
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: David Ahern <dsahern@kernel.org>
Cc: Ido Schimmel <idosch@nvidia.com>
---
 net/ipv6/ip6_offload.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/ipv6/ip6_offload.c b/net/ipv6/ip6_offload.c
index 700f1861d8eb..01642900c0fa 100644
--- a/net/ipv6/ip6_offload.c
+++ b/net/ipv6/ip6_offload.c
@@ -26,6 +26,7 @@ static int ipv6_gro_pull_exthdrs(struct sk_buff *skb, int off, int proto)
 {
 	const struct net_offload *ops = NULL;
 	struct ipv6_opt_hdr *opth;
+	int exthdr_cnt = 0;
 
 	for (;;) {
 		int len;
@@ -38,6 +39,13 @@ static int ipv6_gro_pull_exthdrs(struct sk_buff *skb, int off, int proto)
 		if (!(ops->flags & INET6_PROTO_GSO_EXTHDR))
 			break;
 
+		/* Same limit as ip6_protocol_deliver_rcu().
+		 * @proto is left pointing to an extension header,
+		 * so that the caller does not aggregate this packet.
+		 */
+		if (unlikely(exthdr_cnt++ >= IP6_MAX_EXT_HDRS_CNT))
+			break;
+
 		opth = skb_gro_header(skb, off + sizeof(*opth), off);
 		if (unlikely(!opth))
 			break;
-- 
2.53.0

