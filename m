Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793854974;
	b=1i3TFTj3bgXuW81CDSxVxuComkpPLPukYZXugHWq+6rWz97GFSnwTwmuxfkV4Ohk6MUs
	 nKTp48pAZI8vloAgK/jc7RbHWvk6SrYFJNOnlAt6L+Y4hZcA4D/IDuESf56wG6gOVGapY
	 pV66BXzHVzSth3Mm9YgJUTGkD67VAsaSDfqGaMpkj8WoYQtKqQTxGaMMNKlq56f21nvDs
	 OZDqyxVj24M48X13Kv0/YBam/atbKVdLAvagHDHM1fCjKhpnq5WQB9olvCcX4fIEk4qhe
	 1PbVSbH5tQUeFlCSuj5m2aK29bMztBcqf2IAzZZ8x3nHRycDK4f8ORsDNbugCh8hZXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793854974;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TF3dG/II9qrYEa2Qmqny+KjCxq+HEK6VEhmgidqtZ9g=;
	b=hVD5ziBAz9e4CKmV7LsToJPUCspFZhH5CNXCF3z9LaQJizgWJ5NNOAS/TZ+CUDHx2VT1
	 mSzY9b9TFHGceDhEUfJSsDwdXV99VtptTyxUOgyvst9X37e2dSYX+4k1NoO3WetjnOxCK
	 CV5b69/LoA5H7QbdFPEdl8L698rfFWdxFH6rotmhHQzQUhMv2XD8EMizvBLiZDu1gcb+o
	 n5gmGSe/NEQ3dxMxAH5vaxinjoB1GB8XbSI2/Ji/tOkoXVlVUSWMDGLMFDjSmZA27rhN9
	 +mwB5mlwEnqTw5Yt1jft0cHLiHstOdLU743XMY4r+XJ38Hg3ACbf+LmYf6cuv+f7HTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=jvcXWPBo;
	arc=none smtp.remote-ip=74.125.82.49
Received: from mail-dl1-f49.google.com (mail-dl1-f49.google.com [74.125.82.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1528C606D829
	for <linux-sctp@vger.kernel.org>; Thu,  5 Nov 2026 05:02:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1528C606D829
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=jvcXWPBo
Received: by mail-dl1-f49.google.com with SMTP id a92af1059eb24-19305bcb72cso1365142c88.1
        for <linux-sctp@vger.kernel.org>; Wed, 04 Nov 2026 21:02:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793854973; x=1794459773; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TF3dG/II9qrYEa2Qmqny+KjCxq+HEK6VEhmgidqtZ9g=;
        b=jvcXWPBo4oPsQGKrdvmfRGUxrtNptrfBHwHbDuBYiWoBP/PbA/e0/6vIGvZDg1o4KW
         xBy/ROcm1nDKrffPpwBo2MOmMNxacoz4XahOMl9+Q6QY18NzDS+UGvKiN4hB0MgpuyiE
         omok6Wmkl4sB+merjoI1ah8wVRDErhWLA4ULo4HvU6Z5CK+dhc9AANDHEbCKt9qX3Wnd
         aw76kTwCcRPuODRqwWbp61xLxId0Rc1feEQPMjIQl4uMbqvXTyFXwykSSrZdwBZA7T0x
         B0gkdP+VT2UfpWtb+2l2R34ZWlN+FTT8iDpHsAR53SfKFu1DeolJO+Y5JBjpv8a8PvzN
         +8hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793854973; x=1794459773;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=TF3dG/II9qrYEa2Qmqny+KjCxq+HEK6VEhmgidqtZ9g=;
        b=VKQ2jjcTEyXu9f8MmjNdEuf3+o0Qg2hCnTXEhdQRqwUOsv8Qv2+P3oCHEG3VJv4Uk+
         lIORT2WeFi5FGrgvVjN508dts6BRcIg9TFRjMvb0+2n3mQ9+j8MtyvTkbnk7u/X6xV6a
         wMBySyhOwqa0E/6fGYR4ISX2vOBQBlZGMoFAni/Gd9hMRr5QtoymxMJ2Ro+1qrJp979O
         TXfV/WgZigGnP0Z2oa4/vlkAyAL1wGUgkY1N5kGB0AWYQwdMaA+FgWMGm5I1f6I6yfl4
         Oz8yMYQ7B3qeIdSdfgNiBSD7il1LbNrvH0rIbSrSfOP9PEqITOvf7bia5GMDLxWWRl47
         z4hw==
X-Forwarded-Encrypted: i=1; AKwUvBwcJigZF3q/jYEcszSdJDLwNuagqO+bVjV2t+VBZXCJcEIxAgu2qbFZkuFNNGeZGsgzKzgheSS1VADt@vger.kernel.org
X-Gm-Message-State: APuU4Z877q9dYYI6ME8cKDMkJWi1QEuj8bo2cK07w7GM/ApXxRYSJyFW
	EubMVqqwXBsp4UdQj93ciXTUHOLZVGh3ffOlBuf9ZhELjqeQ57lU10Zl
X-Gm-Gg: AYBFou3HEYxDuJtKB30YIh4p7Qk2CHQJAyzUmsxOUcu6UiyDAlDx4Et1WVit510A/Jq
	6vIZOKpbXMwYmyCVn+Tc3N+aiihGkQHZMNnPH8951U9hUE3Z4mlYTkcZTcjzsiHcf+mjlwQ+73Q
	yj9tMcvBbJzG/jNaSbpizINjm3v41qiS3k74JNCjku/932AB8R0xryiiexC7iqoNe+QEfBEXV/i
	pzboE0KO77lwheXl1yn485t04Xp+Oo324g80CJp7MNQvMm0IeXEbJW+T7x4nVjAJci6A+mumfNs
	IJ5iO1qLV7yRpSpaGhk2bpKhL1ihTbaMtTfDg3PJ9PWxWEliN3XAxfCY3tcXKXNjYVTeq923tEe
	xYUZPHYDogJKVbYpHwt4o5pxx4XszJmCvORsJFV9d/TKCqONJluFTmSPENxfMPeYiBXI7G+kInM
	jmqsxGL7UVTca5GpYCA1latWgPuxfzz2Jsz5i+tQew1kpwPpCA84JyNR18fOcUQsKWpvuslOSEH
	80Lvw2/FFrTqo/84rYSJQOpMMHZVdIDOqaJtWGkDDNVy3E2ntwWlZGb4iWhLMU6Xk/GlS1VuUzD
	O5R79ZTmiJ6OJEI3EnsDc6jn5hrbrk7gd+zwBQoB/+fI71B7zgn5xwVa3NppiUDX+/WkjclQjPE
	=
X-Received: by 2002:a05:7022:3b88:b0:143:54c6:6a5 with SMTP id a92af1059eb24-1ac5c8379a3mr26747424c88.37.1793854973017;
        Wed, 04 Nov 2026 21:02:53 -0800 (PST)
Received: from localhost.localdomain ([136.25.42.214])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b245c1c283sm13626735c88.4.2026.11.04.21.02.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 21:02:52 -0800 (PST)
From: Tim Budding <tim.budding@gmail.com>
To: netdev@vger.kernel.org,
	linux-sctp@vger.kernel.org
Cc: lucien.xin@gmail.com,
	marcelo.leitner@gmail.com,
	davem@davemloft.net,
	edumazet@kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	shuah@kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Tim Budding <tim.budding@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH net v2 3/4] sctp: fix I-FORWARD-TSN handling of fragments on other streams
Date: Wed,  4 Nov 2026 21:02:24 -0800
Message-Id: <20261105050225.49292-4-tim.budding@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261105050225.49292-1-tim.budding@gmail.com>
References: <20261105050225.49292-1-tim.budding@gmail.com>
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

sctp_report_iftsn() incorrectly frees queued I-DATA fragments in two
cases. First, it drops any queued fragments with TSN less than or equal
to the New Cumulative TSN. This prevents reconstruction of messages
still being received on other streams and can fully block an ordered
stream. Second, it calls sctp_intl_abort_pd() if the New Cumulative TSN
equals the highest TSN seen. This check exists for association resets
but can be inadvertently triggered by any I-FORWARD-TSN that arrives
before data with a higher TSN, causing data loss and, if a partial
delivery is in progress on an ordered stream, an aborted association.

Fix the first by freeing fragments from sctp_intl_skip() based on
stream, U bit, and MID instead of TSN. Fix the second by moving the call
to sctp_intl_abort_pd() from sctp_report_iftsn() to the corresponding
reset handlers.

Observed in real use as unexpected message loss. Reproduced on an
unmodified kernel with the sctp_ifwdtsn.sh selftest added later in this
series, which passes with this fix. Reproduction and fix done with AI
assistance.

Fixes: 47b20a88566f ("sctp: implement report_ftsn for sctp_stream_interleave")
Cc: stable@vger.kernel.org
Signed-off-by: Tim Budding <tim.budding@gmail.com>
---
 net/sctp/stream.c            |  2 ++
 net/sctp/stream_interleave.c | 32 +++++++++++---------------------
 2 files changed, 13 insertions(+), 21 deletions(-)

diff --git a/net/sctp/stream.c b/net/sctp/stream.c
index e4354d58f20b..d5e71a2027f5 100644
--- a/net/sctp/stream.c
+++ b/net/sctp/stream.c
@@ -749,6 +749,7 @@ struct sctp_chunk *sctp_process_strreset_tsnreq(
 	 */
 	max_tsn_seen = sctp_tsnmap_get_max_tsn_seen(&asoc->peer.tsn_map);
 	asoc->stream.si->report_ftsn(&asoc->ulpq, max_tsn_seen);
+	asoc->stream.si->abort_pd(&asoc->ulpq, GFP_ATOMIC);
 
 	/* G1: Compute an appropriate value for the Receiver's Next TSN -- the
 	 *     TSN that the peer should use to send the next DATA chunk.  The
@@ -1028,6 +1029,7 @@ struct sctp_chunk *sctp_process_strreset_resp(
 			LIST_HEAD(temp);
 
 			asoc->stream.si->report_ftsn(&asoc->ulpq, mtsn);
+			asoc->stream.si->abort_pd(&asoc->ulpq, GFP_ATOMIC);
 
 			sctp_tsnmap_init(&asoc->peer.tsn_map,
 					 SCTP_TSN_MAP_INITIAL,
diff --git a/net/sctp/stream_interleave.c b/net/sctp/stream_interleave.c
index e239da686f68..1113b3455369 100644
--- a/net/sctp/stream_interleave.c
+++ b/net/sctp/stream_interleave.c
@@ -1203,28 +1203,21 @@ static void sctp_report_fwdtsn(struct sctp_ulpq *ulpq, __u32 ftsn)
 	sctp_ulpq_abort_pd(ulpq, GFP_ATOMIC);
 }
 
-static void sctp_intl_reasm_flushtsn(struct sctp_ulpq *ulpq, __u32 ftsn)
+static void sctp_intl_reasm_flush_mid(struct sk_buff_head *reasm, __u16 sid,
+				      __u32 mid)
 {
 	struct sk_buff *pos, *tmp;
 
-	skb_queue_walk_safe(&ulpq->reasm, pos, tmp) {
+	skb_queue_walk_safe(reasm, pos, tmp) {
 		struct sctp_ulpevent *event = sctp_skb2event(pos);
-		__u32 tsn = event->tsn;
 
-		if (TSN_lte(tsn, ftsn)) {
-			__skb_unlink(pos, &ulpq->reasm);
-			sctp_ulpevent_free(event);
-		}
-	}
-
-	skb_queue_walk_safe(&ulpq->reasm_uo, pos, tmp) {
-		struct sctp_ulpevent *event = sctp_skb2event(pos);
-		__u32 tsn = event->tsn;
+		if (event->stream < sid)
+			continue;
+		if (event->stream > sid || MID_lt(mid, event->mid))
+			break;
 
-		if (TSN_lte(tsn, ftsn)) {
-			__skb_unlink(pos, &ulpq->reasm_uo);
-			sctp_ulpevent_free(event);
-		}
+		__skb_unlink(pos, reasm);
+		sctp_ulpevent_free(event);
 	}
 }
 
@@ -1232,11 +1225,6 @@ static void sctp_report_iftsn(struct sctp_ulpq *ulpq, __u32 ftsn)
 {
 	/* Move the Cumulattive TSN Ack ahead. */
 	sctp_tsnmap_skip(&ulpq->asoc->peer.tsn_map, ftsn);
-	/* purge the fragmentation queue */
-	sctp_intl_reasm_flushtsn(ulpq, ftsn);
-	/* abort only when it's for all data */
-	if (ftsn == sctp_tsnmap_get_max_tsn_seen(&ulpq->asoc->peer.tsn_map))
-		sctp_intl_abort_pd(ulpq, GFP_ATOMIC);
 }
 
 static void sctp_handle_fwdtsn(struct sctp_ulpq *ulpq, struct sctp_chunk *chunk)
@@ -1260,6 +1248,7 @@ static void sctp_intl_skip(struct sctp_ulpq *ulpq, __u16 sid, __u32 mid,
 			sctp_intl_stream_abort_pd(ulpq, sid, sin->mid_uo, 0x1,
 						  GFP_ATOMIC);
 		}
+		sctp_intl_reasm_flush_mid(&ulpq->reasm_uo, sid, mid);
 		return;
 	}
 
@@ -1271,6 +1260,7 @@ static void sctp_intl_skip(struct sctp_ulpq *ulpq, __u16 sid, __u32 mid,
 		sctp_intl_stream_abort_pd(ulpq, sid, sin->mid, 0x0, GFP_ATOMIC);
 	}
 
+	sctp_intl_reasm_flush_mid(&ulpq->reasm, sid, mid);
 	sctp_mid_skip(stream, in, sid, mid);
 
 	sctp_intl_reap_ordered(ulpq, sid);
-- 
2.34.1

