Received: from mail-pj2-f3.google.com (mail-pj2-f3.google.com [74.125.227.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C96EE478E49
	for <linux-sctp@vger.kernel.org>; Fri,  9 Oct 2026 07:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791532002; cv=none; b=NCiH3WXO2vl/AtpwimxRsUFU7Ahb2GU6HCnyY+KVduKa6Kp/M5/RSV+VzLAKdbWgZfmgyrjNwdOe3xCJ004UJOBgzS1UD58Y5OlM8gpp5snlijqY/KWYG2FNsP3FF3KLTeZU8rjAmAQR1bwuaEfMRjId39vU9wPcXyIdnvBRpS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791532002; c=relaxed/simple;
	bh=+grsSZCeGjPJjHmjcAR86H9X3p7tblGNuACQPAt7aDE=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=bLep/mEHE1nCaRcNMnKFY+cTtBavcCMGnMI8r1vauHRUIQyDe5u5GhyeSgyZtAz0WaDKa/qj42OVqtI0F07AtzgXgGaZUEbDYGulvxW/UDnvBXCfEoAbre+LNLr8N21h2yc011a/h0JJxPK/iJ6xIDhseEl7KkbFu3I87KLkzvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EHJ7kYTi; arc=none smtp.client-ip=74.125.227.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EHJ7kYTi"
Received: by mail-pj2-f3.google.com with SMTP id d9443c01a7336-2e81c65b074so6266335ad.0
        for <linux-sctp@vger.kernel.org>; Fri, 09 Oct 2026 00:46:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791531999; x=1792136799; darn=vger.kernel.org;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=w8E1UM2uA2mgoa7ClHpQP/oej4PTxre8P1UpeWTgBp8=;
        b=EHJ7kYTiL0RZIB4ZWtwzU804X7OveKzrXAnyUPMYbfmILcIt9G5H7ZNP3DqQiTfLjz
         xiuDwuXmU9TodSB54ZnS7P4nBbfN3KLMxByZjax3/rew6YJlfuopc1CKZIGE8FAm7pbH
         PVCtD5pY916VpypxoUMR6gKFZVS7xHZ/Ev9rCaHijATwHD1M2Me/+he3qwwgiX9SvAsW
         RsoZhT8Yl8jMFrC35B2z0YHb8ARteM9AwJheDwDgmoMp9MfYlX33CyZls6LHHoJ6I8w4
         d+/Fdg0SXg03IYft+Z4N+A1n+gpAYzxPHljbWMfrcg5HSAcm63YtZB6eCOe80oxDY1K2
         Et4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791531999; x=1792136799;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=w8E1UM2uA2mgoa7ClHpQP/oej4PTxre8P1UpeWTgBp8=;
        b=lTDP09BIxsjuyCskJKOvlF9cJMM6GCKzkSDhQjMtXbIXAzRdiBTS04E6bS7YxapDmN
         qXq/zfVI4fCwjcvLvBe6wcEO8i06Q65z9U3p0ZvytO596geR2VcyKYvTRUjpmUt6We6p
         WpnzimHM6rVqOyLxxb+S4XVZnb4f20j8+FQPQp2mtg4hCwFGJNJQb+FEagRaqfVIlXCZ
         awdXr7pqGyDfgS5FvnKSoJAAvN5RZ3ywAYa7bfR2PladYHJq/NGEc4VtRv56UNdv+1Ds
         dd26ivFV+a/obeovtLyRMLytCzwKbr4MVJoYT5c7GW2IJnp1Z++SKRF1p4XrVb1QfC/6
         Sb6w==
X-Gm-Message-State: AFq9FYJUw3JugKakaMb+SrhQkA4fL9b6Cv6VV46PwoDr757ZYJadc0Yb
	ZeQ1q5GPoFQh6hWSyP/aIFoMoJRMcyY34o+oV862VcOJx3ROLQYAR5Ow57yEt7Md7qE=
X-Gm-Gg: AYBFou05l5H95kuq1slRbDfqHnRTEZ/h+r1plCW3ATF9ICcUMnE362OXGOB+w7KLkck
	VBWnvrhlAaIMxTy3kfPWz1L+wMl0sb82OaCl4n9NQneJx1LhBBgJxyrcIS1YsLOQijuPOpuq3oo
	aimdav8xgjOniipUUAyD9KJP0AZQptMiwaAXjqWj8RxJQ3DaMt3SUmySkoGuEy4ivksYoCZFTBm
	Ia+frzhWc9LxFc2vwV2EbXsVpem2k+3gMNPZlp9Wi08+q9hbZ3J9vu9M1Q+wsuNrRAByWi0u92g
	u6+stlzAqA8DCBBEMAUtv8YyZtWhrGNNSyEAjlmAyuqIQsG5pG9etjC55nRPywWjtYHePJBdfaO
	MN/3oMUKoFmi/pR2931+Tn6InetWcXH/cGhFwsK+VA3+OfDYdIsGOwQl+HCzuipab+uEQTaQpBk
	R6tfbbhp+wELFarf+v1B+eOli4ozx+DA3/xmxnlrawpwb7R5vI+rppsqWXIQZwA9B6avAjKEHP
X-Received: by 2002:a17:903:19e7:b0:2e2:c84b:43e9 with SMTP id d9443c01a7336-2e842837a3amr10138365ad.1.1791531999201;
        Fri, 09 Oct 2026 00:46:39 -0700 (PDT)
Received: from hhost ([120.231.212.218])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e841a02f85sm4980385ad.10.2026.10.09.00.46.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2026 00:46:37 -0700 (PDT)
Date: Fri, 9 Oct 2026 15:46:26 +0800
From: Xingyuan Mo <hdthky0@gmail.com>
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>
Cc: "open list:SCTP PROTOCOL" <linux-sctp@vger.kernel.org>,
	"open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
	Xingyuan Mo <hdthky0@gmail.com>
Subject: [PATCH v4] sctp: reject forged cookie peer_addr with unknown address
 family
Message-ID: <20261009074601.3954275-1-hdthky0@gmail.com>
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email 2.43.0

When cookie authentication is disabled, COOKIE-ECHO peer_addr is
attacker-controlled. An invalid sa_family made sctp_get_af_specific()
return NULL and crash in sctp_transport_init() on
af_specific->sockaddr_len. Validate it with af->addr_valid() in
sctp_unpack_cookie(), which also rejects a mismatched family, e.g.
an AF_INET6 peer_addr on an IPv4 socket that would later crash in
sctp_v6_get_dst() on inet6_sk(sk)->opt. peer_addr is validated in
place, so a v4-mapped v6 address is normalised to AF_INET before the
association and its primary transport are built from it.

For that, sctp_v6_addr_valid() has to return 0 for a non-v4-mapped
address when it is called with a socket that is not PF_INET6, so that
IPv6 addresses are never used on IPv4 sockets. The check is done after
the v4-mapped handling, so v4-mapped addresses passed to an IPv4
socket through the socket API keep being accepted. As addr_valid()
now also checks sk_family and ipv6_only_sock, simplify the address
handling in sctp_process_param() with it, as it additionally filters
out non-unicast addresses. As a side effect, a v4-mapped address in
an IPv6 address parameter is now normalised to AF_INET before the
transport is created, matching what the socket API paths already do.

Also add the missing !af check in sctp_process_init(), as
sctp_get_af_specific(AF_INET6) returns NULL on CONFIG_IPV6=n builds.

  BUG: KASAN: null-ptr-deref in sctp_transport_new+0xa7/0x350
  Read of size 4 at addr 00000000000000b4 by task poc/682
  Call Trace:
   <IRQ>
   sctp_transport_new+0xa7/0x350
   sctp_assoc_add_peer+0x153/0x850
   sctp_process_init+0xf9/0x1180
   sctp_sf_do_5_1D_ce+0x464/0xbc0
   sctp_do_sm+0x114/0x2990
   sctp_endpoint_bh_rcv+0x280/0x430
   sctp_inq_push+0xdd/0x100
   sctp_rcv+0x17f5/0x1ae0
   sctp4_rcv+0x2b/0x40
   ip_protocol_deliver_rcu+0x25b/0x270
   ip_local_deliver+0xd1/0xe0
   </IRQ>
  Kernel panic - not syncing: Fatal exception in interrupt

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Assisted-by: opencode:deepseek-v4
Signed-off-by: Xingyuan Mo <hdthky0@gmail.com>
---
v2: https://lore.kernel.org/netdev/20260913113522.2674588-1-hdthky0@gmail.com/
- validate the forged cookie peer_addr with af->addr_valid() instead of
  a family whitelist, and make sctp_v6_addr_valid() reject non-PF_INET6
  sockets, so a forged AF_INET6 cookie can no longer crash an IPv4
  socket in sctp_v6_get_dst() (found by Sashiko)
- simplify sctp_process_param() address handling with addr_valid(), as
  addr_valid() now also checks sk_family and ipv6_only_sock
- add the missing !af check in sctp_process_init() for CONFIG_IPV6=n
  builds (suggested by Xin Long)

v3: https://lore.kernel.org/netdev/20260915212917.3775248-1-hdthky0@gmail.com/
- drop the sctp_transport_new() check
- merge the !af checks into the conditions they guard with ||
- drop the comment above the sctp_unpack_cookie() check

v4: https://lore.kernel.org/netdev/20260917030505.4176635-1-hdthky0@gmail.com/
- move the non-PF_INET6 socket check after the v4-mapped handling in
  sctp_v6_addr_valid()
- validate bear_cookie->peer_addr in place instead of a copy

 net/sctp/ipv6.c          |  6 +++++-
 net/sctp/sm_make_chunk.c | 23 ++++++++++++-----------
 2 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
index ef26878f1282..97390569c4bd 100644
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -725,7 +725,8 @@ static int sctp_v6_available(union sctp_addr *addr, struct sctp_sock *sp)
  * SCTP.
  *
  * Output:
- * Return 0 - If the address is a non-unicast or an illegal address.
+ * Return 0 - If the address is a non-unicast or an illegal address,
+ *            or a non-v4-mapped address on a non-PF_INET6 socket.
  * Return 1 - If the address is a unicast.
  */
 static int sctp_v6_addr_valid(union sctp_addr *addr,
@@ -749,6 +750,9 @@ static int sctp_v6_addr_valid(union sctp_addr *addr,
 	if (!(ret & IPV6_ADDR_UNICAST))
 		return 0;
 
+	if (sp && sctp_opt2sk(sp)->sk_family != PF_INET6)
+		return 0;
+
 	return 1;
 }
 
diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 84a4c97d0f75..175dbb242e1c 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -1732,7 +1732,9 @@ struct sctp_association *sctp_unpack_cookie(
 	struct sctp_cookie *bear_cookie;
 	struct sctp_chunkhdr *ch;
 	unsigned int len, chlen;
+	union sctp_addr *paddr;
 	enum sctp_scope scope;
+	struct sctp_af *af;
 	ktime_t kt;
 
 	/* Header size is static data prior to the actual cookie, including
@@ -1841,6 +1843,11 @@ struct sctp_association *sctp_unpack_cookie(
 		goto fail;
 	}
 
+	paddr = &bear_cookie->peer_addr;
+	af = sctp_get_af_specific(paddr->sa.sa_family);
+	if (!af || !af->addr_valid(paddr, sctp_sk(ep->base.sk), NULL))
+		goto malformed;
+
 	/* Make a new base association.  */
 	scope = sctp_scope(sctp_source(chunk));
 	retval = sctp_association_new(ep, ep->base.sk, scope, gfp);
@@ -2381,8 +2388,8 @@ int sctp_process_init(struct sctp_association *asoc, struct sctp_chunk *chunk,
 		    (param.p->type == SCTP_PARAM_IPV4_ADDRESS ||
 		     param.p->type == SCTP_PARAM_IPV6_ADDRESS)) {
 			af = sctp_get_af_specific(param_type2af(param.p->type));
-			if (!af->from_addr_param(&addr, param.addr,
-						 chunk->sctp_hdr->source, 0))
+			if (!af || !af->from_addr_param(&addr, param.addr,
+							chunk->sctp_hdr->source, 0))
 				continue;
 			if (sctp_cmp_addr_exact(sctp_source(chunk), &addr))
 				src_match = 1;
@@ -2554,17 +2561,11 @@ static int sctp_process_param(struct sctp_association *asoc,
 	 */
 	switch (param.p->type) {
 	case SCTP_PARAM_IPV6_ADDRESS:
-		if (PF_INET6 != asoc->base.sk->sk_family)
-			break;
-		goto do_addr_param;
-
 	case SCTP_PARAM_IPV4_ADDRESS:
-		/* v4 addresses are not allowed on v6-only socket */
-		if (ipv6_only_sock(asoc->base.sk))
-			break;
-do_addr_param:
 		af = sctp_get_af_specific(param_type2af(param.p->type));
-		if (!af->from_addr_param(&addr, param.addr, htons(asoc->peer.port), 0))
+		if (!af || !af->from_addr_param(&addr, param.addr,
+						htons(asoc->peer.port), 0) ||
+		    !af->addr_valid(&addr, sctp_sk(asoc->base.sk), NULL))
 			break;
 		scope = sctp_scope(peer_addr);
 		if (sctp_in_scope(net, &addr, scope))
-- 
2.43.0

