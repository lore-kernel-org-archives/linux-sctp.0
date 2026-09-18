Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20D5C17D6
	for <linux-sctp@vger.kernel.org>; Fri, 18 Sep 2026 03:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789702793; cv=none; b=kldyz9LK23HQ0IQQsP/4n/ly0E65Csb/nLuFtc9gH6sqv69jm+SXfZE5H4ofrzG704uBFpCOmELoGqy3nn3YFvF/VLbb6qvJY8J0vJcqx4kbka6s1cQEbIdJR85S6JJf6WaXbcP1RCaGU/uDGhqXkRWbL52nAwBy70bkrpPvigE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789702793; c=relaxed/simple;
	bh=9zyfsMStqHCzcyLPXjxWLHVGXBONiRoKF6UKjmqzzSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ADtaAEF7g+mzz6fXqOtUl4Cgu84pKBGVBG7a8kKB/Fl6MTjeeJAn7vKGHfvZNOWgiFl+x0zpAGqtaebvRoEqH41/Q0/FQDrViL52E/VKg+5K/QcSH2vVoKsx89zvsCnPfvFX0i9Q8y8geUw3OPYpqJ74Ywc3aBQuw2LRYgwxVbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=htfvsjFH; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="htfvsjFH"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-398b1e63c49so1147925a91.0
        for <linux-sctp@vger.kernel.org>; Thu, 17 Sep 2026 20:39:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789702791; x=1790307591; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=SKq4v+7ohiq5ZxcfqZ+UYd2lyYbuemEMf0RmoykBXpw=;
        b=htfvsjFHk+5g6a00eSg5PqaVap1JkBzT2oo2k1m+WbArVZAXewOyOm3NSn0ZqaPkS+
         XzmQTdFOBDLM18wCeHOLrxowasFH+UMgEzPsCVtu4PJSuTjUH2upMfbbYNa5Xa1QfUqi
         9HKM/G04zws3cwHIeR5iEqvYe/1v4sznHYpJfGoMZUXUPsf14yNwhj9DtJDbie5CDoIQ
         rJ8ljrS2ScZJEfea5Ve2lpLYTUOoesndQKC1hSmyF95P5ZxUSGecqsQjEWBCGP8FLe4N
         q1onxT0H0aLR/k+wVt7b9qHgNDs63bJK9B9StTu6XZ6SKp/vcGBjr/hMLLwBjAw6gCkW
         d7oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789702791; x=1790307591;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SKq4v+7ohiq5ZxcfqZ+UYd2lyYbuemEMf0RmoykBXpw=;
        b=hm2eZmtqlqOrxmn8AkxdD7S8nmQcv64yPXV9DtT50HtdmiETG7b+OYHxfXEvfgPkj1
         ID2pn9R0SFCxwTYixZsvDK1Q+Y8MymaGynVqNrKt8HXNNJDXWGQaVK8nPoNFhyMOUjny
         28y0BmUGXqRFIh5btj0VQScVZIdXoVVFfyklJLOpsq6yiN4WnHhNPdQhyPRGFaibZs+1
         YyZ09DMOX20gRDGqZcy4w3P1vbsZEXf2pIWKXJzFTebFgCQJ927tugQBnatidsJTANZ7
         JMyUzE0TYE36CpLN2itTgrspO9XwcZGM9TjF4NMaHjKoGb9ObdnnjloLH+hXXy8O2EIb
         Lnkw==
X-Forwarded-Encrypted: i=1; AKwUvBzZ9W7/vzauNT4QeX+qJKJMoiINYZ9DJQzZTleqsGToXa3AurQqaNgiKLQLBgVcyyddUmiE2wufz9hv@vger.kernel.org
X-Gm-Message-State: AFuF++m5Ds2ICqhFh+Xqhs9i7r2d+/FpwtPXVFyB+hG3efZ2ezeME564
	One4+VNEwA9HpvKDJjjO+GmPDmNVRO+CNpxk23Xle5lofdpv35sBTXCU
X-Gm-Gg: AYBFou0ZGgHsA1dtZXZJPI5E7Ma9Sk59yVZNWvPdKZU5JUTkfH+x9BT0kZ5SPqJE7m+
	kNHZL+rNw5Vmtdg3lWkAB9PHvSayC1mblR7QzpHZoVu8Cb0NJXdJhQKsikZ7iIUFHL0mZM3LpWp
	ln65vg8mU9nrAGlX2p+AAPytDGs1Hm2sCiMv7TrgHbPmwo5fbVIBF/F+CNZxFG4p0gmQMNjcd7A
	XHAU+EASxvjX9E1MyILfO5FkgfrNqqGxJ4I0EcQ5HuaaS0LGDTw2QD5428F1W9KwO3YzrbGN44T
	QRnupKlLbjyBvBIzKMVKxp8t2RzPpA4N/yCI476q93SOy7Al9ArbR+J0kIgarrm/aDtVtj2GRYQ
	xnKt+V7vnIziBYFvd10adEsDPRECv94fV8JqpRUkvjOtb5zGOOMpJwT6W4LM0zMmTwZ+QDQoqh6
	Md5MvpKNYwk4L7dWIdT+oDfpnWhXLd/xVvstEsVqUYa9gA1CHstRVUHmNcKF4pLeT6faLW/BKAP
	bhKnuhLVnuEKU5AqMwNDrnWSrzi4FAG40brK06kaNY2HC4C3A==
X-Received: by 2002:a17:90b:4a4b:b0:39d:e7c7:8044 with SMTP id 98e67ed59e1d1-39e36106e8dmr8461939a91.17.1789702791461;
        Thu, 17 Sep 2026 20:39:51 -0700 (PDT)
Received: from localhost.localdomain ([2409:8a1e:2e81:7320:79da:8b9b:16b2:8431])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33c287aab5fsm608065eec.22.2026.09.17.20.39.47
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 17 Sep 2026 20:39:51 -0700 (PDT)
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
	Yuchao Zhang <ndaugoing@gmail.com>
Subject: [PATCH 0/1] sctp: check return value of sctp_get_af_specific in sctp_process_init
Date: Fri, 18 Sep 2026 11:39:41 +0800
Message-ID: <20260918033942.85061-1-ndaugoing@gmail.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch fixes a NULL pointer dereference in sctp_process_init()
that a remote peer can trigger on kernels built with CONFIG_IPV6=n.

Problem description:
In sctp_process_init(), when a COOKIE ECHO arrives from a source
address different from the one recorded in its cookie, the embedded
address parameters of the INIT chunk carried in the cookie are walked
to re-validate the source:

	af = sctp_get_af_specific(param_type2af(param.p->type));
	if (!af->from_addr_param(&addr, param.addr,
				 chunk->sctp_hdr->source, 0))
		continue;

On CONFIG_IPV6=n kernels the IPv6 address family is never registered
and sctp_get_af_specific(AF_INET6) returns NULL.  A peer that completes
the INIT/INIT ACK exchange over IPv4 with an SCTP_PARAM_IPV6_ADDRESS
parameter embedded in its INIT, and then sends the COOKIE ECHO from a
different source address (as a multihomed peer legitimately may), makes
the walk dereference NULL, crashing the kernel in softirq context
without any authentication.

Fix:
Add an explicit NULL check for af in sctp_process_init() to skip
unsupported address family parameters, aligning with the other
from_addr_param call sites in net/sctp/input.c and
net/sctp/sm_make_chunk.c.

Tested and verified style-compliant with checkpatch.pl
(0 errors, 0 warnings).

Yuchao Zhang (1):
  sctp: check return value of sctp_get_af_specific in sctp_process_init

 net/sctp/sm_make_chunk.c | 2 ++
 1 file changed, 2 insertions(+)

-- 
2.53.0

