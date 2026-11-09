Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.1
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794193223;
	b=e0B6zMxBX2zETxfXJZC9uDm33NyVnEzwqq/J9kOoQx7Rl0SFBuh1qqaEuTvLpq9Cv3RO
	 fwC1jtp6JRut7g3m83CxUYSIMc11Nrhf4tWnw4JEmmoQRcxE8mNuHSI2UIRw0BCe/8jMP
	 pb2QiBGp9aiTE4Zv+DjTavbHy4I+BWDl8To+TZpAV13ypa8aXGeSJujJfxb4VS7A8WgVj
	 cDIAy3fdpReQeYlPfRJ3Jy0tSnlo+brDCcBvw8rEl3P62XJgcPiM2e2C3Mkvrt90ePSih
	 fkEIkNA94RWsm26YvUsH/kvX2tR0nTX9VZfYBR+gWruVkp0B9ePVQ8fjEU1bHuEYUww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794193223;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=XKiQIorj2y2/pH/PLJmaYrty47uTj0nmh8YMBi+fHS0=;
	b=31YAUbHOBDIY0AhmF7aTg/IyvunP4bFcWIC2wmkcwGGgCH3IBR1TKkpqAez5K3hn4fdH
	 GYFlEL07iwOfp2kANegtZhSi+KpJ+Kvm0XiB4psTI1uREgTHcaoVUZoZ65qi6GZoWcrJO
	 eoi6LsA1ghR9PSq8bBA05BUYRI/swxf5Yp+8mx3uR4x2OJjv8d9LsOR15PFRu3tXNZsjK
	 tGeTlekdo/MXIsQ9jPN1EsVIFkcYZx4hrNHozs0knoJ4DNQFRE+Bc8B0ZwdHMZtfp9AIp
	 N4klKbTZlJ+rYtS1cPPV4KgQDI3pDnscPrZbwGsJ5+Ne4p6nCu46FVSKeYeSa5hPq+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=iGM6EGEZ;
	arc=none smtp.remote-ip=91.218.175.1
Received: from mta0.migadu.com (out-1.mta0.migadu.com [91.218.175.1])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C912606A320
	for <linux-sctp@vger.kernel.org>; Mon,  9 Nov 2026 03:00:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0C912606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=iGM6EGEZ
X-Envelope-To: linux-sctp@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=KReNeCFx0VtyfDXYfamQGFIfQ6CxDn+RBqDsMYJq/6g=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794193221; v=1; x=1794798021;
 b=iGM6EGEZhHiPpTFW7+51FAvIFUXLeUGjzb0W12bISLEX0m3l4jHB0WVLFX+pOAbO2uaW/1ur
 Yet3Xcz92/kTHlKb0C9GGtK0uBb0VJ3hzG7oruRWyV8U5NFfIAMnnUU+w2q0fttWQgDsfjpqSrC
 Hc87dlop8ytFkrPzKc7EOe8Y=
X-Envelope-To: linux-sctp@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id a14b75727c5eeb5f;
	Mon, 09 Nov 2026 03:00:15 +0000
X-Mizu-Trace-ID: a14b75727c5eeb5f
X-Migadu-Flow: FLOW_OUT
From: Jiayuan Chen <jiayuan.chen@linux.dev>
To: netdev@vger.kernel.org
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>,
	David Ahern <dsahern@kernel.org>,
	Ido Schimmel <idosch@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Paul Moore <paul@paul-moore.com>,
	Matthieu Baerts <matttbe@kernel.org>,
	Mat Martineau <martineau@kernel.org>,
	Geliang Tang <geliang@kernel.org>,
	Julian Anastasov <ja@ssi.bg>,
	Allison Henderson <achender@kernel.org>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	"D. Wythe" <alibuda@linux.alibaba.com>,
	Dust Li <dust.li@linux.alibaba.com>,
	Sidraya Jayagond <sidraya@linux.ibm.com>,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Tony Lu <tonylu@linux.alibaba.com>,
	Wen Gu <guwen@linux.alibaba.com>,
	linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	bridge@lists.linux.dev,
	linux-security-module@vger.kernel.org,
	mptcp@lists.linux.dev,
	lvs-devel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	rds-devel@oss.oracle.com,
	linux-sctp@vger.kernel.org,
	linux-s390@vger.kernel.org
Subject: [PATCH net-next 12/14] net/smc: annotate data-races around smc sysctls
Date: Mon,  9 Nov 2026 10:52:11 +0800
Message-ID: <20261109025425.328445-13-jiayuan.chen@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261109025425.328445-1-jiayuan.chen@linux.dev>
References: <20261109025425.328445-1-jiayuan.chen@linux.dev>
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

autocorking_size, smcr_buf_type, smcr_max_links_per_lgr,
smcr_max_conns_per_lgr and limit_smc_hs are read without any lock while
their sysctl handlers update them with WRITE_ONCE(), and the SMC netlink
handlers toggle limit_smc_hs with plain writes. Add READ_ONCE() to the
readers and WRITE_ONCE() to those handlers.

Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
---
 net/smc/af_smc.c   | 8 ++++----
 net/smc/smc_clc.c  | 8 ++++----
 net/smc/smc_core.c | 2 +-
 net/smc/smc_tx.c   | 2 +-
 4 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index d10244af5bd29..9a657172be8f9 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -88,7 +88,7 @@ int smc_nl_dump_hs_limitation(struct sk_buff *skb, struct netlink_callback *cb)
 		return -ENOMEM;
 
 	if (nla_put_u8(skb, SMC_NLA_HS_LIMITATION_ENABLED,
-		       sock_net(skb->sk)->smc.limit_smc_hs))
+		       READ_ONCE(sock_net(skb->sk)->smc.limit_smc_hs)))
 		goto err;
 
 	genlmsg_end(skb, hdr);
@@ -102,13 +102,13 @@ int smc_nl_dump_hs_limitation(struct sk_buff *skb, struct netlink_callback *cb)
 
 int smc_nl_enable_hs_limitation(struct sk_buff *skb, struct genl_info *info)
 {
-	sock_net(skb->sk)->smc.limit_smc_hs = true;
+	WRITE_ONCE(sock_net(skb->sk)->smc.limit_smc_hs, true);
 	return 0;
 }
 
 int smc_nl_disable_hs_limitation(struct sk_buff *skb, struct genl_info *info)
 {
-	sock_net(skb->sk)->smc.limit_smc_hs = false;
+	WRITE_ONCE(sock_net(skb->sk)->smc.limit_smc_hs, false);
 	return 0;
 }
 
@@ -411,7 +411,7 @@ void smc_sk_init(struct net *net, struct sock *sk, int protocol)
 	spin_lock_init(&smc->conn.send_lock);
 	mutex_init(&smc->clcsock_release_lock);
 	smc_init_saved_callbacks(smc);
-	smc->limit_smc_hs = net->smc.limit_smc_hs;
+	smc->limit_smc_hs = READ_ONCE(net->smc.limit_smc_hs);
 	smc->use_fallback = false; /* assume rdma capability first */
 	smc->fallback_rsn = 0;
 	smc_close_init(smc);
diff --git a/net/smc/smc_clc.c b/net/smc/smc_clc.c
index 014d527d5462d..df0afeef67cbd 100644
--- a/net/smc/smc_clc.c
+++ b/net/smc/smc_clc.c
@@ -990,8 +990,8 @@ int smc_clc_send_proposal(struct smc_sock *smc, struct smc_init_info *ini)
 	}
 	if (smcr_indicated(ini->smc_type_v2)) {
 		memcpy(v2_ext->roce, ini->smcrv2.ib_gid_v2, SMC_GID_SIZE);
-		v2_ext->max_conns = net->smc.sysctl_max_conns_per_lgr;
-		v2_ext->max_links = net->smc.sysctl_max_links_per_lgr;
+		v2_ext->max_conns = READ_ONCE(net->smc.sysctl_max_conns_per_lgr);
+		v2_ext->max_links = READ_ONCE(net->smc.sysctl_max_links_per_lgr);
 	}
 
 	pclc_base->hdr.length = htons(plen);
@@ -1272,12 +1272,12 @@ int smc_clc_srv_v2x_features_validate(struct smc_sock *smc,
 
 	if (ini->smcr_version & SMC_V2) {
 		ini->max_conns = min_t(u8, pclc_v2_ext->max_conns,
-				       net->smc.sysctl_max_conns_per_lgr);
+				       READ_ONCE(net->smc.sysctl_max_conns_per_lgr));
 		if (ini->max_conns < SMC_CONN_PER_LGR_MIN)
 			return SMC_CLC_DECL_MAXCONNERR;
 
 		ini->max_links = min_t(u8, pclc_v2_ext->max_links,
-				       net->smc.sysctl_max_links_per_lgr);
+				       READ_ONCE(net->smc.sysctl_max_links_per_lgr));
 		if (ini->max_links < SMC_LINKS_ADD_LNK_MIN)
 			return SMC_CLC_DECL_MAXLINKERR;
 	}
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 6021322253e93..3d338019a1b8b 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -990,7 +990,7 @@ static int smc_lgr_create(struct smc_sock *smc, struct smc_init_info *ini)
 		lgr->net = smc_ib_net(lnk->smcibdev);
 		lgr_list = &smc_lgr_list.list;
 		lgr_lock = &smc_lgr_list.lock;
-		lgr->buf_type = lgr->net->smc.sysctl_smcr_buf_type;
+		lgr->buf_type = READ_ONCE(lgr->net->smc.sysctl_smcr_buf_type);
 		atomic_inc(&lgr_cnt);
 	}
 	smc->conn.lgr = lgr;
diff --git a/net/smc/smc_tx.c b/net/smc/smc_tx.c
index 0f0c6df3bf2ce..30bffe79d06a3 100644
--- a/net/smc/smc_tx.c
+++ b/net/smc/smc_tx.c
@@ -148,7 +148,7 @@ static bool smc_should_autocork(struct smc_sock *smc)
 	int corking_size;
 
 	corking_size = min_t(unsigned int, conn->sndbuf_desc->len >> 1,
-			     sock_net(&smc->sk)->smc.sysctl_autocorking_size);
+			     READ_ONCE(sock_net(&smc->sk)->smc.sysctl_autocorking_size));
 
 	if (atomic_read(&conn->cdc_pend_tx_wr) == 0 ||
 	    smc_tx_prepared_sends(conn) > corking_size)
-- 
2.43.0

