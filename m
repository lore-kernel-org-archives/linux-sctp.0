Received: from mail-pj2-f5.google.com (mail-pj2-f5.google.com [74.125.227.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2752E35A39D
	for <linux-sctp@vger.kernel.org>; Thu, 17 Sep 2026 03:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789614348; cv=none; b=Dr1/45KUKJ83RbYE0REIIXRty/m5eZkwhAhMcYkUsqdE9tGwiDlFF4o5NT/VXsMrLDl46lxSbO2Z0LOh2m6JZnO7qLZwVo2lD3FU0xtOT8oJFxTtFzxYikbvH5I8ESVHUuMkLQgM93gyewFbamBOqGmKyRZgZPaoCBWDnRie2f8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789614348; c=relaxed/simple;
	bh=YavanCZcN6GwCOP2AzZi9fy/8p+AsGhmLV2iICw/lv0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=FZyA53pv03anROlF0YWE3dep79qnXmtDejKtZ5uoEHkyDvWrrU9haYfk4oqFpWJ35+D+A/oAciNOQwfa+0JaKJ7z/P3e49rKgBuyNaK8EnpSh/c/gQqH0N+4UBI4SyuaBMkmpThTWAnAVdqOdlS9kAWoaurCseO5jQT+gxay9hI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AILxZt3P; arc=none smtp.client-ip=74.125.227.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AILxZt3P"
Received: by mail-pj2-f5.google.com with SMTP id d9443c01a7336-2d6fbdc8772so1585285ad.0
        for <linux-sctp@vger.kernel.org>; Wed, 16 Sep 2026 20:05:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789614346; x=1790219146; darn=vger.kernel.org;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GmKX7x8Mi0sQYSQi5uPWAMNZJvojTYX1qQ+b3jxypgs=;
        b=AILxZt3PX7pekqz9oL/GDit7gvhMD9kDHUFo73nlIeDbQlYALNoiTkb+JXToZeLp+H
         2GSh/vnocjUP3g26yCPiQFUZiO7vvL1Y4NeokoyDli2AD20dkd/1FT+f+9ciC0Zv/C6c
         VtNyO3wW1WvoRftRqFZbsV0Gxfx62dz9sXikdd/ASB1L1sRZDZIbI+rnZ9EG0/XMymBb
         KZBfqwhwxJr8aYDHtzQtUEfFWfHO1wlD0LkQTbHMw4VzQsF5VSYTJmEdS3SSw2piwW4k
         ycFzR4VLGkym8+V/W9fAcwyh6mE6fYV8emuMmqIs5f6xH0ROMyVffgfXoV/efgS9/Bmc
         2LWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789614346; x=1790219146;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GmKX7x8Mi0sQYSQi5uPWAMNZJvojTYX1qQ+b3jxypgs=;
        b=xfiY4tlVoaVeITXGtgFWAWXGIIPFSn3d/Ku400HgV6pU630r/1+bwDtTYogwHZKP0X
         JC7t9E7ic7cl/V+lGmwAitfOKcezGaLsQKsommXQxHYnxiauMaOAn5HR1T4aZPF1Hcbe
         zDC5f6XTFY5msyvHtE+VGjuLujDzic9DFfKphhFU+PxV4iSxtw0yAjPr4S7JM4eqCQOl
         kIvpuROaiTIVXmDO1iV11LDzXW1ot/pV7v4b4J2K4qHJg8nLRM+kvDytGMr14fiKuE/k
         mjEFgJmqh1KnKgAJSjRhqg02j1N+zg6SXdZWR8sxVBEpvWLyE2T7C708RfZLYXv/8DDR
         jXxg==
X-Gm-Message-State: AFuF++loj8Cjy9svZIeAPv7XECdimWsV/sMIlwU0/ap1XzJKogz3OuE/
	x1RFtIs5PJEnn5jdV+84oEKvOjdgJPMVV88o4hjHJYtF3wUAV6aBhiGp
X-Gm-Gg: AYBFou33cKZHabB6I8kHTjQudLf2c/LXyhmsPcyUxipfCKjNDgIt+mXb8cdJ1PoNect
	lIl9luqH7iQNyiS9xA67PsXUaZaEFp+LY80NIkTZu2DNzbcPYW54u72yKifJwIn6dk4Gfkg7j52
	TGBjA8dN6tTzsTAHGNG397CtatePbA7c8+XcoMRAVgIpUU1LVirV07wtNchR5gr68OtzYbiOEXd
	AIb7pofLcJchsVb5BHXmCGAwBQrLWT03yWCUwald9anXo44REZ+rex3MFIrHh7VwX+7XmOsKcQ3
	psYCbSzRAgtcNygo9WM/kz/bwWG8ysGsMbPvIEIs/nypIX+mmXxG5OBZaXyzxNIUbX148/ODpqG
	uzEjTBCpd0vQ8tc4eNkPYCoYT3lz8uS5IJ+O/wOhSnJjUstOullcfBZNgclFZ7UeT7JMJ1L6KvY
	Rvw/NcO2PR7rP5VlGWN0PMdH2kKSvLSS7xicQ/dfEzpjyVKHTAazrFBnFwueuxm2s=
X-Received: by 2002:a05:6a00:17a3:b0:85d:84a5:b7bb with SMTP id d2e1a72fcca58-87238f95d56mr10734722b3a.18.1789614346316;
        Wed, 16 Sep 2026 20:05:46 -0700 (PDT)
Received: from hhost ([2409:8a55:316c:2b80:7367:4ccd:ebdb:9a0])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-871febde2e1sm2104957b3a.7.2026.09.16.20.05.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 20:05:45 -0700 (PDT)
Date: Thu, 17 Sep 2026 11:05:10 +0800
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
Subject: [PATCH v3] sctp: reject forged cookie peer_addr with unknown address
 family
Message-ID: <20260917030505.4176635-1-hdthky0@gmail.com>
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
sctp_v6_get_dst() on inet6_sk(sk)->opt. Validate a copy of peer_addr,
since addr_valid() rewrites a v4-mapped v6 address in
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

 net/sctp/ipv6.c          |  3 +++
 net/sctp/sm_make_chunk.c | 23 ++++++++++++-----------
 2 files changed, 15 insertions(+), 11 deletions(-)

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
index 84a4c97d0f75..20c093894884 100644
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
@@ -1841,6 +1843,11 @@ struct sctp_association *sctp_unpack_cookie(
 		goto fail;
 	}
 
+	paddr = bear_cookie->peer_addr;
+	af = sctp_get_af_specific(paddr.sa.sa_family);
+	if (!af || !af->addr_valid(&paddr, sctp_sk(ep->base.sk), NULL))
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

