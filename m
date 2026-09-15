Received: from mail-pj2-f6.google.com (mail-pj2-f6.google.com [74.125.227.134])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE20C4825AD
	for <linux-sctp@vger.kernel.org>; Tue, 15 Sep 2026 21:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.134
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789507774; cv=none; b=tAW3aS329T6xwKrfYmOKtxyPe7vxbWt0GJnLrdRWc7BH0NEphZ9Crt6b6yLNJpwMaHmgnuSmGieXW7SD/zGL8ijLFgXS75Wx8+lc5MtoZJat3/tfFPBDUYJDUP/RR7JmW64XHktK6JAtVpMVom1MPl5/sHM659S26T7PZtjf4Ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789507774; c=relaxed/simple;
	bh=vVD4pS5qS6maXiv6EP3biLQD2gpeIwM0hPXlQBwWQUw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=S23w74RHRWnGMAp9jAtuf9RoKA8TrAIhTXgkR9XMewUJ9At/zR7wRV0K++8yrrplh79AQ7XwvAuyfTb7JusWqy8P1POK4xyOk5tXLzk4x+Mt4fYYaKB8kxoMX1/6itqoYyvKVOMaLo5cyn6PHgKyt1FzKKYG+gqA3hbTvmz7DsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jOdgYKo+; arc=none smtp.client-ip=74.125.227.134
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jOdgYKo+"
Received: by mail-pj2-f6.google.com with SMTP id 98e67ed59e1d1-3964e7720afso3314445a91.1
        for <linux-sctp@vger.kernel.org>; Tue, 15 Sep 2026 14:29:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789507772; x=1790112572; darn=vger.kernel.org;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uAEOVcz8d/teGZZzHqLM89uMtEOQp+zIbDQel4kYlnE=;
        b=jOdgYKo+KpR/pxdhSQn5P+9fhjxCEKs47ABBcKd8KI0gEMX3NbDDeUIuXDACJnCpfL
         2EnuWaL+gsIxP5WWC0evf00ka6TOS30tm4fZlTGnDkNhlkWq5vDDhhV2AqSad8K1n3j7
         xdwocfLNbHqbuM4W2LF9TQGGo84svW7jFPGJsSDkH2bpDxK5i26E7cUkmj04+fDwI1lt
         e6VEw5sk9mKVShMP5bN/eDCGPQI9eUyrRS5plBdepmrUW2JMlNovhA/8dfeY95D3jqKQ
         EhV9bgmhMX4QeixQqYwo3xCq/qKjneu51u0Sg5G7lfRU8dwtdn6wyC3dYqDK+ZZ3th8z
         TyZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789507772; x=1790112572;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uAEOVcz8d/teGZZzHqLM89uMtEOQp+zIbDQel4kYlnE=;
        b=xGuHCGcaxsqaFjnJdLx7pinx1p4KkKe3jT974vT7B1LUtPonDm4Hi/XP6JovS6CpwX
         WMCgaOufcfBsh0c6Nw+U+DCyJPHdI/DxZRPDQyeKOQ2NmCckFIwyjcQW0oHlx4CnKaXk
         nSwcfpbDp4lA4OaQZ7/4E1WiPxu3tcW5jP1tyxCPpmb3wDDxnXxTmu1HXB/CH3TQkqZH
         uDufjpm6hs1jR1xOMztok/+/dDHcFLfTn9AaYhFEoaD77h3jOd3TyznNEsuDSRXwbJH9
         vVUe73U1mnqpsGaJNqOEFq3MvZrKDOv+VFGulzkDa3KkVwkC+oFpq4tm0q7C0Jg5FHWe
         QDEA==
X-Gm-Message-State: AFuF++nzAOpHNBnEDjO9SadvZ0G1dDT8P5q3dVLBRNxLXg6pTRgzYYj0
	iLKCbzwu1k6mTNrkuC26eZWKIB89m/p+qsx63faRMnf1kmf/uOAfH16o
X-Gm-Gg: AYBFou34tk4yZELT8MKW174nAstOqk5WKAX8uAw6rm6G6qfGzBQChXrFbIQg9al/++k
	o4hItt/UNfF1XhoXAaWhJzF8x6aPM0UNBxzaFr9djURGlJftzwx1nFA6H+ApcR7yUVeV1UqvWNq
	9WGHiNoqBcrUYFpFKbrNRaQm0IdUZdFSqj3D7KOVXA8gPbJAfdQBpzl7ue3SIZTIwGPSmz0QUSD
	CiqKwyaqf++ekva7nui3ZBRxktYBuSP4rF/T+mNen/WYPl13U1R84TSAQyXBK/Y9vIP9QIWoxcB
	DWUxCEhfWkLLR7xMZ34zHOKG6akBGgFibyXsPqmEszy/rY+8KP7vuRe3ESBLb2SQzL1ppjRmEqp
	FLxLHhhExfgBYnr5gztEi4uRV0O5LCoH4tYtdzSj/Y4yfT6QpNWQShn3RnEWuDBzfrxxV2QAD5X
	kccE4QmV4L0JY8UBrvfSQjI58AXNAKrn0POEtTyQLsekZpfZGUloAZ+Exkigbfzll+MTiwAL5Tc
	SfrzYV8eNycNhNbiMNOxityTWAwruyc0PKZ2DVOCQ==
X-Received: by 2002:a17:90b:54cb:b0:37f:c22a:c188 with SMTP id 98e67ed59e1d1-39e1e25ac28mr416513a91.4.1789507772027;
        Tue, 15 Sep 2026 14:29:32 -0700 (PDT)
Received: from hhost (102.2.85.136.bc.googleusercontent.com. [136.85.2.102])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e1b6991c4sm658790a91.6.2026.09.15.14.29.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 14:29:31 -0700 (PDT)
Date: Wed, 16 Sep 2026 05:29:26 +0800
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
Subject: [PATCH v2] sctp: reject forged cookie peer_addr with unknown address
 family
Message-ID: <20260915212917.3775248-1-hdthky0@gmail.com>
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
sctp_v6_get_dst() on inet6_sk(sk)->opt, and bail in
sctp_transport_new() if af_specific is missing. Validate a copy of
peer_addr, since addr_valid() rewrites a v4-mapped v6 address in
place and the cookie still lives in the received skb, which is not
guaranteed to be unshared.

For that, sctp_v6_addr_valid() has to return 0 when it is called with
a socket that is not PF_INET6, so that IPv6 addresses are never used
on IPv4 sockets. As addr_valid() now also checks sk_family and
ipv6_only_sock, simplify the address handling in sctp_process_param()
with it, as it additionally filters out non-unicast addresses. As a
side effect, a v4-mapped address in an IPv6 address parameter is now
normalised to AF_INET before the transport is created, matching what
the socket API paths already do.

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

Changes since v1 [1]:
- validate the forged cookie peer_addr with af->addr_valid() instead of
  a family whitelist, and make sctp_v6_addr_valid() reject non-PF_INET6
  sockets, so a forged AF_INET6 cookie can no longer crash an IPv4
  socket in sctp_v6_get_dst() (found by Sashiko)
- simplify sctp_process_param() address handling with addr_valid(), as
  addr_valid() now also checks sk_family and ipv6_only_sock
- add the missing !af check in sctp_process_init() for CONFIG_IPV6=n
  builds (suggested by Xin Long)

[1] https://lore.kernel.org/netdev/20260913113522.2674588-1-hdthky0@gmail.com/

 net/sctp/ipv6.c          |  3 +++
 net/sctp/sm_make_chunk.c | 25 +++++++++++++++++--------
 net/sctp/transport.c     |  3 +++
 3 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
index ef26878f1282..c45ac15f3b79 100644
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -734,6 +734,9 @@ static int sctp_v6_addr_valid(union sctp_addr *addr,
 {
 	int ret = ipv6_addr_type(&addr->v6.sin6_addr);
 
+	if (sp && sctp_opt2sk(sp)->sk_family != PF_INET6)
+		return 0;
+
 	/* Support v4-mapped-v6 address. */
 	if (ret == IPV6_ADDR_MAPPED) {
 		/* Note: This routine is used in input, so v4-mapped-v6
diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 84a4c97d0f75..cfc4973f4d4a 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -1732,7 +1732,9 @@ struct sctp_association *sctp_unpack_cookie(
 	struct sctp_cookie *bear_cookie;
 	struct sctp_chunkhdr *ch;
 	unsigned int len, chlen;
+	union sctp_addr paddr;
 	enum sctp_scope scope;
+	struct sctp_af *af;
 	ktime_t kt;
 
 	/* Header size is static data prior to the actual cookie, including
@@ -1841,6 +1843,15 @@ struct sctp_association *sctp_unpack_cookie(
 		goto fail;
 	}
 
+	/* peer_addr is peer-controlled when cookie authentication is
+	 * disabled.  Validate a copy, as addr_valid() may rewrite a
+	 * v4-mapped address in place.
+	 */
+	paddr = bear_cookie->peer_addr;
+	af = sctp_get_af_specific(paddr.sa.sa_family);
+	if (!af || !af->addr_valid(&paddr, sctp_sk(ep->base.sk), NULL))
+		goto malformed;
+
 	/* Make a new base association.  */
 	scope = sctp_scope(sctp_source(chunk));
 	retval = sctp_association_new(ep, ep->base.sk, scope, gfp);
@@ -2381,6 +2392,8 @@ int sctp_process_init(struct sctp_association *asoc, struct sctp_chunk *chunk,
 		    (param.p->type == SCTP_PARAM_IPV4_ADDRESS ||
 		     param.p->type == SCTP_PARAM_IPV6_ADDRESS)) {
 			af = sctp_get_af_specific(param_type2af(param.p->type));
+			if (!af)
+				continue;
 			if (!af->from_addr_param(&addr, param.addr,
 						 chunk->sctp_hdr->source, 0))
 				continue;
@@ -2554,18 +2567,14 @@ static int sctp_process_param(struct sctp_association *asoc,
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
+		if (!af)
+			break;
 		if (!af->from_addr_param(&addr, param.addr, htons(asoc->peer.port), 0))
 			break;
+		if (!af->addr_valid(&addr, sctp_sk(asoc->base.sk), NULL))
+			break;
 		scope = sctp_scope(peer_addr);
 		if (sctp_in_scope(net, &addr, scope))
 			if (!sctp_assoc_add_peer(asoc, &addr, gfp, SCTP_UNCONFIRMED))
diff --git a/net/sctp/transport.c b/net/sctp/transport.c
index 6ea55b9fbde4..cd1a604d6f8e 100644
--- a/net/sctp/transport.c
+++ b/net/sctp/transport.c
@@ -92,6 +92,9 @@ struct sctp_transport *sctp_transport_new(struct net *net,
 {
 	struct sctp_transport *transport;
 
+	if (!sctp_get_af_specific(addr->sa.sa_family))
+		return NULL;
+
 	transport = kzalloc_obj(*transport, gfp);
 	if (!transport)
 		return NULL;
-- 
2.43.0

