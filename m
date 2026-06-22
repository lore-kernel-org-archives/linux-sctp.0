Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3873639B481;
	Mon, 22 Jun 2026 10:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782122583; cv=none; b=CS3pQLXFfSO7dV0ZfkL/JqYNmo8maldudo6w7HnXLuQ6Y2bHHd/H8lbnt4enroU/brUuQwSWS7s0aB6fzir7Uj7TAEZG+MrAslnV2mzvPpZdBER9YKcGnEeqPvoLGOi0PcGXa1fTfyzfwdNBC3VQsz7qL/XqbpAXWe7fOnFUG3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782122583; c=relaxed/simple;
	bh=aW5tpOiVP3K52zuoTpSZyUea9npiJy6qVPe7I+Ng8bg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=LjKV8LqSEejwV1C8WG5C8zaWP+OmRfTz6MGo54npTbXFGjSVnEuWqKgjOrFLG5J5OMpIK4PFxxiHS9HAMVGNTGQPvW6dxquvWBhuYo3GJRHt3qo91Q3/hwi/AaPL9CntTwgLLvBe+BWJ95sTReLtSdsXlNlGezCU7wAFTNjhJ34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost.localdomain (unknown [117.182.74.238])
	by APP-03 (Coremail) with SMTP id rQCowACHf7ZBCDlqXQ2FFQ--.42823S2;
	Mon, 22 Jun 2026 18:02:43 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: Simon Horman <horms@kernel.org>,
	linux-sctp@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wentao Liang <vulab@iscas.ac.cn>
Subject: [PATCH v2 net-next] sctp: use sctp_auth_shkey_release() in error path for consistency
Date: Mon, 22 Jun 2026 18:02:35 +0800
Message-Id: <20260622100235.34263-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowACHf7ZBCDlqXQ2FFQ--.42823S2
X-Coremail-Antispam: 1UD129KBjvdXoW7JrW8Kry3JF1ktFyDZrW3GFg_yoWfCFbEyF
	y3CrZaqF4UKFs8Zw4fCr4avrZagw4jq3W8CrnrKFZrZ34UXrsrXrWfWrs3X3WxWw48Zr13
	Jr95try3Jw13ujkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb3kFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
	6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628v
	n2kIc2xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7x
	kEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E
	67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCw
	CI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1x
	MIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIda
	VFxhVjvjDU0xZFpf9x0JUd-B_UUUUU=
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiDAcGA2o43ZmpwAAAsx

Use the proper refcount-aware helper sctp_auth_shkey_release() instead
of kfree() when freeing cur_key in the error path of sctp_auth_set_key().
While both are equivalent in the current code, using the helper maintains
abstraction consistency and prevents potential issues if the code is
reordered in the future.

Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 net/sctp/auth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/auth.c b/net/sctp/auth.c
index be9782760f50..84708f87392f 100644
--- a/net/sctp/auth.c
+++ b/net/sctp/auth.c
@@ -753,7 +753,7 @@ int sctp_auth_set_key(struct sctp_endpoint *ep,
 	/* Create a new key data based on the info passed in */
 	key = sctp_auth_create_key(auth_key->sca_keylength, GFP_KERNEL);
 	if (!key) {
-		kfree(cur_key);
+		sctp_auth_shkey_release(cur_key);
 		return -ENOMEM;
 	}
 
-- 
2.39.5 (Apple Git-154)

