Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=117.135.210.2
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794192172;
	b=MLY3N5O1JLxic1BW8p8qKAsP+BXeA6smlhQxvxykXJEPsMiZPGhSDW1yzb+WdzVxExrZ
	 0xnY5eHUMgO67FsOCRt4f/x6QKuYlIlo3PwwcaowObmoZpsjckcpjcepymRaj7gJoG3mi
	 TH1YUxVlD3PR72zm0sIjM3FClRiosNUPJqSNI6xQ2/BPgc1ijO1lcM86uNiBEv6qDieuj
	 QgiEOQ7OwfZ4C/feUiGqa9GT6YqIz1w1Aj90GqR2+As048Y/Qq33/uU0Db5iaEDt3VU/J
	 NNTXGcifzKJ6QxYszk7b7SiGs7V5ung+Xy+slXz/hCuFz9ex/qHCdtfU8Bsb8i3GI/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794192172;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-CM-TRANSID:X-Coremail-Antispam:X-CM-SenderInfo;
	bh=4ZD1HzBAczl7IU1PtRM9yDehp3DVa/ilO4eu9zsq+xQ=;
	b=ZsIexzlpb9DdbRcqmD00/an4EQNjVAqikj39AsDEA34sM5hmrG/eqqvTE/7gZaJWFWwT
	 JZ0IYkhd7CgiQlGBpHYH6WEcXnFsrgfgNkidqqswAED+utsEH4uUw7u5gKOC6oaLsiiSW
	 FcF2OFDAtBJjsSiS2AO3ElWn/ETwIpP/c9Q7ZuK+orqOZqbAntACdwNppe+5XLd6+IGN6
	 k3cVo1OF4d3fan5rtXvPek5xXka1Pu0XmWlgVhVYDA1k3f+k9z82ZBslNAvIjGf5Le77S
	 68Ymugn9T0DI97cORUumQNBti5y98+4guo3w0joSMBNLL7fPcvYkenb6qc43TbYpO8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=IligXMQJ;
	arc=none smtp.remote-ip=117.135.210.2
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2139A606A31C;
	Mon,  9 Nov 2026 02:42:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2139A606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=IligXMQJ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=4Z
	D1HzBAczl7IU1PtRM9yDehp3DVa/ilO4eu9zsq+xQ=; b=IligXMQJleodfk/cIi
	Ui+gAfRJ8oCPCpFW0zu+ZsbZyqEOkwx3RbeGnOOydN5wRLCCOqwBSi5wQiFX969n
	yr8EmybHXMjbEMnzcG41CywPfBq6yv6RR8KsmVQa9BcJhgKFz2podw0k53zI489Q
	sZkLantXt5RJyO7j3j1oEzfCk=
Received: from colol4bi5.localdomain (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wDnH4MPM_FqYjHEGA--.39027S2;
	Mon, 09 Nov 2026 10:42:24 +0800 (CST)
From: Binbin Deng <18983559317@163.com>
To: marcelo.leitner@gmail.com,
	lucien.xin@gmail.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org
Cc: linux-sctp@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Binbin Deng <18983559317@163.com>
Subject: [PATCH v2] sctp: fix race between addr_wq timer handler and backlog draining
Date: Mon,  9 Nov 2026 10:42:18 +0800
Message-ID: <20261109024219.347985-1-18983559317@163.com>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Post: <mailto:linux-sctp@vger.kernel.org>
List-Help: <mailto:linux-sctp+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sctp+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDnH4MPM_FqYjHEGA--.39027S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxGw1UKF17Ww1kJw13Xw1kKrg_yoWrWw4DpF
	WYgw4YyF4DJr1YqFn5AF4vgryrur48W3y7Ga47KwsYyanFqrnYgFyUKrW5tF4UKFsFqay7
	Zr4qgr45AF4DJFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pimhF7UUUUU=
X-CM-SenderInfo: jprymmytvvmjmrxbiqqrwthudrp/xtbC4BDny2rxMxDkjAAA3M

sctp_addr_wq_timeout_handler() walks net->sctp.auto_asconf_splist and,
holding only bh_lock_sock(), calls sctp_asconf_mgmt() on every
auto-asconf socket. Unlike every other asynchronous SCTP entry point
(sctp_rcv() queuing packets to the backlog, and the timer handlers in
sctp_sm_side_effect()), it does not check sock_owned_by_user() to defer
its work while a user context owns the socket.

While a user thread owns the socket (e.g. recvmsg() blocked in a copy
to user, or release_sock() draining the backlog), sk_lock.owned is set
but the socket spinlock has been dropped, so bh_lock_sock() succeeds
and the timer enters

    sctp_asconf_mgmt() -> sctp_send_asconf_add/del_ip() -> sctp_do_sm()

concurrently with the backlog drain path

    release_sock() -> __release_sock() -> sk_backlog_rcv()
      -> sctp_assoc_bh_rcv() -> sctp_do_sm()

Two state machines then run on the same association with no common
serialization and mutate shared state concurrently: the outqueue
control chunk list, transport->packet.chunk_list and packet->auth, and
the transport/dst lifetime.

The bug was found by code review of this timer entry point against the
sock_owned_by_user() avoidance used by all other SCTP asynchronous
entries, and confirmed with a reproducer that races an RTM_DELADDR
address event against a user-owned auto-asconf socket. It triggers the
following, observed with KASAN and refcount debugging:

  - rcuref "imbalanced put()" from dst_release() in
    sctp_transport_route() racing the timer's transport routing,
  - a GPF in sctp_packet_transmit() dereferencing a chunk pointer
    corrupted by concurrent packet/chunk list use, and
  - associations dying silently (ETIMEDOUT, GET_PEER_ADDRS failure).

Defer the work like the other entries do: if the socket is owned by
the user, stop processing, leave the addr_waitq entry queued and
re-arm addr_wq_timer to retry after SCTP_ADDRESS_TICK_DELAY. The
retry is merged with the existing IPv6 DAD retry into a single
mod_timer() outside the loops. Sockets processed earlier for the same
address event will see a duplicate ASCONF on retry; the peer reports
that in an ASCONF-ACK error indication, which the association
tolerates.

Fixes: 9f7d653b67ae ("sctp: Add Auto-ASCONF support (core).")
Signed-off-by: Binbin Deng <18983559317@163.com>
---
 net/sctp/protocol.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index 27c26e12f95d..267dc9b7a0e7 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -603,6 +603,7 @@ static void sctp_addr_wq_timeout_handler(struct timer_list *t)
 	struct net *net = timer_container_of(net, t, sctp.addr_wq_timer);
 	struct sctp_sockaddr_entry *addrw, *temp;
 	struct sctp_sock *sp;
+	bool retry = false;
 
 	spin_lock_bh(&net->sctp.addr_wq_lock);
 
@@ -624,15 +625,12 @@ static void sctp_addr_wq_timeout_handler(struct timer_list *t)
 			in6 = (struct in6_addr *)&addrw->a.v6.sin6_addr;
 			if (ipv6_chk_addr(net, in6, NULL, 0) == 0 &&
 			    addrw->state == SCTP_ADDR_NEW) {
-				unsigned long timeo_val;
 
 				pr_debug("%s: this is on DAD, trying %d sec "
 					 "later\n", __func__,
 					 SCTP_ADDRESS_TICK_DELAY);
 
-				timeo_val = jiffies;
-				timeo_val += msecs_to_jiffies(SCTP_ADDRESS_TICK_DELAY);
-				mod_timer(&net->sctp.addr_wq_timer, timeo_val);
+				retry = true;
 				break;
 			}
 		}
@@ -645,16 +643,27 @@ static void sctp_addr_wq_timeout_handler(struct timer_list *t)
 			if (!sctp_is_ep_boundall(sk))
 				continue;
 			bh_lock_sock(sk);
+			if (sock_owned_by_user(sk)) {
+				bh_unlock_sock(sk);
+				retry = true;
+				break;
+			}
 			if (sctp_asconf_mgmt(sp, addrw) < 0)
 				pr_debug("%s: sctp_asconf_mgmt failed\n", __func__);
 			bh_unlock_sock(sk);
 		}
+		if (retry)
+			break;
 #if IS_ENABLED(CONFIG_IPV6)
 free_next:
 #endif
 		list_del(&addrw->list);
 		kfree(addrw);
 	}
+
+	if (retry)
+		mod_timer(&net->sctp.addr_wq_timer,
+			jiffies + msecs_to_jiffies(SCTP_ADDRESS_TICK_DELAY));
 	spin_unlock_bh(&net->sctp.addr_wq_lock);
 }
 
-- 
2.43.0

