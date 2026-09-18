Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 759F83F482C
	for <linux-sctp@vger.kernel.org>; Fri, 18 Sep 2026 03:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789702798; cv=none; b=Cr9odhRN02DezClQbWi39FS0+EsXFDhkS4/+kmrMoxblgIk7OguwGOPUdJpngklGC9+DUcPi6McxFUfAom47hj1EIQBHqTQO7ZZIcAImAEysmPxVcTusPcLVu9JBuugT6Dm09jJ0aOuJ+djRhY+tLPm27EciWBFwGTro23weIyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789702798; c=relaxed/simple;
	bh=yJiyg92QC6XahndjgkRwHsdfasvgZ8Sl+8BkRmHKw6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eg2aoQ2QCwImLg4yZARME6fLeBgqQrkHW3eEOiOZ+UhoHZuFrCjV1BqVMWaujyaT8xaAOFufoiGxXjsnJui4lCiNFPkhiaXL0K37yluoWbtLObzC9RQfY4o9tbpDjkYxnuxrWVtaJgaPxqKbiflAZia2kFE9T0Q8LeXfZQTGg6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gy16NSMu; arc=none smtp.client-ip=74.125.227.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gy16NSMu"
Received: by mail-pj2-f13.google.com with SMTP id d9443c01a7336-2dd88a115ebso2061085ad.2
        for <linux-sctp@vger.kernel.org>; Thu, 17 Sep 2026 20:39:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789702796; x=1790307596; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Uey7daPDoexPjIHMCdJvQFu1kjO+d7SoV4geDUUnn+k=;
        b=gy16NSMuob6aZgfR18QnZQADpatcH/w9fbZD2etDem9Kllhxp9MVDmA+0CHkP/7xY3
         RKrETLo5PKTI7DoAu8MG0xv1IgyfI0KAPqTYzlR0dG6D9pQgll3MUia19StApmMX5HCP
         8V1Qz0qANcdL043nMUQApNEls4aMupDYPe0w6rmtOZmVCDWmYwqQeXMP4OxF7bC1Au+r
         /9uzzv4fzwzmtajJoyfT4LimcyiwsJ0jgLtelojrIkgUp/T+8oQXMQFT/j43A9JBMdPA
         jI3zk7X7y/lvlk676tRiDYwpboMtp3zhntTIDkdD6J1ZD2DGfBe6+Z30GmOU2dGiQ4D5
         MSdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789702796; x=1790307596;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Uey7daPDoexPjIHMCdJvQFu1kjO+d7SoV4geDUUnn+k=;
        b=q/be1hr1Wu4hsnuEO7G4tNdF62b2YSBvje7T7BWhXfScaWG4INEdgYvsZjdWkB6NOW
         8h4RsOT0/cnpXX2Pw0sOcJA8kaKvY5uW4NWtaZveM2cCnlWw3i9fGIHPkwlADClj4ZCP
         1E6qDfBteW5jIYT0rE3qEvpkxY2Y1+fMCqMsg2oyru4X4swYXQt4+F+TOAahiaKvB0Kr
         8ZFH2cGUiRJt3UFBiomQIRO+zHpN3Ub8shEKjfq704qmohyI9oIIRNg/Dh/Cro34YE8s
         itewouwZqS+aO5zBdmmuZxh6ov7qentMXcf0TcWqXXS7uosQe7xSEQIeEQ3Ov1biNM9m
         FOVw==
X-Forwarded-Encrypted: i=1; AKwUvBxeSee5PGO7OKUx6SnjG4Z3U3Zo4/TG8R/VhITGUEpSivuc3FUNL0+2xEGxfvzEfH8p0VA7YWgx1tK3@vger.kernel.org
X-Gm-Message-State: AFuF++mcMQFgIHKSEU/oF2aNd/KtwzHqQN1kjVR/o55IOw3YcMJqWtYl
	XtekkrGvldXgjEdqsxspoT1T1IqrUNbxqD5pHiF8tJc7/aQh9Ot9p2jp
X-Gm-Gg: AYBFou2Rec/9kXHQ2oPZBf4rNI/mqjbgDgQS+rzz5gypVOJvso4RZBH23NcYKCLjRrX
	T6Ex42w+VTZStiAgHr8Ex6nRsGoggsCBMqy0t59AQ0j0sDbdJxOm8TptWreMxTlvhSvpoXF2fo1
	s9peruNZI2M2AQBU9Le9YvGysJ5B2tJcebIb3CJvbYcuylNYRcpT3bhTxm7WEoJKOFOxs2MHe9d
	tKasaRbhyfW21yfg+9rJFXjaSyHAAQPTajFt3cGQ2VZu18453eFNAuLK+5qA12MbzqfF+NvuxuN
	OYLFlUrVdr9WfBkBC+n+1u3JThYbOGI1DYG8UF73c4sZKPrFMcCzxMhoXHOArNSyUoYxqQ148iS
	qwVQ9/GMV0Zu7Lu1CNwlWlMObwMd4iUijMRl3KYDlHoYoKjoCdcJ5CLIqtvPKyxH0+MEEX7slOo
	8V42/RGn3dO733RxKU2qbKhahs5+liFa17YBrCqBCqwtZXw72USTtXE4A7J53en/QGhP/71xBxO
	EvO/RAfba+nxLgOL2/RP3wgGieV3PW7vq2QVBi6xCf1gjhzrg==
X-Received: by 2002:a17:902:c948:b0:2d8:d4de:fa80 with SMTP id d9443c01a7336-2ddb1ab39edmr24350885ad.4.1789702795755;
        Thu, 17 Sep 2026 20:39:55 -0700 (PDT)
Received: from localhost.localdomain ([2409:8a1e:2e81:7320:79da:8b9b:16b2:8431])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33c287aab5fsm608065eec.22.2026.09.17.20.39.51
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 17 Sep 2026 20:39:55 -0700 (PDT)
From: Yuchao Zhang <ndaugoing@gmail.com>
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Xin Long <lucien.xin@gmail.com>
Cc: "David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	linux-sctp@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yuchao Zhang <ndaugoing@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH 1/1] sctp: check return value of sctp_get_af_specific in sctp_process_init
Date: Fri, 18 Sep 2026 11:39:42 +0800
Message-ID: <20260918033942.85061-2-ndaugoing@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260918033942.85061-1-ndaugoing@gmail.com>
References: <20260918033942.85061-1-ndaugoing@gmail.com>
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In sctp_process_init(), when matching the source address of a COOKIE
ECHO against the embedded address parameters of the INIT chunk carried
in the cookie, the address family handler is dereferenced without a
NULL check:

	af = sctp_get_af_specific(param_type2af(param.p->type));
	if (!af->from_addr_param(&addr, param.addr,
				 chunk->sctp_hdr->source, 0))
		continue;

On kernels built without IPv6 (CONFIG_IPV6=n) sctp_af_v6_specific is
never registered and sctp_get_af_specific(AF_INET6) returns NULL.  A
remote peer can reach this path by completing a regular INIT/INIT ACK
exchange over IPv4 with an SCTP_PARAM_IPV6_ADDRESS parameter embedded
in its INIT (ignored at INIT time by the address family gate in
sctp_process_param(), but the cookie embeds the whole INIT chunk), and
then sending the COOKIE ECHO from a different source address, e.g. a
second interface of a multihomed peer.  sctp_unpack_cookie() does not
compare the packet source address against the peer address stored in
the cookie, so src_match is 0 and the walk dereferences the NULL af.

This crashes the kernel with a NULL pointer dereference in softirq
context, remotely and without authentication.

The other from_addr_param call sites of the same family already check
af (__sctp_rcv_init_lookup() and the ASCONF path in
sctp_process_param(), fixed by commit e40607cbe270 ("net: sctp: fix
NULL pointer dereference in af->from_addr_param on malformed packet")),
which missed this one.

Fixes: 0c5dc070ff3d ("sctp: validate from_addr_param return")
Cc: stable@vger.kernel.org
Signed-off-by: Yuchao Zhang <ndaugoing@gmail.com>
---
 net/sctp/sm_make_chunk.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 84a4c97d0f75..ff1c013e2575 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -2381,6 +2381,8 @@ int sctp_process_init(struct sctp_association *asoc, struct sctp_chunk *chunk,
 		    (param.p->type == SCTP_PARAM_IPV4_ADDRESS ||
 		     param.p->type == SCTP_PARAM_IPV6_ADDRESS)) {
 			af = sctp_get_af_specific(param_type2af(param.p->type));
+			if (!af)
+				continue;
 			if (!af->from_addr_param(&addr, param.addr,
 						 chunk->sctp_hdr->source, 0))
 				continue;
-- 
2.53.0

