Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AA063EFD02
	for <linux-sctp@vger.kernel.org>; Fri,  9 Oct 2026 07:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791531796; cv=none; b=FkdrvwebRdHILsymTRgWtHerVeCYKCevJJQbkSJpiMs0XiEmox9V1v8eop7nvNRP6hsUSmGawoL9LphdVMavfX13KOJ5BJjAvHZOpRWfVwZE2ygx8Hcwv8Ve2FzcuB4ffWmGJzrH7uBsqeq085+E1h3FIN2lGAtfutzDWuFIya8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791531796; c=relaxed/simple;
	bh=DCFwk84YQeVwB0bdYL/DEBTfDn29ZEFtTD8ZJ8N7F+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tmEMFMGQlpjVy6whw0uzPZXGPpRJkqKBUZRFBGy5oaZ68D3IN4pBcL1qJExxUJQ2O3yxYx6zq4PmFBWVytmj985QNj96nEkQ1QXxsnV9ncLxBzrVASDnSirqOSfPHNwfK525gyVk4eASuQ1t6B8lAXMl1xvk0Q65DwsUSh+Aa1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FhYX6Epf; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FhYX6Epf"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-cc4aa02a269so2794322a12.2
        for <linux-sctp@vger.kernel.org>; Fri, 09 Oct 2026 00:43:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791531794; x=1792136594; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sQby3psrENILqujk9LF3SKChRv2pgUnWBA444kpbwyk=;
        b=FhYX6EpfNia23V4TbtEAv01+b2rZrI9nDlYemg7TZA5T+NS+aJKIUN2I2my1usm/2y
         sNCS7DP/Ev8JJHgxgoLYeNRFoQQBVoJ0RAtBzoWFzxMsmHlXPdMGyDt6XJEu/JgFmaxX
         T3jWa/I0VYWuk5QPkVzXgW1Lx/q9604O5GTkopm8ZVlyQLAgoR4CE9em/gGBR++VKM4e
         AYekB9Uo8FRM2WJfdwfJSeekfdKtAuUDAtmGCrUm4Qrnk2h2nHGCIvIX3mz/KjBPXrNF
         /b8Vwg2Be7SgB1HFoRQp1AywXTNPkyL/bOo+LJePs6tHd4ikmyIYiotonOQ96lDxgNBe
         u+kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791531794; x=1792136594;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=sQby3psrENILqujk9LF3SKChRv2pgUnWBA444kpbwyk=;
        b=w8i+lW2+cIl5U/5ZJi1s4bdLc1i5NPynhSw3Ta1Fy5DKTmfMIcpuK9qUwKLTnZWqey
         83UpVtScTHb2HIjoP47Mux9iImQb4nNduFGggf6lrtxQvV+kBeeBh/wHOicUPmXXcR7G
         Ndv2urtA9La9m3+G4sSW9N0KbDZO/c6FOqySLrJfziqJCk2pzHUkV/Oph8pTez/Lnhtw
         BWHFL+puMDN8S7xkNfwDa507UcVLEiOQ4jCbtB3+zLL10Fd6joFhfkirR8lVOPME97kd
         YZqpYcOQ/6uwLmDPxFVFzEVzXRRl6d4yNnHQBXbrkwpVudB0F9/M8Jy36r1ElJmlt41M
         ys2w==
X-Forwarded-Encrypted: i=1; AKwUvByKGlAjFYUHeh+TFQ79XOpEMDct01ii8COQRV7MnofmPSlQDRQ4OxtFxf5QkhjS2DsUF3H31sT2UBaR@vger.kernel.org
X-Gm-Message-State: AFq9FYJ61+XPL/jdOi4UvEp1EC6EkbcoUqW8cJTV71lxaus52L5x83eK
	7v33/zHzkUXDKxWkcA/riQBL9IRfNlZIai1NxBqvunsms4SfL1XoZ7YW
X-Gm-Gg: AYBFou3u6UV2V+/PFOriOu0Nnu1leCPf8KvlZFt28bp71X0SQ1ODu3rT/Nxfb8xLJeH
	tpdsEUzq1mMOhdyjJz4TXhLMDPkM9WOkYBo10U6bYNBXy5NDSlPPg4R7h016FZRj+562TI+19ay
	ZtcFO6PXLq/vgvq9mOVLWv1+8lEVq3e1pnvK/KQkYfEp674UPuQ+5bwat3kQvZJH6SQv2QvcMsC
	ZAmf5+Vzx9LG0w+RnSWoTbOaZne8Rt3ZdpP57ZUz19NbJEfUaqkG2XfA1wDtg3Qjs4Bw3O2qYL8
	LGdrroR5zwDY8ZyC2AxALe6uk+pGzcqIUdS84szWdGCytB4wOSE/SRMIY5pBHAlGmzsbiSV7Hxw
	+i1siHyI8mrQx/88oFNi0ocvJW8dx2H8ZFrYpAfVxrkoPZMrYp2FKAfe/p3Qn93dWXFNV4cgrZR
	LZpE0br1oMI313Mp9VAffsk5jIN6EUsjzz/RK7KrI/Ya8YwNwjBj11HXE/ZhcIvpNnqjvWA0ho1
	j8EQFFTpvRSRjQZ4HL+cuB2Txxmjv4RpbtouI4kuJpgCA==
X-Received: by 2002:a17:90b:1d03:b0:3a6:f1d2:57f7 with SMTP id 98e67ed59e1d1-3ab3ab30ffcmr852024a91.44.1791531792841;
        Fri, 09 Oct 2026 00:43:12 -0700 (PDT)
Received: from JUNVYYANG-MC1.tencent.com ([43.132.141.21])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab38ddac6dsm2124986a91.7.2026.10.09.00.43.10
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 09 Oct 2026 00:43:12 -0700 (PDT)
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
	David Lee <david.lee@trailofbits.com>,
	Kyle Zeng <kylebot@openai.com>,
	Jun Yang <junvyyang@tencent.com>,
	stable@kernel.org,
	TencentOS Corvus AI <corvus@tencent.com>
Subject: [PATCH net v4 2/2] sctp: re-point retained control chunks on association migration
Date: Fri,  9 Oct 2026 15:42:32 +0800
Message-ID: <20261009074244.3718-3-juny24602@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261009074244.3718-1-juny24602@gmail.com>
References: <20261009074244.3718-1-juny24602@gmail.com>
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jun Yang <junvyyang@tencent.com>

sctp_sock_migrate() transfers DATA chunk ownership but leaves retained
control chunks pointing at the old socket. A later retransmission can
therefore access the socket after it has been freed.

Extend the migration walk to cover retained control chunks and use
sctp_control_set_owner_w() to assign their new owner. Reuse the DATA
ownership check so each chunk is processed once per pass, even when it
is reachable through multiple lists or retained pointers.

Preserve a control chunk's existing authentication key across migration
so its final release can still generate SCTP_AUTH_FREE_KEY when needed.

Fixes: d04adf1b3551 ("sctp: reset owner sk for data chunks on out queues when migrating a sock")
Cc: stable@kernel.org
Reported-by: TencentOS Corvus AI <corvus@tencent.com>
Assisted-by: tencentos-corvus-ai:hy4-preview
Signed-off-by: Jun Yang <junvyyang@tencent.com>
---
A KASAN reproducer for this issue is available if requested.

v4:
 - Restore sctp_process_tx_chunk() to skip duplicate visits.
 - Preserve the control chunk's existing shared key.

v3: https://lore.kernel.org/netdev/20260926100359.78731-3-juny24602@gmail.com/
v2: https://lore.kernel.org/netdev/20260804113705.45754-1-juny24602@gmail.com/
v1: https://lore.kernel.org/netdev/20260730090537.27629-1-juny24602@gmail.com/

 include/net/sctp/sm.h    |  1 +
 net/sctp/sm_make_chunk.c |  5 ++--
 net/sctp/socket.c        | 53 ++++++++++++++++++++++++++++++----------
 3 files changed, 44 insertions(+), 15 deletions(-)

diff --git a/include/net/sctp/sm.h b/include/net/sctp/sm.h
index 3bfd261a53cc..76605d1ee839 100644
--- a/include/net/sctp/sm.h
+++ b/include/net/sctp/sm.h
@@ -252,6 +252,7 @@ struct sctp_chunk *sctp_make_fwdtsn(const struct sctp_association *asoc,
 				    struct sctp_fwdtsn_skip *skiplist);
 struct sctp_chunk *sctp_make_auth(const struct sctp_association *asoc,
 				  __u16 key_id);
+void sctp_control_set_owner_w(struct sctp_chunk *chunk);
 struct sctp_chunk *sctp_make_strreset_req(const struct sctp_association *asoc,
 					  __u16 stream_num, __be16 *stream_list,
 					  bool out, bool in);
diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 84a4c97d0f75..ddc31a5dbad3 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -94,7 +94,7 @@ static void sctp_control_release_owner(struct sk_buff *skb)
 	}
 }
 
-static void sctp_control_set_owner_w(struct sctp_chunk *chunk)
+void sctp_control_set_owner_w(struct sctp_chunk *chunk)
 {
 	struct sctp_association *asoc = chunk->asoc;
 	struct sk_buff *skb = chunk->skb;
@@ -107,7 +107,8 @@ static void sctp_control_set_owner_w(struct sctp_chunk *chunk)
 	 *  For now don't do anything for now.
 	 */
 	if (chunk->auth) {
-		chunk->shkey = asoc->shkey;
+		if (!chunk->shkey)
+			chunk->shkey = asoc->shkey;
 		sctp_auth_shkey_hold(chunk->shkey);
 	}
 	skb->sk = asoc ? asoc->base.sk : NULL;
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 4a08023d52aa..d09b9f139070 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -155,9 +155,24 @@ static void sctp_clear_owner_w(struct sctp_chunk *chunk)
 
 static void sctp_set_owner_w_migrate(struct sctp_chunk *chunk)
 {
-	sctp_set_owner_w(chunk);
-	if (chunk->shkey)
-		sctp_auth_shkey_release(chunk->shkey);
+	struct sctp_shared_key *shkey = chunk->shkey;
+
+	if (chunk->msg)
+		sctp_set_owner_w(chunk);
+	else
+		sctp_control_set_owner_w(chunk);
+
+	if (shkey)
+		sctp_auth_shkey_release(shkey);
+}
+
+static void sctp_process_tx_chunk(struct sctp_association *asoc,
+				  struct sctp_chunk *chunk, bool clear,
+				  void (*cb)(struct sctp_chunk *))
+{
+	if ((clear && asoc->base.sk == chunk->skb->sk) ||
+	    (!clear && asoc->base.sk != chunk->skb->sk))
+		cb(chunk);
 }
 
 #define traverse_and_process()	\
@@ -165,17 +180,14 @@ do {				\
 	msg = chunk->msg;	\
 	if (msg == prev_msg)	\
 		continue;	\
-	list_for_each_entry(c, &msg->chunks, frag_list) {	\
-		if ((clear && asoc->base.sk == c->skb->sk) ||	\
-		    (!clear && asoc->base.sk != c->skb->sk))	\
-			cb(c);	\
-	}			\
+	list_for_each_entry(c, &msg->chunks, frag_list)	\
+		sctp_process_tx_chunk(asoc, c, clear, cb);	\
 	prev_msg = msg;		\
 } while (0)
 
-static void sctp_for_each_tx_datachunk(struct sctp_association *asoc,
-				       bool clear,
-				       void (*cb)(struct sctp_chunk *))
+static void sctp_for_each_tx_chunk(struct sctp_association *asoc,
+				   bool clear,
+				   void (*cb)(struct sctp_chunk *))
 
 {
 	struct sctp_datamsg *msg, *prev_msg = NULL;
@@ -198,6 +210,21 @@ static void sctp_for_each_tx_datachunk(struct sctp_association *asoc,
 
 	list_for_each_entry(chunk, &q->out_chunk_list, list)
 		traverse_and_process();
+
+	list_for_each_entry(chunk, &q->control_chunk_list, list)
+		sctp_process_tx_chunk(asoc, chunk, clear, cb);
+
+	list_for_each_entry(chunk, &asoc->asconf_ack_list, transmitted_list)
+		sctp_process_tx_chunk(asoc, chunk, clear, cb);
+
+	list_for_each_entry(chunk, &asoc->addip_chunk_list, list)
+		sctp_process_tx_chunk(asoc, chunk, clear, cb);
+
+	if (asoc->strreset_chunk)
+		sctp_process_tx_chunk(asoc, asoc->strreset_chunk, clear, cb);
+
+	if (asoc->addip_last_asconf)
+		sctp_process_tx_chunk(asoc, asoc->addip_last_asconf, clear, cb);
 }
 
 static void sctp_for_each_rx_skb(struct sctp_association *asoc, struct sock *sk,
@@ -9640,9 +9667,9 @@ static int sctp_sock_migrate(struct sock *oldsk, struct sock *newsk,
 	 * paths won't try to lock it and then oldsk.
 	 */
 	lock_sock_nested(newsk, SINGLE_DEPTH_NESTING);
-	sctp_for_each_tx_datachunk(assoc, true, sctp_clear_owner_w);
+	sctp_for_each_tx_chunk(assoc, true, sctp_clear_owner_w);
 	sctp_assoc_migrate(assoc, newsk);
-	sctp_for_each_tx_datachunk(assoc, false, sctp_set_owner_w_migrate);
+	sctp_for_each_tx_chunk(assoc, false, sctp_set_owner_w_migrate);
 
 	/* If the association on the newsk is already closed before accept()
 	 * is called, set RCV_SHUTDOWN flag.
