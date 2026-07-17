Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EFBE1ADC83;
	Fri, 17 Jul 2026 08:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784276629; cv=none; b=OSLkdKDxvskyDvSJAe6Gl78jpORq+DBLrZb8fieoHXOIomI2LI0XEIU6hrGm1cAEWCVfNgdCN9VRID6KdPoF1adL5qAcsVCJxj3po0SSm03hC23RUvHRv36P6MTj0lLEAJIHNP4/uuCcwm9+gpYEVw4ufstXHrVZUtw2d9fKIpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784276629; c=relaxed/simple;
	bh=u8FeOgGeidjBCoK8aCLS4fOTF/iMCUlPpDkwe0d7uDo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RrOMTk9Az5dsLeT4R6A37Ayjs4SsjFEvGnLyIMbX/7ZGHO/jF03qIt9CbA0CcDLlTPVMQ439AJM1OmLi3j5joAKeUE/8L80BlvX/IdskwLECPp78BSRAJy9T3RwmHsTJap32PeK8ilyo2u6hBpIwdYUfBaNSXOpVTYebbqgLXlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=IEc/OFEF; arc=none smtp.client-ip=220.197.31.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="IEc/OFEF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=cr
	e3/aFEzBTHrCFjylFi0Gqb5tPfLro6l4NFdHJ/+DQ=; b=IEc/OFEFYWp23mpvx9
	h+kCjNW4ixEt2rhP/2sd2g/zLFpZ85tfbDCOyNIG5GTWkIhj249QdqIEfmPoS1Ph
	PjRA4mM4HSNtgZVDmML8+V2/9IRsgwLk6q8djafIJ/HM85Y1Fl54hq6Lx6HVuq6c
	NHvxjeSzurC73RP/HEIDXNwn8=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-4 (Coremail) with SMTP id _____wCHBNnh5VlqHENqKQ--.41694S2;
	Fri, 17 Jul 2026 16:20:51 +0800 (CST)
From: luoqing <l1138897701@163.com>
To: jedrzej.jagielski@intel.com
Cc: davem@davemloft.net,
	edumazet@google.com,
	horms@kernel.org,
	kuba@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-sctp@vger.kernel.org,
	lucien.xin@gmail.com,
	luoqing@kylinos.cn,
	marcelo.leitner@gmail.com,
	netdev@vger.kernel.org,
	pabeni@redhat.com
Subject: [PATCH net v3] sctp: socket: remove unused 'err' parameter from sctp_skb_recv_datagram
Date: Fri, 17 Jul 2026 16:20:48 +0800
Message-Id: <20260717082048.948262-1-l1138897701@163.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <PH0PR11MB5902DBD696C30DB0A2308A49F0C72@PH0PR11MB5902.namprd11.prod.outlook.com>
References: <PH0PR11MB5902DBD696C30DB0A2308A49F0C72@PH0PR11MB5902.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wCHBNnh5VlqHENqKQ--.41694S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxWr1fAFyDXrW7tw45AF47Arb_yoW5Cry7pF
	n8AFW5ArWDJrW8uwnakFZ7J3WSgws5Jw15CFWrtw4Yyrs8tr9YqFy8KF4SkF45Cr4Yka4Y
	qr1qgw13KrnxCFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UfDGrUUUUU=
X-CM-SenderInfo: jorrjmiyzxliqr6rljoofrz/xtbC3QOi5mpZ5eM2vwAA3m

From: luoqing <luoqing@kylinos.cn>

The 'err' parameter in sctp_skb_recv_datagram() is never used by any
of its callers. Both sctp_recvmsg() and sctp_ulpevent_read_nxtinfo()
pass the address of a local variable but never check its value after
the function returns, rendering the parameter completely useless.

Remove the unused parameter to simplify the function signature and
eliminate dead code.

Signed-off-by: luoqing <luoqing@kylinos.cn>
---
 include/net/sctp/sctp.h |  2 +-
 net/sctp/socket.c       | 10 +++-------
 net/sctp/ulpevent.c     |  3 +--
 3 files changed, 5 insertions(+), 10 deletions(-)

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
index c7b9e325ec1c..3804382d78e0 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -2123,7 +2123,7 @@ static int sctp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 		goto out;
 	}
 
-	skb = sctp_skb_recv_datagram(sk, flags, &err);
+	skb = sctp_skb_recv_datagram(sk, flags);
 	if (!skb)
 		goto out;
 
@@ -9082,7 +9082,7 @@ static int sctp_wait_for_packet(struct sock *sk, int *err, long *timeo_p)
  * Note: This is pretty much the same routine as in core/datagram.c
  * with a few changes to make lksctp work.
  */
-struct sk_buff *sctp_skb_recv_datagram(struct sock *sk, int flags, int *err)
+struct sk_buff *sctp_skb_recv_datagram(struct sock *sk, int flags)
 {
 	int error;
 	struct sk_buff *skb;
@@ -9120,17 +9120,13 @@ struct sk_buff *sctp_skb_recv_datagram(struct sock *sk, int flags, int *err)
 		if (sk->sk_shutdown & RCV_SHUTDOWN)
 			break;
 
-
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
 	return NULL;
 }
 
diff --git a/net/sctp/ulpevent.c b/net/sctp/ulpevent.c
index 8920ca92a011..8ed51a15c3a4 100644
--- a/net/sctp/ulpevent.c
+++ b/net/sctp/ulpevent.c
@@ -1061,9 +1061,8 @@ void sctp_ulpevent_read_nxtinfo(const struct sctp_ulpevent *event,
 				struct sock *sk)
 {
 	struct sk_buff *skb;
-	int err;
 
-	skb = sctp_skb_recv_datagram(sk, MSG_PEEK | MSG_DONTWAIT, &err);
+	skb = sctp_skb_recv_datagram(sk, MSG_PEEK | MSG_DONTWAIT);
 	if (skb != NULL) {
 		__sctp_ulpevent_read_nxtinfo(sctp_skb2event(skb),
 					     msghdr, skb);
-- 
2.25.1

