Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net [207.46.229.174])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3A6D3E6DDD;
	Thu, 23 Jul 2026 22:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.46.229.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784847417; cv=none; b=LXY/1M3DEj9HlOXbahj00WPPz0b7ZIX0ZgSwolYi0evGHqr4krCOnTQt/B6nzvmThLM4oRqq8+7Rthy9TbF0gQ+3Mpf/4wwIUK35ZWcnPh8YIKgLZjtfIvUOwGGeiKVK5iHiUH3r5mRugn2zQ44k+TY8cB93zQcUGZkfZvbqFxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784847417; c=relaxed/simple;
	bh=IN2A5qS9NUOHev9Q1On4wNr1UQD2oYoCJwKIpU2+EfA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=He0qzTr41bW6Ry50cc1e4fgGl2WhbxsVX/DeWfzXD0gWpORJ8L3bsKp+RvFJITWMAw+Zj9zYcTGCb7BTkDFxIjDaKDKdPUi7TxRWnRyNyKEOe8bQ7kswZTICLHb2wlxj5CoggatDTn0rdIbMrfkpXHuxdagD+MVIhpdoA49//Og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mails.tsinghua.edu.cn; spf=pass smtp.mailfrom=mails.tsinghua.edu.cn; dkim=pass (1024-bit key) header.d=mails.tsinghua.edu.cn header.i=@mails.tsinghua.edu.cn header.b=HMjxTY/p; arc=none smtp.client-ip=207.46.229.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mails.tsinghua.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mails.tsinghua.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mails.tsinghua.edu.cn header.i=@mails.tsinghua.edu.cn header.b="HMjxTY/p"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=mails.tsinghua.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:
	Date:Message-Id:MIME-Version:Content-Transfer-Encoding; bh=A3cyf
	QGF7kX31PLY9aN/o8U/KPQJ1RsdZmlw6hHHiwc=; b=HMjxTY/pD1UKnrnI44j2q
	/3wmS731Bb2yTc9vp2clFYENG5vNF1+4MRQAClEg/pk5Saoq95Ou9y2SbxLFj12W
	LRy4aTiYK1b8ByvSEicKoG7uXpxczXtLxw+OPxZQu9mDDWQ4ALg6+74JjTzUy5D6
	U6MsISoQ8Mlrdrq7yCr7FY=
Received: from node118.platform-default.svc.cluster.local (unknown [36.102.215.18])
	by web2 (Coremail) with SMTP id yQQGZQBXVbcenGJqP3A8AA--.25496S2;
	Fri, 24 Jul 2026 06:56:39 +0800 (CST)
From: Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>
To: linux-sctp@vger.kernel.org,
	netdev@vger.kernel.org
Cc: marcelo.leitner@gmail.com,
	lucien.xin@gmail.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	linux-kernel@vger.kernel.org,
	Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>,
	stable@vger.kernel.org,
	Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>,
	Ao Wang <wangao@seu.edu.cn>,
	Xuewei Feng <fengxw06@126.com>,
	Qi Li <qli01@tsinghua.edu.cn>,
	Ke Xu <xuke@tsinghua.edu.cn>,
	yyxroy22@gmail.com
Subject: [PATCH net] sctp: reject stale cookies with mismatched verification tags
Date: Thu, 23 Jul 2026 22:56:23 +0000
Message-Id: <20260723225623.2658868-1-yangyx22@mails.tsinghua.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:yQQGZQBXVbcenGJqP3A8AA--.25496S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Ar48WFyxuw18KrW3Gr4UJwb_yoW8Kr15pF
	sxJrWSqwnxJF13u3W8CF4kG3W5GrWkK3y7Jw4rZ3WFyw4DJFyFg3yIgFy7K3W0yr4kAa4U
	ZrW5tF9xK3s8CaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUm0b7Iv0xC_Cr1lb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I2
	0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rw
	A2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xII
	jxv20xvEc7CjxVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJVW8Jr1l84ACjcxK6I
	8E87Iv6xkF7I0E14v26r4j6r4UJwAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x0
	82IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGw
	Av7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48J
	M4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2xKxwCY1x0262kKe7
	AKxVW8ZVWrXwCY02Avz4vE14v_ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWU
	JVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67
	kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY
	6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0x
	vEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVj
	vjDU0xZFpf9x0pE-Vy5UUUUU=
X-CM-SenderInfo: 51dqw5r0ssqzpdlo2hxwvl0wxkxdhvlgxou0/

sctp_unpack_cookie() skips cookie expiration checks whenever an
association already exists.  This is broader than the exception in
RFC 9260 Section 5.2.4.

For an existing association, Section 5.2.4 permits an expired State
Cookie only when both Verification Tags in the cookie match the current
association.  Otherwise, the packet SHOULD be discarded and a Stale
Cookie ERROR MUST be sent.

The broad check lets an expired Action A restart cookie reach
sctp_sf_do_dupcook_a().  In a runtime test with the default 60 second
cookie lifetime, replaying such a cookie after 65 seconds returned a
COOKIE-ACK and restarted the association.

Check cookie expiration unless both Verification Tags match.  This
preserves the Action D exception for a lost COOKIE ACK while rejecting
expired cookies in all other cases.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>
---
 net/sctp/sm_make_chunk.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index c02809264..a1c0334a1 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -1802,9 +1802,9 @@ struct sctp_association *sctp_unpack_cookie(
 		goto fail;
 	}
 
-	/* Check to see if the cookie is stale.  If there is already
-	 * an association, there is no need to check cookie's expiration
-	 * for init collision case of lost COOKIE ACK.
+	/* Check to see if the cookie is stale.  RFC 9260 Section 5.2.4
+	 * exempts an expired cookie only when both Verification Tags match
+	 * the current association.
 	 * If skb has been timestamped, then use the stamp, otherwise
 	 * use current time.  This introduces a small possibility that
 	 * a cookie may be considered expired, but this would only slow
@@ -1815,7 +1815,10 @@ struct sctp_association *sctp_unpack_cookie(
 	else
 		kt = ktime_get_real();
 
-	if (!asoc && ktime_before(bear_cookie->expiration, kt)) {
+	if ((!asoc ||
+	     asoc->c.my_vtag != bear_cookie->my_vtag ||
+	     asoc->c.peer_vtag != bear_cookie->peer_vtag) &&
+	    ktime_before(bear_cookie->expiration, kt)) {
 		suseconds_t usecs = ktime_to_us(ktime_sub(kt, bear_cookie->expiration));
 		__be32 n = htonl(usecs);
 
-- 
2.34.1

