Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C445339844
	for <linux-sctp@vger.kernel.org>; Sun, 26 Jul 2026 06:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785045904; cv=none; b=eWrZQitdsQR/13TpW5iU2uniM4ZTqY3gTp36alSctTWPcqgBqkmBqOJ3gz2K9mLXYxZ8a+9zBdCl+0KsNBGiRIlScXsmylPZvjIq/+aUx+M9N34U4x/Dcv6R4t/2hMtS0f2g1MOPCuD71DnQ77UuNy/0W/92GBMRM5n2d3FmEl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785045904; c=relaxed/simple;
	bh=c5XNKNHTZbrHkPw/Z+1eXictyOLeMAlNLdg3abaiNhE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nlqgzcves3Nz8F4/5j/NsxAI4Sa8xZSwXvjSAi9LpSF+wDJ2KZ8/acS9VNGSyhaJgZiyPEwoq1hPqsVhEnYCs3OsoGlCDFXAZDA7TAnDfuu/TNNt3w22+juWkePuAy5TBBfmL9E3GdnI0dBWgEYmmiQCM56GurTWfplg+BrxUEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xbow.com; spf=pass smtp.mailfrom=xbow.com; dkim=pass (2048-bit key) header.d=xbow.com header.i=@xbow.com header.b=MAFghmyb; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xbow.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xbow.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=xbow.com header.i=@xbow.com header.b="MAFghmyb"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2cc7ef7ec27so21505815ad.1
        for <linux-sctp@vger.kernel.org>; Sat, 25 Jul 2026 23:05:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=xbow.com; s=google; t=1785045902; x=1785650702; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=J5QJoU4w/3scQb+Fz57sP6CBWEGcVzv5XgFT6cYtEy4=;
        b=MAFghmybkKJrchl8Nn1pNIEUig8qlesLsrUZjTflHGzehgdXx9Bvp2AbTbLUHWm3e1
         MnEVdJOeTbIGUBoPkNh63ZO5wHwq5vrt8pQdjqRZIUSyTuJpXVO+hyc8Bhsiul9p5ycr
         xbngiMi6J87zpyUmaJuGBHG6I4Ru6WBIzO6hf+gs6IHIXKAlIFwLdYupg0JX+LCZHbyy
         HyhLI6atnOGJuqOsZSmbvoXJQzCwuDY3Twq5pF0/cUWH752JJVTQNMaB+edRs04SNler
         LNQstZU7Q0xm7DPIaY7GuvEaLenVeQEF+8tlvrxV8WrKMiBlgeYUV5z23hcJQKsazV3n
         gpTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785045902; x=1785650702;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=J5QJoU4w/3scQb+Fz57sP6CBWEGcVzv5XgFT6cYtEy4=;
        b=ioLL1zGO+Dfh8DPOpUxRxRmm13ScRsz9MkDAL8Y0lJhPgKMCtPZY68dM653NIaZC+n
         pQRePiNsglxqDF5ldutXsfcQxCR5nCIYxQr71Pftg5ydthleVBlIUpUQwJxgIcvIJhnU
         hoFV7tbM8h+PQ6SnCScigKcriEPnfuqhGRfSTNgDQ0GhjNfhmhyQkJJreokAoJ/gqvMH
         AK9FukNy9/6oaZcf26SN8N3ImOQfiyD4qrTXW34COjraC9Z6ScHAjVprWVmLq1dq1CrY
         G5hCNayREN9P/R5vbC2rVi/6mXHrs9sSUiJk2PO0+R/y/Nl49tVIj7U1T5M5iwtTLZzs
         lmQQ==
X-Forwarded-Encrypted: i=1; AHgh+RrHF3ZTiqptJmHWEtbYrS2AFOpljJaapCx94zwOUBbZ2riM5eOt7rLan0T/Nf6IAsmZJCvm+kIsMJIT@vger.kernel.org
X-Gm-Message-State: AOJu0YyW59E9G1FDw+TY7w6iocCAxZTNAvywF8Kjw2Ad0YYAxKOMRY0L
	vN7lIC9sA7X/cbA7LIV32CZ6Ch/dgxaHVPcTf7ggl2G+edztZTjf15L7LAQT0lBcN+uqLnz8GUC
	8eEhGpUQ=
X-Gm-Gg: AR+sD11geOfrMm+2ayf2PsamFVzxzWLUNCOQGfWp19ieXsQI33Tmxfqk5aJLw1czw5F
	A8YaHWEzHmxfqGAafgvxTtO9PtspJQVAfJFEBrEC5YP3ZQlVFWYd5efDNOuLjy9lDZzT8tgJe26
	G0tBCiiseWBYrOhkEsgdUS1OHkDqMReOssudSQJH0tmNuWQGV6hX0ndRzib0w3pgWk7CZfS8Z5G
	s+NCX2wFnnk0bptvIKkaIRhR7prmTH8sZ6e3X3mP8+Ezm2qsGO/8d/CBdqWPNFTWQKjy1qAklZw
	BZFoY0WqDvTE91oG4goAgxs8U9MZ8r5OA+cbb3pyQrQJyX9HRWaI43NQ8BbYFM42mTOphiTTMJQ
	WIKuVq0JdAicDbY8xwxWMY6SMW67cbT5qw4tXgnKA/Tymek1hbUg0FaxvSWtlfFA4zHGVHkk5qV
	lr8hlXag8YAgKKvfMu5aM3rTFTueY3oYwarb9nxebYTRQNEXSEe3x55k6J6V+wky5hBLSmR38=
X-Received: by 2002:a17:902:ef49:b0:2c9:97a7:3276 with SMTP id d9443c01a7336-2cfde89b889mr40088285ad.39.1785045901839;
        Sat, 25 Jul 2026 23:05:01 -0700 (PDT)
Received: from localhost.localdomain ([125.128.148.126])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cfde80ee56sm16774265ad.76.2026.07.25.23.04.58
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 25 Jul 2026 23:05:00 -0700 (PDT)
From: Baul Lee <baul.lee@xbow.com>
To: netdev@vger.kernel.org,
	linux-sctp@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: marcelo.leitner@gmail.com,
	lucien.xin@gmail.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	federico.kirschbaum@xbow.com,
	Baul Lee <baul.lee@xbow.com>,
	stable@vger.kernel.org
Subject: [PATCH net] sctp: fix transport UAF via the retransmit queue
Date: Sun, 26 Jul 2026 15:04:53 +0900
Message-ID: <20260726060453.42730-1-baul.lee@xbow.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

sctp_assoc_rm_peer() clears the cached chunk->transport back-pointer on
only two of the output queue's chunk lists before freeing the transport:
peer->transmitted and asoc->outqueue.out_chunk_list.  A DATA chunk parked
on asoc->outqueue.retransmit keeps pointing at the transport, so once
sctp_transport_free() drops the last reference and the object is
RCU-freed, that chunk is left with a dangling pointer.

While the chunk sits on the retransmit queue the dangling pointer is not
followed: sctp_check_transmitted() skips the flight-size accounting both
for transmitted_queue == &q->retransmit and for gap-acked chunks.  Two
steps remove that cover.  First, sctp_outq_flush_rtx() moves a gap-acked
chunk onto a live transport's transmitted list without reassigning
chunk->transport, unlike the ordinary resend path, which rebinds it in
__sctp_packet_append_chunk().  Second, a later SACK that reneges on the
TSN clears tsn_gap_acked.  The chunk now sits on a transmitted list with
tsn_gap_acked == 0, so the next SACK reaches

	tchunk->transport->flight_size -= sctp_data_size(tchunk);

a read-modify-write inside the freed sctp_transport.

The transport is freed by an ASCONF Delete-IP and the faulting accesses
are driven by ordinary SACKs, both coming from the association peer, so
an application that speaks SCTP and accepts multihoming is enough to
reach this.  KASAN reports a slab-use-after-free read of 4 bytes at
offset 216 of a freed kmalloc-1k sctp_transport in
sctp_check_transmitted(), the object having been freed from
sctp_assoc_rm_peer() via sctp_process_asconf().

Clear ->transport for chunks on the retransmit queue as well, mirroring
the existing out_chunk_list handling.  The sink already guards with
if (tchunk->transport), so a cleared back-pointer is skipped exactly like
an already-acked chunk.  The sacked and abandoned queues do not need the
same treatment: chunks there never have ->transport dereferenced and are
never migrated onto the retransmit queue or onto a transport's
transmitted list.

Discovered by XBOW, triaged by Baul Lee <baul.lee@xbow.com>
Reported privately to the maintainers on 2026-07-10 with root-cause
analysis, a PoC, a KASAN log and this fix; posting to the list was
requested as the follow-up.

Fixes: df132eff4638 ("sctp: clear the transport of some out_chunk_list chunks in sctp_assoc_rm_peer")
Reported-by: Federico Kirschbaum <federico.kirschbaum@xbow.com>
Reported-by: Baul Lee <baul.lee@xbow.com>
Cc: stable@vger.kernel.org
Signed-off-by: Baul Lee <baul.lee@xbow.com>
---
 net/sctp/associola.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index 62d3cc155809..c95f68d21670 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -569,6 +569,10 @@ void sctp_assoc_rm_peer(struct sctp_association *asoc,
 				sctp_transport_hold(active);
 	}
 
+	list_for_each_entry(ch, &asoc->outqueue.retransmit, transmitted_list)
+		if (ch->transport == peer)
+			ch->transport = NULL;
+
 	list_for_each_entry(ch, &asoc->outqueue.out_chunk_list, list)
 		if (ch->transport == peer)
 			ch->transport = NULL;
-- 
2.50.1 (Apple Git-155)

