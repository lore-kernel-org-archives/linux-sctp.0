Received: from smtpbg150.qq.com (smtpbg150.qq.com [18.132.163.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 212751A2C25;
	Thu, 16 Jul 2026 11:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.132.163.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784202002; cv=none; b=t+VlMdq1yW9KGlOdrN3FBk4Ie77LTc6KwRKsX+UAtSzcE274AiBOzz5CM7y4dD0rKNvQ0jvO/CGTjpqL5EVgmGTbLDfJuy4zw3pGZ6siVvX6wm02GJrCyy8BhMDpTEqA0hEe1LYA0bcv2lzwYttDLN5cZi8XSFmzTwjZmu0mh54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784202002; c=relaxed/simple;
	bh=xhvo0TssXigBZEtmj8shKdLhEgk1c6KWckqcsGkEVRA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hOg5MVXncyH4pyLYdcOF0Oa7WtHAkea77agO+DJAvt0RZLOdiIbYgQOzT10hSXNjavw7Ys2chGw9MD9Kz7pfLZen6sTr086v84T98li66xLpagD2tUb52uSr5YJ+nO2mi1hw4359R99SUroj5ECHMkHAJa90F7qnkobalyMToSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=tencent.com; spf=pass smtp.mailfrom=tencent.com; dkim=pass (1024-bit key) header.d=tencent.com header.i=@tencent.com header.b=u6B0GL6a; arc=none smtp.client-ip=18.132.163.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=tencent.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tencent.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tencent.com header.i=@tencent.com header.b="u6B0GL6a"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tencent.com;
	s=s201512; t=1784201950;
	bh=tXkMwg9Ltdv9kC1EmbDQ6kbQY/ZIImE6dQ3kuFrs3do=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=u6B0GL6aXodweCwZKzr5a4RwuGJk8m1PVs5+SSUvSDyGW0aizPWNkjBAQeVx8erA8
	 6okFXI/zxrMmhQDESj1DYNLD7HjsBMikyrKW5VS6aZ+adEA32x7UIkzgp46sfKaqC8
	 tn2qrCtqRUvFTOuFghoLG5KZ73xKlscJax9RNi8E=
X-QQ-mid: esmtpgz14t1784201948te6fea8b8
X-QQ-Originating-IP: 3KJDf4wvd+SARAxlsRTdD/N9bosazwthnDKhH80Xl5c=
Received: from JUNVYYANG-MC1.tencent.com ( [21.36.98.78])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 16 Jul 2026 19:39:06 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 11546903899262708686
X-QQ-CSender: aigbot@tencent.com
Sender: aigbot@tencent.com
From: "=?gb18030?B?1uzIuMC2vvxBSUdCb3TTys/k?=" <aigbot@tencent.com>
To: netdev@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	linux-sctp@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@kernel.org,
	Jun Yang <junvyyang@tencent.com>,
	stable@vger.kernel.org
Subject: [PATCH net v2] sctp: don't free the ASCONF's own transport in DEL-IP processing
Date: Thu, 16 Jul 2026 19:39:04 +0800
Message-ID: <64BCFE010EC8ABF4+20260716113904.33080-1-junvyyang@tencent.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpgz:tencent.com:qybglogicsvrsz:qybglogicsvrsz4b-0
X-QQ-XMAILINFO: NUTz4BkILuKLphSou9uUGeLyGG0ftyhAepKiKSYydMvLCev82HHq8NCm
	1UwmDtsZAq8Qcvpj9mMLhJMHRKHclJcsd0ZPZwZTEOZ3FfSnG29gozzRXjJLBoCMpWf9F4J
	ryVjSmJuCUwKd1mUJdFx81bou+QisaAja9UJZFpRznkUqpmGECoCDjKwWqaiPyJ6GS8kUHF
	TDfQv8fg/QbSa5PjWtbonuQkfXfZHL6cbBd9tPkLEnpuUR7i3KxIOmGM4CYxEpuyCAd40Ky
	3sk0PFMyzPsEUTvJsB/AtJER5BM/lDJB3mSr4Lg9x1Ut+hrv8mkncNzIKsZoAQBcqxqtE22
	6K9ducaVqph/pWAMn9W/X7NR0y25MO3CUVUIJys/BChaZoGQM916bXyzAIG1cVXJq7XMCnK
	UZPhh241G4+T9IuBRc334qQ2+yDoABNJVlG+eFXTK4InIAOCQF2GzQr6ujLalpHsWxLPqj1
	QP7nueaQF1unZV2QcgY0CFzFeuU4FWIREr7VcFSweqkpcqN8/RKBtSMMs74FD9cZ+caLHiw
	Q5weVy9hwJl6iVkQ86oHxxJLoyTGGtOz1X5b8TkZqd+CFKUx+vdnpAWkqnVYeRCmLf78pME
	1YLeUPYYMQBiswxAC1g3ryCxsKyGmL+ngGYBscIy9HE75ct0rD7lSqRob5tYoEGnSORY5NK
	xQsGvOxTsgCP8sn41bsqylM/Cz73BTMRm/o5qJPkQlmBIxtek8zNEWDVBrR2v3sElG8NjfW
	tnKlyzLGoNt7Zb2RC+ZRgSpKPRRCLL57XF8wbPRs+sNlPgvSoBIQgr6ThQE1nBKsKgGuTuQ
	wfa6ZnTE+fx2Lwx2EbqMDX3ti71+8YweDbualgnnO5EzVr1vfn4QxX96k8l42RoGx5DOQ0y
	/24Dhuu/pCKwckGba4twin2lluQk0rtiL5e54kJOUTtZ5UDMvIFSPy32iahc6gOvCzIZ1Jp
	bHUx6ArUpyVn6iGoz0N44NtveLx2VxvHX8+J06qho42Pm4AqjMPPTCjGwKfGaoSo7w2yp8E
	POaEfArux64OZrCHhiEbkn535I7a75s7vwU5u4MQ==
X-QQ-XMRINFO: MSVp+SPm3vtSI1QTLgDHQqIV1w2oNKDqfg==
X-QQ-RECHKSPAM: 0

sctp_process_asconf() caches the transport the ASCONF chunk is processed
against in asconf->transport (== chunk->transport, set once in sctp_rcv()).
For an ASCONF located through its Address Parameter by
__sctp_rcv_asconf_lookup(), that cached transport corresponds to the
Address Parameter, which need not be the packet's source address.

sctp_process_asconf_param() rejects a DEL-IP for the packet source address
(ADDIP D8, SCTP_ERROR_DEL_SRC_IP), but nothing protects asconf->transport.
A single ASCONF can therefore carry, in order:

    [Address Parameter L] [DEL-IP L] [DEL-IP 0.0.0.0]

where L differs from the source. The DEL-IP for L passes the D8 check and
calls sctp_assoc_rm_peer() on the transport that asconf->transport still
points at, freeing it (RCU-deferred). The following wildcard DEL-IP then
reuses the now-dangling asconf->transport in sctp_assoc_set_primary() and
sctp_assoc_del_nonprimary_peers(): set_primary() dereferences the freed
transport (->ipaddr, ->state) and plants the dangling pointer into
asoc->peer.primary_path / active_path, and del_nonprimary_peers(), keeping
only the pointer that is no longer on the list, removes every real
transport, leaving the association with a transport_count of 0 and
primary_path/active_path pointing at freed memory.

Reject a DEL-IP that targets the transport the ASCONF is being processed
against, mirroring the existing source-address guard, so the wildcard
branch can never reuse a freed transport.

Fixes: 42e30bf3463c ("[SCTP]: Handle the wildcard ADD-IP Address parameter")
Cc: stable@vger.kernel.org
Signed-off-by: Jun Yang <junvyyang@tencent.com>
Acked-by: Xin Long <lucien.xin@gmail.com>
---
v2: add [net] subject prefix to target the net tree.

 net/sctp/sm_make_chunk.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 8adac9e0cd66..b14251214896 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -3153,6 +3153,12 @@ static __be16 sctp_process_asconf_param(struct sctp_association *asoc,
 		if (!peer)
 			return SCTP_ERROR_DNS_FAILED;

+		/* Don't free asconf->transport; a later wildcard DEL-IP
+		 * parameter reuses it.
+		 */
+		if (peer == asconf->transport)
+			return SCTP_ERROR_DEL_SRC_IP;
+
 		sctp_assoc_rm_peer(asoc, peer);
 		break;
 	case SCTP_PARAM_SET_PRIMARY:
--
2.55.0
