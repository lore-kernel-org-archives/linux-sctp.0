Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB7B245FFB4
	for <linux-sctp@vger.kernel.org>; Fri, 21 Aug 2026 09:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787303706; cv=none; b=XTngBgECtGovegQO1LIPzJmjtOadVZpe+MgzN7Nk8A7ZSDf9VPpm2tc7mn8rHkV00CRmh06Zrb/Lvx/BD0Ub8dgfc1XEmZAsNuSVaaoXe9Mt8ZNeOGKy13lfG24qw0rWjy5y6+z8b5iqYNM/1sTVHjkTW14EEKu8IWxZ/19nSQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787303706; c=relaxed/simple;
	bh=GpZ7lAZUDDY8mmgO/vLheg8cIkWPWXVTSYi1zgatoFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u9AzGu6yKWZwgVNtVDHSjNqw+gLXFLrO3luRcmD5nN8kFl9aV5DX/isNBmQw97vi0cWlPMKUuZifMD688fPJgZIFji2ZFN5n95gHhBBmSuWCveFBeXZPlrpRp7woZ1lkT3wfMXCrgHA8qZKM3UoF+W1BBHJ+I2/aiN65Yxv16CE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QVpAA3bx; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QVpAA3bx"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2d032846c95so9289475ad.1
        for <linux-sctp@vger.kernel.org>; Fri, 21 Aug 2026 02:14:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787303696; x=1787908496; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cOc1ChBn0Q+8PcoZY23s3bBdWzVEJkQfEsnlzXv9qKY=;
        b=QVpAA3bxGp9+LiYLwG5b62f/C1TOaK00lSTCL2HkoykLlHM0EY3n/sEzikXdPqqnV5
         oV0IFyGG0cvVqqqcwO/MOjBVlCN2luF93mA//GEtf/DegmmkRkwsEx98eNzFVT7olDtu
         CsdsHWWYUU4Mhky6+avo5L4U/f7wRaQuLqW4xQNE37a7woq6r/1YPEvW9B0tyjBQ9TSb
         HbEF7iPfFbUvBc9xmrlO9F4A0uvRU9IzL8+FqQK7dMOl/Vk7yf+CEcGLxKpgLUjipBCR
         GTz4g9FM8W13hB7B4dLD5fOwARfyBVCqr3S15SeuGjFLN43bnEjg17r6Y0ZkYBjzeqUw
         z1Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787303696; x=1787908496;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=cOc1ChBn0Q+8PcoZY23s3bBdWzVEJkQfEsnlzXv9qKY=;
        b=YdD3tQvbe0e2mtFMH1QX7HQv4Quv6Td9mPB3rIh0CRjz9A6Qf3E6gTjeYaBN15hc9x
         T3ZZPs8BwhIWIAbcAzHBdfXOFbvsH9DCSe2ctaz+IAget4T2WlRlYmbMI0TqDur6CAfS
         /DEe53r238ui1e1G8Cs6W/LVjT6X+2qBX7mrYBVKbItMKKKox9wE6y7LF8AnOc1Q9A2i
         NZyPsTlFciuDPB6M/lJ/04znn95BrY8nm3lOxhPI+XbnnmuT5VWNMD+vYBzVgmFg+c5G
         iOsuMvl6tqVduln7kiSMj+sWono1Sl+FMrR0xE9A4OkeGppdJixVf49G5q3sR83F0cNA
         gtHQ==
X-Gm-Message-State: AFuF++kZBiqhYQUQnstKQt7do2H7/zvocrOw/YroVTeEh0MfSPs9GQD2
	R9K+K/8uckD8pviQoxJYM3hZlQEJj3w+I77uge02+/EC9QpHFzalyYjjnAX5SzfhG1y5Dg==
X-Gm-Gg: AR+sD12TYHDxStjQjARVu5o9Tc42fNrKyj4qDYM9Y/aDoKaZSJJwcZd1sWq2lwBIHiy
	ZtFMqcMXKuJbrZR45CqESwTHQFjYa6qhZJfLO71FmfQR8TAHeEs4pLBcx3b1KaRDtsqODioW0++
	WAdRlVE9tNGjg+LylKKL7XN29K1OmF9bcFz9HYb/KLZjVLmize/BGXiBlaGpQYAD7w25GTgCMP+
	lJgu9PLg8y7loLF3APxxZliuMCv4zY0cZR37k2bcwVqA0Tw3Wd+sd4MvuagkBUKd7Yt9R7rqcgj
	wmkbbxlpX9u70+qUMuJ3ZzqH7m6z1qmTonHCmQKQSEtvizx0egeEYivfeV2qYOKKxBBb0PXw6CX
	6n4Ecqf7TqLsoNmevxWXUV0Y+I1Y8zUwR2Nrc8K/XXniEEOsyuSinq6Tfcu8jljHp3hEsZHDdFS
	32DKQ0MRwUDvdJO3cGarY+81+iLnh97T5k2BEL9Y/VekOM1XDtfUTnSXHTdvq3kyZjjSKV2mr2d
	3LQCvEyDhXx2+EKEcaL4Fi1Np+TC3GiZV4=
X-Received: by 2002:a17:902:ec86:b0:2c6:9f66:d573 with SMTP id d9443c01a7336-2d64ae3ac9emr93532155ad.2.1787303695496;
        Fri, 21 Aug 2026 02:14:55 -0700 (PDT)
Received: from JUNVYYANG-MC1.tencent.com ([43.132.141.21])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d62e3cf1e3sm16141265ad.72.2026.08.21.02.14.52
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 21 Aug 2026 02:14:55 -0700 (PDT)
From: Jun Yang <juny24602@gmail.com>
X-Google-Original-From: Jun Yang <junvyyang@tencent.com>
To: linux-sctp@vger.kernel.org,
	netdev@vger.kernel.org
Cc: marcelo.leitner@gmail.com,
	lucien.xin@gmail.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	Jun Yang <junvyyang@tencent.com>,
	stable@kernel.org,
	TencentOS Corvus AI <corvus@tencent.com>
Subject: [PATCH net v3 2/2] sctp: fix stream->outcnt underflow on duplicate RECONF responses
Date: Fri, 21 Aug 2026 17:14:39 +0800
Message-ID: <20260821091440.6496-3-junvyyang@tencent.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260821091440.6496-1-junvyyang@tencent.com>
References: <20260821091440.6496-1-junvyyang@tencent.com>
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A cached RECONF chunk may contain more than one request parameter.  A
duplicate response can therefore find and process the same ADD_OUT request
again while another parameter is still outstanding, rolling back outcnt
twice and possibly underflowing it.

Track outstanding request types as bits and clear each bit after its first
response.  Later responses for the same request are then ignored.

Fixes: 11ae76e67a17 ("sctp: implement receiver-side procedures for the Reconf Response Parameter")
Cc: stable@kernel.org
Reported-by: TencentOS Corvus AI <corvus@tencent.com>
Link: https://lore.kernel.org/netdev/20260730110225.37371-1-juny24602@gmail.com/
Suggested-by: Xin Long <lucien.xin@gmail.com>
Assisted-by: tencentos-corvus-ai:kimi-k3
Signed-off-by: Jun Yang <junvyyang@tencent.com>
---
v3:
 - Split the response_seq == 0 lookup fix into patch 1 (Simon Horman).
 - Keep the request bit helper local to stream.c.

v2:
 - Track outstanding requests by type instead of sequence (Xin Long).
 - Drop the redundant arithmetic guard (Xin Long).

v1: https://lore.kernel.org/netdev/20260730110225.37371-1-juny24602@gmail.com/

 include/net/sctp/structs.h |  2 +-
 net/sctp/stream.c          | 39 +++++++++++++++++++++++++++-----------
 2 files changed, 29 insertions(+), 12 deletions(-)

diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index cccc662..b21f23b 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -2057,7 +2057,7 @@ struct sctp_association {
 	     force_delay:1;
 
 	__u8 strreset_enable;
-	__u8 strreset_outstanding; /* request param count on the fly */
+	__u8 strreset_outstanding; /* request param bitmask on the fly */
 
 	__u32 strreset_outseq; /* Update after receiving response */
 	__u32 strreset_inseq; /* Update after receiving request */
diff --git a/net/sctp/stream.c b/net/sctp/stream.c
index cfca5aa..e1a215d 100644
--- a/net/sctp/stream.c
+++ b/net/sctp/stream.c
@@ -22,6 +22,9 @@
 #include <net/sctp/sm.h>
 #include <net/sctp/stream_sched.h>
 
+#define SCTP_STRRESET_BIT(type) \
+	BIT(ntohs(type) - ntohs(SCTP_PARAM_RESET_OUT_REQUEST))
+
 static void sctp_stream_shrink_out(struct sctp_stream *stream, __u16 outcnt)
 {
 	struct sctp_association *asoc;
@@ -372,7 +375,9 @@ int sctp_send_reset_streams(struct sctp_association *asoc,
 		goto out;
 	}
 
-	asoc->strreset_outstanding = out + in;
+	asoc->strreset_outstanding =
+		(out ? SCTP_STRRESET_BIT(SCTP_PARAM_RESET_OUT_REQUEST) : 0) |
+		(in ? SCTP_STRRESET_BIT(SCTP_PARAM_RESET_IN_REQUEST) : 0);
 
 out:
 	return retval;
@@ -417,7 +422,8 @@ int sctp_send_reset_assoc(struct sctp_association *asoc)
 		return retval;
 	}
 
-	asoc->strreset_outstanding = 1;
+	asoc->strreset_outstanding =
+		SCTP_STRRESET_BIT(SCTP_PARAM_RESET_TSN_REQUEST);
 
 	return 0;
 }
@@ -474,7 +480,9 @@ int sctp_send_add_streams(struct sctp_association *asoc,
 		goto out;
 	}
 
-	asoc->strreset_outstanding = !!out + !!in;
+	asoc->strreset_outstanding =
+		(out ? SCTP_STRRESET_BIT(SCTP_PARAM_RESET_ADD_OUT_STREAMS) : 0) |
+		(in ? SCTP_STRRESET_BIT(SCTP_PARAM_RESET_ADD_IN_STREAMS) : 0);
 
 out:
 	return retval;
@@ -564,13 +572,16 @@ struct sctp_chunk *sctp_process_strreset_outreq(
 	if (asoc->strreset_chunk) {
 		if (!sctp_chunk_lookup_strreset_param(
 				asoc, outreq->response_seq,
-				SCTP_PARAM_RESET_IN_REQUEST, true)) {
+				SCTP_PARAM_RESET_IN_REQUEST, true) ||
+		    !(asoc->strreset_outstanding &
+		      SCTP_STRRESET_BIT(SCTP_PARAM_RESET_IN_REQUEST))) {
 			/* same process with outstanding isn't 0 */
 			result = SCTP_STRRESET_ERR_IN_PROGRESS;
 			goto out;
 		}
 
-		asoc->strreset_outstanding--;
+		asoc->strreset_outstanding &=
+			~SCTP_STRRESET_BIT(SCTP_PARAM_RESET_IN_REQUEST);
 		asoc->strreset_outseq++;
 
 		if (!asoc->strreset_outstanding) {
@@ -669,7 +680,8 @@ struct sctp_chunk *sctp_process_strreset_inreq(
 			SCTP_SO(stream, i)->state = SCTP_STREAM_CLOSED;
 
 	asoc->strreset_chunk = chunk;
-	asoc->strreset_outstanding = 1;
+	asoc->strreset_outstanding =
+		SCTP_STRRESET_BIT(SCTP_PARAM_RESET_OUT_REQUEST);
 	sctp_chunk_hold(asoc->strreset_chunk);
 
 	result = SCTP_STRRESET_PERFORMED;
@@ -816,13 +828,16 @@ struct sctp_chunk *sctp_process_strreset_addstrm_out(
 
 	if (asoc->strreset_chunk) {
 		if (!sctp_chunk_lookup_strreset_param(
-			asoc, 0, SCTP_PARAM_RESET_ADD_IN_STREAMS, false)) {
+			asoc, 0, SCTP_PARAM_RESET_ADD_IN_STREAMS, false) ||
+		    !(asoc->strreset_outstanding &
+		      SCTP_STRRESET_BIT(SCTP_PARAM_RESET_ADD_IN_STREAMS))) {
 			/* same process with outstanding isn't 0 */
 			result = SCTP_STRRESET_ERR_IN_PROGRESS;
 			goto out;
 		}
 
-		asoc->strreset_outstanding--;
+		asoc->strreset_outstanding &=
+			~SCTP_STRRESET_BIT(SCTP_PARAM_RESET_ADD_IN_STREAMS);
 		asoc->strreset_outseq++;
 
 		if (!asoc->strreset_outstanding) {
@@ -899,7 +914,8 @@ struct sctp_chunk *sctp_process_strreset_addstrm_in(
 		goto out;
 
 	asoc->strreset_chunk = chunk;
-	asoc->strreset_outstanding = 1;
+	asoc->strreset_outstanding =
+		SCTP_STRRESET_BIT(SCTP_PARAM_RESET_ADD_OUT_STREAMS);
 	sctp_chunk_hold(asoc->strreset_chunk);
 
 	stream->outcnt = outcnt;
@@ -929,7 +945,8 @@ struct sctp_chunk *sctp_process_strreset_resp(
 
 	req = sctp_chunk_lookup_strreset_param(asoc, resp->response_seq, 0,
 					       true);
-	if (!req)
+	if (!req || !(asoc->strreset_outstanding &
+		      SCTP_STRRESET_BIT(req->type)))
 		return NULL;
 
 	result = ntohl(resp->result);
@@ -1079,7 +1096,7 @@ struct sctp_chunk *sctp_process_strreset_resp(
 			nums, 0, GFP_ATOMIC);
 	}
 
-	asoc->strreset_outstanding--;
+	asoc->strreset_outstanding &= ~SCTP_STRRESET_BIT(req->type);
 	asoc->strreset_outseq++;
 
 	/* remove everything for this reconf request */
-- 
2.55.0

