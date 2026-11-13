Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794574005;
	b=I3PGvhuz9EQ2qpQZG1o+O51r0MOnv3LEJBnUgFMWHScLNWyYb324kgBg4HCh2WRPq6OS
	 SMsiig1ekdFVEHvP275M+0dw8WWpc5HicuLpfsjdv1sXS0GoPH3h3k9hpkKM4vjGnSCVy
	 MjLl8Mb3dMfGCSFtx+zXKncpldjBxetTPPMqXs43B6AmY9TpmwPGBjYCF56fnfS0v6GgN
	 5I9H7WuWmcXA1p+EKX9xRfHGz3sjdvmQP5Rl1zRLbKauzVPWU2QfaTpHeMH5zLbt9WogZ
	 Dyxv9GznBUTA5m4kUnzabBJveKCZawv2RbGtSnG+sW+IuobYRYdRxIF/oBof/2JwGhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794574005;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=PMR9qNu9agOtm/LtQpGKIgFR+fMSUYTNiBypgvjfLyg=;
	b=pEfFBHBdZ6YciCz5N74UnXiv+Sk8GArSvkJ2aANYM2Zy///2AxL7erB3/LEk8sEjWutZ
	 lTsOenl64xqee6IaMUE0ElMXd/OnTpv+zOfhvupspVexHcZ/pR/mMpb4UuSmHRzBHwgj9
	 cH2fr6p6Bxpo5qVARmL0glVV7a4egP1lhPdWEtiRTLwhUZES6yt0Gzo5lmssCbszELoIb
	 ruToMa6aiY9SSYvQpHVPtdFrDXvLXeVpKHjByf9sAq+wlyt+oarLzCMCqF9vVSZlEZek8
	 Ggvj1LjWHM+FgrR9H61blvN1Wo4MAuQHp1zendJdb6AtPYswmxV3RDdbPfpd4ylvaTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DtQCYMvg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5173606A327;
	Fri, 13 Nov 2026 12:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DtQCYMvg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C42551F000C4;
	Fri, 13 Nov 2026 12:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794574005;
	bh=PMR9qNu9agOtm/LtQpGKIgFR+fMSUYTNiBypgvjfLyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DtQCYMvgT5Gf/dzhflzuBbnS+OyLNtzdv6WGTsEZUvadEReHjajrxQBREC+vgL7y4
	 mnhvLDaYWz5Xv14dPxP/5K4YNsN0n8T9wKt98WBaBdS6iDHkKXt2Tst5sXXiM75vlL
	 YYtQMWNpypVG4YTywgYoQB2fXHge2HyETacC3PngmN6vxNkyNIdhcJuyFaTpqkFo69
	 g05ZkTN0h2OuJE6C6RgkhEdEQR8a7PQYPPZY/3SFQTjJf2+Peu8SVN0g4ugwiS+Ozm
	 tr++Gbn7KO+DGiGnxnT7MD4bmCAoiOHXUYHUjEbJOsRhOslx8US0aqs32m1Hwd6Kfg
	 K7jMJb9dy6e8A==
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
Subject: [PATCH net 2/5] ipv6: mcast: use skb_set_transport_header_careful() in ipv6_mc_check_exthdrs()
Date: Fri, 13 Nov 2026 13:46:22 +0100
Message-ID: <20261113124625.4010206-3-edumazet@kernel.org>
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

ipv6_mc_check_exthdrs() stores the offset returned by ipv6_skip_exthdr(),
which depends on the extension headers found in the packet. Should the
value be truncated, ipv6_mc_check_icmpv6() and ipv6_mc_check_mld_msg()
would then validate and parse the MLD message at the wrong place.

Since commit 3744b0964d52 ("ipv6: Implement limits on extension header
parsing") a single chain is bounded to IP6_MAX_EXT_HDRS_CNT headers
(24576 bytes), so this needs a large skb->data - skb->head on top of it,
for instance after several nested decapsulations, each of them possibly
pulling its own extension header chain. No reproducer was written,
this is hardening.

Use skb_set_transport_header_careful() and treat such a packet as
broken (-EINVAL).

Fixes: 9afd85c9e455 ("net: Export IGMP/MLD message validation code")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
---
 net/ipv6/mcast_snoop.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/mcast_snoop.c b/net/ipv6/mcast_snoop.c
index 04d5fcdfa6e0..7abf79815aa2 100644
--- a/net/ipv6/mcast_snoop.c
+++ b/net/ipv6/mcast_snoop.c
@@ -56,7 +56,8 @@ static int ipv6_mc_check_exthdrs(struct sk_buff *skb)
 	if (nexthdr != IPPROTO_ICMPV6)
 		return -ENOMSG;
 
-	skb_set_transport_header(skb, offset);
+	if (!skb_set_transport_header_careful(skb, offset))
+		return -EINVAL;
 
 	return 0;
 }
-- 
2.53.0

