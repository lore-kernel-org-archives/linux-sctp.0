Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795751308;
	b=akuy51iLlOxxJyS68w+jS89+eN+8W6dxUnGV4jeSoUySJ3i1bE4NvWhX2WJRIsvCNxcE
	 Y7eWfPHkvsdp4iLss+RNREB3369boS6IbKz9kcd69KENig4+cul4CTcTUMhDm15LL4t5I
	 hYMrEhY+bC/lhNyET6B6lI/BwPVBuePoiZ4o2I1Cf4HyR42ReRc57LZXAwfCqtLYrNJOb
	 GQS2IK/bhqgdgKK4kxnr5cTOd0DDx40A/McQMT10EiiguMDYT22mGahPvH3LMTeTWIajF
	 L24IWuOlSzL9+SP59WHxprwiQqilcMG0XOREs4T8+DpUAkde+7/V4EB7uTSBMoqbhCA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795751308;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Endpoint-Received:X-Original-From:Reply-To;
	bh=hVnGOgVHf4ffCaE3/psaCUulg/6elzufetyMn+DOCxE=;
	b=gETcGKLy7aZl2fakIbmJJ0fd7+nAdN6ei5Kt7YiMhkEv1DabpOxf71lw8vg6DrqDMXIV
	 py6vU74jcT+hUqGkF46hk2dKZWF0J4VM64jr8PyN1timt4HkLq4L8lc21b70nTl8rEqu4
	 oclmHDTmX1NUAMArJQRBItcKizkSgKVBQQMmMt11i4Mt5yKMJBlNO3m5Nnfh3bSKLfjCw
	 OXY2Co/HpDtVYkj84x+cWpOyq7/81WoRn6mZY/z0pHegL0GioBGikpa8PDL4S1RuiKIfV
	 FiA8seMvPlAaHwTnhL41Ty2ZEDcTsXkcfS6kI/Q1G/ZN77UxncjLPvg7BPB0gPhLIlg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IxElr0Ul;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6294606A31C;
	Fri, 27 Nov 2026 03:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IxElr0Ul
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795751308;
	b=ymGj7eQ24UF8A4L4oOfpOTqEilj2ua2wIRj0rX71trUPOU9zY7A+Pglbk7y/rnxof5y1
	 Eac+udzmEY9Chy9vKj6B2+sKywqEkaH667TDAj+1GHzyrZc2xLNdSpKhgcAobxzxNqetY
	 D6gp6XzSSjWi5dgaD6FdAxf3W5ZkrpFuBAUVN3aMVODxXIAPbSKJ/9oXgwzkkCS21S4jf
	 Gb0TdHAdOwjmDMirRYUr69vwPx+AOqGXWGBN+KuKHreYfYWeN/UyP/oqtTHLCiQe1GfEr
	 7UNTFUMf+eznOd8JJkqSa727Jif3w2nb7vaf6DwZE412SNAnaTPvOh1vUlNWzyCFA6A==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795751308;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=hVnGOgVHf4ffCaE3/psaCUulg/6elzufetyMn+DOCxE=;
	b=X/UXBBUYEIl90g4mtNGF+/LEKv+kAaCh+gq55CklDf/ft3FibrRI9mvCd3040vl2TiBA
	 PdPrfX14NFMEPvgDAnL+50KCYxFSDOagwIfgrekHPJKbpVBTxenj8gPQeXqS7+EWONEPB
	 sV1XRsFBqE/GkE0uIMzRgu8mq0dfDc0os9wP8HPPSO48OEitukuu0x2VIqr9Vb7TvZZ/L
	 HkmPyogh0/Dtour5DbfLH++QwjMMFLx0+ha+1V2gBU111EIhJWVwIqXITtIxXWDkAYl9e
	 hf8HA/G3uJJpkiQQBD2/Ob7dlLg4XeLhEO06+K2CU+p3dDvfVFrvRsgjE5zGHouBthg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 1BDD31F00898;
	Fri, 27 Nov 2026 03:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795751308;
	bh=hVnGOgVHf4ffCaE3/psaCUulg/6elzufetyMn+DOCxE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=IxElr0UlkosT2Q/X6QjP63o7GSb3HrPu8sJxDHU+ihgP4JSqPwHuCYWfz08iJsdH/
	 i4h157I5t09EGX03wrungyoWaXTXkaXJfv8DZzL/ZjQkp8OJPovrNYakfD8nOuv5T2
	 Ci46jw6UFYGoJHTbGvE4A6k40gOWAlbmRRf3iucjBjT55Pun3+a785FHhUlkLu6tfJ
	 CDzL43IxTIWcHj4WijFtJ6CSgPCr+aJlwEw22m7OBLn9XCuksUdtsAnOpWC5B6mvoa
	 tdy50r0kAH0o0iNWB4X55MFqs0m4ze9nF7cU6AlUXhS/glxj13HZxmNfpUUafTiCvn
	 NXI2A3J5VD59Q==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id A2F3D4B541;
	Fri, 27 Nov 2026 03:48:27 +0000 (UTC)
From: Dickson Wu via B4 Relay <devnull+dickson.wu.certik.com@kernel.org>
Date: Fri, 27 Nov 2026 03:45:33 +0000
Subject: [PATCH 5.15.y 1/3] sctp: validate cached peer INIT chunk length in
 COOKIE_ECHO processing
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Post: <mailto:linux-sctp@vger.kernel.org>
List-Help: <mailto:linux-sctp+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sctp+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261127-so4-sctp-515-v1-1-bbee1a6af200@certik.com>
References: <20261127-so4-sctp-515-v1-0-bbee1a6af200@certik.com>
In-Reply-To: <20261127-so4-sctp-515-v1-0-bbee1a6af200@certik.com>
To: stable@vger.kernel.org
Cc: Xin Long <lucien.xin@gmail.com>, 
 Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, 
 linux-sctp@vger.kernel.org, netdev@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795751132; l=2266;
 i=dickson.wu@certik.com; s=dickson-b4; h=from:subject:message-id;
 bh=eEi0YwdkXypuwuA9pjLZfEn7yjYj5qgMN4seHuxYJzQ=;
 b=wN6ijL1szIwA+sIhPm8hqnHjlV160TSQa+7xQ921Wdn/BGFRx5pgVF53lM+m/hFMrhWaepx3X
 jWlpfOCODEfAzJaWoWoYNrj62rBtqJ9Xbaa43c/ktCbnDa2DTg8ifiI
X-Developer-Key: i=dickson.wu@certik.com; a=ed25519;
 pk=fxH7FS4FdojeJSGLJzgKdfO51Rvr4EW30yinj2mc1vg=
X-Endpoint-Received: by B4 Relay for dickson.wu@certik.com/dickson-b4 with
 auth_id=1647
X-Original-From: Dickson Wu <dickson.wu@certik.com>
Reply-To: dickson.wu@certik.com

From: Xin Long <lucien.xin@gmail.com>

commit 0861615c28de668669d748ef4eb913ea9262d13b upstream.

When a listening SCTP server processes a COOKIE_ECHO chunk, the cached
peer INIT chunk embedded after the cookie is parsed and its parameters
are later walked by sctp_process_init() using sctp_walk_params().

However, the chunk header length of this cached INIT chunk was not
validated against the remaining buffer in the COOKIE_ECHO payload. If
the length field is inflated, the parameter walk can run beyond the
actual received data, leading to out-of-bounds reads and potential
memory corruption during later parameter handling (e.g. STATE_COOKIE
processing and kmemdup() copies).

Add a bounds check in sctp_unpack_cookie() to ensure the cached INIT
chunk length does not exceed the available data in the COOKIE_ECHO
buffer before it is used.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Brian Geffon <bgeffon@google.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/eb60825fa22d6f9e663c7d4dbb69f397b5d34d42.1780362366.git.lucien.xin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ adapted to 5.15.y: read the cached INIT from peer_init[] ]
Signed-off-by: Dickson Wu <dickson.wu@certik.com>
---
The backport and the test runs were prepared with AI coding tools
(OpenAI Codex agents, with review by Claude). I went over the result
before signing off.

 net/sctp/sm_make_chunk.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index c15d62ad24754..b599dd2c15bd4 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -1757,6 +1757,7 @@ struct sctp_association *sctp_unpack_cookie(
 	struct sctp_signed_cookie *cookie;
 	struct sk_buff *skb = chunk->skb;
 	struct sctp_cookie *bear_cookie;
+	struct sctp_chunkhdr *ch;
 	__u8 *digest = ep->digest;
 	enum sctp_scope scope;
 	unsigned int len;
@@ -1787,6 +1788,10 @@ struct sctp_association *sctp_unpack_cookie(
 	cookie = chunk->subh.cookie_hdr;
 	bear_cookie = &cookie->c;
 
+	ch = (struct sctp_chunkhdr *)&bear_cookie->peer_init[0];
+	if (ntohs(ch->length) > len - fixed_size)
+		goto malformed;
+
 	if (!sctp_sk(ep->base.sk)->hmac)
 		goto no_hmac;
 

-- 
2.43.0


