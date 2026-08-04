Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A0FB3546C0
	for <linux-sctp@vger.kernel.org>; Tue,  4 Aug 2026 11:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785843433; cv=none; b=FXcM8VrkkvqK3XelOePuOB0diqPoBS11ObJG4MYkfTyWb7HeOwyNPu/So+aOSzFoiebgJN9pTPnuz3Ux4JSQ8dU7rFtXWk6EsdoQkz4bzlknGUTGNyiWskiqkEmzV+/X8z1iUUX/c76CJb6HmlIOZ1dhOjzEU1CI+Idm+ftxzZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785843433; c=relaxed/simple;
	bh=J9EO5u6alNER3gWkRpSxFbxQr0R5xUb+Hi7pDsjGVRY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=l/tZ+2zh1w6QRHc/Me5AYwDNpMA70bHj7L8FaDHbIpdqbZjp6JdYWxMJfPx1vtlxLJb91LzdBtj+6hK2N79WDkQzaJUq6xKD4DPCHdEuNjjGxRNAypz/4uouPRDnqvnXXulosQJz/Ai97aXyJXxo21pvVgd8kcw0h9+7lV8M1XU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BHxQ7beb; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BHxQ7beb"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2cc61541f8cso10312695ad.0
        for <linux-sctp@vger.kernel.org>; Tue, 04 Aug 2026 04:37:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785843432; x=1786448232; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=PyVRapuBdfN3KzSgfWTRP6Piniiymmw+PtB2Y0jNT9A=;
        b=BHxQ7bebDaOYuo4U6b2dEbhgCVDBV7ckOHe6p75uyujtnKbS1sEJ1X6fJp8s+1mdjR
         4G5VR9dZAgmgDgBMJZw/IWIPZDCDW0MPSZ4mhMYn8qtd0B/SR3AQv6YzTGXfSjoinx39
         6spXvZLSpgx5c7yEKsi8djVFytgy5oQrxJ4LpfWLX+BQdytFy9IBYNlbQMnIdbcKO3ve
         x0JF2nvpBbBKDYFE1aM9R7KPhcqTVmHx4nhKghLAUSFiEnBBg3qE64tL6y99vuBIq5bq
         LtmzfpiVifc+En6Dic+HAFWIlg/ozx5veaIK6FPEcZPCTd5sd590rZ+3S23hYKyqXF7R
         j2Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785843432; x=1786448232;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PyVRapuBdfN3KzSgfWTRP6Piniiymmw+PtB2Y0jNT9A=;
        b=Ftsr7JufPqNpElUYzJbD/RT4EUMlgpuSlKQZhIImce79DOJcL/DX/RGGEv9jjwKHd9
         CeoqGrx7fzLvUDsFtZgkqzNAFzztEWhcQxJo3XkI702T1MR+ai+rBu9Hbnj0ed1Nn45b
         wy+laX9DUZkhX7A8hFbqIdE98lfAn/C9rFypRyN2d1TvHDk899FsCcmiuk9/J0WAN3Ch
         DvGdLVveCYZhWvMfXrVa23MPt3V7zchDEzpIIYXSY3cj7hTKDH/Qr3FSEfPPDan4EWV2
         Wsgcfx2oCYX+0aIzy7M/u4YhW+nD/qho2vRdf/G0RRDVhftLoUvilBPhBJGX8EIhq3ko
         7T+w==
X-Forwarded-Encrypted: i=1; AHgh+RoW9iOldhv/LsgpU0ZD3pLpZBc5VqzleGDhgK0yHAw+14bTMkUpejf//WgBZ/HnGbGNan2/UE3lDu6Q@vger.kernel.org
X-Gm-Message-State: AOJu0Yycr99jCsLJxA6rEUh1jyUev88SJSuOhZyEaU1jRu8F/RyL2ICg
	e7gLHxl8SrRY8EF9BUSr1XjLWTSCGtgugsTFVkG8JQh/Il/VzDSfkoWW
X-Gm-Gg: AR+sD13uMgUkU99DUrrwt6zLlJuB2TAj5WOgAbZ8aBAGlORJZVtzdhQgtRmGIl0QoRE
	EblTxST7byNNFKAkvEyGLkYuxpHEoT7zSm73zyc1AuzpmrD4YjtOe0PalUdZTbejjEAsW+A/dmD
	i+wHp22g9JsDsFgqyaCdeR+o5o46eMjojy1QTVAkQyld8CCw1qJKRYdpfx3Mte1dmmMTZ00yGtP
	8v3XLvmsKBA1VLjHbh329CQ/LcJviwvjP4Qf4vhYRbhvrS5A5mOjlGBjXd9CVw7HHviZopMyr8a
	OBVAKGoK9Gq74PHX24p5L5DU41jsw/XkzoSag/enP6nSxzZQhAMFdHGdTKiwzmefX/F36RKGbyH
	NJ3k5gb5XmAwYO+4zbaIXRpojXfhimSLCYMthKH3nTYXycxlsWM7Vre7TKjp5+MqwMMpqO1d5S6
	i4o7W2RVPHifchGSAissaWtK8MyiaLHl7qxUuuRHXYwfIwr6i3dASULE1TwTyJp5MR5grsZo9Kw
	7Z1WF2Aw40LrCPEaY5Tx3Csjzw=
X-Received: by 2002:a17:90b:4a4d:b0:384:927f:3db9 with SMTP id 98e67ed59e1d1-38febfcab02mr2446887a91.1.1785843431564;
        Tue, 04 Aug 2026 04:37:11 -0700 (PDT)
Received: from JUNVYYANG-MC1.tencent.com ([43.132.141.21])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38febfd8fecsm1217217a91.2.2026.08.04.04.37.08
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 04 Aug 2026 04:37:10 -0700 (PDT)
From: Jun Yang <juny24602@gmail.com>
To: netdev@vger.kernel.org
Cc: Jun Yang <junvyyang@tencent.com>,
	stable@kernel.org,
	TencentOS Corvus AI <corvus@tencent.com>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	linux-sctp@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net v2] sctp: re-point retained control chunks on association migration
Date: Tue,  4 Aug 2026 19:37:03 +0800
Message-ID: <20260804113705.45754-1-juny24602@gmail.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jun Yang <junvyyang@tencent.com>

sctp_control_set_owner_w() records the owning socket in a control chunk's
skb->sk.  sctp_sock_migrate() re-owns the association's DATA chunks via
sctp_for_each_tx_datachunk(), but that walk keys off chunk->msg and so
skips control chunks: any control chunk the association still holds (for
example the saved stream-reset request asoc->strreset_chunk, the ASCONF
request/ack lists, or asoc->addip_last_asconf) keeps pointing at the old
socket after the association is moved to the new one.

Once the old socket is freed, a later retransmit reaches
sctp_packet_transmit() -> skb_set_owner_w(head, chunk->skb->sk) and
operates on the freed socket -- refcount_add() on its sk_wmem_alloc,
then sk->sk_write_space() from sock_wfree() -- a use-after-free of
struct sock.

Rename sctp_for_each_tx_datachunk() to sctp_for_each_tx_chunk() and walk
the control chunks the association retains there as well, so migration
re-owns them with the same clear/set bracketing already used for DATA
chunks.  sctp_set_owner_w_migrate() picks the right owner helper by
testing chunk->msg, which is NULL for control chunks.

The per-chunk owner test that traverse_and_process() already applies is
split out into sctp_process_tx_chunk() and reused for the control lists.
A chunk can sit on two of them at once -- asoc->strreset_chunk and
asoc->addip_last_asconf both stay queued on outqueue.control_chunk_list
until they are flushed -- and the test keeps such a chunk from being
cleared or re-owned twice, which would otherwise leak an shkey reference.

sctp_control_set_owner_w() re-reads chunk->shkey from asoc->shkey, so
sctp_set_owner_w_migrate() releases the reference sctp_clear_owner_w()
took by value instead of re-reading chunk->shkey, which would drop the
wrong key if the active key changed while the chunk was queued.

Fixes: d04adf1b3551 ("sctp: reset owner sk for data chunks on out queues when migrating a sock")
Cc: stable@kernel.org
Reported-by: TencentOS Corvus AI <corvus@tencent.com>
Assisted-by: tencentos-corvus-ai:kimi-k3
Signed-off-by: Jun Yang <junvyyang@tencent.com>
---
This is based on David Lee's

  [PATCH] sctp: hold shkey across socket migration
  https://lore.kernel.org/netdev/20260731120558.558957-1-david.lee@trailofbits.com/

which adds sctp_set_owner_w_migrate()

v2:
 - Rename sctp_for_each_tx_datachunk() to sctp_for_each_tx_chunk() and
   move the control-chunk traversal into it, rather than adding a
   separate sctp_for_each_tx_ctrlchunk() helper (Xin Long).
 - Handle control chunks in sctp_set_owner_w_migrate() by testing
   chunk->msg, dropping the sctp_ctrl_set_owner_w() helper (Xin Long).
   Control chunks now go through the full clear/set bracketing instead of
   a bare skb->sk store, so sctp_control_set_owner_w() is no longer
   static.
 - Factor the existing owner test out of traverse_and_process() into
   sctp_process_tx_chunk() so the control lists get it too.

v1: https://lore.kernel.org/netdev/20260730090537.27629-1-juny24602@gmail.com/

 include/net/sctp/sm.h    |  1 +
 net/sctp/sm_make_chunk.c |  2 +-
 net/sctp/socket.c        | 53 ++++++++++++++++++++++++++++++----------
 3 files changed, 42 insertions(+), 14 deletions(-)

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
index 0ae30c3c8913..7684686798cf 100644
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
-- 
2.55.0

