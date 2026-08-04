Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87F2339CCF3;
	Tue,  4 Aug 2026 08:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785833063; cv=none; b=T1knGNVTQ2be4uFy0d4u76zMIbPJ8L/aXeEkG0h9IGY2ALFiNqxBOivwM0kHbst0aK50w8OsLaoyO+Ad5vYdK8px82JIC7Wvs7MWsEVZ30WZcET80/iZpz0qpSN2F49CYuLMxcQby2kExcjeCthatALwES1Y0di5AEQFiwtUBY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785833063; c=relaxed/simple;
	bh=yaAp/R/gMkSEUBp21YJTjtYQVAXCn7g5EQDVaXl0Oa8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=S6I7VYuRGyakF0Lga/4X4AzvV5GUyxmsAMTB+c2l1WrIUxx9O8j9dwppeKgNpt/siW/XOhOjK0Xh3t9owfwfBwySzmqp1tsMC+uu/YTFjDB3Z4MYXiaqH5n5DOa2Zi4hTXLMKLJKkVYL+xMqA2Z6U869IvjWnzjNRxLLzowHxts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=gKSF6kG3; arc=none smtp.client-ip=220.197.31.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="gKSF6kG3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=rZ
	uJVJJ4WHp1oKzmA9jHPcBkuXt8jzhliS3SwNI/FoY=; b=gKSF6kG3jbGPGzhMTt
	Mw4OLBBMQD6FApy+frgYA1bFtBs2Y8e8VLEksKw+c8JZh7nNFt/wnILO3CFubF+b
	DsLeL1njlBcs6uytf73PPifjAa6x+GT7UkCZ+ckDfMNSHjeFboAjc0ATHuFipLe9
	yy4dK4gJ2cMDky/Ad8N/V+5qY=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-3 (Coremail) with SMTP id _____wAnpF0epnFquLOxNQ--.49672S2;
	Tue, 04 Aug 2026 16:43:12 +0800 (CST)
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
	linux-kernel@vger.kernel.org
Subject: [PATCH net-next] sctp: fix use-after-free in timeout event handling
Date: Tue,  4 Aug 2026 16:43:10 +0800
Message-Id: <20260804084310.818056-1-l1138897701@163.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wAnpF0epnFquLOxNQ--.49672S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7ZFWDtryUZr4rKF4furW8tFb_yoW8Zr15p3
	yYka93KF1DJr12qF4fAF4kJa4fuan7K39xJFyYvr1fAan5try0gFW3trZ8KFWDJr4kJFyF
	qF1DK3y3Ar4DZFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jj4EiUUUUU=
X-CM-SenderInfo: jorrjmiyzxliqr6rljoofrz/xtbC3QCo7GpxpiB2GwAA3p

From: Qing Luo <luoqing@kylinos.cn>

sctp_do_sm() in sctp_generate_timeout_event() may process an
SCTP_CMD_ASSOC_FAILED command, which calls sctp_association_free() and
drops the last reference, freeing the association and its socket while
the timer callback is still running. The callback then dereferences the
freed sk and asoc, a use-after-free.

Hold an extra reference on the association at the start of the callback
so both it and its socket stay alive until we are done, and release it
at out_unlock along with the timer's reference. Also only set sk->sk_err
while the association is still alive.

Assisted-by: LLM
Signed-off-by: Qing Luo <luoqing@kylinos.cn>
---
 net/sctp/sm_sideeffect.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
index 424f10a6fdba..f384c2faf1c4 100644
--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -275,6 +275,12 @@ static void sctp_generate_timeout_event(struct sctp_association *asoc,
 	int error = 0;
 
 	bh_lock_sock(sk);
+
+	/* Take an extra ref to keep asoc alive through sctp_do_sm().
+	 * The timer already holds one ref; we'll release both at out_unlock.
+	 */
+	sctp_association_hold(asoc);
+
 	if (sock_owned_by_user(sk)) {
 		pr_debug("%s: sock is busy: timer %d\n", __func__,
 			 timeout_type);
@@ -296,13 +302,13 @@ static void sctp_generate_timeout_event(struct sctp_association *asoc,
 			   SCTP_ST_TIMEOUT(timeout_type),
 			   asoc->state, asoc->ep, asoc,
 			   (void *)timeout_type, GFP_ATOMIC);
-
-	if (error)
+	if (!asoc->base.dead && error)
 		sk->sk_err = -error;
 
 out_unlock:
 	bh_unlock_sock(sk);
-	sctp_association_put(asoc);
+	sctp_association_put(asoc); 	/* release timer's ref */
+	sctp_association_put(asoc);	/* release our extra ref */
 }
 
 static void sctp_generate_t1_cookie_event(struct timer_list *t)
-- 
2.25.1

