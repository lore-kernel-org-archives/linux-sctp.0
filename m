Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EC0F272E56;
	Thu, 27 Aug 2026 01:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787792496; cv=none; b=KzIA/DLNEMz6id/dGQPq9oaN6MNILEqu72bqaKQY/atdf6yX3M5WSx6Gk52mjciexi41KqL7LcqGH6Of/1F1RD8mcJ727D65nZUlOvA/hkIg/wkBpNEAUVmEpunf/eXolAUSzSONB+A/+hIlwWqNFoBw+/9aPanLqI7EI+WJwYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787792496; c=relaxed/simple;
	bh=K387+5MOXgtRrXOoteyrozmkC8NODgD+4aUXFUZxW9o=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=BwuNQ5Qz1wdY6R88cnQ+m0fJtj/AitG0wFIS7V1x6J2bjkAFkaEdUcaG4ZDNQw/pdD1NnAeLwn9fynjdl5wmGB73LzfKzxa+MZKNgECjFjHhE0hmnq61Ve4XZSt0CttF3y5U/GXCJeJR2SXhj0lD9jJ5GgXfbLlM9F7T977tZ08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AbBEDQdl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AbBEDQdl"
Received: by smtp.kernel.org (Postfix) with ESMTPS id BA349C2BCB9;
	Thu, 27 Aug 2026 01:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1787792495;
	bh=K387+5MOXgtRrXOoteyrozmkC8NODgD+4aUXFUZxW9o=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=AbBEDQdlMU/eYao8fqV/2MJIGj9LMPFNegRE6y926Zh+j6sE+j8mNVQ8s5NIuFluP
	 DS7LZbRgY+ES33Aoj+LuMWJzUwWCQ7JMBvJXSHiTmK5ddY94wY5aPOra0BTLAF+hQi
	 9j9hxCe/qh6f3KsMEnqYSmYgUQtgqMGAqLBEvYV5yVmn0on2fMVCXCqrvzhAWQzNAl
	 nmdFVWv+nUjP1Idus04ACgh+1MXHfNnlvl7Z0drayoQMe2xE0TCIonAH9vL/Ph89h+
	 WzmPtP1zzr+QFX5OirVH5f3r0kM6dFXziw7KypZPfxUG7aEmlrsM4VZTwjlGW10tBp
	 u1rF04MlBOtuQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5B92C61DC6;
	Thu, 27 Aug 2026 01:01:35 +0000 (UTC)
From: Charles Vosburgh via B4 Relay <devnull+theminershive.gmail.com@kernel.org>
Date: Wed, 26 Aug 2026 21:01:30 -0400
Subject: [PATCH net] sctp: validate chunk length in the inqueue parser
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260826-sctp-zero-chunk-inqueue-v1-1-86769dcc7f8c@gmail.com>
X-B4-Tracking: v=1; b=H4sIAGmMj2oC/yWMwQ6CMBAFf4Xs2U2wkUr8FeMBlqesJgW7LTES/
 t2qx5lkZiVDVBidqpUiFjWdQoH9riIZu3AD61CYXO183TrPJmnmN+LEMubwYA3PjAzuD8d2kK5
 pnHgq9Rxx1dfvfKaARJe/tNzfIen7pG37AMBtY+GAAAAA
X-Change-ID: 20260826-sctp-zero-chunk-inqueue-b478dca552c6
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, 
 Xin Long <lucien.xin@gmail.com>, "David S. Miller" <davem@davemloft.net>, 
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
 Vlad Yasevich <vladislav.yasevich@hp.com>
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org, 
 linux-kernel@vger.kernel.org, security@kernel.org, 
 Charles Vosburgh <theminershive@gmail.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787792493; l=2767;
 i=theminershive@gmail.com; s=20260727; h=from:subject:message-id;
 bh=vMqw/cZjBCZMhglW7zLT3gwURYELJivbP13I5N01yIA=;
 b=AmMthM08XUQ5X5Ww1jjqDX9nET7jygzPCTaHbOa8fI2r79rQo6SpJ45SG3itooGWFrAhE2fma
 bP9tGswl6nJDoONJJV1u1R8Ugp+D1++c0DcsIn5EUbQuFbpRVESWpsN
X-Developer-Key: i=theminershive@gmail.com; a=ed25519;
 pk=kxCwp20gY82hL3ixb5IXlZ2N0X9TDxiKPCpjPcWqN3E=
X-Endpoint-Received: by B4 Relay for theminershive@gmail.com/20260727 with
 auth_id=977
X-Original-From: Charles Vosburgh <theminershive@gmail.com>
Reply-To: theminershive@gmail.com

From: Charles Vosburgh <theminershive@gmail.com>

SCTP chunks always include a four-byte generic header, but
sctp_inq_pop() currently accepts shorter declared lengths. A zero-length
chunk leaves chunk_end at the current header.

When ASCONF is covered by the association's SCTP-AUTH policy,
sctp_assoc_bh_rcv() can continue before the state machine performs its
normal chunk-length check. sctp_inq_pop() then returns the same malformed
chunk repeatedly and the receive softirq can lock up.

A remote SCTP peer can trigger this after establishing an association on
a kernel built with CONFIG_IP_SCTP and configured with
net.sctp.addip_enable=1 and net.sctp.auth_enable=1. The reproducer did
not require application credentials, a shared SCTP AUTH key, or
net.sctp.addip_noauth_enable=1.

On commit f967455fb2a5 ("seg6: reset IP6CB after IPv6 decapsulation"),
one zero-length ASCONF caused repeated
watchdog soft-lockup reports in a two-vCPU KVM guest. All 3 pre-trigger
health probes succeeded, while 36 of 37 post-trigger probes failed. With
this change, all 37 post-trigger probes succeeded and no equivalent
soft-lockup signature appeared.

Reject chunks shorter than the generic SCTP header at the shared inqueue
parser boundary. Mark the packet for discard before either caller can
continue processing it, while preserving the four-byte generic minimum.
Declared-length 1 through 4 controls and kernel-generated ASCONF traffic
remained healthy. The patched sctp_hello selftest passed for IPv4 and
IPv6.

The complete private reproducer and validation evidence are available
directly to maintainers on request.

Fixes: bbd0d59809f9 ("[SCTP]: Implement the receive and verification of AUTH chunk")
Cc: stable@vger.kernel.org
Assisted-by: ChatGPT:GPT-5.6-Sol
Assisted-by: Vantix:claude-opus-5
Assisted-by: Codex:GPT-5
Signed-off-by: Charles Vosburgh <theminershive@gmail.com>
---
 net/sctp/inqueue.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/sctp/inqueue.c b/net/sctp/inqueue.c
index 5f988b3a8814..12a46868165a 100644
--- a/net/sctp/inqueue.c
+++ b/net/sctp/inqueue.c
@@ -212,6 +212,11 @@ struct sctp_chunk *sctp_inq_pop(struct sctp_inq *queue)
 	chunk->chunk_end = ((__u8 *)ch) + SCTP_PAD4(ntohs(ch->length));
 	skb_pull(chunk->skb, sizeof(*ch));
 	chunk->subh.v = NULL; /* Subheader is no longer valid.  */
+	if (unlikely(ntohs(ch->length) < sizeof(*ch))) {
+		chunk->pdiscard = 1;
+		chunk->chunk_end = chunk->skb->data;
+		return chunk;
+	}
 
 	if (chunk->chunk_end + sizeof(*ch) <= skb_tail_pointer(chunk->skb)) {
 		/* This is not a singleton */

---
base-commit: f967455fb2a5a2079b9eb5823e9ccf359174bf9f
change-id: 20260826-sctp-zero-chunk-inqueue-b478dca552c6

Best regards,
--  
Charles Vosburgh <theminershive@gmail.com>


