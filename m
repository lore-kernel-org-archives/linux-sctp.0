Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CFBC478865
	for <linux-sctp@vger.kernel.org>; Wed,  5 Aug 2026 15:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785943133; cv=none; b=mjO7BeS+buV7znB44vu++hcldXJlHThit3eKOohK8WYH0WqYxqrdR0zsoib+8NS/Q5vinfp91Ataa4/5DqLiyjqIOOFK6zKShcih12hZKkJuGZjodvTw9UuulqWAsh6+uletpK5dNTiHPWN1tkggyKHpiMejBD3vQWejO9KoEYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785943133; c=relaxed/simple;
	bh=ZZNYP0Dgp/aQeD7XlJY0GnewzQjGWhFzJEDtuyuCt4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rh7BOWlP04/JRl8JctWmzKecs4sAU8EH3lyBwkBjNBhyhpx4bxfGNG2UeI08fp71XRU8nTuijbqPqsSZtyZFW+u3RzpYzKjqfzBQ/2DHrrCF8TB3v5J6LieTsERSEzzB2n55yIF/l5zi/k85cvNKZ1sieIMHAcVfhyCOcLqjabY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=shpbWh/E; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="shpbWh/E"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-51c8e2e39easo10797521cf.0
        for <linux-sctp@vger.kernel.org>; Wed, 05 Aug 2026 08:18:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785943123; x=1786547923; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=lTY7AKVH6b+X0UAUoNZRDghBXWYJrtfWNLvl0g5pK5I=;
        b=shpbWh/E7c3Ul9g8+bNPLc/bv56FjFUwywxVNAb72yh1phRSCxJHmIFitqFNzckgQ4
         0axB1Akn/lhn+VydYvodNQpYr3KdhOF+FCw8ElX3pFuzJb5LF6b7rE9K9gQ1hDxw6a/K
         10r0G3ayG5ozM+gksejfXoOfvXeVyUjPHPL9O+4h3qE0x6KRZrlDWmwnrZh0GAbuCsgs
         cxEtLFxOKLUcrhkuA6oUEEYKeQ1yUDqJYRtCsPyPMKVYkAKvrQYq2CnY71GlFZcSrr7e
         SrvYMIxkDm9T1lRxNGMYJumzfTkfNT3XPikkVirQhOpGLJCe/z+s92rIyZLcOtDcMy4s
         Wt7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785943123; x=1786547923;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lTY7AKVH6b+X0UAUoNZRDghBXWYJrtfWNLvl0g5pK5I=;
        b=Ee1Balr/1TzPZGAcq+dzLN9mSgiz/O77AXPPLzLe2z6HtzTf/C+rUoz3JzjiF8uU1O
         tfkrceW4uDDBMfqN+RDCVhur9ihWk02XMsJu1YtsNQSrYqSsKJjUWI6ir28FVp67FLT+
         i6pAFYrdFkLq2qsvB9vMdoAwQyVRs3+fSfw8dW9O5816yFuAKI6CNWjW2HLv/MC5D0+c
         HvoR85Azy+xIWkoGi3JODOgEWvcVcymXW9EYf4g8W9COGbBqTsRmzGiSdJ3s/QX9yPst
         QeisvqwZ3KxflRSNYqx0AWZc3xqA3r4LqMUaRo7NbCZoybmJ33iAg5jVsmyZprzD+vuw
         dzag==
X-Forwarded-Encrypted: i=1; AHgh+RpwNjSk3PiXqxB9u6epsID/OUSpGEwlO9F/pNuJt04xk9sJxDfOCySEZPTPp3q/uNMdeHSoX21nEEO2@vger.kernel.org
X-Gm-Message-State: AOJu0YxjDCH/4yKtMfTxP5ZUQbyEUsvcYiglJYsO42LvcqYxoKyLe+w9
	qibh/hVpYBjXOAQCPn4geqxsYZ5ZVHoDvZ+kn5TGITberSWz2AZ3SoBu
X-Gm-Gg: AR+sD11UYnKFl5tZ725/soS5PN0ZpOLmviP7KAhgpalK6OQwVdBd2oJE7NN2Kl6MT/R
	gxBC/zjr7yBURzjTV3e4seKJdNgpmmcdE+7/XoyH763vIuLbEbAHhwUpzlGV3tGIIrX2tBwFaT8
	fnzsfUOcGsxLH0NtzFwVBRSbEsQpGk1+HisD2c4j1oLac2h72A2nbxOVT5j/j8VPTt04+IT5mS5
	XlxFW0ALHFbMfflMw8itQarpdmZ2MjFBpMWfaVjNr80UfgrEKGaVZ2KFQsqhcFE8WW+LBrULY4o
	Ep5M43dshxnlog391GV4jDDgPxuQf3dTHZH0PTt8CWLRV9kSJrmdm3mVUstMrK2F7W35RAad0O9
	qqDnflK3OSnBPR1j3mt6XJ88drVRcdMowsq8QTXdhFE3DPOzyiVt7GaZkRUPgYmJyUWN5C+XMFJ
	xQJS/Am98Gf0/v6JvAid4abexOTUR8l3VDELesMRcE04otyq/MZtM1/xtw1y6TrKTaU5I8sZW1g
	YUNqCR66ElATEmncepdJQOCJtc2CAPTiFpTXagGYeHBQfKCrg5jQ/U4ZS77n7k+th3TAAcmpSCk
	/cRCYpAfMx3DpnqCsMF3tIBA2KA=
X-Received: by 2002:ac8:5c8f:0:b0:50b:48e3:47a7 with SMTP id d75a77b69052e-52ce60853d6mr82421191cf.18.1785943122785;
        Wed, 05 Aug 2026 08:18:42 -0700 (PDT)
Received: from wsfd-netdev58.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-52ce894e18asm22023081cf.23.2026.08.05.08.18.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2026 08:18:41 -0700 (PDT)
From: Xin Long <lucien.xin@gmail.com>
To: network dev <netdev@vger.kernel.org>,
	linux-sctp@vger.kernel.org
Cc: davem@davemloft.net,
	kuba@kernel.org,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Daniele Linguaglossa <danielelinguaglossa@gmail.com>
Subject: [PATCH net] sctp: clear control chunk transport if it is being removed
Date: Wed,  5 Aug 2026 11:18:40 -0400
Message-ID: <7e1168cb722132152a29d47e5eafaeac4a3bf6f3.1785943120.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

sctp_make_heartbeat_ack() caches the destination transport in
chunk->transport without taking a reference. When src_out_of_asoc_ok is
enabled, the HEARTBEAT ACK may remain queued on control_chunk_list instead
of being transmitted immediately.

If the peer transport is removed while the chunk is still queued,
sctp_assoc_rm_peer() drops the transport and schedules it for RCU freeing,
but only clears cached transport pointers in out_chunk_list.  The queued
control chunk therefore retains a dangling transport pointer.

Once an ASCONF_ACK clears the suppression and the queued control chunk is
transmitted, SCTP dereferences the stale transport pointer, leading to a
use-after-free.

Fix this by also clearing chunk->transport for queued control chunks in
control_chunk_list when removing the transport.

Fixes: 8a07eb0a50ae ("sctp: Add ASCONF operation on the single-homed host")
Reported-by: Daniele Linguaglossa <danielelinguaglossa@gmail.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/associola.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index b6ac0966420a..5b0ae616e1ff 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -573,6 +573,10 @@ void sctp_assoc_rm_peer(struct sctp_association *asoc,
 		if (ch->transport == peer)
 			ch->transport = NULL;
 
+	list_for_each_entry(ch, &asoc->outqueue.control_chunk_list, list)
+		if (ch->transport == peer)
+			ch->transport = NULL;
+
 	asoc->peer.transport_count--;
 
 	sctp_ulpevent_notify_peer_addr_change(peer, SCTP_ADDR_REMOVED, 0);
-- 
2.47.1

