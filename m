Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E52263BBA09;
	Thu, 16 Jul 2026 10:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784196297; cv=none; b=mvhCIY/Vag21ZW9Vn6aTgmdeSbnKFrMy3SHJ6etrdm/n7ZGwbiXTR2626IwrW939YS7UqfP44Nr3puTgxZxUZf4qPrKI+6/p/cl9HOLYuERfmYB5ZnMiuHMK3CAp+J31nWP62vr7TtX+qqx1p2WeHGJxdO2w2Ln/GeqO/kBB8ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784196297; c=relaxed/simple;
	bh=VxJOqaYjc96ux6auGLRa1m88ed/8mIVND1Ty92dCe6k=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=GuA9LOj9rWURqQWZJvP388yn65SSIRTEpfE9K2FUfSKE+TlHIfXw7NxugUt0JipdcTPCBh0j13UoQtDXE1sUqEpfsWVNzRTEwfEMckf3g2j6WdZnQAa7HvyEXdfanW0wSbhMHpkxY64esdRlY4uiyaYgIpG/L5utzDxRDkvBHp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=KUdus9tJ; arc=none smtp.client-ip=117.135.210.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="KUdus9tJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=Xb
	dUoFETFx3sxFfOWnV3nSITFAjfBNTVmvkCQ5jOhSo=; b=KUdus9tJsfmkXZT3HS
	BYQwj2L9KNivfq2ivv+ynb1lFvEewgpyQSbUraDlbXYOBolrmssu8IGi0q3qHa+k
	tyIkCGisSHQ1CfJKNIj1/9vqf81mtDoFRGnTHh5qR4JqoRBdIqOtV9Lq3aMSqFwl
	8M9PO/RDLtAK3Ra/bYebdsuZQ=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-3 (Coremail) with SMTP id _____wC3ou+XrFhqiTS8Ig--.46S2;
	Thu, 16 Jul 2026 18:04:10 +0800 (CST)
From: luoqing <l1138897701@163.com>
To: marcelo.leitner@gmail.com,
	lucien.xin@gmail.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com
Cc: horms@kernel.org,
	linux-sctp@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	luoqing@kylinos.cn
Subject: [PATCH v2 1/2] net: sctp: socket: Fix uninitialized error on socket shutdown
Date: Thu, 16 Jul 2026 18:04:06 +0800
Message-Id: <20260716100407.1490724-1-l1138897701@163.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wC3ou+XrFhqiTS8Ig--.46S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrZF47Cw4UGryrWFW3AFyUtrb_yoWkKrb_u3
	y8u3W7Za45Wrsakan5Cr4YyrWvyw43KFyI9ryktF9rG348GFZ7trWDAFnavr1xGrZa9r1D
	Jw1YyF95Za1fCjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU8jhF3UUUUU==
X-CM-SenderInfo: jorrjmiyzxliqr6rljoofrz/xtbC+hoCRmpYrJq4vwAA3n

From: luoqing <luoqing@kylinos.cn>

When sctp_skb_recv_datagram() detects sk->sk_shutdown & RCV_SHUTDOWN,
it breaks out of the loop and returns NULL without setting *err.
This leaves the error pointer uninitialized or with a stale value,
which can confuse callers expecting a clean shutdown indication.

Compare with the generic __skb_wait_for_more_packets() in
net/core/datagram.c which properly handles shutdown by setting *err = 0.

Fix this by setting *err = 0 before breaking when the socket is shut down,
indicating an orderly shutdown rather than an error condition.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")

Signed-off-by: luoqing <luoqing@kylinos.cn>
---
 net/sctp/socket.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index c7b9e325ec1c..ea7050b27715 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -9117,8 +9117,10 @@ struct sk_buff *sctp_skb_recv_datagram(struct sock *sk, int flags, int *err)
 		if (error)
 			goto no_packet;
 
-		if (sk->sk_shutdown & RCV_SHUTDOWN)
+		if (sk->sk_shutdown & RCV_SHUTDOWN) {
+			*err = 0;
 			break;
+		}
 
 
 		/* User doesn't want to wait.  */
-- 
2.25.1

