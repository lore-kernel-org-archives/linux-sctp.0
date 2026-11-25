Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621754;
	b=bJ04q9F7PL5R/lkK+ZecwuafJ0R0bdm+GolI/LXYO/xI4fybYsrqC7M5dm1Q1+2BaO5x
	 fOYnxVodkScgEH0wOdiIokrZ0uiqeL3brgDJGZw2yVanCTt4d9THbGs8ZXUGETGBTEd92
	 27oXvqSAhVFc0VNMg21rLMnPgYpzUIlfqokRg3bFJpO1nwC2Pozt/l5+l6kC1wBG+UpMb
	 4f8kxYPJRvTDgAtPxjzLymDfngGDx2XieUwop4gECm9qkmWEva+KnoJFToNbbeGDiv0Fj
	 00npDvZBAhh0YjBuGVeBtok79GpQq09xAzeNEWEGOMdCOT+wXRNsBNihris75Ixp/KA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621754;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=2G4AYUd7cpfGVwTNSVOea5oYMTV/zVtjSs8MJKt1xHU=;
	b=wTKypFE4hcxWEvBXKB9QNf9hkc7J2xh9xGK3g7Bz+/TuDasmKvC4nvFR/WJ7l8dhYi7x
	 iBfdKwAcSzaFTS96XmwHMzCPAX6vLWGEZ/HIhFhNPgWF18QzIwuUH+AXGZjBdBXkArwPE
	 0aMLLtlsHd7MpYQ/lrELQCtqqGe51RF2YcUwHQOsZc4zuNgFJ42TVpVnedrMrsiw79mxS
	 deckwwlY8ZA+pB6QXDPf6ygm3685/qhM0Hnq8PZoqbyoLh4tom65gE4zV3GlsBk0Ud0rp
	 GCRZ4egR7xQhOXIxFwFT+YvWew6M8j8j8obmR7KzjWSBuLRjkeGbr53d6rmp5JftAMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=WEVGqzFH;
	arc=none smtp.remote-ip=209.85.219.49
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 343DE606A334
	for <linux-sctp@vger.kernel.org>; Wed, 25 Nov 2026 15:49:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 343DE606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=WEVGqzFH
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-92110499585so55006916d6.0
        for <linux-sctp@vger.kernel.org>; Wed, 25 Nov 2026 07:49:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795621753; x=1796226553; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=2G4AYUd7cpfGVwTNSVOea5oYMTV/zVtjSs8MJKt1xHU=;
        b=WEVGqzFHkBju6xfGP+do6tGFYjuoS3H8QWOPUrFsmgLoO41obRCPP5pwjo6QuTmYzq
         XO8tfnRaiAjVZ2v4w3JDhrTN57MLSrZB5+mCWTddB0ABtefRUzaMFcfk72hmf5Ad6zUM
         9tBXSpDkowwupZ5L3LgeuO0F8u2C+F/GQ75Ji6uLpaviwvwLcrUOtoTjFeKSJftfzaKK
         ppsqWZglf9+MvOBQwBUn4m3/Ale78VLFjVYBlA0Hyp/nmitpt4QuqLgiwwpmPv3jAaBz
         LInan7TQCqrPJ4VHW77pa6WEjxgESqdAoGqgFTB0LD/qfGwRQ8Kprve29oS6YxrQyizx
         C6jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795621753; x=1796226553;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2G4AYUd7cpfGVwTNSVOea5oYMTV/zVtjSs8MJKt1xHU=;
        b=q8oLHe6HwTFTiZaDe4Myuqxc1ZC1BQlgYwmixQUsKxUO3efTNQQYkF4WkvSPRlzj+k
         mWhbCVzpB9I47AZXXHtIcd5tDn+kdts4g2fF3uEyYBc6p5eiqokRdCERpRk9tbI1696/
         4vbKBeWxj8R9XGFwoNEgnLafMC0pYIl32Ma1mIi5FgnDCvcfaX5M1WE1g2iFMjcS+fqu
         ZkL4/2pFpvocrnn0Hj8dkYztiQDsKfXbyMqG9cIxl1TI+6OJEyZfPDen0zXCtDm7CgPd
         Vf/LNbyyZval0lYM2nloaDeSBoO6p0KGi/Omd469Ofu1OKA5b5NGQrYAhdLjHUO4zWUw
         nUEQ==
X-Forwarded-Encrypted: i=1; AL+hErEdsYDTJ9recJ+5vuMw3Z3QmbcnUmj1ZQAF3QL8VcDLxA8jLn9XopqC4kGWMi9BP+0iJqBAYhJHFx4R@vger.kernel.org
X-Gm-Message-State: APuU4Z/+BEfUISyOyeRmap6tNcfoQmS/vl+jMDl8i6ke+2CFqSklxWCg
	6PMmZvOLP+1Y8g2dqVvL45SDwiMbgQa05KPNwn8rafTIpp/Ue4wDjnm6
X-Gm-Gg: AZFdTZdncZOtuFKubHyvQLPQB51C1R/F4MWT+HVSdUXP1b7Y2+a4dF0Sa00jm7jyEba
	QHTWJXjXLvyDOTd4aB5dpzLH+9QVEScrLfX/S4fcMWso+5qdAjyVRSH3NyGb1Enpa93fbmxfumw
	atCLk1yJa7A2h1O0GPQ6ZqlgX5KkW9gBTOfwL4CRGAkq1SIYHh1jKyEbvt5qN2SHW0p9Qwa62co
	+lHEuamhb12qf43IMOid0aeLzfn04XzJGw/JUMnbQXIGNIF3fOAqtkIgBxfqNnYrUjSA0LNjyOX
	dIbmqnwz+jwWUz0I4sdjcDFjzUa6naU1scYu4z8xLHBxrbWpumsbZumN8MRUc0+jEFVjvnrwTkH
	9MPh6Gfh/nwttc/BzLiJZt2SkGzSUNCuz4mkHZys3kvcCYzhHI2zNw/o5TzjBPnGiPeMn2jiQh0
	yKPKRpdtGPnMM3kWzEnbUapZm/vFL+iQmBlQ5zazaljh/JjiqKFwiQDvyEQnC5QW+OJPg/0IFS+
	UUfKvccE2iR1sSdnO0IWCsf7pNiG5CdViVlqoVgK3+pSGmNEzvjF/Jf5Q0Y5wCjIJtlHmvu6g4i
	orzSZC1V+xoFNZOezMShHGh2abGBe1JNStNJxL9OKt6lp8X2naIAT84f6FcDZ2r1KLx2qLPtNKb
	extwIHLUgtR4FFTlBynBzUl2gcLDxL00W4nH0Annqs6MdDG5OR5gjskU9
X-Received: by 2002:a05:6214:6346:10b0:921:317c:89b5 with SMTP id 6a1803df08f44-92134b11263mr242953356d6.44.1795621752867;
        Wed, 25 Nov 2026 07:49:12 -0800 (PST)
Received: from wsfd-netdev58.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-92134a0f5d7sm166716946d6.37.2026.11.25.07.49.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 07:49:12 -0800 (PST)
From: Xin Long <lucien.xin@gmail.com>
To: network dev <netdev@vger.kernel.org>,
	linux-sctp@vger.kernel.org
Cc: davem@davemloft.net,
	kuba@kernel.org,
	Eric Dumazet <edumazet@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: [PATCH net v2] sctp: diag: fix stack garbage in IPv6 scope_id during dump_one lookup
Date: Wed, 25 Nov 2026 10:49:11 -0500
Message-ID: <7cc69548f249ff63527a663c22d9dc918d3c3e84.1795621751.git.lucien.xin@gmail.com>
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

As gomaja noticed, sctp_diag_dump_one() builds IPv6 lookup addresses on
the stack but never initializes sin6_scope_id or sin6_flowinfo. For
link-local addresses, __sctp_v6_cmp_addr() compares scope_ids when both
are non-zero, so stack garbage in these fields can cause sporadic lookup
failures.

Zero-initialize both laddr and paddr to ensure sin6_scope_id is 0, which
acts as a wildcard in __sctp_v6_cmp_addr(), matching any scope, just as
TCP and UDP handle idiag_if purely as a device filter (dif) parameter
without conflating it with IPv6 scope_id.

The dif check in sctp_addrs_lookup_transport() already filters by
sk_bound_dev_if, so scope_id on the lookup addresses is unnecessary.

Fixes: 8f840e47f190 ("sctp: add the sctp_diag.c file")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
v2:
  - Add a Fixes tag and target net.git.
  - Fix the issue by zero-initializing laddr/paddr instead of explicitly
    setting sin6_scope_id to 0 (reported by Clashiko).
---
 net/sctp/diag.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/diag.c b/net/sctp/diag.c
index c2a0de2adf6f..564a5b51e6ce 100644
--- a/net/sctp/diag.c
+++ b/net/sctp/diag.c
@@ -433,7 +433,7 @@ static int sctp_diag_dump_one(struct netlink_callback *cb,
 	struct sk_buff *skb = cb->skb;
 	struct net *net = sock_net(skb->sk);
 	const struct nlmsghdr *nlh = cb->nlh;
-	union sctp_addr laddr, paddr;
+	union sctp_addr laddr = {}, paddr = {};
 	int dif = req->id.idiag_if;
 	struct sctp_comm_param commp = {
 		.skb = skb,
-- 
2.47.1

