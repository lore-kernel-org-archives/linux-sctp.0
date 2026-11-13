Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794574016;
	b=nkyZQFfeksZ+BC+K2WWxo9m0kH7NRlCr7P+JnWstrXqAIneB09lMRnCyhsp7Byg3rR30
	 BZXhlIWTtS+uiqg1sx3rkZPM6SSj/K0nqkvmYZJSVuav5iVlQkw40yGJumW0TvFMjEniT
	 hNJGKkuxkwWU1lpoCFS83fZFz6mLXHSmlEdN9gXMQlbn+l3leFBQuRRY4jvuk7P9yYVFU
	 r+/FsIljzygXPW5m3W1bwBfKawtZ03Aw8OPxBjq3kGC/lIHlzPGwYAZUOuhzZZFII3J0Z
	 8XHD+uUYvA7VXo+wM5JhfIzqncYLxN9alL821SVwmUZwJ9ykoK8b9YUCtu5EWRFCW/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794574016;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=6siMVFoM0QwN53FycGkAXwCGQpNcuJOjN81/NP+qoYM=;
	b=WfDiwjw8Nf0Kqvwy5VtWm5OxOtq4AbM9tUAJR4RRFghENTn+8zB/26jHRt0nh0xTCC8d
	 qXryoJAXkI4ujJILX6MhWs8LUTfY7ONrC4ghYQY309N96GxsiWQXa51Ak4P2WvknW9sxU
	 HNYYL90xheMgi7PJp2wsSuYNDc4TYrM1Rc+kt24CH/5MdgUKKyMdoISZKjfdWoqZd7kNz
	 PfGM1HpElzw2VuGjRjguQXqMIYTnR8cT/2znKCBxlCampO+9Hs8/TXn4EzRyGHCP8HdOM
	 +eYO4N5wWSy0f1diQouWNPbbzVWGD43FkHGogPG90q9FxmK4As6BvemosanBACJUWMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZtFcpAiO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAE4B606A32E;
	Fri, 13 Nov 2026 12:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZtFcpAiO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF7CA1F000C7;
	Fri, 13 Nov 2026 12:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794574016;
	bh=6siMVFoM0QwN53FycGkAXwCGQpNcuJOjN81/NP+qoYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZtFcpAiOvVo7RLTwsesQNrbEjTsV6Mnmg8vIzBWxgpP54DKqAHuyqw7YRBgPP6Qfy
	 OAEVUQtEw7xq+mHvDNNgcK2rseKeoDENeQ/pNXxujq3U+1zDKslhGAOabHZ1eXX737
	 beKep3s0fmOfVI2pO/g2UsKO514It/D7kpYZBCBqbTNS6jM4G3xvWHpyWT5h+Wb3/S
	 q6g4tLcRyl+pIAEAQAYK0Y4roBk7xXyySnFtvBclSua0WZhnzgqkDiDKpp8VoIzHa+
	 BO+oVYwfKdMufenDgms6c6mAGIk6dIgg10V/fdz7RxIX8Tl17hJlcixNGRsNkK54Vz
	 xCF9xaJm+573g==
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
Subject: [PATCH net 4/5] sctp: use skb_set_transport_header_careful() in sctp_v6_err()
Date: Fri, 13 Nov 2026 13:46:24 +0100
Message-ID: <20261113124625.4010206-5-edumazet@kernel.org>
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

sctp_v6_err() stores @offset, computed by icmpv6_notify() from the
extension headers of the packet embedded in an ICMPv6 error. Should
the value be truncated, sctp_err_lookup() would read the SCTP header
at the wrong place.

Since commit 3744b0964d52 ("ipv6: Implement limits on extension header
parsing") a single chain is bounded to IP6_MAX_EXT_HDRS_CNT headers
(24576 bytes), so this needs a large skb->data - skb->head on top of it,
for instance after several nested decapsulations, each of them possibly
pulling its own extension header chain, since @offset is relative to
the IPv6 header embedded in the ICMPv6 error. No reproducer was written,
this is hardening.

Use skb_set_transport_header_careful() and ignore the ICMPv6 error if
the offset can not be stored. Do this before changing the network
header, so that nothing has to be restored on failure.

Fixes: 1a37e412a022 ("net: Use 16bits for *_headers fields of struct skbuff")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
---
 net/sctp/ipv6.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
index 97390569c4bd..ad5c951efdf0 100644
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -170,8 +170,11 @@ static int sctp_v6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 	/* Fix up skb to look at the embedded net header. */
 	saveip	 = skb->network_header;
 	savesctp = skb->transport_header;
+	if (unlikely(!skb_set_transport_header_careful(skb, offset))) {
+		__ICMP6_INC_STATS(net, __in6_dev_get(skb->dev), ICMP6_MIB_INERRORS);
+		return -EINVAL;
+	}
 	skb_reset_network_header(skb);
-	skb_set_transport_header(skb, offset);
 	sk = sctp_err_lookup(net, AF_INET6, skb, sctp_hdr(skb), &asoc, &transport);
 	/* Put back, the original pointers. */
 	skb->network_header   = saveip;
-- 
2.53.0

