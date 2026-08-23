Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 954F133D505
	for <linux-sctp@vger.kernel.org>; Sun, 23 Aug 2026 17:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787506154; cv=none; b=XhhtPoIThvWDp6E8/kavrlWZ3BiTU6XOVUepq7jQWOFH//StOnx0/QCGOBu+GMwz507sFGIAc2lp9LCXcdedbzUttC7O+TyPjj+lcN2Q1PikreiL5ZKyzLCG4CIWz7tRO/HVT3WTXOmZIMr4MQVRunkZh8O4ZmDrkZ4CAiL9cK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787506154; c=relaxed/simple;
	bh=iTKOf7uCI2/d91q6OlhbzHUwpygffkInnHb9WWl1Ops=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SRiYT/5Mw7EjWS7pu8uYLKdTQTsCsgN+lneH/ePRsVldR6EQHNFXRyrkp7WVNYgMrFME5R0g7aBZIY9yraPYL2a7LfRk1vHGXy8bwaprowpRX3ekxeQGHDAXTm8TeUVPgOfbL7SmtgG2CMgISsHedH+snCG+SkhsdVFb3WRuNUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nWnCPnBq; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nWnCPnBq"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-38e42560ebcso1957435a91.1
        for <linux-sctp@vger.kernel.org>; Sun, 23 Aug 2026 10:29:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787506153; x=1788110953; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+uH7PuwtEATmQil0pCnUwHz2U63JqlbC31pLQWpx/cs=;
        b=nWnCPnBq3+vFqpFZmpCAeU/bXJVqkd9JPWlMQ4yT2/ynUAXzLEC1Apt6Dxt3khYOTf
         s6t8XckSwgg9PBTZypV1SHNDdPk79lH3W4oIEBtj1S09EVBW1eX+nLGAGxCAFf/lzAFC
         iAdPsg34LWwqtkdW7DMgdWoYLHgQEclgetUSyHFNvL5i7sjWO01Qa2JUqjlGTgKe7xFk
         9RSb3sFiMcgQydRzdo2eP+86ZmMBHp/BYXQNFnXNUiZHEnh+wO6vpBfuFzc0u5xZNCdk
         AHReBPvkjpPO6gb4tFB/OioxJIbHOGKfSUJp2PcLivhVxtZqdUVmMsUt/fr/p39Y6yQX
         KnEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787506153; x=1788110953;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+uH7PuwtEATmQil0pCnUwHz2U63JqlbC31pLQWpx/cs=;
        b=LtSxI2Bjc2qgsmgpr3GrOaDRKaXCWXk5yn8ImLEBnXP4K4lOuNqwPZjfHdcqvycrv3
         Jmxo0nTI4t/vz5891IFOXywfd3RPWZbBuhqqA6vygsE7PakMoX3+CPdDXSEd6qh53doN
         BnjUwtIeo7TqC6y+5M+moZbWsmRWtzo/jvNz5eP9D4F1EDfDzSrdQrFX8Dee+iEZ0NYG
         yNvQ19BGmaTumwbbLcvqxNdZ0xsw03NK04tS6WcFiqVLlXjRO3TObHL+kLF9dDdV8A8H
         rcjBvQO9Egm0uT0Q3NRISrZQ9ebQY5A/68ruOOUjp5FTQ3j7vaJgJRHLjUUVprOxk+HY
         +1aQ==
X-Gm-Message-State: AFuF++nw+8P+lreeZe1TZFbfu1RopCPX2AXEwUFrzIoCa4D8jAuUvBu1
	+RaZwzt3Q39n9eDy+Nq7ccfkOxGHcmnLgQ/yxi41zuGbsbjzVTkxJa8h
X-Gm-Gg: AR+sD10ObM/3hik8m5IeH9jh4hB01VYxT2y9Uu2U4NUJgjtIqwfkTzdtS0dX0cN2D27
	7G8McHPZoer/r8TKwnp3Q5MJTFFYdhCnjkHQhb0uV1C69ArIjaFniHsm4SXuR1jlWiFDtz6x9FE
	33pJ+5sUqfRlfyd4jngq0MFGz6NLgxgfc+nH/dvanxYwWk+6FP/Xon2B+k66ZfgyOzG0o6TKwRT
	nkuSutyAy2pfzZRO2lkXdvZzouvm8SJwBsq/7E/YZhLllUj//ZtGUNYBMDxs8BPl6KWGOY4WJGq
	d4EyIIN8zU7hmOVJxdjtpvw/ftICZevKuvffedvT4aHAOISMA9rPjHRTpH/QiElesX4mLf8hYiP
	EKK+D3m0U2BDKlwOsj6sFd41zQFJovzylZqCcA7yFjUrH5zIOPjVekbppdukekdAjRY5f0loJna
	21uaL7PhM1PZRcWMmAmASBFOcOJsapo9Hb3NBXrwQUfN7bQLfgwtlTn2WjsJTkcmJ0r1uOn1b49
	S3IIBsdJiOzkSmCRowrrdo=
X-Received: by 2002:a17:90b:224f:b0:381:1f51:1ff0 with SMTP id 98e67ed59e1d1-395c354d445mr33626577a91.2.1787506152714;
        Sun, 23 Aug 2026 10:29:12 -0700 (PDT)
Received: from 192.168.50.3 ([183.193.113.149])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-395e4a1597csm6654547a91.13.2026.08.23.10.29.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Aug 2026 10:29:11 -0700 (PDT)
Sender: Weiming Shi <thebestswings@gmail.com>
From: Weiming Shi <bestswngs@gmail.com>
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>
Cc: linux-sctp@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH net v3] sctp: fix NULL deref on untransmitted RECONF completion
Date: Mon, 24 Aug 2026 01:28:58 +0800
Message-ID: <20260823172857.896146-2-bestswngs@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

sctp_process_strreset_outreq(), sctp_process_strreset_addstrm_out() and
sctp_process_strreset_resp() complete a pending stream reconfiguration
request by stopping the reconf timer on the transport it was sent on:

	t = asoc->strreset_chunk->transport;
	if (timer_delete(&t->reconf_timer))
		sctp_transport_put(t);

chunk->transport is assigned by __sctp_packet_append_chunk() when the
chunk is appended to an outbound packet, and sctp_outq_flush_ctrl() arms
the reconf timer at that same point. A request already published in
asoc->strreset_chunk but not yet transmitted has neither, so completing
it dereferences NULL.

Two ways to get there. sctp_send_asconf_del_ip() sets
asoc->src_out_of_asoc_ok without sending anything when the address being
removed is the association's last one, and sctp_outq_flush_ctrl() then
leaves every non-ASCONF control chunk queued; as only
sctp_process_asconf_ack() clears that flag, it persists. An unprivileged
process that removes such an address and then asks for a stream reset
panics the kernel from softirq. A peer needs neither ASCONF nor local
help: sctp_cmd_interpreter() uncorks the outqueue only once the whole
packet has been processed, so a reply built while walking a RECONF chunk
stays untransmitted for the rest of that walk, and one RECONF chunk
carrying [Incoming SSN Reset Request, Outgoing SSN Reset Request,
Response] -- or two RECONF chunks in one packet -- reaches the same
dereference.

  KASAN: null-ptr-deref in range [0x00000000000001e8-0x00000000000001ef]
  RIP: 0010:timer_delete+0x67/0x110
  Call Trace:
   <IRQ>
   sctp_process_strreset_addstrm_out (net/sctp/stream.c:832)
   sctp_sf_do_reconf (net/sctp/sm_statefuns.c:4212)
   sctp_do_sm (net/sctp/sm_sideeffect.c:1172)
   sctp_assoc_bh_rcv (net/sctp/associola.c:1044)
   sctp_rcv (net/sctp/input.c:243)
   ip_local_deliver (net/ipv4/ip_input.c:262)
   process_backlog (net/core/dev.c:6680)
   </IRQ>

A response can only acknowledge a request that was actually sent, so do
not match asoc->strreset_chunk while chunk->transport is NULL. Guarding
the lookup covers all three completion sites.

Fixes: 810544764536 ("sctp: implement receiver-side procedures for the Outgoing SSN Reset Request Parameter")
Cc: stable@vger.kernel.org
Reported-by: Xiang Mei <xmei5@asu.edu>
Suggested-by: Xin Long <lucien.xin@gmail.com>
Assisted-by: Claude:claude-opus-5
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
---

v3:
- No code change; v2's changelog linked the wrong v1 posting.

v2: https://lore.kernel.org/linux-sctp/20260822172352.63025-3-bestswngs@gmail.com/
v1: https://lore.kernel.org/linux-sctp/20260820162235.2668698-2-bestswngs@gmail.com/
 net/sctp/stream.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/stream.c b/net/sctp/stream.c
index 34ffe6c945a4..2012f61e250e 100644
--- a/net/sctp/stream.c
+++ b/net/sctp/stream.c
@@ -488,7 +488,7 @@ static struct sctp_paramhdr *sctp_chunk_lookup_strreset_param(
 	struct sctp_reconf_chunk *hdr;
 	union sctp_params param;
 
-	if (!chunk)
+	if (!chunk || !chunk->transport)
 		return NULL;
 
 	hdr = (struct sctp_reconf_chunk *)chunk->chunk_hdr;
-- 
2.55.0

