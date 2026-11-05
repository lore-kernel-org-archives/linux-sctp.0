Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793854967;
	b=E1tRkumqkp96LgIE52p6MTWR3xrdiw138EUOgBzjd5UX9nSs1ZrQjn4lumIRTGm3VxKO
	 BdLNTlxPhLY6vZNGyhMuHYCObhMIWqRaJyYxV34z6jm404rOH0UrFUaDX6oqQrBmrVsu9
	 BZBjlLsBYmI6xaCfBbrPV2DZlWuCwt0FrTxFdpWtT7ShzkXulpE65yl7BPcnyfph5+i7E
	 UCvlMncpCQ1FWVV6WKgPHmyW4BwEJw5uCs46nRSLtaeEIwyulUFYnOj4NyG/pEbcJeGBB
	 APafoJOIqJHmQ/kSBJBnQTMea1uMYvB/Zt2MJGHX50kDocs1lBbkUoJESUskxMn1OXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793854967;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=LO7efjMzYzRkjGuKwYuy78sqey9ql9fr/9N15oGP1+E=;
	b=Y1JtGudNAng2rQsPeVXWygme/aku1Gx3PUtLnZ9gpTrLdmqzzH6lyV3ONjRjBYclbrcx
	 /5SPN2quluCgrQq4fFcs7QE6YCi4yU3OTtdA9gXxTIbBTAGwP45LpGJbTrzeEVRoeJPG3
	 2RhPbUSqU2o/a0REunwCPnu6Q8ed7LyactkaSOD/wMiFPGVEd5PqJfBuFt9gqyEgM4Ec+
	 auLy8FH+zZiPjiB90Cmt7UxBGlLlxmC3VtgBkQF3OEaNGnhz2EtHJox8QYGJaZHILl7jm
	 vSntauNJ7DpTAqiJo0M30lKaj+1tVsKPh5WpP3SXMw9eQW6o7CiiZ0foyrxeRCPlXCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=jF7FxoT5;
	arc=none smtp.remote-ip=74.125.82.169
Received: from mail-dy1-f169.google.com (mail-dy1-f169.google.com [74.125.82.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EC27606A32F
	for <linux-sctp@vger.kernel.org>; Thu,  5 Nov 2026 05:02:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1EC27606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=jF7FxoT5
Received: by mail-dy1-f169.google.com with SMTP id 5a478bee46e88-35b2c599f43so1186151eec.0
        for <linux-sctp@vger.kernel.org>; Wed, 04 Nov 2026 21:02:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793854965; x=1794459765; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=LO7efjMzYzRkjGuKwYuy78sqey9ql9fr/9N15oGP1+E=;
        b=jF7FxoT5DUg01XPIQKoII/OIFbtaJhSE+kxslDbtQi8ukCE5stYLsOAhskPoTIgNV4
         KPiGf4+2+3TUevvlXRzzG2m0TVoBuh59xEyZV8LnWMjKra/CdRtmUOV3UdwebYef+P6H
         q/o7DrNDs2VQ+OQTqtHTJDZt/ovdO081CU0+rVWeAFMTewQq4GuCWnBbiVGe9TwO4oWB
         EzpfIDj3EfODbbmeob+53wJwIZiffNjxyLfRuyMLZi86bYlmRCEHziFhzmpLpWID7rit
         AlZ6igJ+iLGQ90COXYesZV8tOfofedFcGr6Y1iQRiedMROzO5vqnQU3e3rfN//wYTyvV
         Jqtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793854965; x=1794459765;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LO7efjMzYzRkjGuKwYuy78sqey9ql9fr/9N15oGP1+E=;
        b=B2AIQJjjmnIiBLlO4WTMb08iKDbe4gP64SIjukRlHl00CrAR8DdV4zvP5iCgXQm4yr
         OChK52ys1qJ8FxzFXf+G1QL+8DongiZeWzNOcy6LShDqH7DNFb5STlMtm2O7/+1HiUNS
         l3hUW+ERlM3AChkwTXyowJhlK1ZH5uXtOXJXvP8Lh6+6n/k2KYKzMrCFqT7HBXmDSKDU
         CHEIn/Du1qHejzeP982zECJCfsb4wTKraibhNm6uopu9hKCb6ZHtzfNAtlAcidF9d7BL
         tLrbTS4MxOlpbBIiGQOW1UdRYFn239AHP2pDZNMnDj3wR066rWa8qHEDo3FXiqfUvqbq
         NTkQ==
X-Forwarded-Encrypted: i=1; AKwUvBxSRV/3/gz1RwsnlYNd9a0eMo6m3oF2DBrylfPnAiy0HVaeRSJhtIXESc4gNghhC440cRvg4mjMQJa7@vger.kernel.org
X-Gm-Message-State: APuU4Z8LHjpUiAHt7BTJqjUSXmte8HUi55Y7EmqUBzXKleotDMXQ9Na7
	l6eUwjBlhjJQnSZ6wnz5JUyqvPhyftEgI1SJAn3yKm/8vJPSbEcy+1z0
X-Gm-Gg: AYBFou1NBUer3lyFgNprRslZaxnDMd9S1BrQRpmEKt+6sDilGcBfg/Kp/bTtn3n6L2t
	MISMQ1WhG/Ho5sfOQnJjFhLSZAjIP2VEeYkQVjQ5EnhgJqZYYv3wc+rGNkZOA3OFDxCfpm5kFiH
	mUyTxtquiFyC23APLtNf99dQQgjFDdEjooN1/owh5QW+ZQ5vTPsgOsmb/3TVnZ3tNrZV6nJzydn
	m5FimrjFj9yQkvWgHL+zM6P08MznYlMVlLUDu6XogeA2T2z+HFrgWPGNmhLBc/AetfIl7pqe5mq
	gTBdMtNwWnhz2WeDMsau6AWC8nsz5+7T7UOUoAoPawA7umdTkgE0QehNFfmQihcSnGmaTYF7CAB
	iaAudiaHtRrCxiVsI/DIonaeWMZrbU9TZlHptOj2Jz6h1Wyhci6M1xgicbiN9WqygRVy8CVm2Db
	w0CDBFESAb48J0eF3RogSfBhciGqAUykVMgQUwcOTb3KDf/NADSHNn112l+2IHmb90c4egRFBAU
	tkESPB72KQVoX06FeAeoFKVgyb4g9sbpHdguF8KrepIRobTgnCT274tUqd9zKgSIr4hJUsEko7a
	idu8vPYYcWHxaUdBk41tmbb1oNOvIcJ64WVKcQ0NXFP0/v70oDgMOE0UP19AosApJoa27lLbhh4
	=
X-Received: by 2002:a05:701b:2084:20b0:153:21e5:4328 with SMTP id a92af1059eb24-1ac5a9670abmr29178715c88.17.1793854964836;
        Wed, 04 Nov 2026 21:02:44 -0800 (PST)
Received: from localhost.localdomain ([136.25.42.214])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b245c1c283sm13626735c88.4.2026.11.04.21.02.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 21:02:44 -0800 (PST)
From: Tim Budding <tim.budding@gmail.com>
To: netdev@vger.kernel.org,
	linux-sctp@vger.kernel.org
Cc: lucien.xin@gmail.com,
	marcelo.leitner@gmail.com,
	davem@davemloft.net,
	edumazet@kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	shuah@kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Tim Budding <tim.budding@gmail.com>
Subject: [PATCH net v2 0/4] sctp: fix I-FORWARD-TSN handling with user message interleaving
Date: Wed,  4 Nov 2026 21:02:21 -0800
Message-Id: <20261105050225.49292-1-tim.budding@gmail.com>
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
different streams share the TSN space. When a PR-SCTP message is
abandoned, the receiver still frees queued fragments by the
I-FORWARD-TSN's New Cumulative TSN, which loses fragments of messages
still being received on other streams:

  TSN  stream  MID
    0    0      0    B   64KB reliable message on stream 0
  ...
    5    0      0
    6    1      0    BE  PR-SCTP message on stream 1, lost, abandoned
    7    0      0
  ...
  I-FORWARD-TSN new_cum=6 skip=[sid=1 mid=0]

The stream 0 fragments with TSNs 0-5 are freed with the abandoned
message, are never retransmitted, and stream 0 stays blocked.

Patch 3 frees fragments by the skip entries instead of by TSN, and no
longer treats an I-FORWARD-TSN that reaches the highest TSN seen as a
reset. Such an I-FORWARD-TSN is then handled by sctp_intl_skip() alone,
which has two partial delivery bugs of its own: an unordered partial
delivery is not aborted when its own message is skipped, and
PARTIAL_DELIVERY_ABORTED reports the highest skipped MID rather than
the one being delivered. Patches 1 and 2 fix these first, so the three
fixes should be backported together and in order. Patch 4 adds a
selftest.

Patch 3 has a cost, as discussed on v1 [2]: an unordered fragment of an
abandoned message that first arrives after the last I-FORWARD-TSN
naming that message is no longer freed by a later, unrelated
I-FORWARD-TSN. It keeps its rwnd and receive buffer charge until a
later unordered skip on its stream, a reset, or teardown. Dropping such
fragments on arrival needs new per-stream state and is left to a
follow-up [3].

Changes since v1 [1]:
 - Fold "sctp: don't treat an I-FORWARD-TSN as an association reset"
   into the purge patch, now patch 3, as Xin suggested [3].
 - New patch 2, from Sashiko's review of v1 patch 3.
 - Move the unordered partial delivery fix first.
 - Selftest: add leading_edge_nopd, reset_pending_srv/cli and
   pdapi/pdapi_uo; wait for conditions rather than fixed times,
   including all data being acked before the queue check.

Tested with the new selftest, sctp_vrf.sh and the lksctp-tools
functional tests, also on a kernel with KASAN, lockdep and kmemleak.
W=1 and sparse show no new warnings.

Initial bug observed in use, root cause identified with AI-assisted code
inspection. Related bugs found and fixes implemented with AI assistance.
All reviewed and tested by me.

[1] https://lore.kernel.org/all/20261024120627.837568-1-tim.budding@gmail.com/
[2] https://lore.kernel.org/all/20261026052706.187296-1-tim.budding@gmail.com/
[3] https://lore.kernel.org/all/CADvbK_du=-oT19kKBKYSjFKYscnQSH1mekRKMXgmLPMXTEH_=w@mail.gmail.com/

Tim Budding (4):
  sctp: abort unordered partial delivery when its message is skipped
  sctp: report the partially delivered MID in PARTIAL_DELIVERY_ABORTED
  sctp: fix I-FORWARD-TSN handling of fragments on other streams
  selftests: net: add SCTP I-FORWARD-TSN tests with message interleaving

 net/sctp/stream.c                           |   2 +
 net/sctp/stream_interleave.c                |  38 +-
 tools/testing/selftests/net/.gitignore      |   1 +
 tools/testing/selftests/net/Makefile        |   2 +
 tools/testing/selftests/net/sctp_ifwdtsn.c  | 699 ++++++++++++++++++++
 tools/testing/selftests/net/sctp_ifwdtsn.sh | 233 +++++++
 6 files changed, 951 insertions(+), 24 deletions(-)
 create mode 100644 tools/testing/selftests/net/sctp_ifwdtsn.c
 create mode 100755 tools/testing/selftests/net/sctp_ifwdtsn.sh


base-commit: 6baae996ecf6a3f57b08ea6f6786e29af9260f51
-- 
2.34.1

