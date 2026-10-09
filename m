Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D54846D09B
	for <linux-sctp@vger.kernel.org>; Fri,  9 Oct 2026 07:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791531790; cv=none; b=ktmN7DBTBUExAGvCvdycpL0jMY7DkylLCwmE9eAADGvz9i62sAMR3XDZodv9itQ2N3UK94zKXOvABQ+8+XAaMp1ToFbHMgLRmFXblm6vfA4pjBwMsmC5jV8KauRg9mht3rsTkkNNTX1Deq63w+5wHR0/l0MkJD56llmZmcobm3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791531790; c=relaxed/simple;
	bh=tTYCiu56WjZLaEUZm84YXG5kgInp20xIQBrWMS7xesA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jVsW8i0HgDD6JgyMoe5exCsd9wMzbfi9Y0mStUP2QLTjd5hc573+nnvpbbFi0gGj9sZZO5JkbrlKVDpiZj3r4cXGnGJ3xbhohPiRiBDnCDGJSCh1dQDo6V88/3cbwxP0HuTYs4WiH0YMejk+ZX4jrM/RgErebJ2yzW9F+u++L4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Hi5RMqC+; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Hi5RMqC+"
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-cc52c1b8286so977374a12.1
        for <linux-sctp@vger.kernel.org>; Fri, 09 Oct 2026 00:43:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791531787; x=1792136587; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=lwKfuoeQ35NUGbMAfIq/wI54O4pLFX7q37/ntcKq2NQ=;
        b=Hi5RMqC+YhUcgDtBBykgvCC5iAk45YKIiH28waYItnmuBPTdE9x4W7AXlc+q7XTrzE
         1RQE8KsueGEnSYzcwvNeahx97CBQaWHH2aQmuGLJ0FVMTD2zD7htwq96CAg4kaWNEBXb
         9z82WJ0Miv6d1PkfF/Ig7OdBkjieVQFyRuu8YJxJ2IbqkW61kjht4WYNFhUudxbtOtqI
         8hCXrx4kahnSdh4b+0d96iqpQjTiTUuekDKBoS/m76KLnSo/gAYHudHZKN8uWy/jD3my
         j1cDUldnSJ7LHUJKnHPGkKV5UkKD1jMMQU4Of7ZEnf3wj9RR2mMZZV8uXDTio5vc6ZaW
         VUUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791531787; x=1792136587;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lwKfuoeQ35NUGbMAfIq/wI54O4pLFX7q37/ntcKq2NQ=;
        b=aquJpjEPiu58khg9WQPJ7MSMf+B3sQvjGWXUon/6ol8bQuUVDTl2QcMfv9X7bpWBi0
         nXSSw/NHyvh34lgI/9W17lGARp79SOEif1gCqzFTbbIFLdgT8Y/56nrCRUQArMTE94yU
         i35ZrnUurWkTWKVrE2LJ0TE562KX2d6uzkcTnSvewB0bEi6lSHvhhmHeKrcEp218eEuK
         +7F0b92thiCkSQq6Egxj5X62VSxzyzqqjMEuIr9bDAaK/28xsUcdXorK9fDLxRwwOBiu
         5CdN9lUXPJcKof81edQDhmZni3luFFEAgVv7Svz1hRuIKuCM6bs8vGyl4QQCxN+t2mDT
         MT3g==
X-Forwarded-Encrypted: i=1; AKwUvBwPjD/QfteR3nM8Vc8YvFRtOtqhZWwoxGOSBox7OkWHPff2kH5zARiLUU0k2uaikke71z7JZilqhJgU@vger.kernel.org
X-Gm-Message-State: AFq9FYLg7CMacYEpV7yAHFCjC44JAfkKfbEIrHOggqTmlraMVni0uI+m
	VWrrG/mu9+0fN0MayhWUEwkO03Uq2BgaEhi0MtRZVhJwWTn4n+BEX9Ey
X-Gm-Gg: AYBFou2eNN80K51yj07uRH04rrfu0z9+QGiY6W8srZpIP2bDmpgVyGLRVgTcYBh8lqM
	LvTiPFtxr5h5dtVn3llwqsbI5fgHOEHxWHABkrXTqJv/wdkhgUR11PMO31nWjEaOqRjn3XGlQ7s
	JGIsJXjhLg0fkZKhpPow1R94wja5MrhYZjsRiCwKTYthCqH3ArL09+mmQFo+RkITM7J3j1411Nz
	E5NMtk31i4fvvVc6LkQgeNAQBVy5zIZjcFGigzUykzwMEyFblHskkPvrVb8MlXLlgIBlF7G1yCA
	mQrk+uIudQG31ovrsY/G3biU3beMnGRgZOp9HXCdg1z16htRqqRJ8kbCBqOlHUGJv/LnX+wyMeB
	GKSs6lT11MrGfSSuonu/QulkWUcQZllCyHwUVOqWI7M5pFgN+E54YgjZWRllTEu7fl8f5plkvzJ
	nJZnzzSPMEoO2YAY/ocvR2/4XL8sFtHgdD00dL7i1Sb/W5jC71aDxQ5/oPv9d4SCSqTT+oq2ZZM
	nHJf5iOGupdx/wxUqJP31py5fBFV3afHu6vVLO/5r57sA==
X-Received: by 2002:a17:90b:4f43:b0:3a4:ee64:f492 with SMTP id 98e67ed59e1d1-3ab3ac8f4admr686219a91.33.1791531787321;
        Fri, 09 Oct 2026 00:43:07 -0700 (PDT)
Received: from JUNVYYANG-MC1.tencent.com ([43.132.141.21])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab38ddac6dsm2124986a91.7.2026.10.09.00.43.04
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 09 Oct 2026 00:43:06 -0700 (PDT)
From: Jun Yang <juny24602@gmail.com>
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Xin Long <lucien.xin@gmail.com>
Cc: "David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	linux-sctp@vger.kernel.org,
	netdev@vger.kernel.org,
	David Lee <david.lee@trailofbits.com>,
	Kyle Zeng <kylebot@openai.com>
Subject: [PATCH net v4 0/2] sctp: re-point retained control chunks on association migration
Date: Fri,  9 Oct 2026 15:42:30 +0800
Message-ID: <20261009074244.3718-1-juny24602@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series fixes ownership of retained SCTP control chunks during socket
migration. Patch 1 carries David Lee's shared-key prerequisite.

Changes since v3 [1], following Xin Long's review:
 - Add David Lee's and the forwarding submitter's sign-offs to patch 1.
 - Restore sctp_process_tx_chunk() to skip duplicate visits.
 - Preserve a control chunk's existing shared key across migration.

[1] https://lore.kernel.org/netdev/20260926100359.78731-1-juny24602@gmail.com/

David Lee (1):
  sctp: hold shkey across socket migration

Jun Yang (1):
  sctp: re-point retained control chunks on association migration

 include/net/sctp/sm.h    |  1 +
 net/sctp/sm_make_chunk.c |  5 +++--
 net/sctp/socket.c        | 57 +++++++++++++++++++++++++++++++++++++++---------
 3 files changed, 51 insertions(+), 12 deletions(-)

base-commit: a7bfaba4823e3c165bb2004c74eff7c096672bc7
