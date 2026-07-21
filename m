Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E72E0370D5A;
	Tue, 21 Jul 2026 01:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784598969; cv=none; b=eMGUHDV4e3CbJNjLPrKq8v3VNKeQleLORdaaJ3sXV8QiU2AKT1LdQ1SLPwQpADbQZJh4v6NZqjcn+TgU+7G8jBvkvTeFabYU4iXKGY4oiIcUIxeFH+OY3b+HYWjFcZiTgm/mP7A+pa7S8gI+gkZ/9yEQdoxg3pbMPCsaLQ+4b0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784598969; c=relaxed/simple;
	bh=1gEAvsDkPdV+ckVEA5ZmHtjhZPdEeOJbL6EvIk0+lQ0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=TKcNZp1L8BuU37DOl8U8I0kbpNvmKw2em5aar9RcPeMYGnSIy/+0IQ/VUIxTguH3ONpqwS/rkxKcYfIQd8ldQPCN5ThmTS7PI5P51Gc9w22BFqyeorJMqaO8m2BZ0eBJENmAqy4SzJU2fBn3mRfFhU5KzbizqgEwfAHTXb0t0rM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=MHMQaPvM; arc=none smtp.client-ip=117.135.210.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="MHMQaPvM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=bT
	NreMooTLS260MLL42K2chU3a6i6BwQz7uP5TuxFq8=; b=MHMQaPvMBpWHqZ2WL0
	zQS4afAh6p2nZHnn2DlDjEHt3DtDgxPi91vJyRokS/jzM4DucdSmvGOwCX44PZ+K
	zKJfLWSUXd/ohpMGeq3qHoZOgvaxeye7o95cyp0FMLxcVPGHxyztTpv0MTc6tQgd
	ax29Vky9VgnfA57N81GVGOhQE=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-4 (Coremail) with SMTP id _____wD3f1iU0V5qBBFALA--.30538S2;
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
Subject: [PATCH v4 net-next] sctp: auth: break when skb_clone fails for auth_chunk
Date: Tue, 21 Jul 2026 09:55:31 +0800
Message-Id: <20260721015532.120157-1-l1138897701@163.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3f1iU0V5qBBFALA--.30538S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7uw1kGw4xKFykAryktr1rCrg_yoW8Aw48pF
	Zak3W8tw47Jr1DJFZ7Awn5ua1j9w4kWw43CF1Yy3WYyFs8XryrtrWYq3W7Zw1UCFsxZa4Y
	vw40qa1Y9F47u3JanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jjiihUUUUU=
X-CM-SenderInfo: jorrjmiyzxliqr6rljoofrz/xtbC3hbLEGpe0Zab7AAA3X

From: Qing Luo <luoqing@kylinos.cn>

When processing AUTH + COOKIE-ECHO packets, if skb_clone() fails
due to memory pressure, chunk->auth_chunk is NULL. The original
code still sets chunk->auth = 1 and continues, leaving the
COOKIE-ECHO to be processed without a valid auth_chunk for
deferred verification.

The intent of not setting auth was to drop the chunk earlier,
but in sctp_endpoint_bh_rcv() asoc is NULL for new connections,
so sctp_auth_recv_cid() returns 0 and the early check is
ineffective.

Fix by breaking out of the receive loop when skb_clone() fails,
dropping the entire packet since the AUTH data needed for
COOKIE-ECHO verification cannot be preserved.

Fixes: bbd0d59809f9 ("[SCTP]: Implement the receive and verification of AUTH chunk")
Signed-off-by: Qing Luo <luoqing@kylinos.cn>
---
 net/sctp/associola.c   | 2 ++
 net/sctp/endpointola.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index 62d3cc155809..7741f982e368 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -999,6 +999,8 @@ static void sctp_assoc_bh_rcv(struct work_struct *work)
 			if (next_hdr->type == SCTP_CID_COOKIE_ECHO) {
 				chunk->auth_chunk = skb_clone(chunk->skb,
 							      GFP_ATOMIC);
+				if (!chunk->auth_chunk)
+					break;
 				chunk->auth = 1;
 				continue;
 			}
diff --git a/net/sctp/endpointola.c b/net/sctp/endpointola.c
index dfb1719275db..9675370a46da 100644
--- a/net/sctp/endpointola.c
+++ b/net/sctp/endpointola.c
@@ -368,6 +368,8 @@ static void sctp_endpoint_bh_rcv(struct work_struct *work)
 			if (next_hdr->type == SCTP_CID_COOKIE_ECHO) {
 				chunk->auth_chunk = skb_clone(chunk->skb,
 								GFP_ATOMIC);
+				if (!chunk->auth_chunk)
+					break;
 				chunk->auth = 1;
 				continue;
 			}
-- 
2.25.1

