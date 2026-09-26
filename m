Received: from mail-pz2-f42.google.com (mail-pz2-f42.google.com [74.125.228.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 929053BCD3D
	for <linux-sctp@vger.kernel.org>; Sat, 26 Sep 2026 10:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790417054; cv=none; b=b/bJMKT3T56TE1zrcCCwpqmlOd7Ve9VCvlaIzv5jFVPj36rxyn0Hv+jSYzaiie7YpdRenWaYMyRjg467681ZvlfKSMBos4tqhAqlnWq9NDA7aQc4W43OXnf0/SEOIVYVMmPOWJHyH+KzG5JftoqFGC2b1VVW7w1YI9wIu/tRrbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790417054; c=relaxed/simple;
	bh=RtcseYG9aV+ITJZ61o92g0FqmHI/+STKqt0//tmSLMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rlVEt4Bwpvu4lVRHutll5P8CHhY+1gvBtQwfQ2Y3eUIzFIlV9ln8IZsLlnZ/k9gSO/3JHto6QxPPjorb7V4tf2B3c1cuB/VVxfac9UoopRMhdh0T4ZIT4SfG0LMdWKrJbrnsrUZzyQj1YnCuE4nBE7mQ5KX7lr7+ALJSpeJ+aTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NBUF9oao; arc=none smtp.client-ip=74.125.228.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NBUF9oao"
Received: by mail-pz2-f42.google.com with SMTP id 41be03b00d2f7-cc4cdc0d663so680893a12.3
        for <linux-sctp@vger.kernel.org>; Sat, 26 Sep 2026 03:04:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790417052; x=1791021852; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vpGJ2l/O3/mIRy9LzQ6XSr4TtWxUOpBwbRMVXQJYci4=;
        b=NBUF9oaovb5HLvyoojTvf17U9p9KX7kkVhRx+kQOeFdTkzX9QbHp1P9a782Bd7irHh
         rCHLXRYhTznaU+4ONc5QBaY1Uo/DhBewJG6/mkqYdjAQEDdE/e2FAqH2dHGP6b7VNR9q
         iCcYMw9TZJbsq34MAZOJUh2J7/cJiR4P/ZGIItF3fz06gtuNUMmLgurJ7T7BfyI57hMS
         DsBK4nU4zslaWX0tYMADnxUqMh2YEoYJXPf/I10rY+Et5+ABdeNaIgkO21/eUKGAbVgS
         6LXsIEiAIH+T95D9pgka9NOI8Il6dCwPsZOlbWWQu7BiwNWOVgc0dAycr65jfB250keM
         NhPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790417052; x=1791021852;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=vpGJ2l/O3/mIRy9LzQ6XSr4TtWxUOpBwbRMVXQJYci4=;
        b=HxRX/eh2c9asZvkuaFOd0SixqfxADOk2eih3PO5Q7DFlMelU3TFyFeGNNhm5za0jHP
         T7e6PRqB2PUCylIBw12StdKaSdy5X9yVTBrvBEgwYZpyjtyj3UmS+pSEq7ofFbjk5wev
         BWS3TTFMQqqF4QLlFRsxAvaxM6iphZ5KTEW7h8qsjYRhx7pXAaGoumVKe9Y5YK/hlUZE
         DLPft0Rliubu84yKt/oWxwqINJtXWL1b1b3K6kvKhgA+CK8ZpgZqb7PxYe0DGIfeNNHr
         4O5o/0pf/J1yQBFaEgjV2PTNasArfDoIEu8TXNekKgCs/nss/C5RskPNNU+d0hbTTDDN
         zRxA==
X-Forwarded-Encrypted: i=1; AKwUvBwsRdYvRVh4BMBSn7WAgwruz5f1Ew4185dZ86vedVmqRWy92/YWT4HljC9rrVtQSzGdwY3VZmSlEPRh@vger.kernel.org
X-Gm-Message-State: AFq9FYJUmMDI3nM8/5G+JG42RmjO5gayQmnwHRsCzwML1OQZCjpkc7cF
	GPv+39KbgUp6UKtmFQBXrsOcwHpsZ81CDG5ErA6bbLgSqivZjDlBzACk
X-Gm-Gg: AYBFou0mTHkGTFYYajrz/eupc6btoK9njB5dc39qnr66/qAJ2ik2+329BmZMX1oFXEa
	ZH7ccIMHdot7KZKos2wrZ7xElMsZH0e6TzKb1qe1nAX5/DCsA0s8IMCbJo0jYHqSdsXNu9/J12g
	uzr2/jzWwCWe6SSaDQixGOAl+twpIOgFWsbtHAYMkPTpk26EIE5QA0aoPenzQNNytml29njP1d0
	xMHXAfwpH4GPeUsJHkbVjnuhf0xjBwUY28lY0ClzmAoeShu8BWj50i8BCEFfhVE+V6fVVcCFULl
	nN9znh6IlIurExL7YUdN0Cl7eZlF4vI13VHwQdeZeMBSup9LCeYMPJPlWx9JaKvqZCNCTJW0kiF
	3XKJw7Dqp+MojV/lrluukAgKetKr8sIW6l8T3RNzyNK7NmOUfnIDEzKoXQMs9M84yaqx03ZWMBT
	PlfXe13U/J3FlCn5FO3VMRrl3XeDGpT/B0S0Ovcm1NgweL241olI0Tp2Gelj0NZIsAyBzvIovUP
	TlcxCJitJugIqYnLmbF0GZTwvXq2RNnEBzuX2vBS4aqGKE=
X-Received: by 2002:a17:90a:d88e:b0:398:9c39:520f with SMTP id 98e67ed59e1d1-3a0985b8f62mr6876795a91.15.1790417051743;
        Sat, 26 Sep 2026 03:04:11 -0700 (PDT)
Received: from JUNVYYANG-MC1.tencent.com ([43.132.141.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0c719f86fsm6730826a91.7.2026.09.26.03.04.08
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 26 Sep 2026 03:04:11 -0700 (PDT)
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
Subject: [PATCH net v3 2/2] sctp: re-point retained control chunks on association migration
Date: Sat, 26 Sep 2026 18:03:58 +0800
Message-ID: <20260926100359.78731-3-juny24602@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260926100359.78731-1-juny24602@gmail.com>
References: <20260926100359.78731-1-juny24602@gmail.com>
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
sctp_control_set_owner_w() to assign their new owner.

Save the old chunk->shkey before setting the new owner and release that
key afterward, since sctp_control_set_owner_w() may select a different
asoc->shkey.

Fixes: d04adf1b3551 ("sctp: reset owner sk for data chunks on out queues when migrating a sock")
Cc: stable@kernel.org
Reported-by: TencentOS Corvus AI <corvus@tencent.com>
Assisted-by: tencentos-corvus-ai:hy4-preview
Signed-off-by: Jun Yang <junvyyang@tencent.com>
---
A KASAN reproducer for this issue is available if requested.

v3:
 - Call cb() directly for control chunks.
 - Include the shared-key prerequisite as patch 1/2.

v2: https://lore.kernel.org/netdev/20260804113705.45754-1-juny24602@gmail.com/
v1: https://lore.kernel.org/netdev/20260730090537.27629-1-juny24602@gmail.com/

 include/net/sctp/sm.h    |  1 +
 net/sctp/sm_make_chunk.c |  2 +-
 net/sctp/socket.c        | 37 +++++++++++++++++++++++++++++--------
 3 files changed, 31 insertions(+), 9 deletions(-)

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
index 84a4c97d0f75..b2eb7568a58e 100644
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
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 4a08023d52aa..efee9e3e671e 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -155,9 +155,15 @@ static void sctp_clear_owner_w(struct sctp_chunk *chunk)
 
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
 }
 
 #define traverse_and_process()	\
@@ -173,9 +179,9 @@ do {				\
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
@@ -198,6 +204,21 @@ static void sctp_for_each_tx_datachunk(struct sctp_association *asoc,
 
 	list_for_each_entry(chunk, &q->out_chunk_list, list)
 		traverse_and_process();
+
+	list_for_each_entry(chunk, &q->control_chunk_list, list)
+		cb(chunk);
+
+	list_for_each_entry(chunk, &asoc->asconf_ack_list, transmitted_list)
+		cb(chunk);
+
+	list_for_each_entry(chunk, &asoc->addip_chunk_list, list)
+		cb(chunk);
+
+	if (asoc->strreset_chunk)
+		cb(asoc->strreset_chunk);
+
+	if (asoc->addip_last_asconf)
+		cb(asoc->addip_last_asconf);
 }
 
 static void sctp_for_each_rx_skb(struct sctp_association *asoc, struct sock *sk,
@@ -9640,9 +9661,9 @@ static int sctp_sock_migrate(struct sock *oldsk, struct sock *newsk,
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
