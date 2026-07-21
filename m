Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F22B3CB8E6;
	Tue, 21 Jul 2026 01:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784598970; cv=none; b=snwTU35BGl+gKYEo/MUhYpXgPI9aG3hCR/fSDx/qFZvqifsh3DUq43jJnPQTYFfCBiwB2UlXCG+FKMnzDMV2orHr0iWm7m1iul1NILk56nvAOsyUaXwTL54tfbdN2dnQB+lpA9keI1fnBK+pYCVvdtKfyBw1ieeczgq5qMsGTNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784598970; c=relaxed/simple;
	bh=RswfzU8NDB0MqFAsM5wWBZFw+Sf2DUCPB5kSsLi9iog=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dLFWNPVCjuTthu4DzJsp8lpehxaAaJeiSTQh455pJ3Aljc0EHFWMTC3uGpxKmdthnZUKz5UWHamEtajwzrSBWJJb5julR4FVt24Psr5bmfRKu9aW0bj6OOJEQovbKWUlSnAiNJnI8+XWZuwIIP98ahlWkyQVCw0xSDMeLHPE0OA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=JPJZsBXQ; arc=none smtp.client-ip=220.197.31.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="JPJZsBXQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=3v
	K22ai1haxB83sgQvvZN5DiH1E7xb/ZaLFFlSKjfBg=; b=JPJZsBXQ1cHNYlv8vJ
	ZoE/XzITMt+9R3K+F4R+9kelpCelW9dC3RHJdbUNZqFbC//f5O/cCiK2FCWRj0EJ
	6RybkEiIaWNrZTRaNG4Wt/qJ7w5+4ToA1QOcKwOO/Mr25hfVyhPE1rHDZheh9FF3
	8QpU+hgIqhNQJl9iATqMKXoSk=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-4 (Coremail) with SMTP id _____wD3f1iU0V5qBBFALA--.30538S3;
	Tue, 21 Jul 2026 09:55:34 +0800 (CST)
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
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 net] sctp: auth: verify auth requirement when auth_chunk is NULL
Date: Tue, 21 Jul 2026 09:55:32 +0800
Message-Id: <20260721015532.120157-2-l1138897701@163.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260721015532.120157-1-l1138897701@163.com>
References: <20260721015532.120157-1-l1138897701@163.com>
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3f1iU0V5qBBFALA--.30538S3
X-Coremail-Antispam: 1Uf129KBjvJXoW7WF13tw47ZF1kCFykGr1xKrg_yoW8Gw13pF
	Z3AF4vkFn5Ar48XaykAw1rCay5ua1kGrW3tF1rt3W3A3WDXF45KrWrtay3Xw4Y9FZ5Aa42
	qws8tw1aq3ZFvFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UE0PhUUUUU=
X-CM-SenderInfo: jorrjmiyzxliqr6rljoofrz/xtbC+RfLEGpe0ZezsAAA3E

From: Qing Luo <luoqing@kylinos.cn>

sctp_auth_chunk_verify() returns true unconditionally when
chunk->auth_chunk is NULL, silently skipping authentication.
This is incorrect when:

1. skb_clone() failed in the BH receive path, leaving auth_chunk
   NULL. In sctp_endpoint_bh_rcv() asoc is NULL for new
   connections, so the early sctp_auth_recv_cid() check cannot
   catch this.

2. No AUTH chunk precedes COOKIE-ECHO, so skb_clone() is never
   called and auth_chunk remains NULL.

Fix by checking sctp_auth_recv_cid() when auth_chunk is NULL:
if authentication is required, return false to drop the chunk;
otherwise continue normally.

Fixes: bbd0d59809f9 ("[SCTP]: Implement the receive and verification of AUTH chunk")
Signed-off-by: Qing Luo <luoqing@kylinos.cn>
---
 net/sctp/sm_statefuns.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index d23d935e128e..89ed618b1de3 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -642,7 +642,7 @@ static bool sctp_auth_chunk_verify(struct net *net, struct sctp_chunk *chunk,
 	struct sctp_chunk auth;
 
 	if (!chunk->auth_chunk)
-		return true;
+		return !sctp_auth_recv_cid(chunk->chunk_hdr->type, asoc);
 
 	/* SCTP-AUTH:  auth_chunk pointer is only set when the cookie-echo
 	 * is supposed to be authenticated and we have to do delayed
-- 
2.25.1

