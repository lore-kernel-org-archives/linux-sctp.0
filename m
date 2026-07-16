Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F1DD332601;
	Thu, 16 Jul 2026 06:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784184842; cv=none; b=NM1dedA+zb9FO8YNRORDXIghh+4s4GVdjXylBcNZcH45FoJrXMS3KuMqobHedTUJXw6HAFAZxhe2gGq0wllqdDquHq/avv8NWBEIg7h7w1o1jmTOIjR6ZWr3YhhErqrPUg9SDIw92zgcA2lIeyizWCg1qopbRG2DOdMzRwFdVME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784184842; c=relaxed/simple;
	bh=6pYazEto3Y2JAOkobQPb4AqDQQ0566wABMWPFhnFv30=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OC1DfLpyzEPlTcjkyHmxS2QtMOvQsLCOif0Zs9eHlc/ynyMBsmPupmHcrXVKckXgzkrxvCmQfBsR047JaMcCNsZH2z253K7zl0kGU4xVD81kuSmcpQq8cY+0gnNLj91DvFDyl7DjxXDUk0ZRWUrKuaxWJABXlaOsI4S2oTci3xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=mf920P15; arc=none smtp.client-ip=117.135.210.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="mf920P15"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=NS
	aS9Dioj92aNYqmgiwXuFH4g7kJo9MMDzbReSSKBfM=; b=mf920P15YnSwjlnZN/
	BTsJDfwaDzlFSpbd2jY37BIVShS1iIkapIUTytH7rS8n/CHyqCnzjnTIgXeNh/bS
	e6uRK4yOqokStPnIYrxbr9MBAgB/PxKItI4GgjwxPtrzmzGxTJo8BWkrblvp/KY7
	rYcU4LMb/DZZ2gUJ1+pGZ2u4o=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-4 (Coremail) with SMTP id _____wC3B9DLf1hq05eSKA--.10495S3;
	Thu, 16 Jul 2026 14:53:00 +0800 (CST)
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
Subject: [PATCH 2/2] sctp: auth: Fix safety issue when skb_clone fails in auth_chunk handling
Date: Thu, 16 Jul 2026 14:52:59 +0800
Message-Id: <20260716065259.872235-2-l1138897701@163.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260716065259.872235-1-l1138897701@163.com>
References: <20260716065259.872235-1-l1138897701@163.com>
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wC3B9DLf1hq05eSKA--.10495S3
X-Coremail-Antispam: 1Uf129KBjvJXoW7WF18Zw4xXw43ArWkur4DArb_yoW8XrW8pF
	9xGa48tw4UJryDGFWkAwn5Xa1Y9a1kGay3GF1aya1YyFs8Xry5trW5tanrX3WUuF43Za4Y
	vw4jga1agF47CF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jrNVkUUUUU=
X-CM-SenderInfo: jorrjmiyzxliqr6rljoofrz/xtbC+QzDCGpYf8wbEQAA31

From: luoqing <luoqing@kylinos.cn>

When processing AUTH + COOKIE-ECHO packets, if skb_clone fails due to
memory pressure, chunk->auth_chunk is set to NULL but chunk->auth is
still set to 1. This causes sctp_auth_chunk_verify to skip the AUTH
validation (since auth_chunk is NULL), allowing unauthenticated
COOKIE-ECHO packets to be accepted.

Fix this by only setting chunk->auth = 1 when skb_clone succeeds.

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

