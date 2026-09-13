Received: from mail-qk2-f6.google.com (mail-qk2-f6.google.com [74.125.230.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F8DC39A06D
	for <linux-sctp@vger.kernel.org>; Sun, 13 Sep 2026 11:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789299400; cv=none; b=nkaPgHLrptwvRFvhuEfNy0uVeB1UVbEtjqDyOu1puqEGcdFiJ8fHeUbSd0AIG0WxgsJPAwP28QSCejXxrZ0RMXDLJPZ+cXDq1Ja03/YsdPMOZvv5NraHr9UhUen5S9EBAnJzUIwKHpZgOZU5YXGUo6jVGBDy5mkeHomgaRSMADM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789299400; c=relaxed/simple;
	bh=s+yn8heHjHJXCmboNyulsK9UYhxqQFZnQizWHkohj2A=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=NQho8UNZiMWs5YkAqjStJ1oHzE3R737ldmz3RYuf1TOjiRG7xQ474Wrv1jv78D6WwcH3bDeW2wXFWkAx1t4PoY8STc3PkiKpad3rdOOjDkCAxSI7ZvSggWhJLsrQ9WHo0Rp3Cf9jFTk5xM5LVgdetcC7f0Q/8ttT5LRxsT0KRoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B9vaLb6c; arc=none smtp.client-ip=74.125.230.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B9vaLb6c"
Received: by mail-qk2-f6.google.com with SMTP id d75a77b69052e-52fa263dd47so14876361cf.0
        for <linux-sctp@vger.kernel.org>; Sun, 13 Sep 2026 04:36:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789299393; x=1789904193; darn=vger.kernel.org;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+K4Q6mA0B7cFhrdQfvjltB31JYYm86Jr0HYn9YoOBBs=;
        b=B9vaLb6chjjUwhd7+nAPYDILJDu0e11nHJdg2Ir9NSZv6HBWdiAcxDYmp3E+z6Z1zW
         syCSi0sv0SvFdDQxWg3e0WXt89o9V/H5fkatG8JspOQPKSf71qCnwH/WbX8AlhvrUbeW
         e3yqtAHjqZK9dzGRQjnyIJPdBf59jPJIU6DwMJQi0vcOwHZeBNFhC0TJ1u3azXz3D88+
         5dHWMXK5GWKDGp9EvmeAnK5fvU5f93tbk8LMXlCkLPROm+qBs+mlZMZk5/Fm5H3HsbdW
         +LWfdLkhIYw/cy96ESSt+gHnEmAkZ7YuWXNQ4Rpa4+VFn1mKJEFFOPGxZC0B8s3VOb4F
         LW6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789299393; x=1789904193;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+K4Q6mA0B7cFhrdQfvjltB31JYYm86Jr0HYn9YoOBBs=;
        b=qpOV8UbdJ6L2/Mx3ywMQxeRpc4LlkB+ryrtMnCS4NA/uB5z361XuLS3ooFtHT8h/Br
         xLCvlpgBZJ6Uubti5d7EByr04odmggaPxwy0zRo6uGFTALo3PdLByjy4dLJrr7viO+Ih
         G9SdfayJOA0mWLzuH67YA+fq53iJPuVxhKFw0AGcR1mL+70OkEFwSgPxBw0SfZ8tT52F
         JvJ2BniieyoxEzEcd87Nbu6+DFqcw9QYmMPdgXI1xIOUcNKDwwUA6zSqR/S03K1sfGVV
         I/e13gxiYIVupFeZUQhl1Jnyn51YOdRtt2wYX289MwIi2rQf1NR4NFQrbjaKXvKC3pYC
         phSA==
X-Gm-Message-State: AFuF++karHVBhZOS/drYEN+hTfz/x+Za5ORIc8oI9Z0qslQI3GUaBqOM
	p9tJFEWpqN7b/ihfeaNa651aik/S9+Njj1qR0//OhDOFsI+9VwTZyFjJ
X-Gm-Gg: AYBFou23oQ8K3+Sb7Vj3zN5vFFp4Bwav+DIk1SKvuSgKpzMc47ITN+dkstMtPMTlCSs
	wWPiejpX8ZI76UZnVf9R6hLL6HDnCfN2XCtRTC8K/RLyMyuh3dPfvyAnqeNpQyajULwz045W5ry
	EuG4r0KiOYMSOCAm4exdiORbK4xXssG+MB7SiVA2IG8ooBlyCwCjhLeyQ3Crza7C9XscNkhbk7P
	Bfj6fC03swSqhBFOjz8k5TfWni0TwU88QSsnrpqKoklgcg/B5VjPr8BwcGHyq+bVtG9w6SxB7jK
	Lpg9Snyouz4LMAs+kkCdtbqfWoQ53mMj/8rLk8KfUtmyn9iz+uLU4HUksfT3X841M7FRRYi3hCv
	u3Vxis+Y+wXHKT7iN7w+5qkhk2afy7Y59SqvgTlPj6lljJ+FXNhCNphQ8H9H4Y3I+czSH29mQWP
	/p8XA4qsMspla7WqN2BbmGroi7jz8dJLpuemsb1nykxVs7vltVFYxzAlC3gLaMPGTXI+irM8hye
	XzSkGcUtEZKitm7QiCZ8J+Ih2U=
X-Received: by 2002:ac8:5996:0:b0:530:b2e4:d59d with SMTP id d75a77b69052e-530e820b6cemr86862271cf.56.1789299388158;
        Sun, 13 Sep 2026 04:36:28 -0700 (PDT)
Received: from hhost (awork062063.netvigator.com. [203.198.28.63])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-530ca4b9c54sm68504331cf.20.2026.09.13.04.36.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Sep 2026 04:36:26 -0700 (PDT)
Date: Sun, 13 Sep 2026 19:36:15 +0800
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
Subject: [PATCH] sctp: reject forged cookie peer_addr with unknown address
 family
Message-ID: <20260913113522.2674588-1-hdthky0@gmail.com>
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
af_specific->sockaddr_len. Reject non-INET/INET6 families in
sctp_unpack_cookie(), and also bail in sctp_transport_new() if
af_specific is missing.

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
 net/sctp/sm_make_chunk.c | 4 ++++
 net/sctp/transport.c     | 3 +++
 2 files changed, 7 insertions(+)

diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 84a4c97d0f75..7c8fe4b38cd1 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -1855,6 +1855,10 @@ struct sctp_association *sctp_unpack_cookie(
 	if (!sctp_auth_verify_cookie_params(ep, bear_cookie))
 		goto malformed;
 
+	if (bear_cookie->peer_addr.sa.sa_family != AF_INET &&
+	    bear_cookie->peer_addr.sa.sa_family != AF_INET6)
+		goto malformed;
+
 	/* Populate the association from the cookie.  */
 	memcpy(&retval->c, bear_cookie, sizeof(*bear_cookie));
 
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

