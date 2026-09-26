Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 643F91FA272
	for <linux-sctp@vger.kernel.org>; Sat, 26 Sep 2026 10:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790417050; cv=none; b=pZowtrjfsCgCwovP2kdYN/aANiR0x0Dph/pW3k8J1byEdE2eaMkfioMMyWhSdgBFUIYHfum2IhHt1c6EGc0eTlx245mzksU8/f5OLNZqbXMTc4n5C9TxpGuwL8+rDOS7UVYH25CarTQnjnEQ+Zvwo5g9lggUwmh/7Um8wjlHux0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790417050; c=relaxed/simple;
	bh=NOFvYIzMe59oRg00wo/vPLaX5v5lix8k0vP6rv1OWrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tkHHPD8VCOc4w4a0kbIg+ZGCwb47OMTkWJHn8b1MXXL3LEDRIpAodCDXI3w2OpPimw+IZCQANgkuVNvrXSa4XoArA4b8zlbKxS+PTKcuXof1qvKsMVzfepNtQKrhxyi5PBWRJ/vlo7aFsLPKOe5JmJHNZzULOBrNWtkN5E8E2hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Fmud9/20; arc=none smtp.client-ip=74.125.227.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fmud9/20"
Received: by mail-pj2-f13.google.com with SMTP id 98e67ed59e1d1-396ccb652d7so1085595a91.0
        for <linux-sctp@vger.kernel.org>; Sat, 26 Sep 2026 03:04:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790417049; x=1791021849; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AJU1rtsDPsuoX/UjSP5YhpwRW3gJBK/2ZRn5HWHEarw=;
        b=Fmud9/20t4Klc/IEnNbitJi0+EsF+v+m/MBplz6Mw1YaGNSI135bjKPDyYhzKK5Q+U
         bVYHLLvgdHqbVk7CsY15V584s/noIn2ioj49gysmWBU9lh2KH/pxKeOVW9ahayg18XT1
         PIU683LuhQFonjrYJyjJg0jSecaIOivtnVh3UKxK/YebdFrqfb6OGuSxCHIswrOiyDr0
         faUyeoo7+gN+AQoOoqcQPNGjiTEKDQRFF24aW+c/2+fmRkOPn5lntZH4rJomGyCdcdy5
         zVL2LWLjkx+fv1WHEWAmKclNqam1vkJETI7iVJcTttPfJPdtWBkiNVI8nbZ81OtOrxG9
         Lbog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790417049; x=1791021849;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=AJU1rtsDPsuoX/UjSP5YhpwRW3gJBK/2ZRn5HWHEarw=;
        b=hSi/A/Tecb4JtRU3acjSYDofyNt4SSyCpttiXYZwlATXeCOGXDXt60DbhSauUmAUqT
         0xIQxnbw85iiNvq39ZmwBxBNwvJTjyUmTnGJa90p74RUEn67nDq2pGJxcOPoU7kmSklM
         0LcQ59l42zbS673KGlJUnxEzKadKmP/zMPYbcvCXbsP3RI2OeaDzP7mwR2PqZr+FOxqa
         E0d7bJ3jeYI996wgdcJX4WON2Ysw97cL+HUOrlAE9dnzuWq2KnVQjDTa9ryRfXHPLY3C
         ut2In7E+wEA7ZF625Fe+IJhAw5zm8AqcMyMZuTi57hLImkwlqdyzM/ix+q3sSzTh+kKo
         rfFw==
X-Forwarded-Encrypted: i=1; AKwUvBxDmSI0K7MVUFfXdS9ZWChDq0usmyIgaOVEKAhCO2JdFgCN6zCKfVHPze/sXUAlAoArb0qjOj4MmeL5@vger.kernel.org
X-Gm-Message-State: AFq9FYKkcnsH1d4e8d5fWbAf4XSxLqxgRGHkXAxLpB+Ebu8MugTjoIiD
	4hNdJejIkIy1mMznwfVWIyexzs6RPhfaAmjTSOcMdk7vQ3seB7cb/j6w
X-Gm-Gg: AYBFou3FXAfaSDREuvj7HPryn1eNMSIdO8vVxf1qj4ZRBxsGQ33RhPghUjl1MXW9TTj
	vjTX+JGujy6fRap6gvj4xIjQwVQjWSzob/DqVUCmR2gb66WBwWCZ9wBptH1AJ6gJ6+VnKchLv2N
	fmtQahkQXtb9rcb1r2LbGR1JznCYb9hH5MZj0+4MzkfCCJQR1Z8o4d7ljlqVWdV1a0GFEcjGZe9
	T1VhqRfY7EkrXUp3k/aP2d1Je7AR51wzFOdcy6z1QeyLbFsGN6BPhSTRlU0Sd4yUBjvNZ6uoskx
	w9gqOS/sk3Nxk/gjnCYwdnADkQTz904IM1Fo+zLtHkcXMhbiYCA5tQF4+3/qeTzEcSWfh/OlVQG
	FD/aowOrF3aP+orNwPsdUwiCT1wMJMSvCiZL89OJ2iinw8VHNkCp2fYyQMl9Upd+ZAFWV6KvVB7
	EdK9QQum3Hdxbp3iTiqiazJeTm0a1bdtGy8NAGbYyb3Nh88oVmH5ZueDo4b1lBIGWK3HlDv4M1C
	TAXIP9E7RTZ2rGIQZ7yotg/Ba3uJ1W8lZiJXSB7ZfH8fbY8A7kNtQ7Y/A==
X-Received: by 2002:a17:90b:48d0:b0:3a0:e22b:1b16 with SMTP id 98e67ed59e1d1-3a0e22b1df8mr1010759a91.25.1790417048136;
        Sat, 26 Sep 2026 03:04:08 -0700 (PDT)
Received: from JUNVYYANG-MC1.tencent.com ([43.132.141.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0c719f86fsm6730826a91.7.2026.09.26.03.04.05
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 26 Sep 2026 03:04:07 -0700 (PDT)
From: Jun Yang <juny24602@gmail.com>
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Xin Long <lucien.xin@gmail.com>
Cc: "David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	linux-sctp@vger.kernel.org,
	netdev@vger.kernel.org,
	David Lee <david.lee@trailofbits.com>,
	Kyle Zeng <kylebot@openai.com>
Subject: [PATCH net v3 1/2] sctp: hold shkey across socket migration
Date: Sat, 26 Sep 2026 18:03:57 +0800
Message-ID: <20260926100359.78731-2-juny24602@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260926100359.78731-1-juny24602@gmail.com>
References: <20260926100359.78731-1-juny24602@gmail.com>
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Lee <david.lee@trailofbits.com>

sctp_sock_migrate() transfers queued DATA skbs from the old socket to the
new one. skb_orphan() invokes sctp_wfree() during that transfer and drops
the skb-owned shared-key reference.

If userspace has removed that key from the association, this can be the
final reference. The following sctp_set_owner_w() then dereferences the
freed chunk->shkey while trying to take the new owner reference.

Take a temporary shared-key reference before orphaning the skb and release
it after the new owner has taken its reference. This preserves the selected
authentication key throughout the ownership transfer.

Bug found and triaged by OpenAI Security Research and
validated by Trail of Bits.

Fixes: 1b1e0bc99474 ("sctp: add refcnt support for sh_key")
Assisted-by: Codex:gpt-5.6-sol gpt-5.5-cyber
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Acked-by: Xin Long <lucien.xin@gmail.com>
---
Original submission:
https://lore.kernel.org/netdev/20260731120558.558957-1-david.lee@trailofbits.com/

 net/sctp/socket.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index c7b9e325ec1c..4a08023d52aa 100644
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
