Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795614546;
	b=t+D8BHs0avVD1FlHw7+CPtNYozfqxESQP9WV5b5Oh/9TO9nn5JI9eSDn59s1A7hWvxJ/
	 5fs5wv5QA/lF2BBJctTfjeDQvKomHnYSIiswOZuBM2J4M60i54JG+8EDQSHL7ypPJ74Iz
	 COBKHDEGZ9XQi+XgFZOB+ysA9aP2o7FRPxDs2LdyAJ2KZSGKEOkUucNPlYQYyUHr5vsjS
	 gXT1Lgp9llcAL3xUBc1iZW0FUimruJQ7QE6JYQYKKZu1XodvG/EfBLd1Su1cez0HYEcbI
	 plIHYYoKFUZQ4uB5PV1MF+Nr4D32DZxKW1bzu4yb6O8h+9AdH9mQ69ySIR6oDroRs9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795614546;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:MIME-Version:
	 Content-Transfer-Encoding;
	bh=q+TEqk3BrCSLG9dvbIoNPDzAN/9pi420Wcl40rHqq+o=;
	b=P294OjthaRPI/XxSy4IXYu4hpZ/pnbYIBViUGAPj8rHf96dkmfBfGHtRsKBI2j4zQgJv
	 7szYRE6Wb207xzqszq9dwSHp110MnSi17KRPIxE6S/LA2G/Hd9US3ScF0wbXD/Q6DI/vC
	 gnDAihcW+JmiG+UeYwEFcl4OJtV22jJKFIJlaYr5Xx933d7f6IVu9mQQI+uqMW05qCLVu
	 i5p3hUrMvjBmJrJZbxSC8j9feQ6cD8cjCNK/K+JsIZuMGAt/C/H988WPkKAkWiXxtmsXI
	 Otj/s1hTfh5AbLGPvMfhV4HSLUmNa+cwvtyR57ybfjx2OwzqfUb9N9TFny5T4fKlIfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=GBRswj5m;
	arc=none smtp.remote-ip=74.125.82.181
Received: from mail-dy1-f181.google.com (mail-dy1-f181.google.com [74.125.82.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BC5D606A323
	for <linux-sctp@vger.kernel.org>; Wed, 25 Nov 2026 13:49:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1BC5D606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=GBRswj5m
Received: by mail-dy1-f181.google.com with SMTP id 5a478bee46e88-386cf1041cdso1425998eec.0
        for <linux-sctp@vger.kernel.org>; Wed, 25 Nov 2026 05:49:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795614545; x=1796219345; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=q+TEqk3BrCSLG9dvbIoNPDzAN/9pi420Wcl40rHqq+o=;
        b=GBRswj5mjNzJLymR8dayJW2ojhT2B30cBwmTXtrjzjIB6rH4miof2IkwnmfCPkZ+tE
         OB8BdB5RSDtOUYv+Nk7IBRHQbisa0gKrP2h+nrf3xSyeKgJjlzFbpG92Cj+OimTgatH6
         Kx4RZuCHUqHH9PhjA2seW3rWWhHvHiojuZE3rhzQ4R4cxB2dy05jQZFE8CFCn1GUcMxD
         NSKUdGQnSZ3cwaPMmoaXsOcSvGdpo+iV9TdPa6spZLj82SV6FJR9sjey6hNSZaBMyPFz
         n7fSLN7vkfRCIliZpNdyR/8hh2uy4l9O1Uo8hOmiccsxRQGcSMH+2qa6e7ioM+0zsLol
         6yXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795614545; x=1796219345;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=q+TEqk3BrCSLG9dvbIoNPDzAN/9pi420Wcl40rHqq+o=;
        b=dGVrcbzDgWKGNxX4H7PmBFAAbxmw9lFLeK7W6WpBB/JB4g69v2nFFm5o2oUyKkvJ9W
         wPTg/3stxHuZUl2Tq8cEwxSd+PXEhnCD2/0sEwEIgXjizQN2uO+G/tLAV7bDU6h/qCpp
         6kHsYZGcmLrvHbc5uGJZTfYHebs3QLzzp8vb9jFoJEL2vbKnAgYy77r4DlnvEMP8s7Ph
         AtHvPIxhft1REzHqAOwjZoJG3+oPFYEn41ujZcyCjsubhTIJVtnK0/+/tYqMYnfF9kzG
         pF2DYtbH4iy+XFLQy/8NjJlVZ/ZEeItiOl3PJ/CcxgFOgg91uCU8LCIXlCOlEpG3Za1f
         Uigg==
X-Forwarded-Encrypted: i=1; AL+hErEH/S3O31vs2IoKW/QLEYB8nNWh4Y6yWaA4VlJPv0xkAgQm7+EwHpC6N8gwDu8YnBl2V9x2x94+C9Bu@vger.kernel.org
X-Gm-Message-State: APuU4Z/Pq8fJI1JeKJj+IeSw058qL6jH3ufNIzGFDZNsrIg76mpjZCu6
	I3CkMPlrd2l7HtzGWzXkWunERLssZVR6KDl+UmP1DikMsSkw0YEPXFSy
X-Gm-Gg: AZFdTZd46OpLZ/2sm76BqfMLQYk5PeaIsKQZ6kbfvmkG99rSIyFC/QUm5Xzi7jG97TL
	fAP5UHLuK0hscNEh1bcrJE3A+tuOcPJyMxjNIaRLpLZloeuLew6zz0/72X2qZ6DMlrSyShvZpVT
	qJwfJ1YqdLVkAUriIfcTtZ4b3o0av+CEzya/wNd15j/N8EZHaGgDmWsJvAC4Js8FWyyV6budza0
	dutt9/Vc8DOyIfH/AXLep9Ux0Ymikujb+CGLPfSuwFEdJEUDlwi8l4MNKoy5l9IohvCdr6feQB0
	vBm68Zo6uL7xoiUE7fhUB/B+ohpLqUoBhLmqhf1SJaf7pukzPz+v7ohK38jooudxmQvlgS4q+3N
	PxmzbCBVHf/GJC5Hojsl3UJRx2YGZLU7vPi+CYRDrIhnTIrP+/AkV66BBtDjJTSMNMNprZJwB6K
	qpORDM8woNY3Cw7duBvdW5dDnrjIVq68CLP+j6XoeeCiex8wn88jjAQ6S0JbJga+BmFJ//F5aBg
	QaTk5a2AmPYnUgo9yt7ug0Ju+ZIOMhsGhiAc4zNNb+dP3uRBhwiZXUBNyNXgzZA2vlyH4UaLVDb
	rnrOHmtnvU9QYpmL2SAgoKo9rcFvZFaB3V2MP3bCNyNGw/4Lw1T0ILu5y1aIOI7VbQCJPCmzimO
	dE21xXC3bghzX
X-Received: by 2002:a05:7301:7107:b0:386:b494:8642 with SMTP id 5a478bee46e88-386b494879amr8586265eec.13.1795614544884;
        Wed, 25 Nov 2026 05:49:04 -0800 (PST)
Received: from d20be28ee783.tail196be.ts.net (vldb.skku.ac.kr. [115.145.173.180])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-385665f21aesm66740398eec.4.2026.11.25.05.49.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 05:49:04 -0800 (PST)
From: Kyuwon Cho <kyuwoncho18@gmail.com>
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Xin Long <lucien.xin@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemb@google.com>,
	Simon Horman <horms@kernel.org>,
	Neil Horman <nhorman@tuxdriver.com>,
	Mao Wenan <maowenan@huawei.com>,
	linux-sctp@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH net] sctp: keep the port of a bound socket when adding an address fails
Date: Wed, 25 Nov 2026 22:49:00 +0900
Message-ID: <179560159232.2963157.3418291084812904092@gmail.com>
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

Since commit 29b99f54a8e6 ("sctp: destroy bucket if failed to bind
addr"), sctp_do_bind() releases the port when sctp_add_bind_addr()
fails. sctp_bindx_add() also calls it for each extra address of a
socket that is already bound, and possibly listening. There
sctp_get_port_local() takes no new reference, but the failure path
still calls sctp_put_port(), which unhashes the port and clears
bind_hash and inet_num while the socket keeps its other addresses and
stays listening. listen(0) then writes through the NULL bind_hash, and
accept() of a pending association oopses in sctp_clone_sock():

  KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
  RIP: 0010:sctp_inet_listen (net/sctp/socket.c:8723)
  Call Trace:
   __sys_listen (net/socket.c:2016)
   __x64_sys_listen (net/socket.c:2021)
   do_syscall_64 (arch/x86/entry/syscall_64.c:61)

Release the port only when this call took it, that is, when the socket
had no bind_hash before.

Fixes: 29b99f54a8e6 ("sctp: destroy bucket if failed to bind addr")
Signed-off-by: Kyuwon Cho <kyuwoncho18@gmail.com>
---
The issue was found by an LLM-guided test generator that we are
developing as a research prototype. A reproducer, which runs as any
user with CONFIG_FAILSLAB:

#define _GNU_SOURCE
#include <arpa/inet.h>
#include <fcntl.h>
#include <net/if.h>
#include <sched.h>
#include <stdio.h>
#include <sys/ioctl.h>
#include <sys/socket.h>
#include <unistd.h>

#define SCTP_SOCKOPT_BINDX_ADD	100

/* needs CONFIG_FAULT_INJECTION and CONFIG_FAILSLAB; runs as any user */
int main(void)
{
	struct ifreq lo = { .ifr_name = "lo", .ifr_flags = IFF_UP };
	struct sockaddr_in a = {
		.sin_family = AF_INET,
		.sin_port = htons(30114),
		.sin_addr.s_addr = htonl(INADDR_LOOPBACK),
	};
	int s, one = 1, nth = open("/proc/thread-self/fail-nth", O_WRONLY);

	if (unshare(CLONE_NEWUSER | CLONE_NEWNET))
		return perror("unshare"), 1;
	s = socket(AF_INET, SOCK_STREAM, IPPROTO_SCTP);
	ioctl(s, SIOCSIFFLAGS, &lo);
	bind(s, (void *)&a, sizeof(a));
	listen(s, 5);
	setsockopt(s, SOL_SOCKET, SO_REUSEADDR, &one, sizeof(one));

	/* fail the allocation in sctp_add_bind_addr() */
	a.sin_addr.s_addr = inet_addr("127.0.0.2");
	if (write(nth, "1", 1) != 1)
		return perror("fail-nth"), 1;
	printf("bindx add: %d\n",
	       setsockopt(s, IPPROTO_SCTP, SCTP_SOCKOPT_BINDX_ADD, &a, sizeof(a)));

	printf("listen(0): %d\n", listen(s, 0));
	return 0;
}

Without the patch, listen(0) oopses as above; with it, it returns 0,
and in a variant that accepts a pending association, accept()
returns the new socket.

The patch was written with LLM assistance; we reviewed and tested it.

 net/sctp/socket.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index bc68af88e271..519063833aac 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -420,6 +420,7 @@ static int sctp_do_bind(struct sock *sk, union sctp_addr *addr, int len)
 	struct sctp_bind_addr *bp = &ep->base.bind_addr;
 	struct sctp_af *af;
 	unsigned short snum;
+	bool bound;
 	int ret = 0;
 
 	/* Common sockaddr verification. */
@@ -467,6 +468,7 @@ static int sctp_do_bind(struct sock *sk, union sctp_addr *addr, int len)
 	 * The function sctp_get_port_local() does duplicate address
 	 * detection.
 	 */
+	bound = sp->bind_hash;
 	addr->v4.sin_port = htons(snum);
 	if (sctp_get_port_local(sk, addr))
 		return -EADDRINUSE;
@@ -484,7 +486,8 @@ static int sctp_do_bind(struct sock *sk, union sctp_addr *addr, int len)
 				 SCTP_ADDR_SRC, GFP_ATOMIC);
 
 	if (ret) {
-		sctp_put_port(sk);
+		if (!bound)
+			sctp_put_port(sk);
 		return ret;
 	}
 	/* Copy back into socket for getsockname() use. */
-- 
2.43.0

