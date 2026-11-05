Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793854972;
	b=ljVwkh4iHJcVrYxV4qLvgpADbdQMb0eoqdr84yzBRf0SoSU6lLh6G4TIIDWzKXNQLA94
	 bC72937zSZElkVeGR1en+kEalZAlQRL+oNq2nNTf1kzURlNrJKzv5IhbxYzXE6ywQyEKD
	 5yYCkVdlqwk9sgx/pe8Zr4qaaqYbazRY9cD0m6E+mXU9PXOFT36A5AykKUjpEzYqWzN0K
	 otQeX1y6kHJq+LOi+v6BOD6leLb9DAUO9eMEQ4e+vn46lkYw5HP6aUHGlfw0itlk6lTUr
	 DzommKygNNSLwKbRuJT4pbk9z7pnAYigGDtQQ0Ilgvn67jNYmChyIFugMQxl2ZxoYVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793854972;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JrA96iHSEppxQ2hp+sSJL/g5LPKU9LnKIC8wGzFqNw8=;
	b=Yu93oE85OFYdUwnqr2BFCaLYTHKJLltFXFOO+x6wnQZ7ZSodF7EDgzBXrP073RKIFcH8
	 cHe+exp9h+Z43WmkSkFUqqoKDsr0SQeA9eGYv/nJqmsdYZchTRrnryLuppUg3LAIrGX9J
	 LnqCqbLm7KJvOxlRb75hdiAiG9P+WmJDvyDqi2x1++TpYDSkr0in6xLVF+vmWQiKySa7s
	 5PuF4kQpsnjGSNzYxDvIL/tUr2KXiWkdpPyHzZF35AWP3s01xInmvXgOh7BVbSdEzP35n
	 lNbeIoDE1pk8BOKgOj+L9k9mZ4PfQTSy6cw1cBMb72h10GD6fGyycpDYtRY9Ds7ADDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VxNtRLI3;
	arc=none smtp.remote-ip=74.125.82.41
Received: from mail-dl1-f41.google.com (mail-dl1-f41.google.com [74.125.82.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4538606D820
	for <linux-sctp@vger.kernel.org>; Thu,  5 Nov 2026 05:02:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B4538606D820
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VxNtRLI3
Received: by mail-dl1-f41.google.com with SMTP id a92af1059eb24-1a8cc11ac42so1571656c88.0
        for <linux-sctp@vger.kernel.org>; Wed, 04 Nov 2026 21:02:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793854971; x=1794459771; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JrA96iHSEppxQ2hp+sSJL/g5LPKU9LnKIC8wGzFqNw8=;
        b=VxNtRLI3j9T/8JzZeBa7Vg/9x3/kswBzW6MPGKAqaXfVyJ3lITbV4/VITEAICjFfMf
         eMk2B5AHjHt7knwLMB+T5Dshpo8fW5iugQoOKGXGvPz3mr5TGAdRRLcJWqL3TK8DyxDq
         cnBt51+U0LBmPPBvJyvPOSnvB5X6rTiDbKxi4szD6gQ51Oksxy/4Bf9/dg7xdWFE5xal
         ezJPO7Yz6vgEQ03dSP9ltynu3OCWaAeHuPGbVFyqCwv9sIQRTT5BErN8iBOywapHneTH
         3W9KbNFG6O4UgwRN8R5O6iyiVcff28vJEYPlqlQ4lLwQII/aIh2g+A8eGVJPWgXFSnUN
         Tt6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793854971; x=1794459771;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=JrA96iHSEppxQ2hp+sSJL/g5LPKU9LnKIC8wGzFqNw8=;
        b=SJl83VkdZLOwOubUzcLmRQhMnCw46Pb5Nwon4sAg8URSzVHm09Tp/kwuhqrEgvhQ0I
         5r9rsOfvNYnVd4QlKJzvbU17yoNEPHE2MyW3qHvAodNHt/fo6gSgEg5p3ipZ19xb9CBY
         gSxfznsiiFIWWLqcjCjRUgMtH9HdJNfK4ptUfnt3IxyDKo97lp1hra+86k478EPP83s2
         gB6dqqXTQIP0NyGvuVkCFwJx1zXWUqaWZWM/+f7IOtCRdYP9WO0gBzmgg7NpP0Rzcit+
         mUpAZXhoZwVNO3WB1dJu86XcwiaTu0aZ6/Q4sE3z9ttpI04yZXQFT/YIy/mVafc+FzMT
         XU2A==
X-Forwarded-Encrypted: i=1; AKwUvBxGBm1X7VdevMuhXZ6oIAynm+yvXHr1OT0C4ZO3+9Ma+0m/vuN586z5ahpWhG08YylyN2Zxki0o4DNF@vger.kernel.org
X-Gm-Message-State: APuU4Z/jayD94hlsD2FTEshwufCOkGdTWlLxUXW3hY1HA65PlAAnyMaz
	3X/h4i+XHaiEO/Tg8II9QS5CYDlNBBhac5u0GS3EvseqxcwEcf/n2HVB
X-Gm-Gg: AYBFou05mOQxeeOBYp5GhvVakLvNWIaEkt4MWBpgVoh4HoGqXHkFF+pMJMHXjbkwrKj
	xtJM9P0fvcXC3hQZf52fM7RmgX+f79/Yabn2NvEFvjuRkpM0uNrczx79kOC7BXLfp4AL4smATGe
	fW+A31jbVo1VEFE1/ikp4yUYyUq0Md9CSnwT1dXC2wfdIYnMJf4Sbt9PSQvh9pSop0/MWEZQQha
	yJDotxeY/wPKdTYS8U9MQEgqnbvmneFL0GLIOPA/Z96HKJe9wqt/ASilLF/ISfn/2XeooahI/Y0
	yD4AEojA9akVcX7SArsSNE+waAAGaGd6itBVy76bw0NazOFRGortFcunmSQa/dVnTQ8sYG7vTdy
	jhkn9+2uIo2kJhFFlznaXzUsij1REmb9T6TOwHr6Qvj0eqDBZHGclua4u/0LZ8AGA04gBoogaZm
	iUZ7JXlSLWn1tyBikEDAi1yPzbmKZRG37ufZewcYqup/FcxkP55t9m+smgu5jnwDtMF7CmvRyO+
	N3NERxd/HbNlRs2umnxu4O0naMhUG2z8AUZPgJQ4m5jlSrj7m/0PvVGHk0nrg9qzDRJexASq1QQ
	SJQi9WDZpHhgFEKS3VhYY64wxgHh6hy9hbOrLmVJCKevQvtSGm9XJ34EvuwzATeV6caZWasMz8o
	=
X-Received: by 2002:a05:701b:2816:b0:182:94d7:f76a with SMTP id a92af1059eb24-1ac6088a34bmr25504978c88.43.1793854970493;
        Wed, 04 Nov 2026 21:02:50 -0800 (PST)
Received: from localhost.localdomain ([136.25.42.214])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b245c1c283sm13626735c88.4.2026.11.04.21.02.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 21:02:50 -0800 (PST)
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
Subject: [PATCH net v2 2/4] sctp: report the partially delivered MID in PARTIAL_DELIVERY_ABORTED
Date: Wed,  4 Nov 2026 21:02:23 -0800
Message-Id: <20261105050225.49292-3-tim.budding@gmail.com>
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

When an I-FORWARD-TSN skips the message being partially delivered on a
stream, sctp_intl_skip() passes the MID from the I-FORWARD-TSN to the
PARTIAL_DELIVERY_ABORTED notification as pdapi_seq. That MID is the
highest one skipped on the stream, so when more than one message is
skipped, the notification names a later message instead of the one
whose partial delivery was aborted.

Report the MID being partially delivered, sin->mid_uo or sin->mid,
instead.

Reproduced on an unmodified kernel with the pdapi and pdapi_uo tests of
the sctp_ifwdtsn.sh selftest added later in this series, which pass
with this fix. Reproduction and fix done with AI assistance.

Fixes: de60fe910543 ("sctp: implement handle_ftsn for sctp_stream_interleave")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/179293012867.3134.16497481637722705271@kernel.org/
Cc: stable@vger.kernel.org
Signed-off-by: Tim Budding <tim.budding@gmail.com>
---
 net/sctp/stream_interleave.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sctp/stream_interleave.c b/net/sctp/stream_interleave.c
index 869940001588..e239da686f68 100644
--- a/net/sctp/stream_interleave.c
+++ b/net/sctp/stream_interleave.c
@@ -1257,7 +1257,7 @@ static void sctp_intl_skip(struct sctp_ulpq *ulpq, __u16 sid, __u32 mid,
 	if (flags & SCTP_FTSN_U_BIT) {
 		if (sin->pd_mode_uo && !MID_lt(mid, sin->mid_uo)) {
 			sin->pd_mode_uo = 0;
-			sctp_intl_stream_abort_pd(ulpq, sid, mid, 0x1,
+			sctp_intl_stream_abort_pd(ulpq, sid, sin->mid_uo, 0x1,
 						  GFP_ATOMIC);
 		}
 		return;
@@ -1268,7 +1268,7 @@ static void sctp_intl_skip(struct sctp_ulpq *ulpq, __u16 sid, __u32 mid,
 
 	if (sin->pd_mode) {
 		sin->pd_mode = 0;
-		sctp_intl_stream_abort_pd(ulpq, sid, mid, 0x0, GFP_ATOMIC);
+		sctp_intl_stream_abort_pd(ulpq, sid, sin->mid, 0x0, GFP_ATOMIC);
 	}
 
 	sctp_mid_skip(stream, in, sid, mid);
-- 
2.34.1

