Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793089946;
	b=Nn4CyrN5BFUx4JpcmgK531wBpQpY+27WowPk53NNCyRtGYZanz8EZk5z76z9JmttLXfj
	 AQvBafJ5IFPw5FXcduu84g8TG1HqEDRpOkJyYN8Cx6GJd1DqXJOKNZ8e0kkiRU8n11tfA
	 LCGiypWgBKg5kJPlic4O2bOhWuFfvGTypidcLjo2+LZ8gKW4PHFR56Ds5XVasCvm/QmE0
	 JOY7BGV2fIqaEGCMDDNXThV9ROpp1vp+FkMlLYVS50sxEc7cgM2M3XYMKLbk+EDbSLvk+
	 O5rqiOlyij2iySo+BLIEU6M598QC6LJzJiM4K+DyRQSqx31TrbIAIZIEl67IjZplQkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793089946;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=bBDjCRfYv01l5K9nHrY3/Hd2EiV/PHl9OnpVwXCk3ew=;
	b=jrr/CI8/O1+jQEYLKmAMt9hPD2UwjuivAqis5GDtytZv+s370tEGpLo1NoqE/V/Oons8
	 QHoppsy/Lpk+vGVWhxIupg/VDZNYkiJwFaaU7ggROj+46EZupGM9qZT3AmvZwzGhhZF66
	 5Yg+nB1WP45qjHiXZ8+HjopMw8rv+pwAEdjOyAXfO3/pki7pLOwn0QVsgUTOAbX5or2nk
	 ZjmIibU+kWRbx5ewKIYLbudTdjNab0MFo4eIfkMnUbAZCwpaB6vHxqpU2dq3Fzmw/kkm5
	 oICYBdNTTqoo0b0SD1gfBG3D2AeuSjkyKC0kruk0hA88bt91OXxRnMUDyTE7T/xnawg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=JGPWpZne;
	arc=none smtp.remote-ip=209.85.215.179
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 974A2606A31E
	for <linux-sctp@vger.kernel.org>; Tue, 27 Oct 2026 08:32:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 974A2606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=JGPWpZne
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-cc758830601so2380393a12.2
        for <linux-sctp@vger.kernel.org>; Tue, 27 Oct 2026 01:32:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793089946; x=1793694746; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=bBDjCRfYv01l5K9nHrY3/Hd2EiV/PHl9OnpVwXCk3ew=;
        b=JGPWpZnejBl2k0E3x5C6PtwzodNl+Q6b5PjhKtsnInQyZ9bj2wkbTtLyQLZAowYhh+
         5VJM/JanbOo9njybFJ2DtZ28HRUDUyyqMPexFCPDyRFJ05VYZdlPn0g6m92b6zow6/k0
         PlQRpYhg/LeNrmbo0xy3ezH/CSGJ9Qce7+SegQRopKlzGMqP3202+L7N5xweQTOwDB8O
         KQsh54mTMnqvlHdLmMkf9ON9q1xGT8HFNoeYDZ4LOdzLXVYYBrkQoJ/XBZdk5EGkKD9T
         mai0dKeO8Y1pinqQZXi+FkGAN9IwN3Y+Q4kenrHua35qOCJAMYWb4qYP22np3BhqfBwF
         kVIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793089946; x=1793694746;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bBDjCRfYv01l5K9nHrY3/Hd2EiV/PHl9OnpVwXCk3ew=;
        b=JQ0Ye2s/PQxm5mHsdtlqAIBsfIp1/hCwkTW31VOG5yRJLqaGmOlr/OFmw27fgtO00+
         bXXNczg4v8c6lPCFMouM+HBSrcsqmDIO1bPpNGnd+ZfVtLF4V3AQ6ema4DXvqOTU1v5e
         m2PX3sm0s8bRjvklYxfekgvUgrig6b7k4Hm9RaRDj7Ry0kWqWYl/4TZzZM3MvFd6Tww/
         JwcSNq8hELGCzIRU5u4N4V7b8MTJ+sfbRf2YG68amAcYtQNgsdkVfMRQ178GDOMKgNUg
         3l47txqo4ULq0YDC04JCq/brGtSmDkUtzil66JXDUu/J2ujWCmdR7B85nMHUCxhXHj4T
         zdJQ==
X-Forwarded-Encrypted: i=1; AKwUvBwDSajTIW3mHsn/AmhMywk9zVTXYAhL2fpZemVbao1eqRbFHfao2BesrooDiVvxb0h/ejv/m7bBJ40z@vger.kernel.org
X-Gm-Message-State: AFq9FYLr/oY84wMMUz68q00WXkWSwEC4Lij9XuZIAoZpdBwYZB0xdJby
	vLeks4ePuSVQ36CNSBkcSYYvoFXyGJ96xc7Izl5Fu5XN/1sC1Ov/Mfa3
X-Gm-Gg: AYBFou1wrH8cV7+hTeiH0Ddm24GzKTaVA4MaMtdzW+VZptD8AfCGHCe2kJ0GeQXzNd8
	zhs0WAhXo2yVq7+h/L3Rjz+gT6eEdzy72mLlMGyqlYpCvu0tRIQoV82kFrLUQHKaPV92+KXI8cy
	cLfaKAQ8zBtFZuUJms9FQG1C107mB8tdB9BEI7VnzHyqlWiwfhp2o6/Jod46XY9tvuElLN3xafx
	WUtmn5+FbKLWQ033Yjc5ktr5rISc/cUnGDwiFL1MLVqQL7Csu8d4FUOb0m9W2oosiQi8ZUnzBBd
	fzmuSjPrlHXLWonXVSVbt27NOJ55mrze56odrGbx0ualt2IYAshxPko5AkaJZcw+suzW9/GHj9m
	CWO4juMVlWw3vD+4cL1WI2LWrjZIo3kiy7BC6t8EvhR20u0La1cEfteHQ3Qxex81FV9MddGpq8p
	c8nfPJojQLs9QeTcmfZGT2+s1FmZwQiZ6JgdS4gnb9xnMTPlP+m2VtHfglh2xch8wTF53wX1V1a
	fx7JnOeR3i/h1VduZp26pSyBMSkk6VpedrpLyW+JZ5ALgeAqF4pZZUJdOzXrKcxV5rOscqifsGT
	3Qc7fjyEth8zN+xSmoOa3LTjxVAqTt1zL24LjcelEB/OhP+Ietk=
X-Received: by 2002:a05:6a21:880e:b0:3e1:c1a4:91f6 with SMTP id adf61e73a8af0-3e7cd4d9db9mr6517172637.13.1793089945941;
        Tue, 27 Oct 2026 01:32:25 -0700 (PDT)
Received: from WIN-L6GHNQALH57 (1-21-119-227.east.dxpn.ucom.ne.jp. [1.21.119.227])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a36b37251fsm2018741b3a.27.2026.10.27.01.32.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 01:32:25 -0700 (PDT)
From: Masafumi Suzuki <shengshilingmu97@gmail.com>
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: Simon Horman <horms@kernel.org>,
	linux-sctp@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Masafumi Suzuki <shengshilingmu97@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH net] sctp: account for chunk padding in sctp_init_cause()
Date: Tue, 27 Oct 2026 17:24:05 +0900
Message-ID: <20261027082405.1297-1-shengshilingmu97@gmail.com>
X-Mailer: git-send-email 2.55.0.windows.5
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

sctp_init_cause() accepts a chunk when skb_tailroom() can hold the
cause header and the payload. sctp_addto_chunk() then writes 0-3
bytes of padding before that header so the chunk stays 4-byte
aligned. The check does not include the padding, and the following
skb_put() calls skb_over_panic() from softirq.

Count the padding sctp_addto_chunk() is about to write. The cause
length on the wire stays the header plus the payload.

Fixes: 8914f4bace3f ("sctp: add sctp_make_op_error_limited and reuse inner functions")
Cc: stable@vger.kernel.org
Signed-off-by: Masafumi Suzuki <shengshilingmu97@gmail.com>
---
 net/sctp/sm_make_chunk.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 84a4c97d0f75..8933caadcdb6 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -133,20 +133,27 @@ static const struct sctp_paramhdr prsctp_param = {
  * cause codes will be embedded inside an abort chunk.
  */
 int sctp_init_cause(struct sctp_chunk *chunk, __be16 cause_code,
 		    size_t paylen)
 {
 	struct sctp_errhdr err;
+	int chunklen, padlen;
 	__u16 len;
 
 	/* Cause code constants are now defined in network order.  */
 	err.cause = cause_code;
 	len = sizeof(err) + paylen;
 	err.length = htons(len);
 
-	if (skb_tailroom(chunk->skb) < len)
+	/* sctp_addto_chunk() pads the chunk up to a 4-byte boundary before
+	 * appending the cause, so account for that padding here as well.
+	 */
+	chunklen = ntohs(chunk->chunk_hdr->length);
+	padlen = SCTP_PAD4(chunklen) - chunklen;
+
+	if (skb_tailroom(chunk->skb) < padlen + len)
 		return -ENOSPC;
 
 	chunk->subh.err_hdr = sctp_addto_chunk(chunk, sizeof(err), &err);
 
 	return 0;
 }
-- 
2.47.0
