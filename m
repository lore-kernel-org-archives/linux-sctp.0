Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38C6D3D4138;
	Mon, 20 Jul 2026 09:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784539918; cv=none; b=ZNSiUxxU81au9EchZrHlQbIHsWJ8JYJkEoPrFAnaSp7GJxuPYzWCb9jL1bg36ICdQpvbaXL2j0SwwdRN1VezrZoxiDo5qwsMwTkae8So2UfC5cAELsrdangP9ox3jShMElTLE2k9VMfEAI52F41vRo2AeQBUfU+buwNVPUk94JU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784539918; c=relaxed/simple;
	bh=Hw279sExNL64E4KRu70qCU5S4MdYaCnaWMTfoEyEgak=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=VoYFjxMJVXgmGk0wUlqBtyrMGM146eoRpbNW0Xc8RKNZ3yVzQSTWeSzK1MLQbqPzitCJoQZRLySRRI+oVDIKxVPbDTJIcTf08IDBQVQAOD3FzEecaeSxsnycVak7wuR7JtmbjwsNzhNmzqz8hL24AfcfcTWoqkQZT3tFBn6N1GE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=kpJKT7MT; arc=none smtp.client-ip=117.135.210.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="kpJKT7MT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=SY
	Ieos+xxdrBIaoTxl8R8jHJBSXv3la/SrnkQ2hbEds=; b=kpJKT7MTpn5XKXLS3G
	jEuoyopm/YGWqpIw7ItQNH9tZ1mnOZ55Eq0j+oYJgg8L6YzFMnCwvb4OUcsqAwks
	HOsHmnpilM+eIhhPUrDcdj7Ih3qQqu1hza/bDTF95bp+YkgmMXBr/PmWlMKIAkdU
	gbH0Q+hJIhrfLCB2yhchp2IKc=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-3 (Coremail) with SMTP id _____wDH417l6l1qF9ZsKg--.11715S2;
	Mon, 20 Jul 2026 17:31:19 +0800 (CST)
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
Subject: [PATCH net v3 1/2] sctp: auth: do not set auth flag when skb_clone fails
Date: Mon, 20 Jul 2026 17:31:15 +0800
Message-Id: <20260720093116.1266202-1-l1138897701@163.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDH417l6l1qF9ZsKg--.11715S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7CrWruF1UGryfWr4fWw1Dtrb_yoW8Zw18pF
	Z3K3W8Kw4UJryDJFWkAwn5Zw45ua1kG3y3KFyay3WFyF4DXryjyrW5ta1xX3WUuF43Za4Y
	v3yjga129FnrCFUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jjuWLUUUUU=
X-CM-SenderInfo: jorrjmiyzxliqr6rljoofrz/xtbC+QflKmpd6ueCEwAA3a

From: Qing Luo <luoqing@kylinos.cn>

When processing AUTH + COOKIE-ECHO packets in sctp_assoc_bh_rcv()
and sctp_endpoint_bh_rcv(), the AUTH chunk skb is cloned and
saved as chunk->auth_chunk for deferred verification. However,
when skb_clone() fails under memory pressure, chunk->auth_chunk
is set to NULL but chunk->auth is still unconditionally set to 1.

This creates an inconsistent state where the chunk appears to be
authenticated (auth == 1) but has no auth_chunk data to actually
verify against. Later, sctp_auth_chunk_verify() sees a NULL
auth_chunk and returns true, skipping authentication entirely
and allowing unauthenticated COOKIE-ECHO packets to be accepted.

Fix this by only setting chunk->auth = 1 when skb_clone()
succeeds, ensuring the auth flag accurately reflects whether
a valid auth_chunk is available for verification.

Fixes: bbd0d59809f9 ("[SCTP]: Implement the receive and verification of AUTH chunk")
Signed-off-by: Qing Luo <luoqing@kylinos.cn>
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

