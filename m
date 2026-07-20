Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 770A63CC7CD;
	Mon, 20 Jul 2026 08:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784535749; cv=none; b=UTRTDXs3DkInU3FgyP5qSB8ld9T29xkDJuseqf94G4gujlJ/mnLsNVOtLkLFVuL+Uq5iyzklvIDz5GL9cZ/Ixw9WUvJHKfxnKq6IsUhWiYBZXQFNvGG7El5Dnk9qltxSziPT0JglRnfvSCJOq8guBWZ1H/f8O1Tz1aTejJ92idc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784535749; c=relaxed/simple;
	bh=ySEwroPRb5DHlyaq4soxUzkTKQt+T8Sec43Br85Lu5M=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=p/FuMtgZhd/M13x7hKW4qETvDNdr+y8mFJwHpUGfR3XLI4lc1tLFRtGXP8SnIBUGQ9GeX4oU2HqcwX3S6ZoKYW/WE1QxNaW54QYtzyWib9xo1KM0ZtRn6TVd8K9cfX2I2mHNZxfNfquejYJRJcXPRmY2ycNRV/5W5yeCgWZ5XZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=CrlMW0M0; arc=none smtp.client-ip=220.197.31.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="CrlMW0M0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=Jc
	wHsY5zypMELrWEKa1Ep6tVBSBTsXsnGhc31N6FYz0=; b=CrlMW0M01HTlIiij65
	UHL8aGC2hXrF+dEtvVZFYPXp0ehPe+lR+q6SMMWaqRG3Mml8GpWxfSY5O5h8s+Jc
	P07C8PpQh4EnzTtUyaVCKUa53E/u4hhALhvs/bnERTCz6t/b05aX48pUadxJ5wJV
	NZG6lCbb0PtmwIPMv6UFte8Po=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-3 (Coremail) with SMTP id _____wCnM1uZ2l1qpi5jKg--.47708S2;
	Mon, 20 Jul 2026 16:21:46 +0800 (CST)
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
Subject: [PATCH net v4] sctp: socket: refactor sctp_skb_recv_datagram to use ERR_PTR
Date: Mon, 20 Jul 2026 16:21:45 +0800
Message-Id: <20260720082145.1072547-1-l1138897701@163.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wCnM1uZ2l1qpi5jKg--.47708S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxXw18ZryUCF4Duw4ruFyrtFb_yoWrGrW3pF
	n8AFZ8JrWDJrW8uwnakFWkX3WrK3yrJ3y5Ca4rtw1Fyrs8Gr95tFyYgr4SkF45Cr4rCa4a
	qr4qgw1akrnruFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UDxhJUUUUU=
X-CM-SenderInfo: jorrjmiyzxliqr6rljoofrz/xtbC3hrOE2pd2poyVwAA3L

From: Qing Luo <luoqing@kylinos.cn>

The err output parameter in sctp_skb_recv_datagram() is passed to
callers but never validated, making error reporting unreliable.
Remove it and use ERR_PTR to encode errors directly in the return
value, which is the standard kernel pattern for this case.

Signed-off-by: Qing Luo <luoqing@kylinos.cn>
---
 include/net/sctp/sctp.h |  2 +-
 net/sctp/socket.c       | 20 ++++++++++----------
 net/sctp/ulpevent.c     |  5 ++---
 3 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
index d50c27812504..b86d50d6b146 100644
--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -97,7 +97,7 @@ void sctp_sock_rfree(struct sk_buff *skb);
 
 extern struct percpu_counter sctp_sockets_allocated;
 int sctp_asconf_mgmt(struct sctp_sock *, struct sctp_sockaddr_entry *);
-struct sk_buff *sctp_skb_recv_datagram(struct sock *, int, int *);
+struct sk_buff *sctp_skb_recv_datagram(struct sock *sk, int flags);
 
 typedef int (*sctp_callback_t)(struct sctp_endpoint *, struct sctp_transport *, void *);
 void sctp_transport_walk_start(struct rhashtable_iter *iter);
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index c7b9e325ec1c..2deaa498e6cf 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -2123,9 +2123,11 @@ static int sctp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 		goto out;
 	}
 
-	skb = sctp_skb_recv_datagram(sk, flags, &err);
-	if (!skb)
+	skb = sctp_skb_recv_datagram(sk, flags);
+	if (IS_ERR(skb)) {
+		err = PTR_ERR(skb);
 		goto out;
+	}
 
 	/* Get the total length of the skb including any skb's in the
 	 * frag_list.
@@ -9082,7 +9084,7 @@ static int sctp_wait_for_packet(struct sock *sk, int *err, long *timeo_p)
  * Note: This is pretty much the same routine as in core/datagram.c
  * with a few changes to make lksctp work.
  */
-struct sk_buff *sctp_skb_recv_datagram(struct sock *sk, int flags, int *err)
+struct sk_buff *sctp_skb_recv_datagram(struct sock *sk, int flags)
 {
 	int error;
 	struct sk_buff *skb;
@@ -9117,21 +9119,19 @@ struct sk_buff *sctp_skb_recv_datagram(struct sock *sk, int flags, int *err)
 		if (error)
 			goto no_packet;
 
-		if (sk->sk_shutdown & RCV_SHUTDOWN)
+		if (sk->sk_shutdown & RCV_SHUTDOWN) {
+			error = 0;
 			break;
-
+		}
 
 		/* User doesn't want to wait.  */
 		error = -EAGAIN;
 		if (!timeo)
 			goto no_packet;
-	} while (sctp_wait_for_packet(sk, err, &timeo) == 0);
-
-	return NULL;
+	} while (sctp_wait_for_packet(sk, &error, &timeo) == 0);
 
 no_packet:
-	*err = error;
-	return NULL;
+	return ERR_PTR(error);
 }
 
 /* If sndbuf has changed, wake up per association sndbuf waiters.  */
diff --git a/net/sctp/ulpevent.c b/net/sctp/ulpevent.c
index 8920ca92a011..21ae0adbaeef 100644
--- a/net/sctp/ulpevent.c
+++ b/net/sctp/ulpevent.c
@@ -1061,10 +1061,9 @@ void sctp_ulpevent_read_nxtinfo(const struct sctp_ulpevent *event,
 				struct sock *sk)
 {
 	struct sk_buff *skb;
-	int err;
 
-	skb = sctp_skb_recv_datagram(sk, MSG_PEEK | MSG_DONTWAIT, &err);
-	if (skb != NULL) {
+	skb = sctp_skb_recv_datagram(sk, MSG_PEEK | MSG_DONTWAIT);
+	if (!IS_ERR_OR_NULL(skb)) {
 		__sctp_ulpevent_read_nxtinfo(sctp_skb2event(skb),
 					     msghdr, skb);
 		/* Just release refcount here. */
-- 
2.25.1
>> I think it's used at [1] in sctp_recvmsg():
>>
>>         skb = sctp_skb_recv_datagram(sk, flags, &err);
>>         if (!skb)
>>                 goto out;
> Would it make more sense to ERR_PTR() etc ?
>
>
> 	David

Yes, you are right. The current implementation returns a negative error
code directly via err, but it would be cleaner to use ERR_PTR() to
unify the error path with other datagram receivers.

I will refactor this part in v4:
>
>
>> ...
>>
>> out:
>>         release_sock(sk);
>>         return err;   <------ [1]

