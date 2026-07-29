Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC9C13BE636
	for <linux-sctp@vger.kernel.org>; Wed, 29 Jul 2026 16:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785340840; cv=none; b=bG9s908Ry9K1Beed7hv3jSjGEq1dyD/VFGUPy3kR4O1i21zSSFFjJHQAZn7D78Rk3IV3BkRrHGaDFi/66OxjrTRf5U9ybR/DnrSmAkW1RUsknnQYwsLkxCkfVrrd4VrHUVo8wiFqzWsqQ1bK2c1lk38g65pBjGgtiCTczWybjps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785340840; c=relaxed/simple;
	bh=wGk13vL35KwG3l0xTxS+K1aQKa+KpFO1SrTRXLK0xuA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WToRaLpBaTaEvGioehefuHI9Rm8oTctbCEQ384fgCnnSfZgsmcagiVHbLfsRbvFWmBYR/s0cvEU+R3ZMaab1qDO45e+kxIS3o7T5DrXZp/N1hC6PSlyH7NYt5NuveuP/txazAs/6Mt+94fE5o4mLeMexTtYGrD5yG3ORURgrvoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xbow.com; spf=pass smtp.mailfrom=xbow.com; dkim=pass (2048-bit key) header.d=xbow.com header.i=@xbow.com header.b=kHzVSBmM; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xbow.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xbow.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=xbow.com header.i=@xbow.com header.b="kHzVSBmM"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-38f0f132f56so2866a91.0
        for <linux-sctp@vger.kernel.org>; Wed, 29 Jul 2026 09:00:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=xbow.com; s=google; t=1785340835; x=1785945635; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=mi7DTUQ6I2JLv7hCuqy916IrqtjL9UgcrN2Dk8y583M=;
        b=kHzVSBmMze66yf7sXerQmvWqALFENLBE4hemGdXQ/RqF14VblyD5kxugNeUyOo6mRi
         sBbd2CvHXIqGDPiaMCHXyGgJq3WlL5OzYbUyoxNpqu6vRzKv7LfoXezR6iP62xg17D2b
         o7r6E6u0/xi/WFrHKNPA2KeoUKO+Z650Elco7LhE/6I5GqnRZSXEPVyT9FkBEtEOFp4b
         slfaOtB4mk3oh5F9pt3TSgTMv2oWgIpkxRK5L2kAid7zXkx+9nChPV2WeH1RcnU70yiU
         wKaIMbluEfn5oGrNSeEPJAyan5+XrzZqiDN/wOE2ofOP3IZfERS+N9p0qut/A5TKJYUC
         cD2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785340835; x=1785945635;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mi7DTUQ6I2JLv7hCuqy916IrqtjL9UgcrN2Dk8y583M=;
        b=Q7E3+3QVNZd8+6hALGiNVi28dDngobKBiGPzfFAdWlSrzKfBACVSA2IEFL2yqiX9Je
         4lJ2TB/idTOmnxV8xZ51LIbncF0ud4IX5p4KqsnY/8PpVgnTnb6xsV+CB3FZ9JX6hkEO
         P/fgUgGOHk1VoyolBLDCRX+VJP3jCBLffL9/MDis/ag0XiEKuy6Bg8aMD/9rHuYMnhKz
         F2lDKafkX/eY8/Be/bYZgJvpA38SFuS8DwIk8M505kELbRPjxOaollyJs8wU6c3jRotI
         P3EzkNJNnewD8As/Lgj2ctLmGHEqTdBDOSew/fc/lR1Em9eWwj2VcPZz0mxlhOxyNi1u
         9Vsw==
X-Forwarded-Encrypted: i=1; AHgh+Ronw4em0VfEBl70Kx3b7k8hrAbAIqV45p6qu3R19XT1Jp/uWnjf/kLabqLrYi8+zeSFyXEVIwk1u+rn@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/onjZf2odbniZToQosYJRtzTXx6UoMvBk9T/+GVfi4gWn9zey
	YX7y7qnWqyanqXGg0nzNwpJalFpRlOEhAbDQ1QMRC5R2/PPW1nvOYEGy+vdnJ/tanwM=
X-Gm-Gg: AR+sD10Nzfc2Dloz1egz5vC+a2l1CKPPQ9Tpp5aDWrRx2gVwi5ijeWG//cabk/woDO0
	koofj0v7onSX7hVoxL6/8isjYltX1I2b/K4+9VJzAhfMM+ifcbO5n6xZqGDvfwQehsSF1DGAlTB
	vxFWlBvYsDHhnW2+cBCzFZFp0XtJdLIel+tgy9XDhffe1NFMkNPPnDT1vO6V0G7Y9k49qSMeqdg
	RdnXTgJcbqickQvkNpUF5J+OEGLGu164KBuOswIzYBWs5CP6zZPnGFd1NC/SCylKV6bIvxPpHW0
	N68gOtLnHY+s3hRewWAPR6r3SFO5uzSAiwvOqOvZl+bFVxFBDqorrkLUdwFv9PBdZOLKhGR4+F8
	U7Rsg0dHGl3M0D+iHKe32ois+AOyAKvPAOYiwK6AQ2VBMkXntVb45yujPMBmUOxyo6+CFOokjck
	4gJadmHRIBk1kBEil2ScnCYIhluQ8m8uyqoahAtz/vfp5k/rBElMZiM82uiuJZuOybD9ocaH4oS
	Rs4P3PEVeA2skkKkn9zBsrdsKev
X-Received: by 2002:a17:90b:4a90:b0:37f:9e21:91d6 with SMTP id 98e67ed59e1d1-38f8368746dmr2143556a91.13.1785340833898;
        Wed, 29 Jul 2026 09:00:33 -0700 (PDT)
Received: from Mac.lan ([125.128.148.126])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38f7f12f965sm1615685a91.5.2026.07.29.09.00.30
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 29 Jul 2026 09:00:33 -0700 (PDT)
From: Baul Lee <baul.lee@xbow.com>
To: netdev@vger.kernel.org,
	linux-sctp@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	stable@vger.kernel.org,
	Baul Lee <baul.lee@xbow.com>
Subject: [PATCH net v3] sctp: keep chunk->transport in step with the list it is queued on
Date: Thu, 30 Jul 2026 01:00:28 +0900
Message-ID: <20260729160028.54546-1-baul.lee@xbow.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

__sctp_outq_flush_rtx() moves a gap-acked chunk onto another transport's
transmitted list without updating chunk->transport:

	if (chunk->tsn_gap_acked) {
		list_move_tail(&chunk->transmitted_list,
			       &transport->transmitted);
		continue;
	}

The chunk then sits on a live transport's list while chunk->transport still
names a different one.  If that transport is removed - sctp_assoc_rm_peer()
from an ASCONF Delete-IP - sctp_transport_free() RCU-frees it and the chunk
is left with a dangling pointer.  sctp_assoc_rm_peer() scrubs
peer->transmitted and asoc->outqueue.out_chunk_list, but the chunk is on
neither.

The pointer is not followed while tsn_gap_acked is set.  A SACK that
reneges on the TSN clears the flag, and the next SACK reaches

	tchunk->transport->flight_size -= sctp_data_size(tchunk);

inside the freed transport.  KASAN reports a slab-use-after-free read in
sctp_check_transmitted(), freed from sctp_assoc_rm_peer().  Both the
removal and the SACKs come from the association peer.

Set chunk->transport at the move.  The ordinary resend path needs nothing:
it reaches its list_move_tail() only after sctp_packet_append_chunk()
returned SCTP_XMIT_OK, and __sctp_packet_append_chunk() has rebound the
chunk by then.

Discovered by XBOW, triaged by Baul Lee <baul.lee@xbow.com>

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Baul Lee <baul.lee@xbow.com>
---
v3:
 - drop the redundant assignment on the ordinary resend path (Xin Long)
 - trim the commit message

v2:
 - fix the root cause in __sctp_outq_flush_rtx() rather than scrubbing the
   retransmit queue in sctp_assoc_rm_peer(), which cannot see chunks already
   migrated onto another transport's list
 - correct the Fixes tag

Link to v1: https://lore.kernel.org/netdev/20260726060453.42730-1-baul.lee@xbow.com/
Link to v2: https://lore.kernel.org/netdev/20260729124929.5885-1-baul.lee@xbow.com/

 net/sctp/outqueue.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index f6b8c13dafa4..e92fb9da4647 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -650,6 +650,7 @@ static int __sctp_outq_flush_rtx(struct sctp_outq *q, struct sctp_packet *pkt,
 		if (chunk->tsn_gap_acked) {
 			list_move_tail(&chunk->transmitted_list,
 				       &transport->transmitted);
+			chunk->transport = transport;
 			continue;
 		}
 
-- 
2.53.0

