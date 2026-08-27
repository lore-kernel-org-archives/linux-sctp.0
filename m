Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 861CF349CD2;
	Thu, 27 Aug 2026 21:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787866408; cv=none; b=lNsfXHNvRxxzN1255oA+GeYmNCC2AiQzQc4X4vQXWCUSPMiVH1YPJiCenoMTmhLi+w6OoybHHfQU4JBhzpoTiSFlbfMPq8szlVuhpv++ctKIFB7VxtfgYAk0owPcvX5BvGWGveIScZhz9QsEc6dlEjK/2YZBQI+eBayv8B8bJJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787866408; c=relaxed/simple;
	bh=KC0uZjfOM/QzlwTZHtj7+1uScvQIHOo13y9JW7w+fp0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=UuDi1GPJVhI97uX2YP6ZpgivDgiaMXO5CnA6U5bj3nhaEYB0O/HhVQOVwIf5b3bldgcKDamFUoubNlto+bVbfM6zn6Er/x2iSSuivSSEyz6MME12/3UIB1PxqDMetflqhf9/WBGRrjCPKXULN3DFfyJBatoKnVf73zFLFkV/QYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JPr16Nlz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JPr16Nlz"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1C195C19425;
	Thu, 27 Aug 2026 21:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1787866408;
	bh=KC0uZjfOM/QzlwTZHtj7+1uScvQIHOo13y9JW7w+fp0=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=JPr16Nlzy6+LJfV25/46DJfb31+6a1WK46mWyNGNso+zUkDiB3qWwsA+0S59SdDPF
	 SWztIqvz339fLSBAb7HM89exlxXgJEQ0VXiS79P9UTom1EQBkNuvHbxPkUZGxD6Lfz
	 xwewVQPSSGhj875VbYg+jpVvTK5CMhFVPRpVgLJjJyntVeUpnusaCGb5tWKT+1scHH
	 pQul9VXgKj22OEW89XHkzK4lWO+LiuUPch8g+09sueIyywbDqQq4fA4RiG2AoZKAZ+
	 RILpGxrN8B9jwD58+X3GNDP5SGqwosCoMKh7XBUMHj77zS4bXGDmYImjCQ2aTVrhzz
	 LxxEetBYc5phw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EED80C61DB9;
	Thu, 27 Aug 2026 21:33:27 +0000 (UTC)
From: Charles Vosburgh via B4 Relay <devnull+theminershive.gmail.com@kernel.org>
Date: Thu, 27 Aug 2026 17:32:53 -0400
Subject: [PATCH net v2] sctp: validate chunk length in the inqueue parser
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260827-sctp-zero-chunk-inqueue-v2-1-2e7669c6a6cb@gmail.com>
X-B4-Tracking: v=1; b=H4sIAAStkGoC/4WNSxKCMBBEr2LN2rEgJSG68h4WCxgGiEqC+VAqx
 d0FPIDL7nr9egLPTrOH824Cx6P22poliP0OqCtNy6jrJYNIhEyUkOgpDPhhZ5G6aO6ozTNyZKy
 OuaqpzDJBEpb14LjRr818BcMBil/pY3VjCqtzxTrtg3Xv7X9MN/jv1Zhiikrm8lQT5Y2iS9uX+
 nEg20Mxz/MXDZKt/9UAAAA=
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787866405; l=3668;
 i=theminershive@gmail.com; s=20260727; h=from:subject:message-id;
 bh=aM1ph9zq6C+26p9W6U+K2Mb79wS90gFjxiNAMYMThSw=;
 b=yOUN1WGQwKC2FssCDQfG6NXk/XFqXZEmxrdaW17BwiCsXzi4m6rDqx93FMG7YAwyiKyotxUXS
 G4c8lbHU8VHAA43OTRgolr3YtKERSkmHoPHvRYQIJY3KUXbNE0x/LYi
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
Changes in v2:
- Fold the minimum-header check into the existing chunk classifier.
- Keep pr_debug() on the malformed path and leave chunk_end unchanged.
- Retest lengths 0--4, legitimate ASCONF, and IPv4/IPv6 SCTP traffic.
- Link to v1: https://patch.msgid.link/20260826-sctp-zero-chunk-inqueue-v1-1-86769dcc7f8c@gmail.com

To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To: Xin Long <lucien.xin@gmail.com>
To: "David S. Miller" <davem@davemloft.net>
To: Eric Dumazet <edumazet@google.com>
To: Jakub Kicinski <kuba@kernel.org>
To: Paolo Abeni <pabeni@redhat.com>
To: Simon Horman <horms@kernel.org>
To: Vlad Yasevich <vladislav.yasevich@hp.com>
Cc: linux-sctp@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 net/sctp/inqueue.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/sctp/inqueue.c b/net/sctp/inqueue.c
index 5f988b3a8814f..d666cec6b194e 100644
--- a/net/sctp/inqueue.c
+++ b/net/sctp/inqueue.c
@@ -212,8 +212,10 @@ struct sctp_chunk *sctp_inq_pop(struct sctp_inq *queue)
 	chunk->chunk_end = ((__u8 *)ch) + SCTP_PAD4(ntohs(ch->length));
 	skb_pull(chunk->skb, sizeof(*ch));
 	chunk->subh.v = NULL; /* Subheader is no longer valid.  */
-
-	if (chunk->chunk_end + sizeof(*ch) <= skb_tail_pointer(chunk->skb)) {
+	if (unlikely(ntohs(ch->length) < sizeof(*ch))) {
+		chunk->pdiscard = 1;
+	} else if (chunk->chunk_end + sizeof(*ch) <=
+		   skb_tail_pointer(chunk->skb)) {
 		/* This is not a singleton */
 		chunk->singleton = 0;
 	} else if (chunk->chunk_end > skb_tail_pointer(chunk->skb)) {

---
base-commit: f967455fb2a5a2079b9eb5823e9ccf359174bf9f
change-id: 20260826-sctp-zero-chunk-inqueue-b478dca552c6

Best regards,
--  
Charles Vosburgh <theminershive@gmail.com>


