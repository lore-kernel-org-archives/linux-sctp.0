Received: from smtpbgbr2.qq.com (smtpbgbr2.qq.com [54.207.22.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 720903D8901;
	Thu, 16 Jul 2026 09:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.207.22.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784193286; cv=none; b=b+11MgAFBXJY3tvVlFxJdNCKdIb8pqQQDAfAYmHMwzst8CgclbwZyPc8olRfWUKmKn2kvikqAdoViPPAADAJN2b3s91NvsFFYwGm9P1aHeBALXrXfMX7FrD3ExYnj52X+8briiaPbSbr8QSvuBkAh5aRIccdx8TeZmmMJ7XaI/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784193286; c=relaxed/simple;
	bh=h533/s68PkW/dTRQqtEhMLD26L4Imx1KV6XCi6Spb/M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=n7+HgS5AVn8uFaEla34n9oVT0XY8PzVNgmf3F/s8bLcfjqty4OkmN7iyiJRlKBk2g+PJ9CneMecgxmqDfHTsrqITLhyXfSxlDsH00quZSeO0pQE3pbUy6Ss3GwaqBR6rG+Ar6QvtiTTAHmLVnEgrH+4Lj6WukmFqxmLYulJNaCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=tencent.com; spf=pass smtp.mailfrom=tencent.com; dkim=pass (1024-bit key) header.d=tencent.com header.i=@tencent.com header.b=Io8wEm81; arc=none smtp.client-ip=54.207.22.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=tencent.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tencent.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tencent.com header.i=@tencent.com header.b="Io8wEm81"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tencent.com;
	s=s201512; t=1784193143;
	bh=cZzj3HYQJKx8gtuyJN2jviMgDkTVbUaJ8m4ySFDZLE4=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=Io8wEm81ou5V2S+Hef8TBYW27SGkmge93/D5u+CWIXSaxk4UYEUKdASV+m+JIIxYc
	 avddYbOJR+5G4V6WsSBmJ4HhPdT9k7IjYqNpnRboYuwHOqplc/PM5gGqzNeMeUxe0T
	 q/hYBj17QvFTIjmpXVFAc9wfgOcMyDa+bAv8VEhs=
X-QQ-mid: esmtpgz16t1784193135tc698a91c
X-QQ-Originating-IP: zyLiXb/SlMT+LvdM5maz7tsR5nsrvqeisB9yO7HQxFs=
Received: from JUNVYYANG-MC1.tencent.com ( [21.36.98.151])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 16 Jul 2026 17:12:14 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 11565686538516819325
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
	Jun Yang <junvyyang@tencent.com>,
	stable@kernel.org
Subject: [PATCH] sctp: don't free the ASCONF's own transport in DEL-IP processing
Date: Thu, 16 Jul 2026 17:12:12 +0800
Message-ID: <80818E6580896D22+20260716091212.43126-1-junvyyang@tencent.com>
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
X-QQ-XMAILINFO: M7SN0LSU40tUh5h91YXqVYY8gPs+2MXMJ1hd28KtDTkU2s3S5SuCNtao
	H46Atz49zwOyNkLS7GOf/hCY9ecE0Lfa4WoBsL9QAIpGrkq4PqvAUHD/GuCwrMjEo3Rcy2I
	2CDpZb0nlUQ130x2UN2WmXdgQxp6YTQjU8ooSF4FctuNBmP5QIG4ofir84zf/SR/x2RbwA/
	YfhemRd5pnlHr0K2DeO41OohDDYj/qjNneMpo47US6fgRLP2iN2hCwdXrz66zsvAHIh9GlP
	MEjYVCYhtWbMN+WlBwxNkgpvkfnuwW4aW/+bdRRiiK9z1v4nwixsDXayIoaj5e0DBsJhIvK
	JqXEkJEYfdwrQufP5xY0OHRivr56YmatsKT8WQ2EM77cE/B8qWcalWNEIEuxpFei0oF3lmi
	4s70FkR+bZ3dGkCHkTbfGdijY+8W2WKXUg6KOqWrKzP1qK8DjniFueSfZF1DeDnBPpxijar
	ZHQBqo5BBUi2m7oHtVhGZgImBPpkVDu7pMhRmDmOdfrJRklVBO4jwixIICK4o7w2xjoffSr
	967g3oya5zx3y50vVvD9M5HTx0SdMZT2qE9bWKmMmZ/HxnSnK0Qj4pDRje2A8D6HG35M2gf
	LnHiE81EkqgJJYzkDH8yDLuhlizJ+0WYVZhFFlBugmd0g8GDy2g89sQmAjDXgeDr2akTrza
	metfWdd62MCbiu0Ccrb3yTmFg3XAVaqSO+zlUYkszKIYdJ/ABJT7JUAMNwgWC9iqDN8VSxl
	AJx3WZ9WrQ3lSdIqzzUnYpAoZPDagAyZpSNe3g2ykZEJ13VfWbJndER8E6dFP2xxNe1hzh+
	8gWMf3VxpNzjD1pGGlEKOCm4RFeLJiG5kYx0KhuMUlONsStM+4opQcG6NAEy70EWFJc/par
	e/Xp6mzsRS7KgbxcPw0Vql6+CriC2v5MEtWgQQYigQVeWEfu3rGPqH2MoR3v7eqZdQbWSLT
	mtyoJXov3o4lMSA==
X-QQ-XMRINFO: NS+P29fieYNwqS3WCnRCOn9D1NpZuCnCRA==
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
Cc: stable@kernel.org
Signed-off-by: Jun Yang <junvyyang@tencent.com>
Acked-by: Xin Long <lucien.xin@gmail.com>
---
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

