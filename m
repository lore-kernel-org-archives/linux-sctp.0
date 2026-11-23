Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795394938;
	b=WTAEYVsrnTiMKU0ZBx6rOERkUrL1FD4fBvLsdIvCWBUr8SpflY3pFKnsCaiIEA9c1jcb
	 cYSUUGRdWsmUkfxqv6Yy4lj1HdktEKz908tLrTD6rN9IVSTdQZfHBgq5vUiUZraU/RA0x
	 PhQ0/+HxoRUsfPXbfkCURLfgMrhkQwayOc01QyGT5Xvo+QtKBKaNSW1ROmdVDsMwZYis2
	 w2B9zXNHSmtMjskyHSDCeb5goh1Orw6vVu/LgTpqFzBu0J2BQn8KQfioK0jWaipOxrVR0
	 LeKItWUwc7e2B8tjO9f0xjL81w+OcEh5KoFpo2rJ7yQNDLY8KjuUYokCR85bR/lORCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795394938;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=XkB1/D3AgiE/513YaWxpzlpuC5tZ2ZyAh+6bQUBtanI=;
	b=x2i69W+DcQ1pcngqfwjrjbtJC5zOFfz2zNwDNp9BpvJNDr08ltP7N5TgRFggFbjx6HtE
	 IvLt5Z6QtYxqXU30Lr/HLhyCNlm2h4XS/97LxkqW9QhgkTy8OQ/9DBpaI29KmcqVAXAoG
	 w7LaaD+XZaHWYHhsRjGU/uburfSYE9W+T8TIKrYk+GpAQfR66ACrviFEgQdrgeKxpxT5g
	 j3q7NY7E6TUqk10Ca1Txc/1rNt334RR7oSCdtzdttdVGfNr2yFDLntAcneq/3HcTzVXHn
	 LulHf29kP14BV1OB+KFEjxcljFq+mbzGFWdApirmjqZvb22VCMDnRgtQDogXM4kUVCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Yv4KZfCQ;
	arc=none smtp.remote-ip=209.85.219.41
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60934606A31D
	for <linux-sctp@vger.kernel.org>; Mon, 23 Nov 2026 00:48:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 60934606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Yv4KZfCQ
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-9213fddb596so32749066d6.2
        for <linux-sctp@vger.kernel.org>; Sun, 22 Nov 2026 16:48:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795394937; x=1795999737; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=XkB1/D3AgiE/513YaWxpzlpuC5tZ2ZyAh+6bQUBtanI=;
        b=Yv4KZfCQcO/Uy3EECBrqPMwu7OhIBLjYRV+wwYftbhQybdJ81AlyvFmnYfeMLgi4ai
         fWw/OAbJiRVllxuBWeqkpNywfiGahml9PxA5nzIhP6VXXB8wzByW7ddbm0Eu7YGsIqdw
         Sr9ndePx+kj+L1M3g8dbC07LlK5zpu4Gbd4FfH+nOFbiIjLB2lIf5MnZw7PftSlmqdkK
         4HSdH5vDRLBsTwL/vSNx04Klgz7r20BhopWwcD+L7Ayt7mmfMruh1BSY3P7KteCc7UIa
         09XhNh9o+GqjiDB74SXB5uC99wIhdo7Bgf44XYBxP6Vf9IaxzgJaJ6ogqpDwulDkwxUI
         ztmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795394937; x=1795999737;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XkB1/D3AgiE/513YaWxpzlpuC5tZ2ZyAh+6bQUBtanI=;
        b=1g5P3K5KYQsYHNnNPu4/Cti9y7ekD1pBGPwk4snTukBZ4X8HW8/AtOhIdylnFtBrx4
         GB7PKHlLAG63VOPgOIDTUThWSN/TvzdWhTYw0B19/04gwzwizW2NWG2WI0Qga0IwI4wh
         iH4Gsj8mXqCOC+cki1ZgmqoZTPTRPQoIVCbHxkIm5vdMt7oQc6ubWNobSVlTdzTIZRIS
         zoGZidGLolNCWzQPH4x5NBnvdt49x5SZw71IGSg/8OzgGr5eoG4nmIizSVavKWXq5vK7
         NEZSPqdMtXghZl9it7EABsJ47xdrPkoak7xutFUr/DLDswAsJExZ0fdQ2SSBxcG0BSwr
         G9hg==
X-Forwarded-Encrypted: i=1; AL+hErGAapPTiYWPiVXmtvXghfwe/8Olfnr8+8xLP6ud/Uh9SlG8jaTUAXmaWB0SMupoUISjyqWdq1ga/w89@vger.kernel.org
X-Gm-Message-State: APuU4Z8Slbth7JVGJ56vY6foWyq4a9eqyq8p4+L7YmXL7JIkPkkEqu6a
	+Mo8BTxXhOqI5vEbHb5cOKSZ+Am4yAYCbwiQrktLtPUAOTwClhk60NzPwzSGCjwX
X-Gm-Gg: AZFdTZdlk1PoFTBSTW5dsvCStLNyLA6vDAY0gyDRE34v/Yqwvt65TFlcrpHGjtaKOy6
	uuILsmOsu+GLs0QfOhm6luaQvak2wacsu5L5j4cCGUeNTa2+y73zkVE0aN4nJ7HEwwZm7fsvnbY
	UpYaoh5RZKoFv2nCjjEZ8S+6za2WciypfTFvXuTSoA8U5iY650sskk81TIQXgvCNebfQ8VTkFL1
	42WoiyWpo4sZvEQUUfo7nOH6z3Q2goJb1MB/ZchHTYKtbjze8ynS6g84vhtsrzalQXPiL9RB1pC
	tRthCybY7cJEnKYh5fyNaC+6wFQq8REzVfOb467m9d33i6NfdEnuX2/QFl+9xVZJzvTVFoLi5vK
	XbbDoaWq+19FNMFcoDVjnMLuairjDwmpIpUFbdMcTmngn4ty6CX94qOZNakn/u6bBGlO31n+SXU
	k0yBhIaWQI5zoioD/iP699paqazLL82PSw/wdKLe9gf8wNxfXqwFqFAcRR5ySDukRJ+9Rk3huuS
	cFxd2eElakL41ajLFqEb3sgHW6btjvIHVlqxamvDlMAYDv5O+cOY6KjTcWCN2CT4PIhO1HJbWXq
	qtA8EKomC8rfvlgDHt1R486nxRbiVinrrD+G0pkhvx6KJKvkkvOl9a7T0iOMKn8pNXsHIeEVeBv
	RP/8zX/JaJzX154YAMYl4eM5rwM6QhtdgzQIWUITJtqu1l5rSI/xU2/fmvVr7T6zG9DIpWp4Z36
	TnvSoRZ3hSKf0u+eQM
X-Received: by 2002:a05:6214:458b:b0:91e:cf4d:f868 with SMTP id 6a1803df08f44-92134a990c3mr185930986d6.22.1795394937359;
        Sun, 22 Nov 2026 16:48:57 -0800 (PST)
Received: from wsfd-netdev58.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-921349b0827sm90841726d6.8.2026.11.22.16.48.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2026 16:48:56 -0800 (PST)
From: Xin Long <lucien.xin@gmail.com>
To: network dev <netdev@vger.kernel.org>,
	linux-sctp@vger.kernel.org
Cc: davem@davemloft.net,
	kuba@kernel.org,
	Eric Dumazet <edumazet@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: [PATCH net-next] sctp: diag: set sin6_scope_id for IPv6 link-local lookup addresses
Date: Sun, 22 Nov 2026 19:48:56 -0500
Message-ID: <409da01d058fee776791de001ffd222069f06090.1795394936.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.47.1
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

As gomaja noticed, sctp_diag_dump_one() builds IPv6 lookup addresses on the
stack but never sets sin6_scope_id. For link-local addresses,
__sctp_v6_cmp_addr() compares scope ids, so an exact SOCK_DIAG_BY_FAMILY
query can only match a link-local association when the caller's idiag_if is
propagated into the lookup addresses.

Set sin6_scope_id from req->id.idiag_if on both laddr and paddr before the
lookup, so that exact queries for IPv6 link-local associations can succeed
when the correct interface index is supplied.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/diag.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/sctp/diag.c b/net/sctp/diag.c
index c2a0de2adf6f..dc199e3e96b1 100644
--- a/net/sctp/diag.c
+++ b/net/sctp/diag.c
@@ -455,11 +455,13 @@ static int sctp_diag_dump_one(struct netlink_callback *cb,
 		memcpy(&laddr.v6.sin6_addr, req->id.idiag_src,
 		       sizeof(laddr.v6.sin6_addr));
 		laddr.v6.sin6_family = AF_INET6;
+		laddr.v6.sin6_scope_id = req->id.idiag_if;
 
 		paddr.v6.sin6_port = req->id.idiag_dport;
 		memcpy(&paddr.v6.sin6_addr, req->id.idiag_dst,
 		       sizeof(paddr.v6.sin6_addr));
 		paddr.v6.sin6_family = AF_INET6;
+		paddr.v6.sin6_scope_id = req->id.idiag_if;
 	}
 
 	return sctp_transport_lookup_process(sctp_sock_dump_one,
-- 
2.47.1

