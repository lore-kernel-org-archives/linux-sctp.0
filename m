Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792843634;
	b=KkYpIwIwkkna7Rg7a4hv7kRKumrruMCp4Ml2qCuY/HvyIGZKbV/Ax0vRCRbHr986u3e1
	 OsTeqsztrZHSZ3m6EujD/423aWC56g2rk2QGxODvIX8AtADnX8wWyD2pCziLhsF9WTWBC
	 BI1skWuLPef/l63adKlucP07ZYCmK5kmp9k/sqtT1RsaoreJxHRBbWmZk2yz+JQ2e4UOC
	 JI8UsCXw00kttEO5Zg1lqsrYkaAyI7zcNcEEbm8MnDZWLISB/rj5jTmcRzk6aWFFelyxN
	 cV+uyM9ljUFZibmCg36KAM+NC6pAuCCVkafdbIPRxHL9EQmvbOmbf1jb9p3JczlPjJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792843634;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zLNM9fxN8Q0mYWX/OgajYSxuCiy7NImfGuJpx0sAOuU=;
	b=csdh2tb91/5NK3kLDGKxGXWFXajIidFrsyYIBHv9W4ROp8i4oOTJBCIaKt3dC7+0L++l
	 3dulwpiPzRWZA/oAtDU6EwNk/5UGbO46LAwShauLZ6S5YWAAikEUyJpEcRQ8u+p4IMSQZ
	 L/qVZJAOfppC8RppmscHUewANk4l2wxXm9+assRtwyDWBMGsjfHUA8ZLXFv6oiZ315VV5
	 sJZQdeGh8RJv1f3MbatmypBeDcMQ8vyuxUzahWShh7sxeTcUBl6HMCzJuKvKHg1Tt0dqN
	 U+USSVwziQs2bUKHqoJVJKMcJwaBS/6548CJqTNCv1m5BjPUF+20VCOiRTAH/hPVJaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=jbkjwaQH;
	arc=none smtp.remote-ip=74.125.82.171
Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09C7060A260F
	for <linux-sctp@vger.kernel.org>; Sat, 24 Oct 2026 12:07:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 09C7060A260F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=jbkjwaQH
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-36681e85e87so376752eec.1
        for <linux-sctp@vger.kernel.org>; Sat, 24 Oct 2026 05:07:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792843628; x=1793448428; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zLNM9fxN8Q0mYWX/OgajYSxuCiy7NImfGuJpx0sAOuU=;
        b=jbkjwaQHOM9PvR1//nhAnjt8kj/2TksQ4yOsFvy5FOP0dbrbBcz3Za7a7PKHXZYz36
         sZS1qtulphs4jCdlYqqjek2qB+1vZoV295ubms5R1QFlKO9i5SOOdwRgoOCqdJ9yQ7Wy
         dpB62kKcPiBHBqfOH/T2NltriOyz6mN+AW7DwZo64Jqh2VbJDp+FpLwJRHrOo5O8kf0p
         zPTNtlOkmz0p27ORnExmYq3J0kTMWFAwJBF1D88NpYt4zj/8VcEH8VG4meK23sNTM7Ft
         JvtEWROLMn7nXRvCnQ8gaLABalcEMonDfO/0KQGgHgHOWPSl4ChKdJBIz7VemKTH5n4A
         7xMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792843628; x=1793448428;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zLNM9fxN8Q0mYWX/OgajYSxuCiy7NImfGuJpx0sAOuU=;
        b=ZyZ0tmnG15JgFW2FmgPsSHVUCz16bGKrryx0O+4Zd+XFssh02CMYsTzigfJa8Wv/nl
         /ZOea0eGkURoC+4s8TbcaDbFHsw6NodyykZSXh3DolGnrYbzV4h7Ahqfg9QQ7AzsvPWO
         nOUV65itbByD58p7y9GsSBbkLYaaKqjqDh0w8A2PtEdxW6U22sB8P4om1dlO0eDoZQ2o
         hmqIZQPItZKvcVNcJzAWwlNEhQCzbfP4SKXTUwPdwjdSv3aq4exCUvpcKng2pI79Ny6Q
         EhIDjjxf3Rb1SoOvj9RJj4xGMIaBlgVr6iTH3mtGv/fVJ4wZp7yX1CSdccWlTO87AjmV
         b/vA==
X-Forwarded-Encrypted: i=1; AKwUvBxxkMpDl088HDRZrVBCnItRwCY2+hwy10NfZoXkW/H+EU8PKQt8AogByUALxTc9QuQcJCIiueKZmw3Q@vger.kernel.org
X-Gm-Message-State: AFq9FYJLhSSlk96kFqIFSGvD8O/DVWkQSYisNCGPJnJqoZnSee+ZQHar
	coRDELWBgpPiTX+/t+WshkqUhBfrXGmy7TiLASNki+he1VZGccozYtB5
X-Gm-Gg: AYBFou2LNGpI73O1JsBHOBn6g6XkkH9wxUXLkmTiId0eJ+o0lNdOv2iXm6pcIiiQRGw
	wzlqxh5lzT4U01NjDhsNd4XjJBI+RGnNs2H+c39rnTxNRFObGWIQoOGr9lR3EhrfQlpZYJAQilY
	v7MFFqdP8ueqw+V4wxnP3DrfnjAwZlH50qQPcRnqlu9/o6Ej/A6HfW7NoAczQ7hm+L4sBX7yooE
	QXfDa85t4qZOM0ZaKLDkdawgX5cKR56UgCC8a1dsNA3dZygsgjOZSwhrNT4ffwkMYAxpfVnFHIw
	H2sbUHpm2K9hRIVIQO+Kd+oy3nYjQ7H/eugjF2djIeb+qC4/1UR5gG4L3Ub7rbkB07i+ern/K9Y
	CfZtopxKt9paA4ueODQpqsH4DXoOnR2neJ/5rzulBjeWoPN1KR5PyQ+R94xRV5ElE8yWZkdh39f
	r1rocXcL/Biwrt+zSjROpTDsH+v/+tZxfo1VLF3u+fLm2dyJ1+Ae6tmgm5zRAjGOXMG4OrLv/1x
	NTt1v/oEPVwZpRzdHtc55libbOCF+X5D8nPAqQHf/GVD0c+XE59oaL7DDcH+jx/oF6ChWIWdtoj
	715SIVxnVD6mc1J+JoB93ssINQ==
X-Received: by 2002:a05:7301:4205:b0:369:d793:328d with SMTP id 5a478bee46e88-369e84bd8b1mr2964461eec.31.1792843628051;
        Sat, 24 Oct 2026 05:07:08 -0700 (PDT)
Received: from localhost.localdomain ([136.25.42.214])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-369e8d95e91sm8120722eec.15.2026.10.24.05.07.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Oct 2026 05:07:07 -0700 (PDT)
From: Tim Budding <tim.budding@gmail.com>
To: netdev@vger.kernel.org,
	linux-sctp@vger.kernel.org
Cc: Xin Long <lucien.xin@gmail.com>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Tim Budding <tim.budding@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH net 3/4] sctp: don't treat an I-FORWARD-TSN as an association reset
Date: Sat, 24 Oct 2026 05:06:26 -0700
Message-Id: <20261024120627.837568-4-tim.budding@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261024120627.837568-1-tim.budding@gmail.com>
References: <20261024120627.837568-1-tim.budding@gmail.com>
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

sctp_report_iftsn() handles both a received I-FORWARD-TSN and the SSN/TSN
reset request and response of RFC 6525, where all queued data has to be
discarded. It tells them apart by checking whether the New Cumulative
TSN equals the highest TSN seen, and if so calls sctp_intl_abort_pd(),
which aborts partial delivery on every stream, skips the MIDs being
partially delivered and flushes the whole ulpq.

However, sctp_tsnmap_skip() runs first and raises the highest TSN seen
to the New Cumulative TSN, so the check is also true for any
I-FORWARD-TSN that arrives before data with a higher TSN, e.g. when the
abandoned message was the last one sent, or after a burst of loss. All
partially received messages on all streams are then dropped. A stream
that was in partial delivery also has its MID skipped, so the next
fragment of that message fails sctp_validate_idata() as stale, and the
association is aborted with a protocol violation.

Drop the check from sctp_report_iftsn() and have the reset paths call
abort_pd() explicitly. For DATA chunks this changes nothing, as
sctp_report_fwdtsn() already aborts partial delivery and
sctp_ulpq_abort_pd() returns early when none is in progress. For I-DATA
the reset paths still discard everything as before.

This relies on the previous patch, which makes sctp_intl_skip() abort an
unordered partial delivery of the skipped message; the check removed
here used to do that at the leading edge.

Found by an AI assistant while working on the first patch in this
series. Reproduced on an unmodified kernel with the leading_edge test of
the sctp_ifwdtsn.sh selftest added later in this series, which passes
with this fix. Its reset test checks that an SSN/TSN association reset
still works with interleaving.

Fixes: 47b20a88566f ("sctp: implement report_ftsn for sctp_stream_interleave")
Cc: stable@vger.kernel.org
Signed-off-by: Tim Budding <tim.budding@gmail.com>
---
 net/sctp/stream.c            | 2 ++
 net/sctp/stream_interleave.c | 3 ---
 2 files changed, 2 insertions(+), 3 deletions(-)

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
index 77fe0db5ff77..f49b534ff78f 100644
--- a/net/sctp/stream_interleave.c
+++ b/net/sctp/stream_interleave.c
@@ -1225,9 +1225,6 @@ static void sctp_report_iftsn(struct sctp_ulpq *ulpq, __u32 ftsn)
 {
 	/* Move the Cumulattive TSN Ack ahead. */
 	sctp_tsnmap_skip(&ulpq->asoc->peer.tsn_map, ftsn);
-	/* abort only when it's for all data */
-	if (ftsn == sctp_tsnmap_get_max_tsn_seen(&ulpq->asoc->peer.tsn_map))
-		sctp_intl_abort_pd(ulpq, GFP_ATOMIC);
 }
 
 static void sctp_handle_fwdtsn(struct sctp_ulpq *ulpq, struct sctp_chunk *chunk)
-- 
2.34.1

