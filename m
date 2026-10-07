Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CF12479885
	for <linux-sctp@vger.kernel.org>; Wed,  7 Oct 2026 09:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791366698; cv=none; b=cpuIUISZwOVkjixoL1gjy3iND+74/2HDINwwl3z3mDLi1z2XLaepyfNTq5q4PFgDHHkLrq4Z8v0BbG3KLajq4N+Xcet2ztop4BFH/Qrs3DpAFU0IXvL4uD/BYC5x4n82yvk7cz9O/7r7R4hhXVAB7HdfS+bF/WCP/GiUIm+uVqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791366698; c=relaxed/simple;
	bh=/Sq51opT+pCTWy3QNnNI3fXGhVvRT9I3pfHWyC7IIJU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aRJfMhdODavWdyZfIhFAykIvunpbOmubYGv7MWuNvaxTSJkZbjGmuMnlgDQvJXR7In7qx3Dq1zKViczxke9ZGwGnYwfj6rr7KjC59l3Qvq/KEPhz30AFOide6qs38IiODB1/H47iGOgzWRSThrzvVgAQEYLjAPHstMpDG4lbLdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NqJsciZg; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NqJsciZg"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-39647aa9d52so1545620a91.0
        for <linux-sctp@vger.kernel.org>; Wed, 07 Oct 2026 02:51:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791366689; x=1791971489; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=81iw+VezXIuwKODbfw1IR0OLhT5NZkd1eLLqyo8b2hE=;
        b=NqJsciZgmLq+N1DiaW8aEiNqTHuKdZnaUBcZLsxg3hj6Kr/uVMhLrvLgMXjDUAdzxh
         YCRqp8ZuTFim6GwArsPO44cdsy7VC98kF5rqQ1WvQxoRyNbFYQ4HFx3B2zDBWgbhEAE6
         571kUVrpQs7qhy7qeGRhzf2M+8mr0bQdeoOZuRKtqEy8WuTGUgypJ5DLGEMclmhaB62Z
         PmCItA4dwM2KaEBRggNTRexWxSrw8XOTqXHpqxgxeO6TjugZrnwjoQnAuloMEl/Xyz7C
         56AKWrl1NdYFEZZ3Vo6oaLeuL45TFoRaCo95De25XiaARApfvbMRQ4HG4T3CmhaJu9x/
         73fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791366689; x=1791971489;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=81iw+VezXIuwKODbfw1IR0OLhT5NZkd1eLLqyo8b2hE=;
        b=WAysz17ANmTPLAS6nziCcYY9f3BR60GY4nmIfdHZS1cnOrTd1Y8zxlWT8lg8pT+450
         xZZ6o4pUedy20o4i+y3k3m2DjYhLsMfMxpEAhFd3lpTOPkuWj+YeEmZCVsYviFXNgIw4
         Dm7YXzjCNU8gHzft8f4dqsX3FXKgB/Km+BXNdnmSAjhtoSrvCK/9/J8bBsV/Jt8h/fTV
         TEuuuza3Oi39x+CRyTbDoy8z9uIEuTTCCh9gMLLz2altARxOFWpD7TdBPSkVCl7GfefV
         bU+ND0zu5YgvNpJLoDp9xb+h3ahMj70Lfzk9sxCH/MT8UtNC3/ozIwAzUyF7BJ6fHUvO
         QTlA==
X-Forwarded-Encrypted: i=1; AKwUvBwX8cl+laoLvQEGeVaByvG6qH1medTVqBTbsCD42fg8PyYUDDOqpGrx64/oPeIg6dPPshhjso8cjYw+@vger.kernel.org
X-Gm-Message-State: AFq9FYI3dYzBTmMazHd8S9209aQIVhnEBb2y6yHJ2h9B3glycVJZhDA0
	uVM9TLeBNDkoVYEBA6zs1bkJyccy9yEtpP7IXnVo5ABNnGkTZVarbJLy
X-Gm-Gg: AYBFou2GFoAgkKAlqDiNKWxqTuNo7ecph7+JVRxYHMUci2b9k9bwokm7zt6S5LKh7bt
	Nmj1OwiggBej88ULX+HXd6Z4d9dUDHo/V/yUWuBfQSZTiIArG05BprjBYOwltFEeJmXzTRMsC2i
	LieGx3f2Q0EHgAFookMOggAf3MyjxsCHQMakdfwob8KoyP9X+QsGbXUfRHvt+NGxo9jhd3oh5vH
	V+Zw7S7bUc/tYuarJ1Z6zoiCSFK21T6taLv/qammr9rbMsL4BlmQpAlcFJZhdrODoopKEIdEi3z
	EoMHyAngbYa0pWboPdUw61rAnLOgR4CY+0HTPyOKSRQ5fdgdYhvg63BwaACDkEH57bbYSKBjiuC
	Ei9Gi+wavM+6CLr1zL3U3I+fHvB/hc37tkyfYTQKyFfZhBvkdvBqc7sQR2KVDSHbeC9LJhAOc59
	tiKwtCDuci4AcUrF701qBk2oKxJMih5wokWttBqQo4fxhi0rOP/OQC5Ue3geHdpjipUmovjIA89
	vfx/UqtcCRTy5U6eD4F5pAqRCUmOaccroDV4Qn7GWtF0qsekaL6mqSMGfERbFE2l0obaUvIQ2mb
	r6McPJCKamA=
X-Received: by 2002:a17:90b:4f87:b0:3a0:e985:9ca2 with SMTP id 98e67ed59e1d1-3a8a13bdd81mr815434a91.31.1791366689543;
        Wed, 07 Oct 2026 02:51:29 -0700 (PDT)
Received: from phui-2.c.googlers.com.com (25.187.82.34.bc.googleusercontent.com. [34.82.187.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a8a4a173e9sm1090228a91.3.2026.10.07.02.51.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2026 02:51:29 -0700 (PDT)
From: Hui Peng <benquike@gmail.com>
To: "David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Xin Long <lucien.xin@gmail.com>
Cc: Vlad Yasevich <vyasevich@gmail.com>,
	Neil Horman <nhorman@tuxdriver.com>,
	Simon Horman <horms@kernel.org>,
	linux-sctp@vger.kernel.org,
	netdev@vger.kernel.org,
	stable@vger.kernel.org,
	Hui Peng <benquike@gmail.com>
Subject: [PATCH net v3] sctp: copy zeroed stats to user in sctp_getsockopt_pr_streamstatus() when !streamoute
Date: Wed,  7 Oct 2026 09:51:28 +0000
Message-ID: <20261007095128.1370109-1-benquike@gmail.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When an SCTP stream output extension structure (streamoute) has not yet
been allocated, sctp_getsockopt_pr_streamstatus() sets the local stack
variables params.sprstat_abandoned_unsent = 0 and
params.sprstat_abandoned_sent = 0, but then immediately jumps to 'out:',
bypassing copy_to_user(). As a result, when an uninitialized user buffer
is passed to getsockopt(SCTP_PR_STREAM_STATUS), the kernel returns
success (0) without copying the zeroed stats back to user space, leaving
uninitialized data in the user buffer.

Refactor the !streamoute check into an if-else chain so that when
streamoute is NULL, params is zeroed and falls through to copy_to_user(),
copying the zeroed stats to user space and setting retval = 0 once before
returning.

Tested in QEMU against Linux 7.3.0-rc3 using an uninitialized
sctp_prstatus user struct passed to getsockopt(SCTP_PR_STREAM_STATUS) on a
freshly created stream: on the unfixed kernel the user struct contains
uninitialized stack garbage; whereas with this fix applied, getsockopt()
copies zeroed stats into user space and returns 0.

Fixes: f952be79cebd ("sctp: introduce struct sctp_stream_out_ext")
Cc: stable@vger.kernel.org
Reviewed-by: Xin Long <lucien.xin@gmail.com>
Assisted-by: LLM
Signed-off-by: Hui Peng <benquike@gmail.com>
---
Changes in v3:
- Re-target subject tag from [PATCH net-next v2] to [PATCH net v3].
- Fix Fixes: tag SHA to f952be79cebd ("sctp: introduce struct sctp_stream_out_ext")
  as suggested by Simon Horman and Xin Long.

Changes in v2:
- Re-target subject tag to [PATCH net-next v2].
- Remove redundant retval = 0 assignment in !streamoute block and fall
  through to copy_to_user() as suggested by Paolo Abeni and Xin Long.

 net/sctp/socket.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index a2235905d2ee..bc5b78ab589a 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -7568,9 +7568,5 @@ static int sctp_getsockopt_pr_streamstatus(struct sock *sk, int len,
 	if (!streamoute) {
 		params.sprstat_abandoned_unsent = 0;
 		params.sprstat_abandoned_sent = 0;
-		retval = 0;
-		goto out;
-	} else if (policy == SCTP_PR_SCTP_ALL) {
+	} else if (policy == SCTP_PR_SCTP_ALL) {
 		params.sprstat_abandoned_unsent = 0;
 		params.sprstat_abandoned_sent = 0;
-- 
2.47.3
