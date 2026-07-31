Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 119A93F1AC4
	for <linux-sctp@vger.kernel.org>; Fri, 31 Jul 2026 12:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785499562; cv=none; b=khn22YyptLATFEdd//ioe394nVeCmWb1n2e7G/68lm3frKEgvkMqRzJuRt7UE1ikcZZrCRzIARBqV3J5P04FITaIUyPtcmI48sBpXaXGEh6elz3zp5mg5HwxyVynp0OTtl1qABDdOw6vawdTHIdSAwp0fJWNI/8E4mGfMg66eM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785499562; c=relaxed/simple;
	bh=7Nv247yt1+fKJsVSZ0a7lvl522Kt3IM0DYz6/l5ynCo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GNkgCdrYRw8YUyEauN3J8d9OUrBCx1soPeuFtNjEIWmkgCy6Q5U8eThnLuDl49aPBG1Y8BQMwUlBUA8g40CvFfvB7KtoHKnh308jzoixTF/vXPutb02CgkgeYZ956f/+kmzTHvUL3eItTMS8RcgmK+MZKqsI99FfZlxShZRGVEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com; spf=pass smtp.mailfrom=trailofbits.com; dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b=gR2ObLPe; arc=none smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b="gR2ObLPe"
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-92e5c9211d2so69371585a.1
        for <linux-sctp@vger.kernel.org>; Fri, 31 Jul 2026 05:06:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=trailofbits.com; s=google; t=1785499560; x=1786104360; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Q3JgexJ0YvH/Q9Rjtz2xt8Xnp3qUV33bbtdN0HErD0c=;
        b=gR2ObLPeMWA7Eqsua5+qF0F6anzq8gCumz6WvUrghHw8WylUTdVYFmORyP66lot9r1
         K9k5rFeoDlo1ZBSKH0LcnpsoILS+QJgZMxylPB+lND6Q1iXrjLQviSFd15qpEn+U2vk5
         kQ6FnHZ+paN3lUxJOlSEYsIwbPsPSSjw6GYmi/MPYEJA6iE4agoWW/2+OhUC7wbQbzqt
         m49YSpIy3tsZOEekEjQiRpikO0giwAcwkrY8/vK+qwsXYx7iCEekjt1egRcTH5q/NM+I
         o8eZl2EkmFM6jSTCsnZ5oSMo7qrIy6we3/SUS2L7lsKLqtnxheLQVgnH4SkGBZhacbto
         CA2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785499560; x=1786104360;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Q3JgexJ0YvH/Q9Rjtz2xt8Xnp3qUV33bbtdN0HErD0c=;
        b=ITqCuMgTUbWEnxgEeNhMOO+WwymfHN74Q3/csWwkouHWxbYza5tXXKImI6i9BexkzO
         TW9tj9tk0vJMjSeoveI6rlBhlCDQc+mQu26JhgYZtvRbq8dcLPgpvEmmvPhusw8TXeEp
         CcVVUbFysbAC4DgGzBpag5ktiwzlsq4qHK+/J+CiQFb2RW6yTRlo/sjRhiysmiaXqMPX
         5DP5gy1YNTxF8xqC0L+tF2wpe1zHzdCAtsm5Lp1iP/8Y8eKF+fh14E1M71YJLDhJqQ3a
         ljTjdYtjf+6rKkqtnMYQvuZGxM40mOUc76QgVH5NL9VtdqbgpOVXRlmf6gx3dEtjPm2S
         8EKA==
X-Forwarded-Encrypted: i=1; AHgh+Ro3Hn2VcUoKbrQbKBjv6F/k/b4p5l1t/lEz0elF43aJAC8IU7Wk76z4LGiDxD9We25tkjgyb70rF0t/@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0KDgSjHGAbk/QpGF8GJweOP8KdC36TZK72K/ynDeekJf5yemV
	Pu7JDsWJC3dJ7Cc0prTNEw4lPTqqvhCKO10P4H/6z6AH2R9B5mM6RZurEJ+HvKJiDdk=
X-Gm-Gg: AR+sD11PVv0qzmzgtDvXketl5J+gZueggskTqGgaGBMSaoQkHacAM6RmPMAulID9RAY
	4uVAArabU35+2JApUaPkYShLfnFVBbNlKu5IQ2A1fMotn15OttHh+knJclV+mDwoIKomaj/6viv
	njF2kzwcA7Ig1qArENcelFxKyxRWtCcv5kLKhs8vAk32u4EhSaiyi+VrRvwxyAvTbL/XKScApik
	Gbc2+kQGWxMJiZe8O0VowBuxdmoh33jvf+reG40nRcSo6fqekeckqt5/64VywfS9NWMEdgYDgX6
	mpGMbQlQm64gpxlMtRRB8k1wVzdqVRexoc/ZYQTgwL7Rr/HkwogQqF7bGh3iR1XCvDgcgqM+GFw
	gm6ze1ybH2To21niEIWr3Os+LMBbvSsp94aBc8zRDEC7Ny0hqSXBLJ/U9W2GvKwMVGxEx3tKHRJ
	AAmty81et/ExzJtM/SbCqiwtMoOOPpgtwwdQBJiHh2zKHdwjBCozRZKYIp7LwK1WUFSg==
X-Received: by 2002:a05:620a:6293:b0:934:8ea0:9512 with SMTP id af79cd13be357-934965b723fmr259762985a.7.1785499559744;
        Fri, 31 Jul 2026 05:05:59 -0700 (PDT)
Received: from localhost ([146.190.222.192])
        by smtp.gmail.com with UTF8SMTPSA id af79cd13be357-9349c199c2asm40966085a.28.2026.07.31.05.05.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jul 2026 05:05:59 -0700 (PDT)
From: David Lee <david.lee@trailofbits.com>
To: marcelo.leitner@gmail.com,
	lucien.xin@gmail.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com
Cc: David Lee <david.lee@trailofbits.com>,
	Kyle Zeng <kylebot@openai.com>,
	Dominik 'Disconnect3d' Czarnota <dominik.czarnota@trailofbits.com>,
	horms@kernel.org,
	linux-sctp@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] sctp: hold shkey across socket migration
Date: Fri, 31 Jul 2026 12:05:57 +0000
Message-ID: <20260731120558.558957-1-david.lee@trailofbits.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

sctp_sock_migrate() transfers queued DATA skbs from the old socket to
the new one. skb_orphan() invokes sctp_wfree() during that transfer and
drops the skb-owned shared-key reference.

If userspace has removed that key from the association, this can be the
final reference. The following sctp_set_owner_w() then dereferences the
freed chunk->shkey while trying to take the new owner reference.

Take a temporary shared-key reference before orphaning the skb and
release it after the new owner has taken its reference. This preserves
the selected authentication key throughout the ownership transfer.

Fixes: 1b1e0bc99474 ("sctp: add refcnt support for sh_key")
Bug found and triaged by OpenAI Security Research and 
validated by Trail of Bits.

Assisted-by: Codex:gpt-5.6-sol gpt-5.5-cyber
Signed-off-by: Kyle Zeng <kylebot@openai.com>
---
Trail of Bits has a reproducer for this bug that triggers a 
KASAN use-after-free and can share if needed.

 net/sctp/socket.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index c7b9e325e..4a08023d5 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -147,9 +147,19 @@ static inline void sctp_set_owner_w(struct sctp_chunk *chunk)
 
 static void sctp_clear_owner_w(struct sctp_chunk *chunk)
 {
+	/* Keep the shkey alive until the new owner takes its reference. */
+	if (chunk->shkey)
+		sctp_auth_shkey_hold(chunk->shkey);
 	skb_orphan(chunk->skb);
 }
 
+static void sctp_set_owner_w_migrate(struct sctp_chunk *chunk)
+{
+	sctp_set_owner_w(chunk);
+	if (chunk->shkey)
+		sctp_auth_shkey_release(chunk->shkey);
+}
+
 #define traverse_and_process()	\
 do {				\
 	msg = chunk->msg;	\
@@ -9632,7 +9642,7 @@ static int sctp_sock_migrate(struct sock *oldsk, struct sock *newsk,
 	lock_sock_nested(newsk, SINGLE_DEPTH_NESTING);
 	sctp_for_each_tx_datachunk(assoc, true, sctp_clear_owner_w);
 	sctp_assoc_migrate(assoc, newsk);
-	sctp_for_each_tx_datachunk(assoc, false, sctp_set_owner_w);
+	sctp_for_each_tx_datachunk(assoc, false, sctp_set_owner_w_migrate);
 
 	/* If the association on the newsk is already closed before accept()
 	 * is called, set RCV_SHUTDOWN flag.
-- 
2.53.0
