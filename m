Received: from oss.cyber.gouv.fr (oss.cyber.gouv.fr [51.159.188.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8E5F47CA7C;
	Tue,  4 Aug 2026 20:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.159.188.251
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785873682; cv=none; b=mAouzSTctoaLVfmApXyxlzjQQw4oXz9rxETyGg+1YxFXTekYkn1UKG+zmyEloTH9wPp1s+cKLX5QuF/Syn3uoTP9pfTMSO00173b9+SsnrljhQ6g/xVuWEBNdWfwALtGQU7BQTAm3SxmAFRvLPqBeaB+4lLr5ZWRNBUTh7LM+AM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785873682; c=relaxed/simple;
	bh=PoCwSeNdvnrQC7bNliKK/WPOJcxbF4tBg3FjZv69mRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=GDoVqtPFNdrVpSmkNQUhZ0h8mmJ+cHAqhme/uJb2QjwkXc/cqJDXHBGiaSnez8EH5SQNGvu+Hg5TVb05CXivZOdginX8knNZ8dbfX6pbLXSdnlAkxrkAEST+Lq2UzwvDW028xa98n0u9ROSNVf/PIvaEG5OUGW24tCsUc92yF1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr; spf=pass smtp.mailfrom=oss.cyber.gouv.fr; dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.b=NdTuqVWP; arc=none smtp.client-ip=51.159.188.251
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.b="NdTuqVWP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=oss.cyber.gouv.fr; s=default; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=5rwNrKKJZi6CPQAN4Mj+Yrp6obxTEX2FMeJ5eLguFMc=; b=NdTuqVWPg+WS8eg89l2TgIB1DM
	sOt13UTmKbeUDtKEWtTZXwROZqmwVEa73qKjXUWL7aJUmFp0hI1UHQu7tI76pGkxHWJqKOzaFz3wQ
	vDXLMKmMT+Pm5K+dgO6KyJIr9gmGsvr9A5sdmC1SoLB71UprgaCrgSZh+s5KAZvLMq1jRa+bP3QeC
	vePKdONjavRt6q3ju3E3bAcASDsgo5LWhxqq090jdcvVqwMvm3QxEGn2UQy0nnpnRtNyKzjbMjH4i
	gm1FMYYJEBaIGYl/nodkS5uoSwPZrJ+F859d3Q047kpAVriFVPoGGpj4fm203KHHdy99QtS6CYXG7
	NtW1rUOA==;
Received: from [151.115.150.205] (port=53462 helo=gepetto..)
	by pf-012.whm.fr-par.scw.cloud with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <Jeremy.Jean@oss.cyber.gouv.fr>)
	id 1wrLKB-00000005xne-2RDY;
	Tue, 04 Aug 2026 22:01:18 +0200
From: =?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	linux-sctp@vger.kernel.org
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>
Subject: [PATCH] sctp: validate cookie AUTH state before use
Date: Tue,  4 Aug 2026 20:00:42 +0000
Message-ID: <20260804200042.2412009-1-Jeremy.Jean@oss.cyber.gouv.fr>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-scw-domain: oss.cyber.gouv.fr
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - pf-012.whm.fr-par.scw.cloud
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - oss.cyber.gouv.fr
X-Get-Message-Sender-Via: pf-012.whm.fr-par.scw.cloud: authenticated_id: jeremy.jean@oss.cyber.gouv.fr
X-Authenticated-Sender: pf-012.whm.fr-par.scw.cloud: jeremy.jean@oss.cyber.gouv.fr
X-Source: 
X-Source-Args: 
X-Source-Dir: 

When cookie authentication is disabled, COOKIE_ECHO restores fixed-size
AUTH fields directly from peer-controlled cookie bytes.  A forged RANDOM
length, HMAC list, or CHUNKS list can then reach association consumers
with lengths or identifiers that were never validated against the local
backing arrays.

A forged RANDOM length can cause out-of-bounds reads during key-vector
construction.  A forged HMAC identifier also caused a 32-byte write past
a zero-length AUTH chunk, providing a primitive for a local privilege
escalation chain.

Validate the cookie's RANDOM, HMACS, and CHUNKS parameters at the cookie
trust boundary before copying them into the association.  Reject invalid
types, malformed lengths, unsupported HMAC identifiers, HMAC lists
without SHA1, and forbidden chunk ids.

Fixes: bbd0d59809f9 ("[SCTP]: Implement the receive and verification of AUTH chunk")
Fixes: 1f485649f529 ("[SCTP]: Implement SCTP-AUTH internals")
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Assisted-by: Codex:gpt-5.5
---
 include/net/sctp/auth.h  |  3 ++
 net/sctp/auth.c          | 75 ++++++++++++++++++++++++++++++++++++++++
 net/sctp/sm_make_chunk.c |  3 ++
 3 files changed, 81 insertions(+)

diff --git a/include/net/sctp/auth.h b/include/net/sctp/auth.h
index 6f2cd562b1de..74b3790e2a3d 100644
--- a/include/net/sctp/auth.h
+++ b/include/net/sctp/auth.h
@@ -22,6 +22,7 @@ struct sctp_endpoint;
 struct sctp_association;
 struct sctp_authkey;
 struct sctp_hmacalgo;
+struct sctp_cookie;
 
 /* Defines an HMAC algorithm supported by SCTP chunk authentication */
 struct sctp_hmac {
@@ -72,6 +73,8 @@ struct sctp_shared_key *sctp_auth_get_shkey(
 int sctp_auth_asoc_copy_shkeys(const struct sctp_endpoint *ep,
 				struct sctp_association *asoc,
 				gfp_t gfp);
+bool sctp_auth_verify_cookie_params(const struct sctp_endpoint *ep,
+				    const struct sctp_cookie *cookie);
 const struct sctp_hmac *sctp_auth_get_hmac(__u16 hmac_id);
 const struct sctp_hmac *
 sctp_auth_asoc_get_hmac(const struct sctp_association *asoc);
diff --git a/net/sctp/auth.c b/net/sctp/auth.c
index c901d373af80..cc4229ee116d 100644
--- a/net/sctp/auth.c
+++ b/net/sctp/auth.c
@@ -377,6 +377,81 @@ int sctp_auth_asoc_copy_shkeys(const struct sctp_endpoint *ep,
 	return -ENOMEM;
 }
 
+static bool sctp_auth_chunk_id_forbidden(__u8 chunk_id)
+{
+	switch (chunk_id) {
+	case SCTP_CID_INIT:
+	case SCTP_CID_INIT_ACK:
+	case SCTP_CID_SHUTDOWN_COMPLETE:
+	case SCTP_CID_AUTH:
+		return true;
+	default:
+		return false;
+	}
+}
+
+/* Verify AUTH parameters copied from a state cookie before they are restored
+ * into an association.  When cookie authentication is disabled these fields
+ * are peer-controlled, so they must satisfy the same constraints as locally
+ * generated AUTH parameters.
+ */
+bool sctp_auth_verify_cookie_params(const struct sctp_endpoint *ep,
+				    const struct sctp_cookie *cookie)
+{
+	const struct sctp_paramhdr *random;
+	const struct sctp_hmac_algo_param *hmacs;
+	const struct sctp_chunks_param *chunks;
+	u16 hmacs_len, chunks_len;
+	u16 n_hmacs, n_chunks, i;
+	bool has_sha1 = false;
+
+	if (sctp_sk(ep->base.sk)->cookie_auth_enable || !ep->auth_enable)
+		return true;
+
+	random = (const struct sctp_paramhdr *)cookie->auth_random;
+	if (random->type != SCTP_PARAM_RANDOM ||
+	    ntohs(random->length) != sizeof(*random) + SCTP_AUTH_RANDOM_LENGTH)
+		return false;
+
+	hmacs = (const struct sctp_hmac_algo_param *)cookie->auth_hmacs;
+	hmacs_len = ntohs(hmacs->param_hdr.length);
+	if (hmacs->param_hdr.type != SCTP_PARAM_HMAC_ALGO ||
+	    hmacs_len < sizeof(struct sctp_paramhdr) +
+			sizeof(hmacs->hmac_ids[0]) ||
+	    hmacs_len > sizeof(cookie->auth_hmacs) ||
+	    (hmacs_len - sizeof(struct sctp_paramhdr)) %
+			sizeof(hmacs->hmac_ids[0]))
+		return false;
+
+	n_hmacs = (hmacs_len - sizeof(struct sctp_paramhdr)) /
+		  sizeof(hmacs->hmac_ids[0]);
+	for (i = 0; i < n_hmacs; i++) {
+		u16 hmac_id = ntohs(hmacs->hmac_ids[i]);
+
+		if (!sctp_hmac_supported(hmac_id))
+			return false;
+		if (hmac_id == SCTP_AUTH_HMAC_ID_SHA1)
+			has_sha1 = true;
+	}
+	if (!has_sha1)
+		return false;
+
+	chunks = (const struct sctp_chunks_param *)cookie->auth_chunks;
+	chunks_len = ntohs(chunks->param_hdr.length);
+	if (chunks->param_hdr.type != SCTP_PARAM_CHUNKS ||
+	    chunks_len < sizeof(struct sctp_paramhdr) ||
+	    chunks_len > sizeof(cookie->auth_chunks))
+		return false;
+
+	n_chunks = chunks_len - sizeof(struct sctp_paramhdr);
+	for (i = 0; i < n_chunks; i++) {
+		if (sctp_auth_chunk_id_forbidden(chunks->chunks[i]))
+			return false;
+	}
+
+	return true;
+}
+
 
 /* Public interface to create the association shared key.
  * See code above for the algorithm.
diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 0ae30c3c8913..c08a5753fb58 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -1852,6 +1852,9 @@ struct sctp_association *sctp_unpack_cookie(
 	/* Set up our peer's port number.  */
 	retval->peer.port = ntohs(chunk->sctp_hdr->source);
 
+	if (!sctp_auth_verify_cookie_params(ep, bear_cookie))
+		goto malformed;
+
 	/* Populate the association from the cookie.  */
 	memcpy(&retval->c, bear_cookie, sizeof(*bear_cookie));
 
-- 
2.47.3
