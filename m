Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 774F320B1F5
	for <linux-sctp@vger.kernel.org>; Tue, 14 Jan 2025 21:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736891760; cv=none; b=tN3p8/IQCbwhYvjr3oBV3DrvgHC9Vesx6HMxW2qfjjC0g4qwcD1B19XoAQ+FSAcPx+Sp95UNJkTMRRIAKUm6CoJi0CgzGX1h87HTeirYUu/IHfd/1QoI2sZY8a6eW1G8A63m64V12JTMmcDevpoRN14BExcQnkQQkwGQRIKjUhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736891760; c=relaxed/simple;
	bh=GctQo7H8HkmP6GW9U3X0MKlIXcENPnDLXaQ5lhGQv4U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gNwr8scvRQduMh2k1M6yxUtvTOyCenZJ+gpEDhQEBlefpvi7GI9OUWwpe0EtjJiBETM6pxcezF1NSsykkLp1cv+cr3n9tfS0o7LLGoJhqwAwG/d+2OmKO+BtQIl1gZUv5SfLkQ9tz5+Yc90QYMfFQkTgThbRROPubS9/fzJMolI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ebklMm5h; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ebklMm5h"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1736891756;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=kmvn+FRsH75b3AFcBnzEsuAkCfsGQozChkxL0TaYJnk=;
	b=ebklMm5hNDUAybui5i2ZOcefOaqMGNo2/PNtDkVgRSUqHhBoRjmKTKu6zprybEBvkEZuev
	5DV+ZzKaG8NDtVRLZKNvLzv4he7YaFNYiDxD+bNT0tfZQQBy8Ap+qIHrTR0z8LD9nrp5s5
	Hi4bbvzzx4qYAULtv2xxSAGOhPd1Tmg=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Xin Long <lucien.xin@gmail.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	Kees Cook <kees@kernel.org>,
	linux-sctp@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RESEND PATCH] sctp: Replace zero-length array with flexible array member
Date: Tue, 14 Jan 2025 22:54:41 +0100
Message-ID: <20250114215439.916207-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Replace the deprecated zero-length array with a modern flexible array
member in the struct sctp_idatahdr.

Link: https://github.com/KSPP/linux/issues/78
Reviewed-by: Kees Cook <kees@kernel.org>
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 include/linux/sctp.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/sctp.h b/include/linux/sctp.h
index 836a7e200f39..19eaaf3948ed 100644
--- a/include/linux/sctp.h
+++ b/include/linux/sctp.h
@@ -239,7 +239,7 @@ struct sctp_idatahdr {
 		__u32 ppid;
 		__be32 fsn;
 	};
-	__u8 payload[0];
+	__u8 payload[];
 };
 
 struct sctp_idata_chunk {
-- 
2.47.1

