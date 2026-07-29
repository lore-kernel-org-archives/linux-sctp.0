Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8E7643CE62;
	Wed, 29 Jul 2026 14:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785336885; cv=none; b=eNzZo9XciECcafPVZ6czQpPllQBz9fCTKi3Ek1HX62dOB82UtgXXeEc/SnER7kRzUYW9swxP+haqKQS4XU94zo/y7ZEjwKLt29smqxSsOznaJ4dKSWxiciJuVzt+VDR2UQz4FmZqujy3j6We2f80gvjnJVNSIaHfRHDjLXXn5t8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785336885; c=relaxed/simple;
	bh=2NJHoro+sLZzogfMZLyqq2JppkenrhoHGxt8PzXFrRM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=Akm2NHZfxcOWzPbGTqHBbdnYnb23+hPWuMgmPrMKsgWaKtwPBOCH6JAf5CmYTkt5ZTgjM2CIRgvuz+kQRE84+5nDq1EzcoNxbm/+w4yHwtAVbcf+SL0YkeqP+Vsk9o03GoSOrOq8u2KzM7HO1NJGAt4LrBCcKZq7zQO37CteUCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lnywAbds; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lnywAbds"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6A66AC2BCB3;
	Wed, 29 Jul 2026 14:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1785336884;
	bh=2NJHoro+sLZzogfMZLyqq2JppkenrhoHGxt8PzXFrRM=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=lnywAbds53WAn/MxmUSHYVordLwTHK+Kjg53vW3XVEdvXHKhY2E2sSCEo+avsYMcs
	 WLSjcmj6s4t1YTI+5alspt9IFAy7j++EI+NPIPe5D7quAS/nDFMLe1jX+Nt+AN1KPn
	 cJjHoTYdNTap30FPN7FG9TUn3PN7aiETGalRM8j7HnJfbgo6zHyLlYRFRfIcREhpyH
	 DlxjpfSG1DAFfHORhl1t11Yo/Dk+a8DWk/22Bgz4i9Rv7NbZ0bIa+fhQgNaEhcdZ1k
	 GnED0o2fu3AS0HOUzqFoUQzpdNKWy8NjogMghVUh+DFtzOVAFu+7PhiKECT9ZS4Ybx
	 skD9y0gdQpz0Q==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48EA9C53219;
	Wed, 29 Jul 2026 14:54:44 +0000 (UTC)
From: Charles Vosburgh via B4 Relay <devnull+trilobyte777.gmail.com@kernel.org>
Date: Wed, 29 Jul 2026 10:53:41 -0400
Subject: [PATCH net] sctp: validate Cookie Preservative parameter length
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260729-sctp-cookie-preservative-length-v1-1-1ade32e42668@gmail.com>
X-B4-Tracking: v=1; b=H4sIAPQTamoC/yWNwQrCMBBEf6Xs2YW6FIP+inhI46ZdlaRk0yCU/
 rurHt8w82YD5SKscOk2KNxEJSeD46GDMPs0McrdGKinU+/ojBrqgiHnpzAuhW3efJXG+OI01Rl
 j9MPgiBzFEcxinSjv38MVEle4/UNdxweH+nXDvn8A+bGtE4gAAAA=
X-Change-ID: 20260729-sctp-cookie-preservative-length-ffa4472272fb
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, 
 Xin Long <lucien.xin@gmail.com>, "David S. Miller" <davem@davemloft.net>, 
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org, 
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
 Charles Vosburgh <trilobyte777@gmail.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785336880; l=2510;
 i=trilobyte777@gmail.com; s=20260727; h=from:subject:message-id;
 bh=vg+pRzQHtqmDcldA7wmoJprrLJOFDAz+bHKBOZZASV8=;
 b=gnu/YmwrNjWnv84AcUmadJFMhxPGwQQcfX/VhEnVwrCu9DRmhwVrpntewjtkIfYj48bQnVhfR
 lV4nsEAO+eLD9QR6aX2Q+YgC0m1iNFJjo/bpYvIS2kLL+Yw9BUlDJeq
X-Developer-Key: i=trilobyte777@gmail.com; a=ed25519;
 pk=kxCwp20gY82hL3ixb5IXlZ2N0X9TDxiKPCpjPcWqN3E=
X-Endpoint-Received: by B4 Relay for trilobyte777@gmail.com/20260727 with
 auth_id=899
X-Original-From: Charles Vosburgh <trilobyte777@gmail.com>
Reply-To: trilobyte777@gmail.com

From: Charles Vosburgh <trilobyte777@gmail.com>

The Cookie Preservative parameter contains a fixed 32-bit Suggested
Cookie Life-span Increment after its parameter header. However,
sctp_verify_param() accepts a header-only parameter because the generic
parameter walker only requires the header to be present.

sctp_process_param() then reads lifespan_increment beyond the declared
parameter and adds the value to asoc->cookie_life. When the malformed
parameter is last in an INIT, the read starts at the receive skb tail,
and the resulting value changes the expiration in the State Cookie
returned in the INIT ACK.

Require the declared parameter length to match the fixed structure size
and abort the association through the existing invalid parameter length
path otherwise.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Suggested-by: Xin Long <lucien.xin@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Charles Vosburgh <trilobyte777@gmail.com>
---
This follows Xin Long's review of "[PATCH net] sctp: validate Adaptation
Indication parameter length", which noted that
SCTP_PARAM_COOKIE_PRESERVATIVE has the same fixed-format validation issue.

Runtime-tested in KVM/QEMU. The unchanged reproducer accepts header-only
and overlong Cookie Preservative parameters on the unpatched kernel. With
this patch applied to net.git base 51b093a7ba27, both malformed forms are
rejected while the baseline and valid eight-byte controls still pass.

The patch passes checkpatch --strict, builds net/sctp/sm_make_chunk.o,
and completes a full x86-64 bzImage build.
---
 net/sctp/sm_make_chunk.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index a1c0334a1038..eb9cff77759b 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -2165,7 +2165,14 @@ static enum sctp_ierror sctp_verify_param(struct net *net,
 	switch (param.p->type) {
 	case SCTP_PARAM_IPV4_ADDRESS:
 	case SCTP_PARAM_IPV6_ADDRESS:
+		break;
 	case SCTP_PARAM_COOKIE_PRESERVATIVE:
+		if (ntohs(param.p->length) != sizeof(*param.life)) {
+			sctp_process_inv_paramlength(asoc, param.p,
+						     chunk, err_chunk);
+			retval = SCTP_IERROR_ABORT;
+		}
+		break;
 	case SCTP_PARAM_SUPPORTED_ADDRESS_TYPES:
 	case SCTP_PARAM_STATE_COOKIE:
 	case SCTP_PARAM_HEARTBEAT_INFO:

---
base-commit: 51b093a7ba27476e1f639455f005e8d2e75390e4
change-id: 20260729-sctp-cookie-preservative-length-ffa4472272fb

Best regards,
--  
Charles Vosburgh <trilobyte777@gmail.com>


