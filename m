Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44F11379EE2;
	Thu, 16 Jul 2026 10:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784196297; cv=none; b=UubY92z3OLFzUak11pbPjYWuQ9y3zZjmUhdoQUWsDhvZ1etGcJSHiXVCqHehuwCTlWtQiFxEfdAtlqhNjgTCzAuYcYj9cG0jyplUkVtcYKjjTH5HrTl15B3eO1aPLFVpLfMyag2YPH3b+jWTG6MIb80SPlyoDas1RxRB+jnBjkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784196297; c=relaxed/simple;
	bh=rKq4TZ13IPDXdVCVe8nfY9eTiG8++fKTSsWPGEcMYkA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OgIUVY8xTH6o5QNIKQQfIyvEUnul183HsT4FbdtsbdbycqK1GIry35kj364knyuS31sAz93AYmXDADCS8heR6xz15Sk4cTX8gm4RclPYXIhbhoERFiJha5nT1f1K3jAQBPcNAgpBf7LCw1RLmLgnvYJfKZwofP6JE0/TjWRkFk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=m4qMlBSW; arc=none smtp.client-ip=117.135.210.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="m4qMlBSW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=wJ
	Q+qevjemwkRWRQlyToiEC8xoetCRwVJoYnUhyXbN0=; b=m4qMlBSWIGrB4Lux3w
	ADfo9ND/NUI75t/RsWvZE72ZgGiLk2XQ1m3mMVVd2Qp72gq9HBFZp6nEbFcXxL9s
	TN+yGLSepOO5xlenAonivoBX8kQ6fJEUSen0X1I269T8lkff1EpqlU650wv1ZWHZ
	DUoYEahXRUmbDS+tDT1h/RP98=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-3 (Coremail) with SMTP id _____wC3ou+XrFhqiTS8Ig--.46S3;
	Thu, 16 Jul 2026 18:04:10 +0800 (CST)
From: luoqing <l1138897701@163.com>
To: marcelo.leitner@gmail.com,
	lucien.xin@gmail.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com
Cc: horms@kernel.org,
	linux-sctp@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	luoqing@kylinos.cn
Subject: [PATCH v2 2/2] net: sctp: auth: Fix safety issue when skb_clone fails in auth_chunk handling
Date: Thu, 16 Jul 2026 18:04:07 +0800
Message-Id: <20260716100407.1490724-2-l1138897701@163.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260716100407.1490724-1-l1138897701@163.com>
References: <20260716100407.1490724-1-l1138897701@163.com>
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wC3ou+XrFhqiTS8Ig--.46S3
X-Coremail-Antispam: 1Uf129KBjvJXoW7WF18Zw4xXw43ArWkur4DArb_yoW8Wr47pF
	9Ika48tw4UJr9rGFWkAwn5Ww4Y9a1kGay3CF12ya1FyFs8Xry5trW5tanrX3WUuF43Z3WY
	vw4jga12gFsrCF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jr_-PUUUUU=
X-CM-SenderInfo: jorrjmiyzxliqr6rljoofrz/xtbC+hsCRmpYrJu4wgAA3a

From: luoqing <luoqing@kylinos.cn>

When processing AUTH + COOKIE-ECHO packets, if skb_clone fails due to
memory pressure, chunk->auth_chunk is set to NULL but chunk->auth is
still set to 1. This causes sctp_auth_chunk_verify to skip the AUTH
validation (since auth_chunk is NULL), allowing unauthenticated
COOKIE-ECHO packets to be accepted.

Fix this by only setting chunk->auth = 1 when skb_clone succeeds.

Fixes: 59d8d4434f429b ("sctp: delay the authentication for the duplicated cookie-echo chunk")

Signed-off-by: luoqing <luoqing@kylinos.cn>
---
 net/sctp/associola.c   | 3 ++-
 net/sctp/endpointola.c | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index 62d3cc155809..e54068305396 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -999,7 +999,8 @@ static void sctp_assoc_bh_rcv(struct work_struct *work)
 			if (next_hdr->type == SCTP_CID_COOKIE_ECHO) {
 				chunk->auth_chunk = skb_clone(chunk->skb,
 							      GFP_ATOMIC);
-				chunk->auth = 1;
+				if (chunk->auth_chunk)
+					chunk->auth = 1;
 				continue;
 			}
 		}
diff --git a/net/sctp/endpointola.c b/net/sctp/endpointola.c
index dfb1719275db..3419748c66bc 100644
--- a/net/sctp/endpointola.c
+++ b/net/sctp/endpointola.c
@@ -368,7 +368,8 @@ static void sctp_endpoint_bh_rcv(struct work_struct *work)
 			if (next_hdr->type == SCTP_CID_COOKIE_ECHO) {
 				chunk->auth_chunk = skb_clone(chunk->skb,
 								GFP_ATOMIC);
-				chunk->auth = 1;
+				if (chunk->auth_chunk)
+					chunk->auth = 1;
 				continue;
 			}
 		}
-- 
2.25.1

