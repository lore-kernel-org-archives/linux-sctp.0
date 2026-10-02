Received: from mail-pj2-f39.google.com (mail-pj2-f39.google.com [74.125.227.167])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8011623D28C
	for <linux-sctp@vger.kernel.org>; Fri,  2 Oct 2026 01:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.167
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790903104; cv=none; b=M96cOsti64gRlI758DwnGlQL8QKEsxXKoiIaX41MoHVW6UrWCQWbovGP0gujwr0yn5nxVeiqq+GDetkP48F4aQxYC4ZQ204Q6G0ggwDTElVlz6pJ6VV86SD3N8sIFPS1yxXSvhypcj/GIPi1I31LbnmFMxP8gGH0EZhc5FkXc7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790903104; c=relaxed/simple;
	bh=70E4JEwJRhITrayTFGxFr/Ka+e6/XGMShGQ5vKZGBZc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IIARMp5vD13G6ISBVj0lKFW6ZI3GnAbT5gQB0mK40lrClMzIwX+ZW8ptoomCgykosYSxowgKQrgObD6I0Edzs8/F0DQWco89RqKMNZYf46Zuc9uGq9SjJvRfljYBbeQre2THmvMd+CQpulrBL5FErRi6IApBMHBd2wqJWVJYMR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Fv/gSVkw; arc=none smtp.client-ip=74.125.227.167
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fv/gSVkw"
Received: by mail-pj2-f39.google.com with SMTP id 98e67ed59e1d1-3a49b6bb21eso2810991a91.3
        for <linux-sctp@vger.kernel.org>; Thu, 01 Oct 2026 18:05:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790903101; x=1791507901; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=cGNX4KL8GRa1VIINdGkPoVIRrpUVCsPABrTMa/jeOp8=;
        b=Fv/gSVkwZLBzjHeKivXsZKpxWt+zzMFQ2md9GZKSnGlD49HEDu738K9QCRd+H2G2Q1
         lz/OV/Lq5EXTpJYM02vxisOfzEIHB0IUNoetE1h75dIuAZNRwN/uYvVkhs+1VN30+Ltg
         we2m7WNHUquY3N6LpHBZP2DSqmTxi246x2W+H+ZKoSlb2taTk0bXfCR3oRFt1gTur22x
         ueRmmbuCAFtwsBq4yNTO76Cw0bwMv7dgX6AEX18F7S339+W1FOvWaLy2DQC6OfCUTZQC
         +r/h+fLNoYz8t2UjRtRg2LdzfgtzdA2c3/E9nZ4/3uDN4THJTBu/9pM0hUxnOdRRbkQa
         XJ5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790903101; x=1791507901;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cGNX4KL8GRa1VIINdGkPoVIRrpUVCsPABrTMa/jeOp8=;
        b=sjgTpXmIKJuSnTj8agGVuzQ4C8vvQRIL3jobXX6rc3t6LkrMtIuxJurfr+ZzzVNlKY
         CSniyzIGuTxcFfbCLKS1iQbbsm1VJ+VXp3rNK7Yh2wv5SdBRu1jwCTwnuWrz+hfj0fDF
         W0OKLkwzarE+hsjE9ACadSQxNH7GDGxleaFfmrVXD6R3MqiR/iq7rJPo3LUTEqPnlpsH
         wvXrlsQjB1qcbip+GmIxdoQo5eJQ41eJYKD217KXh6r6abt80ghAdlquaiA2q+xyBPi7
         vHXaENfmo1NucnsC2pTkgIblaOC7EYzRuX1JTP6MxPoBLyWVsjpp3AIHaX/rgnjssTfB
         EQJQ==
X-Forwarded-Encrypted: i=1; AKwUvBxhE25pah3u5tBcCT7CW2AQbf51yYgYHDPNFGrtAJw/bNH68NW2nMi2HQkHJCpvCJIHs4NQHCfL5X8o@vger.kernel.org
X-Gm-Message-State: AFq9FYL1GO91ohIa8g8OqrPWExhC9lP30Jo5LdAUP32w/KZEuspJ/pTT
	y5pc0HdP5CKzyI+b+SsX5NlBYIqePN6Uphp/75P8sM0mpGFkV0dZAMTH
X-Gm-Gg: AYBFou2TR1bxV22JK27B5IQVgKI4pJWQFEC5Wo1t0ijA4oouW3J0tv9N5N3e92D6Jv4
	tvXjqd8YcvPS+fxbF5JE4bP8hSdcWpIDzwGw1ga5hJnEapLxX/FF/nU882B2JGztkbxf7jTYDRJ
	LlLu5OEbDLSEYTYiGtkL26KaF83bVLrVtt2KY+9PH9A193y+LHvb2XfHEb8te60VQ32uKIwXSpq
	Kwak8qb6Qw/YPv8mpe7AG8PqSSrVgyFQ8jcgvxg+01Sy9WJ8rzkeMNc22iPgGVH31FzgiYeqaqx
	SS1+qbx+Uq45fSMyD3fR+ksiucWtSP+uGEgWYIw/t9FjgbQzkZBC5R8dH2t7jRyPZ8DC/yUpGdm
	ppveh8kvlfMsnXhPTH6nMZSt2bxjScouG4nVCe04L+lQH3985EOxY0QhBZYcmzbJh7m3pxrxOE1
	Qvd/UCqj4Hv0+jGFvXQcbpgYN63FN6CnDMTZ4aPsmfLak22Mldj/9xFgeLxXwQdDI4sQs7GZKYx
	XhNc8MjY+s=
X-Received: by 2002:a17:90b:1e53:b0:3a0:a055:1741 with SMTP id 98e67ed59e1d1-3a6ceaff95dmr666070a91.27.1790903100692;
        Thu, 01 Oct 2026 18:05:00 -0700 (PDT)
Received: from ancienth-X870E-Nova-WiFi ([125.186.72.2])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a6cd44c23esm1587388a91.4.2026.10.01.18.04.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2026 18:05:00 -0700 (PDT)
From: Daehyeon Ko <4ncienth@gmail.com>
To: marcelo.leitner@gmail.com,
	lucien.xin@gmail.com
Cc: davem@davemloft.net,
	edumazet@kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	nhorman@tuxdriver.com,
	linux-sctp@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Daehyeon Ko <4ncienth@gmail.com>
Subject: [PATCH net] sctp: revalidate output stream after association connect wait
Date: Fri,  2 Oct 2026 10:04:49 +0900
Message-ID: <20261002010449.3689454-1-4ncienth@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When message interleaving is enabled, the first send waits for association
establishment before building its data chunks.  The wait drops the socket
lock, and handshake processing can reduce the output stream count to the
peer-advertised inbound stream count.  sctp_stream_init() then frees the
extension of every removed stream.

The sender currently resumes with the stream that it checked before the
wait.  If the peer removed that stream, sctp_outq_tail() later dereferences
its NULL extension.  Fatal-oops policies then panic the host.

KASAN: null-ptr-deref in range [0x38-0x3f]
RIP: sctp_outq_tail+0x49e/0xaa0
Call Trace:
 sctp_primitive_SEND
 sctp_sendmsg_to_asoc
 sctp_sendmsg

Revalidate the output stream after the association connect wait.  Return
EINVAL if it falls outside the negotiated range.  This matches the pre-wait
check.

Fixes: 668c9beb9020 ("sctp: implement assign_number for sctp_stream_interleave")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
---
 net/sctp/socket.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 4652fd90d9a6c..394d31cb698e0 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -1848,6 +1848,11 @@ static int sctp_sendmsg_to_asoc(struct sctp_association *asoc,
 				err = -ESRCH;
 				goto err;
 			}
+			if (unlikely(sinfo->sinfo_stream >=
+				     asoc->stream.outcnt)) {
+				err = -EINVAL;
+				goto err;
+			}
 		} else {
 			wait_connect = true;
 		}
