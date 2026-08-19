Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 359472C11F3
	for <linux-sctp@vger.kernel.org>; Wed, 19 Aug 2026 01:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787103524; cv=none; b=uBdjw/6vzFqMhX35hHzKq4eXOVIuK6e2Yxr1QISY74cT0OQthdhHMKxxzV4ItXt3tfodRgZtQCj9eUZLbVeD/AVB/v8obQ8aefcoepk7EschVSs/As2fbtIMnMYKLNIC2A2lsAErIgDuwdVRH+wDHf/WpS7uLcIJd/UdnMXEoqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787103524; c=relaxed/simple;
	bh=LFrAOYXYKD2eZi92nlYeYNfprg/amWabLxum55E9ojs=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=s2qPWlgUcLij7ZUsa1O7ClDyrCI/QdfnGe9VaU61URpFP2V1ePZEzQt3cc/5Ss7vgKFoIlxP26wC9RtQl8nMePVPQSBevVrgrRc5h8Q9TOw7tg3S0z2IzlvhYq4xaATBjyJv3am/XNUt1UkXKDGCt2+noKzb8kKXR7X7x5ar9ZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MXitSGyn; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MXitSGyn"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-38125cebfdaso863662a91.1
        for <linux-sctp@vger.kernel.org>; Tue, 18 Aug 2026 18:38:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787103522; x=1787708322; darn=vger.kernel.org;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vZ8i5JGHu3nT+RVW9GRgK1v513n97DoASsTZpEyB5GU=;
        b=MXitSGynUZoA7sHL1hBAultlhx8TzO7cVZvEO56TnO44i5nD5fHo76ef8+3bNJzI5m
         eIFzg8gFLuoAkRbwN0q5LRoedFCLxQcD6rVULUK2OfB3MdjH5qRVKnjpf4bWuX+g4vSP
         Aaf0yusBz/ZUIR8f51DRO969VxG/umt4+Q7S5W2HV2+1PTiylRfxMdtswFsenkIL92s1
         x4PCs6DJEcWPvAvQHcfQy4TtTthfKp24eSnR7JeZLsHKY5Uo+5p7119Xgdw/ISJ5qNvz
         1gX88USSMk/Ls0Gouo6ABRZfxSWtbSML2rY89vkIlkHIfuDECWc1JWwOl0R09NZ5wVQT
         I87g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787103522; x=1787708322;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vZ8i5JGHu3nT+RVW9GRgK1v513n97DoASsTZpEyB5GU=;
        b=lZDMlpkhe2MezQXjb1ym94rIFSvIuBU0m/jTt2RIyT1HKzV82viJ7WJIXHnwE0QOZR
         ZmZR+YDNfh+ImgiFxxAcxaYzSLJYwpuRDpvVals+DIO1XKGAm4K4tUWDdmde7kFlb7Gu
         zljlG9ctnwIoL6RIyFYPwAqaMkKPTnzFq+07sm6Jki8H3160FNOipFvC3L86SZZM93Qt
         LauBvZT37V/4YU4WFDTNvwN6bM7+wYUFpge8Lk5dsNXHnBZHe+G6wMa3pz7JQHiY8HbT
         sScspL26AdIBYX913Oz4EYwnzaTpteNW7fHdP7plhK+qtNM28vg1DCDm3opxjoJXYKTa
         vWSw==
X-Gm-Message-State: AOJu0YxQs/Jnmsnd1CaSv1SPyfgyHWvhLULf/2zctyD/6CDA4byjGSYB
	IJ1S6/7JA373zUjCRQNxo9LOepJno1nmb3zk481aVC+cV6PdhpqvzwLo
X-Gm-Gg: AR+sD10opGdp2Z6UrkfIhKvS/jbZcWtqoiLar+owmz0PKbNBx5NIn+d9byBCiN6qk8U
	37kgilJJfym1Jlsc5jbOD0tny1yL5zpYtdYVLNUbMsZYqXbSQe9lTEGebUyM4qwteAAPcwl50j3
	v5XOQpNsW5JOSValopy6phQJXTz8JYghLro0L2QW7hf/xOWHBBTa41rkV66AaApJHzcgdLoFvVJ
	H9l+Pmk8nV6DhOmWAZZc0K70QMh4kLMX9Z0bbsnK/433/9FtrP+97s306zwQCEuCFkSgkzleron
	PJrn8yZhQofc3sG1GdssqZkGX13TFJvfkdpgOUyxjO+UfAeOKJuhqeC5segR6PrOZ0MpiioZoPI
	pHK2Qsiy376/gj1s8W2F5ibZYC3L5Y0w77nSw5h+Dr3WnXPyKKQNO7RMdpDEn+G3U8lwJDPdoib
	uTExc+CLS3jkgNtrLOA2oG5G//fmuC3QGf92VvGGc8P59XPMyINfOD0/DnGGtkCNkM0+uytiq4J
	An0VWco
X-Received: by 2002:a17:90b:510a:b0:381:792d:f993 with SMTP id 98e67ed59e1d1-395810df1b5mr2140618a91.17.1787103522343;
        Tue, 18 Aug 2026 18:38:42 -0700 (PDT)
Received: from v4bel ([58.123.110.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3957fb60a2bsm666018a91.17.2026.08.18.18.38.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 18:38:41 -0700 (PDT)
Date: Wed, 19 Aug 2026 10:38:37 +0900
From: Hyunwoo Kim <imv4bel@gmail.com>
To: marcelo.leitner@gmail.com, lucien.xin@gmail.com, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	horms@kernel.org
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org, imv4bel@gmail.com
Subject: [PATCH net v2] sctp: drop a chunk if its transport was removed
Message-ID: <aoUJHQmxL0LFIMCw@v4bel>
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

sctp_rcv() resolves the transport once per packet and leaves it in
chunk->transport. The lookup reference, or the one sctp_add_backlog() takes
if the socket is owned by userspace, keeps it around until the chunk has
been processed.

An authenticated ASCONF DEL-IP can remove it in the meantime.
sctp_assoc_rm_peer() takes the transport out of the association and calls
sctp_transport_free(), which tags it dead and drops the reference the
association held. There is a window on both paths: the packet can sit on
the socket backlog, and on the direct path the lookup completes before
bh_lock_sock().

The DATA chunk in that packet puts the removed transport back into
asoc->peer.last_data_from. Once the packet is done that reference goes
away and the transport is freed by RCU, so the next delayed SACK carries
the pointer into the SACK chunk and sctp_outq_select_transport() reads the
freed transport's state.

Drop the chunk in sctp_inq_push(), next to the existing rcvr->dead check.
Both paths reach it with the association's socket lock held. The peer
retransmits it.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
---
Changes in v2:
- Move the check from sctp_backlog_rcv() into sctp_inq_push(), so that the
direct softirq path and the socket migration branch are covered as well.
- Correct the Fixes tag.
- v1: https://lore.kernel.org/all/an-oGfEatacPTSX-@v4bel/
---
 net/sctp/inqueue.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/sctp/inqueue.c b/net/sctp/inqueue.c
index a024c08432471d..5f988b3a8814ff 100644
--- a/net/sctp/inqueue.c
+++ b/net/sctp/inqueue.c
@@ -71,8 +71,11 @@ void sctp_inq_free(struct sctp_inq *queue)
  */
 void sctp_inq_push(struct sctp_inq *q, struct sctp_chunk *chunk)
 {
-	/* Directly call the packet handling routine. */
-	if (chunk->rcvr->dead) {
+	/* Directly call the packet handling routine.  Drop the chunk if the
+	 * receiver or the transport it was looked up on is gone.
+	 */
+	if (chunk->rcvr->dead ||
+	    (chunk->transport && chunk->transport->dead)) {
 		sctp_chunk_free(chunk);
 		return;
 	}
-- 
2.43.0

