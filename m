Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3E223D6CC3;
	Mon, 20 Jul 2026 09:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784539926; cv=none; b=uVwm4aL3xisa5WE8ioYLJU8yvrSeAwlxYdzyJuLwIH9x0O1oXlYufAEyvcl0ndmGO7kvr6pbSlm7LCvdc46M9SymV9ZWzHp2NGBpQDbrqQKs/GGiNQLc2MRLkA+LHQC4JJX57Snlhr8iMWiZEIf5fQ/8D5PzqBR5onAKA8Vb5xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784539926; c=relaxed/simple;
	bh=TbVvBEEtnyhSfHlg4arMCBn82aESOFCueGiZl/gSxbI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FZ7zY2G4i5OflZuhSTPWOf0kc84RJb6RUTEci3n/VGHdOYt0syGBm6KcQSNS6NVR152g3u/53aPwti/QbxQURsVmVneY+8L9WRTlJL/drjgOp0D4p9Eg+/9j5ttYlkQ/bYHtmgphnt5CDJJ+yDosgMo7GNbFCwNhDOEjpdoEhok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=RPFIC0b3; arc=none smtp.client-ip=117.135.210.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="RPFIC0b3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version:
	Content-Type; bh=Jwd400HCzMAajPxjHxQMbahtKfRi8j541vUlNmw7fjg=;
	b=RPFIC0b3E4ZUwdGjz7OpS8ozxFre9yWbtn0ooZTLA5rn/ST9xpKM+Z3d1OqL+t
	YyKgTLMuO9pUtuLTWQ9OYTJf4p+eRIq8YJlL6o4HygQp7QrsxWB4NMSEJtTxOqcK
	34jAM/34sotSoNqKPFmLop0MQ9sgMlfDrZXRteWFBG6XI=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-3 (Coremail) with SMTP id _____wDH417l6l1qF9ZsKg--.11715S3;
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
Subject: [PATCH net v3 2/2] sctp: auth: verify auth requirement when auth_chunk is NULL
Date: Mon, 20 Jul 2026 17:31:16 +0800
Message-Id: <20260720093116.1266202-2-l1138897701@163.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260720093116.1266202-1-l1138897701@163.com>
References: <20260720093116.1266202-1-l1138897701@163.com>
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDH417l6l1qF9ZsKg--.11715S3
X-Coremail-Antispam: 1Uf129KBjvJXoWxAw4UXFW8Zryxtr4rJr17trb_yoW5uF13pF
	WfCa1vy3WkJr4xAa97Aw15uay5uan7GrW3tFn5t3W5A3WDWF1YkrWrK3yaqw4jkr4rAa4j
	q398Kw1SqF1DXFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UE0PhUUUUU=
X-CM-SenderInfo: jorrjmiyzxliqr6rljoofrz/xtbC3QflKmpd6udqogAA3n

From: Qing Luo <luoqing@kylinos.cn>

sctp_auth_chunk_verify() currently returns true unconditionally
when chunk->auth_chunk is NULL, which means authentication is
silently skipped. This is incorrect in two scenarios:

1. skb_clone() failed in the BH receive path, leaving auth_chunk
   NULL. Although the previous fix avoids setting auth=1 in this
   case, the chunk can still reach sctp_auth_chunk_verify() via
   sctp_endpoint_bh_rcv() where asoc is NULL for new connections,
   bypassing the early sctp_auth_recv_cid() check.

2. No AUTH chunk precedes COOKIE-ECHO in the packet. In this case
   skb_clone() is never called and auth_chunk remains NULL. Again,
   in sctp_endpoint_bh_rcv() the early check cannot catch this
   because asoc is NULL and sctp_auth_recv_cid() returns 0.

Fix by checking sctp_auth_recv_cid() when auth_chunk is NULL:
if authentication is required for this chunk type, return false
to drop the chunk; otherwise, continue normally.

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
>> A better fix would be:
>>
>> Add a check in sctp_auth_chunk_verify() at the point where the COOKIE-ECHO
>> chunk is actually being processed:
>>
>>
>>         if (!chunk->auth_chunk)
>>                 return !sctp_auth_recv_cid(chunk->chunk_hdr->type, asoc);
>>
>> This ensures that if chunk->auth_chunk is missing while authentication is
>> required for the COOKIE-ECHO chunk, the verification fails and the chunk is
>> dropped. Otherwise, when authentication is not required, processing can
>> continue normally.
>>
>> Please give it a try.
>>
> Also, please add a extra Fixes tag in your next post:
>
> Fixes: bbd0d59809f9 ("[SCTP]: Implement the receive and verification
> of AUTH chunk")
>
> which introduces chunk->auth_chunk and calls skb_clone() in
> sctp_endpoint_bh_rcv().
Hi,

Thanks for the review. I’ve reworked the fix into two patches:

Patch 1/2: In sctp_assoc_bh_rcv() and sctp_endpoint_bh_rcv(), only set chunk->auth = 1 when skb_clone() succeeds.

Patch 2/2: In sctp_auth_chunk_verify(), when auth_chunk is NULL, check sctp_auth_recv_cid() to decide whether authentication is required. This covers both cases from the review.

I’d like to discuss whether Patch 1 is necessary. Patch 2 alone is sufficient for correctness — even with auth == 1 and auth_chunk == NULL, Patch 2 catches it at the verification point. Patch 1 only provides semantic cleanliness (not setting auth = 1 without a valid auth_chunk), but closes no additional gap.

Should I keep Patch 1 as a defensive cleanup, or drop it and submit only Patch 2?

Best regards,

