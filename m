Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792687003;
	b=Llz3LEjQp0tAQjvxyZgafYulOAqtZ1L+1z0zqg05XTvUIhoVqODQSAOfaVignEBMlEnq
	 NdGMCQAmDjdnDPq7pxpUkAJ4R6Wgbbu9OOjaghs42UvTtgbEsL+OYOzohMParF53IPlVv
	 CtN0jtNOeKI6qhDl2Umm5X6cqEHoaBrEeF+5bOKoAcvvZl5Yt9+QDViJSna1oXnUuO07f
	 v9GwKmrUjgLWTCQuvvW5Gy5YGWb5dyHUNpVSnhiyD1VHWknVkqSLZ1yX4DpQNHPMnEnRg
	 yW3ppt3UJ5KgKP3VlKCcURujkCueIWkcQsnVV905cEVR7FqstBk8BVO9eZ/nBcAAAuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792687003;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=R7l9GBldBqggvq/zvWK0w7jaQ7qb61TWRK+g3QMrrtM=;
	b=oGyL7zbGdCXV+67wPnvUe9hoSN6QQMLewR8T7LwV8e8nsji/zjptldL6oJCl+lQhvD9U
	 dEp/PBarZbuY3syZDKsevNKer9k1C6tPhQdrdKhclHsrikZpj0AYae49pPSgXPrSQM8Kz
	 kV9oUVHu0KXJqfghI4EJT3D0sYPs+hPWOUkNGqpz3RWtUPtpIv7Qpd2vDKFtGvrgYtM6W
	 JhEyFw94mlsusOWdsuBaqtPi7aPB/6TsuYNzSi6i3/mbDJnXAR1WjURrySGrRAS7xdfv1
	 0QBYb4XZmfavinS9u0c7qjgZXp3Fs5j42CXmd3Dw/vRtzGcRoY0vw7xl01NeTs0zPEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b="Vokx/Tg8";
	arc=none smtp.remote-ip=209.85.128.53
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 721C1606A319
	for <linux-sctp@vger.kernel.org>; Thu, 22 Oct 2026 16:36:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 721C1606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Vokx/Tg8
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4a140e7405dso48715e9.3
        for <linux-sctp@vger.kernel.org>; Thu, 22 Oct 2026 09:36:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792687002; x=1793291802; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=R7l9GBldBqggvq/zvWK0w7jaQ7qb61TWRK+g3QMrrtM=;
        b=Vokx/Tg8TYjm7F/SKH8DDaZUu92EOwWBEPcfCIIyGelydx+ks+r3kdT/Q7Pf8xeFu5
         Q93181FjebSTzRVLLMCnCIgs1ZtiJPV3dJTwJgt3PsEDXNq8O0NssbWA7dhYpG5cdMa6
         rv2M7wIv4eaS+CHYapfxkr5yKhlLjjGMdu1R/j2MjAIXxwdQabrnCVh6EnCXGziI0K9U
         XlO4jocMxrcN1M2TjO2Qp8EUHcTGoxAeWykVXoJ3K2NFKCv8ujmiHjJGh/puVnGVBQIs
         LVhhycFDpcGDnbNeR7uxY23W6NEAzsNdg0eK4riZzHlw4Jgm45N8SCjxNdT2OQjGo3b8
         aq/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792687002; x=1793291802;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=R7l9GBldBqggvq/zvWK0w7jaQ7qb61TWRK+g3QMrrtM=;
        b=wa4aM8hqcg4TsmeZSYbWArVo6BszoA9UADZkOxeBTf6EPPb2WXZwFqDTRC2DYDiSpD
         klEidWoKnoIlaVsSJrHIfTpAD1ExzJI6O3uLdB9EoUtDzQH090SWldY+KBFVyavbD516
         UCwweNDuSaHpsDwp5MMVGrRgZhudHvrF/7mDYzcjk+btizo1HPRYsYl1YLDNARvBjmGb
         CDgu7dGj6QtImpW94+R/aauopID1MxTbGM7qxNRa7nnScm/JY3/oBu4upm3blWdD2tpx
         H1iD/6/8lpMxPdPtfoewQNuKzlx0+n0DplWBVwpRUWKhmeJaCTjihkeCnaYAmXtz+Fhu
         BNBw==
X-Forwarded-Encrypted: i=1; AKwUvBxaT+OETLxja6AHVrsn5kTz4MRvdX7Vq28WOTvNXsmmD1YUJa6Cnuo2O5K/9PiwtB+/VC7sK1dJpeUW@vger.kernel.org
X-Gm-Message-State: AFq9FYJ54a/hWp6XntiXdbMSVDQcXRMAGfFWL2gwQNb1cck3a4CfrGJb
	EFBP4fChCRwtEKQpJcpuARZNIt5VhIUT61nSfgjRGOcEUo5HWGH2VwYVb63L1w2CiR3t6A==
X-Gm-Gg: AYBFou2tPJGZpTZ02o15DPFkZFu2XLEopgkmLVaiQijL+U+kCh7mbIJJYs/VpWzZFr8
	IZlPRsvZWSLlkY5JeZtc/W/WipqDpXlv9F0vgqcbHU/DbcSxjnz6sbbXG6jDmkBh9z4BaYp9A5D
	X5neEb5si8zFDNG245ZP+PRLXI63kfEd8opZhs/AVCdvvtfHwkuE68AqwMjpWEto5ecp5JEpnjT
	8FFYoHYeUFsbQr4tykOwBE5XGgX0fZCzw/XUib+l5AGN0bc8WqaUn8SyJGj2QudW7sV3SMcY0a7
	P8dHrMp2OYz/wU+maLSnNvj/r63jbyJFkR942oHVlFOywdYCbnpiLA42b+KbYfc6bD9njq8p6y8
	PWFYPyPRzGRgJ/HPHzcmX97xZSSscgfSeMQjf1QYv57rgMLTT1LptqIKm60gHAxpZeOdNobWVBB
	AeAyE7C2b0/U9yVw1yq6EPh4wHEdl9NtTNK21b3vzI3OronVKV5YDwn+ioHO5g4pw6Zj+Uq1dRF
	APgGHHJe7mTXY/RjaFyGyPBG90J22bvPbWbK3xpBRSytslO1zI=
X-Received: by 2002:a05:600c:620a:b0:4a1:706f:b40d with SMTP id 5b1f17b1804b1-4a1fdb1a609mr102596995e9.7.1792687001668;
        Thu, 22 Oct 2026 09:36:41 -0700 (PDT)
Received: from dev1.kernelcare.com ([2a01:4f8:172:1c85::2])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a210299910sm8263415e9.1.2026.10.22.09.36.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 09:36:41 -0700 (PDT)
From: Andrey Misiurov <andrey.misyrov@gmail.com>
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Xin Long <lucien.xin@gmail.com>
Cc: Jun Yang <junvyyang@tencent.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	linux-sctp@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Andrey Misiurov <andrey.misyrov@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH net] sctp: fix ASCONF address change on single-homed hosts
Date: Thu, 22 Oct 2026 18:36:39 +0200
Message-ID: <20261022163639.2566945-1-andrey.misyrov@gmail.com>
X-Mailer: git-send-email 2.43.7
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

Commit 9b2854f86f0b ("sctp: don't free the ASCONF's own transport in
DEL-IP processing") refuses a DEL-IP of the transport the ASCONF was
located by, so that a later wildcard DEL-IP cannot use it after free.

This also breaks the single-homed address change (RFC 5061 5.3.2). The
host sends [Address Parameter L] [ADD-IP S] [DEL-IP L], the association
is located by L, and DEL-IP L is now refused. The sender never gets an
all-success ASCONF-ACK, keeps src_out_of_asoc_ok set and stops sending
data, so the association stalls.

Fix the wildcard DEL-IP instead: look up the transport of the packet
source rather than reusing asconf->transport, and clear
asconf->transport when a plain DEL-IP removes it.

Fixes: 9b2854f86f0b ("sctp: don't free the ASCONF's own transport in DEL-IP processing")
Cc: stable@vger.kernel.org
Signed-off-by: Andrey Misiurov <andrey.misyrov@gmail.com>
---
 net/sctp/sm_make_chunk.c | 15 ++++++++-------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -3150,9 +3150,11 @@
 		 * packet MUST be deleted.
 		 */
 		if (af->is_any(&addr)) {
-			sctp_assoc_set_primary(asoc, asconf->transport);
-			sctp_assoc_del_nonprimary_peers(asoc,
-							asconf->transport);
+			peer = sctp_assoc_lookup_paddr(asoc, &asconf->source);
+			if (!peer)
+				return SCTP_ERROR_REQ_REFUSED;
+			sctp_assoc_set_primary(asoc, peer);
+			sctp_assoc_del_nonprimary_peers(asoc, peer);
 			return SCTP_ERROR_NO_ERROR;
 		}
 
@@ -3165,13 +3167,9 @@
 		if (!peer)
 			return SCTP_ERROR_DNS_FAILED;
 
-		/* Don't free asconf->transport; a later wildcard DEL-IP
-		 * parameter reuses it.
-		 */
-		if (peer == asconf->transport)
-			return SCTP_ERROR_REQ_REFUSED;
-
 		sctp_assoc_rm_peer(asoc, peer);
+		if (asconf->transport == peer)
+			asconf->transport = NULL;
 		break;
 	case SCTP_PARAM_SET_PRIMARY:
 		/* ADDIP Section 4.2.4
