Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793994696;
	b=i7QMRAkcADPWMe7+hMrRmc+ShlUCkqt2rNG59ZIKsQtPJtrcJeqx7vjRJ8E5RIiBG8q+
	 Wxr6QVifCbtf0Ti21pC/p5N8rg51NZnW7dQF0EahbVWXYkarJpDg7VsoqoljEIC8SW/bR
	 ua190gzSblFtCnWICz1iHSemfnrTKQpdAbi8vfaqA3t2oEUz/jWAvHSE6Z229kQtW1iVZ
	 l3eXrvTBHjfqIeg553/wHbcEawvUe+MP3vg1+mQjFW+uUABslUZTzYG0lt4BOTzBnr5Zc
	 /XDGaqaqCuJfIjDO8tmQbkbpTPRvsqt29zEAC3y22C8jDKeJNuwz/RVitFqBFsu2r8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793994696;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=ffQKOr7UnubupJZqlvLZWc1enNvauuxfHnatBigPms0=;
	b=Jnl/7bOiBfJoLRqd00n9xkK0gz/FPJxxLfR1m0ROexVUGfFFi++zmeWQxJJXjbs6A2cf
	 i4z0p47FVfqosfqe767kfOf5NxGOl58fxRWPbBfVstGfoG8rjQl0nTdO9sHisq648ZEfs
	 iFD0n3Lke9LGH0TlGA7UIGcWiCKlPPt0f3UVZMIBboBejGS9qR5HrmtpfyHLvPorFYIvn
	 Nxl8GeSyclnwicxuboMcuWY6rG6nEN/6jWr+x3cKMO7YZuRRSOHOeAHreZRR2imbgPcnp
	 WpdC30hCXxbp4bIbaDplYMeqgiXZkLP+CWSe5M9LYWy8zL+GWHoenCRCn2R/ESl0RGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=AXVOwGKL;
	arc=none smtp.remote-ip=209.85.128.48
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 101EF606A32C
	for <linux-sctp@vger.kernel.org>; Fri,  6 Nov 2026 19:51:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 101EF606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=AXVOwGKL
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4a214af2076so7572285e9.0
        for <linux-sctp@vger.kernel.org>; Fri, 06 Nov 2026 11:51:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793994694; x=1794599494; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ffQKOr7UnubupJZqlvLZWc1enNvauuxfHnatBigPms0=;
        b=AXVOwGKL0ZQ/8MhHgGtDkNLemGqJKsvgcFOBO98XdAtyAOsf6P5JaiG8DLsrYU43cD
         kqoWxmklZs3+Wpn4wacCbFsr4zrTlcksjpMGgWzY3bK2RZJG+kp8h3DaMOZKm4oLHaIH
         2/VXKg6+ewO7v3fcWV61iLbPTa5t8juelzLgI5w2MdSqtvBB2Ckdf8VlUz5NfK0Fi1rb
         Gn2M1F/bC7XDrmEq7e0H3BM/f73CThA69XLc1jQHpo1qPHiFJ8wKE1jEoLK9Ret4hPMD
         u8zGMFfcfGHc+zHuVY9Rj0iKsfaKI+twppjE8I6FoyeZ4A3YjeeRM1/m79h74QdRzBYp
         LnBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793994694; x=1794599494;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ffQKOr7UnubupJZqlvLZWc1enNvauuxfHnatBigPms0=;
        b=z4lowygdNKk8YSvzOdj02S0X744APcYXg08oNM45Fj2twR/oKW0QiZrIcUwhTgxuz+
         MWCUHuqsvQRC5by3Mhg8DZXFZILheV2lmGZLLRjR7805/nGaUwBETXzecSdfXyBeURW9
         F9zZ+IL9+XwS3pcDC5fU+wqTsKEYdOYncKIVeKRKyF45lBkqxOKNcF+NCxZe2DWBDZyu
         5+KxCuAL18L+LrOnSr+vY5Bbq5pHaGo3VppipsdNdt/PPL2ZDMBSAMEbUlMoQLQqFUXj
         9HTEeFaPtL6L3sq4GSXeGPLQ1cQJ+OtXL4dz76TZX+MUVzLvXSISo8pztbCA8gXLqkRr
         VTrA==
X-Forwarded-Encrypted: i=1; AKwUvBx0lQiZZk1ErzQBIWk4OJTXHq7otK39jjhQyeMVtZee91qS2xh04HkpVPG8HLySpA58h7dZn46ueRSH@vger.kernel.org
X-Gm-Message-State: APuU4Z8VLi5l/qCEQ0hmohqX4xa/SgtoLrrBGi8YcWTfk8KY7XG1zLsz
	SDDveKe/AYBHB3uFD4rbaFLXjqE/VEhlrHs9+a03IzNE3bbPAQ/EX3Hp
X-Gm-Gg: AYBFou1fDCYw96NAyZ7UO/hUkJtFXZpiUpvBrVX/huTIOl+UiyKj6fGQ+sXB2rwKFtH
	OBIr+IL5lbsDfInyLSnE69Qo4HiRytEuKfDBcQzOHoXTFG16GJzbFs68+Z4oeBf2LT0Muk4tyMQ
	pJdickVLTd0GYooYeyZnwMl0jWDs5aZN9njWgjz4LRZh+hiwWQNsjARYVM1R9B1mc814Zy7cOxT
	TNrVMQcBJs2BjQRtq+2BUHtRfgOm9I+AjFjmX6i+xbt0Sy2Ej2guyUCFa9/d9gaC+gUULnUK1Nr
	+4o4UbjcNk8NEKAVMDHzgv06BuD1XtTbf1RVTGBvOaGxQA9QHEKqKEhcqwgZVv2pRNRae/WAtHK
	nh4W6Loxn4jdqfYqUd4FPZf3/rE/1g6c/dfJ8BkWufXdDmzgQFXu9IGcTNFglpjhhIw3+xQ5ns1
	brf0nGNowlbZst0Y9Hmupz/jD3QdegtyHLQHr0JRFuqmQlb3vY5DTmFEotEG9Ze6HJ7k0WMXBvH
	TdwqeHWeVF5rP1WALx3psWbZuvMAC5kVpSt+5xCMf0mIRDQJpmHsFBG5iriy6iv/u+KN5crrsXG
	pLUGo2Rb+1/pPyGJZYZnJy5z
X-Received: by 2002:a05:600c:64c5:b0:4b0:a7aa:843 with SMTP id 5b1f17b1804b1-4b6df4f1dfdmr62389165e9.25.1793994694120;
        Fri, 06 Nov 2026 11:51:34 -0800 (PST)
Received: from dev1.kernelcare.com ([2a01:4f8:172:1c85::2])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-492d723283dsm5109746f8f.23.2026.11.06.11.51.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 11:51:32 -0800 (PST)
From: Andrey Misiurov <andrey.misyrov@gmail.com>
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Xin Long <lucien.xin@gmail.com>
Cc: Jun Yang <junvyyang@tencent.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	linux-sctp@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH net v3] sctp: fix ASCONF address change on single-homed hosts
Date: Fri,  6 Nov 2026 20:51:26 +0100
Message-ID: <20261106195126.1563231-1-andrey.misyrov@gmail.com>
X-Mailer: git-send-email 2.43.7
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

Commit 9b2854f86f0b ("sctp: don't free the ASCONF's own transport in
DEL-IP processing") refuses a DEL-IP of the transport the ASCONF was
located by, so that a later wildcard DEL-IP cannot use it after free.

This also breaks the single-homed address change (RFC 5061 5.3.2). The
host sends [Address Parameter L] [ADD-IP S] [DEL-IP L], the association
is located by L, and DEL-IP L is now refused. The sender never gets an
all-success ASCONF-ACK, keeps src_out_of_asoc_ok set and stops sending
data, so the association stalls.

Fix the wildcard DEL-IP instead: look up the transport of the packet
source rather than reusing asconf->transport. Both DEL-IP paths can
now free asconf->transport, and chunks bundled after the ASCONF still
use it, so point it at a surviving transport: the packet source for the
wildcard delete, the primary path for a plain one.

Found by manual code inspection while reviewing a backport of commit
9b2854f86f0b; reproduced on a two-namespace single-homed renumber.

Fixes: 9b2854f86f0b ("sctp: don't free the ASCONF's own transport in DEL-IP processing")
Cc: stable@vger.kernel.org
Signed-off-by: Andrey Misiurov <andrey.misyrov@gmail.com>
---
v3: a plain DEL-IP of asconf->transport set it to NULL, but chunks
    bundled after the ASCONF dereference chunk->transport (e.g.
    sctp_vtag_verify()); point it at asoc->peer.primary_path instead,
    as suggested by Xin Long. Reported by the netdev Sashiko AI review.
    v2: https://lore.kernel.org/all/20261029193454.1028626-1-andrey.misyrov@gmail.com/

v2: the reworked wildcard DEL-IP branch could itself free
    asconf->transport via sctp_assoc_del_nonprimary_peers() and leave it
    dangling for a bundled DATA chunk (sctp_assoc_bh_rcv() ->
    peer.last_data_from) and the following SACK; retarget
    asconf->transport to the surviving peer. The pre-existing wildcard
    SET_PRIMARY / sctp_source() point is left out of scope.
    Reported by the netdev Sashiko AI review.
    v1: https://lore.kernel.org/all/20261022163639.2566945-1-andrey.misyrov@gmail.com/

 net/sctp/sm_make_chunk.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index ddc31a5..9719464 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -3151,9 +3151,12 @@ static __be16 sctp_process_asconf_param(struct sctp_association *asoc,
 		 * packet MUST be deleted.
 		 */
 		if (af->is_any(&addr)) {
-			sctp_assoc_set_primary(asoc, asconf->transport);
-			sctp_assoc_del_nonprimary_peers(asoc,
-							asconf->transport);
+			peer = sctp_assoc_lookup_paddr(asoc, &asconf->source);
+			if (!peer)
+				return SCTP_ERROR_REQ_REFUSED;
+			sctp_assoc_set_primary(asoc, peer);
+			sctp_assoc_del_nonprimary_peers(asoc, peer);
+			asconf->transport = peer;
 			return SCTP_ERROR_NO_ERROR;
 		}
 
@@ -3166,13 +3169,9 @@ static __be16 sctp_process_asconf_param(struct sctp_association *asoc,
 		if (!peer)
 			return SCTP_ERROR_DNS_FAILED;
 
-		/* Don't free asconf->transport; a later wildcard DEL-IP
-		 * parameter reuses it.
-		 */
-		if (peer == asconf->transport)
-			return SCTP_ERROR_REQ_REFUSED;
-
 		sctp_assoc_rm_peer(asoc, peer);
+		if (asconf->transport == peer)
+			asconf->transport = asoc->peer.primary_path;
 		break;
 	case SCTP_PARAM_SET_PRIMARY:
 		/* ADDIP Section 4.2.4
