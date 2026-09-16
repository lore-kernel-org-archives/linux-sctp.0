Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57EC346C4BC
	for <linux-sctp@vger.kernel.org>; Wed, 16 Sep 2026 08:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789546222; cv=none; b=aUJWEI3qstlFk+bRZ0EDVWho17zCjtDDR/6SPqZoujdoybZDlaRoH8X1HOdUzlQmPjXBgA0aQNKdBwXzBwJGklPKBT0jey8cpeh4I10uaBaE9/QftiQ7Ie+Gg1h7qJv+ngrGWnZf0Vj5GtMX5phzBEf67IEEB+Dr02WtdCbz7/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789546222; c=relaxed/simple;
	bh=nkTivANmUXq4e9wIM0SOH6H4eHJjSyDHp1VOxM3zsjM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qV0qEfNQsEftG65ZU4WO5pjV6Ab+lZeRN2WoBuzYbboVikYI/EceEoYn9Bz3jJ7qBakRD5dvHOdm2p9cF7R6ibQx9XVL5LPOS4vzeELEnCFWDPx2vJi179DymLP03m/enk2NH21lRP0MQM5gWoJNpaBAGJj50u400NZlvndMUZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XyKnPYOr; arc=none smtp.client-ip=74.125.228.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XyKnPYOr"
Received: by mail-pz2-f12.google.com with SMTP id 41be03b00d2f7-cc4cacd3409so662265a12.2
        for <linux-sctp@vger.kernel.org>; Wed, 16 Sep 2026 01:10:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789546204; x=1790151004; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=iUsD627B/6M5jyv1UJxvIMio9SziZyI6UnP6z74oBus=;
        b=XyKnPYOraE1XyhHvbxhOev1tK4nDmePjiIguBf4pnQqCZPLPbRWuCP9WQXeRNFnTCK
         b38nBSpGEVn06GDTKfOfy39hYCEkC5oueYJN1G4tD4P+cQWFZilSSFZsS5W4AXjsn78s
         633GH9EScJNtBtFEfl2oyEmSwW8Kt2pHfOjkfXlmNWnCLq7CHoxNrJAzkbh34gM9i1Yg
         6fKTCLuIoAxw95pVGrWMqRk0tjBc9Z2qK21xUsMNMM8cXt9h7eb1KfaoxGNR3+K5aAyj
         Mq17NxbN5fBxBgEZtH2KOSSsnRQAGP8CW6B4K63Lr8U8HIp+nPIFF+D8YC7wEobd8ypv
         O0XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789546205; x=1790151005;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iUsD627B/6M5jyv1UJxvIMio9SziZyI6UnP6z74oBus=;
        b=qTXck1m4IVtrm+jRHiNYnKoS4zjaQqRgnunwVq2JNQxBdVjw0kHAmIpvDBr4EdZmKC
         tzPoc1OtTPd2WP5IqjyjP1yJHxdjVVCQEpm8eJVmPxwisoF7cOkk+0VgcwuApjF4sNm7
         5QpP72VFBl/tFzl9ll5oirRgyw5EPXXKAn4+cuZXCvnq1Clkin5TyI8yEpiAl2049/XR
         w1V0vgDaP78JRbddShnJMVHkiJczMYbH2aib1sBx0Qen6EmeF0ADr0EPlkWrUWViDrio
         Bu3peREF08sv+hK0DoDD05qpsw/PCit54X5JLo2gPzFFf95EvDKSGwaZ15bONv90+ITj
         tiEw==
X-Gm-Message-State: AFuF++n8RbUYxoS0WhR19cSJ9Et+6WlnTl1VDuxl98JNr7aOn46JVjj2
	Orr+yRhK/ZdHuYj2MYCRahAzj8cx4dPkCVuCCFa5kwCfoxOmj7++9iM9
X-Gm-Gg: AYBFou29jRT+amFlSv9ypeO8iqJd72U0wM/I7ovevClZ0YvYJshSP87wrIPksV+dW6j
	UCP3RvCfTXGaHjIGvMoCAe6Y9RCQqg3806JBbrDEfTzaDBV95lsxVhW6qbruTIL6FufmsamdXEd
	r3kJ4Y/farPh1oQqXt2QpiLcGzH/0ujk8FIkqa/YsKVPq/jtDl8zSmwE9iwkrKP5qHEJUr9+06J
	Tr+BUepOhRS8UY5+W05M/rca/uY5/SrYcgiyutPTza4ZESyRXbuty2tOSUdJR321xf26ICcFouU
	bUfus1oL/OLnYOeW5FIyNpKBQo0FmpIPQjREzwnMqTKkfC1a5k0P02INglJv6xVc4TN9lfsS1Zu
	xAMJ3cJfR3v6Bvykb0jX4tel4YPUvht8n3xMfM4s9IBTK1IjcB1Pg92U3zi6THF+cz7hgdHMent
	hJLr6TJ7kQo7PS7aoWz1dAHuDBbyZtXa6EaWuxoFetz740jNC/JStVNZ+6cOojoEGhY+7dvylnh
	j1ffP2O2kn1uANxzIBYQyHQeunxoFwLBrXF0g==
X-Received: by 2002:a17:90a:1c82:b0:39e:24ab:9fb0 with SMTP id 98e67ed59e1d1-39e24aba659mr1236240a91.6.1789546204505;
        Wed, 16 Sep 2026 01:10:04 -0700 (PDT)
Received: from localhost.localdomain ([180.101.244.68])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e1d1626adsm952594a91.4.2026.09.16.01.10.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 01:10:03 -0700 (PDT)
From: Aohan Mei <ljp1205831794@gmail.com>
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org,
	marcelo.leitner@gmail.com,
	lucien.xin@gmail.com,
	imv4bel@gmail.com,
	Aohan Mei <henrymei@tencent.com>,
	TencentOS Corvus AI <corvus@tencent.com>,
	stable@vger.kernel.org
Subject: [PATCH net] sctp: don't re-register a removed transport as last_data_from
Date: Wed, 16 Sep 2026 16:09:51 +0800
Message-ID: <20260916080955.1019050-1-ljp1205831794@gmail.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Aohan Mei <henrymei@tencent.com>

When an association is in COOKIE-ECHOED state and the peer sends a
bundled [ERROR(Stale Cookie)][DATA] packet from one of its non-primary
addresses, processing the ERROR chunk takes the non-fatal stale-cookie
retry path sctp_sf_do_5_2_6_stale(), which queues
SCTP_CMD_DEL_NON_PRIMARY while keeping the association alive.
sctp_cmd_del_non_primary() removes every non-primary transport -
including the very transport this packet arrived on, which is still
referenced by the receive lookup and shared by all chunks of the
packet via chunk->transport.

sctp_assoc_rm_peer() does redirect asoc->peer.last_data_from away from
the removed transport, but right afterwards the bundled DATA chunk
makes sctp_assoc_bh_rcv() re-register
asoc->peer.last_data_from = chunk->transport unconditionally, undoing
the redirection with the just-removed transport.

Once the packet is done, the receive reference is dropped and the
transport is RCU-freed, while the surviving association keeps the
dangling last_data_from.  A later FWD-TSN (or the delayed SACK timer)
makes sctp_gen_sack() dereference it (->param_flags and friends), and
sctp_make_sack()/sctp_outq_select_transport() may write to the freed
object and link it into the live transport list.  This is a
use-after-free triggerable by any malicious SCTP peer (or a local
unprivileged user acting as one) with no capabilities required:

  BUG: KASAN: slab-use-after-free in sctp_do_sm+0x498a/0x5660
  Read of size 4 at addr ffff88800e1e356c by task poc/115
  Call Trace: sctp_do_sm <- sctp_assoc_bh_rcv <- sctp_inq_push <-
              sctp_rcv <- ip_protocol_deliver_rcu <- ip_rcv
  Allocated: sctp_transport_new <- sctp_assoc_add_peer <-
             sctp_process_init (INIT-ACK processing)
  Freed: kfree <- sctp_transport_destroy_rcu <- rcu_core
         (call_rcu queued by sctp_transport_put at end of sctp_rcv)
  The buggy address is located 364 bytes inside of freed 1024-byte
  region [ffff88800e1e3400, ffff88800e1e3800), cache kmalloc-1k

Related is commit 03a9d10ecf71 ("sctp: drop a chunk if its transport was
removed"), which only covers the window between the receive lookup and
the chunk processing (e.g. an ASCONF DEL-IP racing the socket backlog);
here the transport is removed *while* the packet is being processed, by
an earlier chunk of the same packet, so the drop in sctp_inq_push() does
not reach this path.  Verified with the bundled [ERROR(Stale
Cookie)][DATA] + FWD-TSN reproducer: the KASAN report above still fires
with that commit applied, and is gone with this patch on top.

Fix it by never registering a dead transport as last_data_from:
sctp_transport_free() sets ->dead when the transport is removed, so
both re-registration sites (the association and the endpoint backlog
paths) can simply skip it, keeping the redirection done by
sctp_assoc_rm_peer() in effect.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: TencentOS Corvus AI <corvus@tencent.com>
Cc: stable@vger.kernel.org
Assisted-by: CodeBuddy:Kimi-K3
Signed-off-by: Aohan Mei <henrymei@tencent.com>
---
 net/sctp/associola.c   | 16 ++++++++++++----
 net/sctp/endpointola.c | 10 ++++++----
 2 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index 5b0ae616e1ff9..ecef09959630d 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -1023,11 +1023,19 @@ static void sctp_assoc_bh_rcv(struct work_struct *work)
 			continue;
 
 		/* Remember where the last DATA chunk came from so we
-		 * know where to send the SACK.
+		 * know where to send the SACK.  chunk->transport may have
+		 * been removed while processing an earlier chunk of this
+		 * same packet (e.g. a stale-cookie ERROR chunk queues
+		 * SCTP_CMD_DEL_NON_PRIMARY, which removes the non-primary
+		 * transport this packet arrived on), so never register a
+		 * dead transport; otherwise last_data_from would be left
+		 * dangling once the receive reference is dropped and the
+		 * transport is freed.
 		 */
-		if (sctp_chunk_is_data(chunk))
-			asoc->peer.last_data_from = chunk->transport;
-		else {
+		if (sctp_chunk_is_data(chunk)) {
+			if (!chunk->transport || !chunk->transport->dead)
+				asoc->peer.last_data_from = chunk->transport;
+		} else {
 			SCTP_INC_STATS(net, SCTP_MIB_INCTRLCHUNKS);
 			asoc->stats.ictrlchunks++;
 			if (chunk->chunk_hdr->type == SCTP_CID_SACK)
diff --git a/net/sctp/endpointola.c b/net/sctp/endpointola.c
index dfb1719275dba..f9d4f318e132e 100644
--- a/net/sctp/endpointola.c
+++ b/net/sctp/endpointola.c
@@ -392,11 +392,13 @@ static void sctp_endpoint_bh_rcv(struct work_struct *work)
 			continue;
 
 		/* Remember where the last DATA chunk came from so we
-		 * know where to send the SACK.
+		 * know where to send the SACK.  As in sctp_assoc_bh_rcv(),
+		 * never register a dead (already removed) transport.
 		 */
-		if (asoc && sctp_chunk_is_data(chunk))
-			asoc->peer.last_data_from = chunk->transport;
-		else {
+		if (asoc && sctp_chunk_is_data(chunk)) {
+			if (!chunk->transport || !chunk->transport->dead)
+				asoc->peer.last_data_from = chunk->transport;
+		} else {
 			SCTP_INC_STATS(ep->base.net, SCTP_MIB_INCTRLCHUNKS);
 			if (asoc)
 				asoc->stats.ictrlchunks++;
-- 
2.43.7

