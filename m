Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC7004314AC;
	Tue, 18 Aug 2026 09:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787045015; cv=none; b=evkD8Gu1xSun4+fnI5zXK2x5FiEUYKrcoPKqFoCkYq6JdjkbUN8nlSflFb5qxqANnCeG0aBJyj49R24WsF2ZWZfALsj2JIzpCRARUyCp5rr8k7R0Tm9iJl5V3hYT8gGFe47pHXM16Rl90Q4GZ/OwZp67udEavazWirsmytxqxgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787045015; c=relaxed/simple;
	bh=402fMMssiIdPF2JcHwkS6V1FYpx3oE2pEMqwEW75whI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=eM+daQMVv8Y7JxxUFbUjr2eG8bKgzAXSES+a0AAo5i37Hx13ucLWefdvf/4N1p3uFqNDIFsm6HuJyQfY0qqVX6sw9b+4Vo7yz5rnkg/FZW7YlEj1/envIhPVVsLYFCTsB5XFLQmf4orW8mFBbKrnexMd6vRJ5IDTHACWCg08HM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=fDSn4c/p; arc=none smtp.client-ip=220.197.31.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="fDSn4c/p"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=Zh
	GA5Vh58hu3LJobhJ2/cESeBIPkyCAyVrsrvHtCACU=; b=fDSn4c/pLuSssRSvqY
	lVBRTbHFQHCO7CvVrd3+FJpoFI0Gl0fEPNmjpes8P0cKF1FsSPyZBRH6hKdUD4ca
	D66QNvdP/NDY5IbvAevlwaqpr3rl5gWeeDHRlQDYWVLCNVx1oGumX9Bo+1ofK/Z5
	+TXyAwQKez+srafy9/3rJwlhA=
Received: from localhost.localdomain (unknown [])
	by gzsmtp5 (Coremail) with SMTP id QCgvCgAn9c9sJIRqz2OcMw--.21125S2;
	Tue, 18 Aug 2026 17:22:54 +0800 (CST)
From: luoqing <l1138897701@163.com>
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Xin Long <lucien.xin@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	linux-sctp@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net] sctp: fix possible out-of-bounds read in SCTP_PARAM_SUPPORTED_ADDRESS_TYPES
Date: Tue, 18 Aug 2026 17:22:52 +0800
Message-Id: <20260818092252.782855-1-l1138897701@163.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:QCgvCgAn9c9sJIRqz2OcMw--.21125S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7WF18trWxuFWfGw47AF15XFb_yoW8tFWfpa
	48AFZ5trW5GF1qkFyfCw4xJw45Gan5JF4xGFWUtw15Jrs8Xr1rKFyIkrWj9ay5Ka1rWayf
	G3yjqa17CrsrZa7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07U6v3nUUUUU=
X-CM-SenderInfo: jorrjmiyzxliqr6rljoofrz/xtbC3Q7fJGqEJG7zqgAA3V

From: Qing Luo <luoqing@kylinos.cn>

While processing SCTP_PARAM_SUPPORTED_ADDRESS_TYPES in
sctp_process_param(), the length field is subtracted from
sizeof(struct sctp_paramhdr) and stored in a __u16 variable. If the
length is less than sizeof(struct sctp_paramhdr) (4 bytes), the unsigned
subtraction underflows, resulting in a value near 0xFFFF. The subsequent
for() loop then iterates far beyond the parameter boundaries, causing an
out-of-bounds read.

sctp_verify_param() performs no length validation for this parameter
type, so a malformed parameter with insufficient length can reach
sctp_process_param() through the INIT/INIT-ACK/COOKIE-ECHO processing
path.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Qing Luo <luoqing@kylinos.cn>
---
 net/sctp/sm_make_chunk.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 236e25abc7a4..ebf791969454 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -2169,12 +2169,19 @@ static enum sctp_ierror sctp_verify_param(struct net *net,
 	case SCTP_PARAM_IPV4_ADDRESS:
 	case SCTP_PARAM_IPV6_ADDRESS:
 	case SCTP_PARAM_COOKIE_PRESERVATIVE:
-	case SCTP_PARAM_SUPPORTED_ADDRESS_TYPES:
 	case SCTP_PARAM_STATE_COOKIE:
 	case SCTP_PARAM_HEARTBEAT_INFO:
 	case SCTP_PARAM_UNRECOGNIZED_PARAMETERS:
 	case SCTP_PARAM_ECN_CAPABLE:
 		break;
+
+	case SCTP_PARAM_SUPPORTED_ADDRESS_TYPES:
+		if (ntohs(param.p->length) < sizeof(struct sctp_paramhdr)) {
+			sctp_process_inv_paramlength(asoc, param.p,
+						     chunk, err_chunk);
+			retval = SCTP_IERROR_ABORT;
+		}
+		break;
 	case SCTP_PARAM_ADAPTATION_LAYER_IND:
 		if (ntohs(param.p->length) != sizeof(*param.aind)) {
 			sctp_process_inv_paramlength(asoc, param.p,
@@ -2600,6 +2607,9 @@ static int sctp_process_param(struct sctp_association *asoc,
 			asoc->peer.ipv4_address = 1;
 
 		/* Cycle through address types; avoid divide by 0. */
+		if (ntohs(param.p->length) < sizeof(struct sctp_paramhdr))
+			break;
+
 		sat = ntohs(param.p->length) - sizeof(struct sctp_paramhdr);
 		if (sat)
 			sat /= sizeof(__u16);
-- 
2.25.1

