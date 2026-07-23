Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9F833DE45C;
	Thu, 23 Jul 2026 07:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784791156; cv=none; b=Emp1lhdS2Zo9++5y27rrn8LAV0AeY+k79bK0+MzsQnEHYoSTMjbNhQBhKJRrus2Zu3LNHKUrZBEpdAbVddlhlOLUMQBKNfi86PJ1Nh6J8V3TE+gm1I3m5ke3kozuPebapTJ18TS3N9WDrxR2tUju6mGSSKlBheD4vGYcy/lOSTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784791156; c=relaxed/simple;
	bh=0//1bJhxa6lpGsjiaJTFOGmAKxIOxL0x4ZNp3zrBGys=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=HFr9zmkdWxaetNBc0nFUNMVjQLGWDDcf/GF0BGZG1UXSt/jxwaGnKStU3gDNE30WdeCE8DndPyh0F1ebAbhs2pIsRr2TFcKj9vxZ33T5v1iycnEuPcP5MJFx5RLDubHl7cC2cOIgCFwHeiAthfwbrBIpz1MzNqOGpb+8IRHXF6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=K0YQr6nQ; arc=none smtp.client-ip=117.135.210.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="K0YQr6nQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=kr
	yMrCu4C1oSCLCeLEyxXWYdBtEs4BbxdSq2hr42r9Q=; b=K0YQr6nQoZLgmiq9rP
	j0+j+liRgKL51/kD4VAEj2S6C3n/q9N7FiAuQ4uskFwJViSBjXIeaY8X2XEehk5Y
	nqn/1/2VNwGvmzVgwFSfdoqTb6wPoVD7sLHxWQnJ/Vrmy4LUclkONtrSqjpCb5lL
	+eVWJqawBiowkUyDAWAsxUi6g=
Received: from localhost.localdomain (unknown [])
	by gzsmtp2 (Coremail) with SMTP id PSgvCgBH3fs7wGFqvSXGHw--.269S2;
	Thu, 23 Jul 2026 15:18:21 +0800 (CST)
From: luoqing <l1138897701@163.com>
To: marcelo.leitner@gmail.com,
	lucien.xin@gmail.com
Cc: davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	linux-sctp@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH net] sctp: fix addip_serial increment on ASCONF_ACK allocation failure
Date: Thu, 23 Jul 2026 15:18:18 +0800
Message-Id: <20260723071818.459034-1-l1138897701@163.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PSgvCgBH3fs7wGFqvSXGHw--.269S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Kw15AF48uF1DCw15tr47urg_yoW8Aw17pr
	Z3WF48trn3Zr1UArn5urWxGw1Ykan5Kw45Gr4YgrsYyanxJrySyry3Gw4Utw1jkFn5AFWj
	gryYqr47JF1YvFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07U66wtUUUUU=
X-CM-SenderInfo: jorrjmiyzxliqr6rljoofrz/xtbC3h0ydmphwD0a5wAA3M

From: Qing Luo <luoqing@kylinos.cn>

In sctp_process_asconf(), when sctp_make_asconf_ack() fails to allocate
the ASCONF_ACK chunk due to memory pressure, the code jumps to the
done label where asoc->peer.addip_serial is unconditionally incremented.

This leaves the peer's ASCONF (serial N) unacknowledged while the local
endpoint now expects serial N+1. When the peer retransmits serial N, it
falls into the serial < addip_serial + 1 branch ,
which attempts to look up a cached ACK for serial N. No cached ACK
exists since the allocation failed, so the retransmission is silently
discarded. The peer eventually times out and ABORTs the association.

Move the addip_serial increment inside the if (asconf_ack) block so that
the serial number is only advanced when the ASCONF_ACK is successfully
created and cached. This way, on allocation failure, the serial number
is unchanged and the peer's retransmitted ASCONF will be correctly
re-processed.

Fixes: 1da177e4c3f4 (Linux-2.6.12-rc2)
Signed-off-by: Qing Luo <luoqing@kylinos.cn>
---
 net/sctp/sm_make_chunk.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 8adac9e0cd66..87b5d320977b 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -3321,12 +3321,11 @@ struct sctp_chunk *sctp_process_asconf(struct sctp_association *asoc,
 			goto done;
 	}
 done:
-	asoc->peer.addip_serial++;
-
 	/* If we are sending a new ASCONF_ACK hold a reference to it in assoc
 	 * after freeing the reference to old asconf ack if any.
 	 */
 	if (asconf_ack) {
+		asoc->peer.addip_serial++;
 		sctp_chunk_hold(asconf_ack);
 		list_add_tail(&asconf_ack->transmitted_list,
 			      &asoc->asconf_ack_list);
-- 
2.25.1

