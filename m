Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794475293;
	b=IaSzcXfMKyfurtjyvfUgvcDu1e7Qs8pPTe+3mI0Q1TKAoz/Xmdasq3CsU5C7MOpl+X7b
	 YbR2TYH0pGys2+ZE6oUTVVQeo03xdBT357T0jLQbexJwMgba8XWuJW3/Dsyt8AQdLf0Zv
	 ClRO21v0UESm3X+dA4gzDwEqLlJ+WEhrEy53CzFAo5l6ULMYTNnqy4SdTMQ3bnOl+Q9+k
	 E1zLr/cRUUDeLgorioMCJ6+JU3Vl7WghK/YpS6xy/xUga5FMEzhQO4Pp3SmWrGuCA9Fx2
	 wjGvnh016n9r6PQ9kVcClpS4tAVN1i4OgAMjFbfhMxYniR5eWtHCG+BE30Aq2wwx79w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794475293;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=WWgmljf7p+9w5O022U38G+2AIVWKoqElpuvWzSOA914=;
	b=3ZBvahLSx83m+KLaweqQ16W3dSR4+v+rFCbCUaubTWpXhnGghGcwAi+Dt2Nmm5z00ysu
	 ZEm/cFdSdI5X7F/cCf6yobhf64A1jZoP3q0bcZc8XEV4UoAdu6uJ4F7c/h2T+Y1Tu9KUA
	 GJfK6EEqEt46xwKS0tQ9MfjoUKmAT/yMg6gQn/Ht6DAfOXt89b+oR7UVa/nDaPD/y/Qg/
	 fLdDo6m4t2bfcFLUUVbBFO5LipjMhwA2yUrqwIK2UMoIg7hbaF6vLzqrIo0JGDW0Db5EL
	 /LXFDrnvqWQwm/bu9942vKhyIWUZ5nz4n+FaeNC0APO9UNV8jYjCGYUTVPZaE7wgZzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=uCLbTb0r;
	arc=none smtp.remote-ip=209.85.210.181
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AFB1606A321
	for <linux-sctp@vger.kernel.org>; Thu, 12 Nov 2026 09:21:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8AFB1606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=uCLbTb0r
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-8b5c3288e6cso1792572b3a.3
        for <linux-sctp@vger.kernel.org>; Thu, 12 Nov 2026 01:21:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794475292; x=1795080092; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=WWgmljf7p+9w5O022U38G+2AIVWKoqElpuvWzSOA914=;
        b=uCLbTb0rB83bwv9iDuS+LxIdVmXsAEqbZalNHgCMW9hYO09rz9Bd82xt1MY/+a7ipU
         Ph9/ItVXahyPYEPiUhLnothPXdEa3DmzRP468PqaETZ+1nIdHeTcguQ2DV3yakaUitrk
         LE4J2DXpB2C7uS2qBfUbJ9jkB6F6yLgZ9yUDoEJUbxLAtWq+qMiO+fP/uFoSyvICafIC
         SeSkbuIYpxPANwSS985Jer97vYYJx7f/nUg9POhhaQkH6xN1IKcAsxhMfXY9hxrgAm4n
         2ZmYffJHUWXBKOMCdMj3IukJ5K+cv7J3fRxSgpukR9zmN09xhtXGSqjPjZlRocobEjgE
         HspA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794475292; x=1795080092;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WWgmljf7p+9w5O022U38G+2AIVWKoqElpuvWzSOA914=;
        b=LoPtSRMPw1SV3/AzzpatAnwZ9ZZnzgqCWjIQVw/Q9/U9qGQsOmpRlUBo/BePwgCzSE
         EnPYxcLckWaAU4Wy6WM5AElYAJrDvc9Pf8u7GZY60Nn3QpnxIWPknBemcC2COKknxj03
         dyBSCoqeaJExFx5WZs/5dZeZDqJWE4NdpLI/P9BKYD/ohbvjSImSg8xvW3UF/XMp0tDW
         AsHRac9NCPwbpYIgduJeIS1YL87HKboUWOsINepP/Wx4RTKkQ1XWWYhzZy7t5Ez0LOsy
         nRaYTFUfGujJJvFQcFEff9MkjPp1DMUocie8TQn6dcIqI3G9XRkdZwl0xNmIpX/y6B/9
         0eFA==
X-Forwarded-Encrypted: i=1; AL+hErHiIIIoA7bh7VDjyq0y2MeslHn2WUHQB/LtoSsyZEunNvFtkOY2B2oOPJ8QybZ9oN/L9TCCP+Anrpk7@vger.kernel.org
X-Gm-Message-State: APuU4Z+fcQWhKjw/TPU476zdxozjUuYDy2HUiLxtRyit3fNdj1wwfCIr
	V3EEGcuGVNwoYcFwh2mqgWqX+G5QRnaGj8fipIMa4Vtz+S5E48Cbu3VG
X-Gm-Gg: AYBFou0Ht9HySVzdtR6piHb2e8cvCEdPqfQo50aH48sfnt93mdLBz/v3um7GVJCZbVv
	RAt1ACiFbp/rmc/jMoDisz93wmTan77cIOejuc+GoRtefSb6FVf/xwTIbxkCkPSZX+pq+DuqaRq
	+yLbdDDRTFkfgScaRRjMGnM0xNQerFS+M6wHF6FtmtRasm654ogwZYW7bw6mjm/L90woNBYow11
	2Speqgt8AjvFMPXMTmg9Bw9Mp/wLU8uBiRmd3Glq5Vw/rDR8wdyjMiV64QhDcFhrJbeHVFzUUb9
	yJv0XwMHWkcXs7jI6H6I4KwYiulksnD2zMGsKwwZgNqW+mr0Cb4y9qHFf4tNX1Exob+bfEPD2KI
	W+AxbLwW1BVLwHuYAsbeTufYEJe9e21bw7Qai01vgbE00U6L9rENxmd8AXsvTJycTUcfn2UCy6/
	8vJw6ErRHltcOdWFPDZz5tH1jvBOpp7Xc9EJh+zqNBMsrgdS+uJDvr89+QDM+azkaND9hyJlHC+
	Hw4Hnd/1EEoVF8HptUyHcOBbLz4rN4JpPtB0NNrJXiT6C63z6zChEdDXRBOgZEHY9MsxSg4gLGS
	bQNqzOkBOO08Qz9GlijEIk0pTd7EvWHTQKrnG+/HrWz004cCuTp3IRJ/zrQ6DAKg3ZartXg7eQ=
	=
X-Received: by 2002:a05:6a00:b86:b0:89e:c324:958a with SMTP id d2e1a72fcca58-8bc1d148d9emr4997745b3a.34.1794475291667;
        Thu, 12 Nov 2026 01:21:31 -0800 (PST)
Received: from JIAPENGLIN-MC0.tencent.com ([43.132.141.21])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8baaa2a6d79sm3214881b3a.10.2026.11.12.01.21.28
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 12 Nov 2026 01:21:31 -0800 (PST)
From: Lin Jiapeng <ljp1205831794@gmail.com>
To: netdev@vger.kernel.org
Cc: Lin Jiapeng <jiapenglin@tencent.com>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Vlad Yasevich <vladislav.yasevich@hp.com>,
	linux-sctp@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net] sctp: preserve the last transport during INIT error cleanup
Date: Thu, 12 Nov 2026 17:20:58 +0800
Message-ID: <20261112092114.12458-1-ljp1205831794@gmail.com>
X-Mailer: git-send-email 2.55.0
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

From: Lin Jiapeng <jiapenglin@tencent.com>

On failure, sctp_process_init() removes all non-ACTIVE peer transports.
An existing UNCONFIRMED transport is not promoted to ACTIVE by
sctp_assoc_add_peer(), so cleanup can remove the last transport.

sctp_assoc_rm_peer() assumes another transport remains after removal.
If the list becomes empty, it interprets the list head as a transport
and passes the invalid replacement to sctp_assoc_set_primary() when
removing the primary path, causing a NULL pointer dereference:

	Oops: general protection fault, probably for non-canonical address 0xdffffc0000000045: 0000 [#1] SMP KASAN NOPTI
	KASAN: null-ptr-deref in range [0x0000000000000228-0x000000000000022f]
	RIP: 0010:sctp_ulpevent_notify_peer_addr_change+0x73/0xba0
	Call Trace:
	 <IRQ>
	 sctp_assoc_rm_peer+0x186/0x9b0
	 sctp_process_init+0x1ff4/0x2810
	 sctp_do_sm+0x1c97/0x4560
	 sctp_assoc_bh_rcv+0x30b/0x630
	 sctp_rcv+0xb63/0x1220
	Kernel panic - not syncing: Fatal exception in interrupt

Keep the last transport during cleanup so sctp_assoc_rm_peer() has a
valid replacement. The retained transport is freed when the association
is destroyed.

Fixes: add52379dde2 ("sctp: Fix oops when INIT-ACK indicates that peer doesn't support AUTH")
Cc: stable@vger.kernel.org
Reported-by: TencentOS Corvus AI <corvus@tencent.com>
Signed-off-by: Lin Jiapeng <jiapenglin@tencent.com>
---
 net/sctp/sm_make_chunk.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 15c2d87575a8..e4b7dacf174e 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -2528,7 +2528,8 @@ int sctp_process_init(struct sctp_association *asoc, struct sctp_chunk *chunk,
 	/* Release the transport structures. */
 	list_for_each_safe(pos, temp, &asoc->peer.transport_addr_list) {
 		transport = list_entry(pos, struct sctp_transport, transports);
-		if (transport->state != SCTP_ACTIVE)
+		if (transport->state != SCTP_ACTIVE &&
+		    !list_is_singular(&asoc->peer.transport_addr_list))
 			sctp_assoc_rm_peer(asoc, transport);
 	}
 

base-commit: 145480b28ca82e9fae789427cc4569e596515a32
-- 
2.55.0

