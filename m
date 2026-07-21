Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9B4A400990;
	Tue, 21 Jul 2026 02:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784600775; cv=none; b=qIwEK/AQ9If1Lk6RXiSXyYyilBXyPfBAxePhfZxDKiNCv/opfMl1Q48tRpo/zy4alrmYXSDyDMh4DBcwwP3zQfZHVo94Tx8+SUwDMnZdM3D09s0QXYnYzOMRUNRbIfNaMxEPV1BHd66bclabSOlVvjEYm4cZIW98cbMIoqqtceM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784600775; c=relaxed/simple;
	bh=csN9nc/Fk+W9/o7VXwUrKsqPz6/xdMK1DSx/2jIVHnE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=aUw0Ez/4FThcSKk9hQggpEtr6DEUHnorIts1AC+tqlrnZ8nBJ65mE1Oe3CkhhwkQOqXq8mTvkb9wrlfQniKCeuJq6ZRSffaixMzyoVcj2yj9onphpX0huAfTsrxQM89otHoEOXQblHWFxwqmyCG1+LO4Fn4oGRviKTCWcblXR3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=g2VsBu7S; arc=none smtp.client-ip=220.197.31.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="g2VsBu7S"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version:
	Content-Type; bh=x0IcHSv9W/Yq+myep3UwQEGkRffz0hgPt6rbcqKY/08=;
	b=g2VsBu7SmDy8WeYwYKwS2mH/213ybJTzRmzKKmnVoUNPjz35vUHuTA3l64mtpp
	I+4cULj3sRkF4xvVNV28yOLhcTppFD8cXlr5ggIYBg6SFBhKHXiMpGHUMFtj3/pq
	VIJDMVflAHqPgUDHkHprfhqgrP/e4luvWwpVuElivveG8=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-4 (Coremail) with SMTP id _____wA3wpOS2F5q9u4KLA--.38248S2;
	Tue, 21 Jul 2026 10:25:24 +0800 (CST)
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
Subject: [PATCH net-next v4] sctp: socket: set *err = 0 on receive shutdown
Date: Tue, 21 Jul 2026 10:25:22 +0800
Message-Id: <20260721022522.178618-1-l1138897701@163.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wA3wpOS2F5q9u4KLA--.38248S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7uF4rtr15AF4kZFy5AryxZrb_yoW8AF47pr
	4xCF4DJrWkJry8ZFs7KF4xJ3W5K395Aw4fAayUWw4akrs8GF98Kw15tF1akF17uF4rWay0
	vr1qq3W3W3WkuFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07Uq-erUUUUU=
X-CM-SenderInfo: jorrjmiyzxliqr6rljoofrz/xtbC3hSN0Wpe2JRCkAAA38

From: Qing Luo <luoqing@kylinos.cn>

When sctp_skb_recv_datagram() detects RCV_SHUTDOWN, it breaks out
of the loop and returns NULL without setting *err. While current
callers happen to work correctly (sctp_recvmsg pre-initializes
err to 0, sctp_ulpevent_read_nxtinfo doesn't use err), this is
inconsistent with the generic __skb_wait_for_more_packets() in
net/core/datagram.c which explicitly sets *err = 0 on shutdown.

Set *err = 0 explicitly for correctness and robustness against
future callers.

Signed-off-by: Qing Luo <luoqing@kylinos.cn>
---
 net/sctp/socket.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index c7b9e325ec1c..b8ec295e3a2f 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -9117,9 +9117,10 @@ struct sk_buff *sctp_skb_recv_datagram(struct sock *sk, int flags, int *err)
 		if (error)
 			goto no_packet;
 
-		if (sk->sk_shutdown & RCV_SHUTDOWN)
+		if (sk->sk_shutdown & RCV_SHUTDOWN) {
+			*err = 0;
 			break;
-
+		}
 
 		/* User doesn't want to wait.  */
 		error = -EAGAIN;
-- 
2.25.1
Thanks for the review.

On reflection, I agree that the ERR_PTR refactoring should be dropped. Honestly, the refactored version ends up being more convoluted rather than simplifying things, so I’ll revert to the original &err interface to keep it consistent with skb_recv_datagram().

Regarding the *err = 0 fix for the shutdown path — my intention there was purely defensive, aligning with the pattern used in __skb_wait_for_more_packets(). As the commit message notes, the current callers are not actually affected by this, so no real bug is introduced. That said, if you feel this change is still unnecessary, I’m happy to drop it as well.

