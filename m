Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B8061DF980;
	Thu, 16 Jul 2026 06:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784184819; cv=none; b=FmoZOJ3z3CtdeX6skEvzevHqhII5g9wWnKzZpOfdiRriUvpj5OrWBfwxSmdVsm6LC6gYiK5TcqINnl8UctQeDHKlLQCXvPC500lAST0f4P9xoHIxwWWfN1XLJtSBtByJ9DzFrYT0KfLdSh7cAgSmEmHvX1cHAcwV0ZLAfxesYVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784184819; c=relaxed/simple;
	bh=zciyxj/UN8rWdlhPhkwBTB8aXRbmFaHm23TrGfa/Uy8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=R0COMNVIIDAtL5XoJaJze/AVjDk+z8FMe9/V0UDq0hzEi4MuGbStSHpgbugU0W27Ewcx8clseRZxDk1lKPIc3VWYFo33ZLL93us/UE6dw/+e0uFcDuL//m9GJhwIT9CjlhgJ56QeNPsgvBouviEbaK3MSP/V9ka7BrLCt1en980=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=hPZMW34O; arc=none smtp.client-ip=220.197.31.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="hPZMW34O"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=zB
	RjiWlR8lFZKYe3JDeeWXbqOqqhYa+7Qn2akp1nBMw=; b=hPZMW34OsYFVQsGjN3
	Cxw5kUD7qCoheTMujxbecp9iQrr0QaafOtR2jlQ4JQAN4Rpihwy4uJ9wulUIBNzn
	I7SfrGpRCLJpqf33pUEw1r9qJzIHM1R9qJYZra3Cd0u1VwP3XiwPDLtPNdr9SuaB
	N1eXq7skAZAEEvgHM78TRZdao=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-4 (Coremail) with SMTP id _____wC3B9DLf1hq05eSKA--.10495S2;
	Thu, 16 Jul 2026 14:53:00 +0800 (CST)
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
Subject: [PATCH 1/2] sctp: socket: Fix uninitialized error on socket shutdown
Date: Thu, 16 Jul 2026 14:52:58 +0800
Message-Id: <20260716065259.872235-1-l1138897701@163.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wC3B9DLf1hq05eSKA--.10495S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrZF47Cw4UGryrWFW3AFyUtrb_yoWkCrg_u3
	y093WxZa45WrsIyan5Cr45ArWvyw43KFyI9r97tF9rG348Ja97trWDAFnavr1xGrZa9rn8
	Jw1YvF95Aa1fujkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU8jsj5UUUUU==
X-CM-SenderInfo: jorrjmiyzxliqr6rljoofrz/xtbC+QzDCGpYf8wbCgAA3u

From: luoqing <luoqing@kylinos.cn>

When sctp_skb_recv_datagram() detects sk->sk_shutdown & RCV_SHUTDOWN,
it breaks out of the loop and returns NULL without setting *err.
This leaves the error pointer uninitialized or with a stale value,
which can confuse callers expecting a clean shutdown indication.

Compare with the generic __skb_wait_for_more_packets() in
net/core/datagram.c which properly handles shutdown by setting *err = 0.

Fix this by setting *err = 0 before breaking when the socket is shut down,
indicating an orderly shutdown rather than an error condition.

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

