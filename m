Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794540549;
	b=hev8TvJjv1Gec2ByL1NIFAjtwpp2hHtMBE7lER30SLPIPYFtuu20deN+0VgBSdcweNzR
	 XZd3UEbWh1m/cPktOfRthJpFnAzpiiAf7IvKey8F6beVBrpIkL7yzKbO7MaXWqvzJXhmO
	 YaLUBvJ9RRH5tRZGCNcfmayF3Uzbf+sCBuPAyUnPjojJgc0bC0UKnD+VwFNK+RIMwyxV5
	 PZg4heozfzZ0rG6+1mjyRhjgDQaNBhG28AeNv9EUDT4O9V6Kl6bn1ePf8sRb9RhREyOgO
	 7Wb5RYerflMom2GlQPFWl8nMfWSyKbl5iyLHBmkIPvhkWoi2itXS7vTcTWbQNR9TLWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794540549;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sfS7nB4gtLu1FKmXvUmoI2KWykiSmHoqnc+SrZgTJWU=;
	b=ssh58ADzoSlM/u2Q6gLjOIdlhX9+W7eOIiLKk3sE4pDsudMF36JMSLmIyTitYwivEGk4
	 ixY660tCmT3issn3giWcveWXVAUIDCtqcoDa3xhUIEFpHNfvEcnNcQd06xaxYTcpblX9P
	 USBo3er34l9xLRJCgRdRwm5soFLsc09dSKnlqszPUM1CUWekQnzfxD6WU56nzWcVc/wMQ
	 7wIAAH3kRfztTiKU1OS5tnYZjs4i2stRjMqbpFOwOD6/hEOfKmxbwm8G2+vWWuD9qhk7k
	 d8+G/SL3RSjhnEnXM9FeCqB6dqSkzTAPRvgRJvW0t12lmUzXR7uepCY62BZPyF7Id9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=b+cixmrE;
	arc=none smtp.remote-ip=209.85.215.181
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F480606A323
	for <linux-sctp@vger.kernel.org>; Fri, 13 Nov 2026 03:29:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9F480606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=b+cixmrE
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-cc4aa18f9afso182728a12.3
        for <linux-sctp@vger.kernel.org>; Thu, 12 Nov 2026 19:29:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794540544; x=1795145344; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sfS7nB4gtLu1FKmXvUmoI2KWykiSmHoqnc+SrZgTJWU=;
        b=b+cixmrEkhG8B2FLuslGH/982o8yDK4CKzbnMcESoppN1oTQOqPMvYmraVAajZw7UO
         lHGal90PN4yXv+1CZIGgzuveVliopVzmJs4CYVZsxjc4TVRaPOCb0s/wEhw5NUlmIgkm
         8CYNhOv6dPEG5UcpOic1h33f4VgUaoU8sOW6LeGSvsLJBkQ3OftQpqu4l5j+PRbBaptG
         yHcu4QoQNbNIvujdjt8niVrtl3v+qfj6+HP7jpptE0/7LlQtYcZvFS3KEr2fiWlZbEM7
         crk4t7XR7cIPxfTvKXrPLGrFIDEbWPOiLIBbtwae/GvvV+KcLRUBVPR3ZdDYrcWU200B
         ou/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794540544; x=1795145344;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=sfS7nB4gtLu1FKmXvUmoI2KWykiSmHoqnc+SrZgTJWU=;
        b=EGnl74sCxLtucZE3IdQzD0f6VCj69Lm+Xrie4mXPR/sJofUDOnAVWPvZVxMKg+yiCZ
         fFpapkzN/QRuy1ki6U0nKs0WzIeiRwh/WPUSplsIRL8Dn3Fnjjeo/f80I7k+c2FXAZlG
         XXgbjKfGXSHOAUaV3RvDsg36LHQzDvLvWohONfNPr2nuJHGYjnnikSaWbn0DeNGRIEGF
         HvFHVFhAw9SGt8WcoCDL1ZUVEy8xuakM+7gv4hD67VUT6YcG5MIqt7OldBGWpXi6P1hn
         7lqo/ysFUzxX1bVBTyylL+sqDouE5j7Mq3JCEVDifTbJQ+V8eRoJnysxTy5+VhO+0lB6
         fZ6g==
X-Forwarded-Encrypted: i=1; AL+hErGjbNNrTeWAdqH9/4VaBmOrIW6yrH16j7OlxLXkkWcKh+0f0Bx6bZFXPQr+iF7FRt51ekgg7RBFl7Nc@vger.kernel.org
X-Gm-Message-State: APuU4Z+gv+/dwWUVWh77OSsZGzXB2dMQ5KaEue112KkPajcuK77xJAxn
	Ib9AHImL0LlnogxsTjb0J72mrsjC/A9OXgJqmr0l8sixP3zfCh0jj3vx
X-Gm-Gg: AYBFou3h8u0Qj08m5P+D5Z+/B8cgGYRj9M66crL/FPm1cYINoRTKqua318vBtcP7aKi
	em6sy6noraAfeEoBcpX6yU0crUdp3EI7PM10BAojv4JEvxYexlJAzDHbWX6hKxa3AhVoKsGcZ2b
	B+LxmMziG9bfc/kFCAxd9pzRJn4yxJfu25wZIdnKhwbqHFd3ZrCz3pABmUa/kqOAZJXnwjlJuXl
	uaPIQGt9Y3pZo0BtyxwNvhO29gaO+Jpqvvv5um+wgXRJ6CXIohf+Gtnuu7YKBYOqKjh/uHNdFgJ
	p2mNMWyKFQkJOnk3ehuz5QtUfLXgkkJGQS+x8kfOHSy1NkdgsdRbY/5R6U1y4W18sUT5ymTUMQZ
	ytx5sRRH5f+HscrCip8yRuL2r10s6E1OiAb5fEIcIST4CxtAIv/CvRvuDklRRZG9sxrT+qt+WVu
	oJ6hSuwzy/IJ5UHwHryhTxtrVKsb1tzMiDho7iGfPCNa8r5oveOS6Irdt2Znl4PJigRiWOJ1WtB
	QmG2LItrpBCy0TxlarpEFpgFDTWNTReg+oEPnSkf5QfMxHimQ4Qml5WHVZNjwEbpkD07fSpF5wp
	tOYEm1vSgVVWFkpotTjz7UfG63jPXBaK+eQalZry0g==
X-Received: by 2002:a17:90a:c2c8:b0:3ac:80dc:f40c with SMTP id 98e67ed59e1d1-3b1b0a0e9fbmr951734a91.14.1794540543447;
        Thu, 12 Nov 2026 19:29:03 -0800 (PST)
Received: from localhost.localdomain ([223.104.68.104])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b197d32ea0sm7087063a91.15.2026.11.12.19.28.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 19:29:02 -0800 (PST)
From: Yong Liu <pkfxxxing@gmail.com>
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Xin Long <lucien.xin@gmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>,
	linux-sctp@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net v2] sctp: revalidate association sockets after locking
Date: Fri, 13 Nov 2026 11:28:02 +0800
Message-ID: <20261113032805.1447885-1-pkfxxxing@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261110120212.1110283-2-pkfxxxing@gmail.com>
References: <20261110120212.1110283-1-pkfxxxing@gmail.com> <20261110120212.1110283-2-pkfxxxing@gmail.com>
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

SCTP timer callbacks and ICMP error lookup cache asoc->base.sk before
acquiring its BH lock. An accept or peeloff can move the association to
a new socket in between. Processing under the old socket lock can then
race with an abort on the new socket that tears down the association's
queues. Transport and association references do not keep those queues
alive. With mdelay() instrumentation widening the race, KASAN reported a
slab-use-after-free in sctp_chunk_abandoned() from the T3 retransmit path.

The ICMP error handlers also reread asoc->base.sk after lookup, so they
can use the new socket without holding its BH lock. In particular, the
PMTU handler can reach the same retransmit path, while protocol-unreachable
handling can run the state machine directly.

Recheck the association's socket after locking it in the timer callbacks.
Treat a mismatch like a busy socket and use the existing reference-counted
retry path. Pass the socket locked by sctp_err_lookup() to both IPv4 and
IPv6 error handlers, including their UDP encapsulation callers. Defer PMTU
and protocol-unreachable processing and ignore redirects when that socket
no longer matches the association. Require a matching socket for immediate
error reports as well.

Use READ_ONCE() for the socket pointer reads in the timer, ICMP, receive
and backlog paths, paired with WRITE_ONCE() in sctp_assoc_migrate(). Take
the new socket reference before publishing its pointer. The cached socket
is protected by BH context and the endpoint's RCU-deferred sock_put().

The issue was discovered and fixed by Qihoo 360's Tulongfeng multi-agent
system.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Yong Liu <pkfxxxing@gmail.com>
---
Changes in v2:
- Use Yong Liu for the author and Signed-off-by, as requested by Jakub
  Kicinski.
- Address Xin Long's review and the Sashiko ICMP finding: pass the locked
  socket to the IPv4/IPv6 error handlers and their UDP encapsulation
  callers, and revalidate it before immediate ICMP processing.
- Use READ_ONCE() for socket pointer reads in sctp_err_lookup(), sctp_rcv()
  and sctp_backlog_rcv().
- Broaden the subject and commit message to cover the ICMP paths.

v1: https://lore.kernel.org/all/20261110120212.1110283-2-pkfxxxing@gmail.com/

Based on b3dfbde62cf1981c4638939c159dfd087b7a72e9 (Linux 7.4.0-rc2).

 net/sctp/associola.c     |  4 ++--
 net/sctp/input.c         | 32 ++++++++++++++++---------------
 net/sctp/ipv6.c          | 11 ++++++-----
 net/sctp/sm_sideeffect.c | 41 ++++++++++++++++++++--------------------
 4 files changed, 45 insertions(+), 43 deletions(-)

diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index 4521be3bd8..c5d520c8d7 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -1088,8 +1088,8 @@ void sctp_assoc_migrate(struct sctp_association *assoc, struct sock *newsk)
 	sctp_endpoint_hold(assoc->ep);
 
 	/* Get a reference to the new sock.  */
-	assoc->base.sk = newsk;
-	sock_hold(assoc->base.sk);
+	sock_hold(newsk);
+	WRITE_ONCE(assoc->base.sk, newsk);
 
 	/* Add the association to the new endpoint's list of associations.  */
 	sctp_endpoint_add_asoc(newsp->ep, assoc);
diff --git a/net/sctp/input.c b/net/sctp/input.c
index 9494cfa511..e25c94ad08 100644
--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@ -169,7 +169,7 @@ int sctp_rcv(struct sk_buff *skb)
 
 	/* Retrieve the common input handling substructure. */
 	rcvr = asoc ? &asoc->base : &ep->base;
-	sk = rcvr->sk;
+	sk = READ_ONCE(rcvr->sk);
 
 	/*
 	 * RFC 2960, 8.4 - Handle "Out of the blue" Packets.
@@ -217,7 +217,7 @@ int sctp_rcv(struct sk_buff *skb)
 	 */
 	bh_lock_sock(sk);
 
-	if (sk != rcvr->sk) {
+	if (sk != READ_ONCE(rcvr->sk)) {
 		/* Our cached sk is different from the rcvr->sk.  This is
 		 * because migrate()/accept() may have moved the association
 		 * to a new socket and released all the sockets.  So now we
@@ -226,7 +226,7 @@ int sctp_rcv(struct sk_buff *skb)
 		 * of the current sk.
 		 */
 		bh_unlock_sock(sk);
-		sk = rcvr->sk;
+		sk = READ_ONCE(rcvr->sk);
 		bh_lock_sock(sk);
 	}
 
@@ -292,7 +292,7 @@ int sctp_backlog_rcv(struct sock *sk, struct sk_buff *skb)
 		goto done;
 	}
 
-	if (unlikely(rcvr->sk != sk)) {
+	if (unlikely(READ_ONCE(rcvr->sk) != sk)) {
 		/* In this case, the association moved from one socket to
 		 * another.  We are currently sitting on the backlog of the
 		 * old socket, so we need to move.
@@ -304,7 +304,7 @@ int sctp_backlog_rcv(struct sock *sk, struct sk_buff *skb)
 		 * Otherwise, we can safely push the chunk on the inqueue.
 		 */
 
-		sk = rcvr->sk;
+		sk = READ_ONCE(rcvr->sk);
 		local_bh_disable();
 		bh_lock_sock(sk);
 
@@ -377,7 +377,7 @@ void sctp_icmp_frag_needed(struct sock *sk, struct sctp_association *asoc,
 	     t->pl.probe_size + sctp_transport_pl_hlen(t) <= pmtu))
 		return;
 
-	if (sock_owned_by_user(sk)) {
+	if (sock_owned_by_user(sk) || sk != READ_ONCE(asoc->base.sk)) {
 		atomic_set(&t->mtu_info, pmtu);
 		asoc->pmtu_pending = 1;
 		t->pmtu_pending = 1;
@@ -410,7 +410,8 @@ void sctp_icmp_redirect(struct sock *sk, struct sctp_transport *t,
 {
 	struct dst_entry *dst;
 
-	if (sock_owned_by_user(sk) || !t)
+	if (sock_owned_by_user(sk) || !t ||
+	    sk != READ_ONCE(t->asoc->base.sk))
 		return;
 	dst = sctp_transport_dst_check(t);
 	if (dst)
@@ -432,7 +433,7 @@ void sctp_icmp_proto_unreachable(struct sock *sk,
 			   struct sctp_association *asoc,
 			   struct sctp_transport *t)
 {
-	if (sock_owned_by_user(sk)) {
+	if (sock_owned_by_user(sk) || sk != READ_ONCE(asoc->base.sk)) {
 		if (timer_pending(&t->proto_unreach_timer))
 			return;
 		else {
@@ -492,7 +493,7 @@ struct sock *sctp_err_lookup(struct net *net, int family, struct sk_buff *skb,
 	if (!asoc)
 		return NULL;
 
-	sk = asoc->base.sk;
+	sk = READ_ONCE(asoc->base.sk);
 
 	/* RFC 4960, Appendix C. ICMP Handling
 	 *
@@ -526,7 +527,7 @@ struct sock *sctp_err_lookup(struct net *net, int family, struct sk_buff *skb,
 	/* If too many ICMPs get dropped on busy
 	 * servers this needs to be solved differently.
 	 */
-	if (sock_owned_by_user(sk))
+	if (sock_owned_by_user(sk) || sk != READ_ONCE(asoc->base.sk))
 		__NET_INC_STATS(net, LINUX_MIB_LOCKDROPPEDICMPS);
 
 	*app = asoc;
@@ -546,11 +547,11 @@ void sctp_err_finish(struct sock *sk, struct sctp_transport *t)
 	sctp_transport_put(t);
 }
 
-static void sctp_v4_err_handle(struct sctp_transport *t, struct sk_buff *skb,
+static void sctp_v4_err_handle(struct sock *sk, struct sctp_transport *t,
+			       struct sk_buff *skb,
 			       __u8 type, __u8 code, __u32 info)
 {
 	struct sctp_association *asoc = t->asoc;
-	struct sock *sk = asoc->base.sk;
 	int err = 0;
 
 	switch (type) {
@@ -582,7 +583,8 @@ static void sctp_v4_err_handle(struct sctp_transport *t, struct sk_buff *skb,
 	default:
 		return;
 	}
-	if (!sock_owned_by_user(sk) && inet_test_bit(RECVERR, sk)) {
+	if (!sock_owned_by_user(sk) && sk == READ_ONCE(asoc->base.sk) &&
+	    inet_test_bit(RECVERR, sk)) {
 		sk->sk_err = err;
 		sk_error_report(sk);
 	} else {  /* Only an error on timeout */
@@ -630,7 +632,7 @@ int sctp_v4_err(struct sk_buff *skb, __u32 info)
 		return -ENOENT;
 	}
 
-	sctp_v4_err_handle(transport, skb, type, code, info);
+	sctp_v4_err_handle(sk, transport, skb, type, code, info);
 	sctp_err_finish(sk, transport);
 
 	return 0;
@@ -660,7 +662,7 @@ int sctp_udp_v4_err(struct sock *sk, struct sk_buff *skb)
 	}
 	if (hdr->type == ICMP_DEST_UNREACH && hdr->code == ICMP_FRAG_NEEDED)
 		info = ntohs(hdr->un.frag.mtu);
-	sctp_v4_err_handle(t, skb, hdr->type, hdr->code, info);
+	sctp_v4_err_handle(sk, t, skb, hdr->type, hdr->code, info);
 
 	sctp_err_finish(sk, t);
 	return 1;
diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
index 97390569c4..f96e79ca7f 100644
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -123,11 +123,11 @@ static struct notifier_block sctp_inet6addr_notifier = {
 	.notifier_call = sctp_inet6addr_event,
 };
 
-static void sctp_v6_err_handle(struct sctp_transport *t, struct sk_buff *skb,
+static void sctp_v6_err_handle(struct sock *sk, struct sctp_transport *t,
+			       struct sk_buff *skb,
 			       __u8 type, __u8 code, __u32 info)
 {
 	struct sctp_association *asoc = t->asoc;
-	struct sock *sk = asoc->base.sk;
 	int err = 0;
 
 	switch (type) {
@@ -149,7 +149,8 @@ static void sctp_v6_err_handle(struct sctp_transport *t, struct sk_buff *skb,
 	}
 
 	icmpv6_err_convert(type, code, &err);
-	if (!sock_owned_by_user(sk) && inet6_test_bit(RECVERR6, sk)) {
+	if (!sock_owned_by_user(sk) && sk == READ_ONCE(asoc->base.sk) &&
+	    inet6_test_bit(RECVERR6, sk)) {
 		sk->sk_err = err;
 		sk_error_report(sk);
 	} else {
@@ -181,7 +182,7 @@ static int sctp_v6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 		return -ENOENT;
 	}
 
-	sctp_v6_err_handle(transport, skb, type, code, ntohl(info));
+	sctp_v6_err_handle(sk, transport, skb, type, code, ntohl(info));
 	sctp_err_finish(sk, transport);
 
 	return 0;
@@ -211,7 +212,7 @@ int sctp_udp_v6_err(struct sock *sk, struct sk_buff *skb)
 	}
 	if (hdr->icmp6_type == ICMPV6_PKT_TOOBIG)
 		info = ntohl(hdr->icmp6_mtu);
-	sctp_v6_err_handle(t, skb, hdr->icmp6_type, hdr->icmp6_code, info);
+	sctp_v6_err_handle(sk, t, skb, hdr->icmp6_type, hdr->icmp6_code, info);
 
 	sctp_err_finish(sk, t);
 	return 1;
diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
index 35f540fb15..bd6b23369f 100644
--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -233,15 +233,14 @@ void sctp_generate_t3_rtx_event(struct timer_list *t)
 	struct sctp_transport *transport =
 		timer_container_of(transport, t, T3_rtx_timer);
 	struct sctp_association *asoc = transport->asoc;
-	struct sock *sk = asoc->base.sk;
+	struct sock *sk = READ_ONCE(asoc->base.sk);
 	struct net *net = sock_net(sk);
 	int error;
 
-	/* Check whether a task is in the sock.  */
-
+	/* Defer if the socket is busy or the association has migrated. */
 	bh_lock_sock(sk);
-	if (sock_owned_by_user(sk)) {
-		pr_debug("%s: sock is busy\n", __func__);
+	if (sock_owned_by_user(sk) || sk != READ_ONCE(asoc->base.sk)) {
+		pr_debug("%s: sock is busy or moved\n", __func__);
 
 		/* Try again later.  */
 		sctp_transport_hold(transport);
@@ -271,13 +270,13 @@ void sctp_generate_t3_rtx_event(struct timer_list *t)
 static void sctp_generate_timeout_event(struct sctp_association *asoc,
 					enum sctp_event_timeout timeout_type)
 {
-	struct sock *sk = asoc->base.sk;
+	struct sock *sk = READ_ONCE(asoc->base.sk);
 	struct net *net = sock_net(sk);
 	int error = 0;
 
 	bh_lock_sock(sk);
-	if (sock_owned_by_user(sk)) {
-		pr_debug("%s: sock is busy: timer %d\n", __func__,
+	if (sock_owned_by_user(sk) || sk != READ_ONCE(asoc->base.sk)) {
+		pr_debug("%s: sock is busy or moved: timer %d\n", __func__,
 			 timeout_type);
 
 		/* Try again later.  */
@@ -362,7 +361,7 @@ static void sctp_generate_autoclose_event(struct timer_list *t)
 	sctp_generate_timeout_event(asoc, SCTP_EVENT_TIMEOUT_AUTOCLOSE);
 }
 
-/* Generate a heart beat event.  If the sock is busy, reschedule.   Make
+/* Generate a heart beat event.  If the sock is busy or moved, reschedule.   Make
  * sure that the transport is still valid.
  */
 void sctp_generate_heartbeat_event(struct timer_list *t)
@@ -370,14 +369,14 @@ void sctp_generate_heartbeat_event(struct timer_list *t)
 	struct sctp_transport *transport = timer_container_of(transport, t,
 							      hb_timer);
 	struct sctp_association *asoc = transport->asoc;
-	struct sock *sk = asoc->base.sk;
+	struct sock *sk = READ_ONCE(asoc->base.sk);
 	struct net *net = sock_net(sk);
 	u32 elapsed, timeout;
 	int error = 0;
 
 	bh_lock_sock(sk);
-	if (sock_owned_by_user(sk)) {
-		pr_debug("%s: sock is busy\n", __func__);
+	if (sock_owned_by_user(sk) || sk != READ_ONCE(asoc->base.sk)) {
+		pr_debug("%s: sock is busy or moved\n", __func__);
 
 		/* Try again later.  */
 		sctp_transport_hold(transport);
@@ -418,12 +417,12 @@ void sctp_generate_proto_unreach_event(struct timer_list *t)
 	struct sctp_transport *transport =
 		timer_container_of(transport, t, proto_unreach_timer);
 	struct sctp_association *asoc = transport->asoc;
-	struct sock *sk = asoc->base.sk;
+	struct sock *sk = READ_ONCE(asoc->base.sk);
 	struct net *net = sock_net(sk);
 
 	bh_lock_sock(sk);
-	if (sock_owned_by_user(sk)) {
-		pr_debug("%s: sock is busy\n", __func__);
+	if (sock_owned_by_user(sk) || sk != READ_ONCE(asoc->base.sk)) {
+		pr_debug("%s: sock is busy or moved\n", __func__);
 
 		/* Try again later.  */
 		sctp_transport_hold(transport);
@@ -454,13 +453,13 @@ void sctp_generate_reconf_event(struct timer_list *t)
 	struct sctp_transport *transport =
 		timer_container_of(transport, t, reconf_timer);
 	struct sctp_association *asoc = transport->asoc;
-	struct sock *sk = asoc->base.sk;
+	struct sock *sk = READ_ONCE(asoc->base.sk);
 	struct net *net = sock_net(sk);
 	int error = 0;
 
 	bh_lock_sock(sk);
-	if (sock_owned_by_user(sk)) {
-		pr_debug("%s: sock is busy\n", __func__);
+	if (sock_owned_by_user(sk) || sk != READ_ONCE(asoc->base.sk)) {
+		pr_debug("%s: sock is busy or moved\n", __func__);
 
 		/* Try again later.  */
 		sctp_transport_hold(transport);
@@ -492,13 +491,13 @@ void sctp_generate_probe_event(struct timer_list *t)
 	struct sctp_transport *transport = timer_container_of(transport, t,
 							      probe_timer);
 	struct sctp_association *asoc = transport->asoc;
-	struct sock *sk = asoc->base.sk;
+	struct sock *sk = READ_ONCE(asoc->base.sk);
 	struct net *net = sock_net(sk);
 	int error = 0;
 
 	bh_lock_sock(sk);
-	if (sock_owned_by_user(sk)) {
-		pr_debug("%s: sock is busy\n", __func__);
+	if (sock_owned_by_user(sk) || sk != READ_ONCE(asoc->base.sk)) {
+		pr_debug("%s: sock is busy or moved\n", __func__);
 
 		/* Try again later.  */
 		sctp_transport_hold(transport);
-- 
2.43.0

