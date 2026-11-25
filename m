Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621533;
	b=2R5+mJUwtnkM1X1YZDkuVS0QDI5m1D535x0js05BCwgMQI2JF4cCqrlrQvyRYvMWgjTF
	 eEjSxcj9yOgLLcofTaHEYr6Mb4HsmsN4DBfvt6sDymFGzjj88tB1TWpW9Hp56dMwtoTFO
	 4eUNQs6UqNGz4nJAL7XqNiAiiYte/mF3FvTTi2if2iZv6+G19wGn125edp04fkgA7HiNo
	 oFn2LHvlu7q9aycn3oP8NsSpphAOJXmxy/ywd/NZCufDm0boVzguMD8oX9/dv3cBp2tYu
	 hzUa+k0ARbMHZW7J18rmPy0rFXeyqKqa1m3cQwb5BnBFSoOEZaPyQZPqOUqU23DVWAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621533;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=+hF8JaB+djbNpsEhW3Xi8DSX8SvBQulT2na5Z6v+Cc0=;
	b=tFeaKWHh9Pw+SU+U3hUoxHgN++oCP/lRhzKV5nsc2vsAJSEZKH5T/Qp8bQYksHk5phq9
	 /A9Y5OIHUOJgg1g1iw17kT9oahhrGD6iw0VUwVu/UqN8+oa/XAOP0A4aW+Q00vqWBFZXg
	 phxHj0Cnh8DmKG8QbkmugMmVpLKg9OxnxJl1vmUozPFVelQP+In/LSZzfmaJn0L3M1UZN
	 sFm/TRL90q+I3kNFUTv0giuFAYWoODfrAJy25JHzhlQxYlGn84/sa/CUl/9S5NIJGXrvW
	 Ez/N2VKiZS4N+GWl5Hzh6NtVfbNsNzwywHd38S5ZtxdcppBOMy0J4QBrA2kgIZHqujA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=uWORzPPA;
	arc=none smtp.remote-ip=209.85.160.180
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2E6C606A323
	for <linux-sctp@vger.kernel.org>; Wed, 25 Nov 2026 15:45:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E2E6C606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=uWORzPPA
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-53644ab1f7bso53087371cf.3
        for <linux-sctp@vger.kernel.org>; Wed, 25 Nov 2026 07:45:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795621532; x=1796226332; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=+hF8JaB+djbNpsEhW3Xi8DSX8SvBQulT2na5Z6v+Cc0=;
        b=uWORzPPAV0CvAkCMSN+eHMpnoqkpFxACRlj4Z9VNKt1hH59qJZ0BSX+tauZdZUXrlX
         2pQzqhsVNHRxbeyeMGtp7fRudIRZE817E0OMF+s1ikebEgvwW8n8VCsQbAQ6U6/m9Ejk
         8OeLIViXY6TO8FfkQcjTib6YbKbxIrXUHhy2SDwqCVGRQoGC2o9qnoBsYYegxxn5jeBe
         hl5PGqcBh0jq4hcDPGs09GTvJNkzg7JHvxm6ciqoLACPn09kc+eOb1f5EhVYl2lt9oeq
         4gFQEHUbnIZc3HfJhOI15Nz8aBzNQ1+StsEI3z+Pbx/hWsSSSVP5LtKkpnL2PwDKOFtA
         2oRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795621532; x=1796226332;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+hF8JaB+djbNpsEhW3Xi8DSX8SvBQulT2na5Z6v+Cc0=;
        b=oZQ0SGvUU/SwGLXw1QJgjbdf/vDDkqXJwtiH1wq4EynuMfAIu8xKvupRdhs1XK55Bm
         HIKmUWk0HowSr2Cf42TYKog2hP7nD+Lul24l3M6FbkHUnbnxgK8EidrINZHHRXnRJqpK
         ljeeWBvz12MJQbj11CkCvLxDk9mHkaJHwR4mPwr505YYP1waSklAj9cVp/ywKIEJAJiN
         ZawT1Q8YMhn2+tvlkXSs1HG/glZ8gap8cLAwkrmERIlqlKPZ/I+YSeYUBq1/JLB8nyxe
         L+i+5pCAGa5z2axkZaJgRchg1lDTHpc6Yqsxz7EPgozXdP4cCi4Ae9do2w6pPROanLRr
         XMzw==
X-Forwarded-Encrypted: i=1; AL+hErFut/JhbrRgG63044BpIIGWdiIjwyfE7sXneG5v6G9a6IXtLMDvdCQ36OmaruLr9+3zl9351q3iqqKN@vger.kernel.org
X-Gm-Message-State: APuU4Z9sbMSQisHVZloDLhXr0hnauaOVIM1spSVgf53HGQuPq5TElHqI
	jU6xRkvD+/X+sxyF1/e9dQk0//q/e4XjmqDyzxPHLHa2fqy8CbJyhfcF
X-Gm-Gg: AZFdTZfiQC1rBQ+LaU6XwpsQJMqKrm/q987d8uNGbcT1ZRxLjT77lF7MIEC0W091GqE
	aYmx7xrNVRa3vAfiJi7fXnnRLssX/x7qKn8NuFhagfx5n11ef4glEGqK2e7DVZqZK4U9mvyCNXh
	P+dt7pAo94PVAtLem+PFBt7uenec4LCqAvXnjKeUhN5MLG9dkEr8IAXM+xRSACY2mfGQ3qy0cYu
	ZI2oGFSOkNwfMiOarmfj7vki5fCoMnEBdyhB0yQPnRqKDeQ+Ry6suU3CxOeXBhvjGQSMI+dWA0k
	TKnzYjFb1ilj4zqV053NuQU2FmcChYIVvQZdxxWR3Xq4Cpe4Rw19bdw832j86yrg91PTnJ7gCmm
	gxa1xId8ozf74DnmAdt0qV+NZjQ6P7AqHdpVzhu0iFaaREAGT/rB57Bdk/Ta5vOz6hdDnuQQBRd
	5PftCN2BsGn6zghure4BLdwPXCv4904hCy3+FKs8Yc2MhyA3fACPrs5JVKbv9s512FFDM44oAdR
	wDSFL/VkPND4vc3z/2Nj/0aNm6htKMpGxUBzWHAs6GEAPWEjFJ6PVcYDvRma0OLlx9ld+zHFVc6
	8ALpFw3IeiwNF/J0xcWCFRzQYumryvJJAKGqUKt3y0KBGZodWde1cacubpnONA0YoItS3asdxgn
	Ps4PJddaqYeq/vIxEClSQH9ouEIWQEKrwfHt4PnnMs3Lg4D+77v0ua8S+ONX29EgPNK/FOOc=
X-Received: by 2002:a05:622a:4289:b0:535:2521:f07c with SMTP id d75a77b69052e-55d7690bbfcmr344909311cf.7.1795621531606;
        Wed, 25 Nov 2026 07:45:31 -0800 (PST)
Received: from wsfd-netdev58.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-921349b0827sm164792676d6.8.2026.11.25.07.45.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 07:45:30 -0800 (PST)
From: Xin Long <lucien.xin@gmail.com>
To: network dev <netdev@vger.kernel.org>,
	linux-sctp@vger.kernel.org
Cc: davem@davemloft.net,
	kuba@kernel.org,
	Eric Dumazet <edumazet@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: [PATCH net v2] sctp: copy endpoint settings to accepted and peeled-off sockets
Date: Wed, 25 Nov 2026 10:45:28 -0500
Message-ID: <ad53ffafc3285da03f3b6a888981a9b30f8c3ff2.1795621528.git.lucien.xin@gmail.com>
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

As gomaja noticed, when accept() or SCTP_SOCKOPT_PEELOFF creates a new
socket, sctp_endpoint_new() initialises the new endpoint from the network
namespace sysctls and from the compiled-in AUTH defaults rather than from
the listening socket's endpoint. If an association restart (RFC 9260
section 5.2.2) arrives on the accepted or peeled-off socket, the restart
INIT ACK is built from the new endpoint, so it negotiates capabilities
based on the namespace sysctls instead of what the listening socket
configured:

 - Feature flags (PR-SCTP, ECN, RECONF, ASCONF, I-DATA) in the restart INIT
   ACK follow the namespace sysctls rather than what the listening socket
   set via SCTP_*_SUPPORTED socket options.

 - AUTH HMAC and chunk lists revert to the kernel defaults (SHA-1 only,
   empty chunk list) instead of what SCTP_HMAC_IDENT and SCTP_AUTH_CHUNK
   set on the listening socket.

Copy the feature flags and AUTH configuration from the old endpoint to the
new one in sctp_sock_migrate(). Add sctp_auth_ep_copy() to deep-copy the
HMAC list, chunk list, and shared keys from one endpoint to another. This
ensures that association restarts on accepted and peeled-off sockets
negotiate the same capabilities as the original handshake.

Fixes: b14878ccb7fa ("net: sctp: cache auth_enable per endpoint")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
v2:
  - Add a Fixes tag and target net.git.
  - Copy sh_key->deactivated to new_key->deactivated in sctp_auth_ep_copy()
    (reported by Clashiko).
---
 include/net/sctp/auth.h |  2 ++
 net/sctp/auth.c         | 48 +++++++++++++++++++++++++++++++++++++++++
 net/sctp/socket.c       | 17 +++++++++++++++
 3 files changed, 67 insertions(+)

diff --git a/include/net/sctp/auth.h b/include/net/sctp/auth.h
index 85efa65d3912..2ef52507bf11 100644
--- a/include/net/sctp/auth.h
+++ b/include/net/sctp/auth.h
@@ -106,5 +106,7 @@ int sctp_auth_deact_key_id(struct sctp_endpoint *ep,
 			   struct sctp_association *asoc, __u16 key_id);
 int sctp_auth_init(struct sctp_endpoint *ep, gfp_t gfp);
 void sctp_auth_free(struct sctp_endpoint *ep);
+int sctp_auth_ep_copy(struct sctp_endpoint *dst,
+		      const struct sctp_endpoint *src, gfp_t gfp);
 
 #endif
diff --git a/net/sctp/auth.c b/net/sctp/auth.c
index cbeb8a87a17a..3f97e2689e5a 100644
--- a/net/sctp/auth.c
+++ b/net/sctp/auth.c
@@ -1056,3 +1056,51 @@ void sctp_auth_free(struct sctp_endpoint *ep)
 	ep->auth_hmacs_list = NULL;
 	ep->auth_chunk_list = NULL;
 }
+
+int sctp_auth_ep_copy(struct sctp_endpoint *dst,
+		      const struct sctp_endpoint *src, gfp_t gfp)
+{
+	struct sctp_shared_key *sh_key, *new_key;
+
+	sctp_auth_free(dst);
+	sctp_auth_destroy_keys(&dst->endpoint_shared_keys);
+
+	dst->auth_enable = src->auth_enable;
+	dst->active_key_id = src->active_key_id;
+
+	if (src->auth_hmacs_list) {
+		dst->auth_hmacs_list = kzalloc_flex(*dst->auth_hmacs_list,
+						    hmac_ids,
+						    SCTP_AUTH_NUM_HMACS, gfp);
+		if (!dst->auth_hmacs_list)
+			goto nomem;
+		memcpy(dst->auth_hmacs_list, src->auth_hmacs_list,
+		       ntohs(src->auth_hmacs_list->param_hdr.length));
+	}
+
+	if (src->auth_chunk_list) {
+		dst->auth_chunk_list = kzalloc(sizeof(*dst->auth_chunk_list) +
+					       SCTP_NUM_CHUNK_TYPES, gfp);
+		if (!dst->auth_chunk_list)
+			goto nomem;
+		memcpy(dst->auth_chunk_list, src->auth_chunk_list,
+		       ntohs(src->auth_chunk_list->param_hdr.length));
+	}
+
+	key_for_each(sh_key, &src->endpoint_shared_keys) {
+		new_key = sctp_auth_shkey_create(sh_key->key_id, gfp);
+		if (!new_key)
+			goto nomem;
+		new_key->key = sh_key->key;
+		sctp_auth_key_hold(new_key->key);
+		new_key->deactivated = sh_key->deactivated;
+		list_add_tail(&new_key->key_list, &dst->endpoint_shared_keys);
+	}
+
+	return 0;
+
+nomem:
+	sctp_auth_free(dst);
+	sctp_auth_destroy_keys(&dst->endpoint_shared_keys);
+	return -ENOMEM;
+}
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index bc68af88e271..bfd87be8ed54 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -9623,6 +9623,23 @@ static int sctp_sock_migrate(struct sock *oldsk, struct sock *newsk,
 	if (err)
 		return err;
 
+	/* Copy the endpoint's feature flags and AUTH settings from the original
+	 * endpoint so that restarts on the accepted or peeled-off socket
+	 * negotiate the same capabilities.
+	 */
+	newep->prsctp_enable = oldsp->ep->prsctp_enable;
+	newep->ecn_enable = oldsp->ep->ecn_enable;
+	newep->reconf_enable = oldsp->ep->reconf_enable;
+	newep->asconf_enable = oldsp->ep->asconf_enable;
+	newep->intl_enable = oldsp->ep->intl_enable;
+	newep->strreset_enable = oldsp->ep->strreset_enable;
+	newep->sndbuf_policy = oldsp->ep->sndbuf_policy;
+	newep->rcvbuf_policy = oldsp->ep->rcvbuf_policy;
+
+	err = sctp_auth_ep_copy(newep, oldsp->ep, GFP_KERNEL);
+	if (err)
+		return err;
+
 	sctp_auto_asconf_init(newsp);
 
 	/* Move any messages in the old socket's receive queue that are for the
-- 
2.47.1

