Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [80.241.56.161])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C165C30C147;
	Tue, 11 Aug 2026 15:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.161
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786462124; cv=none; b=ZNTX31MyN3RcYCDZczhQw73wsFK8GRq5wWZE0toPv/d34c3WhW+hQR13U98yM9gDqOy9DtPQItKFe4YH3oJQCizRleSl9nDxY0ZT9c0aYztuRw6zeBCQKsGbbOCTLEW/jTdHrFfPQQst0UIXyMmZkymf4ZvR4rRLhdJETC1YtIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786462124; c=relaxed/simple;
	bh=ukXSqRJn8Y+T8a9RPB32KSUQkbPFBSwkuo/XZkl0hPE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dlsXICVeURrYgQELE8/oqcmp3Z3W6hG/qSyrmmBIi+HAS03o1d/cU2/m60Y7bPIbsYEczScmD4RyP1UlBeoCThrstxYwt8dnApC+/Xjjv+NgKpeKvRM/jOVzO0gKeYEABrYcFBdF9JsS5ymBIYHQ3WJPTO5dW9C84E8bsj0YutA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org; spf=pass smtp.mailfrom=mailbox.org; dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b=GVmozBZ0; dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b=J/QkN0bs; arc=none smtp.client-ip=80.241.56.161
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailbox.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b="GVmozBZ0";
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b="J/QkN0bs"
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:b231:465::2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4hKFrl43BxzKnRd;
	Tue, 11 Aug 2026 17:28:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1786462119;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Nw6aTHtvLaWwp5ADjnbDYIyW1LdbtI69k4Mz7FVOZbI=;
	b=GVmozBZ0LwJC9knPP96jgUfwBbudQ3yTdhMv7YWxuNegN74pg2ckMhoAB4lS13ty045tH8
	XmmwEFqP8FNsAwGbKeWUerPXN4vpkuwpAT1UR3k7tCS4mwHqyut73zaM6egTAZVtz2V2J5
	w8XwHo8Uhwpuhq374PzpjQf6XlCLPMSPohuqSk0rAJB/krRXgiB+J4yoSyq+0w7HJzys+b
	eVGXYShMVSh9wa8pZbHwDHZJVzA6LVEhSC6Y82WjIDEvCxxperYB5UURTkwzeKd6BB/TG9
	w912KA1zx0HH/KkaGaEYQ+AHCEmdIIdhCG5lTBaqRMnEpKtjyt3ofglqkiV6yQ==
Authentication-Results: outgoing_mbo_mout;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b="J/QkN0bs";
	spf=pass (outgoing_mbo_mout: domain of a0yami@mailbox.org designates 2001:67c:2050:b231:465::2 as permitted sender) smtp.mailfrom=a0yami@mailbox.org
From: Qing Ming <a0yami@mailbox.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1786462118;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Nw6aTHtvLaWwp5ADjnbDYIyW1LdbtI69k4Mz7FVOZbI=;
	b=J/QkN0bsShCwyFKhRJB5Pa0pyaHkuSuujOKCWvDjUW9wUqV4FTsYQViVKrawh50UJnWmzB
	pNct9Znh3QP4K2rLTMFBcsJ1isXgopxp9P1sf1XTIgineXOLG8iQ1Ix7YXV79z0MbGaRyj
	UJwfPy3EiZjXgTdRPUmucuMm4/vCWjCDLoLXZw2/M8nyJ7cXe59HHUAghBwfFg0BRyn5gh
	nPDetMEo95qzSGCSYnCU2WDGVkojTbpDM5NrnMvUwIo4GqbvL9B5wKV5Kna45gfQr4/wwd
	QDYVLgk9atr8icNk5YaADYkAViWdydGEioYUGHFz2vvUbCCNK7Rt6bzX2Y5VAQ==
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Xin Long <lucien.xin@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Michio Honda <micchie@sfc.wide.ad.jp>,
	linux-sctp@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Qing Ming <a0yami@mailbox.org>,
	stable@vger.kernel.org
Subject: [PATCH net] sctp: clear new_transport when removing a peer
Date: Tue, 11 Aug 2026 23:28:03 +0800
Message-ID: <20260811152803.5629-1-a0yami@mailbox.org>
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-RS-META: pii9f98jyh3m1txgu89ut9nrhjpyz6b3
X-MBO-RS-ID: 398163ccbb3a09552c6
X-Rspamd-Queue-Id: 4hKFrl43BxzKnRd

sctp_process_asconf_param() stores a newly added peer transport in
asoc->new_transport. After all parameters in the ASCONF chunk have been
processed, sctp_sf_do_asconf() uses this pointer to send a HEARTBEAT to the
new transport.

An authenticated ASCONF from a remote SCTP peer can add a transport and
remove it again with a wildcard DEL-IP parameter in the same chunk. The
wildcard deletion preserves the transport on which the ASCONF arrived, but
removes the newly added transport through
sctp_assoc_del_nonprimary_peers(). The removal does not clear
asoc->new_transport, leaving it pointing to the removed transport.

sctp_sf_do_asconf() then creates a HEARTBEAT whose chunk->transport points
to the removed transport without holding a transport reference. During
local address replacement, src_out_of_asoc_ok keeps this HEARTBEAT on
control_chunk_list. After the transport is freed by RCU, a successful
ASCONF_ACK for the replacement address releases the queued HEARTBEAT and
sctp_outq_select_transport() reads the freed transport's state.

The issue was found during a static audit of SCTP objects. With an
authenticated peer, the reproducer triggered the same KASAN report in 2
of 2 unpatched runs on a KASAN-enabled netdev/main kernel:

  BUG: KASAN: slab-use-after-free in sctp_outq_select_transport
  Read of size 4 at addr ffff88800b9bd95c by task python3/197

  Call Trace:
   sctp_outq_select_transport+0x549/0x8b0 [sctp]
   sctp_outq_flush+0x306/0x2c60 [sctp]
   sctp_transport_immediate_rtx+0xaf/0x260 [sctp]
   sctp_process_asconf_ack+0xa48/0xf70 [sctp]

  Allocated by task 197:
   sctp_transport_new+0x68/0x650 [sctp]
   sctp_assoc_add_peer+0x258/0x12a0 [sctp]
   sctp_process_asconf+0x5e9/0x1090 [sctp]

  Last potentially related work creation:
   __call_rcu_common.constprop.0+0x77/0xb70
   sctp_assoc_del_nonprimary_peers+0x7c/0xd0 [sctp]
   sctp_process_asconf+0xd9c/0x1090 [sctp]

The first invalid access was a four-byte read of transport->state at
net/sctp/outqueue.c:833. The same reproducer completed the full
authenticated ASCONF and local-address replacement sequence with this
change without a KASAN report or oops.

Clear new_transport when its peer is removed, before it can be used to
create the HEARTBEAT.

Fixes: 6af29ccc223b ("sctp: Bundle HEAERTBEAT into ASCONF_ACK")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5
Signed-off-by: Qing Ming <a0yami@mailbox.org>
---
 net/sctp/associola.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index 5b0ae616e1ff..c65c83638cce 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -543,6 +543,9 @@ void sctp_assoc_rm_peer(struct sctp_association *asoc,
 	    asoc->addip_last_asconf->transport == peer)
 		asoc->addip_last_asconf->transport = NULL;
 
+	if (asoc->new_transport == peer)
+		asoc->new_transport = NULL;
+
 	/* If we have something on the transmitted list, we have to
 	 * save it off.  The best place is the active path.
 	 */

base-commit: cba9ccb47e9fa4cc77692fb896cc5ab57a667882
-- 
2.53.0

