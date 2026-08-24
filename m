Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 111FA3A6F04
	for <linux-sctp@vger.kernel.org>; Mon, 24 Aug 2026 08:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787559524; cv=none; b=IlmNsH2hJ63s25AntKipo9Ep1D8z7CN8RAERR7z4vbLlAg+JN2Y0bmrEEqoCmIWkJ7lot++mKHncveOsojQJB/iNlq9EPxQyUz+BBP9eJBTow+q6SuTLXY12j2w+HUT/sbGFEEftbdgMjWqiCsALfnMRLOm/omI0fvStDjmsyyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787559524; c=relaxed/simple;
	bh=pKuhV9/J7HbYsqBHlv/2CzsONpr/yBCP2mv3h9XkQng=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lOt+cVJgWzQ+gSN5ud7WitZRja55ly6mbRbvCSnz7Rq5TqWVzJXTlj9FkkXetVW/nL5xF96ovw7ThJpoFmM2KmBI2ARbUgXNN1MfXU+K5XmDjI4bTvdpD/f/pjNChAvfY+J/We9z9eKqtsmU1UReSg9/DI76I9CcnVDrtzRe8YQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZwOxInKs; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZwOxInKs"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-38759bcd877so3803957a91.2
        for <linux-sctp@vger.kernel.org>; Mon, 24 Aug 2026 01:18:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787559522; x=1788164322; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=RksCCBXE0XrMrTynxzNYUq/eoGnOg17BpZWifRjpeC4=;
        b=ZwOxInKsOo1RmwZX9vfs2+V1EnPMb4TkR1ugIk88lXUwTXwLDeJoMscQ8KVyzobyjt
         +1GICJSD4a/hkBacPvpVRUurnuNFvvETsiACnXeowGkg8epq3ZXUbmrjSQ/x+COZzqlz
         WV7P35iVq32D63qCb5+xx7J1xXxl1VxC1xhvXiDtGXEIVk1oOOXUxgeAEI28i8ZBs8qj
         BKw7ySX/+WUYE6gHRl4kOYRGl4Fr8V8QYipszjYq2RXOZchwe+Q1sXyPAP5gd6BSWueu
         AbfKD4MFbHhgueoaUvrCZR1ayvEKdy7tC5mjslPddiYIF/V6mxbBWBS8GgcU0ZQgci3E
         tmIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787559522; x=1788164322;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RksCCBXE0XrMrTynxzNYUq/eoGnOg17BpZWifRjpeC4=;
        b=CCMdrjAovW9lHb67cPPEbVWvMcOY3GPjEDLpoV2Bg4uPdN0fCOeHLv/HVv0Bg4Z2RQ
         4zkGXNL5ULgLSsQjHszkBy08oiZCeZb7PhWlrzIEZnxTbzES4fkC3x48tbGdLLc9o/xY
         AG6kQy3f8919LpdpQc6bOP/WiEgctIOyZ2Yei0tkkmZ7Y0c2wMppzNBoBw6ZoZMtzrSi
         gE/uK2JujPbs2smm3WrphmzT1E6voAL/9NsS1u8xPFxtXOSnuXTp3EJ91TOSRGWGmnnS
         4HiREbA11gXOFxU53yoWzRGMN0K0kecmygbCnGKUz+ZKaz4ID0w0e+8B7JpqKQZKmYLF
         +5/A==
X-Gm-Message-State: AFuF++npJh79pOo62lcmixdqthtTayags32aiZ61i666qVI0HStBaY2V
	An/d3eu01gubBw2uHTDmu4wgOVOquzlWH48VXIhGTVGJDTdig4w0qPNRVEt2g4XA4hI=
X-Gm-Gg: AR+sD10EU4yNtVerM+quLvpjzAP1whnyZOFd8gKKSr2TR8R7HFAXwnXzFl+jZYJxbd6
	eEenv6MI7M+NFIO30ZLeqwe3IQJTxL3FnN4/zEFuKqKLJvjVjotUsFWcXZPhjbyamJ0qQsDiDqh
	RBn7D3wfBgYZPf3hryOcNL6OdAKUA//avYXmt8Kbq43z5/30GzUuf8L0St/y4teBYyWmVShCMuy
	cUIIu6aBshObBTB99fJk1tznZEYgDkcdEAUHhf/xIqnQE1F5nqx3QYfLW+OK2oyh8Ow6dSwJh/w
	gMc7cDPRv0m+fA4eBlM/S/DoDKd1jHFcseyxkam+xhm29MsgfIDlRPBbHEQV4xY/PXX2CXVD+Os
	nmF/q6aGa7oPvqMitSTsUm+W/xrWYiUx1bOW0f8yO6h5D+OL5XvhjdiY+5p+vOPhtAQlzfH+3mP
	9anooz6suIpV7L/xDwUpwZTnI/cQCvgivvEPZPN9oZyB9tGE7ipuCtrejSJCB4RaXDKxziQq8IT
	6ZfRcS8zVG6YszQB+FaLP0dQgCgcfKMNfU1LJw=
X-Received: by 2002:a17:90b:164a:b0:390:b41a:b92a with SMTP id 98e67ed59e1d1-395deeaa2dfmr28096604a91.4.1787559522156;
        Mon, 24 Aug 2026 01:18:42 -0700 (PDT)
Received: from JUNVYYANG-MC1.tencent.com ([43.132.141.20])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-395e4999471sm9079775a91.8.2026.08.24.01.18.39
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 24 Aug 2026 01:18:41 -0700 (PDT)
From: Jun Yang <juny24602@gmail.com>
To: linux-sctp@vger.kernel.org,
	netdev@vger.kernel.org
Cc: marcelo.leitner@gmail.com,
	lucien.xin@gmail.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	Jun Yang <junvyyang@tencent.com>
Subject: [PATCH net v4 0/2] sctp: handle wrapped and duplicate RECONF responses
Date: Mon, 24 Aug 2026 16:18:18 +0800
Message-ID: <20260824081832.98717-1-juny24602@gmail.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jun Yang <junvyyang@tencent.com>

Fix response sequence zero lookup first, then make RECONF response
handling idempotent with an outstanding-request bitmask.

Jun Yang (2):
  sctp: distinguish sequence zero from wildcard in reconf lookup
  sctp: fix stream->outcnt underflow on duplicate RECONF responses

 include/net/sctp/structs.h |  2 +-
 net/sctp/stream.c          | 46 ++++++++++++++++++++++++++------------
 2 files changed, 33 insertions(+), 15 deletions(-)

---
Changes since v3:
 - Restore the SCTP_STRRESET_SET/CLEAR/TEST() helpers.

v2: https://lore.kernel.org/netdev/20260804113100.37840-1-juny24602@gmail.com/
--
2.55.0
