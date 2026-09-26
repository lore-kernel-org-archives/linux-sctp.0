Received: from mail-pj2-f40.google.com (mail-pj2-f40.google.com [74.125.227.168])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACBDF3BCD3D
	for <linux-sctp@vger.kernel.org>; Sat, 26 Sep 2026 10:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.168
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790417046; cv=none; b=IznJGU0TEFAoUa63b8vohGGKUH8WorPYagqWu8pdYFzoatltWTcCbiT8ilTXeF77G3MZbbK+jtqWXw198nALTp1NqvmfQvDTNK3TDmujBN5IyyOWaCR5WM5oYPvDO8Dlf+PTUfXvWmtakRWCJeWnXZlBhPkbOl2JIQuUAfL5NMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790417046; c=relaxed/simple;
	bh=sjAoSVC5G2dj/0GLKC6sL5Re6fss3PLBE3wRn8okrJw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rKJjBBzes0W6ge31azWnQk3Xi+4apwT3RGL3LARxFFI7VmsGNdBITSAJkejS8SocXRm2rZm0QLMLn8Yv7UB1HJHiJ3IwCU6Z3IalPl+pOgTCJ86s1cnA01RU0LZZpxCrOUBoIJcE2sHSW0MvP/63h6M87t0JZw3t2Z6eNGB89vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gT7k2d+N; arc=none smtp.client-ip=74.125.227.168
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gT7k2d+N"
Received: by mail-pj2-f40.google.com with SMTP id 98e67ed59e1d1-3a0eeda3e03so50948a91.1
        for <linux-sctp@vger.kernel.org>; Sat, 26 Sep 2026 03:04:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790417045; x=1791021845; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=os0qPh4HhL9xA5LMr7rZ5FtS+AFAyE+IXe5pNTCIpTE=;
        b=gT7k2d+Nc8CYPUMwgE7bI655578xIca7RlMEN0OZcdP6dCkLxIqeVFSw3QEhBuoXXI
         xvavBNbjzz90k38dHzEPdOwFD/chwkaL9/SEOpPCVC1wmfh/GXH/rnxVDau5Y7FOxXB0
         ix7kNotZocZNjpIw+v+Rb/VKi25bBb8XN1bTr5oEPXBaqO4HOkdi4/gr1t563THDztbh
         lvUyQqHfXkkDmhMoE/n8ovF5gHh8RSqRKGTGfx1sGe29WWpYgrncvzw4lBoZcbXCdj5L
         8r2INBIWMoHo5TJOiliQ09XZ/7WD3rtTjtKuQBvitNxYMuCpu1dVF1Xc2cgkkdWLSZdV
         97uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790417045; x=1791021845;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=os0qPh4HhL9xA5LMr7rZ5FtS+AFAyE+IXe5pNTCIpTE=;
        b=1soud12zxvSotUnB9MV6NNz7l9a2gYZ37UpbDs215Lv2A+Y/pdSKVHvf/RDqjBFvXx
         n9NqG8pKgqB0Y+6XbsK/v70c8ceq+VOsCJLCLA4fwJbdSCB3EESYXNXejcWrRtrbIbns
         rtR46/X+wHcKuSUWYfEKQgfFPq2DKjMzl+cDMZMoJipjaNO0y2nEmti2MLrW8X1t4lpW
         HkSDDvX9ETYg+EnvFIfKzJr2RAtmpc90amd8mGZFmQYBGqCWiyrSF6u0Y0dh9mPUDr2Y
         D0AgOqhJwiMhW1EvQ/Tn1YxD6TBtNmzjDQx4azkce5Jb0mAyeGjkCHy4EXG8mFSBQNL6
         s8oA==
X-Forwarded-Encrypted: i=1; AKwUvBwHX6DAKnIBIiaUPEKIxXbbSPc52bbiS5MPlF24y4wAoCfv2h9BwqkysmvN7mfEe8I24JM01ihzyJMz@vger.kernel.org
X-Gm-Message-State: AFq9FYK6uMrcW2OF+nwdyv5E8l/xZO7ElnzFznS9DjbzkKWwdkBFq9ng
	x/i5O7uclwgJykju/TmYnukIDOiwrvN067LuguXRLiMsCqSWpIufhKNf
X-Gm-Gg: AYBFou1NJi8j9AH2bnxLKkKoVpA2RYP2VYA29zGunwxVrZ2dzbN0K49DpsOCX8XuLPz
	wEyFEqNmOfVOu48xleCHwB+fWhO8+p9Ihz3joOJCC53xcAWKJQw++hFjq9gWhtbySLEgHxzi1+G
	oAmWJ5SgXXIaS0POSWUH/VRVu8A7YY4FcmOJBPCY5IdtLzPuh7gnGNztBUVK7tVCgY0R963mowh
	NATMf5Hx/2DT3/Mj7eAdV21hWIEOlrFSZFAIvwGQMz3/k+vbPVKeWrWkGLe6hcTocWk1LVuqX+V
	VsOyvmII0O2ezabGKqfm60X7LSS3U4cDchALP7VjWuKS7dPAxrlMuBgDgGjX2eqGGnpuyeAWSWB
	bpeUTRT822N0TWLG5p5koDhuWS6vJyTKOdXOO/vjvunlULHY660OlDz+uVrPGZDitVVVGLJscK2
	tHs0rDkweWF1RA3gNJ2zX/CaW8qaEPN9Vfw4RWTibe1EVrzmwbAb00smbZBvaVqVlXc+TojNbZv
	YmvnoDWqvJecIDjFi0NLyF2vFHw+kF93XnFLBpkX/IBjrc=
X-Received: by 2002:a17:90b:518c:b0:3a0:dbfd:1a1f with SMTP id 98e67ed59e1d1-3a0dbfd269bmr1071394a91.25.1790417044551;
        Sat, 26 Sep 2026 03:04:04 -0700 (PDT)
Received: from JUNVYYANG-MC1.tencent.com ([43.132.141.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0c719f86fsm6730826a91.7.2026.09.26.03.04.02
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 26 Sep 2026 03:04:04 -0700 (PDT)
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
Subject: [PATCH net v3 0/2] sctp: re-point retained control chunks on association migration
Date: Sat, 26 Sep 2026 18:03:56 +0800
Message-ID: <20260926100359.78731-1-juny24602@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Patch 1 includes David Lee's shared-key fix [1] without code changes, so
the control-chunk fix in patch 2 can be applied with its prerequisite.

Since v2 [2], patch 2 calls cb() directly for control chunks, as Xin
suggested, and keeps the existing DATA checks.

[1] https://lore.kernel.org/netdev/20260731120558.558957-1-david.lee@trailofbits.com/
[2] https://lore.kernel.org/netdev/20260804113705.45754-1-juny24602@gmail.com/

David Lee (1):
  sctp: hold shkey across socket migration

Jun Yang (1):
  sctp: re-point retained control chunks on association migration

 include/net/sctp/sm.h    |  1 +
 net/sctp/sm_make_chunk.c |  2 +-
 net/sctp/socket.c        | 41 ++++++++++++++++++++++++++++++++++++-----
 3 files changed, 38 insertions(+), 6 deletions(-)

base-commit: a644f09b2090ad22a13fbcf9d141084f573108ef
