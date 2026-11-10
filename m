Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794312232;
	b=IrPdFnL0E0JMqHa32IGbe+Lfne9xxBQM6UyWyHWNu4S1yFJLalngzJU7wUNZrZExa9r4
	 fM20gYdlaC+fMsubPYFrJoHj4jI76X6UqeDBtPhahBK7GFjh169Yu1wid+wY5wmW5Y/rl
	 CF9hpKS0ReWgeszIdORfvWQzSIEoCtli4QYXn1O78919Nsop04jnna79mKIXd24MlZ2An
	 7lNFMVND8owj06d71hpQM+xDYZnLGvxo/yj7mGy6JD/3F4iY8rAZIxI22fwA11JI4y+Ya
	 jXC/aSM1e89NYaIDmRPC6C00X9+GJQNt+KNMmGLrrlQ/yLkEkkBHegAXddtJ7EPlC4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794312232;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=1unnli9q1E0mHNtcr8F0RHVI3I4DtNu0vjyeqxGMrD8=;
	b=CfsfVdA2EE9QHGRKJZUjq7NQZtEz4ybNV6YwJ0eUOGSM6hr7SIPMKjsImX/yM5phke5Q
	 ncUH7hIlPlGZAOaPtgvDitwWhTzPF1xAGPcRlrad93zR0Nta8DIqaQf/SCq0rerJZKppu
	 FU5pwLKXppdjeKEI/uVOoer1t2DGLgyOQm01VbJ37QUxjz01DA0ejzbU1MqdJSkEzybB4
	 5GMZTPtJqT9jVic7YaH/4yv7BcR2AmXKv3C00HKYewehgCrcsxQacL1qz/3t1ZTo/IocM
	 NwFjzp09UHRkU/UB9SFR5+cK5xNGtsjVY+bcdkGpnVThxuFhYr91UmNdQoug5patiqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=DWuBFx2g;
	arc=none smtp.remote-ip=209.85.216.45
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E54C6606A326
	for <linux-sctp@vger.kernel.org>; Tue, 10 Nov 2026 12:03:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E54C6606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=DWuBFx2g
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-3b0a519049aso1271690a91.1
        for <linux-sctp@vger.kernel.org>; Tue, 10 Nov 2026 04:03:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794312230; x=1794917030; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1unnli9q1E0mHNtcr8F0RHVI3I4DtNu0vjyeqxGMrD8=;
        b=DWuBFx2gpkNO/jw5PFJUAGAJB7rJ+Fmpia0qAuoEL01jBrX2mTicsAkJN8M2l5zHPk
         Rvk2E/Fc6jjTdB2DW0N/b3qw1Zpgvb4uhl7Nu0AFAQZ1k6ulRmIHiq7j75kjS1VfwYoU
         axQhiwCC4miwDxdwJCa6ldgjSFzdW+9upbKQaTE2lV79S7U62a2KUm99AdHjlrj/842D
         SQHR7n4e6JBiMxbfm8IRtMlMvTZGyo5X8A8EzLRYSgqLvRBkf1ZNfsIEQqMRuqXlCaiP
         deOWT7FDOfJjepWlwU3lYPQE1Aio7JxYYrBYnAl+cqgSwxfFLQsuS/zxWHMmEtMMP+Nc
         l4Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794312230; x=1794917030;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1unnli9q1E0mHNtcr8F0RHVI3I4DtNu0vjyeqxGMrD8=;
        b=CLD6imdC9bi57cwXlc8lCejwJznvX9/LLEuAhFx4jIzrMrh5jGMZBjU+anIaD5iMNu
         jQ6WZD/TMaNtr2/zPpYbMYE4G6NxQOz8oCf5QSuixsccZUUG/04+Xp1ph24809u1rwGm
         9Aah5U0Ax0LNvyTlAqCjVZdPJ1b/LcE4/I3fegrpoTpXizoIKR0D3oG8MEv/5l4C5Y+o
         3OK3f77rxJFgtZ3gARcmu8Ewb4QJIWYHk6WBUBL0F1PhfV57zpQ+h15kylHJ9ZGrYPLG
         +jDz481YYhbZ2W0HW1BIrYYlGSTrgSxkQkHLTjKylt9cpAoK9uMTH0yed9Amtah68iBc
         x3Dw==
X-Gm-Message-State: APuU4Z/kent+uD92YdAsnmmnJP5qHH++gmKUU8juMbBXh0fLq+2wNibF
	2YnSxTzTl2oe/B3BokBDoLt1NASD5vNvEaHEUYq0hPFuGICnc3raCwCUdpkWquqO
X-Gm-Gg: AYBFou2nSzBfaBagXi+0ensuKf0tB4yTWaD7CBbrCa8EpXi9qwvEafNWDlngulWldpV
	gGP7V1PgqyYzC9/HkBSPnX3zX3/Az4LiiC/SpPXljdzQ778fXZKkiETPO03GiNCQhPM9cMudKZc
	gSdNzlQugw6WtqXVeQ75bFc3lVJou5CkMx82EAc2zhgpAwMxihPOScb84GKf04aDEurfciowI5K
	odYpoDSG/tusKpKPWmz6rIZ38sa3UFav2X2T/TTvdnqfoFghNDYAELh5hlM00CoX2Sy/2qf9Bme
	AckbzPdHmpF8yU+DoTkHSnJlD4G6y1oe8GQU9ODZN5eKWuXGipAV2YeA5MTzq2/ew7TCa2gQZfo
	tFlSB4rzqpSZ9FUa6TmhE1q/Bs420S2EqP3eCuSyWDEU/+HgdN81a5HQdOGZmCg1/xiZriCDSE9
	D2p+HBcOI7HnAiGmCguXysvYhGJ2evL9kox+pthSXvGKTCe6j7xJjQh6Q7TC40hpwz3PL6QT9iE
	8M3p550o0f6nswfHI1iRGbPtOOpbz1kkgLTz8p8FjFRoY9RWliD3AfSYbUggSkVugu54YxlTdDt
	WvgU1f5rT7PhCTbVUOOG9K0+4UEZ6EQK4LypP57voxoKpDKX+dDjAcgQx0fyOyY=
X-Received: by 2002:a17:90b:3c06:b0:3ac:95d7:2fa5 with SMTP id 98e67ed59e1d1-3b166cbd7ddmr2437248a91.44.1794312230164;
        Tue, 10 Nov 2026 04:03:50 -0800 (PST)
Received: from localhost.localdomain ([183.62.176.219])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b16771705asm3693853a91.12.2026.11.10.04.03.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 04:03:49 -0800 (PST)
From: liuyong <pkfxxxing@gmail.com>
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Xin Long <lucien.xin@gmail.com>
Cc: linux-sctp@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] sctp: revalidate the association socket in timer callbacks
Date: Tue, 10 Nov 2026 20:02:09 +0800
Message-ID: <20261110120212.1110283-2-pkfxxxing@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261110120212.1110283-1-pkfxxxing@gmail.com>
References: <20261110120212.1110283-1-pkfxxxing@gmail.com>
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

SCTP timer callbacks cache asoc->base.sk before acquiring its BH lock.
An accept or peeloff can move the association to a new socket in between.
The callback can then run the state machine under the old socket lock,
while an abort on the new socket tears down the association's queues.
The timer's transport and association references do not keep those
queues alive. With delays inserted to widen the race, KASAN reported a
slab-use-after-free in sctp_chunk_abandoned() from the T3 retransmit path.

Recheck the association's socket after acquiring its BH lock. Treat a
mismatch like a busy socket and use the existing reference-counted timer
rescheduling path. The next callback reads the current socket again,
preventing state-machine execution under the old socket's lock. Retain
the user-ownership check to handle a migration already in progress.

Apply the check to the T3, association, heartbeat, protocol-unreachable,
reconfiguration and probe timers. Their BH context and the endpoint's
RCU-deferred sock_put() protect the cached socket during the callback.
Pair the socket pointer reads with WRITE_ONCE() in sctp_assoc_migrate(),
taking the new socket reference before updating the pointer.

The issue was discovered and fixed by Qihoo 360's Tulongfeng multi-agent
system.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: liuyong <pkfxxxing@gmail.com>
---
 net/sctp/associola.c     |  4 ++--
 net/sctp/sm_sideeffect.c | 41 ++++++++++++++++++++--------------------
 2 files changed, 22 insertions(+), 23 deletions(-)

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

