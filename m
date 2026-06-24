Received: from mail-yx1-f44.google.com (mail-yx1-f44.google.com [74.125.224.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C53B3998A4
	for <linux-sctp@vger.kernel.org>; Wed, 24 Jun 2026 12:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782303752; cv=none; b=rNtpxf0m4/VrSGc03KnYOMe4L90622m3y6CVnVuDQ8ocrLXK4gqyRI+QY7zNhgFPlOjVQ1cyYl5KUwPUFhmqaoxOJMAWFipT6vyFqD2RqC73yVu8qHB9YrDtEgLtrZpQNbQH16fXY9zftsy+g0hDEJ1P7zPouEGPJen5doy+Tv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782303752; c=relaxed/simple;
	bh=FnG9zHq+2xxL21OVE0ldGOEIqmMpwP6fHAL5vebTYj4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PF7IIqFApfJqZbBchU5+xDdZg9F+mqDaFIiosQXOwukdIFlFY+Z/RkfoD0Plc2+GE+am1l8Ek+/xErfFoex+fCbt+I5stTmQFOq6dhD6gr7j1a2xJL/Pe6ALbBDVMVS99UOXoO1KeU03Sraf4pDO/nBdH7RDtgs58R/8hyW/OTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ll3pdBFM; arc=none smtp.client-ip=74.125.224.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ll3pdBFM"
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-662ccb916c5so862404d50.1
        for <linux-sctp@vger.kernel.org>; Wed, 24 Jun 2026 05:22:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782303750; x=1782908550; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=c3hCWf81IkIHy8M4N5mPkeK3GOsJg4h+ZHQGj103FE4=;
        b=Ll3pdBFMWhKGBRZbzPTY8hdN5DvvY3EGY9o6W3Hp7MvZce70I5py899BshXy0LTTuj
         ma0kKCpEFlrJ4VQCpXtlG7grbC2wNcc+725u31pA7XuMu73m6j+rtJb+lPxF2T0DVU9O
         NkrMn3Po7ifwemlg7ehQ+/mWStRNPeQdKoTqtOnp09XCwH7p+DLoB/0KD+cUxkXbSBAZ
         3mvdc05VRBXT8DikGnWJew4d1l8kXeEB4Ta+ZIfv3ARrgVMGVJY1Bw46gAARk9tE9yr8
         OpNeD1mcXmndjdkBXjKqyvBzNwL2ZDdN1DFPzr52Ag4Hefw9jGLE9YaYDu+auXY1Eikz
         l7gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782303750; x=1782908550;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c3hCWf81IkIHy8M4N5mPkeK3GOsJg4h+ZHQGj103FE4=;
        b=gI6AHfihhatjKPlb8KIsqP3sS47iwi6P/a33Wg/0mfLMJ4ODzFUEhLb/pKxAws13UZ
         k2ilQDDDSj/9q/oUkPqYG33t1TrNj75x6IsQDlogUQC+B6t9Vs7Wf/CaaFgHnJG202A7
         8u2tFbOcNopTgV7fUZUusNP1MBBzk6qK/qARGe8zQpIdA9fUIQ/HcwD6kmukSA1Wn+Vv
         lQtzjCo+gg+CbUSCawh6R0xw6zDwyg/Hx/ltHvahyBWvIm0BYSrEGrG23XJ4BpPjmoA6
         yWnKUjJPt8+G7s6BWYk2LIxRpKmZbMA0KmazW3b8U+Bm4bQC0gvgNcijR7jTUpQeFn/l
         SeTg==
X-Forwarded-Encrypted: i=1; AHgh+RqK5q2RLCuRf5tn5AQhU7IRpAhrt3S1pkOWml8KY3fNvBZFCFYxTGnAmEO+muaGYYQwIFF7f6c80RP1@vger.kernel.org
X-Gm-Message-State: AOJu0YwbDn2VUMRmpI28cHUHTzSGeLku5eum1P0DR7IEs9CttZPNVcrd
	yFbhQH8/UpVcBj3NzC40q0/V6O1TJFP+ohNqN5Pk9Lh1q8z+EWjzkliV
X-Gm-Gg: AfdE7ckJQmXhMps4Y8KyVzxagAA84Jal5pzPU+HJbIBLaq0hR0HfBKtQFHSwsg4xyJ2
	w6+EZbEMM3kqsZ4yQrl3flaGDS+jnJaBMB99Zl6F9hrqfIX892jgXpC2tF0SvGU9vaaNQXvQxD9
	jOX5kysGjbyW7R9FkX/pJGiybDOmTZoDiHwpilvM456F9MlQDp5dOFlYgolA0bO30QXS/MDMTS5
	OGa2T+Lq+htEXOmnZnqlxjcM2JojbHwL5z/J75mreRCapyoxI3BPZtQ9Gw2SD/qHeFdguDcTFWi
	CU677ThrKv+Lidky+cj37zsVCOJj4XbExql0/OdvhfomRa2zW6YwnCGr+bO54SQk3hDf/pA2lta
	j/o0/lPPbj0J8ZFa8km0r6yCgDztWWDIgtJpgUwTbeNIlZ6LIN3Kr1ckFUtyx44LO1mJFCD38iF
	cjxHss1WSKuXLI6RQIxwjMF+7kPUcTg/HWegAI
X-Received: by 2002:a05:690e:120d:b0:661:1307:3d62 with SMTP id 956f58d0204a3-6636e61116cmr2426807d50.52.1782303749893;
        Wed, 24 Jun 2026 05:22:29 -0700 (PDT)
Received: from Dev-Null-MSI ([2a0d:3344:52ac:a808:98a4:4381:be45:536f])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-66314d444c7sm6614118d50.13.2026.06.24.05.22.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 05:22:29 -0700 (PDT)
From: Yousef Alhouseen <alhouseenyousef@gmail.com>
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Xin Long <lucien.xin@gmail.com>
Cc: "David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	linux-sctp@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yousef Alhouseen <alhouseenyousef@gmail.com>
Subject: [PATCH net] sctp: fix SCTP_RESET_STREAMS stream list length limit
Date: Wed, 24 Jun 2026 14:22:13 +0200
Message-ID: <20260624122213.4052-1-alhouseenyousef@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

SCTP_RESET_STREAMS carries a flexible array of u16 stream IDs, but the
optlen clamps treat USHRT_MAX as a byte count and then multiply
sizeof(__u16) by the fixed header size.

That caps the copied and validated option buffer at about 64 KiB, which
rejects valid requests containing more than about half of the u16 stream
ID range.

Use struct_size_t() for the maximum struct sctp_reset_streams layout
instead, so the bound matches the flexible array described by
srs_number_streams.

Signed-off-by: Yousef Alhouseen <alhouseenyousef@gmail.com>
---
 net/sctp/socket.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 66e12fb0c..b8f13044a 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4111,8 +4111,9 @@ static int sctp_setsockopt_reset_streams(struct sock *sk,
 	if (optlen < sizeof(*params))
 		return -EINVAL;
 	/* srs_number_streams is u16, so optlen can't be bigger than this. */
-	optlen = min_t(unsigned int, optlen, USHRT_MAX +
-					     sizeof(__u16) * sizeof(*params));
+	optlen = min_t(unsigned int, optlen,
+		       struct_size_t(struct sctp_reset_streams, srs_stream_list,
+				     USHRT_MAX));
 
 	if (params->srs_number_streams * sizeof(__u16) >
 	    optlen - sizeof(*params))
@@ -4598,8 +4599,8 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 	if (optlen > 0) {
 		/* Trim it to the biggest size sctp sockopt may need if necessary */
 		optlen = min_t(unsigned int, optlen,
-			       PAGE_ALIGN(USHRT_MAX +
-					  sizeof(__u16) * sizeof(struct sctp_reset_streams)));
+			       PAGE_ALIGN(struct_size_t(struct sctp_reset_streams,
+							srs_stream_list, USHRT_MAX)));
 		kopt = memdup_sockptr(optval, optlen);
 		if (IS_ERR(kopt))
 			return PTR_ERR(kopt);
-- 
2.54.0

