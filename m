Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795574218;
	b=y8UJgRMQiUmPlY1CwZ7z8xeaSO5jzTb5slpt09Fa1yWxAZZDbvXJgqeSDIt14QrbI1Gt
	 G32lXj+QERt3WHpZH57bG7w2cMOfuPJOYxvmZcv+NYRia5j8e0noWSjX2ZCEPUvo3IQhI
	 nA3chhkFYIWOJTz+5cTOfnwC7P7V/aT/JoPCaw3Bwl93XRFgmVAmC1h23x7KuBC085RS3
	 1r8V1O9CMq/Xnh/ieG3kGVjnQf6uYAyce3kFmPReQTXhMfxhwrmTmE+ryUFFLF4advH50
	 kR6nQjh1Bx/vvJLJiIFZroZxav71bHHupzNy7ZNPL6uNms9NGWo0B6oc05DoVdqqhwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795574218;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qcscy56M/CoCoEWONbNvA0WraoTWByCF8svZRDgoSrY=;
	b=Sbjgf634ctAztcy29x3W8NrzKJrhN5/+M4a8cJNhHsgf3Uye0l+FxCQdCaFnZVboQODy
	 cTiVPPdL5C6SxB904dphU5g0s+xzWBIB79+Ba6q5cczjkQtlU3KzypcTN1GMN5UHugQjn
	 oS+7IAUF/xIgO17R0cpdDlol8hSgSYDwJquMIUR59DiIWlefznK++J7dB3JkgH5h9WiPb
	 nBoWrQFUqsoiM6y9EfAosCT94ZlIFIbVOeSZqZEN9aMTk0XJEDOtJI6YoY0POl1GfUbLQ
	 rR+YKahsI+zHciVTg7bzRrIpqdzT1pA+WGiDxpt3pas3X96hTv8YfHRBL+cUbwxcYOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=w6JkcNuZ;
	arc=none smtp.remote-ip=209.85.210.177
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF601606A330
	for <linux-sctp@vger.kernel.org>; Wed, 25 Nov 2026 02:36:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DF601606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=w6JkcNuZ
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-8b5e5e64494so2699212b3a.1
        for <linux-sctp@vger.kernel.org>; Tue, 24 Nov 2026 18:36:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795574217; x=1796179017; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qcscy56M/CoCoEWONbNvA0WraoTWByCF8svZRDgoSrY=;
        b=w6JkcNuZetKNcfvjGYEZkRJSqOX99DtTgjmY/t9hV67fWOF43XdsPIeBTYmmEN7tqo
         Oe4rl6Gskg3nN9WTVaMEDs+7cBe4MJVpRtuNMoxtbhfM5NAriK7aRrMxnlZ/g3vOB28C
         FLqHPHweaSbTAWnKlIs3HXSRSEwQkUpswJ/BR0/SkW8cgxumMCpw7qcVlpPQYAXRldso
         8qywPQ4QDcRL5YHtCn43ETUlfTBX/JRE4sN72uFkWO+gFJ9SAfauQKhPkpDwDZsAcKV9
         SHQp/N5GieLUvJfNMx2lrBqv6vw4aQ7rTo2wgxdRNRzJPzfL4WEB8cDmLQ86+WHbmTQm
         gnwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795574217; x=1796179017;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=qcscy56M/CoCoEWONbNvA0WraoTWByCF8svZRDgoSrY=;
        b=xJhP1DL0LT4hzgWTDPTmQ+To1ApfxpCVDwNDkJsQSfypwhKx/8C7UIuo03jf+Koluy
         UjZbZqRH1s2xAUdxxXf/keHbN88WmPmPi6IjfppGE724ZWr5DjSsJ/4tQ35PTXu2/Vko
         gIDBPctxUpeMa9Uja8bsv6dJ/JKbrfEopIPzw57GzZIDKnilheZkxTEcCys3+RWCHIUm
         1Kowu+UwOdVQ9RpOjTzc4UBSHuzBrePWhkIF99oH/PhQa+gjTs82ke0QPniPBPQH95Gi
         EI3DgL6OqAMyhEXqqYxjvY+NQ2aMSxoBZ56ki50w5WcTLy1XCgq8kpjFrSfnmhI70qHv
         gKNA==
X-Forwarded-Encrypted: i=1; AL+hErH7M+5woMhhpMn9yy5e9O0hsdsLRz36tjyoOjdK19vwA0/ALhTiQFWRPvH/5bh71SQ2XUCJSCqIOhwz@vger.kernel.org
X-Gm-Message-State: APuU4Z9aXSv2hG06qL5vAnDmPlEM8kFOtwaUBco9XYNvsW9DiGxi7R4Q
	js4TIN9T8ZrFluAiVQSThwgiUMOmzY7Orz9i4508YlskIk18ni1cAItF
X-Gm-Gg: AZFdTZcsv621Vn1ut8Fe0BuEYBJ6UEQ5mAJvuFBqtM1JVZZ19KE8hVdP7GEKcUVPj2r
	MDLW6tTFZBUY6b52YUssD4Tsw2ZyIoJ1fCPBzYysTI8SIXJ7fYDYJV5Sclykj9fk5VwkLWnu51y
	eirnuhXOHmdMMUGpJg9E3fvpINLQsRfqgy646ijZi3J5Vxk+Xq5l4PECrjBcUHR7NBEfR49xPyZ
	5RC/fOdxzmMu7jJJcZrqyPb+ZPT6KBWcf8oUPxCQEU9XK9wpdTtIDcCyQiGkWrcgdkLGtlmvzK5
	+bbJnUp2PRXq9zzTlNt9RKueHxLM/j+S3ALB3IS0C6gBGCQIPVM1Ipq0Nwxe5l/M51Mt5Xm4L9w
	ZhHYsf4Jd2c07yABhW8DXKYTKYBAQQd/BEJZUOkaYicmwUstwNEt+PaJeJX4IqoSF1c+OaWNdof
	XLYmDI+JS//pKyoaEBnxWGlI/lwLPGw3ndG1zcbbH4rEg9C3PsyHtofy2ueFk8I008+eEUj2UeK
	sPXMkhN8jMMuUBKbF8HmsOqF327HxnwQ8FZZScrS7dLNxl9cqSt0QZdRNiAjzl4ek0McZXGrfFw
	/02IpLLedpPHJl/h0ap/MMgfbjxzsWGedOmJRIukyaeyLiEKhOTe4E4aZrnU6ElBLLo=
X-Received: by 2002:a05:6a00:1820:b0:8b1:1b86:71d2 with SMTP id d2e1a72fcca58-8c87bfa766cmr14875130b3a.22.1795574217152;
        Tue, 24 Nov 2026 18:36:57 -0800 (PST)
Received: from d20be28ee783.tail196be.ts.net (vldb.skku.ac.kr. [115.145.173.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c908a56acfsm7294885b3a.23.2026.11.24.18.36.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 18:36:56 -0800 (PST)
From: Kyuwon Cho <kyuwoncho18@gmail.com>
To: Xin Long <lucien.xin@gmail.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Willem de Bruijn <willemb@google.com>,
	Jun Yang <junvyyang@tencent.com>,
	linux-sctp@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net v4 1/1] sctp: fail the association when the INIT-ACK cannot be processed
Date: Wed, 25 Nov 2026 11:36:50 +0900
Message-ID: <5d2a09ae8d660d10091942d426c0c8f1f82c1705.1795572890.git.kyuwoncho18@gmail.com>
In-Reply-To: <cover.1795572890.git.kyuwoncho18@gmail.com>
References: <cover.1795572890.git.kyuwoncho18@gmail.com>
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

sctp_sf_do_5_1C_ack() queues SCTP_CMD_PEER_INIT and SCTP_CMD_ASSOC_SHKEY.
If either fails, sctp_cmd_interpreter() stops there, but the association
stays: with the peer marked AUTH capable and asoc->shkey still NULL, a
chunk that the peer wants authenticated, such as the ABORT built by
close() with SO_LINGER {1, 0}, takes a reference on the NULL key:

  BUG: KASAN: null-ptr-deref in sctp_auth_shkey_hold (net/sctp/auth.c:113)
  Write of size 4 at addr 0000000000000018
  Call Trace:
   sctp_auth_shkey_hold (net/sctp/auth.c:113)
   sctp_control_set_owner_w (net/sctp/sm_make_chunk.c:112)
   sctp_make_abort_user (net/sctp/sm_make_chunk.c:1016)
   sctp_close (net/sctp/socket.c:1564)

Process the INIT-ACK and set up the association key directly in
sctp_sf_do_5_1C_ack(), and abort the association with
sctp_stop_t1_and_abort() if either step fails, as is done when the
INIT-ACK fails verification. This also aborts when sctp_process_init()
rejects a peer that is ASCONF capable but not AUTH capable, which used
to drop the INIT-ACK and leave T1-init to expire. SCTP_CMD_PEER_INIT
and SCTP_CMD_ASSOC_SHKEY have no other users, so remove them.

Fixes: 1b1e0bc99474 ("sctp: add refcnt support for sh_key")
Suggested-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Kyuwon Cho <kyuwoncho18@gmail.com>
---
 net/sctp/sm_statefuns.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index fd9f94c12d42..206fa0b6cd4b 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -605,9 +605,11 @@ enum sctp_disposition sctp_sf_do_5_1C_ack(struct net *net,
 
 	if (!sctp_process_init((struct sctp_association *)asoc, chunk,
 			       sctp_source(chunk), initchunk, GFP_ATOMIC)) {
-		sctp_add_cmd_sf(commands, SCTP_CMD_INIT_FAILED,
-				SCTP_PERR(SCTP_ERROR_NO_RESOURCE));
-		return SCTP_DISPOSITION_CONSUME;
+		if (err_chunk)
+			sctp_chunk_free(err_chunk);
+		return sctp_stop_t1_and_abort(net, commands,
+					      SCTP_ERROR_NO_RESOURCE, ENOMEM,
+					      asoc, chunk->transport);
 	}
 
 	/* SCTP-AUTH: generate the association shared keys so that
@@ -615,9 +617,11 @@ enum sctp_disposition sctp_sf_do_5_1C_ack(struct net *net,
 	 */
 	if (sctp_auth_asoc_init_active_key((struct sctp_association *)asoc,
 					   GFP_ATOMIC)) {
-		sctp_add_cmd_sf(commands, SCTP_CMD_INIT_FAILED,
-				SCTP_PERR(SCTP_ERROR_NO_RESOURCE));
-		return SCTP_DISPOSITION_CONSUME;
+		if (err_chunk)
+			sctp_chunk_free(err_chunk);
+		return sctp_stop_t1_and_abort(net, commands,
+					      SCTP_ERROR_NO_RESOURCE, ENOMEM,
+					      asoc, chunk->transport);
 	}
 
 	/* Reset init error count upon receipt of INIT-ACK.  */
-- 
2.43.0

