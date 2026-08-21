Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE11A45A288
	for <linux-sctp@vger.kernel.org>; Fri, 21 Aug 2026 09:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787303693; cv=none; b=t5uae90U76Xt6fnDDi0CiPLFGX7GXa8TYKB/XoKM6Bc5HTTpAd8mh71igH/aefFmbMsUR10ipYQyA0YzX+lenzFxoRXY56/SZWnWWYSGP5whPqhI255v9C9e6hL7FB/BBN/hD+vDiPc/0RIxdoe15nbZFFl4Fz4vvYX1B301fHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787303693; c=relaxed/simple;
	bh=6Fvdwpxft8AoHYq1aha5MR5WZhcRsv0eeaJ35BUbncY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KU8Wfv2wR8Zy58MF4S06dAvilH6c2xeVRHZweJ6XJOKRoVLP3BIiu2n+6g+8fGvjZKeU51W8Wa9AitKr9Dmpq+EMQVJqjR2k5JMIo4EG22mNv1+TT3PZ+EkyDThJoA1D2d4o/fhWtW3I27NzwTfH1742+9k15XxODCyjEM0mo54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JaYn+gBM; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JaYn+gBM"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2cedda2ce6fso4590985ad.1
        for <linux-sctp@vger.kernel.org>; Fri, 21 Aug 2026 02:14:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787303687; x=1787908487; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=0GeuHunERBfxvzXCv5bOEDXvdATeClpDwiKOKDbZsOk=;
        b=JaYn+gBMCiJ3W4iB3p2jg25zmAfPlTV0cBtuLQTOrPsR3sxkdU8zzdm07N/pI0D0f1
         JznZwOe7WB5RnbmQATiBgbx4glIeISypUQEBxtg9T1Jga3LvN4jR09iNI5hv1jn4/iE2
         1beO6JeuZaPzGPeAbh8em2+1vktbm+Su0d4Ddv/MUxzvXhE0hivL79OJyn77HDCWp0T7
         LMCxBsOOHqyW5bpIVNz0AH8/BvfUI7QOgwoNExwYgPPRgzzXMeszd6llhB6HORxDhDPe
         5SAvZshFag+tSSrET7+muxXECbkkDeBQOaYDBkzFftuEjz1NdXb+b9XPs9lKFjr/bD3d
         43Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787303687; x=1787908487;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0GeuHunERBfxvzXCv5bOEDXvdATeClpDwiKOKDbZsOk=;
        b=XuR+Mb52yWXuoag0DGflzj8LOidlCAHwue3MU9XLOULtyePJRbpJ8Ro5U7/vUg5CXw
         ZGViEEtrMedZBROVYVTXNsIIsuHva/bEOosKEUpT7Hhi+sby7jEGqQSjMbfPvCdiRWz3
         ANbrKBmJjQb3mTpv2RJbmY6gXFPdffpAkOzjFyMqNmnokBfiByWGd8S5rGyiUj8mGCGJ
         9HmpQuau5AYIbq6pgieGVZvOkUBV/VLPexqPs8GLJiXG0HYydD23L0f/WeceZYpl67t4
         wAuAi+sEyqtIXudLiWoVpausPY60dNdlAIOqNWdD2ps9hMtYtWM2DEVwOwu010VBAW38
         9UAg==
X-Gm-Message-State: AFuF++nt4z24HM9W+k3CrZrDypcWrGygPk6//P9+oZ38usYwICc7fSiG
	jVCeQH9vx+BhgoiUX0LJwsYUH5Ay0lSxb3xN3A9v27fN2oaX+QrNwMrua6xVk/NgFfc=
X-Gm-Gg: AR+sD13dEkklMCeldS6HWg/hWcEMXRUrk4YfKUbidR/taF0bmJWDtkhnRcAgB4yJ92s
	2VlTGWVG7Imvmn/AyIV01W/YxiLj2f4SDJ3dUFhx/DQYre11WZ/l0JubIzQYNwIksi7X/9/O/GY
	OFS335PV/AlYK6G3GHBiLrb+SkvL16gVmFCXzfzWwtJvjL9tfwE+sI10IVch5eOR2V+619kHOLG
	V4hZLUfZqk6qAdrBAE5SU/SZvu5KbLnboa8Bbnb8ynNZmd+u2P9kkvKWEhK3Ay9HVx5ait514zZ
	7C6E2hDKtDo6HIp2zMjSih/BAnTAgh+TMbcCiUTic+q07t8TqBoRp7iHzbH6Andiq1uY8RWuBrh
	YeYQz9vJhmmyXUITbCJyRk8tJVdjsVWoEMtMWcEK6y85/VIjDyMr/PUHbBwntCpE6Ocx57FI9Pn
	hcNXqqoEKRm3m6UmF7mFbX4gveGMtvdOCUG5A1vmcwNOqFWM/0oruP9lgB70BHO6EUo4gtJzyL3
	yq/3MVqHknJOQXO7jg0uk/ljIcJEQ==
X-Received: by 2002:a17:903:1a28:b0:2d0:401c:2ebb with SMTP id d9443c01a7336-2d64adc3f0amr104460525ad.4.1787303686407;
        Fri, 21 Aug 2026 02:14:46 -0700 (PDT)
Received: from JUNVYYANG-MC1.tencent.com ([43.132.141.21])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d62e3cf1e3sm16141265ad.72.2026.08.21.02.14.44
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 21 Aug 2026 02:14:46 -0700 (PDT)
From: Jun Yang <juny24602@gmail.com>
X-Google-Original-From: Jun Yang <junvyyang@tencent.com>
To: linux-sctp@vger.kernel.org,
	netdev@vger.kernel.org
Cc: marcelo.leitner@gmail.com,
	lucien.xin@gmail.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	Jun Yang <junvyyang@tencent.com>
Subject: [PATCH net v3 0/2] sctp: handle wrapped and duplicate RECONF responses
Date: Fri, 21 Aug 2026 17:14:37 +0800
Message-ID: <20260821091440.6496-1-junvyyang@tencent.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix response sequence zero lookup first, then make RECONF response
handling idempotent with an outstanding-request bitmask.

Jun Yang (2):
  sctp: distinguish sequence zero from wildcard in reconf lookup
  sctp: fix stream->outcnt underflow on duplicate RECONF responses

 include/net/sctp/structs.h |  2 +-
 net/sctp/stream.c          | 46 ++++++++++++++++++++++++++------------
 2 files changed, 33 insertions(+), 15 deletions(-)

---
Changes since v2:
 - Split the sequence-zero lookup fix into patch 1 as requested.

v2: https://lore.kernel.org/netdev/20260804113100.37840-1-juny24602@gmail.com/
--
2.55.0

