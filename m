Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7A8D31E838
	for <linux-sctp@vger.kernel.org>; Wed,  9 Sep 2026 02:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788922006; cv=none; b=RymGaEZqOkGM9neC874lnX+T0hf8NygaIrCwkPaOfG1pmPE6n902f5Vhn5T0cTCLW0jsnvsKZgYJwZ3GafpKfMum/IYk6Q3ORPYjh/U4slaMGof4wkNVW/rUOfxuD4DSJfqtCgE02qLN/hxHNCQRX2ojkaFbiOjGRT9K+vhtMqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788922006; c=relaxed/simple;
	bh=FaMuIMu7x2D3aJYKdS2ouRjVT1y2n3u88iUjSdpGrRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hr4ub+rJVnJ0oAjnWgJfQQNaAIFUsqWJZeQa+6482/TSLkzc76X5Lcp0tYGlxNTPgOknXJFha+uKBuP0ur4dTCt43pkUcZXekKMksceFNw1NMXb963H7u6Fo9dGhszUVrtVzGmvP0Iqg6k+ltfHrSOd7lJc4JSJIvtfdwXjNwJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WR6/7I4V; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WR6/7I4V"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-84e27035206so5079632b3a.3
        for <linux-sctp@vger.kernel.org>; Tue, 08 Sep 2026 19:46:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788922004; x=1789526804; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZO7tbb4HSzx3MW7qh3I4JqZjxCZe9pXRQ8RRhmehi7c=;
        b=WR6/7I4Vi0fVIYRfp6HF5e67IBBWtRGM8m0XsYWT18d0KF8DgXZGbu8/xz+pALbQ+T
         vCR951JMJHfo14q69GTiM9+Lo5F94xKeA2UlZ6OuVuTfLzl2ZMcnMLnwVyl8D4zM0bfA
         KJnbDEoxANms1VHEUfccJmXNqzoYCeREvQ3qhzSphhIJZHZmzOvPqpLuo9deyK+Da7lT
         0hBLy8Z1XwoGGz5JWWht614yFm4odVliMPtQ5QtzgxcbzPdpH7DNgaJR1xZKJlsD5P1V
         J3AXQSbpPK4faNA4D6mLeLUy/QCxTK9NvnybOrqxohlaHDWb/qhfIfyltRQM6/sbYOhG
         gY0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788922004; x=1789526804;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZO7tbb4HSzx3MW7qh3I4JqZjxCZe9pXRQ8RRhmehi7c=;
        b=X6LN6+5OgjwExZhMcYgI1AiUXqQ40haYG5YLPPOA3K4UM/lkKA4GDKJGMKe4pIuCWd
         B7aS1N+peRWWE5BHeOPx9B76IsUwGxuxQeJJX7X01Glz5HtuezSc58nIQcxJkXd8eYsJ
         n8RrPv+jwkJrivmPNidKX29kBZmdI4aFQj6Qos1ZUjMqyQtLHb2V9Zup+xUCclsEjUKn
         eBnFwyoQaVXrdoq0ESpZDgpZfkiqeaL+gl35MUGze+/UOETSgKs0f7MaSW00q+RlD+WY
         T3n6LxvPsNNidorAkF7tw7y8wraoe5ATbMvos8+F3G86tmsUldgiBnBmHuxNJ32/e3ra
         +2OQ==
X-Forwarded-Encrypted: i=1; AKwUvBwuJFnfY2CahsIlQZgVIzA8mbeCdvwtrikDs/13/HlxKDCUjZQX0/lhl0zDBSe9rlOm8f6qW3LIclT4@vger.kernel.org
X-Gm-Message-State: AFuF++n4x3wMtVWlHAPjkX9HXg1FmrJqlaqj4aLaBwePb2KLSq7V3/Ei
	t9n2cjEq74zEyuPQKTbElVdPBZXUgg32errfH9EJ2IH3AYgYlCdJ5+np
X-Gm-Gg: AYBFou2l9zsYVK5N6GWAosIwvb0mAawv95tlE2z7U1pL3auz6jLHwGTXIh085Ca6EeL
	yc0M2gWW8+YaRD2NCkIbUO3oq3f6DRex68qPRAMQ38YOWQp20n+/hyf97Qbp5dq5j6j79qX8rGm
	dyTZD+68Bwa9Cd3o9YzUystXLRQNwfhTKjeLgrVS/Fks/U56mUaUH1xFptkr1oK/BXa8uy9XICn
	AukieYXwISQ6iG9BeK13gM7KvgyQDynPh/jBTaHasRrTWA9RbWREh8zd5oVjoYEyENCtYa8KzUi
	952mlv115tA4Hj2lVCqvmr3K28I38tgsa+J99BdmRD6lR+R/+v+GXFULFK6qTH/WR4zKRessicZ
	7e7bn0e8IPoPvTxKu05ktcF4XS15gzfgIBTF3K1wbo/PxpaL5wX83q5G73JbiF9qJ8EMFsSBmf/
	srE7ARna52q7PefLcRPpRUjZQXfeR01cVY80ti7qzDSSJm4iMLObaX3o6oeqdaLb+e5DI9N9CcS
	g==
X-Received: by 2002:a05:6a21:6f12:b0:398:8870:b58f with SMTP id adf61e73a8af0-3da3a03ef42mr48516402637.14.1788922003934;
        Tue, 08 Sep 2026 19:46:43 -0700 (PDT)
Received: from TENCENT64.site ([103.7.29.106])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc4554a98fesm5977157a12.30.2026.09.08.19.46.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 19:46:43 -0700 (PDT)
From: Jun Yang <littleddfu@gmail.com>
X-Google-Original-From: Jun Yang <junvyyang@tencent.com>
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: Simon Horman <horms@kernel.org>,
	linux-sctp@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jun Yang <junvyyang@tencent.com>,
	stable@vger.kernel.org,
	TencentOS Corvus AI <corvus@tencent.com>
Subject: [PATCH net] sctp: check asoc->base.dead before the RCV_SHUTDOWN break in sctp_wait_for_connect()
Date: Wed,  9 Sep 2026 10:46:23 +0800
Message-ID: <20260909024626.3494588-1-junvyyang@tencent.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

sctp_wait_for_connect() sleeps with the socket lock dropped, so the
association can be destroyed underneath it: an out-of-the-blue ABORT
answering the INIT is drained from the backlog by that release_sock() and
ends in sctp_association_free().  The loop does revalidate the association
after waking, but the (sk->sk_shutdown & RCV_SHUTDOWN) break is evaluated
before all of those checks and leaves the loop with err == 0.  A concurrent
shutdown(fd, SHUT_RD) - inert on a one-to-many socket, where it only sets
the flag - therefore makes the function report a dead association as
connected, and the sctp_association_put() on the way out drops the last
reference.

sctp_sendmsg_to_asoc() trusts that 0.  Commit c863850ce22e ("sctp: not free
the new asoc when sctp_wait_for_connect returns err") turns a failure into
-ESRCH to stop exactly this double free, but it only covers err != 0.  The
freed association is then used by sctp_datamsg_from_user() and
sctp_set_owner_w(), and destroyed a second time by sctp_sendmsg().

Test asoc->base.dead at the top of the loop, as commit ca3af4dd28cf ("sctp:
do not free asoc when it is already dead in sctp_sendmsg") already does in
sctp_wait_for_sndbuf(), so a destroyed association always leaves via
do_error.  Keep the existing return values rather than adding an -ESRCH
escape, since sctp_wait_for_connect() is also the return value of connect().
base.dead is false on the first iteration in both callers - the socket lock
is held until the first release_sock() - so nothing changes for a live
association.

Reproduced on v7.3-rc2.

  refcount_t: addition on 0; use-after-free.
  WARNING: lib/refcount.c:25 at refcount_warn_saturate+0xf5/0x110
  CPU: 0 UID: 1000 PID: 261 Comm: poc 7.3.0-rc2 #1
   sctp_association_hold+0x96/0xa0
   sctp_sendmsg_to_asoc+0xc76/0x1c60
   sctp_sendmsg+0x11c0/0x1ee0
   __sys_sendto+0x3e7/0x470

  list_del corruption, ff11000104fa2070->next is LIST_POISON1
  kernel BUG at lib/list_debug.c:56!
   sctp_association_free+0x80/0x7c0
   sctp_sendmsg+0x199f/0x1ee0
   __sys_sendto+0x3e7/0x470

Fixes: 668c9beb9020 ("sctp: implement assign_number for sctp_stream_interleave")
Cc: stable@vger.kernel.org
Reported-by: TencentOS Corvus AI <corvus@tencent.com>
Assisted-by: tencentos-corvus-ai:hy4-preview
Signed-off-by: Jun Yang <junvyyang@tencent.com>
---
A reproducer for this issue is available if requested.

 net/sctp/socket.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index c7b9e325ec1c..de4bae94c9fa 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -9400,12 +9400,16 @@ static int sctp_wait_for_connect(struct sctp_association *asoc, long *timeo_p)
 	for (;;) {
 		prepare_to_wait_exclusive(&asoc->wait, &wait,
 					  TASK_INTERRUPTIBLE);
+		/* The asoc can be destroyed while sleeping below, and the
+		 * RCV_SHUTDOWN break reports success, so check it first.
+		 */
+		if (asoc->base.dead)
+			goto do_error;
 		if (!*timeo_p)
 			goto do_nonblock;
 		if (sk->sk_shutdown & RCV_SHUTDOWN)
 			break;
-		if (sk->sk_err || asoc->state >= SCTP_STATE_SHUTDOWN_PENDING ||
-		    asoc->base.dead)
+		if (sk->sk_err || asoc->state >= SCTP_STATE_SHUTDOWN_PENDING)
 			goto do_error;
 		if (signal_pending(current))
 			goto do_interrupted;
--
2.43.7

