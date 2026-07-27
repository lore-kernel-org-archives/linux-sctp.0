Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B170B3F327A;
	Mon, 27 Jul 2026 23:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785194290; cv=none; b=Vt8e+osdVJ6VbTVVCq1iTgvuc08CGyKkIKPCF2eYEtSaeSPsmljuKvzalZ/FveaqIFWwZ8O0VHMguZkFFHqmcnz+y0Bzk/11BizX0l/fXzk9tEIJst5WxHu9mzdCwFs/znVbRYSduhY1QKDIF7uJR667cUPXI6u5LHmi4p8MaNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785194290; c=relaxed/simple;
	bh=ObZaFaNdg7f8fxTB+G7vEc+MfOtmxQWlPhUhtFCHF9g=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=SGf19aZZAtO0Kv7nHarwAPQCqCn+v0bmfBqPNqxAZY+Og1nLAQFsUzDYf4dQ/LSVKi65cDLawRqyD+2F20r+apWxLgoJcPLbFLwVncmr/b8dngSi00CNFG+rSSD/NiJPMX3hLcJwCdj+ugRD2RTp9Cp8NVGc8Cx3shxUYTUqtlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i1teuyhn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i1teuyhn"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 43C23C2BCF6;
	Mon, 27 Jul 2026 23:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1785194290;
	bh=ObZaFaNdg7f8fxTB+G7vEc+MfOtmxQWlPhUhtFCHF9g=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=i1teuyhn8C5GAMUxgs6jmM4gIIZIxHVuxQIcjxbKLaCZnoI8X1An/hNNvaHlExcwW
	 bqFCoeRdWyYIsuODZk2M+gXm52rFjYRAcmvVpj+iSspZJX/YV0xFSj18+nOeA4T55U
	 BOXswfglDafZmtvXI09BtDwSiWmp8LpG3x/zc6h5SEiCzOQnkqSpx7ieHCOMsdpCDS
	 pq7TGjpTW3qZlpzXL51+pFzbtFkJHC2cfQRa6qk4lF4yLdTy2ZPGkQhgz4nfz6KFfk
	 ZOXhiXoiJX1zYRgYH20h4mixfLsM59gUpQj2Q36NZkocp8+G2Xu38u6Wg82p38BBeu
	 RZqpsJu1ikINQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F108C531C9;
	Mon, 27 Jul 2026 23:18:10 +0000 (UTC)
From: Charles Vosburgh via B4 Relay <devnull+trilobyte777.gmail.com@kernel.org>
Date: Mon, 27 Jul 2026 19:17:30 -0400
Subject: [PATCH net] sctp: validate Adaptation Indication parameter length
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260727-sctp-adaptation-length-v1-1-0ab58b2810a5@gmail.com>
X-B4-Tracking: v=1; b=H4sIAAnnZ2oC/yWM0QrCMAxFf2Xk2UBXaQf+ivgQ27hFpJYmE2Hs3
 636eC73nA2Um7DCadig8UtUnqXDeBggLVRmRsmdwTsf3eQn1GQVKVM1sv7FB5fZFiQaYzjGEHx
 20OXa+CbvX/gMhQ0u/1HX652TfZOw7x8wYtPyfwAAAA==
X-Change-ID: 20260727-sctp-adaptation-length-aa16536552d0
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, 
 Xin Long <lucien.xin@gmail.com>, "David S. Miller" <davem@davemloft.net>, 
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org, 
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
 Charles Vosburgh <trilobyte777@gmail.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785194288; l=2040;
 i=trilobyte777@gmail.com; s=20260727; h=from:subject:message-id;
 bh=wCoSIOJR+7EQ3GwZeJvo3MqgXnw0t2pbCcjUroECces=;
 b=iG49uxij7c0cxm0J4SFhCX6CCcut8o/62OJ85HHBOvgSMbS5+yuGeJqhW8xxOCIdDtaM5YwLt
 reLPwDo8JwXAHpbSxFezLK4P0kALVCpkZ+T6oqYE/zBA9kRBouipMSN
X-Developer-Key: i=trilobyte777@gmail.com; a=ed25519;
 pk=kxCwp20gY82hL3ixb5IXlZ2N0X9TDxiKPCpjPcWqN3E=
X-Endpoint-Received: by B4 Relay for trilobyte777@gmail.com/20260727 with
 auth_id=899
X-Original-From: Charles Vosburgh <trilobyte777@gmail.com>
Reply-To: trilobyte777@gmail.com

From: Charles Vosburgh <trilobyte777@gmail.com>

The Adaptation Layer Indication parameter contains a fixed 32-bit
Adaptation Code Point after its parameter header. However,
sctp_verify_param() accepts a header-only parameter because the generic
parameter walker only requires the header to be present.

sctp_process_param() then reads adaptation_ind beyond the declared
parameter. When the malformed parameter is last in an INIT, the read
starts at the receive skb tail, and the value is copied into the state
cookie returned in the INIT ACK. This may disclose four receive-buffer
tail bytes.

Require the declared parameter length to match the fixed structure size
and abort the association through the existing invalid parameter length
path otherwise.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Charles Vosburgh <trilobyte777@gmail.com>
---
Runtime-tested against net.git base 53658c6f3682.

The patch passes checkpatch, builds net/sctp/sm_make_chunk.o, completes
a full x86-64 bzImage build, and rejects the malformed header-only
Adaptation Indication while preserving the baseline and valid
eight-byte controls.
---
 net/sctp/sm_make_chunk.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index c02809264075..1f7a097802b4 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -2168,7 +2168,13 @@ static enum sctp_ierror sctp_verify_param(struct net *net,
 	case SCTP_PARAM_HEARTBEAT_INFO:
 	case SCTP_PARAM_UNRECOGNIZED_PARAMETERS:
 	case SCTP_PARAM_ECN_CAPABLE:
+		break;
 	case SCTP_PARAM_ADAPTATION_LAYER_IND:
+		if (ntohs(param.p->length) != sizeof(*param.aind)) {
+			sctp_process_inv_paramlength(asoc, param.p,
+						     chunk, err_chunk);
+			retval = SCTP_IERROR_ABORT;
+		}
 		break;
 
 	case SCTP_PARAM_SUPPORTED_EXT:

---
base-commit: 53658c6f3682967a5e76ed4bc7462c4bdcddaec3
change-id: 20260727-sctp-adaptation-length-aa16536552d0

Best regards,
--  
Charles Vosburgh <trilobyte777@gmail.com>


