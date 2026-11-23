Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.175
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795422390;
	b=O1DViCT66Yc0gHSbkV1cb8NucPJ6OQqHsZPPioyGx+7PzKWB5SxRcs2V0kxOgvdS+0k6
	 HmZ9yQy1TocX2HXf32DCGCTg43wfa63Hvp768X/+WQjxQl8h3vwoCf/IAGESdcOmpOmAx
	 q9Xh9aGpCMZ4+Rb47c+LwXHtvs3+9TlmJZ6+JlH9dbnPoRMAbR3JyYB40B3i6tOZbEcWB
	 jDANT0Nu2NxC/DPyrV45EZcWDEF4JQe1bYCOgOaM28W4DnTfhokaizWCwH0KxB0N2hN4b
	 6PZ5tUzJJq6EttrpfRAzLBYdtgR0b3P56uxhf5NgEmOhhY81XsMbdZoWl2wAjQC9BIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795422390;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:MIME-Version:
	 Content-Transfer-Encoding;
	bh=7udVJwhYhiZkorajfCLaajaBwSVEsWpW464G07q84Aw=;
	b=3mL3AzuKCIpR8+um/AUFV4ZPVJGssKYoGLq/blCJXgm3dZVTnjBJXRt8IXtPn+4itrOQ
	 NsXL4XM6cX9IJWZJQxt+fBXxSA1r/YUcBT54cr7PHDmxiiPJIKQz+p4b3ZYze7sHXblq7
	 hcielP7BOJDdbYwFe2DYB2RsCc1t0ampC689jNkvvw5TGe4rDwxR7KNKiw2tOKwiHv/TT
	 HXQBtEvUpROEhwO6RdIfPFlqNEdVUtLFt7G9B9PfOhGadJJpLtg2+l0Yy/ipzUTDV888V
	 n7k/eSq+qbICMIdK6/Zep9hjvf6mY6qi8ik9Hlt6cyY62x1vJFN/Uj2aFVI1qPrvxVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=XmXsRc34;
	arc=none smtp.remote-ip=209.85.210.175
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 144EF606A31F
	for <linux-sctp@vger.kernel.org>; Mon, 23 Nov 2026 08:26:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 144EF606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=XmXsRc34
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-8ca6a12efd9so479870b3a.1
        for <linux-sctp@vger.kernel.org>; Mon, 23 Nov 2026 00:26:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795422389; x=1796027189; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=7udVJwhYhiZkorajfCLaajaBwSVEsWpW464G07q84Aw=;
        b=XmXsRc34f6Bc9KBidlioBOHmKWsw+Xk2ORPllNKtQKuczraQZvtgcDIOAWsb9rmLeE
         lu0GGK34HkSZybONTHg9EJhyUbbNRDnz2BZIWVconcEUgmi3+hPUca6r1e+N9wElwhkf
         k5Kw4YIaJyK/W+JK5NxJBiz0DY8Go0OVsuzeBgXL6zVh5CvNeFN9DG8r05B5BUne+xmf
         lthZnzKlWaYezCoEFXl0siBMcgaLGk0AZ9TfnirLEsEijy42kfgHC93ip9jp734y3aOE
         8KwL4AO7vbhaZUF8TZnI0Rp4plIRVnHuIZVWt6U82uki5+Nov9xTDA0tDRxxVK7fS5Mu
         Thjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795422389; x=1796027189;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7udVJwhYhiZkorajfCLaajaBwSVEsWpW464G07q84Aw=;
        b=e5F6VVTf3IRg99OAk4sohPg6umg9RK965yN/23AhrRlB/V/5ycOuMyBS1vXY9N2yAQ
         FJWGKVHHlQZXY84qmCai3k5zR/DrF5VJ7X1Zf3iOQ9ZiBUheuDL+e6CeXhAUn5s+ogDo
         QDN8+NZYM7FzGhzA0ifgQ0Mf2MZv/FThRvbTi8I1Uwj7hZ1VMWdSM2gbZXHzuA9IVO3G
         ilNny+wXSkFmIuFl71iUhFyXoyLwml+qujVxXnjhaZQMgXrUwLR5Cq9EzPH8zLKHfXUk
         8WIv1LOKzqmAJJw2QcVd8T0gEZ36Xpw18iEYrSZE4M1t+/AJkPwidKDuT21b+vObbIRn
         ZaIQ==
X-Forwarded-Encrypted: i=1; AL+hErHIS/0snLcTrmT0DhcaslRruyseIiZAY9CSgBJ1mPTfy3w2QA6Xp/jkZSr8Rcw2Z1LRKRyq9HsPZRdh@vger.kernel.org
X-Gm-Message-State: APuU4Z9Fnsp3vBssgW5vC7Rm2gbna8M8HL0W/fM7deQBPiVdJAc3cbEy
	bDSF1nlFC6Slif9/5+R79JhzwLtQBW3DfxXHuLUpeozjPMNbUQ27hSj1LuRlPKXr
X-Gm-Gg: AZFdTZeKyzhSgnvLYFdYZ2VEehr3x8/yKWB/HmuW33wEKXhEugTrgVbjXRdqr6M/GoL
	4bar2bGvwOzLHoYfvnqZ7woOEYDZEVo/pVQ1zij0dOhy4noUsPdBOUe452oWIMpHQWO5wrJ5CRm
	cCVwh2YbLvqMtFxObDT8p6ywsjWsKlBwJhBi3PhRWPd4Pfxzyj+AIasuZtcp8p/Ac3dPucsfk8J
	8PGZOuGPnS9jlnxu5ZvLH3BFe7ZkyvvgTV9JFO1MVFBEpAqZH7Mz+k1VvzKC+75KhORDsr/6xCZ
	wflOweaUAQNo/w707L1/tSVjPqhxgdu2v0+C2drqBxs6NnTAHtK0IQbtXVD5VvN68r9un2HGWpw
	o3QV0PNjfyZiwls0hPy+rp0Wby3n4ke0grUCyBF/OqQ27ZVbvOQqNoJ053k57m4fpyfzOKXEIpX
	CdUeaiO41qdUU6/hNYJ9prHcpmca9xvE02TeUW7vexCPsTZWRU9wMJ2ghSyb8mLzVEz4MBBl1MI
	aZA97gJ5JMXuxJopFk+4oZ4gb862PdZzaocXv3ukNOWrTC4dEsPGvnpT2VF0gdnQB7iWI5AGp78
	DKICGPqsbrUdge929JqkNY0yZwLn38OqbFxIOHH8Kv2vh9jRe9FFucjOMpNwLRnbKVI=
X-Received: by 2002:a05:6a00:2e15:b0:89f:ed3b:df97 with SMTP id d2e1a72fcca58-8c87d5169bdmr8978938b3a.51.1795422389280;
        Mon, 23 Nov 2026 00:26:29 -0800 (PST)
Received: from d20be28ee783.tail196be.ts.net (vldb.skku.ac.kr. [115.145.173.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c87343f571sm4953714b3a.34.2026.11.23.00.26.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 00:26:28 -0800 (PST)
From: Kyuwon Cho <kyuwoncho18@gmail.com>
To: Xin Long <lucien.xin@gmail.com>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemb@google.com>,
	Simon Horman <horms@kernel.org>,
	Neil Horman <nhorman@tuxdriver.com>,
	linux-sctp@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net] sctp: pick the AUTH key by the data chunk type that is sent
Date: Mon, 23 Nov 2026 17:26:25 +0900
Message-ID: <179542222978.3276016.1235014191109840927@gmail.com>
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

sctp_datamsg_from_user() takes the chunk key only when the peer asked
to authenticate DATA, but with stream interleaving the message is sent
as I-DATA chunks, and _sctp_make_chunk() marks those for AUTH when the
peer asked for I-DATA. If the peer lists I-DATA but not DATA, the chunk
has auth set and no key, and bundling the AUTH chunk dereferences it:

  KASAN: null-ptr-deref in range [0x0000000000000018-0x000000000000001f]
  RIP: 0010:sctp_packet_append_chunk (net/sctp/output.c:264)
  Call Trace:
   <TASK>
   sctp_packet_transmit_chunk (net/sctp/output.c:189)
   sctp_outq_flush (net/sctp/outqueue.c:1112 net/sctp/outqueue.c:1218)
   sctp_do_sm (net/sctp/sm_sideeffect.c:1826)
   sctp_primitive_SEND (net/sctp/primitive.c:163)
   sctp_sendmsg_to_asoc (net/sctp/socket.c:1919)
   sctp_sendmsg (net/sctp/socket.c:2086)
   __sys_sendto (net/socket.c:2283)

In the opposite case, DATA listed and I-DATA not, the chunks carry a
key but no AUTH, and room for an AUTH chunk is reserved for nothing.

Ask about the chunk type that will actually be built.

Fixes: 0c3f6f655487 ("sctp: implement make_datafrag for sctp_stream_interleave")
Reported-by: Sashiko AI review <netdev-bot+sashiko@kernel.org>
Closes: https://lore.kernel.org/netdev/179540440300.3135.8565987128928534228@kernel.org/
Signed-off-by: Kyuwon Cho <kyuwoncho18@gmail.com>
---
The Sashiko review of our earlier SCTP report pointed this out. We
reproduced it with a test that enables AUTH and interleaving on both
ends of a loopback association and has the listener ask for AUTH on
I-DATA only: the first send() oopses. The test also works as an
unprivileged user in its own user and network namespace, where
net.sctp.auth_enable and net.sctp.intl_enable can be set.

The patch was written with LLM assistance; we reviewed and tested it.
With it, the test runs clean.

 net/sctp/chunk.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sctp/chunk.c b/net/sctp/chunk.c
index 5b889e89e9f2..0ed251421cda 100644
--- a/net/sctp/chunk.c
+++ b/net/sctp/chunk.c
@@ -183,7 +183,8 @@ struct sctp_datamsg *sctp_datamsg_from_user(struct sctp_association *asoc,
 	 * we need to account for bundling of the AUTH chunks along with
 	 * DATA.
 	 */
-	if (sctp_auth_send_cid(SCTP_CID_DATA, asoc)) {
+	if (sctp_auth_send_cid(asoc->peer.intl_capable ? SCTP_CID_I_DATA :
+							 SCTP_CID_DATA, asoc)) {
 		const struct sctp_hmac *hmac_desc =
 			sctp_auth_asoc_get_hmac(asoc);
 
-- 
2.43.0

