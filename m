Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAEE0332917
	for <linux-sctp@vger.kernel.org>; Thu, 27 Aug 2026 07:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787817053; cv=none; b=SRNdTb532IAVZT3joMlN8Ng7LhJzmpAruyPOQ9CAkg8HtP7vJhQ8BkojXKfwy4LLghzrg62pY//rUC0Bx4SoaY0s4CdEDLtRqBA/coC/uAtztcIgD9Xu9t2M5hKBXCnz6sKo3m3nHlicxY6jYO6sPCgfFZvLjBf3/EYn2qH/LAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787817053; c=relaxed/simple;
	bh=ombfWduYmRzuQM+qSTOW1ygfQL83duLTVFuIzr1u56M=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=f+rCf3PkewRMHzvj/QvDx6T9cQ4ULYOP78U3RjWkeO8jTRb8iXn0U82GbALl2U1bDkFMyWRhc1mJzEya9VS36uJO/WOuKw0ZcSvtkjR05wov2Iz5eOJyg5l4kKO0ksKycBi/QnOuLxdj3+QACsLUx8O4vSmZHvRoA381CQIWcSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jWQVZIjG; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jWQVZIjG"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-84a3e5ca66eso75785b3a.3
        for <linux-sctp@vger.kernel.org>; Thu, 27 Aug 2026 00:50:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787817051; x=1788421851; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=QJxok4wgUB8E2b2EBexjp7DU43elN9IiB4VyNdbeBMI=;
        b=jWQVZIjGm1P24DRfClznD9+7yzaeXVPc0wzpMJbuAd/RNGPmN7gVHVYvo6Zc8OjUfg
         CKiJ7OW2aKP6+T0mhBxULF00v7cqfLQXZgwcbwkeN5dIto9u7cYw8n+Zj0PSYYkmXhsx
         l9IdtO+Dr8tCqbzJixZu/rzCfiDKn0cGzedji1xD2swihZIX3u4jL9cLMuDcmGbfCdzU
         OKU5gtW5b0+Rd2C2y915qsfdX0OGLeOii9uwNrFIfCe/ODxrthMqcjvmdnLplepyw0wL
         bG6j7t55kP7awbmZLX304OyhBrolPJf6QFHXqqZJcFHVi1TavE+3zO4ORvgNNk6NDBLZ
         WB2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787817051; x=1788421851;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QJxok4wgUB8E2b2EBexjp7DU43elN9IiB4VyNdbeBMI=;
        b=OARhDR7+reFl/2TSPH3Hk9YcB7VYlgnAp1zDAu5WE+bhIM5GxR/O53F5iJitjMfNrX
         t/UqO42QIF7Kpoj3/RvUDtgvrpPIbiAPBQQXya+kQeA2S/Sjp8hbr2B8vtDyNjNMZiL3
         D4ar97JIs0Iku5NLep/Ciy4oAwhKAi/qmnKNaBfzdq31wjgtN6RR3S+5w5DRfSQOoqX2
         Alt4iI59ZH66iqr0JhOKakzS0PUNUF0EReb3e+TUF5R7s/IQiFJtdiTdsv7MH8yx7nmE
         +eqRwoxum5bTC3bXXeSQxSOu53O2bHNEckzE4VSHdpt2+NiEu04kI7w88v+4s0LpALRE
         olzg==
X-Forwarded-Encrypted: i=1; AHgh+Rrilsa1QiA3bUc8qvMaHzROnZL+z5euq3GyLXW5JognEbsP1qyKQfY45fMdE6SDax8O1mM7QEWKl3jh@vger.kernel.org
X-Gm-Message-State: AFuF++kSRTTL6QpTvVzY81KbrfGuG5U8Rymx2s7HAKo1UpMvRSAx5Hr/
	IsDiIoK7n/+wvvW8GtFIBDlHY2LqHfXSy2UYRatPYdbUEwn2savR7pgt
X-Gm-Gg: AR+sD13ApFOBjMHEw412dgTembtjtHG/XAa0ZCKnSPA4i5rC8MdYtA3dHjY9PsHLEyX
	eaPavdqPQzPnWLChWNEOe4hxiAMmwTyZ8T3rbUVPrFIGqvQDcKWJqOF4o/5XmiKQk5d8oQLih07
	j1c1eoJyY06ZXD01zwOTJr0Jpa03ShXqzIKbhqM3wRr2EZwI2gvP21kbNTGmUFRv3cNOq83UkS/
	DlNNeWoNXCkgcXYljkps/Wrk/T11bB2XXC93JgiOCNUbAyuy5HNgMchpeC+4My0sj1o8F82nHX1
	TquwBP0JJcmrN7Aes1HGqw8sHOJhMJ62F+EJIFmiZgVwUONfzj9YCDauF1ABeVa2Z8xIVKm9pWY
	E++nK5i9bbPRwKepk3aZVMoklOQdfUgCRkjhNqx2prVNN4JQooX4XaDhkppvp07uJ4XBBEwMZs5
	5LEW7o1VXuQLgIfbgNCfBId+vww3MIBxWcXY93CxDs0xf6a1rd9R2vD10Yk+G8EUurM4+vONT3n
	IO+LKSkCy6rmFP6hrNqYuQCJjthWg==
X-Received: by 2002:a05:6a21:c147:20b0:3d1:56e6:daad with SMTP id adf61e73a8af0-3d156e6db8emr2237492637.0.1787817050967;
        Thu, 27 Aug 2026 00:50:50 -0700 (PDT)
Received: from localhost.localdomain ([189.1.242.96])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc1bec80fdesm1761524a12.24.2026.08.27.00.50.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 00:50:50 -0700 (PDT)
From: Yiqi Sun <sunyiqixm@gmail.com>
To: marcelo.leitner@gmail.com,
	lucien.xin@gmail.com
Cc: davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	linux-sctp@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yiqi Sun <sunyiqixm@gmail.com>
Subject: [PATCH net] sctp: avoid livelock while updating retransmit path
Date: Thu, 27 Aug 2026 15:50:06 +0800
Message-Id: <20260827075006.3979566-1-sunyiqixm@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

sctp_assoc_update_retran_path() walks the association transport list from
the current retransmit path's successor and stops once it reaches the
current retransmit path again. However, the loop skips transports in
SCTP_UNCONFIRMED state before checking for the wraparound condition.

This makes the loop non-terminating when the association contains only
UNCONFIRMED transports at that point and asoc->peer.retran_path is also
UNCONFIRMED. One way to reach that state is through ASCONF wildcard
DEL-IP processing after an unconfirmed address is selected as the
primary transport. sctp_assoc_del_nonprimary_peers() then removes the
other transports one by one; when removing the current retran_path,
sctp_assoc_rm_peer() calls sctp_assoc_update_retran_path() before
unlinking it. If the remaining candidate and the current retran_path are
both UNCONFIRMED, the loop repeatedly continues before it can observe
that it has completed a full pass.

The same reproducer that exercised the bug fixed by commit 9b2854f86f0b
("sctp: don't free the ASCONF's own transport in DEL-IP processing") can
still trigger this CPU stall after that fix is applied. With the UAF
prevented, the ASCONF processing no longer dereferences the freed
transport, but it can still reach the retransmit-path update described
above and spin in the all-UNCONFIRMED case.

Fix this by remembering whether the current transport is the original
retran_path, still considering it as a candidate when it is not
UNCONFIRMED, and then breaking after the candidate logic. This preserves
the existing fallback semantics while making the full-pass termination
independent of the transport state.

Also restore the NULL guard around the retran_path assignment. In the
all-UNCONFIRMED case there is no eligible replacement transport, and
installing NULL would leave later retransmit-path users and the debug
print with a NULL path.

Fixes: 4c47af4d5eb2 ("net: sctp: rework multihoming retransmission path selection to rfc4960")
Signed-off-by: Yiqi Sun <sunyiqixm@gmail.com>
---
 net/sctp/associola.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index c0512c827d0f..6f19eb0b01e2 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -1272,6 +1272,7 @@ void sctp_assoc_update_retran_path(struct sctp_association *asoc)
 {
 	struct sctp_transport *trans = asoc->peer.retran_path;
 	struct sctp_transport *trans_next = NULL;
+	bool last = false;
 
 	/* We're done as we only have the one and only path. */
 	if (asoc->peer.transport_count == 1)
@@ -1289,18 +1290,20 @@ void sctp_assoc_update_retran_path(struct sctp_association *asoc)
 		/* Manually skip the head element. */
 		if (&trans->transports == &asoc->peer.transport_addr_list)
 			continue;
-		if (trans->state == SCTP_UNCONFIRMED)
-			continue;
-		trans_next = sctp_trans_elect_best(trans, trans_next);
-		/* Active is good enough for immediate return. */
-		if (trans_next->state == SCTP_ACTIVE)
-			break;
+		last = trans == asoc->peer.retran_path;
+		if (trans->state != SCTP_UNCONFIRMED) {
+			trans_next = sctp_trans_elect_best(trans, trans_next);
+			/* Active is good enough for immediate return. */
+			if (trans_next->state == SCTP_ACTIVE)
+				break;
+		}
 		/* We've reached the end, time to update path. */
-		if (trans == asoc->peer.retran_path)
+		if (last)
 			break;
 	}
 
-	asoc->peer.retran_path = trans_next;
+	if (trans_next)
+		asoc->peer.retran_path = trans_next;
 
 	pr_debug("%s: association:%p updated new path to addr:%pISpc\n",
 		 __func__, asoc, &asoc->peer.retran_path->ipaddr.sa);
-- 
2.34.1

