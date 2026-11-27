Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.223
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795750548;
	b=fbxPpbRqC1TiUhM6HELdEGoOyqixmZqKv1lZ9VgieNwjb6Epg+qHbIN4zzOVQ6rKzzUU
	 g/bYtmowR3ZfKnsGrsJs3elNM+chfRktkr/Ra90iQvfvdtv6bIGLkWsEMVkY7CkWAz3Zo
	 e9JD0EhXfsW9T4Am6441FFuXZt44UWlkCDvhzMnMDQAJ2mArKGzktJAh4Mah+c8qkXxIb
	 DrxFkt759y4WiQEAiBbMraz/UGoggjWew5HWVDZWHp8HbGkido1U44uiUEGNsLRTdL23t
	 3HLfTyWKnJWQa6LfSqPiDgIQ363XfXl6cEAHB5fViYYpqOKDkm6F/zNg2IG+swlQN8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795750548;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=UDFPOXhQrtOqB/F5UkBQvRkKRIVrORDtN9quSHyl7P8=;
	b=1qqpo+sK6USc9VHEc/yryzc7ZOcmPGsQyfv6p08YehfgzoAPwzZlHgWxNK3FGaQ6g7TO
	 T5oO2vbXnrXk6VKt2YIO/uR5IIZUo/JHkqkdHa8mybfDK4kk0iUz6IFUSxiqR+6bLaZ5l
	 enYpqOm27Baq7y8pRRJTcJ3xAkanNF2eLPpXt0iEPQnBY++MbokXCogeJw1rZ0zG3fT4o
	 HPLUeMTzqHfHaNiAwHsOvGYK6rgU4NhNJ+076CBYaC0mOQZ8QS0imgLKMGGnIi4ja55fl
	 hB64wMoOrEudOnuWkNNWolo/7iNTYp67crs31t2ppgFOiYwK+UzByldcVc/odBjb+7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=4zY5LfMn;
	arc=none smtp.remote-ip=113.46.200.223
Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62BF3606A323;
	Fri, 27 Nov 2026 03:35:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 62BF3606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=4zY5LfMn
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=UDFPOXhQrtOqB/F5UkBQvRkKRIVrORDtN9quSHyl7P8=;
	b=4zY5LfMndjA9BNFUDUXAypTvWP7IkbJDNoDjp8r2rxwh1hvL8NNmLv2QoASg8Os/BR1tZb9q3
	qaFMZoCFiR/pehjSGlHgBN8vwzVS6Xuf+BXW3Bkw0pKUeF8FrdmEn8AJdYuD0t4o56sH8nnod9m
	X6oOTCnRzwOKM811ONn6CHI=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4jbJvm20sWzmV8L;
	Fri, 27 Nov 2026 11:35:16 +0800 (CST)
Received: from kwepemk300018.china.huawei.com (unknown [7.202.194.246])
	by mail.maildlp.com (Postfix) with ESMTPS id 290A540561;
	Fri, 27 Nov 2026 11:35:41 +0800 (CST)
Received: from huawei.com (10.25.63.231) by kwepemk300018.china.huawei.com
 (7.202.194.246) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 27 Nov
 2026 11:35:40 +0800
From: Sun Yiqi <sunyiqi2@huawei.com>
To: <netdev@vger.kernel.org>
CC: <linux-sctp@vger.kernel.org>, <marcelo.leitner@gmail.com>,
	<lucien.xin@gmail.com>, <davem@davemloft.net>, <edumazet@kernel.org>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <willemb@google.com>,
	<horms@kernel.org>, <trilobyte777@gmail.com>, <luoxiaoxing@huawei.com>, Sun
 Yiqi <sunyiqi2@huawei.com>
Subject: [PATCH net] sctp: validate Cookie Preservative in the first pass
Date: Fri, 27 Nov 2026 11:35:34 +0800
Message-ID: <20261127033534.175-1-sunyiqi2@huawei.com>
X-Mailer: git-send-email 2.51.0.windows.1
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
Content-Type: text/plain
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemk300018.china.huawei.com (7.202.194.246)

The Cookie Preservative parameter is eight bytes long, including a
32-bit lifespan increment. The generic SCTP parameter walk accepts
shorter parameters, so sctp_process_param() can read beyond the
parameter and expose data to the peer.

Validate the fixed length during the first parameter walk in
sctp_verify_init() and use the existing invalid-parameter-length
handler for mismatches. The second pass can return success before
checking all parameters, while sctp_process_init() walks the list
again. Checking the length in the first pass covers that path too.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Link: https://lists.openwall.net/netdev/2026/07/29/316
Signed-off-by: Sun Yiqi <sunyiqi2@huawei.com>
---
 net/sctp/sm_make_chunk.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index ba0474c2a0bc..01b1eea0222c 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -2317,6 +2317,12 @@ int sctp_verify_init(struct net *net, const struct sctp_endpoint *ep,
 		return sctp_process_inv_mandatory(asoc, chunk, errp);
 
 	sctp_walk_params(param, peer_init) {
+		/* Validate the length even if the second pass stops early. */
+		if (param.p->type == SCTP_PARAM_COOKIE_PRESERVATIVE &&
+			ntohs(param.p->length) != sizeof(*param.life))
+				return sctp_process_inv_paramlength(asoc, param.p,
+													chunk, errp);
+
 		if (param.p->type == SCTP_PARAM_STATE_COOKIE)
 			has_cookie = true;
 	}
-- 
2.51.0.windows.1

