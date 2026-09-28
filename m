Received: from mail-wr2-f35.google.com (mail-wr2-f35.google.com [74.125.225.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 144324E50AD
	for <linux-sctp@vger.kernel.org>; Mon, 28 Sep 2026 19:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790622277; cv=none; b=J1eC4qflxR5t/iXmf2QyFmVb3R9aJhOtniTj62g1bJDTeUFIyDRLFh9Z+7YGl1sRLZ6ZPfW8QxbxYKYUDHxFUI7kzVH/a/jvc/ACFBArlV2GnPpmGjUiHrc2siWAZct3Pua2MoewxZ5TyGW8XKz/qWjUQeTR6fFj+16wGt9w83Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790622277; c=relaxed/simple;
	bh=pK+7XCkdBfalcoLQB4C2MorhZtzVib1xqhWjiQSG8Z4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MTlDXBGRJiNk4EZs4XB+ZqHo8yirTOcSaT9tjggAimHTo9HYDG2TWpdurufgn+XS5mJU6P5oqZnHnT5cdrPWqyY+Ru87v5R2oFkIrENVG/KXV0yw1MYP53sGMOUOcstWknC8E1iRMrlJ69nADIpSfSbbrECtePCSf3lLUL4TbQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cellusys.com; spf=pass smtp.mailfrom=cellusys.com; dkim=pass (2048-bit key) header.d=cellusys.com header.i=@cellusys.com header.b=HMVpCAxK; arc=none smtp.client-ip=74.125.225.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cellusys.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cellusys.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cellusys.com header.i=@cellusys.com header.b="HMVpCAxK"
Received: by mail-wr2-f35.google.com with SMTP id ffacd0b85a97d-488780459e2so3320841f8f.2
        for <linux-sctp@vger.kernel.org>; Mon, 28 Sep 2026 12:04:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cellusys.com; s=google; t=1790622270; x=1791227070; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=KFkyXhwW18GAT053qn0DCfTNGShaOy7jAryC8dH6Q/8=;
        b=HMVpCAxKz8NLN6JL4VVSoh7yMjynDyGX9fWEk9BOeHv18hoD2KkMzwGqqJK6kD4V4T
         V3gBGsycfzKmc/gugln52UCoq5HRmkZs3T2Za+YuleREgm2p1qsTcOmYmPPiou/Vo2tG
         Derf8W+vKHctCbPfDEeNQzSbQz/1aLqaMs2r0scpHFJ8WW6tOyq+H2aA1oHZSJnGs17k
         ZMXaxxJGUJivTTDYcmtSaE+QgxQAoNLjN/qm1VPgcFdslBlzhbHS0H+EC04WvWchAGvf
         Q6J3ynajr5l8rWDFVnMaP70EAfx25k9uf2lPhwPJ+j4hbf4bzEQCV52AflNWbyY+juUg
         y1WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790622270; x=1791227070;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KFkyXhwW18GAT053qn0DCfTNGShaOy7jAryC8dH6Q/8=;
        b=anHVVbzehHJ8g09faiXvQhXyGc7fpd5ATojtRt+SNl6B9mRmDSqBXH+MShIUprhpeE
         NZMgRrIMvkAXR7soZRAwo7L46SiXdwvtjmQrXUrksU/GvAEVa5u8bXW4A1RDj3XtSvLE
         /PHqVkGRz7Aimeud+SbehXlJkXyYqpA2W/VGwgI03d0H44QTRg59eIW5YAi8SB4R1Bup
         Tnj/TorenxuXx9XkBKL2tzhrvQ0VFlq/+zK8dIGzZDwjvoVs856vjLkJBoyOy4boHerl
         YcvGDnkMKh0K+O9HWHRHmATFWyXVFoETnwMOsJjeWWR8MGkM0/0EHKiIU12Z+JPtHi2I
         bt8A==
X-Gm-Message-State: AFuF++mhD366pen8vT2fDCxSfHZ6sXzj88DT3ZVShw7zMMutPngSCylC
	BuzrZ8neMfEZZLCU2Z/dSZlCIElxCFaSzf8Z0pmmaHdzdkBvCh2OHSU8hsOjGp7QbDo=
X-Gm-Gg: AYBFou19cC2Z8WsNPawdhRYhK17sFz3p0vVka3YulfgsDQtyto+0EnHnk26nhmBwY8d
	dnOqUtytm8cyZqcvKnyeYW5UgptDaK4F9tHA18XPhm3o8hjrMxseZeqZvRxuzAi4ucwhbe4L9k+
	YtFheL8nT0EoBI++EPRqwl8qTFXvSGBlR7zZtUngp803GFLqZMjDUz+7ya3g1iJnVB1caW9ulvT
	wEv3xRnr1C4uOhEPwIHGi83VbPnGaffBgMXKhzZoYJkuyhc1FohhiFOW8/X6lSL2zck6GG/4fxn
	2YVFQiQRYr68HqtKs+3xyap/vECF2/6LHS/uASvpd1bT8n7qS/8TchecI21+LQDPglhwYA3o0eP
	IEugFonGuXsbHh5V8GUqU9dTwgFUcq8Y52iFG743yKByXzzNRzQZkaY49ptd/rJB/980+1AgVBj
	kb/ynXDyIqkOOIgIKbZkbLWWj34Dw0Qp7VxnNeF+spJt7qVfVoDjhY4kuz3DcKfqMLIX2LTkh6h
	873ukJ6FYSqNmTZpbTO6xB2TEGFCH7qg+YygzfICWE8PNYHP5N7rqh1kZoqyedxtDE=
X-Received: by 2002:a05:600c:8b4c:b0:49e:8184:f63b with SMTP id 5b1f17b1804b1-49fe66f3a68mr242422195e9.16.1790622270200;
        Mon, 28 Sep 2026 12:04:30 -0700 (PDT)
Received: from dscRocky-build.localdomain (ip-83-147-170-154.wfd.metro.digiweb.ie. [83.147.170.154])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a00c0d538fsm24710695e9.1.2026.09.28.12.04.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 12:04:29 -0700 (PDT)
From: Warren Briggs <wbriggs@cellusys.com>
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>
Cc: linux-sctp@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Warren Briggs <wbriggs@cellusys.com>
Subject: [PATCH net v4] sctp: carry peer capabilities across an INIT collision
Date: Mon, 28 Sep 2026 15:04:01 -0400
Message-ID: <20260928190401.1641260-1-wbriggs@cellusys.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

sctp_assoc_update() folds a temporary association into the existing one
when an INIT collision is resolved. It copies asoc->c, peer.rwnd,
peer.sack_needed, peer.auth_capable and peer.i, and nothing else.

The remaining peer capability bits therefore keep whatever the surviving
association was given when it was created, rather than what the peer
advertised in the INIT that caused the collision.

Forward TSN is the visible case. The INIT-ACK is built from the
temporary association, so it advertises Forward-TSN-Supported; once the
collision is resolved the surviving association holds
peer.prsctp_capable == 0, and the first FORWARD TSN chunk the peer sends
is answered with ERROR "Unrecognized chunk type". The peer does not
expect this, having been told the capability was supported.
ecn_capable, asconf_capable and reconf_capable are lost in the same
way.

ASCONF and RE-CONFIG also depend on two inbound sequence counters,
peer.addip_serial and strreset_inseq, which sctp_process_init() derives
from the peer's Initial TSN on the temporary association only. Without
them the surviving association would have the capability but discard
the peer's ASCONF and refuse its RE-CONFIG requests as out of sequence,
so they are re-derived from the copied peer.i.

The two address flags fail the other way round. sctp_process_param()
clears ipv4_address and ipv6_address and sets them from the peer's
Supported Address Types, but only on the temporary association. The
surviving association keeps the permissive defaults from
sctp_association_init(), so it can believe a peer supports an address
family that peer never advertised.

peer.adaptation_ind is recorded on the temporary association in the
same way, so the SCTP_ADAPTATION_INDICATION notification raised after
the merge reads a stale value, or none.

intl_capable is lost too but is deliberately not carried here. It
selects asoc->stream.si and affects the fragmentation point, and the
outqueue may already hold data when the merge runs, so changing it
safely needs more than a copy. It will be addressed in a separate
patch.

peer.auth_capable is already carried, added by commit 1be9a950c646
("net: sctp: inherit auth_capable on INIT collisions") for the same
reason. This extends that to the rest of the block.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Suggested-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Warren Briggs <wbriggs@cellusys.com>
---
Changes since v3:
 - re-derive peer.addip_serial and strreset_inseq from the peer's
   Initial TSN, so inbound ASCONF and RE-CONFIG are accepted.
 - dropped intl_capable, to be handled in a separate patch.
 - carry peer.adaptation_ind.

Changes since v2:
 - dropped asoc->peer.hostname_address. The field no longer exists,
   removed by commit bd4b28189469 ("sctp: delete the obsolete code for
   the host name address param").
 - wrapped the commit message at 75 columns.
 - added the Fixes tag.
 - retargeted at net, subject prefix corrected.

Changes since v1:
 - added ecn_capable, asconf_capable, reconf_capable and intl_capable,
   the missing fields identified in review of v1.
 - also added ipv4_address and ipv6_address, which are set from the
   peer's Supported Address Types on the temporary association and are
   lost at the merge in the same way.

Testing. On a 4.18-based kernel carrying this change (the code paths
involved are the same upstream), an INIT collision was created between
two sockets on one host, one of them held in COOKIE_WAIT, and the
surviving association's peer state was read back and exercised in both
directions.

Read back from the collided association, by socket option or sctp_diag:

prsctp_capable   SCTP_PR_SUPPORTED            unpatched 0, patched 1
reconf_capable   SCTP_RECONFIG_SUPPORTED      unpatched 0, patched 1
asconf_capable   SCTP_ASCONF_SUPPORTED        unpatched 0, patched 1
ecn_capable      SCTP_ECN_SUPPORTED           unpatched 0, patched 1
ipv4_address     sctp_diag sctpi_peer_capable unpatched 1, patched 0,
                 with the peer advertising IPv6 only
ipv6_address     sctp_diag sctpi_peer_capable unpatched 1, patched 0,
                 with the peer advertising IPv4 only

Outbound, sent by the collided association, with the patch applied:
 - SCTP_RESET_STREAMS puts a RE-CONFIG on the wire; an unpatched kernel
   refuses the call and sends nothing.
 - sctp_bindx(SCTP_BINDX_ADD_ADDR) puts an ASCONF on the wire; an
   unpatched kernel sends nothing.
 - a PR-SCTP message it abandons is followed by a FORWARD TSN.
 - DATA it receives in a CE-marked packet is answered with an ECNE.

Inbound, sent by the peer to the collided association:
 - a FORWARD TSN is SACKed; an unpatched kernel answers it with ERROR
   cause 6.
 - a stream reset request is performed; v3 answered it with bad
   sequence number.
 - an ASCONF (set primary) gets an ASCONF-ACK; v3 sent none.
 - the adaptation layer indication in the peer's INIT is delivered to
   the application with the value sent; v3 did not deliver it.

 net/sctp/associola.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index 4521be3bd85a..77ac155fdb70 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -1107,8 +1107,19 @@ int sctp_assoc_update(struct sctp_association *asoc,
 	asoc->peer.rwnd = new->peer.rwnd;
 	asoc->peer.sack_needed = new->peer.sack_needed;
 	asoc->peer.auth_capable = new->peer.auth_capable;
+	asoc->peer.prsctp_capable = new->peer.prsctp_capable;
+	asoc->peer.ecn_capable = new->peer.ecn_capable;
+	asoc->peer.asconf_capable = new->peer.asconf_capable;
+	asoc->peer.reconf_capable = new->peer.reconf_capable;
+	asoc->peer.ipv4_address = new->peer.ipv4_address;
+	asoc->peer.ipv6_address = new->peer.ipv6_address;
+	asoc->peer.adaptation_ind = new->peer.adaptation_ind;
 	asoc->peer.i = new->peer.i;
 
+	/* Re-derive sequence counters from the peer's Initial TSN */
+	asoc->peer.addip_serial = asoc->peer.i.initial_tsn - 1;
+	asoc->strreset_inseq = asoc->peer.i.initial_tsn;
+
 	if (!sctp_tsnmap_init(&asoc->peer.tsn_map, SCTP_TSN_MAP_INITIAL,
 			      asoc->peer.i.initial_tsn, GFP_ATOMIC))
 		return -ENOMEM;
-- 
2.43.7

