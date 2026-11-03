Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.161.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793733971;
	b=sx5isGzZraSfRoB2WnsG/jaxXEENQ52uiiSPo4cKyOU4Crn8spOC4BezY45KO5w+Zq7p
	 Wlqtf4ABIlBK4DeD7aEjjvlFVU0aB+mbwwp78rsQC2pXPQAwRQ6ofRDjVvIu0jLPn1s3U
	 H6Vb1LJkgduUyAb6CkbXdyZy/xty9OkKSWZEvFb5r2eGqvOqT1g2Zpv2/07jqYnZgjXTO
	 Hz8Df6tC6LW3L1x/KOTOuDpXGwCauykUTRJKbWQf93zI9eig/9wNv9oGYVj9i2c7xQfaR
	 UQKuqUOUi3/bVZbl7DgjW3aYVgQ9Ln8aASdk/HRndoSF/nkwBUJUTNTSN1X9i60jaJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793733971;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=Eo6VmiARCV/E0+lmU5+H4tJMnPB8p2KHdxisaJd5aXg=;
	b=tqvxMBpe69vZxybWm/7kKKNh5Cf0g6LRfPoKaVrS/89DItuvyReSdgrzA36c5dxKLQWF
	 FUAfzFtU8aKa+3Oqf+q6nqcgbiR7qhLjShxDlKoHojHszcL1fY2wYpOYUZ+oHnU2KnI3j
	 426HAN87wYXFetGiW5rQICXsfX+8l4wAKh5TaE2C398gXDsZg7N+Yruz2q6sr3AjhcKM/
	 Ms26bMQmelVXabotCE7dRzcgiVD5/9j2t4dngqx/tuA+blbA1t5OBbYGCP1dAeadb91p8
	 mIA8/Ih/kCwYxAPQ2Ck2JpyLF2HD7L8bU6MfJ5fqa9tffYEWAohnEGgloR5wpVxFaeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=openai.com;
	spf=pass smtp.mailfrom=openai.com;
	dkim=pass header.d=openai.com header.i=@openai.com header.a=rsa-sha256 header.s=google header.b=UGt+GH9y;
	arc=none smtp.remote-ip=209.85.161.52
Received: from mail-oo1-f52.google.com (mail-oo1-f52.google.com [209.85.161.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAAEE606A328
	for <linux-sctp@vger.kernel.org>; Tue,  3 Nov 2026 19:26:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AAAEE606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=openai.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=openai.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=openai.com header.i=@openai.com header.a=rsa-sha256 header.s=google header.b=UGt+GH9y
Received: by mail-oo1-f52.google.com with SMTP id 006d021491bc7-714d57774d8so2960441eaf.1
        for <linux-sctp@vger.kernel.org>; Tue, 03 Nov 2026 11:26:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openai.com; s=google; t=1793733968; x=1794338768; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Eo6VmiARCV/E0+lmU5+H4tJMnPB8p2KHdxisaJd5aXg=;
        b=UGt+GH9yq1ht0NPyjSAI5qXJmJ8w63K4dOhYvT8/8S6e5QDXUZIUvD14Pb8vIY4Vvv
         q2FVeQuENZUoxFJm4Y2ax5cCNlQBYG7x9wWWMK9tNRbRd7yIX7z+DVpLObbj6DEWZNmd
         EHiCwQfv7yigz+tn9gtH6xoy8VxOJa8MkFby0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793733968; x=1794338768;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Eo6VmiARCV/E0+lmU5+H4tJMnPB8p2KHdxisaJd5aXg=;
        b=B9Tg9yYeVOJgm0DC1GdwxXkKH9O8FUMTm5uKyk1Xm2JIz/i72Xn3iNKWWt3tU3qrdI
         4qWvTLfofxsSpOV4Je1HGKc94yrH2GfMFT6bWS9Wd2JoYAcaP0QFrPBhwr+lO51CTYmL
         nXGhSerE0Wqfwj0vvzLf0y6Ry2Kzf4hpts5fycNsFuOUl26Xvb7jcs2B6DGZjXHVcekJ
         nVkppx/EtNJQP039oNVJGwPuUE/ojRYuEoHie6nVjRc/5Y49tOGiHLg0U2Njcv0gs/hY
         9mk0hZAm/T52K/Dylqdrtsmt6lgH2Qv52lOO016fKwI+qBFSq/zMMeiduQ+i3K1QJT7r
         yNVg==
X-Gm-Message-State: APuU4Z/XpLswp9hJPYg1UbNLcUJ6DfHgg1yhltO03TiGRqqObDgXG/E9
	kMvniFiRaSDR6iguoVQZN6ZFjWsuJ4Pym2aVk3hhnNGX/+ICOtPLF832aGQWVhnkImLtjrM5TWW
	JCvIpGB8=
X-Gm-Gg: AYBFou0hXVsTF0qK6mz++bht8ZNX5QLOzXFfMhbE5JmMlCM1VlsxIR7HOI5jH2blWSK
	MxG6IRRN8alSH7SFsiOSurmMDYwIAMbMVtzUTO+Q8fBv+MvC1h4/V3l3fEIYcYXJSQsybVGTzDW
	W2N3o3GEz2YUiWd28ZhZr6sihvFo7vUIIhWSg9TtfJK/zgfvOFXp9O4HyWILBvOu5hVxJW05q1Z
	Pu/n3sBUCuaEbxd3MBqzAC9xaeqAJIZz59964ArhlE8HjnMFmqE89TWj0WpDtHsdyT6Bpk/K07g
	1wG1bpljxqgUTDL209YaXk+EBerP+/Z2Ib+zY+iXDDu2CxFD3yVSAI2KG8nrO79uedgWIon6eyH
	G84nuaL0bsc9jgqx3mlrp55VUPH4o4KpDAW/hxBWgFBO2vpDHmINbd0XPezwwJ88TyNpUmGlGep
	oFxnK/thppKLzP/uM6eYLXuKxpR+jIQ52JS19R1AEB/rO7SC6Mz7ZswtmcbvQeXSMtBIx2OeLgp
	mhEXsboqhAaH4KJxqveDMhX566/5qPXwcP99VdiHAo7gMq26f53XbwhdmKzDj6bcPSoeETc/UHB
	2qjJ0vylp8qm/4jDfqR/KvuXZMaKMhpNbRJ5O0OpnWYVGBuLkAXB3iV+OPHIpnST0Xa1thAx+zT
	oPuM1Y/Y0S3W4L0GG+Ok7uXDUsWK4aXs=
X-Received: by 2002:a05:6820:2203:b0:6d7:a325:35f7 with SMTP id 006d021491bc7-714f27636fbmr7710632eaf.81.1793733968248;
        Tue, 03 Nov 2026 11:26:08 -0800 (PST)
Received: from com-75606.corp.openai.org ([199.47.143.14])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-714f2ce869asm12149533eaf.4.2026.11.03.11.26.07
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 03 Nov 2026 11:26:07 -0800 (PST)
From: Kyle Zeng <kylebot@openai.com>
To: linux-sctp@vger.kernel.org
Cc: lucien.xin@gmail.com,
	marcelo.leitner@gmail.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net v2] sctp: avoid requeueing pending control chunks
Date: Tue,  3 Nov 2026 11:26:06 -0800
Message-ID: <20261103192606.92502-1-kylebot@openai.com>
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
control chunk and submit it through SCTP_CMD_REPLY. A previous
transmission can still be on the control outqueue when output is corked
or suppressed, or when sctp_packet_transmit_chunk() could not append the
chunk.

sctp_outq_tail() then adds the same list node a second time. Re-adding a
non-tail entry can corrupt the list without being caught by the
insertion-time list checks. A subsequent flush or association teardown
can access an already freed chunk. The ASCONF path is reproducible by an
unprivileged SCTP socket owner in a user/network namespace, with KASAN
reporting a use-after-free in __sctp_outq_teardown().

Check sctp_chunk_pending() in both timeout handlers before taking the
extra reference and issuing SCTP_CMD_REPLY. When the chunk is already
linked, request a deferred outqueue flush instead. Simply omitting the
reply would also omit its uncork at the end of the timeout event. T4
would no longer retry the queued ASCONF, and a migrated, pending
RE-CONFIG could lose its timer until unrelated output flushes the queue.

The flush command acquires a local cork only when the caller has not
already corked the queue. This preserves the existing flush ordering,
transport/error accounting and timer handling without changing the
common enqueue path.

The issue was found by an LLM.

Fixes: 2e3216cd54b1 ("sctp: Follow security requirement of responding with 1 packet")
Fixes: 7b9438de0cd4 ("sctp: add stream reconf timer")
Cc: stable@kernel.org
Suggested-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Kyle Zeng <kylebot@openai.com>
---
v1: https://lore.kernel.org/netdev/20261030042321.74407-1-kylebot@openai.com/
v2: Check pending chunks in the T4 and RE-CONFIG timeout handlers, as
requested. Preserve their deferred output flush with a state-machine
command so pending requests can progress without unrelated traffic.
The common sctp_outq_tail() path is unchanged.

I have a reproducer for this issue and can share by DM.

 include/net/sctp/command.h |  1 +
 net/sctp/sm_sideeffect.c   |  8 ++++++++
 net/sctp/sm_statefuns.c    | 20 ++++++++++++++------
 3 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/include/net/sctp/command.h b/include/net/sctp/command.h
index 2058fabffbf6..abd6cc509183 100644
--- a/include/net/sctp/command.h
+++ b/include/net/sctp/command.h
@@ -39,6 +39,7 @@ enum sctp_verb {
 	SCTP_CMD_CHUNK_ULP,	/* Send a chunk to the sockets layer.  */
 	SCTP_CMD_EVENT_ULP,	/* Send a notification to the sockets layer. */
 	SCTP_CMD_REPLY,		/* Send a chunk to our peer.  */
+	SCTP_CMD_OUTQ_FLUSH,	/* Flush pending output when uncorked. */
 	SCTP_CMD_SEND_PKT,	/* Send a full packet to our peer.  */
 	SCTP_CMD_RETRAN,	/* Mark a transport for retransmission.  */
 	SCTP_CMD_ECN_CE,        /* Do delayed CE processing.   */
diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
index 35f540fb15fc..6f19ac78749d 100644
--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -1498,6 +1498,14 @@ static int sctp_cmd_interpreter(enum sctp_event_type event_type,
 			sctp_outq_tail(&asoc->outqueue, cmd->obj.chunk, gfp);
 			break;
 
+		case SCTP_CMD_OUTQ_FLUSH:
+			/* Request a flush without taking over an outer cork. */
+			if (!asoc->outqueue.cork) {
+				sctp_outq_cork(&asoc->outqueue);
+				local_cork = 1;
+			}
+			break;
+
 		case SCTP_CMD_SEND_PKT:
 			/* Send a full packet to our peer.  */
 			packet = cmd->obj.packet;
diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index b2f609f177fb..8b76b7e28504 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -1122,9 +1122,13 @@ enum sctp_disposition sctp_sf_send_reconf(struct net *net,
 		return SCTP_DISPOSITION_DELETE_TCB;
 	}
 
-	sctp_chunk_hold(asoc->strreset_chunk);
-	sctp_add_cmd_sf(commands, SCTP_CMD_REPLY,
-			SCTP_CHUNK(asoc->strreset_chunk));
+	if (!sctp_chunk_pending(asoc->strreset_chunk)) {
+		sctp_chunk_hold(asoc->strreset_chunk);
+		sctp_add_cmd_sf(commands, SCTP_CMD_REPLY,
+				SCTP_CHUNK(asoc->strreset_chunk));
+	} else {
+		sctp_add_cmd_sf(commands, SCTP_CMD_OUTQ_FLUSH, SCTP_NULL());
+	}
 	sctp_add_cmd_sf(commands, SCTP_CMD_STRIKE, SCTP_TRANSPORT(transport));
 
 	return SCTP_DISPOSITION_CONSUME;
@@ -6197,9 +6201,13 @@ enum sctp_disposition sctp_sf_t4_timer_expire(
 	 * chunk, it MUST be the same (including its serial number) as the last
 	 * ASCONF sent.
 	 */
-	sctp_chunk_hold(asoc->addip_last_asconf);
-	sctp_add_cmd_sf(commands, SCTP_CMD_REPLY,
-			SCTP_CHUNK(asoc->addip_last_asconf));
+	if (!sctp_chunk_pending(asoc->addip_last_asconf)) {
+		sctp_chunk_hold(asoc->addip_last_asconf);
+		sctp_add_cmd_sf(commands, SCTP_CMD_REPLY,
+				SCTP_CHUNK(asoc->addip_last_asconf));
+	} else {
+		sctp_add_cmd_sf(commands, SCTP_CMD_OUTQ_FLUSH, SCTP_NULL());
+	}
 
 	/* ADDIP 4.1 B5) Restart the T-4 RTO timer. Note that if a different
 	 * destination is selected, then the RTO used will be that of the new

base-commit: 05441d697f7f9a927264f4058cbbc6a03dfcac9d
-- 
2.55.0.openai.911.g06873a30d2f3

