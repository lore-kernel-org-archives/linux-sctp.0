Received: from out162-62-57-87.mail.qq.com (out162-62-57-87.mail.qq.com [162.62.57.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B48E73463;
	Tue, 21 Jul 2026 13:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784639666; cv=none; b=bkvVaSmcJ4b8MhLlCzghioczGfXn9UlDZoDkLiC3E+oq8cZxzVeHQH2xh8XZ2d7rYsT1Z3iFh/P5yPsvTNVBKuJuBVcxbI9o+w1SfrP62KAuueRz5ZtTNJXJx2J6WvEWHQ5XEMR3VQDPHu7TIUdrBmGoUnHiJBZUkdAfqWHZ4V0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784639666; c=relaxed/simple;
	bh=E+D4LCPVMbkCkLDDjLmvN6I4bCDR45veuoRy3zsEM8U=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version; b=Lt0RFNnwjL3PrcYM8Nsz99fgbjKXJrZAAUEyiwQuHwIeRKIcadAeijoBW416980VpIq3xvKTzZD4EQUOyv2iUabeOG4yzI0ysFCQo5Ng3Q08rV5XnHE+b31nkaPKDFZDSvFBvDjteDDHTf+/C3D6Tlsk3jtvgN6KyMiYcjmTgMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=wiuDwvyp; arc=none smtp.client-ip=162.62.57.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="wiuDwvyp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1784639652; bh=SQ6H4JXhEyLg3UsgJMR2/KD9tTsREmPUHR2uX9ervVw=;
	h=From:To:Cc:Subject:Date;
	b=wiuDwvypEXIvUPBMmW4MdX1vhv2wvHD5fCUsajVC5+tuuFrsgQHjlB6bTBU9OIllP
	 qjCaHrDUwXdUrP8LQ/RCfhhsCrYNwZKVyVej84nOUffPlp8ImhHXE32lyA14muyDMG
	 t9n0GdCcuiU+aVSqvjcvUaHSrjmJXwK5fp9JliY0=
Received: from 192.168.1.6 ([183.17.126.18])
	by newxmesmtplogicsvrszc43-0.qq.com (NewEsmtp) with SMTP
	id 38739813; Tue, 21 Jul 2026 21:14:07 +0800
X-QQ-mid: xmsmtpt1784639647tlpegqhs8
Message-ID: <tencent_73762ED1DF08CC9D5F5F61954B01350CFE0A@qq.com>
X-QQ-XMAILINFO: NPa98HB0c72NIwp3rT8va3enN/ZxsufbYyo2EtCnl24DJXOYf68bUuqLwqfHgR
	 xSjIml4M0/lurG2EgB0s/BQdceTk+aCIjeFIOJotrm4ZsA0CGHEsajDauTky4igUpdV1dY8SDsiy
	 b+l81jR2E17nc967bKVnm5Mf6u1/bwncnnGTSZVM1ft/TPnnY8+iacKgsBDaQlDmewmzojOzWarQ
	 w9R2cQVF3DsfsBZHiNSr0J+Qh2g8FMn/2/le2AaUXZF7Bb2D7fY50P0izh/1A6SujD0xZOlnTwj+
	 eZELNgnzImrE2QSVHYrW6leio1U3YXxMFJw+8EWg/EiyEJkqubavvuHJG/waZjlrz4eMZ4joK+az
	 8BDNzK7rfuig0+6MCVO9fM5eVMmUPWZYuwhpKMI9ol3l6t+y/4OfhPNN2+q1WMxWs5lVXMGoyasc
	 k2KBcgf3sL9lwp6Rg5hGtl0dBJ6XWG5u09Cy3V2+kg1D+ljCdApqtROZil75Ur3s/WS6aObJrNCb
	 tedw4b5FNklzDWCRflN6ICjffcAxxEpdj7OeqTlgiqfIt4ibkPmeHKTNyAfQWIjAsxq6z55L4mr1
	 JZPQzh+Gl4r/JvGfWh4CLN8PBC5Xykg+0i06eR9dW5Gw9GxAKaz9k9C0LZDLfF7pGP8wR7anSQI+
	 nn520xi5R+NwbWD252rmWHXLCHwlEh+bJJ/NAJ58+ZkpyLNKzaitYRz5bcfb/W4s8aXgI6V8+Mcq
	 DSPouatgNq3KvcTNGbioAaP3zf1qc18+usl5gBkE3ifD1QdwTDfJFpWtGTjuTF6XQSzjc0eH7+fo
	 8BZQs24hxx+wxdOj5d7lH3sxI4gs2sH/5SfCI2/zd+QD+tTRB3XGLVwJZ2OrQa9zozMs2QiFPWnO
	 WSoCYvWufP7o7fbjOpD/cp0RfLw6rOLU7teMc+KBNVA/Aagf4OFp2kvg8eNCL8WBqV/KhG/QO5ER
	 +RlEW1/r6hl8KLZ9syInrGY9/A8F4ogoFkl8tCt/yuL+A9S5L2FX69LS+4aMIysTQuxJq53vuyFe
	 aQAXlUaVeCHbQnG2u1
X-QQ-XMRINFO: OD9hHCdaPRBwH5bRRRw8tsiH4UAatJqXfg==
From: Jun Yang <1753810072@qq.com>
To: netdev@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	linux-sctp@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jun Yang <junvyyang@tencent.com>,
	stable@kernel.org
Subject: [PATCH net v3] sctp: don't free the ASCONF's own transport in DEL-IP processing
Date: Tue, 21 Jul 2026 21:14:05 +0800
X-OQ-MSGID: <20260721131406.71630-1-1753810072@qq.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jun Yang <junvyyang@tencent.com>

sctp_process_asconf() caches the transport the ASCONF chunk is processed
against in asconf->transport (== chunk->transport, set once in sctp_rcv()).
For an ASCONF located through its Address Parameter by
__sctp_rcv_asconf_lookup(), that cached transport corresponds to the
Address Parameter, which need not be the packet's source address.

sctp_process_asconf_param() rejects a DEL-IP for the packet source address
(ADDIP D8, SCTP_ERROR_DEL_SRC_IP), but nothing protects asconf->transport.
A single ASCONF can therefore carry, in order:

    [Address Parameter L] [DEL-IP L] [DEL-IP 0.0.0.0]

where L differs from the source. The DEL-IP for L passes the D8 check and
calls sctp_assoc_rm_peer() on the transport that asconf->transport still
points at, freeing it (RCU-deferred). The following wildcard DEL-IP then
reuses the now-dangling asconf->transport in sctp_assoc_set_primary() and
sctp_assoc_del_nonprimary_peers(): set_primary() dereferences the freed
transport (->ipaddr, ->state) and plants the dangling pointer into
asoc->peer.primary_path / active_path, and del_nonprimary_peers(), keeping
only the pointer that is no longer on the list, removes every real
transport, leaving the association with a transport_count of 0 and
primary_path/active_path pointing at freed memory.

Reject a DEL-IP that targets the transport the ASCONF is being processed
against, mirroring the existing source-address guard, so the wildcard
branch can never reuse a freed transport.

Fixes: 42e30bf3463c ("[SCTP]: Handle the wildcard ADD-IP Address parameter")
Cc: stable@kernel.org
Signed-off-by: Jun Yang <junvyyang@tencent.com>
Acked-by: Xin Long <lucien.xin@gmail.com>
---
v3: return Request Refused instead of Request to Delete Source IP Address,
    as the protected transport need not be the packet's source address.
v2: add [net] subject prefix to target the net tree.

 net/sctp/sm_make_chunk.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 8adac9e0cd66..b14251214896 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -3153,6 +3153,12 @@ static __be16 sctp_process_asconf_param(struct sctp_association *asoc,
 		if (!peer)
 			return SCTP_ERROR_DNS_FAILED;

+		/* Don't free asconf->transport; a later wildcard DEL-IP
+		 * parameter reuses it.
+		 */
+		if (peer == asconf->transport)
+			return SCTP_ERROR_REQ_REFUSED;
+
 		sctp_assoc_rm_peer(asoc, peer);
 		break;
 	case SCTP_PARAM_SET_PRIMARY:
--
2.55.0

