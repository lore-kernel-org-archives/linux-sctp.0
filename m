Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B4F63191D6;
	Thu, 23 Jul 2026 06:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784787110; cv=none; b=qg6E54e8kmUDPfnnwlp1UPC+rv7cpZw4+5vyQBGa/fH2Dkx0GbCaCfe/vQRmhnjle3FR4+4+PDJ1JBOJqzu5h1taJtLXUzjfBjnz/Kwv/OseawpNZ0GqhV0985oqdiKb0il6FGcz3jABwiAcHOQBIlmz6XEdJKot7ahveunlGkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784787110; c=relaxed/simple;
	bh=LHmEKaYmWXGITCrasztQphx/8wabIM7erIyHH+/csag=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oniWThWdIH0t/eof+mu6C7W36tuCCtFObHtceXxfWQ6nEzPKWb4yJxDaS9BkF9JOWwwVrLnQZ21rRY1NJx7/HvMuhDwo8xs7IYwI3DL498xamTbqDdlks0IqQCTCvix7obDsS2sqg3l5obIhmRX2YoueaSK7BnKl9O8c3+yj8EU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=gXeZmHOs; arc=none smtp.client-ip=117.135.210.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="gXeZmHOs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=eD
	R89LDj3mQm3zPoiNOPEfeINdvP5bFqiYEXwnnrldg=; b=gXeZmHOszy85a+iZly
	P7BEO2dCVwOeMPVLFNQg6p6xEA7uOQCiBd4k/+pKAV4OjbenbE1gsYjDmiPBALAe
	G6xuLGu/7bgxHqHdOAH4yuZhpTdsvnplSYKBW8Mc0onswB4gdfDGawBIvGSzDmOq
	2y9QUTDR8CV5+ky9RXvFfJDVY=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-1 (Coremail) with SMTP id _____wD3P0V8sGFq3yyfKw--.38858S2;
	Thu, 23 Jul 2026 14:11:09 +0800 (CST)
From: luoqing <l1138897701@163.com>
To: lucien.xin@gmail.com
Cc: davem@davemloft.net,
	edumazet@google.com,
	horms@kernel.org,
	kuba@kernel.org,
	l1138897701@163.com,
	linux-kernel@vger.kernel.org,
	linux-sctp@vger.kernel.org,
	marcelo.leitner@gmail.com,
	netdev@vger.kernel.org,
	pabeni@redhat.com
Subject: [PATCH net-next v5] sctp: auth: discard auth_chunk when skb_clone fails
Date: Thu, 23 Jul 2026 14:11:07 +0800
Message-Id: <20260723061107.384106-1-l1138897701@163.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <CADvbK_cb8Q=9nv5Z5eR3cf=NLb=5=wSg_HKHrtCtPU_bAN=qvg@mail.gmail.com>
References: <CADvbK_cb8Q=9nv5Z5eR3cf=NLb=5=wSg_HKHrtCtPU_bAN=qvg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3P0V8sGFq3yyfKw--.38858S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7uw1kGw4xKFW8XFyDtr4xWFg_yoW8CFy5pF
	ZxK3W8tw4UJrnrJrZ7Awn5ua1Y9ws5Gay3CFW0ya1aya1DXryFyrW5t3W7Xw1UuF43u3WY
	vw40ga1Y9a17CFUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0JUUxhdUUUUU=
X-CM-SenderInfo: jorrjmiyzxliqr6rljoofrz/xtbC+R4+gmphsH76jgAA3q

From: Qing Luo <luoqing@kylinos.cn>

When processing AUTH + COOKIE-ECHO packets, if skb_clone() fails
due to memory pressure, chunk->auth_chunk is NULL. The original
code still sets chunk->auth = 1 and continues, leaving the
COOKIE-ECHO to be processed without a valid auth_chunk for
deferred verification.

Discard the AUTH chunk early via pdiscard when skb_clone() fails,
so that the receive loop can continue processing remaining chunks
in the inqueue instead of stalling the entire packet.

Signed-off-by: Qing Luo <luoqing@kylinos.cn>
---
 net/sctp/associola.c   | 4 ++++
 net/sctp/endpointola.c | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index 62d3cc155809..a5f2835dbe0f 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -999,6 +999,10 @@ static void sctp_assoc_bh_rcv(struct work_struct *work)
 			if (next_hdr->type == SCTP_CID_COOKIE_ECHO) {
 				chunk->auth_chunk = skb_clone(chunk->skb,
 							      GFP_ATOMIC);
+				if (!chunk->auth_chunk) {
+					chunk->pdiscard = 1;
+					continue;
+				}
 				chunk->auth = 1;
 				continue;
 			}
diff --git a/net/sctp/endpointola.c b/net/sctp/endpointola.c
index dfb1719275db..a15b599b20b7 100644
--- a/net/sctp/endpointola.c
+++ b/net/sctp/endpointola.c
@@ -368,6 +368,10 @@ static void sctp_endpoint_bh_rcv(struct work_struct *work)
 			if (next_hdr->type == SCTP_CID_COOKIE_ECHO) {
 				chunk->auth_chunk = skb_clone(chunk->skb,
 								GFP_ATOMIC);
+				if (!chunk->auth_chunk) {
+					chunk->pdiscard = 1;
+					continue;
+				}
 				chunk->auth = 1;
 				continue;
 			}
-- 
2.25.1

Thank you for the review and the suggestion.

I agree that using chunk->pdiscard = 1; continue; is better than break;. It avoids stalling the entire inqueue under memory pressure and follows the existing discard convention in SCTP. I will update the patch accordingly.

Thanks,
luoqing

