Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795406949;
	b=b+4H7BEBxNDB86I9zz+CHwddH/bJxeWBK4Ym5HrB+p7P5+OowRee3Xzk/YHpbwJWeLsd
	 3v8/xvVzLwlwIX5CUJG5xJgCstXtj+NZt5jbPf5bU1WqV7I/oRZNRrx416B+FIXhk1WDr
	 JWTSCaTle0RgfDC6ciC8XwaIG6kKlRichqkYLGtB2Da2g7yy961AGShWkWeIrYy1iZ/K6
	 hQna1VJ9B4//ilvk/xLgwYnwd1N/5Mj7X8jF/bffqOr90irmnKTTyK2dfJIOEI1GSJHAG
	 XjTvmiMQOnw+raukMNNdCi87wmyVVZ2XVKoa1W9ZnWSLKDGqMzGY8ud4AbYLoKE+a6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795406949;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0ozgnlts1k6aHVWDS0U58M4CpqFB+e+83aS7nu4uq/U=;
	b=aNyhoXoGCp/cU30Xf7Cq4T52jAqqf1jrpAy2YvwR+G7A0N1BFfyIYyqs8Vmq8gTeBU+2
	 lXSepbP9qdFaKu0GQTowpFKDHWNDQDayRObzwYL5Wf0ujLR9wSf/Ak7xfjhUQLsIuzntJ
	 4hYLVIieS9nno0TI01IQxGcdGGTHR+6dlTRr+ZGSZzVfTRnxrWzF5nmz8izQ0NQtiZWvw
	 SqI6PDXC3llWlXmgtQkUppgO5NGMg5HQQ3CK+nMgWhrztG7Vp254omCoWq4r1Y8heNmWs
	 t22ApHzjQT2d8fdsKX6YEMb/SFbkNY+LPTvU8H4zChpMm42syQevfKZJ+T9QkBC+HWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="f/feW676";
	arc=none smtp.remote-ip=74.125.82.177
Received: from mail-dy1-f177.google.com (mail-dy1-f177.google.com [74.125.82.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45E31606A685
	for <linux-sctp@vger.kernel.org>; Mon, 23 Nov 2026 04:09:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 45E31606A685
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=f/feW676
Received: by mail-dy1-f177.google.com with SMTP id 5a478bee46e88-38644aedba1so4093824eec.0
        for <linux-sctp@vger.kernel.org>; Sun, 22 Nov 2026 20:09:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795406948; x=1796011748; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0ozgnlts1k6aHVWDS0U58M4CpqFB+e+83aS7nu4uq/U=;
        b=f/feW676kYcNLohQrSt9t33eRTFRAHP7p89OYGFI07b8sAo1pE6G1FmaTxhlUEl5YY
         g4nhePLzBmIeh3nfKRv9Lwnwva4ZZEQ5Le4Ldcd07LWcw28zYqEzKUAwEB0nr1jz6im7
         60x+EcLa7V+qTzq29bcZEpSePWWAx7yP041SqeDc8eHv80LjfKm/u2m62nihImZn79Oo
         gelQrzpiNSjcVqecuhqdrGNk2s9wKZc2KNG/7Qguf2AFGWexspMMhQOOuvFUElvOcpaG
         LrhXwuxwL2sYJoCu+dFAothWGwRGQ3fzhpBoNspdhK9Bo7SoPszxFXjjpvkNyKiu5I/I
         Fkow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795406948; x=1796011748;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=0ozgnlts1k6aHVWDS0U58M4CpqFB+e+83aS7nu4uq/U=;
        b=flQutKdbsxQETbV3ILyborBrvfVDQ56dewZjyMaZvyXGokoSssBu8HFsw8D6NB0I1t
         Xq7kDWYQwDhGWoiTKKrMJePkGhHbtTwD2y/G5r9Az0ElCWGLTmzOtt+eTUTNzKnusv84
         9A6kDss896g+JcYRpVOewv2n+kqeo1p9MjsRi5t/DPG1TQiha61blGXYoE0oQb6NDCPK
         htoXfDPKDYR6/JLPw2dhx2RSzhODZJnZaZaE91+yIXobwtXTbnLhyvY/s6AyhV22v9No
         OElkGUMbHz/ZCUOuA2Y4941lyS3vQnUoY9/J3RCTLVEtAM+6pOIotNj0TPd6iDVbJ0FK
         vcxA==
X-Forwarded-Encrypted: i=1; AL+hErECv24Ir/IPr8ipG9eHe3m81oqRRnecr5U10h1fNxLPiQopGXlz0M6uipS7YslA93T+B7xMaILgfkD7@vger.kernel.org
X-Gm-Message-State: APuU4Z+EjD4FBHGm3C9p8TMffCq0x39LB0/VZcfsORPMQCKQm1fXVhHY
	E5qaXlwpKAdRWKXRbM6gWxmarO3hm2lJgVzi+XQaG7wWw2WfF62jmskm
X-Gm-Gg: AZFdTZedggecj/7Gyx9EcgxIwSy9xLHw0Ny6NZwl6DzzxbP+WFehqhjcOgXRzmUeCTc
	tcMEwPmoBkEgqle9cOMseshjaKY1+SNdpvhBaZ/0XZigQtI8tv5AdpEFNu8/Mpxaai9R7rS9Pfd
	bN+E1CBdAkOegbM5EoNuuUA6RFybf/HsHTAT7/OBFJJESSrY0lIpQ2CfJ7OO7/ENTLYj7Is6l/l
	8NXjUpx9LZNuXrwvgYGwBYy2fcPoXkI0tPwUggH2XslpWF5oFimJSYJuyHXlSjtA27I21cUthRd
	qsYsTkvbjvrvCKUJ4K8VRjWvmsPcCvSlGzScq9/W8VthboeiEfCO/fYIwvzmGzHEOFOdjxLMrCS
	9VuvAgSb1nX9R890Mcg1ukItxvBWUGbz4z3U7uVHtpEXvr1CSVlD38avh2HhsTYftk3G8h1tC9P
	40W7Lq9v8Sy8y0xsgMmxN0KeXoZwtSMsvTvNzE7qgqtAxAxGwOzVYjNtdupPvoLak3afFa/+q2l
	6g5SEshVWvQEIvw5SHSBAAeZWNe5NI1tt9X33o5VrsvBTJCzMJaKla1QnSv6XgoGzIHsiH4jrMA
	lCGCaMGbXC50QhM5SCgWyAJE9HRCAmEUUl17h8gsd1+/N2gtg8QFWs1b/d78lU/gRqE=
X-Received: by 2002:a05:7301:6184:10b0:386:a9d3:6ce8 with SMTP id 5a478bee46e88-386a9d36dafmr3264927eec.7.1795406948364;
        Sun, 22 Nov 2026 20:09:08 -0800 (PST)
Received: from d20be28ee783.tail196be.ts.net (vldb.skku.ac.kr. [115.145.173.180])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-385677c0c1dsm33451547eec.21.2026.11.22.20.09.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2026 20:09:08 -0800 (PST)
From: Kyuwon Cho <kyuwoncho18@gmail.com>
To: Xin Long <lucien.xin@gmail.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Willem de Bruijn <willemb@google.com>,
	Jun Yang <junvyyang@tencent.com>,
	linux-sctp@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net v3 1/1] sctp: fail the association when the INIT-ACK cannot be processed
Date: Mon, 23 Nov 2026 13:09:00 +0900
Message-ID: <179539544818.3016044.18009252996572506068@gmail.com>
In-Reply-To: <179539544818.3016044.13738712075053349592@gmail.com>
References: <179539544818.3016044.13738712075053349592@gmail.com>
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Post: <mailto:linux-sctp@vger.kernel.org>
List-Help: <mailto:linux-sctp+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sctp+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

sctp_sf_do_5_1C_ack() queues SCTP_CMD_PEER_INIT and SCTP_CMD_ASSOC_SHKEY.
If either fails to allocate memory, sctp_cmd_interpreter() stops there,
but the association stays: with the peer marked AUTH capable and
asoc->shkey still NULL, a chunk that the peer wants authenticated, such
as the ABORT built by close() with SO_LINGER {1, 0}, takes a reference
on the NULL key:

  BUG: KASAN: null-ptr-deref in sctp_auth_shkey_hold (net/sctp/auth.c:113)
  Write of size 4 at addr 0000000000000018
  Call Trace:
   sctp_auth_shkey_hold (net/sctp/auth.c:113)
   sctp_control_set_owner_w (net/sctp/sm_make_chunk.c:112)
   sctp_make_abort_user (net/sctp/sm_make_chunk.c:1016)
   sctp_close (net/sctp/socket.c:1564)

Process the INIT-ACK and set up the association key directly in
sctp_sf_do_5_1C_ack(), and fail the association if either step fails.
SCTP_CMD_PEER_INIT and SCTP_CMD_ASSOC_SHKEY have no other users, so
remove them.

Fixes: 1b1e0bc99474 ("sctp: add refcnt support for sh_key")
Suggested-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Kyuwon Cho <kyuwoncho18@gmail.com>
---
 include/net/sctp/command.h |  4 ----
 net/sctp/sm_sideeffect.c   | 40 --------------------------------------
 net/sctp/sm_statefuns.c    | 15 +++++++++++---
 3 files changed, 12 insertions(+), 47 deletions(-)

diff --git a/include/net/sctp/command.h b/include/net/sctp/command.h
index 2058fabffbf6..8596e96c321a 100644
--- a/include/net/sctp/command.h
+++ b/include/net/sctp/command.h
@@ -34,7 +34,6 @@ enum sctp_verb {
 	SCTP_CMD_GEN_SACK,	/* Send a Selective ACK (maybe).  */
 	SCTP_CMD_PROCESS_SACK,	/* Process an inbound SACK.  */
 	SCTP_CMD_GEN_INIT_ACK,	/* Generate an INIT ACK chunk.  */
-	SCTP_CMD_PEER_INIT,	/* Process a INIT from the peer.  */
 	SCTP_CMD_GEN_COOKIE_ECHO, /* Generate a COOKIE ECHO chunk. */
 	SCTP_CMD_CHUNK_ULP,	/* Send a chunk to the sockets layer.  */
 	SCTP_CMD_EVENT_ULP,	/* Send a notification to the sockets layer. */
@@ -86,7 +85,6 @@ enum sctp_verb {
 	SCTP_CMD_ASSOC_CHANGE,	 /* generate and send assoc_change event */
 	SCTP_CMD_ADAPTATION_IND, /* generate and send adaptation event */
 	SCTP_CMD_PEER_NO_AUTH,   /* generate and send authentication event */
-	SCTP_CMD_ASSOC_SHKEY,    /* generate the association shared keys */
 	SCTP_CMD_T1_RETRAN,	 /* Mark for retransmission after T1 timeout  */
 	SCTP_CMD_UPDATE_INITTAG, /* Update peer inittag */
 	SCTP_CMD_SEND_MSG,	 /* Send the whole use message */
@@ -117,7 +115,6 @@ union sctp_arg {
 	struct sctp_association *asoc;
 	struct sctp_transport *transport;
 	struct sctp_bind_addr *bp;
-	struct sctp_init_chunk *init;
 	struct sctp_ulpevent *ulpevent;
 	struct sctp_packet *packet;
 	struct sctp_sackhdr *sackh;
@@ -158,7 +155,6 @@ SCTP_ARG_CONSTRUCTOR(CHUNK,	struct sctp_chunk *, chunk)
 SCTP_ARG_CONSTRUCTOR(ASOC,	struct sctp_association *, asoc)
 SCTP_ARG_CONSTRUCTOR(TRANSPORT,	struct sctp_transport *, transport)
 SCTP_ARG_CONSTRUCTOR(BA,	struct sctp_bind_addr *, bp)
-SCTP_ARG_CONSTRUCTOR(PEER_INIT,	struct sctp_init_chunk *, init)
 SCTP_ARG_CONSTRUCTOR(ULPEVENT,  struct sctp_ulpevent *, ulpevent)
 SCTP_ARG_CONSTRUCTOR(PACKET,	struct sctp_packet *, packet)
 SCTP_ARG_CONSTRUCTOR(SACKH,	struct sctp_sackhdr *, sackh)
diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
index 35f540fb15fc..a95bf10b852b 100644
--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -698,32 +698,6 @@ static void sctp_cmd_assoc_failed(struct sctp_cmd_seq *commands,
 	sctp_add_cmd_sf(commands, SCTP_CMD_DELETE_TCB, SCTP_NULL());
 }
 
-/* Process an init chunk (may be real INIT/INIT-ACK or an embedded INIT
- * inside the cookie.  In reality, this is only used for INIT-ACK processing
- * since all other cases use "temporary" associations and can do all
- * their work in statefuns directly.
- */
-static int sctp_cmd_process_init(struct sctp_cmd_seq *commands,
-				 struct sctp_association *asoc,
-				 struct sctp_chunk *chunk,
-				 struct sctp_init_chunk *peer_init,
-				 gfp_t gfp)
-{
-	int error;
-
-	/* We only process the init as a sideeffect in a single
-	 * case.   This is when we process the INIT-ACK.   If we
-	 * fail during INIT processing (due to malloc problems),
-	 * just return the error and stop processing the stack.
-	 */
-	if (!sctp_process_init(asoc, chunk, sctp_source(chunk), peer_init, gfp))
-		error = -ENOMEM;
-	else
-		error = 0;
-
-	return error;
-}
-
 /* Helper function to break out starting up of heartbeat timers.  */
 static void sctp_cmd_hb_timers_start(struct sctp_cmd_seq *cmds,
 				     struct sctp_association *asoc)
@@ -1397,16 +1371,6 @@ static int sctp_cmd_interpreter(enum sctp_event_type event_type,
 					SCTP_CHUNK(new_obj));
 			break;
 
-		case SCTP_CMD_PEER_INIT:
-			/* Process a unified INIT from the peer.
-			 * Note: Only used during INIT-ACK processing.  If
-			 * there is an error just return to the outter
-			 * layer which will bail.
-			 */
-			error = sctp_cmd_process_init(commands, asoc, chunk,
-						      cmd->obj.init, gfp);
-			break;
-
 		case SCTP_CMD_GEN_COOKIE_ECHO:
 			/* Generate a COOKIE ECHO chunk.  */
 			new_obj = sctp_make_cookie_echo(asoc, chunk);
@@ -1772,10 +1736,6 @@ static int sctp_cmd_interpreter(enum sctp_event_type event_type,
 			sctp_cmd_peer_no_auth(commands, asoc);
 			break;
 
-		case SCTP_CMD_ASSOC_SHKEY:
-			error = sctp_auth_asoc_init_active_key(asoc,
-						GFP_ATOMIC);
-			break;
 		case SCTP_CMD_UPDATE_INITTAG:
 			asoc->peer.i.init_tag = cmd->obj.u32;
 			break;
diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 6a4205de0aa6..fd9f94c12d42 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -603,13 +603,22 @@ enum sctp_disposition sctp_sf_do_5_1C_ack(struct net *net,
 
 	initchunk = (struct sctp_init_chunk *)chunk->chunk_hdr;
 
-	sctp_add_cmd_sf(commands, SCTP_CMD_PEER_INIT,
-			SCTP_PEER_INIT(initchunk));
+	if (!sctp_process_init((struct sctp_association *)asoc, chunk,
+			       sctp_source(chunk), initchunk, GFP_ATOMIC)) {
+		sctp_add_cmd_sf(commands, SCTP_CMD_INIT_FAILED,
+				SCTP_PERR(SCTP_ERROR_NO_RESOURCE));
+		return SCTP_DISPOSITION_CONSUME;
+	}
 
 	/* SCTP-AUTH: generate the association shared keys so that
 	 * we can potentially sign the COOKIE-ECHO.
 	 */
-	sctp_add_cmd_sf(commands, SCTP_CMD_ASSOC_SHKEY, SCTP_NULL());
+	if (sctp_auth_asoc_init_active_key((struct sctp_association *)asoc,
+					   GFP_ATOMIC)) {
+		sctp_add_cmd_sf(commands, SCTP_CMD_INIT_FAILED,
+				SCTP_PERR(SCTP_ERROR_NO_RESOURCE));
+		return SCTP_DISPOSITION_CONSUME;
+	}
 
 	/* Reset init error count upon receipt of INIT-ACK.  */
 	sctp_add_cmd_sf(commands, SCTP_CMD_INIT_COUNTER_RESET, SCTP_NULL());
-- 
2.43.0

