Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795150512;
	b=iYjWbC4syep4L2qkj7lA3rFsFIny9aj1qiVkNmBY63Ijap+PPbpav+Nmoj4nqvhhZd/I
	 iwPwHX0gHjF1Ig0Amzjs+9lLP9SF0fxDkk17uGThhvllBsTMQlCC/fVfD6Jrdgr60hRvl
	 gLxGOGkoC4kWoEqEWlHgYfUXUKaSaUdp9bQ7w1CckP3mupOj5NAiD2Fxxlu28Y2xpF8us
	 Zs4KWFrR8KhOsQxsuHgkqExjSADnAf6tapsFLLRMuwE6f0mzBfRw24DtLPvdY4c83QDMW
	 0pQ5LGECuIb301wUT9WUM86//1jzKbdDCZT6MEm5vZCSGhFx8HNe4APlck1dnGQE1EQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795150512;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=b425B+NzbMYveC6zvY2QQ/ZSXAP0RoAZgNUrzyAtO5M=;
	b=yV8RUgnZffYvcv+qRPzscRRW1Lcl3sVvrtPXpi517yWcoxeO6FaHSfQqNfBcHv4069mN
	 +Wk7xym8gcXu2+7BRK487a/zm/G39ybkIklEgv2X0BeF9ye00xWX9JsfCSAjxpZ65EfAL
	 mVhmlfvMmgVjZRMAt1g0wQF0yDRSYVDi8Puk4TvkvZbY3Fp7hNwqDq4mgwcXv9RbagkD0
	 VVrRHUt4DMXDrvfwXmK5wcP+TaRd/e6CW2MwPeTcCl5UMgGkpOmnZu0mMzDbshCeU8uo7
	 i0UUdOo/eHzfT53fp4aMPgyH0lFmBheADcJuI302veOq06FNLy25Qiq5PRWdzQGsRvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=OQRXPFvg;
	arc=none smtp.remote-ip=74.125.82.171
Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C108606A32C
	for <linux-sctp@vger.kernel.org>; Fri, 20 Nov 2026 04:55:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1C108606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=OQRXPFvg
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-372bdb942dbso622349eec.1
        for <linux-sctp@vger.kernel.org>; Thu, 19 Nov 2026 20:55:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795150511; x=1795755311; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=b425B+NzbMYveC6zvY2QQ/ZSXAP0RoAZgNUrzyAtO5M=;
        b=OQRXPFvgbSwnd0BPSVz+i9nknnhmYWeFGubuUys7HEd6bnKi0+1wqaw/Ohfnu/Rkdf
         kuOzX/bj3K7AJmAykWhiOu6PgZbsW7xhW9BgzvAjYX488lOYW3I1SWiW7e+7e5Ro/N5d
         H19ndzy3r34Zp3pzZHbMAUXtc5qkMtf4ZDdK4ki3t4Pn/qwN5tpRJJnuRuAGrtf9O9LG
         DFRRt7jj3+qtim4U5zMajd9708s+FbCybT4f7GA4ef4U6Q+HJJoFaShk3Em8hVh9DHyy
         xhmuQz5Ux3uR4kKOeuZxH8AaC7FAaSog9Q7IAgJBLt/JqQVlAuRd81bmCeisAFyUO43p
         NNIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795150511; x=1795755311;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=b425B+NzbMYveC6zvY2QQ/ZSXAP0RoAZgNUrzyAtO5M=;
        b=Q3nBCDtDk7rwGsmcw5rUBsMcFEHnoQafPlXDQAuGkGiYaB8tA4OwCo5bxx7fNibQkL
         a8mXJ4kIrjyWJWGiKygFoqBR6AQJ3HseAcVyq53DQ6Hao3wBIxvO12BYVM2eEaHUrRzn
         zckjd+5jm6LQV20VZvZaObi4WA2VyMLjqqWOHMPCUc5Fo5jLlhQT94bBuvOV1vsNndOG
         7sueiWj+UIGUaRtm0mHDC4GOpek2I1SjL1pg8YUkNrRSRo9KlV0lEWE+6wwhYT9ogkfL
         jSg5/v8q9MH8zuf/z54ZvP4W/jzXtMLqIl0qjle37rTbZiEBk3UAvc3hGA8YK95MOi5c
         Ge1A==
X-Forwarded-Encrypted: i=1; AL+hErGM20mQOLqQdx3bso2a7z4wyYcEI2ZpAO2VT9BBFrU3UwNWrC2iB9Cv5NPyckeq+JeqL1IjGL+YeNJJ@vger.kernel.org
X-Gm-Message-State: APuU4Z9ZXTEYo63WA5ebZp1Kn2fEhHQ6W+SPKbq1LZRL9uKI2Crk/scU
	98RvHN1ns2NsZiP79krOe50UjVua3+3eJqIfin6aVVWEmvsXnc2jS+En
X-Gm-Gg: AZFdTZfrXNnOjYU3cRv7A2Jwmt0kKoonfYM2IlggRtXenmvxMlX2+njRDEaIuILdW9+
	tF/T+o3Zt8aKmLuEa+IaZnQQ+L8bnmYKCKE/oYK0eVJQPPRVGxJxcbh5AXiwpvmdO/kOaKOCcZU
	PtBrIqrczEZbe5sebsonAf/kC6BBHj3WCOMMToDSFDyjM1RU3fmZzYd1GrJ+pltXzXBm1bFpo0N
	R8ZDtvKpW/qauvJKdfu94/UfseRroMYJrE0zn/D5ATq2B/HNkt9ysyBXoZhsjbs3coeP/iYqlS6
	LJtttoIQjQbqYv30nyceSI7eUU2qO3rDsKVKI/6a7Rw0AYYJ60z4ResVdS9l8uZ9XrO5FC8v6Os
	r4HC9n2TvfbGLKJUpmZUP+NoucTxVhGKCV76Co6c4G53149U+mvZdS4a31yF1Ln5KJp/7FnX1NB
	gvK1ZrTCVu7c5GOMuyT2hXNfz1CkR/k/ggmmQx4ZfaTqWluSmc1TwbosOmw217nQ0qU3NlPp0cv
	xC/ncUS1IlaHDGj4sRh263sxC4lBVM72DkZbcU+KttBzW6U/93XYr6Kywj8UXVDPZ2kQqnIwKUW
	DT+ovB2T1Z8rhk0FofgPMk/PVxXcDMjSuF6jbAM7w5LfQzbUn7XXF4W63sxxo0p+X/U=
X-Received: by 2002:a05:7300:c7c4:b0:376:13e5:e8fe with SMTP id 5a478bee46e88-3856c4b839cmr1475580eec.3.1795150511071;
        Thu, 19 Nov 2026 20:55:11 -0800 (PST)
Received: from d20be28ee783.tail196be.ts.net (vldb.skku.ac.kr. [115.145.173.180])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-385646632b9sm3623340eec.1.2026.11.19.20.55.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 20:55:10 -0800 (PST)
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
Subject: [PATCH net v2] sctp: fail the association when the INIT-ACK cannot be processed
Date: Fri, 20 Nov 2026 13:55:05 +0900
Message-ID: <179514851805.604157.8527055700821138420@gmail.com>
In-Reply-To: <CADvbK_citvtZ4eumLcx_szUvth7sQMP1oKu0mLbo0a3bD-eSxQ@mail.gmail.com>
References: <CADvbK_citvtZ4eumLcx_szUvth7sQMP1oKu0mLbo0a3bD-eSxQ@mail.gmail.com>
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
v2:
- As Xin suggested, process the INIT-ACK and set up the association key
  directly in sctp_sf_do_5_1C_ack() and fail the association with
  SCTP_CMD_INIT_FAILED, instead of skipping AUTH in sctp_auth_send_cid().
  Remove SCTP_CMD_PEER_INIT and SCTP_CMD_ASSOC_SHKEY.
v1: https://lore.kernel.org/netdev/179505710266.3511678.14017674052424733262@gmail.com/

The patch was written with LLM assistance; we reviewed and tested it.
With it, the reproducer from the report no longer triggers the report,
also when the injected failure hits sctp_process_init() instead of the
association key.

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
index 64519fd8f943..598eafdc5261 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -603,13 +603,22 @@ enum sctp_disposition sctp_sf_do_5_1C_ack(struct net *net,
 
 	initchunk = (struct sctp_init_chunk *)chunk->chunk_hdr;
 
-	sctp_add_cmd_sf(commands, SCTP_CMD_PEER_INIT,
-			SCTP_PEER_INIT(initchunk));
+	if (!sctp_process_init((struct sctp_association *)asoc, chunk,
+			       sctp_source(chunk), initchunk, GFP_ATOMIC)) {
+		sctp_add_cmd_sf(commands, SCTP_CMD_INIT_FAILED,
+				SCTP_U16(SCTP_ERROR_NO_RESOURCE));
+		return SCTP_DISPOSITION_CONSUME;
+	}
 
 	/* SCTP-AUTH: generate the association shared keys so that
 	 * we can potentially sign the COOKIE-ECHO.
 	 */
-	sctp_add_cmd_sf(commands, SCTP_CMD_ASSOC_SHKEY, SCTP_NULL());
+	if (sctp_auth_asoc_init_active_key((struct sctp_association *)asoc,
+					   GFP_ATOMIC)) {
+		sctp_add_cmd_sf(commands, SCTP_CMD_INIT_FAILED,
+				SCTP_U16(SCTP_ERROR_NO_RESOURCE));
+		return SCTP_DISPOSITION_CONSUME;
+	}
 
 	/* Reset init error count upon receipt of INIT-ACK.  */
 	sctp_add_cmd_sf(commands, SCTP_CMD_INIT_COUNTER_RESET, SCTP_NULL());
-- 
2.43.0

