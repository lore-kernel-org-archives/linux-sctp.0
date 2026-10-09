Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF0323C81AD
	for <linux-sctp@vger.kernel.org>; Fri,  9 Oct 2026 07:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791531791; cv=none; b=P/gqiBUeJKS7HV8mBOuoauzCOMJgPeTTND/vnzcOWJ4nhCnpGLk0nIN/vwqNWzqD3AB9gVOA4flrACsFXARKCYmTYon3zEzwjPptEfZxA6tL6sbEgIKGnR7sMRidcImHmqMLgIqa+40WVSutM+Qa5iXtHcgsvB0aG9CtJL32kPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791531791; c=relaxed/simple;
	bh=qiZqiT0Tg1+Sp+sltzNiNK5HsXboDlmJ8Ghw6/SA9jk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XQcZK1JzTQb95U7f22BwNLX0QjbNXoVbfu15vwOBut0HCgKd9qdNqb7p92Iu3X4HyyVSvpKPqjBW4mPvQQjWHFhFXO6YA9iy3VonRr/8e2xlDUEezGGZ0j8YOeiUp0chuPds9uS+yW/aa0bZhVZDR/h2GpZdfsC6dCJQ+p+/lUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l9R+++0w; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l9R+++0w"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-3a7fecf8440so2477917a91.1
        for <linux-sctp@vger.kernel.org>; Fri, 09 Oct 2026 00:43:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791531790; x=1792136590; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4EGTu/vKHlKEvtTJS4Y1X7sDSvkjeqeXv7lxJj991V8=;
        b=l9R+++0w8Ddo4s7S1V9EAZmKKzG4P4Iu8n1j5rOSvIvKT5yH13JQsTHb77IMsmrHgg
         iEauB15+UHLJxIRGRsRQ7z+NQYU9zBsDt3Rs8MJo6Q1eG/sZpJnGutzBlVxAtRvB5Htv
         FWiz5vCCN41wROuE8Zd7Bxc0EORKOHKmia04GUpL16sn8W6yrER+d4ZDuAQ/0sD2dhTM
         XggeNceaa147ZtYUQjDzJTEun/4SkU7yi5JAixWcr0LAOGWhVkw5WFI5FfzOVZrxx388
         h4XHcanBO0BUrZZE6lQKkti/ywsks8Zv4QAfLPVXeky4KsMzu432goq7eU0E8mS1tKt0
         5M6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791531790; x=1792136590;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=4EGTu/vKHlKEvtTJS4Y1X7sDSvkjeqeXv7lxJj991V8=;
        b=Cuw8yJVkimGuJDsgiK1CJJmkK2ZRSyHkBcTfTSoetHwIRVlBBop5rKPj290VzmeGiO
         e9gQTZkmfB9m5N5Z8yd/9hbRKu+7GHJfHHEDNo7kMb+Ko89k+G6T2XQtnJOhgIvCQ6Kj
         lG1EuMGogLaqD0LAya4EGFLH90sfl7erZwYhWZzc6/JkiHWJLLSZISqvgg4LN01ipAnV
         vQlM0V4R6sVbnI+q4BXXhxiX018JC0isgB/OjF+JrveB6tnbUQk4wtPsK3lz6g7Q2Wcb
         cW3gHYW9uSxP7u++/wGKfbQ8QK1o0OC0XAjo0BBf/x8XxRmWwHeO1x2gNNgPw3hsow0T
         CGJA==
X-Forwarded-Encrypted: i=1; AKwUvBwIY+VnmfesZg5jKfOJuSBkhhv8pWCTvmVFV+uDd8iJhjESmaZ9JmFKqxhHGmrN0+j6+49xvWBWiFIJ@vger.kernel.org
X-Gm-Message-State: AFq9FYIR9QJIUeeu5X1JWX4ItUqKg8TTmzrc+v6kZPaO1eNF1I5DJFLx
	h0glMLSoGW3rj7385J6jk1VMi/1X/ON4QW+pTx9tAh0nQ8QfnrLPUrwO
X-Gm-Gg: AYBFou3Nl3V+7lM3mgvNKQu+eP5YD1ffA+S/4d52Kp7UcbjI1x3RVSTs7XSI+IyB+DG
	XHLx8szB+3UZ3YE1RoXQSTwxgOJX3SXiECTRsO7XscLBxF8KPqsFpKxyz6zxW2IGvrZgdgkKHgw
	62oZvPTDvRefjQmD5B/WbOOWFDolxl/MNW4Xwpcy56YVpFEWVzbZvEJ7uxDkzWL9yOlDQTZGf02
	6mstW4QlzhEimtzDwpydBuaHq1RqBTzcXDECaV14w58sxJvWwlGqwu3V1yS6NP51Hdzk+0fcV+q
	7ZCgCLASOtZiN2+RqK/i7dmpXwtfkLREJowdw7TAQ8S6MpgHoLQdkN/7PKH5srNAI5lhRLLPse4
	wLbqcE6qv+6ajZlZVe12DAOasRzu5ATofqyLuzPUlNG1Uqz7UeutdXql7OzQ/cEDz1RKXNxQ1Ri
	7B/u6KpcBnhE6dH7Bp2hP0n9dffjKZR+Z1k6HG45dicEkyHpWLElX/pneVF5m6DeblMgl4ALLGb
	IhejmCWWvpfoCKiKGY59KpQ2GIhKR9bPmfDHsn4MEQQbw==
X-Received: by 2002:a17:90b:4a8f:b0:3aa:f4af:1e08 with SMTP id 98e67ed59e1d1-3ab3a4875cdmr1076377a91.9.1791531789860;
        Fri, 09 Oct 2026 00:43:09 -0700 (PDT)
Received: from JUNVYYANG-MC1.tencent.com ([43.132.141.21])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab38ddac6dsm2124986a91.7.2026.10.09.00.43.07
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 09 Oct 2026 00:43:09 -0700 (PDT)
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
Subject: [PATCH net v4 1/2] sctp: hold shkey across socket migration
Date: Fri,  9 Oct 2026 15:42:31 +0800
Message-ID: <20261009074244.3718-2-juny24602@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261009074244.3718-1-juny24602@gmail.com>
References: <20261009074244.3718-1-juny24602@gmail.com>
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
Signed-off-by: David Lee <david.lee@trailofbits.com>
Acked-by: Xin Long <lucien.xin@gmail.com>
---
v4:
 - Add David Lee's and the forwarding submitter's sign-offs.

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
