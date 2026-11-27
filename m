Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795751312;
	b=gKADmavTOHtG5s+QRjCsQ/kvpeaanflu5OewCCewCR/jbKPA06IghkY0aTkqQA42J9Kd
	 ZHNM6wg9g3r6ixP9/v3gZk+CVJxhO4nSiMYQLCfd6zP66xILvD5tQ70a0rdJGtCG3mIz2
	 ai5mjcx0Yv1Nszy3hMgFtDMyNV/kVZ4V43pSjT07GUdr2FKZOBDWBnZ+UVj1lIXiSvGn9
	 Br//vVxjsQFBiLq+DEOOzGyNlwMy8uFVeXwKI+BBKh/yyv3pd05lEEnPfPYVv1JFD77yL
	 tY4iGLzYL8W0rCNXgJHVER84s7pVyh06qKNocsL/edULSAQ57G9nSoX1IyoNufagF/A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795751312;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Endpoint-Received:X-Original-From:Reply-To;
	bh=FFULFMRi0g2MjR/jOtVLsaDC9eiHigJbqcP2I7sEFy0=;
	b=xgtTNsVn2B9gfaebYzjVOTD2ObVnnqtGfuL1jTGTiLCFvhj2ZMuhDdevmzZ/COwNJMH5
	 s7kEYpRpqWVfkt23DFZryWM+aDfdNtDAgy0infxrMTCcFMxlzngRuzbD0FYGX8EDe6Vga
	 Sw8duJ7uJ0KKTNWW9AAGR6LERt7tKDrfKu7849S7KEGiUFjPozkJAlNZCxObTGKZl5gC7
	 w8CexkoZvZa40fDGQVEB2paqKUD6sXF6BxrwgUJfTfzjNRMd+ZwoogJFrhdmJbOwsF2FX
	 R2W9ixfYEGDqGX0aCNqPaxX9iC+LgVPZRqhLNHurynVuXAdphiU1XH13okW8Ruzyk9Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gE4OlIoe;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E816606A326;
	Fri, 27 Nov 2026 03:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gE4OlIoe
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795751312;
	b=BOXtQ1MR9F3cEfEwp+JvcsEAlLW21xAUEUBD3EnjpwGYRl+3x891prz9qeKOlX1X6Lee
	 m+w7hLfNZ2UVPpA1FjpjFrRyQe/joRLzzVRi8gJDAVnOSZmKOLOIaeppuGiM1aaxr6VKi
	 hkcyLFq1oV9DzLB5JM/eyCaYq4OHGHBDpu6FeZeplQ+SoR04fj7nJoxXR1WV3aTS5Vl8O
	 O4ZLyK6xL7mnh7LWmDjHyenwqQlI4k0qxgiRl619kqYn3iv/jp0dPIm22UdTD1QWiH104
	 hddA+x2lg3vbTO3EA6nl78peNGi9MItWKmr94iSksxC5/ik5iK+uR0zRo2DG0sfemdw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795751312;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=FFULFMRi0g2MjR/jOtVLsaDC9eiHigJbqcP2I7sEFy0=;
	b=ZHl78rE2fPM1lkTBjEf4O2DXoQq2l18GUAhw8ykF6Y417dS0kFP6gH/NJbfEUO2A/9Dd
	 wkUmi1CnIFZ7efXlZ8ekMy30J4YwPvxrtkCEg2k3YVQnB6KG3guwdFeqycS2Ab07gzKcr
	 /OeII+gozh65YnjDDXZDymTYd2p8cPIVJ47Z714w2BlyGBD9SEtZqd5rEd5ETP7zaA53f
	 ZxIYyhY+Eh9wRKqYHlKAYyIcvA/aLD5QQCvbEO5iROjzWJjqc80q14v2cvSj2D0DdYa9r
	 fzW1hVhg9lg1EqrYMKDQHWcuNcZ7rc7f2uqf3sCoSGmHteDPPQc9KOM4/um2BLeedow==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 5984A1F00899;
	Fri, 27 Nov 2026 03:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795751312;
	bh=FFULFMRi0g2MjR/jOtVLsaDC9eiHigJbqcP2I7sEFy0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=gE4OlIoeDXew4QGZbUIXYSCIYITGbOjhGgitD9FaEOS7fu8Wii136Lok9gQprKA3S
	 ypDZQnRIDK802bkT2VPZjnB+5mYP/bZrMzDfn3bEXBK7MJcbNpLGfBT+VlxMJQQtfH
	 j+Go6LAGVc4692cwRg7wBybzKd5VXqvoj070UP0u5fWFtGfVFL0VnaTnc2+mWhG11k
	 iFGvjVKyhjPclmRqZ5JgBIMXxcIzelmp7wJMEotbiUpMJR0r6QcF/xv1gNh9L8K7Vy
	 qnuvpDktqzEttFP95S2AJslcJ35QN7YKTvQvdc7xR3p1U9JljvQgSuC/SW1fevABdC
	 pTKFFIHvt93kQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id E11C24B550;
	Fri, 27 Nov 2026 03:48:27 +0000 (UTC)
From: Dickson Wu via B4 Relay <devnull+dickson.wu.certik.com@kernel.org>
Date: Fri, 27 Nov 2026 03:45:35 +0000
Subject: [PATCH 5.15.y 3/3] sctp: add INIT verification after cookie
 unpacking
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Post: <mailto:linux-sctp@vger.kernel.org>
List-Help: <mailto:linux-sctp+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sctp+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261127-so4-sctp-515-v1-3-bbee1a6af200@certik.com>
References: <20261127-so4-sctp-515-v1-0-bbee1a6af200@certik.com>
In-Reply-To: <20261127-so4-sctp-515-v1-0-bbee1a6af200@certik.com>
To: stable@vger.kernel.org
Cc: Xin Long <lucien.xin@gmail.com>, 
 Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, 
 linux-sctp@vger.kernel.org, netdev@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795751132; l=6211;
 i=dickson.wu@certik.com; s=dickson-b4; h=from:subject:message-id;
 bh=qXqnyULAbuD8Z1Occ9g1Uf0P7lOgRPzrN8/ffBOP464=;
 b=5FXFgJSL78sQALBLfrcjOwdst3WQw4/gS3PbaOrxEyuRogjkE8iiyCW63jq0NV5H8Kmc1NOYm
 ylugdcJKm6iDMIxxKotCuWhGjFRXduB2QjulU4HkkPBrjS68AWMhdJ7
X-Developer-Key: i=dickson.wu@certik.com; a=ed25519;
 pk=fxH7FS4FdojeJSGLJzgKdfO51Rvr4EW30yinj2mc1vg=
X-Endpoint-Received: by B4 Relay for dickson.wu@certik.com/dickson-b4 with
 auth_id=1647
X-Original-From: Dickson Wu <dickson.wu@certik.com>
Reply-To: dickson.wu@certik.com

From: Xin Long <lucien.xin@gmail.com>

commit 414c5447fe6a200613dd46d7fdc8454622076cb1 upstream.

In SCTP handshake, the INIT chunk is initially processed by the server
and embedded into the cookie carried in INIT-ACK. The client then
returns this cookie via COOKIE-ECHO, where the server unpacks it and
reconstructs the original INIT chunk.

When cookie authentication is enabled, the cookie contents are protected
against tampering, so reusing the unpacked INIT without re-verification
is safe.

However, when cookie authentication is disabled, the reconstructed INIT
can no longer be trusted. In this case, the INIT must be explicitly
validated after unpacking to avoid processing potentially tampered data.

Add sctp_verify_init() checks after cookie unpacking in COOKIE-ECHO
processing paths (sctp_sf_do_5_1D_ce() and sctp_sf_do_5_2_4_dupcook())
when cookie_auth_enable is disabled. On failure, the new association is
freed and the packet is discarded.

Also tighten cookie validation in sctp_unpack_cookie() by verifying the
embedded chunk type is SCTP_CID_INIT before treating it as an INIT
chunk.

Finally, update sctp_verify_init() to validate parameter bounds using
the actual embedded INIT length instead of chunk->chunk_end, since the
INIT stored in COOKIE-ECHO may not span the entire chunk buffer.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/ebcbbac574815b0850f371b4bdb02f2e602b94d3.1782341592.git.lucien.xin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ adapted to 5.15.y: use ->hmac and peer_init[]; verify A/B before the security hook ]
Signed-off-by: Dickson Wu <dickson.wu@certik.com>
---
The backport and the test runs were prepared with AI coding tools
(OpenAI Codex agents, with review by Claude). I went over the result
before signing off.

 net/sctp/sm_make_chunk.c |  5 ++++-
 net/sctp/sm_statefuns.c  | 46 +++++++++++++++++++++++++++++++++++++---------
 2 files changed, 41 insertions(+), 10 deletions(-)

diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 79d2c2b179c35..669b94d9db620 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -1789,6 +1789,8 @@ struct sctp_association *sctp_unpack_cookie(
 	bear_cookie = &cookie->c;
 
 	ch = (struct sctp_chunkhdr *)&bear_cookie->peer_init[0];
+	if (ch->type != SCTP_CID_INIT)
+		goto malformed;
 	chlen = ntohs(ch->length);
 	if (chlen < sizeof(struct sctp_init_chunk))
 		goto malformed;
@@ -2346,7 +2348,8 @@ int sctp_verify_init(struct net *net, const struct sctp_endpoint *ep,
 	 * VIOLATION error.  We build the ERROR chunk here and let the normal
 	 * error handling code build and send the packet.
 	 */
-	if (param.v != (void *)chunk->chunk_end)
+	if (param.v != (void *)peer_init +
+		       SCTP_PAD4(ntohs(peer_init->chunk_hdr.length)))
 		return sctp_process_inv_paramlength(asoc, param.p, chunk, errp);
 
 	/* The only missing mandatory param possible today is
diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index aec07ab9b9513..2990a3d7c5780 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -707,8 +707,9 @@ enum sctp_disposition sctp_sf_do_5_1D_ce(struct net *net,
 	struct sctp_association *new_asoc;
 	struct sctp_init_chunk *peer_init;
 	struct sctp_chunk *chunk = arg;
-	struct sctp_chunk *err_chk_p;
+	struct sctp_chunk *err_chk_p = NULL;
 	struct sctp_chunk *repl;
+	enum sctp_cid cid;
 	struct sock *sk;
 	int error = 0;
 
@@ -782,6 +783,18 @@ enum sctp_disposition sctp_sf_do_5_1D_ce(struct net *net,
 		}
 	}
 
+	peer_init = &chunk->subh.cookie_hdr->c.peer_init[0];
+	cid = peer_init->chunk_hdr.type;
+	if (!sctp_sk(sk)->hmac &&
+	    !sctp_verify_init(net, ep, asoc, cid, peer_init, chunk,
+			      &err_chk_p)) {
+		sctp_association_free(new_asoc);
+		if (err_chk_p)
+			sctp_chunk_free(err_chk_p);
+		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
+	}
+	if (err_chk_p)
+		sctp_chunk_free(err_chk_p);
 
 	/* Delay state machine commands until later.
 	 *
@@ -791,8 +804,6 @@ enum sctp_disposition sctp_sf_do_5_1D_ce(struct net *net,
 	/* This is a brand-new association, so these are not yet side
 	 * effects--it is safe to run them here.
 	 */
-	peer_init = &chunk->subh.cookie_hdr->c.peer_init[0];
-
 	if (!sctp_process_init(new_asoc, chunk,
 			       &chunk->subh.cookie_hdr->c.peer_addr,
 			       peer_init, GFP_ATOMIC))
@@ -2205,10 +2216,12 @@ enum sctp_disposition sctp_sf_do_5_2_4_dupcook(
 					void *arg,
 					struct sctp_cmd_seq *commands)
 {
+	struct sctp_chunk *err_chk_p = NULL;
 	struct sctp_association *new_asoc;
+	struct sctp_init_chunk *peer_init;
 	struct sctp_chunk *chunk = arg;
 	enum sctp_disposition retval;
-	struct sctp_chunk *err_chk_p;
+	enum sctp_cid cid;
 	int error = 0;
 	char action;
 
@@ -2263,6 +2276,26 @@ enum sctp_disposition sctp_sf_do_5_2_4_dupcook(
 		}
 	}
 
+	/* Compare the tie_tag in cookie with the verification tag of
+	 * current association.
+	 */
+	action = sctp_tietags_compare(new_asoc, asoc);
+
+	if ((action == 'A' || action == 'B') && !sctp_sk(ep->base.sk)->hmac) {
+		peer_init = &chunk->subh.cookie_hdr->c.peer_init[0];
+		cid = peer_init->chunk_hdr.type;
+		if (!sctp_verify_init(net, ep, asoc, cid, peer_init, chunk,
+				      &err_chk_p)) {
+			sctp_association_free(new_asoc);
+			if (err_chk_p)
+				sctp_chunk_free(err_chk_p);
+			return sctp_sf_pdiscard(net, ep, asoc, type, arg,
+						commands);
+		}
+		if (err_chk_p)
+			sctp_chunk_free(err_chk_p);
+	}
+
 	/* Update socket peer label if first association. */
 	if (security_sctp_assoc_request((struct sctp_endpoint *)ep,
 					chunk->skb)) {
@@ -2273,11 +2306,6 @@ enum sctp_disposition sctp_sf_do_5_2_4_dupcook(
 	/* Set temp so that it won't be added into hashtable */
 	new_asoc->temp = 1;
 
-	/* Compare the tie_tag in cookie with the verification tag of
-	 * current association.
-	 */
-	action = sctp_tietags_compare(new_asoc, asoc);
-
 	switch (action) {
 	case 'A': /* Association restart. */
 		retval = sctp_sf_do_dupcook_a(net, ep, asoc, chunk, commands,

-- 
2.43.0


