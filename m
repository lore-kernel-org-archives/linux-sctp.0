Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795107827;
	b=DadYu6I8izXdPQydks7KxHGwHUd0VB6d/NiCEynJMZWlIW1/s0YyB5c+QsCFbIlAmiC8
	 MmTxrkSnppdoTa99+d5PhKOci0LLYBH4FBwJlzBbqChEh0BnyjXUVH/SvneBov1rx019M
	 wCiUUFQ6MtzUsA2wow9eXjyitkRr7xxR2aJGkmIMDASAMXYh4fvn4DbP2ucj+5PmcqWui
	 IWJCo5d5VYhkxX7jVgTo09vgl8h7yN+OQ6APNL1TDYCAsrvqCTpKewQcLMTKIpSY+NVVS
	 uXZLK/Rbh9fzJvQ0J5oDKIeaDpezCAVCmTQqYag0nTlRAno+d1mZhg5bf/wItSlUk/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795107827;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:Mime-Version:
	 X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=RoORXzLb277Rdk0jDhn23CA3scGInU/7CE/j8ILPC2U=;
	b=4SgmI/P4p7DFoBxQZO0AuTwR7AOmr+U5cbuoGaQlXmDHLKnoxsrkPNmMZXoipjVrTpNf
	 V6F/3ONw5r4+5BZC85XkzV2ViN64QpCx3/dMM6nFCh3dnqZVx3PQaBCtgf/dQiyT1MOyn
	 Q57J/7TJGGtHqsdMQ64FqwoSoYahMRvgVGEY97Ey4tkDzgYo0sGztLXia9++5SGwqIy7N
	 UGRMeP2IOgIxPiJc/zbenNu20Rz7Uc0nAVzZ3n7XmSvArhfoqZbbgcEj+jCoXOk5AjqCJ
	 qjlMYdyW1cyFG4YwgpDM8fE3Xh9vnvnNoLCDxdj8NcMEOHEJPhDqs2CFiEARbYDTMVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--irogers.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=pRf1H6KW;
	arc=none smtp.remote-ip=74.125.82.72
Received: from mail-dl1-f72.google.com (mail-dl1-f72.google.com [74.125.82.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAA4D606A325
	for <linux-sctp@vger.kernel.org>; Thu, 19 Nov 2026 17:03:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DAA4D606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--irogers.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=pRf1H6KW
Received: by mail-dl1-f72.google.com with SMTP id a92af1059eb24-1b3b5b49cabso2091085c88.0
        for <linux-sctp@vger.kernel.org>; Thu, 19 Nov 2026 09:03:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795107826; x=1795712626; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=RoORXzLb277Rdk0jDhn23CA3scGInU/7CE/j8ILPC2U=;
        b=pRf1H6KWASLQWbCXQXj/AniEbxnzqZjDqFGZfvGIXM1N7OlLmqGYqDPLD9tLvvG8fE
         rMxQzxBfTozcwV5HKdEokJ6r0/aF7WmEbHQSDr77HyIVSlDam7AXH4aORlMgFEIJf3oc
         Tf5OI8LVVOQXI+xpxFSodPDWJ7+BCPNrMkDdV+UtgapscTirg8pWxvuu4VEWxFB487Mc
         NXmj0C0FVqp6RGuc2FxI29ETIAodXKVbJ72f5VTDLqNBuu2BleyfZYjPuDPHAi5nGKh3
         FwSYYM5AHdMBoMLD4AZFCjwWMuUMouQZqFicNN2mx7DoUq/TVw/+f+1PZZ+8FPRYsXu5
         Va1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795107826; x=1795712626;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RoORXzLb277Rdk0jDhn23CA3scGInU/7CE/j8ILPC2U=;
        b=vaYWkC5Sq1LWBePtCz9sLdvkykW3q6Rq6R3lAUnJhrt/n3VYEeKT8WrupVlNRLrhxZ
         vxMnBjar/kt7KsDUw8Ws6hyMW0nwYTRuhbY6RwiNe4Aa2hJ99kokHnCtuLlCxnaI/oKY
         JAajxjnqMu4MsyRy13UHFW2cKSgMGDnCi4fJT97bC24OmbA3iA8XnX6zVnkgTym8KA53
         ZN0MX5y8NTXVa7gw0i3o3ClGNTQGh0qUoYAMIOgdE2i8Hx0H3ugmcAO1IVx9MFARW5yv
         n14mpWpVfQRTMOFT2uB/VPJVjNpCZYR4tCaNYcqDcoZhoqUEU3K8iyRrm2yg3wlyYQTg
         c92g==
X-Forwarded-Encrypted: i=1; AL+hErFnZJX/ctv89HwRXlErukXYCeLH/1g/aVUeIYqrEPAo54sk7Bap7TWBauJ+7aZ0SSlqqYGj4bkMIbBI@vger.kernel.org
X-Gm-Message-State: APuU4Z8I/VchVj+7pOdwCZCr2Z2F1m/uQ3ifLnGiNDkcqBkmv0zYIS7h
	yCp0A96azFe6kXX7b9I0YDB+dv7OO3QTU/Ls0ctAHYZ11vm9WtLJ3dpJY0dCcbZ/Y/9F0X4O0Js
	rlQIXu77d/Q==
X-Received: from dldyq18-n1.prod.google.com ([2002:a05:701b:4552:10b0:195:d59a:94bc])
 (user=irogers job=prod-delivery.src-stubby-dispatcher) by 2002:a05:701b:2083:10b0:164:4e36:f956
 with SMTP id a92af1059eb24-1b5568b47a4mr238242c88.16.1795107825531; Thu, 19
 Nov 2026 09:03:45 -0800 (PST)
Date: Thu, 19 Nov 2026 09:03:42 -0800
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Post: <mailto:linux-sctp@vger.kernel.org>
List-Help: <mailto:linux-sctp+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sctp+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.1.708.g77570a6a1d-goog
Message-ID: <20261119170342.1508789-1-irogers@google.com>
Subject: [PATCH net] sctp: initialize new_value in custom proc_dointvec sysctl handlers
From: Ian Rogers <irogers@google.com>
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Xin Long <lucien.xin@gmail.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: Simon Horman <horms@kernel.org>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev, 
	Elkin Cruz <elkin@google.com>, Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"

proc_sctp_do_rto_min(), proc_sctp_do_rto_max(), proc_sctp_do_auth(),
proc_sctp_do_udp_port(), and proc_sctp_do_probe_interval() point
tbl.data at an uninitialized stack variable new_value on writes before
calling proc_dointvec().

proc_dointvec() can return 0 without writing to tbl.data, for example on
a zero-length write (*lenp == 0) or on a write at a non-zero file offset
ignored by proc_first_pos_non_zero_ignore() (such as pwrite(fd, "1\n",
2, 1) or a split write where the trailing newline is written separately).

When that happens:
- proc_sctp_do_auth() unconditionally stores the uninitialized stack int
  into net->sctp.auth_enable and sctp_sk(sk)->ep->auth_enable, both
  corrupting SCTP authentication state and leaking 4 bytes of kernel
  stack memory back on subsequent sysctl reads.
- proc_sctp_do_rto_min(), proc_sctp_do_rto_max(),
  proc_sctp_do_udp_port(), and proc_sctp_do_probe_interval() validate
  the uninitialized value and overwrite the netns setting whenever stack
  bytes happen to fall within range.
- proc_sctp_do_udp_port() also stops and restarts the UDP encapsulation
  socket even when the port number did not change.

Initialize new_value to the current netns setting before calling
proc_dointvec() (matching proc_dobool()), and skip tearing down and
restarting the UDP encapsulation socket in proc_sctp_do_udp_port() when
new_value equals net->sctp.udp_port.

Found by enabling Clang's -Wconditional-uninitialized on an x86_64
allyesconfig build, with AI coding assistant help to audit the warning
and prepare the fix. Build-tested with Clang; not runtime-tested.

Fixes: 4f3fdf3bc59c ("sctp: add check rto_min and rto_max in sysctl")
Fixes: b14878ccb7fa ("net: sctp: cache auth_enable per endpoint")
Fixes: 046c052b475e ("sctp: enable udp tunneling socks")
Fixes: d1e462a7a5f3 ("sctp: add probe_interval in sysctl and sock/asoc/transport")
Signed-off-by: Ian Rogers <irogers@google.com>
---
 net/sctp/sysctl.c | 39 +++++++++++++++++++++++----------------
 1 file changed, 23 insertions(+), 16 deletions(-)

diff --git a/net/sctp/sysctl.c b/net/sctp/sysctl.c
index 2b94c211427d..0c33f05fa532 100644
--- a/net/sctp/sysctl.c
+++ b/net/sctp/sysctl.c
@@ -425,8 +425,9 @@ static int proc_sctp_do_rto_min(const struct ctl_table *ctl, int write,
 	struct net *net = container_of(ctl->data, struct net, sctp.rto_min);
 	unsigned int min = *(unsigned int *) ctl->extra1;
 	unsigned int max = *(unsigned int *) ctl->extra2;
+	int new_value = net->sctp.rto_min;
 	struct ctl_table tbl;
-	int ret, new_value;
+	int ret;
 
 	memset(&tbl, 0, sizeof(struct ctl_table));
 	tbl.maxlen = sizeof(unsigned int);
@@ -453,8 +454,9 @@ static int proc_sctp_do_rto_max(const struct ctl_table *ctl, int write,
 	struct net *net = container_of(ctl->data, struct net, sctp.rto_max);
 	unsigned int min = *(unsigned int *) ctl->extra1;
 	unsigned int max = *(unsigned int *) ctl->extra2;
+	int new_value = net->sctp.rto_max;
 	struct ctl_table tbl;
-	int ret, new_value;
+	int ret;
 
 	memset(&tbl, 0, sizeof(struct ctl_table));
 	tbl.maxlen = sizeof(unsigned int);
@@ -489,8 +491,9 @@ static int proc_sctp_do_auth(const struct ctl_table *ctl, int write,
 			     void *buffer, size_t *lenp, loff_t *ppos)
 {
 	struct net *net = container_of(ctl->data, struct net, sctp.auth_enable);
+	int new_value = net->sctp.auth_enable;
 	struct ctl_table tbl;
-	int new_value, ret;
+	int ret;
 
 	memset(&tbl, 0, sizeof(struct ctl_table));
 	tbl.maxlen = sizeof(unsigned int);
@@ -522,8 +525,9 @@ static int proc_sctp_do_udp_port(const struct ctl_table *ctl, int write,
 	struct net *net = container_of(ctl->data, struct net, sctp.udp_port);
 	unsigned int min = *(unsigned int *)ctl->extra1;
 	unsigned int max = *(unsigned int *)ctl->extra2;
+	int new_value = net->sctp.udp_port;
 	struct ctl_table tbl;
-	int ret, new_value;
+	int ret;
 
 	memset(&tbl, 0, sizeof(struct ctl_table));
 	tbl.maxlen = sizeof(unsigned int);
@@ -541,18 +545,20 @@ static int proc_sctp_do_udp_port(const struct ctl_table *ctl, int write,
 			return -EINVAL;
 
 		mutex_lock(&sctp_sysctl_mutex);
-		net->sctp.udp_port = new_value;
-		sctp_udp_sock_stop(net);
-		if (new_value) {
-			ret = sctp_udp_sock_start(net);
-			if (ret)
-				net->sctp.udp_port = 0;
+		if (new_value != net->sctp.udp_port) {
+			net->sctp.udp_port = new_value;
+			sctp_udp_sock_stop(net);
+			if (new_value) {
+				ret = sctp_udp_sock_start(net);
+				if (ret)
+					net->sctp.udp_port = 0;
+			}
+
+			/* Update the value in the control socket */
+			lock_sock(sk);
+			sctp_sk(sk)->udp_port = htons(net->sctp.udp_port);
+			release_sock(sk);
 		}
-
-		/* Update the value in the control socket */
-		lock_sock(sk);
-		sctp_sk(sk)->udp_port = htons(net->sctp.udp_port);
-		release_sock(sk);
 		mutex_unlock(&sctp_sysctl_mutex);
 	}
 
@@ -564,8 +570,9 @@ static int proc_sctp_do_probe_interval(const struct ctl_table *ctl, int write,
 {
 	struct net *net = container_of(ctl->data, struct net,
 				       sctp.probe_interval);
+	int new_value = net->sctp.probe_interval;
 	struct ctl_table tbl;
-	int ret, new_value;
+	int ret;
 
 	memset(&tbl, 0, sizeof(struct ctl_table));
 	tbl.maxlen = sizeof(unsigned int);
-- 
2.56.1.708.g77570a6a1d-goog

