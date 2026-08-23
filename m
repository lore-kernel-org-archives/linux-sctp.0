Received: from mail-oi2-f11.google.com (mail-oi2-f11.google.com [74.125.231.203])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 814053644DE
	for <linux-sctp@vger.kernel.org>; Sun, 23 Aug 2026 13:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.203
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787490321; cv=none; b=F+s9d2bUyEuJh+xPMvfj8uGn9qgF74B6K6vjpt1nvWHhi9W+rlkeOD3JP1kic93nu43V8Ch/wELkyoGUHLz0WNY9ymaV58qpoHMY13DvRZjkOOluGcJkE+PM7sqW6RiEPcxKsO5lJsP48G2OpaXNSqY6cPRt1/8ofjXkjMhlyms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787490321; c=relaxed/simple;
	bh=jQmvTJ/tAAOZBRx6Hwb3Iik13elJGbKOMTtn+JmDyXg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nX+J53VYU3OhHQz8GMsj79pSk6Fyt1t/zH9GySorv1Ho2mfeYLrr2GfG8XUhonYGPiExnxx2XwHUVWlgDWinBCtZ3gf8Ri/7Z5nxzwgFNiSLFE3OiYV/T7HIQi0KABA3ooga5k+A018o4BeTfpUpktzGUeHyChk5JsZuYyJCz+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T2Sp+f2M; arc=none smtp.client-ip=74.125.231.203
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T2Sp+f2M"
Received: by mail-oi2-f11.google.com with SMTP id 46e09a7af769-7e9feadef81so1211802a34.1
        for <linux-sctp@vger.kernel.org>; Sun, 23 Aug 2026 06:05:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787490319; x=1788095119; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=mroXYSbpDLq/pWQ9I/nQbeSIztlLPt22fxJ5q2vkeTA=;
        b=T2Sp+f2M7Qh+dt6lRyDDniNN/EYH/SABS1inYy+eHUY2aTnlWtMPR/XruNaw7JW3kn
         9IVoFy3TgqqSFC5g1PPqP4N7bOKyjcOisedaEeSGFn8AZUPGpcRoHeEytCP4L1UVPhcB
         TkuDOQXM55X71IYo84BIdPB53A5/v+FDhHMfRfT13mxkiqpIeqxqnrmBDkAzJpEfoN9N
         pgLnxqYjMrBii4Af4DeeR9GuliwHB1ythLIbRtz8V9be3UMJIKaDJAh3xpb0rOUgVRcT
         LPJSMpGmPHXE3C52Jt2kVbV92245kmt3I13diL6Fdmi7RNZSptarv7NY7zlWXyBMWgHt
         LDNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787490319; x=1788095119;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mroXYSbpDLq/pWQ9I/nQbeSIztlLPt22fxJ5q2vkeTA=;
        b=YlCBSQHMtZ49IRnaxICj0elCvrBJoiQAS7Cpwg9VkzsZ3014l8k4ekhX5h7Nd+U8y9
         fvKkqXyZA+4qgnkCLGl1bPf9FjVp7inuuhxZuQ3CwLheOWlwqEb2CGVM1Tvhedx6wUiu
         7poZThPR+67AfvVre1HH7JMiZFsqGnYMWKK0O7TP4P2VwYJn8FTZOwedLKfaUhjLtx9F
         y7bUGVz08Yo3BjN7ixU6YNSy4LGO+ng+s5IXPartaaRlx9xIofYs1pQqApLv2maMNVA0
         X+Gsp6of3PhtZ4dAOaeao6WrQcPOFbQya5WuiXUOVRr6khEOyCYKlyq4h0mZkJzPvfSQ
         YhtA==
X-Gm-Message-State: AFuF++lwXcduz/I9WtMIaji9lNtVDG3vS1YS5nIZCmLdwohnjyhPOGmn
	7Q64DF4mEiTvgn9JE63OdyIwgwL82jRhEITaZeuhEkJsW0riSjVY8wtK
X-Gm-Gg: AR+sD13kqWTtQaAg+2Lji10hSxmcjJWY1sq3T+o165+91fn/ZicA5HA/A21wG6TG+Nj
	46sQP3pzICz62z8Q1DKdWTUlWILr2GqaXGvJX2bdLttMSOuqAxlcqFMfYJNrtqV8O1pkO18nlYs
	PYZTE5fZsksYdfHZKu/8wKIgh3vztB693j7Z9P05RTdpaIeyXzkeZYq8hcZzCIB6aaEm+vV9Rod
	9eNUEuXKLFwdYsVklMaGY7N2oXF6yjfR9yzvJgsmO/B6EB2A0/L6tKqJApnxgykYorFtv6kWJEE
	36HlbNs1BhpXB9hcV7K44Qgq2dfM/bTOwgNVSyg3R+701al18lHYCtsGjDmHsviMWu27uEFH9c1
	UAWIk6S8xMvzq9/Zuc3WD2HWMKKOS+2cZ0i07Ov+gEM7gIcF+I+P3fMYtNvmTgs3zrYV9fp4TmW
	EIWh3o3DZempPWKP2JQkb2IgMJTNDsMjUUnQC3KIibmokhZoskddstKctTeKRzf2UNgjCt3GYZl
	wZIHfuwzyEud2HvHXnls6m6yg==
X-Received: by 2002:a4a:edc3:0:b0:6b0:4c0b:4846 with SMTP id 006d021491bc7-6b16b359e13mr10745373eaf.10.1787490319351;
        Sun, 23 Aug 2026 06:05:19 -0700 (PDT)
Received: from localhost.localdomain ([14.22.11.162])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-463831398aesm3423042fac.1.2026.08.23.06.05.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Aug 2026 06:05:17 -0700 (PDT)
From: Henry Martin <bsdhenrymartin@gmail.com>
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Henry Martin <bsdhenrymartin@gmail.com>
Subject: [PATCH net] sctp: fix soft lockup from unpadded ASCONF-ACK parameter iteration
Date: Sun, 23 Aug 2026 21:05:10 +0800
Message-ID: <20260823130510.1341584-1-bsdhenrymartin@gmail.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

sctp_verify_asconf() walks ASCONF-ACK parameters with
sctp_walk_params(), which advances by SCTP_PAD4(length), and its
SCTP_PARAM_ERR_CAUSE case performs no length checks, so an odd-length
parameter passes verification. The consumer sctp_get_asconf_response()
then iterates the same parameters advancing by the raw length, without
padding. A single odd-length parameter desynchronises the two walks and
makes the consumer interpret attacker-controlled bytes at a misaligned
offset.

When those bytes yield a length of zero, the while loop over
asconf_ack_len makes no progress, spinning forever in softirq context,
and the watchdog reports a soft lockup. A remote peer can trigger this
with a crafted ASCONF-ACK on an ADD-IP enabled association with an
outstanding ASCONF (RFC 5061 section 4.1.2 requires the chunk to be
authenticated, but the predefined empty key id 0 allows the peer to
compute the same association HMAC from publicly exchanged parameters,
so the gate does not help).

All reads stay within the received skb, so this is a pure remote
denial of service.

Advance the iterator with the same padding rule as the verifier and
reject zero or truncated lengths to guarantee forward progress.

The issue was found by ZeroHive, a vulnerability hunting agent at
Tencent Yunding Lab.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
---
 net/sctp/sm_make_chunk.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 5a335c980a7a4..0634241fd6649 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -3452,8 +3462,10 @@ static __be16 sctp_get_asconf_response(struct sctp_chunk *asconf_ack,
 		}
 
 		length = ntohs(asconf_ack_param->param_hdr.length);
-		asconf_ack_param = (void *)asconf_ack_param + length;
-		asconf_ack_len -= length;
+		if (length < sizeof(struct sctp_paramhdr))
+			return SCTP_ERROR_INV_PARAM;
+		asconf_ack_param = (void *)asconf_ack_param + SCTP_PAD4(length);
+		asconf_ack_len -= SCTP_PAD4(length);
 	}
 
 	return err_code;
--
2.43.0
