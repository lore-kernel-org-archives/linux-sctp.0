Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=220.197.31.4
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793956812;
	b=zJBUwGaFFuJY+aZd4XD9Q0IO97NwpYTHTrAMm5HQfqJYc6XjXdJqbfgPwUZqHVQlgk1F
	 ceu7tPXeQYaqvmNrfATABrXX/evktKv0r6RzksE+jBDc3Dx0ZODLXrJJKGehYOpUXQ8Ly
	 E74ALnx5RphonlVlpGpo1DB2hAdvtaWUWConfElb3Sw52u9kWSJoLWd8NMTVhKh9fHf77
	 inUqT+vmQiubf6/IwcJ7jY2PRlbLoC1dP1EQ5bJg6Zc5J3BFLMXZB8ykWgIkvXXOq9Ha3
	 RYRTCMcARw4vvO6lZavsrv/qVaSDexmgybrc/Tz2uNr4KUQp944U/pZl4QlMitZryPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793956812;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-CM-TRANSID:X-Coremail-Antispam:X-CM-SenderInfo;
	bh=9f7UCeUaSEyen1wvt0ZlaFv00Ygi0CKlI2RIzn6svjM=;
	b=jrLoP5qV2VbBm+za8uMFzhSHHcsBJq94FeXxdvqXphJ7wvpqqNpYjxRrA1ShB3gZIxuI
	 nYTTFRtLupjLI5WJGnx5vLUnLHlGom6iM2MxYIIRcCkZMnHkbP+N4JjoTFysW+I+xo9qf
	 VCFEgPuMgH0lGuwhm1rQqPqMWpAoiZxshbri5CQAI/1Q3y+KX8PhD6HH+qVPjzJdPgQzz
	 OBJphHNoppB82p09H+cmhUMtjEf/UyXKhQ5jvI57mwIA1XyzUSvsDf9m3OfLbSfd0dgWC
	 4zWXriuHs2zG3FGS5tCQEfqdnEb9QOZ9+AnfEKqWje90YuCdf3YIU71wFPBACn7UnwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=njoGhZ0D;
	arc=none smtp.remote-ip=220.197.31.4
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 567B0606A32D;
	Fri,  6 Nov 2026 09:20:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 567B0606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=njoGhZ0D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=9f
	7UCeUaSEyen1wvt0ZlaFv00Ygi0CKlI2RIzn6svjM=; b=njoGhZ0DHk923ZImYI
	4jmx2s7jFRacsjQto5P5GiW5769QMRYo3r9KcXhVS5Zsxrm9nEoH1tzQY1RX9boz
	FGB8jMrtZcIPOHgNQz0iuawXeIHdOIHhRNEx8R9Qm7PDQj0hZ6sEm5+NiFeJcqCy
	2ZDbQnh2smyXNCPofx0qco53w=
Received: from colol4bi5.localdomain (unknown [])
	by gzga-smtp-mtada-g1-3 (Coremail) with SMTP id _____wD3X_+sm+1qq0VFFQ--.340S2;
	Fri, 06 Nov 2026 17:19:42 +0800 (CST)
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
Subject: [PATCH v1] sctp: fix race between addr_wq timer handler and backlog draining
Date: Fri,  6 Nov 2026 17:19:38 +0800
Message-ID: <20261106091938.112942-1-18983559317@163.com>
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
X-CM-TRANSID:_____wD3X_+sm+1qq0VFFQ--.340S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxGw1UKF17Ww1kJw13Xw1kKrg_yoW5Cr4xpF
	WYgrWYyF4DJry5ZFn5AF48Wryrur4rW3y7Ga42ganYywsFqrnavFy8Kw4YqF4UKFsFqay7
	Zr1qgw45Ar4DtaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pimhF7UUUUU=
X-CM-SenderInfo: jprymmytvvmjmrxbiqqrwthudrp/xtbC-A4oDGrtm678ewAA3j

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
the user, drop both locks, leave the addr_waitq entry queued and
re-arm addr_wq_timer to retry after SCTP_ADDRESS_TICK_DELAY. Sockets
processed earlier for the same address event will see a duplicate
ASCONF on retry; the peer reports that in an ASCONF-ACK error
indication, which the association tolerates.

Fixes: 9f7d653b67ae ("sctp: Add Auto-ASCONF support (core).")
Signed-off-by: Binbin Deng <18983559317@163.com>
---
 net/sctp/protocol.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index 27c26e12f95d..7528a40a87f5 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -645,6 +645,14 @@ static void sctp_addr_wq_timeout_handler(struct timer_list *t)
 			if (!sctp_is_ep_boundall(sk))
 				continue;
 			bh_lock_sock(sk);
+			if (sock_owned_by_user(sk)) {
+				bh_unlock_sock(sk);
+				spin_unlock_bh(&net->sctp.addr_wq_lock);
+				/* Try again later. */
+				mod_timer(&net->sctp.addr_wq_timer,
+					jiffies + msecs_to_jiffies(SCTP_ADDRESS_TICK_DELAY));
+				return;
+			}
 			if (sctp_asconf_mgmt(sp, addrw) < 0)
 				pr_debug("%s: sctp_asconf_mgmt failed\n", __func__);
 			bh_unlock_sock(sk);
-- 
2.43.0

