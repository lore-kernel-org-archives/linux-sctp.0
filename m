Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795751312;
	b=MBO5yewtChNxgsGRSs07ixcyqx0OGnrwNrLM0+bYm0D4gE8S0tn80dOkLHtAAIXtE/We
	 JlmXlSOjC3SM4WqY9Bf1Orc2AVjSN3YjXdfdTwxCvr6Wf3ob5TjnvMZh03y/2QhzQvUAx
	 CJUG6DGsoahw8bkbmDBnhbWiTH9CpNURrcne6yURryz6pipLL4FFG2bmmolCElg+DXZMc
	 cjCc7gJfZo6hzkFwcyDorRK8xX7TJoD2JGT2zXKc4wi94y2V4JFcGUB+JGNkxxUBzX3QR
	 qdtmenxGxCGpNEeh5tMaEdCUCxCyGVnl27nZA+mxD05LzONQn0WutmyCFRiCG+7x4oQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795751312;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Endpoint-Received:X-Original-From:Reply-To;
	bh=JfYvPMJByIBM8Lq5c+t11jSf5YhCsrh9TwTWSxwZ8ZA=;
	b=mPmzg2+9E920GA28RYvD/SLQu0zMFamNJcJCvttqLpwHWgc+OqpbeweFAWdPzdPNlKld
	 ZkdfxBCp3PAFoL90JTFcd+4+Q3vREFNGdvSuk8E03jSLJEL+cIBQQq+gK7uMfLD1TfS1w
	 1B3UAEW+GBS/dvAAK070Q+vGzoLxcf6leZURENdyOVnA22bHhxlS53wguBI+I6wAEtu+Y
	 dqL/K/J4wIdCKihuYMDkXVDh39arkqRUphex+ZlJ2x2FFLFHQsM3JiGRXvhCjRBg6TjeL
	 6Q79HcY2/kt6mCcunrlVpke3gGImYVukynZh29ZOX3Nu2qeUef7jBl7tNvdHRstj8UA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aaOKV2qd;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A95D606A324;
	Fri, 27 Nov 2026 03:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aaOKV2qd
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795751312;
	b=N6q+9Vz3uZxNf/Q3iapcWzpqEbRQKcSqqRJSHVUQ+tN8j9XwPSkFYQxfaYNVkzkQlEHP
	 8fqDA6HoTLesOf7LMUrFB26gwVDW6gRyneO6z75ANDbtzQBIh9TB+qjLMDlyW/zDQ/JXD
	 dGMxTNeqWqwj1ptJ1O3dq9YHUloTUsBVLUOfKYFy5zlAX/vxQf0L6df2ZSG08yG0GxQRN
	 NVE18pccLah1x8O5jV3OQjmnRtjhP4/woYxpO3N2pEOgZv5zOvyWXC/xxOt6OCZOjTdB6
	 IcmqsXYz9uNzQYVCwXjkIM1wq3VaQDzY3jDG1hW6a756NXHSuUoEQqJni/SYG4f381A==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795751312;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=JfYvPMJByIBM8Lq5c+t11jSf5YhCsrh9TwTWSxwZ8ZA=;
	b=sZPd2ZYcTLn5a/uCYTh2h/6xldqAQ0UgKBmt93NyNFe+Kh2NCpnAiWz0ycKupLd56qbH
	 WtkFiMmZsGQDnj+/BA6LPKQUiucWKE6twhmzB8Cl7dgiP4g5KlNO6kDxHtpk1crBkTDd1
	 Ran6+dy4+nL7ypDO7kl5h5Dh78wY5gAufAtK2hasvVF1F8Hdj3gnyTs/5C1pVFl06FUlt
	 TSdP9UEid3qxeCW2VImwOzmkcgC4L3ZtGgHu28TTJhE7XSqY44DoiR52f6CfQKcHbuE4v
	 axMcsavt4sa5HiTf8H18Sk9EENqju0fX0+afw8u3wgaKO8ufwXxtkM9kMqkers/9Ecw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 39F281F00897;
	Fri, 27 Nov 2026 03:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795751312;
	bh=JfYvPMJByIBM8Lq5c+t11jSf5YhCsrh9TwTWSxwZ8ZA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=aaOKV2qdsHBH8JlGBoHB4Oyj4kWCoqS+nZ6tbBvYw94eerblgQNnizAzEODYU0M9f
	 t18kYnekr79ve2t88fP8T7L+nmFUkmMVIUx9i3z2j+fthSqpek4aahq8vcVXMQ757w
	 PZKkz1WBkgmuFIIcAcQnQrhSzpSJ71+0wfINLVoY8S3loHJwq5U9ZTVtui5oFOsu+2
	 jFvhW3oZMq1GrnwfAFNxIfMxvataurZ5s13qsgmFPV0LrhS0kQd915Ik/TZUO2Xgol
	 zUvVJBMy4f6I6dX23DE9G73zRX9qG/U0oBcxC4n8kFg9vPz8IpFGB0ygPcQvFswRul
	 JVHnM+8sSSK+A==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id C19BA4B54C;
	Fri, 27 Nov 2026 03:48:27 +0000 (UTC)
From: Dickson Wu via B4 Relay <devnull+dickson.wu.certik.com@kernel.org>
Date: Fri, 27 Nov 2026 03:45:34 +0000
Subject: [PATCH 5.15.y 2/3] sctp: validate embedded INIT chunk and address
 list lengths in cookie
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Post: <mailto:linux-sctp@vger.kernel.org>
List-Help: <mailto:linux-sctp+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sctp+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261127-so4-sctp-515-v1-2-bbee1a6af200@certik.com>
References: <20261127-so4-sctp-515-v1-0-bbee1a6af200@certik.com>
In-Reply-To: <20261127-so4-sctp-515-v1-0-bbee1a6af200@certik.com>
To: stable@vger.kernel.org
Cc: Xin Long <lucien.xin@gmail.com>, 
 Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, 
 linux-sctp@vger.kernel.org, netdev@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795751132; l=4074;
 i=dickson.wu@certik.com; s=dickson-b4; h=from:subject:message-id;
 bh=wvTRasiLPbjXwX1WPHxv3KXHDg2v2+K2wZdKmJkhqbo=;
 b=ffOdLZIDlNZG4UxoINJtXJyPtwNZr2BLpR5+cD+KAW5mZo4hzv7GS8EykS0vya80WUV7McYXx
 zwLhbLb2VeKAwXL+G+160nV3Veb6Ocp/+vqErJYMC3uagdsZTIuX7p1
X-Developer-Key: i=dickson.wu@certik.com; a=ed25519;
 pk=fxH7FS4FdojeJSGLJzgKdfO51Rvr4EW30yinj2mc1vg=
X-Endpoint-Received: by B4 Relay for dickson.wu@certik.com/dickson-b4 with
 auth_id=1647
X-Original-From: Dickson Wu <dickson.wu@certik.com>
Reply-To: dickson.wu@certik.com

From: Xin Long <lucien.xin@gmail.com>

commit 6f4c80a2a7e6d06753b89a578b710a2499a5e62b upstream.

sctp_unpack_cookie() only checked that the embedded INIT chunk length
did not exceed the remaining cookie payload, but did not ensure that the
INIT chunk is large enough to contain a complete INIT header.

A malformed COOKIE_ECHO can therefore carry a truncated INIT chunk whose
length field is smaller than sizeof(struct sctp_init_chunk).  Later,
sctp_process_init() accesses INIT parameters unconditionally, which may
lead to out-of-bounds reads.

In addition, raw_addr_list_len is not fully validated against the
remaining cookie payload. When cookie authentication is disabled, an
attacker can supply an oversized raw_addr_list_len and cause
sctp_raw_to_bind_addrs() to read beyond the end of the cookie. The
address parser also lacks sufficient bounds checks for parameter headers
and lengths, allowing malformed address parameters to trigger
out-of-bounds reads.

Fix this by:

- requiring the embedded INIT chunk length to be at least sizeof(struct
  sctp_init_chunk);
- validating that the INIT chunk and raw address list together fit
  within the cookie payload;
- verifying sufficient data exists for each address parameter header and
  payload before parsing it.

Note that sctp_verify_init() must be called after sctp_unpack_cookie()
and before sctp_process_init() when cookie authentication is disabled.
This will be addressed in a separate patch.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/75af23a89adf881a0895d511775e4770da367cbf.1780873427.git.lucien.xin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ adapted to 5.15.y: extend the existing bounds check ]
Signed-off-by: Dickson Wu <dickson.wu@certik.com>
---
The backport and the test runs were prepared with AI coding tools
(OpenAI Codex agents, with review by Claude). I went over the result
before signing off.

 net/sctp/bind_addr.c     | 11 ++++++++++-
 net/sctp/sm_make_chunk.c |  9 +++++++--
 2 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/net/sctp/bind_addr.c b/net/sctp/bind_addr.c
index 6b95d3ba8fe1c..0947b276d1e08 100644
--- a/net/sctp/bind_addr.c
+++ b/net/sctp/bind_addr.c
@@ -275,6 +275,16 @@ int sctp_raw_to_bind_addrs(struct sctp_bind_addr *bp, __u8 *raw_addr_list,
 		param = (struct sctp_paramhdr *)raw_addr_list;
 		rawaddr = (union sctp_addr_param *)raw_addr_list;
 
+		if (addrs_len < sizeof(*param)) {
+			retval = -EINVAL;
+			goto out_err;
+		}
+		len = ntohs(param->length);
+		if (addrs_len < len) {
+			retval = -EINVAL;
+			goto out_err;
+		}
+
 		af = sctp_get_af_specific(param_type2af(param->type));
 		if (unlikely(!af) ||
 		    !af->from_addr_param(&addr, rawaddr, htons(port), 0)) {
@@ -291,7 +301,6 @@ int sctp_raw_to_bind_addrs(struct sctp_bind_addr *bp, __u8 *raw_addr_list,
 			goto out_err;
 
 next:
-		len = ntohs(param->length);
 		addrs_len -= len;
 		raw_addr_list += len;
 	}
diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index b599dd2c15bd4..79d2c2b179c35 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -1759,8 +1759,8 @@ struct sctp_association *sctp_unpack_cookie(
 	struct sctp_cookie *bear_cookie;
 	struct sctp_chunkhdr *ch;
 	__u8 *digest = ep->digest;
+	unsigned int len, chlen;
 	enum sctp_scope scope;
-	unsigned int len;
 	ktime_t kt;
 
 	/* Header size is static data prior to the actual cookie, including
@@ -1789,7 +1789,12 @@ struct sctp_association *sctp_unpack_cookie(
 	bear_cookie = &cookie->c;
 
 	ch = (struct sctp_chunkhdr *)&bear_cookie->peer_init[0];
-	if (ntohs(ch->length) > len - fixed_size)
+	chlen = ntohs(ch->length);
+	if (chlen < sizeof(struct sctp_init_chunk))
+		goto malformed;
+	if (chlen > len - fixed_size)
+		goto malformed;
+	if (bear_cookie->raw_addr_list_len > len - fixed_size - chlen)
 		goto malformed;
 
 	if (!sctp_sk(ep->base.sk)->hmac)

-- 
2.43.0


