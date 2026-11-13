Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794574011;
	b=rUrrbpgHeQMydNQYqNKHaPVyIyi4TU++gQ/NfrHcvD4Cuail7WbrtDIEkUZOK0/M0zwn
	 t9l8qLVmfz+0kA9IvBnSz/7edYSGsPJj5Soldi+uHon3C1M9tk4lq+2Y4Cn2y+sXct9m3
	 KoDuZGcXiNS3LFL22qMG2UngZwoLsYnd3nUWT0Jx1mvSL8jBD8G+arJyVMwy+/SlPc2yv
	 cnDswjsG3+AF1WhheJpe861krF/vvdm01s/bt3JIWDBVFCUKkEQs6vfBSnZbSU0mf+OCg
	 Tu/x3YemwXvq+St6nrxo17zHVJvhwehA9yMKuJFym3bC8EobLIFUd1k+Avm1jAbkyWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794574011;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=oS7xmVjY6kWuO0Q12FhJUyhxQDYW8Wln7euIXE0sOl0=;
	b=O1DFu0+R3YZL/PMiF9sjIzFyNt5s8FRZdz+TYxyUvU4iZcYyhfbz2PiiFS08E61o9FyS
	 PPksTvx44I7gp/VngJTQh8RdtZlAau2YKMLELyuaep0PsPdY2ezntLUqh+dWuMH1EPUgi
	 JdXM6zCu/ResqzgC9vTosVer3ITQkwR41GBdc9/CEk6BZm1CVk+Sz5vwAyN8r5lQxWw9J
	 wzGjBFizZhzYK/XarviHj50IUUtLTJU4pdmiXVRJanMaNgWFAs5mMJnkt+Ck6R7Hcprd9
	 i8SphH3yrRllbf0KbS6urjY4Tq6FgsAQahEqy78ao6Wj1x179O3eowFxI1FKjkyx9+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gVPHxfAR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F523606A327;
	Fri, 13 Nov 2026 12:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gVPHxfAR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69A941F000C4;
	Fri, 13 Nov 2026 12:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794574010;
	bh=oS7xmVjY6kWuO0Q12FhJUyhxQDYW8Wln7euIXE0sOl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gVPHxfARTOjg0dWOPwFK3LbnIPDayyRamA2NaqEE5PVpQOaqXqbZDVjJbIyeLv0BI
	 XHMKPj3WFZNScO/gK3C9K0hM8P5SdjxQmj0d7+UVqtjCNhXWsHQmOv8WBtF3TsRHl5
	 3avaITMk2TmxgPWghlVLQtB+fHnaDbxupVjDxvSeam+6DuvSrljGAsKrhpZ+Q4H3lE
	 we/C98WVo+IPFHTZ6wLYVeMSqINmsuECBN6l5BklXcJjNvQRDslxpEEXrP4W1XvdSR
	 XO7DIPAnmG9EFzPnwt1I1cDDDnWrRN1m9Kl7c/skaYOJDHlTNYXFEHwDGlzPf4VzvC
	 0Ro/U42sSXBHw==
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
Subject: [PATCH net 3/5] net: openvswitch: use skb_set_transport_header_careful() in parse_ipv6hdr()
Date: Fri, 13 Nov 2026 13:46:23 +0100
Message-ID: <20261113124625.4010206-4-edumazet@kernel.org>
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

skb->transport_header is a 16-bit offset from skb->head, and U16_MAX is
reserved as the "not set" value. skb_set_transport_header() silently
truncates an offset that does not fit.

parse_ipv6hdr() stores the payload offset found by ipv6_find_hdr(),
which depends on the extension headers found in the packet. Should the
value be truncated, key_extract_l3l4() would parse the L4 header at the
wrong place.

Since commit 3744b0964d52 ("ipv6: Implement limits on extension header
parsing") a single chain is bounded to IP6_MAX_EXT_HDRS_CNT headers
(24576 bytes), so this needs a large skb->data - skb->head on top of it,
for instance after several nested decapsulations, each of them possibly
pulling its own extension header chain. No reproducer was written,
this is hardening.

Use skb_set_transport_header_careful() and return -EPROTO if the offset
can not be stored. As for other ipv6_find_hdr() failures, the caller
then sets the transport header to the network header and does not
parse L4. While at it, use payload_ofs directly, since
nh_ofs + nh_len == payload_ofs.

Fixes: 1a37e412a022 ("net: Use 16bits for *_headers fields of struct skbuff")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
---
 net/openvswitch/flow.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/openvswitch/flow.c b/net/openvswitch/flow.c
index 3734416b518d..5fbeb0cca9dc 100644
--- a/net/openvswitch/flow.c
+++ b/net/openvswitch/flow.c
@@ -438,7 +438,8 @@ static int parse_ipv6hdr(struct sk_buff *skb, struct sw_flow_key *key)
 		return -EPROTO;
 
 	nh_len = payload_ofs - nh_ofs;
-	skb_set_transport_header(skb, nh_ofs + nh_len);
+	if (unlikely(!skb_set_transport_header_careful(skb, payload_ofs)))
+		return -EPROTO;
 	key->ip.proto = nexthdr;
 	return nh_len;
 }
-- 
2.53.0

