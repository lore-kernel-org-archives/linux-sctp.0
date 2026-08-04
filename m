Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04B3B35838E;
	Tue,  4 Aug 2026 02:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785812158; cv=none; b=Su4pgKRtaLckdU1k9qjoi3zd3/Fj9TsGhKlaXSpiIDgd7HOY4UJERT+/pr0+Y6y9acVdoPCKBbhNqhD+kbEdkhJ5LvZDHz/uFUu9DNXBiTgwXTgMvbkZDy2OC3c4weFQa6aeov3/9S9Pa/nxLkyaucd3585vb97eBOb6Zjn39zM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785812158; c=relaxed/simple;
	bh=UwDl4R3cZ1wPyAKE9kk0VMdRV3AzShHTLvcH1XhOpf0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=o47e83ePufTT8m5CPAOR5+CxC7kktEqqwBD9nH9sRH+c+G5FlSERfbCbZkj5ie9pWc2SziCxvRd6bobKpCeoVRPjJpc7YNsh6rOk+e20zX2jakWV6fVnNJriozC4UQx7fn8B0nvYe3vjp+NkeEjgsncJ6TOcEJUcB2bVvdIvsaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=UPrt2gXL; arc=none smtp.client-ip=117.135.210.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="UPrt2gXL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=mk
	4MQDhnrxXqGFitsTvlsVF7npFqLHGF3eQ7yqlGUlE=; b=UPrt2gXLFK8TZZz4yl
	5EQ8zl4s6BeTHsm4690C6mJyNTf60zcQ5nWABwWTdeJY069oC/g0sH0kwWV/0WK7
	see9Enw8Ie1likLasfUe+8GHj2Qm+z1kIGtGv3VoH8JSzyNuSeEd4Ni8sVQaXAoE
	jrHh03ax25WYhMlXEkN0JOCI4=
Received: from localhost.localdomain (unknown [])
	by gzsmtp4 (Coremail) with SMTP id PygvCgBXLs6SVHFqaVhsKg--.51731S2;
	Tue, 04 Aug 2026 10:55:16 +0800 (CST)
From: luoqing <l1138897701@163.com>
To: l1138897701@163.com
Cc: davem@davemloft.net,
	edumazet@google.com,
	horms@kernel.org,
	kuba@kernel.org,
	linux-sctp@vger.kernel.org,
	lucien.xin@gmail.com,
	marcelo.leitner@gmail.com,
	netdev@vger.kernel.org,
	pabeni@redhat.com
Subject: [PATCH net v2] sctp: fix addip_serial increment on ASCONF_ACK allocation failure
Date: Tue,  4 Aug 2026 10:55:14 +0800
Message-Id: <20260804025514.241767-1-l1138897701@163.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260723071818.459034-1-l1138897701@163.com>
References: <20260723071818.459034-1-l1138897701@163.com>
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PygvCgBXLs6SVHFqaVhsKg--.51731S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Kw15AF48uF1DCw15tr47urg_yoW8Cw13pr
	WSgr48twn3Xr1UArs5u3yxKw4Ykan5Kw43Gr4YgrsYyanxJryS9ry3Gw4Dt3WjkFn5AFWj
	gryYqr47JF1YvFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0JUUhL8UUUUU=
X-CM-SenderInfo: jorrjmiyzxliqr6rljoofrz/xtbC3hQxdWpxVJRc4QAA3o

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

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Qing Luo <luoqing@kylinos.cn>
---
 net/sctp/sm_make_chunk.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index c02809264075..30c0da27430e 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -3327,12 +3327,11 @@ struct sctp_chunk *sctp_process_asconf(struct sctp_association *asoc,
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
> nit: missing quotation marks around the subject
> LGTM, except the nit Jakub pointed out.
Correct the code formatting

