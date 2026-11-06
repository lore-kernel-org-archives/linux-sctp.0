Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.231.134
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793991132;
	b=qvzS+sUH5sZkboMofMsECgiGcCG4Oc4QvlmJ0XkgwiG+71OooqTDqtKSodnlaIkbp70K
	 Pm9kZxzpAFw4+whhEiMWFoVCKDoo346JBpXJOISmq5LJb6Ol5MusPaHT4lvbpcc29OA9C
	 sFTFinDnhHwTCOnbiidAHefetESN6O0X4AntR6uhiBZGESeNzvzQDIGmzvVe1lQQB8UfR
	 3J0OLqoHR0NmI0rLREGR0Hg/TtTB0Qtq4jX/xJlK69d0iHDG5z/4RR3Et3QIIxC9ObzLQ
	 gtQ/LhWIa5GLuG0qUer10XEAX4fFaN8eLrXPFa1cqjarlPu+Uu/jrhKzCoesjo2fQyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793991132;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=Jkr/vXjba9Z3zwOiGq9O6qe7GzW0wTcrHSexSQcxSGE=;
	b=MJYmGG6CLPignJfHlGdunSZcqW/WBRwYjmNjMo0qL5G8pOp5Zk7TMdIZqG/w7Eh+nPUz
	 fPVvStpK3NuO2P/CHJECz404qbYvEZlrKYdkzVce+GPEoywdRm+LSbwd2/WWM+bzmora4
	 Rgurv6trXtglCnoEk5t/lMtr5MDb16tuI2qKQxjjc3qhA6y/WhCj0MnEJmR3H3V/FZsQc
	 LI8hXUcVHia/jklrAeAd1slqW/adAhgGyThKmc8x2NVuSiBkPbT6pfBARdAs+U7O4f0lJ
	 Bt899B/+BjsK2ZhLjxPfbAtAi5J6xPf8EQKraZgvne/Qr/nHFUSYZ8C44GM1hy+CVVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=jySbVnZm;
	arc=none smtp.remote-ip=74.125.231.134
Received: from mail-oo2-f6.google.com (mail-oo2-f6.google.com [74.125.231.134])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86879606A32C
	for <linux-sctp@vger.kernel.org>; Fri,  6 Nov 2026 18:52:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 86879606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=jySbVnZm
Received: by mail-oo2-f6.google.com with SMTP id 46e09a7af769-8217177c5daso274747a34.0
        for <linux-sctp@vger.kernel.org>; Fri, 06 Nov 2026 10:52:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793991131; x=1794595931; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Jkr/vXjba9Z3zwOiGq9O6qe7GzW0wTcrHSexSQcxSGE=;
        b=jySbVnZm+1AV5VJLdKjudU4bDQgXjripk4/WPWfN2IuT9kWha6DIBZ51q8fjTnB9Za
         5IKiHFgDtEP8JX8Eak9CbaB3xjArWYIjugVii0/OTMMDAWg3nuALGDp390U86YyhCrs+
         iNeIRpYcGn8SCy5c2vQzO9OCT3viYYjrqkLxW7xOrjJUrEqA9uRo9lWHmEb4eh3ugiDn
         5sV99QblolTqwccSQYAM5pwlZNmBYW062mwK7P/n3HYD1b7KJA0LLoZV4/GaXXJg03Z9
         Mo68HwOiGl7ge+H+PLNAfdXKRV/Szg+dUh11bLP5lSnueAc7qo1icq9qeykO3tWLHB+q
         A+dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793991131; x=1794595931;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Jkr/vXjba9Z3zwOiGq9O6qe7GzW0wTcrHSexSQcxSGE=;
        b=KLcH2pvOM1PVltbx7Mnu85rg/E8TB3KqLaCyqVn8wxEWOeiX4M2ObsFtc8x5EAISU1
         RIjhGeaZCDoPsbXMLHNWWCEESCN0qyE+TBsuVrX+Xz8W9SHOcwjTMua/Z2vDByzowpZz
         BBQTqARJWTxVp0QsPw6ZNpII5XY7CYyzYGblchnG24g6ynU7hVN3C8GVm0xjFvQSQA/3
         msBR/wKIWNx4AAukdlMspQ487ki8rg5TQPWACDSS64a9R8F4w9mua421fGlU9IOkKnAn
         OAiH5v+yLVMyORKQr8E6YT72i/MX6yZTLy0ox6423H2cD+R2cjEi7Aocrx5hM1DOxpG+
         zMBQ==
X-Gm-Message-State: APuU4Z+AXsinyEyfEJfxQ24Own88QaKJfpxX/gchZR4frFHhkHYx7yyl
	s1+er1gsQsmvxs/UU/c9tZ5ntKPi4R0A4VPh7UBppquHxrWr0xOvSep5
X-Gm-Gg: AYBFou20L3u6K+GGE+f3ainUpMsBpXTfhnmRus6396DRglVmDtDwbmrDvlXP5uUBPXr
	PBN0UVx1PIaXWBhAVkeiwIF8d4piylruI3gcnCf7VQpBQFwtNleSQafBmsSKU3FpNvTUZ5carRu
	5LAbDcb6SSyobeKsviMNtkcF85hIHIXT39R8nR57yky8ZhiMK0V/IJfrCtDN0WzH+eOs8g7nXVB
	zN5VciNChfjwGeFGm1Z7a2a23WfAjXNgf24tmJkjw2rDjEM++I51rnkI7RnGQDvDlFzvpLR06rj
	2jh/bcPivnoqQH6VXNW7N4M6NCqkxzl1zOwx+U3Kfnz237SZa7UrBlyGfx7/qoLgkwbG1or0hVT
	pW0g7DEjydVbmQRjmTPg7XtmYyyPRDHbkelkN0Q0+/8p60PJh2HandlJMcVYYcinD3RF49pmv1X
	SHcZt/oFIh0B8buvM+bDUWQB5/jjQNPV/8zEeCb6EbYCgnzkGs8gjihkq0Z83evHW9KDRNV+3nb
	MBs30VAqx/ydrqG8MY80Xm+hzPq7CjL4GOTYHjaet4+UdytG2QqGz1sc/ED9L4AfYyZ6ndp8Gc7
	lkZ9pSenAbUgWB9hZ/oYDnW3wlDESYrGkwxdbsZQRpU2ir1eY0oDVYFMbPEpCh0Li7Tj
X-Received: by 2002:a05:6830:7192:b0:818:56c:a8f6 with SMTP id 46e09a7af769-85f1d04dc99mr3163517a34.26.1793991131373;
        Fri, 06 Nov 2026 10:52:11 -0800 (PST)
Received: from localhost.localdomain ([14.116.239.35])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-85f1de8fdebsm2533411a34.25.2026.11.06.10.52.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 10:52:10 -0800 (PST)
From: Henry Martin <bsdhenrymartin@gmail.com>
To: lucien.xin@gmail.com,
	marcelo.leitner@gmail.com,
	davem@davemloft.net,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	edumazet@kernel.org
Cc: linux-sctp@vger.kernel.org,
	netdev@vger.kernel.org,
	Henry Martin <bsdhenrymartin@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] sctp: fix skb_over_panic when adding addresses with a pending delete of another family
Date: Sat,  7 Nov 2026 02:52:03 +0800
Message-ID: <20261106185203.3326303-1-bsdhenrymartin@gmail.com>
X-Mailer: git-send-email 2.43.7
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

sctp_make_asconf_update_ip() accounts for a pending DEL_IP
parameter by reusing the length of the address being added. The
write-back side instead serializes the pending address itself,
with its own address family. If the pending delete is IPv6
(20-byte parameter) while the added addresses are IPv4 (8-byte),
the chunk is allocated 12 bytes short and sctp_addto_chunk()
writes past the end of the skb. E.g. on mainline (05441d697f7f):

    skbuff: skb_over_panic: text:ffffffff84859c77 len:392 put:20
        tail:0x188 end:0x180 dev:<NULL>
    kernel BUG at net/core/skbuff.c:215!
    CPU: 0 UID: 1000 PID: 379 Comm: poc_sctp
    Call Trace:
     skb_panic
     skb_put
     sctp_addto_chunk
     sctp_make_asconf_update_ip
     sctp_send_asconf_add_ip
     sctp_setsockopt_bindx
     __x64_sys_setsockopt

Requires addip enabled on the endpoint (net.sctp.addip_enable=1).

Account for the pending delete with its own address family, as
the write-back side already does.

This issue was discovered by Tencent CodeBuddy Security.

Cc: stable@vger.kernel.org
Fixes: 8a07eb0a50ae ("sctp: Add ASCONF operation on the single-homed host")
Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
---
 net/sctp/sm_make_chunk.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 90de272842512..18947ec5ff9f9 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -2886,9 +2886,17 @@ struct sctp_chunk *sctp_make_asconf_update_ip(struct sctp_association *asoc,
 
 		addr_buf += af->sockaddr_len;
 		if (asoc->asconf_addr_del_pending && !del_pickup) {
-			/* reuse the parameter length from the same scope one */
+			/* The DEL_IP parameter is serialized from the
+			 * pending address itself below; account for its
+			 * own address family, which may differ from the
+			 * added one.
+			 */
+			addr = asoc->asconf_addr_del_pending;
+			af = sctp_get_af_specific(addr->v4.sin_family);
+
 			totallen += paramlen;
-			totallen += addr_param_len;
+			totallen += af->to_addr_param(addr, &addr_param);
+
 			del_pickup = 1;
 
 			pr_debug("%s: picked same-scope del_pending addr, "
-- 
2.43.7

