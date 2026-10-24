Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792843627;
	b=iSD4eVaoLqhMyaqCk3uG1Sh7eDe5VO8SdMNbq6Wigx0iAc/uhhUquPPH/IspMoh/oKn9
	 HpCSsaXHcBDdY9RsHxf6bpsdfpyO3MIx+DuDMf3M0r3XRYLWu098uJBp+sgxLS0f+iER+
	 ZufdkxC8Zhoc1AcvOkEBgezlesbf5sYC62lgflq9csgdmD2PtEKGBRlShuRhAgqfiNDLv
	 5OSPPmoE7KDXTtSOGO3JJnBmk3fyGg3JLe4y0YFjWYAiFPWPyh8tZ4vyMbhbhGqJ+JmkH
	 42jwCkRAd/VTsKVuDOWzBV0KJV9qc6eVrGAM3munh9nUxoYTll/b6EyrTGqOhRSKFag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792843627;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=os4tDb6Xj+U686/n75PMKZ7wN38a+tP5+DzCKnGGcL4=;
	b=K/0u6A8NeMdyumh8otI9noj9MY4CX3vSjihP4wktXhJEAYTCHYb4MSLUkHkNgqI/Mu7j
	 kvR41+N2PzRlJZjd+TBZUx3COrVNIZciDMjp/XLB25pShK2tRFSZKamG3f27gahjvIiQ0
	 az+By82zODCBmmPSIX8WECB581flNILPeWfuFSldXBZGi183MPJn208YyTHFQw/5g5fdG
	 qaowUmA26vwInJACaanHHCZAvMLS+hmxj1hkMMkeOswwLbRy6NNSB1T426T6QmmIPrQTs
	 nkvN5pVYWzBGXtyg1rONl311w3aAuq1MqVqILWQOhtnRWCXEg34pWCHvu8tmjyYsuzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=XSY6OdDC;
	arc=none smtp.remote-ip=74.125.82.174
Received: from mail-dy1-f174.google.com (mail-dy1-f174.google.com [74.125.82.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05070606A31F
	for <linux-sctp@vger.kernel.org>; Sat, 24 Oct 2026 12:07:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 05070606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=XSY6OdDC
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-33bf40b0c8bso3797996eec.0
        for <linux-sctp@vger.kernel.org>; Sat, 24 Oct 2026 05:07:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792843626; x=1793448426; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=os4tDb6Xj+U686/n75PMKZ7wN38a+tP5+DzCKnGGcL4=;
        b=XSY6OdDCSUlPOYv4PuPcxjInaUc3nzXMpvI8UYrp5Z4UXpyCr2KHLZRhqqkK3mbiGT
         EYi249un6JB5e4nmMahZ5NCubG4heReC1qXTKlOuJOZHZL8X2AnA56Qe1YVookEARxLG
         hfzgK1l9BzyWOBdfd21r/jlfhADCh1UJf2DzZAYn25t2pDyqrCVH6DxBLpST4JiGoks7
         RHs2HhOc5DFabGn05StfUXP7GRnO2A6nkhLjnjhzHLjcbOwJn6g3Rf3tchbuQ9ZNzVpr
         mIMJ5yCf3dpPOLs7SB4kWN4FCaqw0hiIlb14dGvdW7SPlHb9Jyp38OOazErINnS8VeAx
         MD2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792843626; x=1793448426;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=os4tDb6Xj+U686/n75PMKZ7wN38a+tP5+DzCKnGGcL4=;
        b=zau8FhG2wXUVVER6A+aE7M1kO5T98eGCxrGLK8fPBvchyoLQD/ocIryRjVpuJ1weBh
         nyMp5MugBiEs2w2o9ehlzWMG6kGf/R3VeABE9rCD9tMWyw3aKoNaD9rPEkj8sHH1ppud
         wFYZ0yC8vRjmlakQ1beAZBTl5R7xv/y5t8UkH1aCILPaFy/lBv6b5bJHYdf2TTuBK588
         kfL003Rf+GVvhz+WzGPgoUe6R3gBNjgx93Mm/rNDnWBPldLeu41vE0Dfb+PFaWeWxO6J
         vKDQGbL38ntSZEAbs9aXW/7JcrDmhwQC2rq195gPqOsQ55putnP4i7eCLgJhwn5au1vx
         tRJA==
X-Forwarded-Encrypted: i=1; AKwUvBwG9QkDqGOO85EPZQ3xTXHaLvi/W1WxMJ4DYtIZ1OA5EtaA+StO+CHqM3ENPlXLbl+cVGpUgeKVHJwi@vger.kernel.org
X-Gm-Message-State: AFq9FYLfttXIiGAwlh0YHFgaQ6RZRoLxmOnNjp9H8Hw7XA/4i5RLbIOH
	T6nV+OXdk8eqagH/ZwUgPS7oZJeeokGPQWuONxpKxklyZUZ0RUmhTeWn
X-Gm-Gg: AYBFou2+wduZ4Ih/DIZoMSW0stqC6cozOoiyziM0OOUkKJZ987XmkdIohDOzteR6pRP
	kX2PUPGWrU2AmUfEkVteX1+ZxIDgnlCKs2UApACJsccwr29hJDEYlEikr+s69ZxLJniRwcaskuj
	q0OlQp5vM9NLjzHabyZzUZsDN4EE3qxjAKjDS/prU6QIZjgMFh+LYcAfDrinkuaInnYLaLnwqCP
	DP8Ex2hZ2PpzVuL/QOIVKFd5W6RzbywX9/I2uhwuR06sJXnFQNpfL3zwNz3qQ8DceFbXpR0NZJG
	iy+aAh1r8h0E7AmA5sEMkP3xs6HNz3YkA9AebuDtYJU1qWEaojO251JhzNSjWxK3EXK+r1lxYlU
	QM9JQoZh8OyuTw27SVaSu0jCI9Ib3LpWW7/F/NgV3GVoDQxgdV/K+m/5hwPsHxfJIkaetXFzdAo
	cvmfW8OLCsykrrjZX/x0i7R2vF+3jYHTjaT8z09aJgZlhOil7wp8gSNAv9MFUN2auCS5HZWoA+3
	jxIBLrI0BhpyOiY6q1X/ArXZjMw9zgp/Mmm/7hwn48SVas67XzzTpJT/a4dYpTylDOl15IgT9RN
	gUgHLREpwxWEPcaSi5AWDZpo9g==
X-Received: by 2002:a05:693c:41c3:10b0:369:efd5:9cad with SMTP id 5a478bee46e88-369efd59d94mr691961eec.8.1792843626034;
        Sat, 24 Oct 2026 05:07:06 -0700 (PDT)
Received: from localhost.localdomain ([136.25.42.214])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-369e8d95e91sm8120722eec.15.2026.10.24.05.07.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Oct 2026 05:07:05 -0700 (PDT)
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
Subject: [PATCH net 2/4] sctp: abort unordered partial delivery when its message is skipped
Date: Sat, 24 Oct 2026 05:06:25 -0700
Message-Id: <20261024120627.837568-3-tim.budding@gmail.com>
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

When an I-FORWARD-TSN skips unordered messages on a stream,
sctp_intl_skip() aborts the stream's unordered partial delivery only if
the MID being delivered is lower than the skipped MID. If the skipped
message is the one being partially delivered, partial delivery is left
in progress: the application never gets SCTP_PARTIAL_DELIVERY_ABORTED,
and the next unordered message on that stream is delivered with MSG_EOR
as if it were the rest of the abandoned message, so the application
sees the two messages merged into one. Until a later unordered message
on that stream is abandoned, no other unordered partial delivery can
start there either.

Abort the partial delivery when the MID being delivered is at or below
the skipped MID, as the ordered case already does.

Found by an AI assistant while working on the previous patch. Reproduced
on an unmodified kernel with the uo_pd test of the sctp_ifwdtsn.sh
selftest added later in this series, which passes with this fix.

Fixes: de60fe910543 ("sctp: implement handle_ftsn for sctp_stream_interleave")
Cc: stable@vger.kernel.org
Signed-off-by: Tim Budding <tim.budding@gmail.com>
---
 net/sctp/stream_interleave.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/stream_interleave.c b/net/sctp/stream_interleave.c
index f8c818a5533c..77fe0db5ff77 100644
--- a/net/sctp/stream_interleave.c
+++ b/net/sctp/stream_interleave.c
@@ -1246,7 +1246,7 @@ static void sctp_intl_skip(struct sctp_ulpq *ulpq, __u16 sid, __u32 mid,
 	struct sctp_stream *stream  = &ulpq->asoc->stream;
 
 	if (flags & SCTP_FTSN_U_BIT) {
-		if (sin->pd_mode_uo && MID_lt(sin->mid_uo, mid)) {
+		if (sin->pd_mode_uo && !MID_lt(mid, sin->mid_uo)) {
 			sin->pd_mode_uo = 0;
 			sctp_intl_stream_abort_pd(ulpq, sid, mid, 0x1,
 						  GFP_ATOMIC);
-- 
2.34.1

