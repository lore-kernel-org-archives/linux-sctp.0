Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795396992;
	b=CzJ5rL04vEmFvnhXGuuJbBIlDCjBrGttezsm2rPIGPfP7DE1fdrKbaJq4xXh5ZRsP0dk
	 FLYUfsLNomgKjbx9JqZXPDeeDJLC7LWbmauiLjjUIWLmHEUGehfm/JRbH9/fSes7dUmCS
	 aAiMZ8zSXMijUxszYvPGw841EwWdvMH1RddHECMvosMksIx3vq407o4E+KIDHQt3w/fhB
	 dxFGhTAtaSLfq2xo7NcwxETXIgA4eb270UXBk9g3uwNB/7rRFcynzGdLV+i1rw04czvEe
	 qPUoHhyPVNaVYHMcB7HbDtn1HR1X3gKUzwu8zg5l4kwVMyZ30b8jdrALzzMb3tKmsWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795396992;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=VrsRfKDaeRM/QRQs0v0E1mQH4y0dNu7zDHVPAnHGwRI=;
	b=fkEpaqmeJXtKCL4jsgJVU/X5+uh9TVoSnODxf2JSCil8WJ/TBIwXGFXFRaFrBCV7OAyl
	 V5lltdPz+N0FrgDnuN1VwbKEjKcXKvbJFBsQXPdOCm2dTh7k4S7HmISZjmeZLe9lve4ar
	 35ZwmHgKgszOrYCkhsoUkzPIC8qp6rVaDdv4HMDGqfFgEKSYDjRvJpl56xZgxfZEYlOsH
	 LEy+bfQln/0w8BqWnglj4J19fVmyhHpzuv6HTSi1Bc8epafcEvLEmgMGKOBnQ/j6GnzeW
	 v+5gzi+Vjr9p/XqYfyHKU7vEf0I/Gw84/uXjf65cEP7v0DKcYoBTrfJxBVYbGIdHOnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=iH5E6dH0;
	arc=none smtp.remote-ip=209.85.160.177
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E541606A31E
	for <linux-sctp@vger.kernel.org>; Mon, 23 Nov 2026 01:23:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6E541606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=iH5E6dH0
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-55d2dcbb905so2689291cf.3
        for <linux-sctp@vger.kernel.org>; Sun, 22 Nov 2026 17:23:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795396990; x=1796001790; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=VrsRfKDaeRM/QRQs0v0E1mQH4y0dNu7zDHVPAnHGwRI=;
        b=iH5E6dH0H2wbHX6n6xgrGku9CMgEVlCrxy0LwyZx6wzSkf0MlcvGab5yb+9Z3Os2u3
         lt2hGKmz23ZenWh7aeDRvrx4wLi8GbxH5HMJ9Ot9A/ebu2Y6IJGOkXcRtXD1FVbOdo7b
         smJ0913ND9j6yl8HxFcTv9DCuKXquPv8OcfYnHhSWNq+564v8QEZ13BLXjVpLdZsxXsd
         cq8l3Gbn8VPF/RYpO02nCiC8F/ZiBshJ/MCK1L5KkMaHMnDNP6ZCZh0SkgHG2FP69rWG
         oXImx7CDTgMFNr9kTRGrHY5d03emRhMV2JL85dgxHeL+iuJwOUjC5n1Hnvp2pVY/m+bx
         yX4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795396990; x=1796001790;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VrsRfKDaeRM/QRQs0v0E1mQH4y0dNu7zDHVPAnHGwRI=;
        b=L4HMPXCT/61MJd7nI8kiIXh4BAhD1oAEGV53mDGarIO5oX1RDhfHKXA9VC0xf/aRpP
         BUkMx0WpyLYwKNXbf187m35gvIYDuH09U8EEq+PQE7lZIqJ56zNZTCGlG55/B604s5Jd
         QvsoL6j3Zs5Dg9P/8wrnTUv7unTf5/mtoXqLV+TuPKI/RQOR/fIhyjZuXY07e+2e0ZUM
         LUJdNO17nAxV0SW1y31NOSDD/x7vBVkLqLWkE4jEdKtmINK6vpmrySMKcIMwQNnaGu5K
         5Ri3roTqs3kvlb4TQHCO+tkshdsxeByW2J7wHu+qeITlVyMM1z58cqX5twuwiSLsvPqW
         2JYg==
X-Forwarded-Encrypted: i=1; AL+hErEi/Et5HP0X3aO5fY9a5GFjlcQaXOP7FKaDSwmWIvVIPD5O6uRGtA1YfijIuDTq7rdT5o0kcSjRaOJ/@vger.kernel.org
X-Gm-Message-State: APuU4Z+w0XSl1eHBPA4xrw26VKrXck38lbcarcTO4i7zgS4PCnpAZttq
	bhaH/sbSN6TsZQ1hy0kw8gHYCtyRTO80GTZRsgFnSwy2gdeVhQnmntLI
X-Gm-Gg: AZFdTZdaeOTC36LDSOh5sLZcg7uQD+xzmVWp28/0Z1zCwAgt0g0t3VuTZU6TFb/50PM
	vg1Q23WpsmDaGbjcFvYyupsMtJvSYXvVXiAfTAO/rcn3+RLspZdG76W4Uda/B5ozEFQfIp+jB//
	fO0vihD3pDyxr86e7kt0vTMzkJFEGjsaTEYi+boJ/ATS+SugBWh9TBUN1ViN0/LTBUbDnMKztLF
	JKsDbz8r+b/wpfZ21Jd3kY34m2SJpNlsLLoYHPXLvOj3w0DOO4tB33j+ujBH9bEGh9ggct+FsAG
	pdWW1lid8ytZmKwzWdRQ4S0WJ6y0SYjliMdvPIvl0vLRT6vijdl72VjAVCdbddelZ3Y8npnXRjo
	5wO0RO6mCTitgrIh/3DdUP6wY9BE06JmuD2qkjl4EClygb/3kSbr+3M0S5HVTmel9sDRXQqfnTs
	57avlCLhYZzAJmqCpVvecHsS+ouz9U8o9knQuNiMP6T7oV8lj6iFW0UjVzWEJY0DiJfuFvlFBzJ
	dAjvx13MWVLwLiPxiFrzFmtNpcEo8xAl6iuPD0z8dLrG/ZUTVXn+AxbbCj8C4QgrckmRCOF6Y+t
	5+KrawSb5d/bm0NPa628mZHwJWWQcr5YUwwf8BeyMX8JYa+3dH0CUF56pQaWAWetIlN3/mjU8aF
	yiz0fWGpE5K52f8Uc0BT7c16dru7AMb6cixyIvU0NJJekLKmuMXvf3zvj0DiF7bU0HYRRS3Dae0
	2hoF0MGTAWtV96vKxMwg==
X-Received: by 2002:a05:622a:4e95:b0:536:141d:d427 with SMTP id d75a77b69052e-55d76ae8343mr164579311cf.73.1795396990227;
        Sun, 22 Nov 2026 17:23:10 -0800 (PST)
Received: from wsfd-netdev58.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-55d7882e2c6sm86898611cf.12.2026.11.22.17.23.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2026 17:23:09 -0800 (PST)
From: Xin Long <lucien.xin@gmail.com>
To: network dev <netdev@vger.kernel.org>,
	linux-sctp@vger.kernel.org
Cc: davem@davemloft.net,
	kuba@kernel.org,
	Eric Dumazet <edumazet@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: [PATCH net-next] sctp: copy endpoint settings to accepted and peeled-off sockets
Date: Sun, 22 Nov 2026 20:23:09 -0500
Message-ID: <48580ca6a02b588e9c24444801109506da11a9d2.1795396989.git.lucien.xin@gmail.com>
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

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/sctp/auth.h |  2 ++
 net/sctp/auth.c         | 47 +++++++++++++++++++++++++++++++++++++++++
 net/sctp/socket.c       | 17 +++++++++++++++
 3 files changed, 66 insertions(+)

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
index cbeb8a87a17a..e075297b9ead 100644
--- a/net/sctp/auth.c
+++ b/net/sctp/auth.c
@@ -1056,3 +1056,50 @@ void sctp_auth_free(struct sctp_endpoint *ep)
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

