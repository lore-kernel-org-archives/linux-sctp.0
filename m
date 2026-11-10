Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.225.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794350578;
	b=ht1MF9vILkgShUNdQ0tn5PLoDoys6FcmwDZz+N/WJbzGkB+Y4TyEGGtbhBU1fgJmhjNa
	 nap+YwLYI2AiWRWp1aqXylePV6KF31xvo3CGXynJYfOQYpzILHH2d3+EdRUrta8KjdYdU
	 0p3aj52FDfUB7fOiMHBfJ6MXVQYEfu5w+YDztd4vNiP+MYnC2DHG5LjUZ2dv1oSOQt3wz
	 MzV0OUHXDFf23Z1VcRSQ9xO9zb0aTOYv234ocPmprMIcHjME4y23YMUL6JpR315idrDyv
	 s527Hu7Tz4QMn4CuQtDn+MaZLQ1xeR14hsqD7fYcbDh5x+ZL55wCP6DZzKSyED+Cy8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794350578;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=65ccBi3rzxm73dF4Hh1JDA1NcutcYotrBjNv9MyOyhM=;
	b=jWlj8ZnhV+dnuPnGf2jeuH788gepdqtS2srr99EtUXOyKOn29xqF6k9+ph6k4zwE8EhD
	 8JebqefY0p470WKcPdOBddWNAHQqv2Gh7JJPKRVt3Acwg6n1JcAB8E3OyDV6fU0cLZV2k
	 HLgDhdSlYoVK7bHck7Prcy6d7hR/0iOcvB3eAQEcDaf8q1ZEl7e226QaSEa0OcGSiC09W
	 PhQkmidrifD69lmNoJQyRawxKehQNQGEqKWFPLnmqlDOSYDjr+dXHw7oad/mYPSSclxn5
	 YiV/MYPwPZN5R6m4I/INJsTYcfCWDeh2GvGNlWIFFy7/3k4ahHYPOhriqfE8rYaJ+CQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=theori.io;
	spf=pass smtp.mailfrom=theori.io;
	dkim=pass header.d=theori.io header.i=@theori.io header.a=rsa-sha256 header.s=google2026 header.b=B97Y8h0+;
	arc=none smtp.remote-ip=74.125.225.133
Received: from mail-wm2-f5.google.com (mail-wm2-f5.google.com [74.125.225.133])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90166606A325
	for <linux-sctp@vger.kernel.org>; Tue, 10 Nov 2026 22:42:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 90166606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=theori.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=theori.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=theori.io header.i=@theori.io header.a=rsa-sha256 header.s=google2026 header.b=B97Y8h0+
Received: by mail-wm2-f5.google.com with SMTP id 5b1f17b1804b1-4a35e178418so9831065e9.0
        for <linux-sctp@vger.kernel.org>; Tue, 10 Nov 2026 14:42:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=theori.io; s=google2026; t=1794350575; x=1794955375; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=65ccBi3rzxm73dF4Hh1JDA1NcutcYotrBjNv9MyOyhM=;
        b=B97Y8h0+lfe0/AHj05Oi62WQcXmqYayJBwOKgM1wVexj6YwUmIAqvFuBFFwUuqlfgS
         IcISOfys3nOJeliQbQCcJI93jcdbdCp0miw66BPLtx4h+/++Za5uIfBKuLI3ATz3lC3j
         HeqMIeq50joZTvZ26NwuKH5VbWUCHE66zQK6M3eYQ2ECiTJi8//6KaCbID4zOxfEgcu/
         teqJcgi6kRX+vyvKE1n6iRdOchyPXoxjB5BhNTAjzDzu5FJNS2/I4f8zopNLKYtM+VV5
         ee0+gKenqyZmr7UVHrh0ElNeP59/hS3F0+poENrwM70ne0tofjwHpS1Zkci6R7Y/Ok6L
         jqDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794350575; x=1794955375;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=65ccBi3rzxm73dF4Hh1JDA1NcutcYotrBjNv9MyOyhM=;
        b=yHDooWRD4WJUcykM/B5TILY4VfWpZYsgspF2f8q5xx3XdybMXDmU8KjmxwxEBsqc22
         o25AmA8r/Q3ghhD0gzcc2Ge/zRuJ4NZuPC9YRaQ+4GiDjz+h4ACtPera0lIxw8qH3c9t
         nObpqOxrsO8CflD0IgBRhUQp9UJm7Q4VgShtwALgNt6uJFmbzwI0stQW/5EHqpUgMvIo
         iCZtIXqaebrtWJHfMVghAz0RKhQpRk+T21Ugk4/YXi/PzRc4K5mXxJUQoQYar+Hk4l+4
         9k5eTm5Dp0xzfOgA8eGxUSSuGoQkzasQUcRuji7cq5qsC5SYBEIhTam2AGAohcMwLXM+
         7J8w==
X-Forwarded-Encrypted: i=1; AL+hErFIWHZBdrSHpj2+8aq6b3RKZ1icQuFn2R3Ds+EYqdnk6HoOZA/Z0UJZkFtcFu/uvdyICz2VHAXnF/RS@vger.kernel.org
X-Gm-Message-State: APuU4Z+XyFYpsTSw1qStUF7SmeyRmLfYWo7hdL4OuhbD63Gt5Dp6orOl
	YizREIAoz1bmHLw2f3yqeeMxWkJN4jRhCPXA5f6RQyirh5pa45eNMJU5UHD/vvFX0Ko=
X-Gm-Gg: AYBFou1ldlrc44Jh8HDVbe3Da39zMUW7Weel97QQX9msxWdeoGLJMSln74yV2N0Z+Op
	6Z7tjBO5ZgnDkVpg8AMqZ/uc3TWbgg33Ui27mobZRK8y/EMx4/Iu8HJIl3HatYrUL7uNdxEq8N9
	AD+BuuC/RfvUvsGlWQIzF9U/Ckgiq+8duUbC3VmFfeZLYW1cH899JohlfF7gD+M01LZCPOzbLCj
	wVj0HrX/+MFevOBMEd3hNJjxkkSjmHFMqXQLSvxme/tdI6EEFt+B6Q8b8pdzzkdgap6QvEASHi2
	bHBiz9SDlDzvhFWIJ+Nf4G9sDpE77M6Tp2fU2VDNo+wt9x5BLRsN6dJTIG4cBs9Pnj83KPaue3f
	W4Z/KMzwN3a3ELWHK4ajVwL64ZZLjF9KzVABH3xTJ1XEmpYQGLaCs8rjnVTszxK4CX3MQ9w1PV/
	gxmoE/uTRgm70ZqGr07eNpat7NwDhu0Wylnhb9XI5zDdq4Uky2UiwcVKavc3QXnF7jFbd7ySCNa
	Sp0cc3vl0oGEhYaQqKfghOn9hETSsqdB0roRutmJ0cB6aYvucp6BOR65KMXmoHdgx01jz2MD4ja
	VTOJkZsUCj3L/6j7zxIi17vMfrjJVC07Iqu+c5O2Bw8JBbjqHrNdCd6hyzzqk5XAlijbYv8eNfW
	qxlWWzg==
X-Received: by 2002:a05:6000:2308:b0:48e:6f76:de9c with SMTP id ffacd0b85a97d-499c6e9636amr523356f8f.28.1794350574841;
        Tue, 10 Nov 2026 14:42:54 -0800 (PST)
Received: from localhost.localdomain (bbcs-110-227.pub.wingo.ch. [144.2.110.227])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4983585923bsm7599946f8f.11.2026.11.10.14.42.52
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 10 Nov 2026 14:42:53 -0800 (PST)
From: Yves Bieri <yves.bieri@theori.io>
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Xin Long <lucien.xin@gmail.com>
Cc: "David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	linux-sctp@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yves Bieri <yves.bieri@theori.io>,
	stable@vger.kernel.org
Subject: [PATCH net] sctp: do not free a new asoc peeled off while sendmsg slept
Date: Tue, 10 Nov 2026 23:42:33 +0100
Message-ID: <20261110224233.82977-1-yves.bieri@theori.io>
X-Mailer: git-send-email 2.54.0
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

When sctp_sendmsg() creates a new association and sending on it fails
with anything but -ESRCH, it frees the association. The send can
sleep in sctp_wait_for_sndbuf(), which releases the socket lock, and
meanwhile another thread can peel the new association off to a new
socket. The wait then returns -EPIPE, and sctp_sendmsg() frees an
association that now belongs to the peeled-off socket, without holding
that socket's lock.

If the peeled-off socket frees the association first, e.g. on close(),
sctp_sendmsg() frees it a second time. Otherwise a syscall running
concurrently on the peeled-off socket can use it after sctp_sendmsg()
freed it. Both are reachable by an unprivileged user. The double free
on net with KASAN:

  BUG: KASAN: double-free in sctp_tsnmap_free+0x5c/0x80
   sctp_association_free+0x1eb/0x750
   sctp_sendmsg+0x15ff/0x2020
  Freed by task 836:
   sctp_association_free+0x1eb/0x750
   sctp_primitive_ABORT+0x85/0xe0
   sctp_close+0x22a/0x8d0

Commit dfcb9f4f99f1 ("sctp: deny peeloff operation on asocs with threads
sleeping on it") fixed this double free by denying the peeloff.
Commit cea0cc80a677 ("sctp: use the right sk after waking up from
wait_buf sleep") replaced that check, and commit a0ff660058b8 ("sctp:
return error if the asoc has been peeled off in sctp_wait_for_sndbuf")
reverted it to return -EPIPE, without restoring the check.

Fix this by holding a reference on the new association while sending
on it, and by freeing it on error only if this socket still owns it.
asoc->base.sk only changes in sctp_sock_migrate(), which runs with this
socket locked, so the ownership check is stable. The reference keeps
the check safe if the new owner frees the association meanwhile.
Userspace still gets -EPIPE, and the association stays with the socket
it was peeled off to.

This was found by Xint Code, an AI code review agent, and reproduced as
an unprivileged user on net with KASAN (trace above), without modifying
the kernel or using error injection. With this patch the sender gets
-EPIPE and the association keeps working on the peeled-off socket.
Without a peeloff, a failed send that created the association (EAGAIN,
EINTR) still frees it, and a peer ABORT while the sender sleeps still
frees it exactly once. The SCTP selftest sctp_vrf.sh passes. The
reproducer is available on request.

Fixes: a0ff660058b8 ("sctp: return error if the asoc has been peeled off in sctp_wait_for_sndbuf")
Cc: stable@vger.kernel.org
Signed-off-by: Yves Bieri <yves.bieri@theori.io>
---
Tested on net at b71c101bbb98.

The fix and this message were drafted with Claude, and reviewed and
tested by me.

 net/sctp/socket.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index b5a57f6..e7e14a0 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -2082,10 +2082,20 @@ static int sctp_sendmsg(struct sock *sk, struct msghdr *msg, size_t msg_len)
 	/* Update snd_info with the asoc */
 	sctp_sendmsg_update_sinfo(asoc, sinfo, &cmsgs);
 
+	/* sctp_sendmsg_to_asoc() may release the socket lock while waiting,
+	 * and a new asoc can be peeled off to another socket meanwhile.  Hold
+	 * it, and free it on error only if it is still owned by sk.
+	 */
+	if (new)
+		sctp_association_hold(asoc);
+
 	/* Send msg to the asoc */
 	err = sctp_sendmsg_to_asoc(asoc, msg, msg_len, transport, sinfo);
-	if (err < 0 && err != -ESRCH && new)
-		sctp_association_free(asoc);
+	if (new) {
+		if (err < 0 && err != -ESRCH && asoc->base.sk == sk)
+			sctp_association_free(asoc);
+		sctp_association_put(asoc);
+	}
 
 out_unlock:
 	release_sock(sk);

base-commit: b71c101bbb9814d163c00234d43c41f0a17907d4
-- 
2.43.0
