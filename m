Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=165.173.180.54
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793176079;
	b=M2c/tvLb8gOZqJdxmlMYuBhkZIyba3kkuaVEsklARy4Wij6q/eFZrdiAEO/qNuyTSAwd
	 C3LlxLm5MQiWRGAYodJ9WeJVty7wwBOEo/db7btQBBPUULjTFK45uzIed9JodJEEwBiaX
	 IedAfb5Dcj4BdwKX5taA+QU6gldC9UxBjC+edSv0CvPRVCsw1MExs/DHbrEfkaTYnBu63
	 WOGJgZF8zbWn57TmXJRhKldSdcarMg1wpKhvSFUMPTa5ipmd89xzb8ItDGAkbmYPpnOc2
	 Z3Sp9hISAek4D/AM1VwcExl86k3fm1ulp0OpHFL9/ozszYDdfhEHNhac6iiWrdSDlVw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793176079;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-ZohoMailClient;
	bh=myM/NwutGCZOyeD1H4WToSGlYN7DqWtaA9tPjs0fpP0=;
	b=Gp/2ByVphWbde343g46TBLF/DWt0NiEaHauCUJ7ZO/gorZ08E7WBi5ZvG7bTBGVxWcaL
	 RLpEpo6zZFzf+aWXKCaE0oXVFGnOI8rqI/HICoT1+y/d7kv/h/tVPbutC/2rddQ15KtDF
	 EezezrsxJyq8ZF705zJ6ZPH0DFloJvtQv98BRaI1F6xRwR7CUxPsTBOMHy5rC0L+LchIO
	 GakxXv5QMm4J6dtVZp6s5wVqlRtlQti7zm/7VWh+80yCJ1ddDEnVYYccVWi4tpezSGxmT
	 fz/AE/FnwxdJSlueeNkr2+07YadiNtLAKaX9c6lWXBt1dTDFkGzalrsmMKpI67IgoWA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mpiricsoftware.com;
	spf=pass smtp.mailfrom=mpiricsoftware.com;
	arc=pass header.oldest-pass=0 smtp.remote-ip=165.173.180.54
Received: from sender6-of-o54.zoho.com (sender6-of-o54.zoho.com [165.173.180.54])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C01F606A31A;
	Wed, 28 Oct 2026 08:27:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9C01F606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mpiricsoftware.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mpiricsoftware.com
ARC-Seal: i=1; a=rsa-sha256; t=1793176057; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=ExSEXI2BEp3D/p4wP7Oy3FrT8GVNHD2UPFhot8vC1ZRHnE79aRf4AXEYryVbY+6t9KGE/1d1hCEyK3H1+2mm43tt5Xy3MKdH2ViOG500gjLDPTe3CbUUonJy3yBJe0nzvwZkJPCRK/H6n8BmBCAq7KlBw347hlgrpxgtI3Wz/hE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1793176057; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=myM/NwutGCZOyeD1H4WToSGlYN7DqWtaA9tPjs0fpP0=; 
	b=KgC6mU7tCzVhs0xr3tQq6hU0UF735YlXnQAQF1VsEIIOAyP+QtGqaAe8PTCpU8R3HwfU3V5oXTni+G1GIXhKlu3/Vuu0IM/Q9XSW8/VdgGPPjc++f05rweV1v/FW/lH1cxRi1KlpENihMROzBTO/hoehjdYYVUqDdBX9KClRaaU=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=mpiricsoftware.com;
	spf=pass  smtp.mailfrom=kalpan.jani@mpiricsoftware.com;
	dmarc=pass header.from=<kalpan.jani@mpiricsoftware.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1793176057;
	s=mpiric; d=mpiricsoftware.com; i=kalpan.jani@mpiricsoftware.com;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=myM/NwutGCZOyeD1H4WToSGlYN7DqWtaA9tPjs0fpP0=;
	b=m9h+e0jC7f+h7Cb6o43k/Xo0qb4nBhudcwHqzxSZdKR09/izEAZ4pElGUjMuQumr
	0a5jibu2lemUn73Nl/E5L5Fpj6tbBVvn44isBNE9LNhLopMCJKDGFyPKvicgLNptG2t
	hah10mmOGTFECuTc9FrrY87lwMpq0PLHtlG3kqow=
Received: by smtp.zohomail.com with SMTPS id 1793176054284430.2233145702239;
	Wed, 28 Oct 2026 01:27:34 -0700 (PDT)
From: Kalpan Jani <kalpan.jani@mpiricsoftware.com>
To: mptcp@lists.linux.dev
Cc: matttbe@kernel.org,
	Kalpan Jani <kalpan.jani@mpiricsoftware.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Neal Cardwell <ncardwell@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Mat Martineau <martineau@kernel.org>,
	Geliang Tang <geliang@kernel.org>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Kees Cook <kees@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Willem de Bruijn <willemb@google.com>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-sctp@vger.kernel.org
Subject: [RFC net-next v11 1/2] inet_diag: pass net_admin to get_info
Date: Wed, 28 Oct 2026 13:57:00 +0530
Message-ID: <20261028082704.1609493-2-kalpan.jani@mpiricsoftware.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261028082704.1609493-1-kalpan.jani@mpiricsoftware.com>
References: <1ec0c2b5-a0fa-44e8-9ae8-dca9b7f90ec6@kernel.org>
 <20261028082704.1609493-1-kalpan.jani@mpiricsoftware.com>
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
X-ZohoMailClient: External

Pass the request's CAP_NET_ADMIN status to idiag_get_info()
so protocol-specific diagnostic handlers can restrict privileged
information.

Socket-destruction notifications have no individual requesting user,
so the callback receives net_admin set to false for that path.

Signed-off-by: Kalpan Jani <kalpan.jani@mpiricsoftware.com>
---
 include/linux/inet_diag.h | 3 ++-
 net/ipv4/inet_diag.c      | 6 +++---
 net/ipv4/raw_diag.c       | 2 +-
 net/ipv4/tcp_diag.c       | 2 +-
 net/ipv4/udp_diag.c       | 2 +-
 net/mptcp/mptcp_diag.c    | 2 +-
 net/sctp/diag.c           | 6 +++---
 7 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/include/linux/inet_diag.h b/include/linux/inet_diag.h
index 704fd415c2b49..8db96bfd3e67f 100644
--- a/include/linux/inet_diag.h
+++ b/include/linux/inet_diag.h
@@ -18,7 +18,8 @@ struct inet_diag_handler {
 
 	void		(*idiag_get_info)(struct sock *sk,
 					  struct inet_diag_msg *r,
-					  void *info);
+					  void *info,
+					  bool net_admin);
 
 	int		(*idiag_get_aux)(struct sock *sk,
 					 bool net_admin,
diff --git a/net/ipv4/inet_diag.c b/net/ipv4/inet_diag.c
index 34b77aa87d0a4..362161bf39fe3 100644
--- a/net/ipv4/inet_diag.c
+++ b/net/ipv4/inet_diag.c
@@ -276,7 +276,7 @@ int inet_sk_diag_fill(struct sock *sk, struct inet_connection_sock *icsk,
 	}
 
 	if (!icsk) {
-		handler->idiag_get_info(sk, r, NULL);
+		handler->idiag_get_info(sk, r, NULL, net_admin);
 		goto out;
 	}
 
@@ -327,7 +327,7 @@ int inet_sk_diag_fill(struct sock *sk, struct inet_connection_sock *icsk,
 			goto errout;
 	}
 
-	handler->idiag_get_info(sk, r, info);
+	handler->idiag_get_info(sk, r, info, net_admin);
 
 	if (ext & (1 << (INET_DIAG_INFO - 1)) && handler->idiag_get_aux)
 		if (handler->idiag_get_aux(sk, net_admin, skb) < 0)
@@ -1027,7 +1027,7 @@ int inet_diag_handler_get_info(struct sk_buff *skb, struct sock *sk)
 	if (attr)
 		info = nla_data(attr);
 
-	handler->idiag_get_info(sk, r, info);
+	handler->idiag_get_info(sk, r, info, false);
 	inet_diag_unlock_handler(handler);
 
 	nlmsg_end(skb, nlh);
diff --git a/net/ipv4/raw_diag.c b/net/ipv4/raw_diag.c
index 943e5998e0ad5..264912d0cb9fc 100644
--- a/net/ipv4/raw_diag.c
+++ b/net/ipv4/raw_diag.c
@@ -185,7 +185,7 @@ static void raw_diag_dump(struct sk_buff *skb, struct netlink_callback *cb,
 }
 
 static void raw_diag_get_info(struct sock *sk, struct inet_diag_msg *r,
-			      void *info)
+			      void *info, bool net_admin)
 {
 	r->idiag_rqueue = sk_rmem_alloc_get(sk);
 	r->idiag_wqueue = sk_wmem_alloc_get(sk);
diff --git a/net/ipv4/tcp_diag.c b/net/ipv4/tcp_diag.c
index ba1fdbe9807fd..cac32575282e3 100644
--- a/net/ipv4/tcp_diag.c
+++ b/net/ipv4/tcp_diag.c
@@ -19,7 +19,7 @@
 #include <net/tcp.h>
 
 static void tcp_diag_get_info(struct sock *sk, struct inet_diag_msg *r,
-			      void *_info)
+			      void *_info, bool net_admin)
 {
 	struct tcp_info *info = _info;
 
diff --git a/net/ipv4/udp_diag.c b/net/ipv4/udp_diag.c
index f4b24e628cf8d..5a1fa627cbee8 100644
--- a/net/ipv4/udp_diag.c
+++ b/net/ipv4/udp_diag.c
@@ -142,7 +142,7 @@ static void udp_diag_dump(struct sk_buff *skb, struct netlink_callback *cb,
 }
 
 static void udp_diag_get_info(struct sock *sk, struct inet_diag_msg *r,
-		void *info)
+		void *info, bool net_admin)
 {
 	r->idiag_rqueue = udp_rqueue_get(sk);
 	r->idiag_wqueue = sk_wmem_alloc_get(sk);
diff --git a/net/mptcp/mptcp_diag.c b/net/mptcp/mptcp_diag.c
index 136c2d05c0eeb..9ed7a6be1e628 100644
--- a/net/mptcp/mptcp_diag.c
+++ b/net/mptcp/mptcp_diag.c
@@ -190,7 +190,7 @@ static void mptcp_diag_dump(struct sk_buff *skb, struct netlink_callback *cb,
 }
 
 static void mptcp_diag_get_info(struct sock *sk, struct inet_diag_msg *r,
-				void *_info)
+				void *_info, bool net_admin)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
 	struct mptcp_info *info = _info;
diff --git a/net/sctp/diag.c b/net/sctp/diag.c
index c2a0de2adf6fd..ab6c560fde053 100644
--- a/net/sctp/diag.c
+++ b/net/sctp/diag.c
@@ -20,7 +20,7 @@
 #include <net/sctp/sctp.h>
 
 static void sctp_diag_get_info(struct sock *sk, struct inet_diag_msg *r,
-			       void *info);
+			       void *info, bool net_admin);
 
 /* define some functions to make asoc/ep fill look clean */
 static void inet_diag_msg_sctpasoc_fill(struct inet_diag_msg *r,
@@ -200,7 +200,7 @@ static int inet_sctp_diag_fill(struct sock *sk, struct sctp_association *asoc,
 	}
 	infox.sctpinfo = (struct sctp_info *)info;
 	infox.asoc = asoc;
-	sctp_diag_get_info(sk, r, &infox);
+	sctp_diag_get_info(sk, r, &infox, net_admin);
 
 	addr_list = asoc ? &asoc->base.bind_addr.address_list
 			 : &ep->base.bind_addr.address_list;
@@ -412,7 +412,7 @@ static int sctp_ep_dump(struct sctp_endpoint *ep, void *p)
 
 /* define the functions for sctp_diag_handler*/
 static void sctp_diag_get_info(struct sock *sk, struct inet_diag_msg *r,
-			       void *info)
+			       void *info, bool net_admin)
 {
 	struct sctp_infox *infox = (struct sctp_infox *)info;
 
-- 
2.43.0

