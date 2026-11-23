Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795406947;
	b=Dy0xPb/XYFa+S0m8EbOsOt2eRz/Y25O3b9pkJH6U6C0LR5ocwSH4ehCus+Y+M7vywUSx
	 UvgKA5dIhfyCeRj6529nn3wTtIQ6daNUm8RjKGpSiMmFsULYxYpHTIwFEPwTWcNfDmGQ1
	 foUa2zCxo+6oqsbvnWTg95EsAs3TBGQ3DaATZBdMFUonzu/qJdX1AF5GnrKNzX+bwPUxb
	 5hVfZcJi2Phj34sVkkyEv5YVyGpMNCh9p5jNazDI04wVgfRA2HLbwLTn5wHG9phls3AxH
	 KSGXZy61tV9O3FOZd5Clme3UGTvWsqT0Pyz81nN/pquGq2YS/auPx0Bk9HXzVyc8p/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795406947;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:MIME-Version:
	 Content-Transfer-Encoding;
	bh=BtiPrcBfsD5mFuSC2CFNcDeCfcErC12Atx3v0TnNNw8=;
	b=5crlyNjwQV0fD1kCbjas9pfhlYn3m6TV0hjqbfTaafET2WUN840qzklo2uIg7iW9jnrs
	 NGe0RN/QcLdIFltfkuMBjlgxEmWbX3mGzK6JSKc5LQL67hKFM7un9aams4uBfAXtNKXKA
	 4cOugyHd63FzxEDZOTMkv8YCxIA8UZcOHRejEDrUKkgNgj/mSYeoLNT3lae6gzIixZmsJ
	 /VYnABxFkfsF87ek7PQUdo3oAyrdcKkmaLyRUUdZ6InZoVB1Kywgh8T+tLHjBohud1oAT
	 GLlJRxTe1Nt40XN9rs7fCxD3Mqbwt5FIAj25A6HGpRubdRF+4hwrSiMAq2ghuNmD8+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=uFI6fXON;
	arc=none smtp.remote-ip=74.125.82.174
Received: from mail-dy1-f174.google.com (mail-dy1-f174.google.com [74.125.82.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D135606A32C
	for <linux-sctp@vger.kernel.org>; Mon, 23 Nov 2026 04:09:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9D135606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=uFI6fXON
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-3712b6d9843so2343333eec.1
        for <linux-sctp@vger.kernel.org>; Sun, 22 Nov 2026 20:09:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795406946; x=1796011746; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=BtiPrcBfsD5mFuSC2CFNcDeCfcErC12Atx3v0TnNNw8=;
        b=uFI6fXON+Sl/Kx9AN7hdZ7oul1UiRTqjvT0Ci+D3lQhJ5VzJs2Hhn9Q+FnlfFPLY4S
         CFBTocoquxvAyN3Nih8zMGcj4WAFVv3Q47IwKlCvt9if4pys2+Ds2xZ6mecan6K+7jVP
         rrd4Np4H2y7d1P9o39XgdzJIga2H7zM5EZAQs6GablqppJdwYejshIndj9uTi7ig70la
         D5uxbjvjkzDI3c7LvBc6cTukEwsv9AGJAtfuUldP2t5pEuLqWHGlJK8aJ1Z3Y33yvAbS
         5UgAbbT5JZuSfKIdm8+5l3fhQf0d1RhTSI4k1MyUxeXVhaQWDebU2DGQdiwByjemnETw
         FAow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795406946; x=1796011746;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BtiPrcBfsD5mFuSC2CFNcDeCfcErC12Atx3v0TnNNw8=;
        b=QOjSU7UdzRL8btZv9VSSQldCXwTqBVWPLkxfoRmYVMzXPmU6uiRtTpUft66I8ixhgH
         3moALZWFrXcmXJyhPHoP/v9coSPZT6xOpOLMI6VbA2cOIftrqhB62bhshD2V4mlWMWgs
         uXJOYeHZ/YLEy3ZkG/lK933sao4MrLCQL5Oz4kLsFIbU5NJ5b1R8PuNmy8Bl/A9LTB2J
         lT72hqrunfASNxsds1qjSFY8q8qkmxq3BFAQcPJuZ/9rjfXdYH2yZfXAE4AzzqINY8kj
         ROnB/YgDHGWBkZr0JYQjgb8jl5TPtI605MMmJlh50jSRumX8oSlwC+f4XV1e4sSRgibb
         En9w==
X-Forwarded-Encrypted: i=1; AL+hErGnT4EyRdGPMHgdzjR4G2tP/gL5eJaYWNpcnEifR0urfYgeuBWLwbyTmWw37jrxofISLB6+QcCwLpO3@vger.kernel.org
X-Gm-Message-State: APuU4Z9IUzzGDe6gmHBl85+SVOkCPtUiMUZds7DCzrTaVk3KeFMdXpOe
	V8VQpTJCrz36rS/MCdOYhn3FpdF8yyiCTAn3ZnebcPICf2Rz1WVY38Pc
X-Gm-Gg: AZFdTZcjRtVIWGsjyP5XO73DgbbMtbIzViTO8lrb7VNJSzDmwGTWVdgVwJvFQIj0TFE
	dmXZ4WgqU6UVic0oVbcCZyFB5fxs+G0jQtzGrDjpLMeMziu4eeKiFyTs1dlC92tB2Z9RfkqWk4g
	OZk2rEJyTWaDd8/2bw0kYYSX55uwas+bIdAwNPyGGepqKR2OaQScOYOmc4mqFUwQNr8AMy99fNz
	GhoD4xbBJpDXOiI+WuGjwvSXAXT5K49s8t5TC/ZksbRtpeuYIrS8fLEIySgwQ8dWp9LdDQw4UnI
	wyIx9znAyB17+AUGSVUVv5262dU7MiiEetQFT8KoP/EyWM7Ii/2zKOY4HsU9ao5q+RECHI8ftpD
	6RUEZlXqLJWdnW69wB334Q2I9J9qKu31z9M4YkVcTyGXQhen6F8tVuywNObTNqUldRFgZ6zlTrh
	qBYHbmH+fZkYbPhPtxLo4dN0jJ5V8wYvONMReYsgwG9RtLDsZqSc19o4iIPZ3K4iaP2J0AG5AKz
	KO1QPSbIax/rZka0Pb9ru55YobDnZAhPt6tEMZq9zTTlQdwqdTbcnxhhN5j3YER0ZTRYjrBIt9P
	4fOxOtunUoShbynTqHwv4tt8v+++KIgGCz7DqbhNhXVHCFRhYc3WQKBc+izYhQdcRRE=
X-Received: by 2002:a05:7301:6486:b0:378:1191:43ca with SMTP id 5a478bee46e88-3863f1355b2mr7829460eec.18.1795406945611;
        Sun, 22 Nov 2026 20:09:05 -0800 (PST)
Received: from d20be28ee783.tail196be.ts.net (vldb.skku.ac.kr. [115.145.173.180])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-385677c0c1dsm33451547eec.21.2026.11.22.20.09.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2026 20:09:05 -0800 (PST)
From: Kyuwon Cho <kyuwoncho18@gmail.com>
To: Xin Long <lucien.xin@gmail.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Willem de Bruijn <willemb@google.com>,
	Jun Yang <junvyyang@tencent.com>,
	linux-sctp@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net v3 0/1] sctp: fail the association when the INIT-ACK cannot be processed
Date: Mon, 23 Nov 2026 13:08:59 +0900
Message-ID: <179539544818.3016044.13738712075053349592@gmail.com>
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

When processing an INIT-ACK fails to allocate memory, the association
stays AUTH capable with a NULL association key, and close() with
SO_LINGER {1, 0} then takes a reference on that NULL key. As Xin
suggested, the patch processes the INIT-ACK and sets up the key
directly in sctp_sf_do_5_1C_ack() and fails the association if either
step fails.

The issue was found by an LLM-guided test generator that we are
developing as a research prototype.

v3:
- Pass the error to SCTP_CMD_INIT_FAILED with SCTP_PERR(), like the
  other callers; SCTP_U16() made sparse warn about the __be16 value
  (netdev CI).
v2: https://lore.kernel.org/netdev/179514851805.604157.8527055700821138420@gmail.com/
- Process the INIT-ACK in sctp_sf_do_5_1C_ack() as Xin suggested,
  instead of skipping AUTH in sctp_auth_send_cid(), and remove
  SCTP_CMD_PEER_INIT and SCTP_CMD_ASSOC_SHKEY.
v1: https://lore.kernel.org/netdev/179505710266.3511678.14017674052424733262@gmail.com/

The patch was written with LLM assistance; we reviewed and tested it.
With it, the reproducer from v1 no longer triggers the report.

Kyuwon Cho (1):
  sctp: fail the association when the INIT-ACK cannot be processed

 include/net/sctp/command.h |  4 ----
 net/sctp/sm_sideeffect.c   | 40 --------------------------------------
 net/sctp/sm_statefuns.c    | 15 +++++++++++---
 3 files changed, 12 insertions(+), 47 deletions(-)

-- 
2.43.0

