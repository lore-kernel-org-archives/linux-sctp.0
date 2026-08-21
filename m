Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84DF645C6E1
	for <linux-sctp@vger.kernel.org>; Fri, 21 Aug 2026 09:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787303702; cv=none; b=bwUJtbmpGXTRdwq3AoqCBleTAbDKX1a+9sIrZKTLKshipVxyUi+LFaOKLylLUAuDaJO1VyIQH3PgTU60ZhF6hxovvoCLmYBjD9dxGx0nC0DYy09yjNuDm0rXO1qBasv8/MQlS1qTmVhrSqLllwV589cg4xo89uAAHbSwI4fRRmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787303702; c=relaxed/simple;
	bh=IyXGt2ZSy4sETXIQk6DSHHTYPvjHyrUfSyePcJ43eVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ttxdoiJF1PnulWMuwX9iVUqPykHKS0nWeYyPlfqoL/RXDiuNXLiB+0yl2QRJLCbyTPM0rhtooKMSjs+L7n5mJfNlWN3e2hG4BIr5gzzac1nuH2nheU32krclmFu40RmCpAhOlJjh+JuKSb+v1xLeL7vXjxGXA4ow/KZLyPOqG/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RzN+iTtU; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RzN+iTtU"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2cc891373e0so9314095ad.2
        for <linux-sctp@vger.kernel.org>; Fri, 21 Aug 2026 02:14:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787303692; x=1787908492; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yfIdkNcKfvVQpLEPJy8UErg0t5uwffjw8yyhEsQ9/OQ=;
        b=RzN+iTtUDFK+ziFjD0zeOJExhOdFAggpB98qpEAo6PQyZ7lHYfVVXz5ApoHmYAXcXN
         eXZRuHjjnuX57mg5jdlEoVMuwjK5EzfbZWNzqIjTru4RRoGiWEeRTU5v7HezznDl3NZL
         nZhVEEJbqgXwLR8Pi4Bgsvnh7obOxQmpCyRyuh1Ui/6WuyghoNZWLVMXN2Qr7vK2fVo/
         sfbua91lGsi1g7sOV4HYLkrLEzFPJzuC+26NScxQ4sqkp8D4vR4rRAHSnDiYXtFRykrN
         ZEfl+h+yT7M4uN6MpKP3ksYk8m3kxhwQ3HOPJzCrG7zCPwoNMIy4Zvs+JffTng5qFUUw
         ++Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787303692; x=1787908492;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=yfIdkNcKfvVQpLEPJy8UErg0t5uwffjw8yyhEsQ9/OQ=;
        b=nhy13tmkY8JWF8OUoeJIuJXU601SOJFAHBdP0DrssTsvaak9JegyigJlsFpEvJ9f4U
         +3JhgWa2SEAeIpmMRY9E6RBSg94IGggiq7AXwaPAQ2JMpbFxQnm2zLf9T8+6cr7WMZ+5
         MXv5253YfB78S3+fEwqkxTlQkwBKYnjfxTC/XSlGN12hd+e3J5k5S7OMHnx+8IWwfnqM
         YE+mNa0S6IMZ7sZKfpDLJU3WcTcq4ifuiQG1xzfPMg4HVNiiF9m0VQ44c6DVqVyjywe4
         jz1WXGBBr+6F3EtQnNxGRLfGs0GcskDfVqVBzWx9w3Cjf99Kk+hjUwnJOGdpvN4Cwn0o
         dviA==
X-Gm-Message-State: AFuF++mMTeBRDZuZseHZpBC/9+VngsAHWzHMEMMcUqZ3NEsNpQqRSdOL
	WOYt8L2d8/UYHKO34AYuM1mx34rljHF1no2/VoROCe8YtpB/2E7Uw1nTJnRj23NEIDI=
X-Gm-Gg: AR+sD11ZCH5q0nnZtebLwrqBvrnEMfaa1l0dzFgXdK7jhmDzgp4zFeJ6ZcBx1r7/+mt
	Ej/yTS34kBASeZsBVypDg5hRNspDlxDZRs7dEyPx6Bc8LcNbU+GAUkmm9b3YOE2DmR1kVeVDULL
	tdY4npJcns0y3h5GfNZrdhnkNiBDsDO71skF2MWvotDbVI0FGyQpM8l50E7kOMnc01W/eZMncHr
	bH9UfBZqQWTUFW2Sjdsj2iWgOw5Bq4DWQixzSbqdNJnC6NgqFgW9jeyTLFkq8Y9UG4dNLvgKKRM
	VfP4zmTD9YqZL3+V/fnqh8C3fCK42YfZWgCV0NBfhIzpVeXEBaqzNg4SxHc0UIfpj0gSGolSIbs
	itEgiAPripTDZosiEzCdQtqzQEwQQ8GlMpPc1EfNM2M7EagGVZRXDxRefDVYSjjm3WN56mAyTF3
	A0EltotVeFDsVY6OIjNze0VRRnJKEJ3dV2mKqNoSAkn+9nOZJiV949hwhoNp7ao6QlZ9NKrceQs
	yvvOy/GLr0y/8bUOdH1m9aX7bej4w==
X-Received: by 2002:a17:903:ac4:b0:2d5:2f49:b3de with SMTP id d9443c01a7336-2d64a9f17ddmr106018705ad.0.1787303692407;
        Fri, 21 Aug 2026 02:14:52 -0700 (PDT)
Received: from JUNVYYANG-MC1.tencent.com ([43.132.141.21])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d62e3cf1e3sm16141265ad.72.2026.08.21.02.14.49
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 21 Aug 2026 02:14:51 -0700 (PDT)
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
	stable@kernel.org
Subject: [PATCH net v3 1/2] sctp: distinguish sequence zero from wildcard in reconf lookup
Date: Fri, 21 Aug 2026 17:14:38 +0800
Message-ID: <20260821091440.6496-2-junvyyang@tencent.com>
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

Zero is a valid response sequence after strreset_outseq wraps, but
sctp_chunk_lookup_strreset_param() currently treats it as a wildcard.

Add match_seq so response lookups match zero exactly while the one
type-only lookup can still ignore the sequence.

Fixes: 50a41591f110 ("sctp: implement receiver-side procedures for the Add Outgoing Streams Request Parameter")
Cc: stable@kernel.org
Suggested-by: Simon Horman <horms@kernel.org>
Signed-off-by: Jun Yang <junvyyang@tencent.com>
---
 net/sctp/stream.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/sctp/stream.c b/net/sctp/stream.c
index 34ffe6c..cfca5aa 100644
--- a/net/sctp/stream.c
+++ b/net/sctp/stream.c
@@ -482,7 +482,7 @@ out:
 
 static struct sctp_paramhdr *sctp_chunk_lookup_strreset_param(
 			struct sctp_association *asoc, __be32 resp_seq,
-			__be16 type)
+			__be16 type, bool match_seq)
 {
 	struct sctp_chunk *chunk = asoc->strreset_chunk;
 	struct sctp_reconf_chunk *hdr;
@@ -499,7 +499,7 @@ static struct sctp_paramhdr *sctp_chunk_lookup_strreset_param(
 		 */
 		struct sctp_strreset_tsnreq *req = param.v;
 
-		if ((!resp_seq || req->request_seq == resp_seq) &&
+		if ((!match_seq || req->request_seq == resp_seq) &&
 		    (!type || type == req->param_hdr.type))
 			return param.v;
 	}
@@ -564,7 +564,7 @@ struct sctp_chunk *sctp_process_strreset_outreq(
 	if (asoc->strreset_chunk) {
 		if (!sctp_chunk_lookup_strreset_param(
 				asoc, outreq->response_seq,
-				SCTP_PARAM_RESET_IN_REQUEST)) {
+				SCTP_PARAM_RESET_IN_REQUEST, true)) {
 			/* same process with outstanding isn't 0 */
 			result = SCTP_STRRESET_ERR_IN_PROGRESS;
 			goto out;
@@ -816,7 +816,7 @@ struct sctp_chunk *sctp_process_strreset_addstrm_out(
 
 	if (asoc->strreset_chunk) {
 		if (!sctp_chunk_lookup_strreset_param(
-			asoc, 0, SCTP_PARAM_RESET_ADD_IN_STREAMS)) {
+			asoc, 0, SCTP_PARAM_RESET_ADD_IN_STREAMS, false)) {
 			/* same process with outstanding isn't 0 */
 			result = SCTP_STRRESET_ERR_IN_PROGRESS;
 			goto out;
@@ -927,7 +927,8 @@ struct sctp_chunk *sctp_process_strreset_resp(
 	struct sctp_paramhdr *req;
 	__u32 result;
 
-	req = sctp_chunk_lookup_strreset_param(asoc, resp->response_seq, 0);
+	req = sctp_chunk_lookup_strreset_param(asoc, resp->response_seq, 0,
+					       true);
 	if (!req)
 		return NULL;
 
-- 
2.55.0

