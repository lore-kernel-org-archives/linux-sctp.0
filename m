Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794495711;
	b=I6+/BmIFvE16WwBaqZWinbdIpxFwem/ohgV2lSH2PFXRz7p2yzNGF9OPkF1m1DdrRzTF
	 cgysxcyzhGH+yQQ/76DxNqKj0QEzVRMgODjcfV+xpacEB3JhWHMDyfjyOalXKS0nnM6MU
	 Xn6M0mObyNWk0sPGh++pniVpwiIixXHgF4ueR3z+E9ywvWOPFNH5X+zOfCZxyjP7D8WqH
	 E/14okuGIZ+PlukwSLe4Ydcm1uHmBvq1KJfD/skRqhjOviU4Ro4YYVPe4YkNwIe6ZHKcc
	 QUTHHPx03iVya+ydinoEhfg58g9//76VWwh5GoA8xtWLWRtbdtWyeYuMgjh0e6Czd0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794495711;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=qc4uEPO8Cmvke9ozBGIwJNLQ+cJCAHLnYttkfZRqa0Y=;
	b=ukyuFagkRxILyR/dxhxO8FyxgxocrO0HQYeghALg85f3DIVe9Iwm65w/baim3f2WPtV/
	 5j+naCgBefou0SxYltyZyip5xBlSbyamGAMXrvpEg0lW4Py3gI8Tzw4KvKam/EbssvEtx
	 dd2KNNKDpJ9ROybKKuejeqskX/M85PoD4COPWXnCuX8c4zyu9KOri+3bfK/vbhg5CBUZW
	 aAKhOgddURGQ3x5u3ojOeB7CBnPXLLuYiIK/r4YFxO+oOSHmjqZABEs6scJdMsNyFFfqb
	 yeJSJsT0xp8SM6I5Z4Klyyk9PXTuDqzJ9mTBz5jUV50xJnSKdpvDecCdcNLHSjJEqEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=AJdhhrGY;
	arc=none smtp.remote-ip=209.85.222.45
Received: from mail-ua1-f45.google.com (mail-ua1-f45.google.com [209.85.222.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C75E6606A330
	for <linux-sctp@vger.kernel.org>; Thu, 12 Nov 2026 15:01:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C75E6606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=AJdhhrGY
Received: by mail-ua1-f45.google.com with SMTP id a1e0cc1a2514c-97ccbba8e86so1177374241.3
        for <linux-sctp@vger.kernel.org>; Thu, 12 Nov 2026 07:01:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794495710; x=1795100510; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=qc4uEPO8Cmvke9ozBGIwJNLQ+cJCAHLnYttkfZRqa0Y=;
        b=AJdhhrGYXO9yQDGaK+QrldNoQyDp8O6FkyNplLJwP9hciEtPs10IVwPQufcIYxLN3y
         EJuzO4d9UwzN9y88LumiaaA/2omQum7pnF7nL+prbbnfafTONwziw62MRjn/LIMR2U9o
         XKwYljRp4PG0SgJw4HZV1D86PVc+6GeO1/vK2N4lUXmEdNmBXZkHgU9F/bdO7/Cg7M7f
         /VaDMAIPBNmmyvfPr8f2U8Dk4H/EiBtU+2/5VJwd9QVuIAsRKsb+V99mJzgQtqXCt+nA
         rv3WITMBGw1um82P1vPo6mbVOkTD14iq4SF/56NAiWIH/FyVctiYJgbbO1kuJiGKmz03
         8Xqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794495710; x=1795100510;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qc4uEPO8Cmvke9ozBGIwJNLQ+cJCAHLnYttkfZRqa0Y=;
        b=t+EiJc0Fo3KK9BYdIiiT3FA61L5fcbl8css+UpsTWMztRRrbT3LHxf6soKwIy+jMQz
         emOdNnTP1+nzwqlE7owlDPM0UrXayjWDFE+BzVbOvNQY+HO9YBcBcfD9NvCHCgklZe4s
         No2yVwlRJ0DW9kmFFYsq4ViUlbtjzAUbkcxNSXOEdhaqzYaXi5pJ4gaenFENY+fWNGYq
         xzaWJVCChzH0oUP6JhoUutIjMCfMaAZI6tofPEECAtyO9s0QYB/nA5v6XVnyln3qKpxX
         oMudng61a6e/umUkcfc2wcPUakYEU+1i2JRCZv542f/V1sSPJ4qc7YaqOOJlJw5EIRE/
         3WHA==
X-Forwarded-Encrypted: i=1; AL+hErH+za9UpI5IRlArhDaq6gZ1Y7ZR3SkMQ2q/Zjrjb7Dsts+nJoOP+PW5niy9H4w/dtnQgW3jVaA0t/y7@vger.kernel.org
X-Gm-Message-State: APuU4Z+sC29ONZj5499BaO7zc08Ymy7yGXEr/938BiIv97UwPTYsJ0Km
	lz3U0xYU6X+w2L+m0dogVN1zBuADpFIVRKhV4S60CEBLA0QfkWfus80I
X-Gm-Gg: AYBFou35nTb3CpGAI913pWGXixj1COKtOXJ/p3XkLXtPJxJ/dcUYbBUdWdAXknZL9mT
	yHnXDBpPt8IHO9Qa+gUitupqm3fPxmKi040vubIhwB8MUJblMxf9OWyE/LB8zJ3Kx5h4/16H2XX
	Mk3YREp+IZq6qS0YtHcrfEiCEd/eX+pFFLaS27hpK16g355k4nTD1mV+vY/g3KyeR6ZUCMhGhL7
	xQuSrHB2uYu3iJrM4fH5Owf3INTv2RDUmstiy/1l+eqd6nSViMPAQdZa/+PvdcrRdwv5u6FJ8jl
	brRwnciBthH9sGUP4uR+W+NMsJBnOfMW24jiy9IpiyK3ZqDr0BTG9tqkszZOUO75HLRXBWPjp2T
	QGtZG+qNche701QmxKBO6tr5XwRyRrSNe0BwBp+Rs3np9w30U0nWqMeOdK+QFhIhzEA4kX8dDIQ
	k3ErmlDVxSIDMxlfbhjb2uGPUTxIcGdETolEdegDtk1/m1uNZjKx32vD19pLQGycVUy+++J6XrB
	gOSirB9OiV+wquSWusrRgMWHv+Dk/cBDcNr1QuBKqHumtYc8bD+bIY/TTRcVZUHDWdWH3OgJUsB
	eVU5LCYepoovHz2XlXu7je5BqJndp3GwSEKEihMlVb/9MaIrkh1TZ20KEJIgIR9jxLTHJ6BZdKU
	LtZ1nocU43sAJwu87TvA1ZqkX9ohlJysa67jZtaLfOj+QGnQKaAzoRWDjh36fWepms50=
X-Received: by 2002:a05:6102:374b:b0:7d2:75bf:2fdb with SMTP id ada2fe7eead31-7d4ee1e5ba9mr1717334137.2.1794495707226;
        Thu, 12 Nov 2026 07:01:47 -0800 (PST)
Received: from wsfd-netdev58.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91ef04fb371sm74191346d6.25.2026.11.12.07.01.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 07:01:44 -0800 (PST)
From: Xin Long <lucien.xin@gmail.com>
To: network dev <netdev@vger.kernel.org>,
	linux-sctp@vger.kernel.org
Cc: davem@davemloft.net,
	kuba@kernel.org,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	on Sim <tlatkdgus1@gmail.com>
Subject: [PATCH net] sctp: validate SACK pull length against chunk length, not skb length
Date: Thu, 12 Nov 2026 10:01:42 -0500
Message-ID: <3fbf59d17a91c46098e3d4115e06987918b68c45.1794495702.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.47.1
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

sctp_sm_pull_sack() derives its pull length from the num_gap_ack_blocks
and num_dup_tsns fields in the SACK body, but validates it against
chunk->skb->len (the remaining packet data) rather than the SACK chunk's
declared length. A malformed SACK with an inflated num_dup_tsns can pass
this check when subsequent chunks pad the skb, advancing skb->data past
the SACK boundary into later chunks.

This misaligns the skb cursor for subsequent chunk processing. When an
AUTH chunk follows, sctp_sf_authenticate() reads and compares the HMAC
digest from the wrong skb offset while sctp_auth_calculate_hmac() writes
the computed HMAC through the correct chunk_hdr pointer, bypassing the
authentication check.

Fix by validating the computed pull length against the chunk's declared
body length instead of the total remaining skb data.

Fixes: 730fc3d05cd4 ("[SCTP]: Implete SCTP-AUTH parameter processing")
Reported-by: on Sim <tlatkdgus1@gmail.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/sm_statefuns.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index b2f609f177fb..44b1770d43c1 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -6368,7 +6368,8 @@ static struct sctp_sackhdr *sctp_sm_pull_sack(struct sctp_chunk *chunk)
 	num_dup_tsns = ntohs(sack->num_dup_tsns);
 	len = sizeof(struct sctp_sackhdr);
 	len += (num_blocks + num_dup_tsns) * sizeof(__u32);
-	if (len > chunk->skb->len)
+	if (len > ntohs(chunk->chunk_hdr->length) -
+		  sizeof(struct sctp_chunkhdr))
 		return NULL;
 
 	skb_pull(chunk->skb, len);
-- 
2.47.1

