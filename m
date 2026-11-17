Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794913510;
	b=seoGKlSu9+pwk8iOeYU2b0z/OqvD2g1pAfBr373kPnBR654qHm77HnfMrQLDmmL8Gmji
	 bOy/QHSqY5oABpAbpn1ocUjNWkTRy85Fy1k9EVVsUN20zIK7cfIZ7n+UCSAUESHlGCon5
	 15HBNYGnHvCuY++cKlAFsDpA1L70mqYzYazz3g/L3bO30JnzJ3cewd5kzWPXn4QNjlAz3
	 mABaZ6g9QxthsDvn3btmzpBDnEfXBe83GY+4f67m3Z3JGQShUCDX5eBjLWTfQDPcxWoKw
	 0VtgrRl/zpjkTse1CI3FFNQGDoL8JvTY7sEVixrw5gZCq5jMqvFxY+O4dzH8C8W8Njw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794913510;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=APyRDGNpX/sOhc1G62vzvyzvnEtlXJLA4HeAQhpE9p8=;
	b=vCb6I3LERZ8zPyabwRwHmGr28s5LU1h/q/q/P6ASdybsv/6bjRQtYi/cIOpZyZTqaKJu
	 B+OYNEDttwbIv56S+mDcJ5gCIZIPJnRH5EiYAL6o0JpVY5sJP2203MS16uXxgntyeSjhO
	 CrpW/y8FMYvXDJGEfc//jGI0C6HiQPKpCTiP/rRmBI3+LfnUz17w5LFwkYMiuTc4386NZ
	 AKsVRGt0M0zRutdE6nYsG205AB2zn2ErKWAWKt6MQA9lOjtKUqwYqO2RYcKoYOWgCCgL7
	 LEZzO9U2pkKHHcRSGSQbLQIRDXYYzKAGPbKqIl9z+G4gg4l+6d+4m8sw8XZyBKWdVpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=qyz7ht9t;
	arc=none smtp.remote-ip=209.85.215.182
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AC56606A323
	for <linux-sctp@vger.kernel.org>; Tue, 17 Nov 2026 11:05:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1AC56606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=qyz7ht9t
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-cdadf7e248aso1804315a12.3
        for <linux-sctp@vger.kernel.org>; Tue, 17 Nov 2026 03:05:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794913509; x=1795518309; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=APyRDGNpX/sOhc1G62vzvyzvnEtlXJLA4HeAQhpE9p8=;
        b=qyz7ht9t1Yr/kkTxUvTrvKjQmhfUVmM3Npvv2fDSDEHea4DimUkYStpl8EIxByS3sX
         iw2+XR+u5YS5o8ISS3TdRXoogjcXqv3pwO1rhrT2fLHEkcewe23LZMPKmqTeNbrnN7eO
         9TyzzvmZUu2BNgcQPELIGJtRWYP8r/CBNm1Mal/5QaEJq9bl3TRTwbDq12hHAyIBGiEd
         m4sO3CXjpfwpjxWnF/iXgn53LIfRV3i73ZJDZg3BP801DAHxcdqyg1R3vNK+pqg7PuHu
         M3LnZH3inAsfLqKmz64Dy4y5m6EHdIdzh4fRVemJsN2nR22ALuy6wyXjgd6gKrZvKBGK
         VR6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794913509; x=1795518309;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=APyRDGNpX/sOhc1G62vzvyzvnEtlXJLA4HeAQhpE9p8=;
        b=MOt3JnAfXvdM8S0lH3zNv2SD9op7Zp+8R/rkOq2XfH0TCFoIH5S1whbwl9QRpueBB9
         l4Zm0RmwDsc4r+Bj+Sy6BFVWOnxeNpbGgcs8/sGlZwo3OjPSUOrb0tT38twOiBcrlKur
         BMCOe6uzZD6Sq/V+fFC8Ygibi8mZ5eBAC8twIg2PigGHjjxhHAgLmG0esrrE40JUAhmD
         IARmgaJIlhos5aG9l4kuEvqu8KQBem+fr65Z6kx9ET0JyAje4shMxVt1wo4CqyLXkDqL
         Wq/umIB2JPju3XYVVBSGznOD4RvG+h/O/l3cLf33XI2CzP1/495hfXQq+jR92Q5DRMpj
         IiNw==
X-Forwarded-Encrypted: i=1; AL+hErH91Dv4y/pq5DiOH8NfkS1Tf3bevmQB6lQu4ku/kOzN9NdHXMczeZX0WOZ3BZV5QcKNsL6n3G/8A639@vger.kernel.org
X-Gm-Message-State: APuU4Z91IszG0Zxa3sAvFa+ZD1ntyStGP42LreJreO0BgaX+cNb4ysNt
	EAO71cY+tT6d4KyrA0hbla1Rg2crvmIuvoUNdJPIMNbCgzk0XotxnzK+
X-Gm-Gg: AZFdTZeZSHvzmxkuVewTcCkdWSbfLwWoSTzeo1ggfHb1GHOZccR0Qw8OeGq7je6uP1c
	dYjVuABNgtcWBmsKwAUY+KOYvKP5C7aVZvpx0Gsb2uimdFdC+ieiji7wiEl/PokxWfbH7LScx2C
	DL6Zm0cep1Pb54nISmfxMls5QgBiq+++Bpw7q8vju8LIqm6nZJ7jX1+slH5fae/wvPc3G5vAM6S
	a7oAkXn0kyQ3fhvFC8wehLU0PaSzh8o4KTf4oAfoOEwW3cFeMVEMMCpD8lUfM0fP9rhCS+gH0nJ
	5IK3mNYivLQpKWnLdz/4z7OOyJGLKyg4wF6PqXPtdlzr1bpXbQ1i/16Y50CfKzOhKmaYNjLYpSv
	McX+Tw5ZhdTHxDpDTz38/3sQg65BJNWPscwBqOSk+9/+0mYDh0SzNUV/GKUxHKOObyZUTI/oUbs
	oGEyT5csps4SJSNlQdis3XketeBXcPRA7IB2gSG4ny90A58P+EE6AW755X8hMlDLCQ4gwZ5/nf8
	BwVSwS4EBDp8cphhiJ4pG3YcLon+hxn+JWKlPyIui2hMbpgaug9uoQulv1g3RTEbvaewuAD5hOO
	iu0uz1yIjwZqghz168NrWsyPQWzApT5RG/a3lbFTLx4OqHHVlEM3X9ZzfJK/TNVYepqpvDapUXR
	/t36zjniwO+4RKw==
X-Received: by 2002:a17:90a:e710:b0:3a8:92a3:8baa with SMTP id 98e67ed59e1d1-3b1b0a428b8mr11460826a91.27.1794913509232;
        Tue, 17 Nov 2026 03:05:09 -0800 (PST)
Received: from JUNVYYANG-MC1.tencent.com ([43.132.141.20])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cddc1898afbsm5633083a12.19.2026.11.17.03.05.06
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 17 Nov 2026 03:05:08 -0800 (PST)
From: Jun Yang <juny24602@gmail.com>
To: lucien.xin@gmail.com,
	marcelo.leitner@gmail.com
Cc: davem@davemloft.net,
	edumazet@kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	linux-sctp@vger.kernel.org,
	netdev@vger.kernel.org,
	junvyyang@tencent.com,
	corvus@tencent.com,
	stable@kernel.org,
	Jun Yang <juny24602@gmail.com>
Subject: [PATCH net v2] sctp: preserve stream scheduler across outq teardown
Date: Tue, 17 Nov 2026 19:04:49 +0800
Message-ID: <20261117110459.44083-1-juny24602@gmail.com>
X-Mailer: git-send-email 2.54.0
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

From: Jun Yang <junvyyang@tencent.com>

sctp_outq_init() clears the installed scheduler when it reinitializes
an outqueue after teardown. The streams still have scheduler-specific
state that the old scheduler needs to release if the scheduler changes.

Initialize the queue counters and flags individually so that
sctp_sched_set_sched() can use the installed scheduler. A new
association is zero-allocated and starts with the socket's default
scheduler as before.

When the socket default matches the installed scheduler, streams retain
their PRIO priorities and WFQ weights. FC and WFQ also retain fc_length,
including bytes charged for purged chunks. Those chunks were queued on
the stream and the accounting converges as new data flows.

Fixes: 5bbbbe32a431 ("sctp: introduce stream scheduler foundations")
Cc: stable@kernel.org
Reported-by: TencentOS Corvus AI <corvus@tencent.com>
Link: https://lore.kernel.org/r/20261104105507.62743-1-juny24602@gmail.com
Signed-off-by: Jun Yang <junvyyang@tencent.com>
---
v2:
  - Initialize the five queue counters and flags individually, as Xin
    Long suggested.
  - Document the per-stream settings and fc_length accounting retained
    when the scheduler stays the same.
v1: https://lore.kernel.org/netdev/20261104105507.62743-1-juny24602@gmail.com/

 net/sctp/outqueue.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index e92fb9da4647..3dafa6e6cab3 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -190,9 +190,12 @@ static inline int sctp_cacc_skip(struct sctp_transport *primary,
  */
 void sctp_outq_init(struct sctp_association *asoc, struct sctp_outq *q)
 {
-	memset(q, 0, sizeof(struct sctp_outq));
-
 	q->asoc = asoc;
+	q->out_qlen = 0;
+	q->error = 0;
+	q->outstanding_bytes = 0;
+	q->fast_rtx = 0;
+	q->cork = 0;
 	INIT_LIST_HEAD(&q->out_chunk_list);
 	INIT_LIST_HEAD(&q->control_chunk_list);
 	INIT_LIST_HEAD(&q->retransmit);

base-commit: a2239d5dbbda3a61b6323df8836f605921a29f7f

