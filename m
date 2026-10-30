Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.161.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793334204;
	b=obKkJyMxoWgnn6w2uWg2RPzsLLwNqXAYHygM3Z0nDbtq9BitKC+CgbUGhDXMvPF8AfPQ
	 B6rawEpsiLWAazHlnAQ+Q27QHvmh4TMbl7SbQzUuY2sgxr/u8YqhuL4aglJbUh3DxWXP+
	 I+fVNECsoWETwd+w4yMMriEe3rCf9hKKouBG8qu+TlhOiFhht1rX/cZbO2ua6gWGcXeAI
	 DXyhzkCFfOUIKQH/RJcTua6qHWwxPLB8TexYd573J2E4gbjsi6x+ch27tPzDd1i07RKCr
	 FK4xuJmLiaT/rXiQ4auIwuEb6ASoc+zWV9dJNdvznX6BBc3J/giufsJV2xSnyicZkrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793334204;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=rKEjNwOw3I9jkzOc5s+g5EecQmWBKoMG6BVKkxwXdEc=;
	b=wPhcszefLZYWij6kujPfkySATNJ4rVBKerxNtymYAZvJAaoZlfKLIyJWpMz/YHphEYoS
	 W2k5Y2dO7LyYbxN/TCNQMxQSTkPUPKi8MN9427O2Gk8dnFmCMNrgKj2eIogtqhLfyii75
	 HM8J0dzRt8V/RNRqqsyChp21EbNSJkLcuLBAC/0URvnc8yhJpLdtoxDRTdwfNKGDPwEy6
	 UQg6QPa7tVhVCHyjOsB8keusyzwEpjX+3uhKSVrGq2h5khubi860lvYVMQVsPfhnzICeJ
	 6iD30YztJMn7dVOdIzkopT0u89MFM11dGWhKcfRYm9Umd45Ng9l9LLHXxCkXsOMSMJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=openai.com;
	spf=pass smtp.mailfrom=openai.com;
	dkim=pass header.d=openai.com header.i=@openai.com header.a=rsa-sha256 header.s=google header.b=FghjVlFY;
	arc=none smtp.remote-ip=209.85.161.53
Received: from mail-oo1-f53.google.com (mail-oo1-f53.google.com [209.85.161.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12F6E606A31E
	for <linux-sctp@vger.kernel.org>; Fri, 30 Oct 2026 04:23:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 12F6E606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=openai.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=openai.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=openai.com header.i=@openai.com header.a=rsa-sha256 header.s=google header.b=FghjVlFY
Received: by mail-oo1-f53.google.com with SMTP id 006d021491bc7-6f74f6b46abso160917eaf.0
        for <linux-sctp@vger.kernel.org>; Thu, 29 Oct 2026 21:23:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openai.com; s=google; t=1793334203; x=1793939003; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=rKEjNwOw3I9jkzOc5s+g5EecQmWBKoMG6BVKkxwXdEc=;
        b=FghjVlFYMvCfSv9cB9Vtqen3PR4e9RoJraqGcWvZLvfGIXkiba4JQG4ZHkxRfkJrB7
         ZZ7Iz7JBADqcS1Krbw8sHeuFsn7LyEp9M5SDI3pVtLjr2HGPTjO/eWBpR/FoYeMy1pHX
         VkbIEYRK2Att2oPTJrEM5YSDWz6PvE5xtNKRw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793334203; x=1793939003;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rKEjNwOw3I9jkzOc5s+g5EecQmWBKoMG6BVKkxwXdEc=;
        b=quPn3e2pl4y3rWViCKocG71lwKdsw+A2y014FMLSkrLSlvC3OsL+Wn4zmZ/3VLGpKj
         eSNKAhNjFRz+Vjlsyz2T4Rz3tjQhtHR7GOzy7DWaXxNN9Bgfr7NJOULUwgf23StfmMcL
         mheMQsFdAd24/Az781w0aKbanhoj60bxviw8P75ObXTmmQ1g2Z0O5BLtp32yTmatJjgw
         GUQB0WBRzqtP+w7bsYJzfPs7YD2LMc6HZC473sCJxpwb9sTZxXmlMikmAO00xNR3NvEq
         dXwzc/MHyt7qo+XxcWxg3tnKbEDMpM5pWomfkz2vGpwbdYm4lceTNL/ctcRkV4NHqHIk
         4IqQ==
X-Gm-Message-State: AFq9FYKUoIr4pv0Tl1tci1NJcDo0spBJ2N/om4anY1aUpX9nrsWsSf35
	D20x1wyWojzs5gmoXu9yOY2EiFh/GzpcAsIDdk49yHuBIB6CEFN1ehrS6sYp8esX+aj85yRdsxB
	8P3rEAuI=
X-Gm-Gg: AYBFou2ONDrmCqzkI/J47b4lsGhNn/w4s+Reb/ZB3RwRvUD6uFkl3AJFRpwuxQuM3DP
	H6iSk+Hj4xazoy0EEu1KCBM1wVR2Pus4YEaWAvZGrSw5qcYF8DX27zoHCxMhA90jUHRiPWBRdRW
	Yhz0xOVUTjGReJhrPcw5PkrPTDriykXwvMq4Z5rQdTrW1Sk+01BCofJvnkZfW65xm7zuxo1w1o2
	WU1uX4yCKFXzxG8tBI3O+CUtSqxN0pGOrSlhavEH8eLTBbcq8QZRCV2WORmNGdvOfVb79e/zJT4
	rqASIcQj86h4kPzoxAfIsIPKAaPN9IiVFL9+rY0YAkWBRtt+NLik0/OMv3V8SbPY6tnFMXxbqQ+
	4D6q5VWFMsg9fwfLA2+mNOTPlYnrp15jDw0e9fZ33vnCG5eqJGygRxoyTU0ERuceq182zwtygLn
	LouLzo1DT4inj7kSiYFAk3IHwHx+eJAykdWfZZbwO+4gv+QFq2W+psNUp1GMoBP5447dZDm8JyC
	30B1J/0vOuWG7t1wYx9SLr+fNtPIOVgO9E+FdwVWldlQQBREupUHbSIgcjEQx7CRAtWGQequPFY
	2VJJMrjTm2gQWCAxTGDlbyrXyPntUUe8xuZD3tPTtTrYS5LWQr1/JY5UcTXRd6a9xprWoLocuWZ
	Vbqo7mknLe2+6NuxqUaQI9z/0vGCNcA==
X-Received: by 2002:a05:6820:8599:20b0:6b7:46fc:1dc with SMTP id 006d021491bc7-714f29af088mr598492eaf.59.1793334202967;
        Thu, 29 Oct 2026 21:23:22 -0700 (PDT)
Received: from com-75606.corp.openai.org ([199.47.143.5])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-714f2a84854sm1052342eaf.2.2026.10.29.21.23.22
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 29 Oct 2026 21:23:22 -0700 (PDT)
From: Kyle Zeng <kylebot@openai.com>
To: linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	outbounddisclosures@openai.com
Subject: [PATCH] sctp: avoid requeueing pending control chunks
Date: Thu, 29 Oct 2026 21:23:21 -0700
Message-ID: <20261030042321.74407-1-kylebot@openai.com>
X-Mailer: git-send-email 2.55.0
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

The T4 and RE-CONFIG timeout handlers take a reference to their cached
control chunk and submit it through SCTP_CMD_REPLY. A previous transmission
can still be on the control outqueue when output is corked or suppressed,
or when sctp_packet_transmit_chunk() could not append the chunk.

sctp_outq_tail() then adds the same list node a second time. In particular,
re-adding a non-tail entry can corrupt the list without being caught by
the insertion-time list checks. A subsequent flush or association teardown
can walk the corrupted list and access an already freed chunk. The T4 path
is reproducible by an unprivileged SCTP socket owner in a user/network
namespace, with KASAN reporting a use-after-free in __sctp_outq_teardown().

Check sctp_chunk_pending() before adding a control chunk to the outqueue.
If it is already linked, release the extra reference supplied for this
enqueue and leave the existing queue entry in place. Continue to the usual
flush so that the pending transmission can be retried.

This also covers RE-CONFIG retransmission after sctp_assoc_rm_peer() moves
the request to another transport and starts its timer. Keep the existing
timer handling, corking rules and data-chunk path unchanged.

Signed-off-by: Kyle Zeng <kylebot@openai.com>
---
I have a reproducer for this issue and can share via DM

 net/sctp/outqueue.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index e92fb9da4647..a5f9f0fcf5fd 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -304,6 +304,11 @@ void sctp_outq_tail(struct sctp_outq *q, struct sctp_chunk *chunk, gfp_t gfp)
 			SCTP_INC_STATS(net, SCTP_MIB_OUTUNORDERCHUNKS);
 		else
 			SCTP_INC_STATS(net, SCTP_MIB_OUTORDERCHUNKS);
+	} else if (sctp_chunk_pending(chunk)) {
+		/* A retransmitted control chunk may still be queued.
+		 * Drop the extra reference and retry the flush below.
+		 */
+		sctp_chunk_free(chunk);
 	} else {
 		list_add_tail(&chunk->list, &q->control_chunk_list);
 		SCTP_INC_STATS(net, SCTP_MIB_OUTCTRLCHUNKS);

base-commit: d89e1d186ec9271bf78e62771779e9fc03bf0fc3
-- 
2.56.0
