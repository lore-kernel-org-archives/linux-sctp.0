Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794193099;
	b=pzMyWQlRp2gb6dE1SQu6OV/YEYRnPf4bkudrm1VyhQPV/YZIBmxDORkA9Z2DS0Ttyo5B
	 vqnJ6VypUYQ/bLLY+AEfjeJPi7C2A3mkH4loTAAveSVIpNKCaAwCy7VkFq5bAksm/RnBy
	 bmk4nLsWeQtI9KuXWPNTSI71SOpDQIlrG7/0xhAlkOoY4l5I2mRAQ7jM9XSa7Wor+d1vl
	 WWL1P6m1wKxXkG4C/pV2SGZQCK3+cJN1Fg6zYT37LvbvLtwNhxlEO9l+E0IWrEptIKaL+
	 1TahgiwHXjuJUqiOQ5LN5j8flcgZqOpxJarJLGt0lAhw5xlvoSuKesqPS9gntAR/4Ww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794193099;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=/ZzxlcdhJK/ud/KyVxq+93rWFaFImo0MKgWgyLOhJCY=;
	b=2kfF0FtmJdNASLNM9jlTBUqxG0oP8dbrLZmBHZiyWbqnuM/iEH4+HA3JXsZF2fGkHdXM
	 h9/2+u9eQAUqryMtRForC1+8LRcJ+jnewNkcFlZ9ctuGwprnTK+WH0mnnyVIQOjZTz/8Y
	 bRGSw+bi/i6snGSzvPbRY2bIfLp6rwDFWhQymwyiqRs0pxeF6ogjbpgAnLbmvHsK2XPSt
	 FHFvu7IEVCeT5l9vEPTAMveWgQcmySOFi+fGEn/6C5PXjhfTI9EJ1+NXq3i55S/zqJUfa
	 6Yi+FL4zw+NL/ybTTwKE+Hhivk+3MaJfJ2AkGcx4l9k8rD7nOLWpGzapZIpWjsuPJeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ZwZturDY;
	arc=none smtp.remote-ip=95.215.58.124
Received: from mta1.migadu.com (out-124.mta1.migadu.com [95.215.58.124])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F023606A338
	for <linux-sctp@vger.kernel.org>; Mon,  9 Nov 2026 02:58:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3F023606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ZwZturDY
X-Envelope-To: linux-sctp@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=VW2UPIRvdm02fMitf8vcWNrGIl0DKTRZ6TxDmEcEySs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794193096; v=1; x=1794797896;
 b=ZwZturDYVJV0ijfMY4q1v+YvPkjzx4ykHjEuDzRYuFWI4wl9s+G6Izqovag1beThw64sqt4S
 Fu5nA8Gvk2cCe1ih31TvDCiyhP+wAhuqoUrxEQ7ASoBnLZ4vGk0WKx2T65jnhq90FECAbbfgavO
 xmoaVEHsSppJvPV2TjpmLmyQ=
X-Envelope-To: linux-sctp@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 331d074107720a0c;
	Mon, 09 Nov 2026 02:58:16 +0000
X-Mizu-Trace-ID: 331d074107720a0c
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
Subject: [PATCH net-next 07/14] mptcp: annotate data-races around pernet sysctls
Date: Mon,  9 Nov 2026 10:52:06 +0800
Message-ID: <20261109025425.328445-8-jiayuan.chen@linux.dev>
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

enabled, add_addr_timeout, checksum_enabled, allow_join_initial_addr_port,
stale_loss_cnt, close_timeout, pm_type and syn_retrans_before_tcp_fallback
are read by their ctrl.c helpers without any lock while the sysctl
handlers update them with WRITE_ONCE(), and the path_manager handler
stores pm_type with a plain write. Add READ_ONCE() to the readers and
WRITE_ONCE() to that handler.

KCSAN reports it when net.mptcp.enabled is changed while MPTCP sockets
are being created:

  BUG: KCSAN: data-race in mptcp_is_enabled / proc_dou8vec_minmax

  write (marked) to 0xffff8d724248abc9 of 1 bytes by task 733 on cpu 3:
   proc_dou8vec_minmax+0x1ab/0x1f0
   proc_sys_call_handler+0x282/0x3a0
   proc_sys_write+0x13/0x20
   ...

  read to 0xffff8d724248abc9 of 1 bytes by task 735 on cpu 1:
   mptcp_is_enabled+0x33/0x50
   mptcp_init_sock+0x35/0x300
   inet_create+0x4a6/0x8e0
   ...

  value changed: 0x00 -> 0x01

Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
---
 net/mptcp/ctrl.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/net/mptcp/ctrl.c b/net/mptcp/ctrl.c
index 63c5747f0f63c..164f79b9deb0e 100644
--- a/net/mptcp/ctrl.c
+++ b/net/mptcp/ctrl.c
@@ -50,39 +50,39 @@ static struct mptcp_pernet *mptcp_get_pernet(const struct net *net)
 
 int mptcp_is_enabled(const struct net *net)
 {
-	return mptcp_get_pernet(net)->mptcp_enabled;
+	return READ_ONCE(mptcp_get_pernet(net)->mptcp_enabled);
 }
 
 unsigned int mptcp_get_add_addr_timeout(const struct net *net)
 {
-	return mptcp_get_pernet(net)->add_addr_timeout;
+	return READ_ONCE(mptcp_get_pernet(net)->add_addr_timeout);
 }
 
 int mptcp_is_checksum_enabled(const struct net *net)
 {
-	return mptcp_get_pernet(net)->checksum_enabled;
+	return READ_ONCE(mptcp_get_pernet(net)->checksum_enabled);
 }
 
 int mptcp_allow_join_id0(const struct net *net)
 {
-	return mptcp_get_pernet(net)->allow_join_initial_addr_port;
+	return READ_ONCE(mptcp_get_pernet(net)->allow_join_initial_addr_port);
 }
 
 unsigned int mptcp_stale_loss_cnt(const struct net *net)
 {
-	return mptcp_get_pernet(net)->stale_loss_cnt;
+	return READ_ONCE(mptcp_get_pernet(net)->stale_loss_cnt);
 }
 
 unsigned int mptcp_close_timeout(const struct sock *sk)
 {
 	if (sock_flag(sk, SOCK_DEAD))
 		return TCP_TIMEWAIT_LEN;
-	return mptcp_get_pernet(sock_net(sk))->close_timeout;
+	return READ_ONCE(mptcp_get_pernet(sock_net(sk))->close_timeout);
 }
 
 int mptcp_get_pm_type(const struct net *net)
 {
-	return mptcp_get_pernet(net)->pm_type;
+	return READ_ONCE(mptcp_get_pernet(net)->pm_type);
 }
 
 const char *mptcp_get_path_manager(const struct net *net)
@@ -230,7 +230,7 @@ static int proc_path_manager(const struct ctl_table *ctl, int write,
 				pm_type = MPTCP_PM_TYPE_KERNEL;
 			else if (strncmp(pm_name, "userspace", MPTCP_PM_NAME_MAX) == 0)
 				pm_type = MPTCP_PM_TYPE_USERSPACE;
-			pernet->pm_type = pm_type;
+			WRITE_ONCE(pernet->pm_type, pm_type);
 		}
 	}
 
@@ -551,7 +551,7 @@ void mptcp_active_detect_blackhole(struct sock *ssk, bool expired)
 
 	net = sock_net(ssk);
 	timeouts = inet_csk(ssk)->icsk_retransmits;
-	to_max = mptcp_get_pernet(net)->syn_retrans_before_tcp_fallback;
+	to_max = READ_ONCE(mptcp_get_pernet(net)->syn_retrans_before_tcp_fallback);
 
 	if (timeouts == to_max || (timeouts < to_max && expired)) {
 		subflow->mpc_drop = 1;
-- 
2.43.0

