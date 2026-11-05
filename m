Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793854969;
	b=daoMq4p5GFDIKEAJIWdFfgh6Xj1FEl01oNkRPsC0hQG0FXZvIdfte2UDy+8FzFH5LEHq
	 mtSErlxnZ56/SArwKoND97bRiPr7+7GuVHUIIMVFo7oUQxKPY64LQJFN6ideTytXMff/7
	 i7oXYSKz5fBlrPDFLwC7LfSEdt3swO1H9/7iovWa1WL/Vn5oAoepkbwYQzvAlVunnlTBi
	 Rjl11dI07DNRtHR80kToHRP1K+Ea5HhBghAN8F0HBUmO7ZZD78bOMYVD8A0d5XDUrPqMi
	 oPEvssyQ63pYZIW8ME5HLQr0Rfai0YnG6sFM6IT8/F0Wo8tTnrglWc9lYT+FJmNbTUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793854969;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZvR6TskZdWW0qqXirA6k1L3BiqLi1sfGsfq7tJ5wLss=;
	b=qDxyieaNnBAG8fNCvaVGr3GlFaVYDp/oG0lK7FuYKTSCseXqTrkCHjfjZ/qgkP3OKQM6
	 X1YOPPTcqofr/dAyPLT5vOvVE5o+Kw+m7NKTdN/QFBGLRln38RyYuYuynhiFB/A7N0Ls8
	 J9izo/D4iKJ1A0ilAKUApqGDioy2GtpUsu3H2FJzRS8J3JK+q4NJ9rJluvtyLUNtt7Ro+
	 S7mUt7kZvmxKxi29m/5g3iobh4SDY59NNh96PiRXTq1Opomwr+D+gN90NjxzmrsL+M1uu
	 tkKFSKay/P84rZucN0/QPX8TvacSxHXpWqnVMGDz13rTe/KgMK71oVgJlhOwLIay1nw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=iVqH7DZb;
	arc=none smtp.remote-ip=74.125.82.41
Received: from mail-dl1-f41.google.com (mail-dl1-f41.google.com [74.125.82.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D4AB606D809
	for <linux-sctp@vger.kernel.org>; Thu,  5 Nov 2026 05:02:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8D4AB606D809
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=iVqH7DZb
Received: by mail-dl1-f41.google.com with SMTP id a92af1059eb24-15dd124bbe7so601368c88.1
        for <linux-sctp@vger.kernel.org>; Wed, 04 Nov 2026 21:02:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793854969; x=1794459769; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZvR6TskZdWW0qqXirA6k1L3BiqLi1sfGsfq7tJ5wLss=;
        b=iVqH7DZbiXYw9I1iVCOjZ4e9C4Zj9/4MJHBezBN7pD87q4SvUWBwXrtJ0712sceVUR
         gTEj9SaTAXSRg78VMKO4rSzGIfEO2ZIsAhKT9Lqersq8HIbzx2VfuBENhnYee6LUWo89
         Mzg5IVoS2EbjHSPJYEnrLr9ysmuj3LZBkFFEv/iw8HhzS/ss0woub3STdsy4wtFVaEr/
         CfPkxVsI2GMqdOmgw2y+ixrXPdzoeBktMtV9flcUiuk3csIXxTkESHrHRxV6RwZj7Ajk
         ff97Mr2c5lUhf8VKXAZY/9FUMhbt4fdBemrTWsuvFmY2Ok75cUH62NKj0dfX8ogFPceX
         3dWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793854969; x=1794459769;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZvR6TskZdWW0qqXirA6k1L3BiqLi1sfGsfq7tJ5wLss=;
        b=h5bTgu67ELTR4t/8OImHCAs72W0lUQMTjspdYDv6AXtHI6y7VPr1UW7cTxuYsBK7Rn
         vDWQmeOb3fashaD4uUBheDLAfTjhCErgPq+0//Dd6fw26AFAXE0SsIy9DlpxzE7GPQGB
         0G6ncHw0FPY4vtG4ytl6f/izaHjdqvHR1of4zAHzVR/SNhqzpALs110m1lFgWok26Xq0
         UeLPoDRgLD/Lp9bAwzwjYQ8hY8SLeMPEAw4un+RncAwk6ZVGYD8bMLrkwWGec4a+KTRb
         n1Y/t6WeKeWC24BtJ1sIJz3SQMz/weHp31PsdambRmtQp8HQjG0KWKGcCFVzock5VY85
         1ukw==
X-Forwarded-Encrypted: i=1; AKwUvBwv/sm1IGb4hecrq32mg65a4vkGqiJw4V1swefToQ/vOl3kdJ/hiHY/sBBF85yzOPG0pz2EVnG63c3+@vger.kernel.org
X-Gm-Message-State: APuU4Z+M8yFCjAbj1TyuF3BX94qJdjVO5W/01gsq6E3Hl0uKTAJV2As5
	SozIXB2jh1wydxV6HZDBCFUKHAeukXkG76SpcOrLxapp0SkSDnTz7wyl
X-Gm-Gg: AYBFou2O/i2YU/ZvVsvkdyBaOM7uGkoxq01eNUnDV7HndXkWQILSWjHEEYQ+6doQQo5
	75u0yjOK46jS6xOOeYv9Fe2edAUaeMDuIpqEaNtLdBfGjsy2SiHmDUFZ0W2Xz/iQfTN8ZIbJzhi
	6jlDIUsxcv9mQ/DjaUmKMjTyZt1Il7n72SBmnzzBRf36IY/CwSGPvRfZaSPFB6hm2DovGw/Kbe6
	Ss4KlgKHVbU6/EYQtvTNybDozGyoy+ClIh88jEfxbwIdjz/x/XnlH/i/dhbM0WDGtjgGwJ3cFs8
	xyOhyhY1JdMiwt2IybptQBc9f2rh+8f8a+FN3shJRaMtYT8c/eMs+QnWfhdiFp4iIdEVVLzl7bp
	EKLHNXqby401vf16kEQiLTeglh+O2oqHS8G1Hzcw6M0BsIR1OpKcpXSh8JQD2V2xaFXyaMVfw6L
	2GEUCh0kh0aJFCN98QFe24rIPPRtPrSBrFWfQNxfPAuXhT7shPxF+URVE+VeXSoFkLqJBQgeMqi
	YW9fMK3M0ahA9GSho9AsCFY6xsfRcEUfPrnCWDIgFnishC3qY8GvdalzSOavD8yM0lXTHRFRhQC
	UnFpC7A9l7gLfxoq5coycbYLh1taLIGHMszvHC0phIocaHvDqpiqNNAhxlotsBuneMWykONLEV8
	=
X-Received: by 2002:a05:7022:29c:20b0:15a:9834:73f2 with SMTP id a92af1059eb24-1ac5c5554eemr25709808c88.38.1793854968501;
        Wed, 04 Nov 2026 21:02:48 -0800 (PST)
Received: from localhost.localdomain ([136.25.42.214])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b245c1c283sm13626735c88.4.2026.11.04.21.02.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 21:02:47 -0800 (PST)
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
Subject: [PATCH net v2 1/4] sctp: abort unordered partial delivery when its message is skipped
Date: Wed,  4 Nov 2026 21:02:22 -0800
Message-Id: <20261105050225.49292-2-tim.budding@gmail.com>
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

When an I-FORWARD-TSN skips unordered messages on a stream,
sctp_intl_skip() only aborts the stream's unordered partial delivery if
the MID being delivered is lower than the skipped MID. If the skipped
message is the one being partially delivered, partial delivery stays in
progress: no PARTIAL_DELIVERY_ABORTED is sent, and the next unordered
message on the stream is delivered as the rest of the abandoned one.

Abort the partial delivery when the MID being delivered is at or below
the skipped MID, as the ordered case already does.

Reproduced on an unmodified kernel with the uo_pd test of the
sctp_ifwdtsn.sh selftest added later in this series; its partial
delivery checks pass with this fix. Reproduction and fix done with AI
assistance.

Fixes: de60fe910543 ("sctp: implement handle_ftsn for sctp_stream_interleave")
Cc: stable@vger.kernel.org
Signed-off-by: Tim Budding <tim.budding@gmail.com>
---
 net/sctp/stream_interleave.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/stream_interleave.c b/net/sctp/stream_interleave.c
index 840f24045ae2..869940001588 100644
--- a/net/sctp/stream_interleave.c
+++ b/net/sctp/stream_interleave.c
@@ -1255,7 +1255,7 @@ static void sctp_intl_skip(struct sctp_ulpq *ulpq, __u16 sid, __u32 mid,
 	struct sctp_stream *stream  = &ulpq->asoc->stream;
 
 	if (flags & SCTP_FTSN_U_BIT) {
-		if (sin->pd_mode_uo && MID_lt(sin->mid_uo, mid)) {
+		if (sin->pd_mode_uo && !MID_lt(mid, sin->mid_uo)) {
 			sin->pd_mode_uo = 0;
 			sctp_intl_stream_abort_pd(ulpq, sid, mid, 0x1,
 						  GFP_ATOMIC);
-- 
2.34.1

