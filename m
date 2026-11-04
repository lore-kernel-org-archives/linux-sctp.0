Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793789719;
	b=XTDmxfDWbxKraBhpH6zG5WzjIwL34g7mq65SwK62UWo95Ym5dec0s2zg7gnB44rSYuZW
	 yUj8JLknNtnZxV27Q5O9LvvQgKadCWfipWtGy89cfKdJQzjm3sIcgPOpgvcMFS2EhV2Nk
	 C1GwtHEruaR2tAB9fvUQgmgB0SG9FuHYYQhIAwWVY8gJQo2uQSxE5Ch9mhVssR97mmRHR
	 Le/ywYYbgLxFlvGtvcEwJGQkP2bS0qc1E3YYF4RLw0eDMn6WQfPRTqC9CuETaqQIk9n5F
	 vKaWDpiYWEMHnxcR3Y/9iriqvnptdAHXLhzYWxfWBKb4xH/xCxflBXbHIWomuZ1kO7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793789719;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=svQ3K123JPnzXeQWDnbEp5nT6eUSmJWo2XdSJUKEnlw=;
	b=KqyqX265Y48O1u/jNFeTQkOx2qe+3n1YNNbFGrEjkvs8Ydb7dGXeSK286LdVvRdNCbZo
	 Nejo1aP8LZ4WdvMFnJX14wX760Ag1A5p7LNFL8dGRZOtJBK21x++M3zWfpCOWcaiFpWo1
	 +QxJOpAQ2VDEcrgtQHY7nJJWI1l4czsOGAsAuNjqhD4Q4HwxnWWXYyDjF7KGdrVL/GfV4
	 488kYXj5AtQWKhTlRinBJ2kKAlK+L+/lmrgu6IbYV3R4l+7m9LmqscrpLv8r5I7n8lE3+
	 3t4GU6KuXEsfmG1H/pbas8CoSWEKxsEuuCBXjn1VCHiL9AQc6a0n7ByLMEoanSP+CPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=mylsWZY6;
	arc=none smtp.remote-ip=209.85.215.181
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B29C606A31B
	for <linux-sctp@vger.kernel.org>; Wed,  4 Nov 2026 10:55:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1B29C606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=mylsWZY6
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-cd67cc518a6so387037a12.1
        for <linux-sctp@vger.kernel.org>; Wed, 04 Nov 2026 02:55:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793789718; x=1794394518; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=svQ3K123JPnzXeQWDnbEp5nT6eUSmJWo2XdSJUKEnlw=;
        b=mylsWZY6HwqPDKZlYnXLspPDOPGGWu1z3Ud+RdWElpdkudKz2bL7MGxoS1n9hHIvGi
         KgSSkDVJSOZlBlBEtDbwKSb+7MmPGIQzYLrjns7Ernl27whywuP1t41+mfEe11ierZxB
         vrQB7TSUZo+RjdfVwxyQiX+XerCfygih6K6mMLVaAP41RT+qnbaS9zolCTx+IVyl9De6
         XUuYCLXHQEhIYGTb5Lv6A1Wxy/fRH7ueKDqF1s1YuCrMBnarXExMMSz6WfcxMa7xWKue
         ffsYIZRQjk92yzjQRdPUzLadMm5KtgoiFHNyXH3f64E7fW4jWP962HFk81VdFJJZXYOl
         NapA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793789718; x=1794394518;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=svQ3K123JPnzXeQWDnbEp5nT6eUSmJWo2XdSJUKEnlw=;
        b=vjp1gVvgXGd4+1u0oICwae7uQEZvJIMvzf9nCFzG0T5NbO5WZUbQhnDTYVv7FdLKPI
         n+traSUAQUJeHwUPRPLM/VyEJpJ1mrI/1jzREiWhAwPa8wHjMaSAG3EF2MsOFtRN86bY
         e2KQmCLV7hQfKIlkF+JCxAa+K4olpO9PU2uwJzk7kHda5CshJQzR8+wLdMJEfCZSE9XZ
         nihg89KXhDixBVLlWK6oXlhl6E0yLcEZlFJn8JBQkpViT0aSoueCdGCMJL2A2h7uv1bP
         7HF/uXY/MkLahF/cOQ1RpnU3LQHMmGfq15CcbRUYtB9G7UsBOZXZ7KFuKPG+1flj6RDC
         TP5Q==
X-Forwarded-Encrypted: i=1; AKwUvBySXyqzEeASq9JTAk55JDj/TbmqOOYSw6M2RL0N1FFTZ73fVoPgpFj8jPwYPqMBrpD4aTVxWHLP3UuY@vger.kernel.org
X-Gm-Message-State: APuU4Z8k1lC9RaobdPajlmJWl+6qef9M7PhDgBV7Jw2XfCALNMXBzMVg
	J3MK0A0phWRAmHcacjarFy5sW+UPFRpcOeuvyOMFaSAIuSZrk7I1XMt8
X-Gm-Gg: AYBFou1nKNKtnc2RDXl0TQO+6k7SoTA9+p02/AbiPy+Rc6nPBAHeoZIokO+4uxWXwnt
	TNCRjkJsDPCSVuI6tD29yoCQ9STsBvnI+emboAhU1yOmn8DN4PKPuH+V/qDbTJ8maPmhOfw7m8W
	HRoMSVfSyzSa/xdZzP6APRIfzkI7GIaQPyJi/ghtouERQDUTDmfC1iBkLzQ0IyvJWveNCWr/HAA
	YQVyRuLzxfTMZqShf9+aNVomNMHqkKwDqZ0WuPn7yDBYtJQFgm77OTsbHVxOoU3sOYflhxPROj+
	OZcw06d3NOiv5A5tHuyoctMMfEkCEGEd65/j9smEa+4/2MgGbKzWFwjoaiBp/u2ZTXHAmrzYJHb
	vtx6YWB3axNr9HYdQ2Mntkz8jqIsISTT1SYIMy1QP8EaQb+Aoa+Ov8vORzlIxeeB1HlXc2zjgPf
	cHpzpt78fG4Dv8bbZ7+BKkXCX71ouRoJb6K484FIO/tQD7pb/zeK2OLV0MPzy5NSmcwaimbmw/C
	NZYoT/MyNTL4LaRouTU7+7ZZRZLYHwkZ0eErQ7o3osNXiAQEdbdKjGXzSpVgSBSO13KCbKNkSmn
	DB0SNvmqNMPei92iXD2+NZmDwJDe0I4p3ymWkpKj8BjfwRwKru1xrjyJ16emhYgGOc5/1x14l7r
	nBrtJTC9Ar1uTFwMzn1XrQquWwStaOKK5kg==
X-Received: by 2002:a17:90b:4cd2:b0:3a7:3474:b1ee with SMTP id 98e67ed59e1d1-3ae897f8a0dmr14154983a91.60.1793789718149;
        Wed, 04 Nov 2026 02:55:18 -0800 (PST)
Received: from JUNVYYANG-MC1.tencent.com ([43.132.141.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b094d572e7sm1739595a91.1.2026.11.04.02.55.15
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 04 Nov 2026 02:55:17 -0800 (PST)
From: Jun Yang <juny24602@gmail.com>
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Xin Long <lucien.xin@gmail.com>
Cc: "David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	linux-sctp@vger.kernel.org,
	netdev@vger.kernel.org,
	Jun Yang <junvyyang@tencent.com>,
	stable@kernel.org,
	TencentOS Corvus AI <corvus@tencent.com>
Subject: [PATCH net] sctp: preserve stream scheduler across outq teardown
Date: Wed,  4 Nov 2026 18:55:05 +0800
Message-ID: <20261104105507.62743-1-juny24602@gmail.com>
X-Mailer: git-send-email 2.54.0
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

From: Jun Yang <junvyyang@tencent.com>

sctp_outq_teardown() reinitializes a live outqueue with sctp_outq_init(),
which clears q->sched before calling sctp_sched_set_sched(). This makes
sctp_sched_set_sched() skip sctp_sched_free_sched(), although the
association's streams still retain their scheduler-private state. If the
socket's default scheduler differs from the installed one, the new
scheduler interprets that stale state through the shared union in
struct sctp_stream_out_ext.

Preserve q->sched across the reset so sctp_sched_set_sched() can free the
old scheduler's per-stream state and clear the union before installing
a different scheduler.

Fixes: 5bbbbe32a431 ("sctp: introduce stream scheduler foundations")
Cc: stable@kernel.org
Reported-by: TencentOS Corvus AI <corvus@tencent.com>
Signed-off-by: Jun Yang <junvyyang@tencent.com>
---
A KASAN reproducer for this issue is available if requested.

 net/sctp/outqueue.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index e92fb9da4647..6cb4b4339d8b 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -190,9 +190,13 @@ static inline int sctp_cacc_skip(struct sctp_transport *primary,
  */
 void sctp_outq_init(struct sctp_association *asoc, struct sctp_outq *q)
 {
+	const struct sctp_sched_ops *sched = q->sched;
+
 	memset(q, 0, sizeof(struct sctp_outq));
 
 	q->asoc = asoc;
+	/* Retain the scheduler to allow freeing its per-stream state. */
+	q->sched = sched;
 	INIT_LIST_HEAD(&q->out_chunk_list);
 	INIT_LIST_HEAD(&q->control_chunk_list);
 	INIT_LIST_HEAD(&q->retransmit);
-- 
2.54.0 (Apple Git-157)

