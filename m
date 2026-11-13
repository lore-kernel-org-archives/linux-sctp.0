Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794573994;
	b=PPvDtWKJOd/JCvmNknK/Ig9eeaBXy+UbIFhunUo9o+KlMxOJW5fk0H3E9BkjE1mV2eyt
	 CetSI9EZXInAewTYJ7dx8DyaT9zfdIQgUrtX1PFBi2xbCDC5Y25VtcC7SFlUgBqlo3ULl
	 w+I3RRsJRRjw0B55TiHy2jxWKiaoXeVNv3x46ESubfg7TytrD8f6Ge1Zbis5sWjgbdkfx
	 mGF4BnSXM8AD4il+6rejn75uzAgH2m7F46/u6YRajKiYe+dIqbY8bwUSxLA7GfOlTZKWj
	 AAWw0wV1gvg/8dmjQYhKVWFXoyQzElKTpAkLbi9vKtkUBE46k6bV+MRUTxMOmbWD2oA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794573994;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=X1n982sTQrbnQ6IoKJRrZJFIdmMhg7SCn+FpAoU2xiI=;
	b=vWEnTYz3YY8cs/s60Fc6aEaqJnfHVLHygZIWn+oJKNfy9sV7SF+Sz4Vg0uLz4SGTpy/R
	 h4lIb93FBx1v6HmnjAhe8yMbJ+emvXeTIcmxY+PZXaCFQ+UXqcFpdjMMuK+THIXLUK+LZ
	 8LucnQhj0oM7NBlpAsrhx6YdlK6DZZpY1zmTyxT+P9gzTb7N41vztFifJQpPEShs98Ktq
	 lDL9Nb+JGSuwF74Dpck7iN5FBmDTTWE864tAFZCt7YFJmiE905eNdOxo2kqQyilJPqXrD
	 WoT0hhh/2Ee9lgH2juKk/Qh9FxxO6U/JIHzjrRNWrg3EVhwhCjBnZVnLiMAFF78n7og==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bqJyCjLB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E99A3606A32D;
	Fri, 13 Nov 2026 12:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bqJyCjLB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA0601F000C5;
	Fri, 13 Nov 2026 12:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794573993;
	bh=X1n982sTQrbnQ6IoKJRrZJFIdmMhg7SCn+FpAoU2xiI=;
	h=From:To:Cc:Subject:Date;
	b=bqJyCjLBtehN6wA6bx4tnGTNkdRCi/nDHAtBfsT1mAhE6txSC77vEyHyWO29ImVH6
	 E/igpMxBHc6HX1qKZ8ExVIbqRYlpE0RtYJlwenZEzf7uuut5V4gLlH2snK7f4G5Ag7
	 4Mn+pj9NVuH9mw6J+LcNrYxto1rK+8vWC8Cv6SOknoVAMxNpm9uX4K5URJ+g2KCFbj
	 zOWtvvPEiIRtN/Dv4wjkZTXgl1Hn/M698fAbrcCJlHA+VXYsNlCPcaLJvzJBPoNB1o
	 k3t2FSu46dlTLv42CyWk9rx/1VkJyUAwCaOYh+vlzplKv11DLrF3EjRDFGb59E5pz1
	 1pDKt9dbR2J1A==
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
	Eric Dumazet <edumazet@kernel.org>
Subject: [PATCH net 0/5] net: avoid truncated transport header offsets
Date: Fri, 13 Nov 2026 13:46:20 +0100
Message-ID: <20261113124625.4010206-1-edumazet@kernel.org>
X-Mailer: git-send-email 2.53.0
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

skb->transport_header is a 16-bit offset from skb->head, and U16_MAX
is reserved as the "not set" value. skb_set_transport_header() silently
truncates an offset that does not fit.

The first patch addresses the report from Hyunwoo Kim, by applying
the IP6_MAX_EXT_HDRS_CNT limit to ipv6_gro_pull_exthdrs().

The four following patches convert places storing an offset derived
from an IPv6 extension header walk to skb_set_transport_header_careful().
A single chain being bounded to 24576 bytes, these need a large
skb->data - skb->head to overflow, for instance after nested
decapsulations. They are hardening, no reproducer was written.

The same change for nf_ct_frag6_gather() is sent separately to
the netfilter tree.

Eric Dumazet (5):
  ipv6: gro: limit the number of extension headers
  ipv6: mcast: use skb_set_transport_header_careful() in
    ipv6_mc_check_exthdrs()
  net: openvswitch: use skb_set_transport_header_careful() in
    parse_ipv6hdr()
  sctp: use skb_set_transport_header_careful() in sctp_v6_err()
  udp: use skb_set_transport_header_careful() in __udp6_lib_err_encap()

 net/ipv6/ip6_offload.c | 8 ++++++++
 net/ipv6/mcast_snoop.c | 3 ++-
 net/ipv6/udp.c         | 7 ++++---
 net/openvswitch/flow.c | 3 ++-
 net/sctp/ipv6.c        | 5 ++++-
 5 files changed, 20 insertions(+), 6 deletions(-)

-- 
2.53.0

