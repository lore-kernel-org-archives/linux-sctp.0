Received: from mail-dy2-f5.google.com (mail-dy2-f5.google.com [74.125.229.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC30F3DAADB
	for <linux-sctp@vger.kernel.org>; Mon, 19 Oct 2026 07:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792395488; cv=none; b=R6Z8TC+vknty5sOv2aR81WSRKeWrU2DjZrPOarQex9N/NuBJdJrhp2pYJG32g0xbu8tqJZltiHK390OGqyJGcXOLFm/Jz5m1hURKQ6M2u2mmPPZKsaO7qlBKv8SL92d65N2g8qFll0SDX3aXGwrtTlDWuNwrK/vKRkL79mDWw9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792395488; c=relaxed/simple;
	bh=cw0jAxB2/4pDIjwI5i4L/jE0/EDlSc5y/L41Gki7wfs=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Zd+DZRmSkhmiCY+ZiKjG0azPeKBdWesfe2M1R7YifdOaFZUGYyyJFIyJIJo3VNzJf9QbZtWyerZOa0azFQHNWw5GSDveN6w6ZJDtIwFPZfdYe7kDHTfS859YnemWNYXGy5CxiMul3YhZYTc1G8NzUYQSZrBESxGZ3S31yLFjg1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OmjSGJZ0; arc=none smtp.client-ip=74.125.229.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OmjSGJZ0"
Received: by mail-dy2-f5.google.com with SMTP id 5a478bee46e88-3535a54c09bso1744770eec.0
        for <linux-sctp@vger.kernel.org>; Mon, 19 Oct 2026 00:38:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792395486; x=1793000286; darn=vger.kernel.org;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WeZ3C8NSrKIaDQPOGP+WAdZGT2qrYqoMzpLwnMzu0Vk=;
        b=OmjSGJZ0wWffjWIEf5FkLtWpuQCfAPM18p5sWUEbhs7aheoWtOZxgKh5UUvncA8CrB
         SurL6hjo19jGA2l6wQD6CnNNGyfHRrLcg3UcaxQ1On2HsewAbN7NSoZ27U19evP0rxRK
         f6m+EfFndubdSkDFezHmtmiBoWce8KJnE770Hu74NJ0UUvOOiobplExxbPrP+Drk0LyU
         EbiWB2jeMFzh66n6a1n9lSHqxzp0ueEeUEhK3/8Lg3a2QrvTGbTNaQZDVP9vO8DRN1pK
         EpQgF8yW2A6CDo9pXqylBkIuo323ouIQv374g+odLx6BqgMbd+SArTYdYv+tKh2KL5j+
         X3tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792395486; x=1793000286;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WeZ3C8NSrKIaDQPOGP+WAdZGT2qrYqoMzpLwnMzu0Vk=;
        b=CQsSogMMDoxG8TbXO23Yy5VAW5B+6gQYEEfsMO3ozGDNCzPqQZyAwsmY2/xEByLF0U
         yq2MP6n12UT2lQWUtrcEieydCL0KqvfXgo4C2zF9LtQZ6FeFct6wnA7PR7+XQK2GLRIC
         Nqzt5ZOMDg5BdXTs/aCb86/WRyYw0sZ4THO2E4iWscITlLILWjOHFvWJEItnVrscnla7
         h2F8ZVX9GrQDC5a/P0E2GVlawzT1vHJDREV9azkQy2u8EWh2MyDSvjHzY0cuMkfja8gp
         ZTnbr2Da76dSjWCLD0JY/F3T8iC95oUmUWHPQ1TCL6F5xsE94FeAsuxwY+avDm/8ZYLq
         Z39g==
X-Gm-Message-State: AFq9FYJKsJtyLYOp4cVO/OU/1RlJiL1yoeK4k9RrqOZPt8lTbI/oYxUP
	GxQ+riGUywyiNNnUUVmBb8Xp37ZwnQOSkfnr8zR+TFdKwFf8nPdhIXJL
X-Gm-Gg: AYBFou361qgpOQ5D7R3mDIWd7O1u2XZImjWuEV5S3rESRcgHeeYhyjyQOnGxzerqlna
	GqPAI0kNwnPrFmUkVUIZv97/fbUVDJEFi2aAU5ZuNoxF6tDhmxg5sjiasrCTOyqqi3Zv+Ax8TY0
	wiWUktKEJiLDNWjbDA5qsM5N5my1WUtBGOGAH+Q6lNllZbaILLsEn07cwnDGKkPG8K25CXP8/et
	ajNHOctTG8GR8NWrh5aQH7vehfckmV7/+svP+O/wUY2pgXxLJ19egaSHN2BeN7uNTfq85Kd3To6
	r3GqhAivIls/5fCa8wa90Yw+v9t+Y5F69KdC2OvLCTONp0kT/pb5ukTwBWd3FTzA3fm/+FTYGjJ
	8/LQIMo0IjDkitm1oVS98wep/snS5EIwHczAaJLhVAJK48f+p/vPcK9B1lPhnA1C6o5UrJ1HXxt
	LmYw+LHwlHfIvJxvOVCpyICWjrfsp4gdCNDyik5scZrO0OR2mfGhSFd9PNW54C8A==
X-Received: by 2002:a05:7301:2d2f:b0:35c:cad8:e61f with SMTP id 5a478bee46e88-361a224cd72mr10463148eec.31.1792395485646;
        Mon, 19 Oct 2026 00:38:05 -0700 (PDT)
Received: from hhost ([120.231.212.164])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-360813b6ca5sm28347221eec.9.2026.10.19.00.38.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 00:38:04 -0700 (PDT)
Date: Mon, 19 Oct 2026 15:37:57 +0800
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
Subject: [PATCH v5] sctp: reject forged cookie peer_addr with unknown address
 family
Message-ID: <20261019073747.178626-1-hdthky0@gmail.com>
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
since addr_valid() rewrites a v4-mapped v6 address in place and the
cookie still lives in the received skb, which is not guaranteed to
be unshared. Store the validated copy in the new association and
pass it to sctp_process_init() instead of the raw cookie, so a
v4-mapped v6 address is normalised to AF_INET before the association
and its primary transport are built from it.

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

v5: https://lore.kernel.org/netdev/20261009074601.3954275-1-hdthky0@gmail.com/
- validate a copy of peer_addr again, as writing to the cookie in the
  received skb could corrupt data shared with clones
- copy the validated peer_addr into the new association and use it in
  sctp_sf_do_5_1D_ce() instead of re-reading the raw cookie

 net/sctp/ipv6.c          |  6 +++++-
 net/sctp/sm_make_chunk.c | 24 +++++++++++++-----------
 net/sctp/sm_statefuns.c  |  2 +-
 3 files changed, 19 insertions(+), 13 deletions(-)

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
index ddc31a5dbad3..d64c3ae33298 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -1733,7 +1733,9 @@ struct sctp_association *sctp_unpack_cookie(
 	struct sctp_cookie *bear_cookie;
 	struct sctp_chunkhdr *ch;
 	unsigned int len, chlen;
+	union sctp_addr paddr;
 	enum sctp_scope scope;
+	struct sctp_af *af;
 	ktime_t kt;
 
 	/* Header size is static data prior to the actual cookie, including
@@ -1842,6 +1844,11 @@ struct sctp_association *sctp_unpack_cookie(
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
@@ -1858,6 +1865,7 @@ struct sctp_association *sctp_unpack_cookie(
 
 	/* Populate the association from the cookie.  */
 	memcpy(&retval->c, bear_cookie, sizeof(*bear_cookie));
+	retval->c.peer_addr = paddr;
 
 	if (sctp_assoc_set_bind_addr_from_cookie(retval, bear_cookie,
 						 GFP_ATOMIC) < 0) {
@@ -2382,8 +2390,8 @@ int sctp_process_init(struct sctp_association *asoc, struct sctp_chunk *chunk,
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
@@ -2555,17 +2563,11 @@ static int sctp_process_param(struct sctp_association *asoc,
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
diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 8dc65498763c..b2f609f177fb 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -814,7 +814,7 @@ enum sctp_disposition sctp_sf_do_5_1D_ce(struct net *net,
 	 * effects--it is safe to run them here.
 	 */
 	if (!sctp_process_init(new_asoc, chunk,
-			       &chunk->subh.cookie_hdr->c.peer_addr,
+			       &new_asoc->c.peer_addr,
 			       peer_init, GFP_ATOMIC))
 		goto nomem_init;
 
-- 
2.43.0

