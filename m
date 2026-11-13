Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794574022;
	b=2EF6HBk39VvEDA2mw/lBWy4y/nJm4fxLwxNWEjQBZG8+tWDJUyRlHl1EW5dzOIcgHg6x
	 3JlqVF9jzydcvbdWxWA+tr/i2W8lsjdqdi3I+cb58HOeiHESPZpUIIi1ocLSivyzWqx+8
	 QKnJpxUsDglI9LHfRTNbv7thqvHbm1+2zN1b9RDBfPVO/BpdL7Iv8DV4B08fwH4WkpDIA
	 wsgZEtveSTaB8tSPn+NtWVICRPXp5Y+IkJB4Mpr27b++EtEsauVjMWqJYzNVfzGk31Wgf
	 HIfk9nbQnRwq4HkmQGLMqt4tkbpMAVa6x4kjao4Ii9aL9gp3nJ9VZ53acMx7j5co4xA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794574022;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=2duuSZ8Rvfzqo0bXUMYpGryPT4QuFWSDj85f3yc5O5M=;
	b=YW1pO8orCepFlSK44e5I56oC8ib7dIBE6H1PNUtXRF+IAKn8OmwFHKfPjkEEoey2S4X2
	 AgMX8HZ6DemeCrtB7p3B6AbdBUJ6yhI/GRYnsNQyMmM6mP/MOYp+GZRL9dSYFNpcCAHj0
	 UIpuOK21/evG/Gd37sSkfuWt4xpd8jrBeys3lWPPyxlEhueOYF32mPmKb9ETwxws6w+Lv
	 sRKl8MJ42YFB3xJR3k9SLwL62JoBuwTeUCO9AkQV9JpKYKOyzSSkRerulkf6w3dYckRIk
	 mHEJLBmFaoiGMAwKelEK6OMc0IfLDXEmeFrpOtX8PZpwYWqcZLIRGbzJbU3H0nFRozQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Qt7XSlPj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E83C606A338;
	Fri, 13 Nov 2026 12:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Qt7XSlPj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4CC31F000C5;
	Fri, 13 Nov 2026 12:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794574022;
	bh=2duuSZ8Rvfzqo0bXUMYpGryPT4QuFWSDj85f3yc5O5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qt7XSlPjZlZkjeKFtCgpnobRkK7iHrP/7adBsUrpoIFS+sxCPAu1SJlz4MKEwLuum
	 Uird9sjk2TL6Xn8y757tzNrbYjfv/kjgFTYwhyXMFcqrE1Fc/Hclq5mmLFY2Dgn7H6
	 +i+q1sEJm47TpjBVeMYHu358iN2j80a/UnkLhw0UawssT4r2izVMAcXHheelgZOCth
	 HdbX4tAta+Y5KIZmNIsC6A+V73pLfmfdU2x1FqkwZO3M/LJ4amTQh4AHRAlIvuppuu
	 V3/i7Mlo/oeKYVtDJCMuWbVbuROvgspP7zB6e6WnZ0httKBbS5jeruvZB964eGXWPG
	 I69bHNKfQP54A==
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
Subject: [PATCH net 5/5] udp: use skb_set_transport_header_careful() in __udp6_lib_err_encap()
Date: Fri, 13 Nov 2026 13:46:25 +0100
Message-ID: <20261113124625.4010206-6-edumazet@kernel.org>
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

__udp6_lib_err_encap() stores @offset, computed by icmpv6_notify() from
the extension headers of the packet embedded in an ICMPv6 error. Should
the value be truncated, the tunnel encap_err_lookup() and err_handler()
callbacks would read the UDP header at the wrong place.

Since commit 3744b0964d52 ("ipv6: Implement limits on extension header
parsing") a single chain is bounded to IP6_MAX_EXT_HDRS_CNT headers
(24576 bytes), so this needs a large skb->data - skb->head on top of it,
for instance after several nested decapsulations, each of them possibly
pulling its own extension header chain, since @offset is relative to
the IPv6 header embedded in the ICMPv6 error. No reproducer was written,
this is hardening.

Use skb_set_transport_header_careful() and return an error if the
offset can not be stored, in which case udpv6_err() ignores the
ICMPv6 error. Do this before changing the network header, so that
nothing has to be restored on failure.

Fixes: a36e185e8c85 ("udp: Handle ICMP errors for tunnels with same destination port on both endpoints")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
---
 net/ipv6/udp.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 9dcefa162522..a6886a0432f9 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -651,12 +651,13 @@ static struct sock *__udp6_lib_err_encap(struct net *net,
 	network_offset = skb_network_offset(skb);
 	transport_offset = skb_transport_offset(skb);
 
+	/* Transport header needs to point to the UDP header */
+	if (unlikely(!skb_set_transport_header_careful(skb, offset)))
+		return ERR_PTR(-EINVAL);
+
 	/* Network header needs to point to the outer IPv6 header inside ICMP */
 	skb_reset_network_header(skb);
 
-	/* Transport header needs to point to the UDP header */
-	skb_set_transport_header(skb, offset);
-
 	if (sk) {
 		up = udp_sk(sk);
 
-- 
2.53.0

