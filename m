Received: from cvsmtppost27.nm.naver.com (cvsmtppost27.nm.naver.com [114.111.35.163])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E34D12D9EE4
	for <linux-sctp@vger.kernel.org>; Sun, 11 Oct 2026 16:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.111.35.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791736682; cv=none; b=PGcACN6sVD9PGXy7WbBbPU5lX4ScV4PaSYhfOUyOvIWC2d+7QNokoMVFMkog0zOR3kW38xEYm9Mehxb4rzqC9GvzYGEWelnRyDmep/9eVyYMJhBh1QUkVmzIZ6naV58mVHSUCjmUtrnXM6or/2CZu/lEgG+J1W2l29EOBtAuyYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791736682; c=relaxed/simple;
	bh=mfRz2zk9VSkKhAjFcY7J3woD/6Sps4QomEr2JVkpR0E=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=XLYztxdax/SQRegg2M5ZP/LA2qiie0JGTCmSNLrokxECDkokQWhaQ7Vtcqjcl5CLn96+Mwj+i0JqvaTiRyfP3KkxV05LVttDLKKrUh6pI8w5OsN9gkAinAN/1ejuaIzEeNr2u+EEb8DJbjv8p5If/jnfgDE78tIu4l8L8pAZqzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=naver.com; spf=pass smtp.mailfrom=naver.com; dkim=pass (2048-bit key) header.d=naver.com header.i=@naver.com header.b=GG23faiI; arc=none smtp.client-ip=114.111.35.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=naver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=naver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=naver.com header.i=@naver.com header.b="GG23faiI"
Received: from cvsendbo016.nm ([10.112.24.39])
  by cvsmtppost27.nm.naver.com with ESMTP id +GuPKer2QUiiMSdPgHWMkw
  for <linux-sctp@vger.kernel.org>;
  Sun, 11 Oct 2026 16:27:51 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=naver.com; s=s20171208;
	t=1791736071; bh=mfRz2zk9VSkKhAjFcY7J3woD/6Sps4QomEr2JVkpR0E=;
	h=From:To:Subject:Date:Message-Id:From:Subject:Feedback-ID:
	 X-Works-Security;
	b=GG23faiIDkvzzL9ASf//+PBZ0J78fWOf0B2a3HzDTvRlZj06LY0LdgOgcjy7v/F3G
	 7/fOWD8Cp85kAO/5B9MieEVH28hRbctRt2andbisnWxUrA4m5O5iQDPW/ksH3ZUYjU
	 xr6iUN8FxdjJn8ll7asG6uTWV++j6DiFJQPcwl55QevEQoYxqhWLeNp0CCzbz+D1HL
	 F/PTJPN2Lad3Lpem1S4OsvfSyB0xMq9GkO0v7HMUtOG8E0zcu6VA/IuZJoauyMNPSD
	 NkAmYd8XATWN2Qz7nt9/f47v3OVjo3DaHeTT7thTyzHGShbnphKwjn1y44AS0D9mre
	 J+QDTgQLoGDVQ==
X-Session-ID: NltzlvSiR0Wm6FzDlyrr8Q
X-Works-Send-Opt: 0rRoWNkNjHmmKAidp4JZKHmmjAumjAurKAKmKqtwaACYkEljxBmwjAg=
X-Works-Smtp-Source: lqKmFqulFqJZ+HmmFqMq+6E=
Received: from localhost.localdomain ([125.130.170.186])
  by cvnsmtp003.nm.naver.com with ESMTP id NltzlvSiR0Wm6FzDlyrr8Q
  for <multiple recipients>
  (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
  Sun, 11 Oct 2026 16:27:50 -0000
From: Seung Min Shin <guncraft2000@naver.com>
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Xin Long <lucien.xin@gmail.com>
Cc: "David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	linux-sctp@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net v2] sctp: hold transport reference across connect wait
Date: Sun, 11 Oct 2026 16:27:50 +0000
Message-Id: <20261011162750.1529631-1-guncraft2000@naver.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

sctp_sendmsg_to_asoc() selects a transport before waiting for a new
interleaved association to become established. sctp_wait_for_connect()
drops the socket lock while sleeping.

While the lock is dropped, backlog processing can handle a COOKIE ACK and
an ASCONF DEL-IP that removes the selected transport. sctp_assoc_rm_peer()
then marks the transport dead and drops its association-owned reference.
The transport can be freed through RCU before the send path resumes.

After the wait, the stale pointer is assigned to newly created DATA or
I-DATA chunks and later dereferenced by sctp_outq_select_transport().

Hold a reference to the selected transport across
sctp_wait_for_connect(). After the socket lock is reacquired, abort the
send if the transport was marked dead. Callers without a selected
transport pass NULL and retain their existing behavior.

Cc: stable@vger.kernel.org
Fixes: 668c9beb9020 ("sctp: implement assign_number for sctp_stream_interleave")
Acked-by: Xin Long <lucien.xin@gmail.com>
Assisted-by: LLM
Signed-off-by: Seung Min Shin <guncraft2000@naver.com>
---

Notes (sctp-connect-wait-v2):
    v2:
    - Rebase onto current net/main after commit 4f1da630d13de.
    - Preserve the RCV_SHUTDOWN check added by that commit.
    - Add the stable list now that the issue is public.
    
    v1: https://lore.kernel.org/netdev/20260928152132.3705137-1-guncraft2000@naver.com/
    
    Tested on net/main af32da41b032 with CONFIG_KASAN=y on x86-64.
    
    Before the patch, the reproducer triggered a KASAN slab-use-after-free in
    sctp_outq_select_transport() on its first run. After the patch, 64 attempts
    completed without a KASAN, refcount, BUG, WARNING, oops, or panic report. A
    diagnostic run returned ESRCH in all 64 attempts and left the association in
    SCTP_ESTABLISHED state. A normal interleaved connect/send smoke test passed.

 net/sctp/socket.c | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index e35692dd8d30..189b89a40d46 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -75,7 +75,8 @@ static int sctp_wait_for_sndbuf(struct sctp_association *asoc,
 				struct sctp_transport *transport,
 				long *timeo_p, size_t msg_len);
 static int sctp_wait_for_packet(struct sock *sk, int *err, long *timeo_p);
-static int sctp_wait_for_connect(struct sctp_association *, long *timeo_p);
+static int sctp_wait_for_connect(struct sctp_association *,
+				 struct sctp_transport *, long *timeo_p);
 static int sctp_wait_for_accept(struct sock *sk, long timeo);
 static void sctp_wait_for_close(struct sock *sk, long timeo);
 static void sctp_destruct_sock(struct sock *sk);
@@ -1245,7 +1246,7 @@ static int __sctp_connect(struct sock *sk, struct sockaddr *kaddrs,
 		*assoc_id = asoc->assoc_id;
 
 	timeo = sock_sndtimeo(sk, flags & O_NONBLOCK);
-	return sctp_wait_for_connect(asoc, &timeo);
+	return sctp_wait_for_connect(asoc, NULL, &timeo);
 
 out_free:
 	pr_debug("%s: took out_free path with asoc:%p kaddrs:%p err:%d\n",
@@ -1843,7 +1844,7 @@ static int sctp_sendmsg_to_asoc(struct sctp_association *asoc,
 
 		if (asoc->ep->intl_enable) {
 			timeo = sock_sndtimeo(sk, 0);
-			err = sctp_wait_for_connect(asoc, &timeo);
+			err = sctp_wait_for_connect(asoc, transport, &timeo);
 			if (err || sk->sk_shutdown & RCV_SHUTDOWN) {
 				err = -ESRCH;
 				goto err;
@@ -1881,7 +1882,7 @@ static int sctp_sendmsg_to_asoc(struct sctp_association *asoc,
 
 	if (unlikely(wait_connect)) {
 		timeo = sock_sndtimeo(sk, msg->msg_flags & MSG_DONTWAIT);
-		sctp_wait_for_connect(asoc, &timeo);
+		sctp_wait_for_connect(asoc, NULL, &timeo);
 	}
 
 	err = msg_len;
@@ -9381,7 +9382,9 @@ static bool sctp_writeable(const struct sock *sk)
 /* Wait for an association to go into ESTABLISHED state. If timeout is 0,
  * returns immediately with EINPROGRESS.
  */
-static int sctp_wait_for_connect(struct sctp_association *asoc, long *timeo_p)
+static int sctp_wait_for_connect(struct sctp_association *asoc,
+				 struct sctp_transport *transport,
+				 long *timeo_p)
 {
 	struct sock *sk = asoc->base.sk;
 	int err = 0;
@@ -9390,12 +9393,16 @@ static int sctp_wait_for_connect(struct sctp_association *asoc, long *timeo_p)
 
 	pr_debug("%s: asoc:%p, timeo:%ld\n", __func__, asoc, *timeo_p);
 
-	/* Increment the association's refcnt.  */
+	/* Hold references while the socket lock is dropped. */
+	if (transport)
+		sctp_transport_hold(transport);
 	sctp_association_hold(asoc);
 
 	for (;;) {
 		prepare_to_wait_exclusive(&asoc->wait, &wait,
 					  TASK_INTERRUPTIBLE);
+		if (transport && transport->dead)
+			goto do_transport_dead;
 		if (!*timeo_p)
 			goto do_nonblock;
 		if (sk->sk_shutdown & RCV_SHUTDOWN)
@@ -9424,7 +9431,8 @@ static int sctp_wait_for_connect(struct sctp_association *asoc, long *timeo_p)
 out:
 	finish_wait(&asoc->wait, &wait);
 
-	/* Release the association's refcnt.  */
+	if (transport)
+		sctp_transport_put(transport);
 	sctp_association_put(asoc);
 
 	return err;
@@ -9443,6 +9451,10 @@ static int sctp_wait_for_connect(struct sctp_association *asoc, long *timeo_p)
 do_nonblock:
 	err = -EINPROGRESS;
 	goto out;
+
+do_transport_dead:
+	err = -EAGAIN;
+	goto out;
 }
 
 static int sctp_wait_for_accept(struct sock *sk, long timeo)

base-commit: af32da41b0327b9c6a37856ba82b6760d6c8d10e
-- 
2.34.1

