Received: from cvsmtppost36.nm.naver.com (cvsmtppost36.nm.naver.com [114.111.35.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6456C4E781D
	for <linux-sctp@vger.kernel.org>; Mon, 28 Sep 2026 15:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.111.35.244
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790609507; cv=none; b=JwLsTwBK/2l2hpPFsMln2o/wHFEaZflflqX1ZkDTYiMp3T/qdMAPDCRIYII1uo4ZbMOzdN+PBjMzdvL+3GNbNGUxetKdWeUMmBn/9Wm+QQ099wavEJcMQBiLbWYfDp9I6SUolnnVdAMUXjZFJxGUY4oH4AK7U0yc2H8pcYUpR2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790609507; c=relaxed/simple;
	bh=WjkOw+dq09Pw9UNWRg4QHNvc5KYfHbrtJx1tojYGQpE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=H5qJnxA+5W+RBjf02L2FAYnPrsOEVvbQSzLgIJ2bUVbDmfwFszO0XZHuyPiA9qdEfCUhPBGyGaQkhIxeDyapqtu4IO3x0VF+pUwhyXIRCAY46oupU5yoOL6PpEXQeM0+sqIfnOH4vlNiRlDP9YxtjaTu6jQULMUfz+3ZGz+K0gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=naver.com; spf=pass smtp.mailfrom=naver.com; dkim=pass (2048-bit key) header.d=naver.com header.i=@naver.com header.b=FuyE6SY5; arc=none smtp.client-ip=114.111.35.244
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=naver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=naver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=naver.com header.i=@naver.com header.b="FuyE6SY5"
Received: from cvsendbo022.nm ([10.112.20.47])
  by cvsmtppost36.nm.naver.com with ESMTP id lmpCSaaiRE+KElsiQu+27Q
  for <linux-sctp@vger.kernel.org>;
  Mon, 28 Sep 2026 15:21:33 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=naver.com; s=s20171208;
	t=1790608893; bh=WjkOw+dq09Pw9UNWRg4QHNvc5KYfHbrtJx1tojYGQpE=;
	h=From:To:Subject:Date:Message-Id:From:Subject:Feedback-ID:
	 X-Works-Security;
	b=FuyE6SY5a3LzBr0bHSxH3B8MfFzRc6dSgKQy3aIaM10/E8lKDHIsqe1Xp+u0Y2jC0
	 M4iF4wxzOe5MZJJSPgBSSOwgBllDqlKB64A7BYeNS9V2SwJjEWKow2gdME6sqQCHW+
	 0X9OU6JpGMnhl+RT4UsUAicPfhqCAhoG4XgxB2YkmLz+SAAVimOZVs5i/pdaoUA0FO
	 TBMffVJ7CNoIADuPivaoQ7962vQHzBgulcOBK9zmneemDbOA51RdPgKNZR239lODnB
	 6JyQupI5k6N2oP3eHNkBSlaJs3cvoDm5S4r92tTjgCc9UWpbvyIGZC+8Cpo0R5+Lpj
	 zT+jMStTNTDJA==
X-Session-ID: TpC2W-GrRn2u2o-LQedDzQ
X-Works-Send-Opt: 0rRoWNkNjHmmKAidp4JZKHmmjAumjAurKAKmKqtwaACYkEljxBmwjAg=
X-Works-Smtp-Source: ednXFxglFqJZ+Hmqaxtr+6E=
Received: from localhost.localdomain ([125.130.170.186])
  by cvnsmtp012.nm.naver.com with ESMTP id TpC2W-GrRn2u2o-LQedDzQ
  for <multiple recipients>
  (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
  Mon, 28 Sep 2026 15:21:33 -0000
From: Seung Min Shin <guncraft2000@naver.com>
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Xin Long <lucien.xin@gmail.com>
Cc: "David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	linux-sctp@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] sctp: hold transport reference across connect wait
Date: Mon, 28 Sep 2026 15:21:32 +0000
Message-Id: <20260928152132.3705137-1-guncraft2000@naver.com>
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

Cc: stable@kernel.org
Fixes: 668c9beb9020 ("sctp: implement assign_number for sctp_stream_interleave")
Assisted-by: LLM
Signed-off-by: Seung Min Shin <guncraft2000@naver.com>
---

Notes:
    Tested on 165768bb70265b5c38cf0b73fafd75be235f8b14 with
    CONFIG_KASAN=y on x86-64.
    
    Before the patch:
    - The attached reproducer triggered the reported transport use-after-free.
    
    After the patch:
    - The exact attached reproducer completed 64 consecutive attempts without a
      KASAN, refcount, BUG, WARNING, or panic report.
    - A diagnostic run returned ESRCH in all 64 attempts and observed the
      association in SCTP_ESTABLISHED state after each return.
    - A normal stream-interleaving connect/send smoke test passed.
    
    The test config does not enable LOCKDEP, so this was not a LOCKDEP test.

 net/sctp/socket.c | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index c7b9e325ec1c..621df93d3450 100644
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
 			if (err) {
 				err = -ESRCH;
 				goto err;
@@ -1881,7 +1882,7 @@ static int sctp_sendmsg_to_asoc(struct sctp_association *asoc,
 
 	if (unlikely(wait_connect)) {
 		timeo = sock_sndtimeo(sk, msg->msg_flags & MSG_DONTWAIT);
-		sctp_wait_for_connect(asoc, &timeo);
+		sctp_wait_for_connect(asoc, NULL, &timeo);
 	}
 
 	err = msg_len;
@@ -9385,7 +9386,9 @@ static bool sctp_writeable(const struct sock *sk)
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
@@ -9394,12 +9397,16 @@ static int sctp_wait_for_connect(struct sctp_association *asoc, long *timeo_p)
 
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
@@ -9428,7 +9435,8 @@ static int sctp_wait_for_connect(struct sctp_association *asoc, long *timeo_p)
 out:
 	finish_wait(&asoc->wait, &wait);
 
-	/* Release the association's refcnt.  */
+	if (transport)
+		sctp_transport_put(transport);
 	sctp_association_put(asoc);
 
 	return err;
@@ -9447,6 +9455,10 @@ static int sctp_wait_for_connect(struct sctp_association *asoc, long *timeo_p)
 do_nonblock:
 	err = -EINPROGRESS;
 	goto out;
+
+do_transport_dead:
+	err = -EAGAIN;
+	goto out;
 }
 
 static int sctp_wait_for_accept(struct sock *sk, long timeo)

base-commit: a7bfaba4823e3c165bb2004c74eff7c096672bc7
-- 
2.34.1

