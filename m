Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619853;
	b=kw/Se3BY61nbOxVAfHwnsgZMjZI3NvcXbXbIVi7p02FhNi8dE+Bxi39TXjBkANx8ZPSo
	 ZHsI3cY9yW3SBHtwPLNWUeWZsWqJCuwiPebT1xCqs73x2GfYKopoPrHYcCVVl7dQHXcVb
	 UVObgqZWdwDV0ZRSCyOIckVjEoQPWwHr2h31MiFCjVEW7mTqB7WrG4QyWCOGdlMNJjSon
	 24E976pXxb0E3HKxuGJrW3y14Z4QXpGzIeC8V1SMQ26KgLErQ7zXtWwRI9YsbjYQDnOAX
	 lcKwGaN+5Wx68Av68mRw/6C8lxLxyBEnuii5JmU6oC65UFPSHiVf9VVdcbKKiev8Yng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619853;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=C+rOOkLJgdQ5N9f4sezWXt+SerC+7jevc34AyllYRns=;
	b=sHnhd3/vxweOS9uy8XgIxkZ7Z2v3pWN+vuIb2vwlDTnxHXWovzI4V3Jt2jyrF/0E1vi7
	 75mITsjHNWIvqNg8YI1J87I6dL8FhVL/rRRQkos8sGU5MG8oOPz6IArJEx1ouwKFK5qiK
	 fZLxWH0izZvhrqXzFVlD5/pJkJo9bwAkecosHFPHnOWDe9WK0/8LQJIh7ZkOjN/oDn0MN
	 toCG18fhxjrE/EThM5M42MaXA2yUL3rPDTFC6fAQXRMmyaniwmGQ1JSzGLwAx1RydY1cI
	 6LwtTBdl73DMP3zzaOrgZpKej+/ZBUefD//Kqqoz5eVZ0wcOOX/uv8RQ3okvykpW9dg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=xfACnRKA;
	arc=none smtp.remote-ip=209.85.167.48
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D204D606A321
	for <linux-sctp@vger.kernel.org>; Wed, 25 Nov 2026 15:17:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D204D606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=xfACnRKA
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5be4b61fd3dso5224536e87.3
        for <linux-sctp@vger.kernel.org>; Wed, 25 Nov 2026 07:17:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795619851; x=1796224651; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=C+rOOkLJgdQ5N9f4sezWXt+SerC+7jevc34AyllYRns=;
        b=xfACnRKATwe4GT60n/IfE0+y/iZMY1VqjkD4LMy432K5Ck4cf37GGCnWO53Dk86qlV
         wwtbRWD4Yqh4i1yjPvIfXwh+OlefKV6IiqBdZMWiuA/z1hDRXtACk7VT/GOdIPchxJpO
         5BWW/Ae9+blhkT5iIe4GP/WrIoNeGYCR5Iuk3dc411n+/99NTTAzb8lbErxZMCMlCAR1
         wN/pmsSiChltIBLm4VLhmx9NQvjfPE+EK0gE0e93xOsRqwhZ9YDG3fRjCovQgYbxv5FL
         SeGn6JRxsG2VTBtA4WgqJbW7TldQ3Mlh109Ed/bHcBs1IHSZXnYQHqhln3++xnS08as5
         5FYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795619851; x=1796224651;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=C+rOOkLJgdQ5N9f4sezWXt+SerC+7jevc34AyllYRns=;
        b=gvHEzCH7Rrm9dvc2Os0SAAEoEgoyyvv9dGsOKkE5zXVZihd3za8FGRPLOKVIjSPqqr
         jsL0jHAmV5PsB1ew3fIRI2U1slfoWDKiG7GZZ/ClHr5GdFKvJ2HwVZ/efgPHtVpweIKQ
         FNdBTcK8LBmGSEfY6HJF9c2qbLg6qJntFvtp3frdUY9Cu64c40lMELFLeU6KiqrS48ho
         8+bsWq/Jw0C4QoijOFgINbU8c7QzyUsMXqaW+jDWm3/+NMQBSaX4OwXEh2uSyHaIoK5q
         nX5G5vECGjlgqaNcX5r7C/xEiOF81a7T/EeoCY1xWGS9KI/6uyVmYYwJzpcyRzuM4DRv
         1hYw==
X-Forwarded-Encrypted: i=1; AL+hErG7cLNDt1K0hmhm8XiEaScJfEOLrtk4KnjlHNW89kZ9AB4JqN3kX2rA0A7fJ6pCNiorKdb9F851Wmxk@vger.kernel.org
X-Gm-Message-State: APuU4Z8AoBJKDq4MtCSrUxbqzhsVAFkx/lC/f22sRycmmS9SCBr8ULIK
	rF1zuO7aOh+6FzO2+OYfrl5v/ch4Gw/6HCAdTJ5k8ZyJh+VvdHgYpMIe
X-Gm-Gg: AZFdTZdR/j7HQxdd0L/ti+lzGFaXL6bqjv04g1BCML88iJtjif9urDGNNMEYeBWUTji
	GGIxfXuuhDhJ43rr7Gf2gYjeH7ugeE207h9FLYMTs7AUnMWk7vTOL4v2/bV5OznxDBYXpUged9d
	J7VOwN/rZMcpywc/U1VO1A/3DFEhymUp9saXLSscQwl3+unm21e3KKNNlX8McO9BiDspe0YKFql
	Ylvkms9k0qslvQgZv9q1brZOwJgRVnWcZ/WUd5JX8dvF4mTdBYmNrPyHao26sHvEwV+oC78AWL1
	KwUylXq1GQ896YWr68dLyr33hRW6aOHAAEFbRsBYBOB8Rgqx7Qf/bGnvSvVIuYun8Rz7u02TFLq
	Dr2UOJWVJva4a88tamaDrQtsLCllqbVdmNix3/z7a+8nJWVDvm8NbVvTp4ZrkuHLXVvAXCgR6r5
	L08DvwpJPp6PwjalSta2dyw57i7DBNo5KBcSUnimgSBdj2gZ2fouZEqBmMkK/FZJ1OR9cdAKkuJ
	5VfTxHbePQjrX7oYFVJWydqH/yi8gH4Qzz7yDhnhum5iFHpFhzOUFnurwAlCfBqDdzgwHjg88ap
	EX4uH/e60GCpK3IrflwKkI14/eYWx7t+VFURY7dMnaUy9nKGRSsl24SOaRHYvD14PqiZsiDsEam
	l9axfqHTqi5eygQM8PXeYbrYu5zaVtK9Zwj8JFgHLPM/a0jX81EJ7wsoQUqrZsGLRg1U/SFw=
X-Received: by 2002:a05:6512:110f:b0:5c1:5814:4b94 with SMTP id 2adb3069b0e04-5c32dbc8a6emr66618e87.9.1795619850414;
        Wed, 25 Nov 2026 07:17:30 -0800 (PST)
Received: from wsfd-netdev58.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5c1bcf333bcsm4758135e87.2.2026.11.25.07.17.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 07:17:29 -0800 (PST)
From: Xin Long <lucien.xin@gmail.com>
To: network dev <netdev@vger.kernel.org>,
	linux-sctp@vger.kernel.org
Cc: davem@davemloft.net,
	kuba@kernel.org,
	Eric Dumazet <edumazet@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: [PATCH net v2] sctp: unshare GSO skb frag_list members instead of linearizing
Date: Wed, 25 Nov 2026 10:17:26 -0500
Message-ID: <739a5caed11c49ce53078747c43ea8cec5076d50.1795619846.git.lucien.xin@gmail.com>
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

When the iptables TEE target copies an SCTP GSO packet with pskb_copy(),
the frag_list skbs are shared by reference via skb_clone_fraglist().
The SCTP receive path then races on shared sk_buff headers in
sctp_inq_pop(), and can hit a BUG_ON in __pskb_pull_tail().

Commit fd60d8a08619 ("sctp: linearize cloned gso packets in sctp_rcv")
tried to fix this by checking skb_cloned() on the outer skb, but
pskb_copy() gives the outer skb a private head without marking it
cloned, so that check never fires for the TEE case. The frag_list
members stay shared regardless. Even when linearization does trigger
(e.g. for AF_PACKET clones), it destroys per-segment boundaries,
breaking AUTH: the HMAC is computed per segment on transmit, but after
linearization the receive side hashes across all concatenated segments
and the digest never matches.

Fix by avoiding linearization for GSO packets entirely. Add
sctp_gso_unshare() which:

 1. Calls skb_unclone() on the outer skb to privatize the head data
    buffer when it is marked cloned (e.g. from AF_PACKET's
    skb_clone()). For the TEE/pskb_copy() case this is a no-op since
    the head is already private.

 2. Walks all frag_list members and replaces any shared member with a
    private pskb_copy(), giving SCTP exclusive ownership of both the
    sk_buff headers and the linear data buffer. Data ownership is
    needed because AUTH verification (sctp_sf_authenticate) zeroes the
    on-wire digest and writes the computed HMAC back in place; with
    skb_clone() the data buffer stays shared, which could let a
    crafted packet pass AUTH on a second copy or corrupt data visible
    to AF_PACKET readers.

Fixes: 90017accff61 ("sctp: Add GSO support")
Reported-by: syzbot+f15a6eff7a53f6eb7dc3@syzkaller.appspotmail.com
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
v2:
  - Use a proper Fixes tag and refine the commit message.
  - Use pskb_copy() instead of skb_clone() for shared skbs in frag_list.
---
 net/sctp/input.c | 43 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 41 insertions(+), 2 deletions(-)

diff --git a/net/sctp/input.c b/net/sctp/input.c
index 9494cfa51106..f993191ee1ea 100644
--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@ -82,6 +82,39 @@ static inline int sctp_rcv_checksum(struct net *net, struct sk_buff *skb)
 	return 0;
 }
 
+/* Ensure exclusive ownership of frag_list members for GSO skbs.
+ * pskb_copy() shares them by reference; unshare with private copies
+ * so AUTH verification can safely modify the digest in place.
+ */
+static int sctp_gso_unshare(struct sk_buff *skb)
+{
+	struct sk_buff **pp, *p;
+
+	if (skb_unclone(skb, GFP_ATOMIC))
+		return -ENOMEM;
+
+	if (!skb_has_frag_list(skb))
+		return 0;
+
+	pp = &skb_shinfo(skb)->frag_list;
+	skb_walk_frags(skb, p) {
+		if (skb_shared(p)) {
+			struct sk_buff *copy;
+
+			copy = pskb_copy(p, GFP_ATOMIC);
+			if (!copy)
+				return -ENOMEM;
+			copy->next = p->next;
+			consume_skb(p);
+			p = copy;
+			*pp = p;
+		}
+		pp = &p->next;
+	}
+
+	return 0;
+}
+
 /*
  * This is the routine which IP calls when receiving an SCTP packet.
  */
@@ -117,8 +150,14 @@ int sctp_rcv(struct sk_buff *skb)
 	 * it's better to just linearize it otherwise crc computing
 	 * takes longer.
 	 */
-	if (((!is_gso || skb_cloned(skb)) && skb_linearize(skb)) ||
-	    !pskb_may_pull(skb, sizeof(struct sctphdr)))
+	if (!is_gso) {
+		if (skb_linearize(skb))
+			goto discard_it;
+	} else if (sctp_gso_unshare(skb)) {
+		goto discard_it;
+	}
+
+	if (!pskb_may_pull(skb, sizeof(struct sctphdr)))
 		goto discard_it;
 
 	/* Pull up the IP header. */
-- 
2.47.1

