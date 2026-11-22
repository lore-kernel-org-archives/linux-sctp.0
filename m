Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795388577;
	b=ZATzPyBVfZQ0lRNAPGzqGnKJSWuT3+AAaj8p024Bw1P4DFpTLAL1zSgSxJnIRb7fS1ke
	 7XimSoFVbR7Q9T/MM0sLqBFUXqTKVgzRhJtdUWN7dwFFyrYQCsdR2lUTmS5m1llO+dwRL
	 dAuWWjRf8TbFAs1tmD0Tu3ka5BiWiygx0Ld9HOxzNXFxH5FCar2nZYi4/IcAz5vuNyL+D
	 VTtgFQW2YUfBWQdrjn4X3B/4Ko82C6H6vj9NAS+RebN4C0uxzwcvSeahIMKxtswj6Zmu1
	 5n3G4TCL9yAoQ0su1fWRtFXtxFfh41m4u6YGbaKisTDuUm33fVYiPItg4aGEmpF3OlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795388577;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=2vtq+bJAgkK5J7ORrOJ12oBNTPI8ZkKXFNJnCJW1Feo=;
	b=jPqB7XHBpx+Oo0T1n/GAKSy2S9gTEYuReFrFGuhatUGKgQkPkPpa46FgABlP1nS5fGia
	 Hyv4BGRvn3/vnAmqOxM6JgLqBIJLocENr7c+BT0a4utZwf+fnzR+SxD6DpcF0HKEGfMKr
	 c9BsaJ4aNhki5upIkP28lI8w5h3k78Lw1yuUS68F6yTNqRre3hCPSpXX67+sBvpZtxhEi
	 piNrykrSVsY0NMwxXMhcAMAVYdUaoo5xFX4i/JdkAUqJGhS9UsXaZuN/uWK5QhyA3hRlp
	 H6ktFJgC7vbZOmetg+MVbG8P82aeauFRLF6ZdJh3hAyeggvfc4zvbFszasbLjZPcPMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=QwtFPDgv;
	arc=none smtp.remote-ip=209.85.160.178
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 873F4606A31A
	for <linux-sctp@vger.kernel.org>; Sun, 22 Nov 2026 23:02:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 873F4606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=QwtFPDgv
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-55d846e884eso15143811cf.2
        for <linux-sctp@vger.kernel.org>; Sun, 22 Nov 2026 15:02:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795388576; x=1795993376; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=2vtq+bJAgkK5J7ORrOJ12oBNTPI8ZkKXFNJnCJW1Feo=;
        b=QwtFPDgv33BmxV4+Xike/FEy+L6uSWkDBttFSL8qbI08MhA6opEgTJBj1O/gs/LSvY
         pkvsTKWtjLTPRarMAcO9KVr7YrVofDVztR8jrlByPdX0lOz9KGCXWo0UbBkECNy7mG2H
         AUhs2d82k1eG5fGubgc+UPZluBpk7e60+YQERHTtZlrA1KxwLWwG8Ne28iWG+wSDAcHk
         mzalP5xMme+ZP+HtFr79YL1sf8+jkcTyy2xEXn3xboo6rtuVEwXlSvbOI24KaSG+7q2D
         OPc9sarA94JGm/ha2Qea/IV/C1+e42KX6JVqoI01j+67mfS6ldYTLtT2N7JRZVM66zfS
         kbXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795388576; x=1795993376;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2vtq+bJAgkK5J7ORrOJ12oBNTPI8ZkKXFNJnCJW1Feo=;
        b=iWNEjMVElYXo7Lbv5kMwbIIT1NkhftrKY2Wau7sA5GtIYg7JrJcXP2QlfKsoOa0S1r
         X1fAqtvvoY8M9CV2z61Vz+joQ/c8FgALAbheqn2pwVXiS6PKYPzn77xLo+DDUbExwRsa
         mM2/+GrZCpvECDwcQgdVApUGZIfOXqyU7BgLq9MuqiP8GqAPs97NKZoVQt3xU/RbGDAc
         v++O5nEqgiv2MdmEwXY+fJzYbnhKv4d8b0c0qpeoeKfv1eIs+QeZbO+tHG1mrrgGp5nt
         sQvK02MNFK24rKXUkb6cxbAoQNquHm9F7TLb/s5a+/bOu7Ne/hGVxBZmep/4+eZcSAcf
         LYyA==
X-Forwarded-Encrypted: i=1; AL+hErEq5Pp0mZc7XDsAuDeboQBN9V2fklo8ZAEIdJeMto1ToiXGW3TvoRfbr9Hk/bIXnWQlqp1SFgY7YF9G@vger.kernel.org
X-Gm-Message-State: APuU4Z+D0/XJhsGgDjXS4s1PUiT9l/PJ5CWxfWlxIXM7iWrdUO90BbcX
	zfxz07VniWuZmSp5furLcHqkIHYPhuca0OB3tQIYE90YprrI9D9NoFUp
X-Gm-Gg: AZFdTZc8lp8hAm3lwd7ffbzdcujx8noxY8w5fOH17xqdqIaBuaGS1tYihgysZY+1So7
	uZrTF3QOrfo5pLCuTv6xofNuZBiRIu4q6aeLnfAjskeUuLbVQZP68Hzdky026ax/tb1XEHGe6Xb
	U8cDyAYov4OsX71qcG8IMoySFYLDi6GQj8ySllEu8kD0imSjPscasE0+/wdgA0O45dRgEDPjYtC
	xYmu7uJsANl8jKaA8u9qytY3oG/lBSyWznhdqwT+yuAf11lopv1t4GvnLEaFCIpOVSvCf6xYytT
	7ZnGMLGXxtBwIbEMfe0KyiQzmY0Kamf1JvHdqrp9pO/3Pe28e38kmAF/K3BdAVdGwU69p0KhDnJ
	xmCHsANfeyuNjB2a7azrgzmx6gvpSSlkzvstq/uh5tx7ItteWB+ko2yZ6Yq0yTcCv/XGDfEwKwm
	5tqWEHIL1FIr4GqKxhs1WUndliI9Q5S9JTIki1oVMeBxHS0INEtXmd9uhx+gTTLnhMxfqSMpydG
	dnPuxzYVq3J5djvvRq9tpLmlAudC25VmgffyCUrNLrd2i/fle8HZVzDF8+WYljzLEwTii/y00i0
	L+CYWf+6MAysUHYEBW3x84pUjLz+M/kzS83Itz20PUEfaoa0xh7kXjJLkpQA+J7omXZp+y9EYLB
	jz1q2IbiJ03j7OzzxQuQvMuqDrWU8uDVQ1d+JhE+pPssTZNityVOyejqAz+6qYMPe8cb7CeaBPa
	+ZlOoShBNbUepbAGSe
X-Received: by 2002:ac8:5a08:0:b0:55d:25a1:72ac with SMTP id d75a77b69052e-55d76a26882mr177747901cf.27.1795388576409;
        Sun, 22 Nov 2026 15:02:56 -0800 (PST)
Received: from wsfd-netdev58.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-55d788506b0sm82756661cf.17.2026.11.22.15.02.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2026 15:02:55 -0800 (PST)
From: Xin Long <lucien.xin@gmail.com>
To: network dev <netdev@vger.kernel.org>,
	linux-sctp@vger.kernel.org
Cc: davem@davemloft.net,
	kuba@kernel.org,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: [PATCH net] sctp: unshare GSO skb frag_list members instead of linearizing
Date: Sun, 22 Nov 2026 18:02:54 -0500
Message-ID: <20e1d469385153bcfa766080453e8d9c1d64c339.1795388574.git.lucien.xin@gmail.com>
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
the frag_list skbs are shared by reference. The SCTP receive path then
races on shared sk_buff headers in sctp_inq_pop(), and can hit a BUG_ON in
__pskb_pull_tail().

The previous fix in commit fd60d8a08619 ("sctp: linearize cloned gso
packets in sctp_rcv") checked skb_cloned() on the outer skb and
linearized the entire GSO packet. This is insufficient for two reasons:

 - A partial pull into the frag_list can privatize the head while later
   members stay shared.

 - Linearizing destroys per-segment boundaries, breaking AUTH: the HMAC
   is computed per segment on transmit, but after linearization the
   receive side hashes across all concatenated segments and the digest
   never matches.

Fix by avoiding linearization for GSO packets entirely. Add
sctp_gso_unshare() which:

 1. Calls skb_unclone() to unshare the outer skb header without
    flattening the frag_list.

 2. Walks all frag_list members and replaces any shared member with a
    private skb_clone(), giving SCTP exclusive headers (data, len,
    cb[]) while still sharing the underlying data buffers.

Fixes: fd60d8a08619 ("sctp: linearize cloned gso packets in sctp_rcv")
Reported-by: syzbot+f15a6eff7a53f6eb7dc3@syzkaller.appspotmail.com
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/input.c | 42 ++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 40 insertions(+), 2 deletions(-)

diff --git a/net/sctp/input.c b/net/sctp/input.c
index 9494cfa51106..cd84ee44b9f2 100644
--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@ -82,6 +82,38 @@ static inline int sctp_rcv_checksum(struct net *net, struct sk_buff *skb)
 	return 0;
 }
 
+/* Ensure exclusive ownership of frag_list members for GSO skbs.
+ * pskb_copy() shares them by reference; unshare by cloning in place.
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
+			struct sk_buff *clone;
+
+			clone = skb_clone(p, GFP_ATOMIC);
+			if (!clone)
+				return -ENOMEM;
+			clone->next = p->next;
+			consume_skb(p);
+			p = clone;
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
@@ -117,8 +149,14 @@ int sctp_rcv(struct sk_buff *skb)
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

