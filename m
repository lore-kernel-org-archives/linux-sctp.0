Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792843622;
	b=aJd6ZipXnpEkgBwv1y6l+1/9aJmB/S/0N4/KznxXbftUJOBsHSzZuQf1pHKAQfRROnhQ
	 yqn1n+SznO2N+pTWcGO4k9laJbZ8WLsgqU1ZvLyEIY7R6XB9lVBscSpMLnHDb8MLUN+DH
	 pRERdtou1VWIPiEaK6k4nu8rL/PMiFuvxGWegnnT2TnQtwzuWNbhET0Z+Ljg6SLatACOm
	 HNrZXr1bfKgtjihFcAsNdEFlBj3cQYXc7bvHZlOdquqhPv7SowvpUqEKzm4skLqS7Xfh5
	 jdc0rB4nxv02moRgXwaxnoUsW0aBl2aMX654d9HLmyhi3TOYdt7hqclU2IMRN0oy/+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792843622;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=iLsBpvRM6v0Gbb8cMHaG5f+AOPaNIuJwM/Pen4fkwPY=;
	b=EqDL3E8DdT1vPTQ3PDQ4xI6jBGY/q2aw/9RNwKri2lXcZme44M4+y54fo9sYBkD2oxDw
	 QzOutC72n5x9X8Bup02EfIPovUxb+edZF+KfPgQNQ/j3USTaN+FgQ6JFbwy56R+3HlmXT
	 RRDC78Dwlo53qYrf6pHPDR0CDns5bkq4o2hrN0uSaNHhKXfjC+2QIoQrU59kZ6208lH1t
	 e2TzwcMCCXUG7T6sFk0s5LuI8TCXvMhMO8E0kTvImb0Rb8UgKX1yaFTDPisozhKlpiiPe
	 LCjaClVAQ2DcGtDIUyObQPsPthZZaoz5xIVHU3yecsXGIIZdcb3oO0IkxHh+uI0jqTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=h62IlHUu;
	arc=none smtp.remote-ip=74.125.82.182
Received: from mail-dy1-f182.google.com (mail-dy1-f182.google.com [74.125.82.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 977DD606A31B
	for <linux-sctp@vger.kernel.org>; Sat, 24 Oct 2026 12:07:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 977DD606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=h62IlHUu
Received: by mail-dy1-f182.google.com with SMTP id 5a478bee46e88-36661f953e4so2978587eec.1
        for <linux-sctp@vger.kernel.org>; Sat, 24 Oct 2026 05:07:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792843621; x=1793448421; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=iLsBpvRM6v0Gbb8cMHaG5f+AOPaNIuJwM/Pen4fkwPY=;
        b=h62IlHUump8BEvauKAFZHnhoaGbJ/hyhck/aoKcgDoZ5C1TEK8cxIkbEhnKnRf7Upo
         bPjJuVKv6gv3duQ3NumZBkD/LOywZ5UPAwqrA03cNam+tMfYYPgx/ZAo1MSugRNvZczn
         Vd5pEbZ0KbuQP4rJEO1JAVghK3gxOkfJmQAnQxWg031KNksY72F3Rm7Ks5bnl+WwO6SB
         N/YMZG/5dUMXys+LfgpjcyJmdY4ntE467u8aAtW/dB3TIlWB7IOqDOJPCPVkQpLND5Hq
         K1CsB7bhJJ4nXHscagOHXuX4CH9SkfR+c0iFjNYzTAJfYUyqVZbu40cWRlgYpEISf3H7
         sO8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792843621; x=1793448421;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iLsBpvRM6v0Gbb8cMHaG5f+AOPaNIuJwM/Pen4fkwPY=;
        b=QFTNHaz+MTK7+xBjyetS9ceeHOQJhxH2OUQbIpCLf2FR6gjYwOY/IAFyCVBQnE00TS
         hCKjndozoHTQfukM57dqLDeZ6H74EJvgRcSkuamDROAO5TU1Wq2h+9y2QyqNqXGZ82W6
         DLrRDH5hJeDAxCyRQ1WVTtxIUxhboEyq1l25HO2ohkWKcysoZaMXedrNMKOYU7U6KnDl
         7BwwtOeXBtS+0oXlcJBUuYIaVeuBWL/6MsP3MoZRJ73zXwvrLfbZ0eZDlgYIBXFZ4ph3
         7AjMtsxTagpuuEBACffkyl8MFlzDyMINe0zwgI/2OrFyoftQ/IYdcSdZRSoXKIWOMaka
         R0lQ==
X-Forwarded-Encrypted: i=1; AKwUvByd5QU5SXn3E0vhS0cQYe2orTfdOOv6sTs+eplNN75kyZ35t/UYD/jTIQmpZBJkCBao5v3SFC6UZVhq@vger.kernel.org
X-Gm-Message-State: AFq9FYK0ObS0fhih/771jVMknT3UjwrQ31kYhnncl19Ou865M+vPUZrs
	GRPvktJ6M3qs8EIGxV+L7N86TAp8YqBJR2WK6Ll4+LGcomNPzsbJ/hiL
X-Gm-Gg: AYBFou3T3Cglzm+AYw7r/7mLb0If5uZKyCpctsKIPWG7nBiz7imsvwSEAZ77yZ11OqH
	K0kxHtfLaajYBfvdgFaQF3Dcj+9O3SMezYMW6vGTI+SANHO3TB8ks0PIP7DHc72TL83Rg9CnxDA
	3/ZtUHvTmHrrBWALnVobs4CHT7wcagJJ87wXa2IRAhL7iHhrVFC52RyX59hd8GKJvnaUuOseDyJ
	GDVyZtATry3As09SQmBbcDMHjZWH+/4R4hDqaXRW3GJmg75ECpiDZvCkD8n73IJ7pPhntrwwwFO
	fBujPpiX7vwdUz0t22MPByhO6ymw+uNNUhJ/sK8H1yCSMYlQlvdQWODIPRyeeqj7nu51zc68nww
	xvQypXQQwgyDFTWmFgunMgHRQP6pz/wHc3p4jhPOCldmiLzekVIrOckqZYw8PRm+zuEdqp0kxLV
	ydFqjGw3ryUB/1GBXkmYUX5PoMktLqj2PYVFaZhq2Dku7DBSZo+ITSzIZnbIKmP7BtfLuifRy/u
	zdP8e7kyxJOsSJz9WeUKakbvODWSknJ74N9ufQL3tjrohBKKpWZl4nGKZbax7/EFAk17juEn8AI
	logoIv+fyLqaLTLjWdqZe00Ckw==
X-Received: by 2002:a05:693c:8943:10b0:368:9553:f2da with SMTP id 5a478bee46e88-369e85074b2mr2972965eec.31.1792843620562;
        Sat, 24 Oct 2026 05:07:00 -0700 (PDT)
Received: from localhost.localdomain ([136.25.42.214])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-369e8d95e91sm8120722eec.15.2026.10.24.05.06.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Oct 2026 05:07:00 -0700 (PDT)
From: Tim Budding <tim.budding@gmail.com>
To: netdev@vger.kernel.org,
	linux-sctp@vger.kernel.org
Cc: Xin Long <lucien.xin@gmail.com>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Tim Budding <tim.budding@gmail.com>
Subject: [PATCH net 0/4] sctp: fix I-FORWARD-TSN handling with user message interleaving
Date: Sat, 24 Oct 2026 05:06:23 -0700
Message-Id: <20261024120627.837568-1-tim.budding@gmail.com>
X-Mailer: git-send-email 2.34.1
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

With user message interleaving (RFC 8260), fragments of messages on
different streams can be interleaved in TSN space. When a PR-SCTP
message is abandoned, the sender reports it in an I-FORWARD-TSN, which
carries a New Cumulative TSN and the stream, U bit and MID of the
skipped messages. The receiver still uses the New Cumulative TSN as if
it delimited messages, which loses or corrupts unrelated messages:

  TSN  stream  MID
    0    0      0    B   64KB reliable message on stream 0
  ...
    5    0      0
    6    1      0    BE  PR-SCTP message on stream 1, lost, abandoned
    7    0      0
  ...
  I-FORWARD-TSN new_cum=6 skip=[sid=1 mid=0]

The receiver frees the stream 0 fragments with TSNs 0-5 together with
the abandoned message. They have already been acked and are not
retransmitted, so the stream 0 message is never delivered and the
stream stays blocked.

Patch 1 frees reassembly fragments per I-FORWARD-TSN skip entry (stream,
U bit and MID) instead of by TSN. Patch 2 aborts an unordered partial
delivery when the message being delivered is the skipped one, instead
of merging it with the next unordered message on the stream. Patch 3
stops treating an I-FORWARD-TSN as an association reset when its New
Cumulative TSN is the highest TSN seen, which aborted partial delivery
on all streams and could abort the association. Patch 2 comes first
because the code that patch 3 removes also aborted that unordered
partial delivery in the leading edge case.

Patch 4 adds a selftest. Its ordered, unordered, leading_edge and uo_pd
tests fail without the corresponding fix and pass with it; its reset
test checks that an SSN/TSN association reset still works.

Tested with the new selftest, sctp_vrf.sh and the lksctp-tools
functional tests, also on a kernel with KASAN, lockdep and kmemleak
enabled. W=1 and sparse show no new warnings.

The first bug showed up as message loss in real use, and I found its
cause by AI-assisted code inspection. An AI assistant found the other
two while I was fixing it. The assistant also helped write the patches,
the selftest and these messages; I have reviewed and tested all of it.

Tim Budding (4):
  sctp: purge abandoned I-DATA fragments by stream and MID, not by TSN
  sctp: abort unordered partial delivery when its message is skipped
  sctp: don't treat an I-FORWARD-TSN as an association reset
  selftests: net: add SCTP I-FORWARD-TSN tests with message interleaving

 net/sctp/stream.c                           |   2 +
 net/sctp/stream_interleave.c                |  34 +-
 tools/testing/selftests/net/.gitignore      |   1 +
 tools/testing/selftests/net/Makefile        |   2 +
 tools/testing/selftests/net/sctp_ifwdtsn.c  | 538 ++++++++++++++++++++
 tools/testing/selftests/net/sctp_ifwdtsn.sh | 141 +++++
 6 files changed, 696 insertions(+), 22 deletions(-)
 create mode 100644 tools/testing/selftests/net/sctp_ifwdtsn.c
 create mode 100755 tools/testing/selftests/net/sctp_ifwdtsn.sh


base-commit: 7076f684d5132e6a6145e1da2fa74771ecd052e5
-- 
2.34.1

