Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793902914;
	b=yaZV7kzC3jUwB7XbPzUeHA4TyIzjOmJTZAAu7yCf0NbZrvrfpWujY7u2WW7uBMHdMgwd
	 dEgVXEFk3EWdvUPzLv898v64RaiCnIZoHEyxtvm/Fd0QxXGr7OXgLvX4CU1+lIAJv3S8/
	 16UXAq98NM8bYAtnHcQggIq11yWtukzAgWt5TlQ98UlSPuoIhmAfsfVzuejtuLoPZkNAO
	 pFLyU7h0SqOgud95KOuOG8dMVzJj7y7NC6BIu2RH/Kq8PsZpK/w8v61CW8zK8sWXvrLtx
	 ooO8563lqlZIep2Z+jK6LZCNviJg+R8/+Sh3gYZR8rKfpj7FilhnsAWNWggdOaskAIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793902914;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Xe5bXUoSjdyUS5Z/rgEUMSGbH/+ArslOY+WPxBZy8QA=;
	b=LiZUbNHkAP4AwxNzAXbybhY7hnn0joRtmDlHxNuZks3G37NXysVdWMcWFk88xSkGueNn
	 SgIVgKd82fTq9lXKyXxTaUmKOpp5vwX+8Q0cksLv6dJ1Lt5m08QIi2PkseOGhbY35R99w
	 HWV2WLAmDUGCNPzwuoPXTXSmHDoiDTIb+N2rYYbeHAovxalcP2ruuMZZ4ukweUoQKe0tg
	 a5MlA/Mq7HtrRFeNHkPQ+7bMSgdtesRaZz6T2xvjuri1R8fAWqrtJfJ1Ka2sFpdTZMLov
	 F00ut8jKY3FzKqOlgFx/fkBOWOGOKpZ4HQmNChV13+b/ybHfNpe+IzyYopu7NOtZGBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=T2h0DhmR;
	arc=none smtp.remote-ip=209.85.128.178
Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3114E606A326
	for <linux-sctp@vger.kernel.org>; Thu,  5 Nov 2026 18:21:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3114E606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=T2h0DhmR
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-8b3299aed39so9358067b3.1
        for <linux-sctp@vger.kernel.org>; Thu, 05 Nov 2026 10:21:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793902913; x=1794507713; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Xe5bXUoSjdyUS5Z/rgEUMSGbH/+ArslOY+WPxBZy8QA=;
        b=T2h0DhmR02KOcmPE3YSD3Y18dAo1C69YstjJVJS3mpOsZgFM0hiT0zJagopeMurV4s
         GKfG+7h8mU4t12KFU+dSIRGQhSKjfRX3zLKEFKB5kK9JCGQKDNm6iqBr/d+1R017glvl
         UGZIrRfWrMGhkno2kGGr0FleUY43JQdOCx28g/W+lezrqyPTldeTrq7Vkj0+MNkgeeyG
         wxIKpxytgEeY7Hubcpo8l6VkECHQuFLvnSO7cGtkRbfLhamCQSUdRPdQWW/dJk4eOVpB
         e2wN+OIY2gCwwGR6wPMF+99UjlqIgnmh3ji07XoaG57SZb3AKC3QweXNbObTGDb3M47K
         Za7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793902913; x=1794507713;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Xe5bXUoSjdyUS5Z/rgEUMSGbH/+ArslOY+WPxBZy8QA=;
        b=dheUeWtOFTTvl9vmwbyOmpjxkvd5oPAYgoon7GA+7lPWZ6mWRAgFWsxc+wp4i4wiuH
         jvkhf138/IhNCFyudWfdfpL4oGUhOwumCfBiPDom2M5Sp1KDipM25lHAz22iGS0tyTWT
         K32OJhHn5YyUUmxZbScjQF2APtrsaiMNA3Ud6rKmavvj25Ajr4jm3jafKDUdg2P01MCq
         nw+LkgTkm+WpZkzvlD6lLJexFytM4f4Ot4fCoKjUc9UV6s5QPATLT+Rn5i5P7J1gVk/5
         jPojGw9saw4t1jgOJkZhJnHCybMvJmEJlJGL2TGqNdH3q5eGwevmAYEA7ktFLB05PZb2
         QdZA==
X-Forwarded-Encrypted: i=1; AL+hErEQfQ1iKQyFe6FgjY0vjiNNEfvYmV0ZT2r0mMoXWf2h2/VE2usZJJnItZS1NGr6Qb1WFvtLci2m+HWJ@vger.kernel.org
X-Gm-Message-State: APuU4Z9zaKOTTB6KuYQ3tlQl9ys2FFsF1g/qhb/yf/ENN3nZv4H1Ksz6
	wznLmh18t8KRDGPdjTpgPedCHNFOae/nU5PP3u8l9BZEgVd3KWyJp0T3
X-Gm-Gg: AYBFou23nkIxuZdDyycuuycjsMWj+I1u82y65souNT4rUSFvmj1BGhgy32bkpNhsWUq
	X2Ek6TZxw0W62LXx13VbMP7Wb7wdaJgkt2kXQGoG1nBzhY3EU/JxlPeR3VUXhNp7Qkye3frNGoB
	RlfXL8+6MDT2ewL7i0tN8ARJr4oxIa8J0bXN1gAwD7elo0E03RychihsNDORhbhSKvBtiijLWhA
	uYZVNjwEroSs7T2qScnFnHf+99XSEiDQqmUln1G90eRq6Du6mI/e7NpFAzNoPJqrGNtz+axIqxF
	rUhu+cohA46MXM7DPqXg2ZnIH929VVfQieW/cLYNOGhjHseD4tRVbYJpqeHf1Hc1PoJir7MWyEn
	0OLi82+WpXQygzgKRcMbP5+Mq43N8rw0vlW/IO0Z/b83BT13aLmBQ+KpURKlSujQyRocfDI+JeR
	ML7TzzzKCpmfH2L8HBqUlzasPT5fg1Kg7jdtLJJIZ++ZMOaW8ua7ZhfbusoA1lxh0mk9h18oL0H
	GzgJm3jSLfCObsH2nwuOslybUdipEEcw7lRbHBK6pNpWzwZKNIjtzY+rHxtPy4hoCcfjl6EiF02
	dbaXiLmrYZ7YWP54/fLyU0Gbervl45p5JwO9wD2DChCDS3n7vYtFmP2ZoT4C0+1jkMBOAzOcYri
	ITg58HaNSFXZcFmaAc/4viH9PqZ4MlEFCP2kyq36auDPT0K1zvzO1onxIouYktumcYp+1yWyoEd
	IAfMH4yhrX8d7jwYQx
X-Received: by 2002:a05:690c:e3ce:b0:8b3:343d:af6 with SMTP id 00721157ae682-8b3343d0bcemr9671047b3.91.1793902913216;
        Thu, 05 Nov 2026 10:21:53 -0800 (PST)
Received: from wsfd-netdev58.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b33f7f084fsm1284817b3.20.2026.11.05.10.21.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 10:21:52 -0800 (PST)
From: Xin Long <lucien.xin@gmail.com>
To: network dev <netdev@vger.kernel.org>,
	linux-sctp@vger.kernel.org
Cc: davem@davemloft.net,
	kuba@kernel.org,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: [PATCH net] sctp: linearize GSO skb when frag_list skbs are shared
Date: Thu,  5 Nov 2026 13:21:51 -0500
Message-ID: <9997493edadfe9faa713c73de9c70e36cee9ffea.1793902911.git.lucien.xin@gmail.com>
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
the new skb shares the frag_list skbs by reference (their refcounts are
bumped but they are not deep-copied). The SCTP receive path skips
linearization for uncloned GSO packets, so it later operates directly on
the shared frag_list entries. If skb_copy_bits() encounters a length
discrepancy or invalid offset in such a shared frag_list skb, it returns
-EFAULT, which triggers a BUG_ON in __pskb_pull_tail().

Extend the linearization condition to also cover GSO packets whose
frag_list head is shared, so SCTP obtains an exclusive, contiguous
copy of the data before processing it.

Fixes: 4c2f24549644 ("sctp: linearize early if it's not GSO")
Reported-by: syzbot+f15a6eff7a53f6eb7dc3@syzkaller.appspotmail.com
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/input.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/sctp/input.c b/net/sctp/input.c
index 9494cfa51106..db3c7818724b 100644
--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@ -117,8 +117,13 @@ int sctp_rcv(struct sk_buff *skb)
 	 * it's better to just linearize it otherwise crc computing
 	 * takes longer.
 	 */
-	if (((!is_gso || skb_cloned(skb)) && skb_linearize(skb)) ||
-	    !pskb_may_pull(skb, sizeof(struct sctphdr)))
+	if (!is_gso || skb_cloned(skb) ||
+	    (skb_has_frag_list(skb) && skb_shared(skb_shinfo(skb)->frag_list))) {
+		if (skb_linearize(skb))
+			goto discard_it;
+	}
+
+	if (!pskb_may_pull(skb, sizeof(struct sctphdr)))
 		goto discard_it;
 
 	/* Pull up the IP header. */
-- 
2.47.1

