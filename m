Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793302504;
	b=ekhfSg8+PqldjjsX3e/xwOf3zx0Tx3xooFbVMK5hmo8LtaRF4CTZrJQGhKlp7ETYRENJ
	 FsvAZLSxVWp3jHU44acbhUFJRoct0LIxrPdVFWsKeCZS1fnF1X5rCH32iAYG7sBN1o7lP
	 NjinacJnI4tdsnz/lKqZ9Qia5UrOEUxwjyy7bTF4vjTEy2ZZHeKuSKVDDJ82H5UO3iE2h
	 E6y14M9Ik6jrVXxTXjdqkw49vpmQuo1zMnMZWckWerkGcuLKpdsJ3fkhdWDJdYfOgwsLt
	 R9TbReKRwSy1wiMT2ildKUIblgabvChqbDNim6tKQJINuIjcjiGHPMy9JgBAmlvM6dw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793302504;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=laioZ8N0OQR8oGU3jFarnfPkuthFm2r6CwyVihbfb8I=;
	b=rQXG1rYKrygPxzQbmMpZGTEaLTwS2MuKxuVMSkhVRbcwaBT3vdSW6NaONP5CN0N7K6nO
	 xX0rpTQIFyczFOfZqssrpOhaERcr1SXYNYeTgYNPS7LGjjX++zSdJQXttrnd6ES3XoTF2
	 gW5hy50sTBoYTLRyRbCO5jETLC12w+FzZc7Dk3rsz5gkJWGTgM8FbVkAxtw11hmT580AM
	 6NrfJo1FLA0Iyugn+C55rB9nWkQP8faphsM5+baBCIRe4CMKL9DLEpFMnCop4/lmFd/sk
	 Dw6tMcEkzMYbk8ax/Tbh4tX96/DHNqJuBkp0n61Md+pWhsFiTbtskUPJndSZ26jrf8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=xr4pNwCK;
	arc=none smtp.remote-ip=209.85.221.41
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 898DE606A33A
	for <linux-sctp@vger.kernel.org>; Thu, 29 Oct 2026 19:35:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 898DE606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=xr4pNwCK
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-48df54150dfso607f8f.0
        for <linux-sctp@vger.kernel.org>; Thu, 29 Oct 2026 12:35:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793302503; x=1793907303; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=laioZ8N0OQR8oGU3jFarnfPkuthFm2r6CwyVihbfb8I=;
        b=xr4pNwCKgYGulSw/az3ibQgRd3q7lIyi9gAtf0ESPFgOodSG05E/NuzpYrS9AdfFJq
         /3XnLbnR81g0VIcYmNAbug97vSIHtPJoNSreJGScZ+D6+n1Z78pDSeecZp0ARZ8yxZqH
         ySR0BaGEWVVQv+B6HqFTgKIAFx0ANskp4JqGTrj7rzVYeYttOkZ31xZduzyXAwfSW2ih
         XSzjfCh99ugHcJbRPc3X5AyaqtFh4YJ7y9RXQUp5EUjP9Bp8EhJEJ4z9p3eh6h2Zr399
         soNi82h30lyjo8knSvtarMORMcxjDxE8Fpywhu/VDW1XI8pwVNkPu1JITIMBxOj82+Ol
         dnew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793302503; x=1793907303;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=laioZ8N0OQR8oGU3jFarnfPkuthFm2r6CwyVihbfb8I=;
        b=veCDJ5kzx5irEqByvxNxr+G26mjYwFL/P3Ae2ALWHXgRAskuS9Tr4+sSlTIiEf/EEJ
         wEFoCct9o2y/a0WC/wwJoCcbqxDEPm3GTh8wci1a1zjAKPs0K15drFtOS+LdS6jj7Gby
         MhYSms+jII7gZlKEmOEkCMs/QIhXn8MdjZwZ5UGXALryzfodIXCuwJcZCHaxwCDgg917
         Nxh8zCm0YWjvowFX16aH19lAhX0M3MNMiT6vyv7iYAWR3myWveqNe1eBVJ4pOKaw1xKA
         Xw9Gjx1yS+yPl8Y0bAFgHmvX4Q9K2AXKINXnly5LoaWsSMthsEleLXmMoO3jq6P1OyWt
         0AXA==
X-Forwarded-Encrypted: i=1; AKwUvBxc/5SniddBOxXnd2ipLvYUQdpK4MlqPGp6MvIVl93FX+DHNQN5mhdURKdfvRFQtMx+Iyo4BNb8L4V7@vger.kernel.org
X-Gm-Message-State: AFq9FYLcZfi01dQeoIHWz4xL4RIkHgllmt78HnlfZbomCv/uSAWXDb1v
	I2aSUzhd6O/DEzhgno0Umtfa8Y07w2QdakzvpIIRXcrR3TkKalbMpiPr
X-Gm-Gg: AYBFou0JcJKbNVSiYYmhOy+LZtliQ9jloDvlmHSgcXFdvhjSwsuRF4qVriNJ/NMoa7u
	AxuAd70WeIQJV7EYwOKvsAFlgB4rzhNZRCLFQ/us+Lrkom4IINS4/ZQKirYNzJtG1wi6UhwLsp9
	GUyBIaF7YT4UYbB54u9VATW6IhvQXvZWgsVRLiS51TVXaOjWXlbzWTON+VYPFc+pMKsFWovM+Vr
	I5Cv8RGVV3lwsk3Hg9focdMiWtJ3d4laxcUXAj6JDNteaMIUWgKWwAzam4tMLeCS2vRFAByq4KS
	Ek8NTrSrDp6vSqCNj98t8zISQ5yUWyOJWWv0WEg48F8cguo5Iw9/jt3zTV0T6OlRW1I4mXLw8wA
	iLxVZip7wVXdCO5zRqJqr0BLlP6wmkp6kHrgETAV4PcG26j8+KREbDErd0LArdmRDMI++DJIG3w
	Xr/a1llUyknnmxRyubjTPdA4wxnTLNc81uvikdXq021Lk0//8H7KYUQAVjBKwowxZdzddvofnPU
	WhkjmJoBmCv8A7mCN7lEbqKe0fgDFqCLNCB8HBTQfUbaLAppB5tPAkKJMcd4rC1BO0unj7fQOD+
	zNrSByqEhQ8VfQWazd9JRNI/
X-Received: by 2002:a05:6000:250a:b0:48a:f073:336b with SMTP id ffacd0b85a97d-48e6e2fcd88mr842417f8f.23.1793302501851;
        Thu, 29 Oct 2026 12:35:01 -0700 (PDT)
Received: from dev1.kernelcare.com ([2a01:4f8:172:1c85::2])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e6eb81d48sm274585f8f.24.2026.10.29.12.34.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 12:35:00 -0700 (PDT)
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
	stable@vger.kernel.org,
	Andrey Misiurov <andrey.misyrov@gmail.com>
Subject: [PATCH net v2] sctp: fix ASCONF address change on single-homed hosts
Date: Thu, 29 Oct 2026 20:34:54 +0100
Message-ID: <20261029193454.1028626-1-andrey.misyrov@gmail.com>
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
source rather than reusing asconf->transport, and clear
asconf->transport when a plain DEL-IP removes it. The wildcard delete
can now free the old asconf->transport itself, so point it at the
surviving peer; otherwise a bundled chunk would reuse the freed
transport.

Found by manual code inspection while reviewing a backport of commit
9b2854f86f0b; reproduced on a two-namespace single-homed renumber.

Fixes: 9b2854f86f0b ("sctp: don't free the ASCONF's own transport in DEL-IP processing")
Cc: stable@vger.kernel.org
Signed-off-by: Andrey Misiurov <andrey.misyrov@gmail.com>
---
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
+			asconf->transport = NULL;
 		break;
 	case SCTP_PARAM_SET_PRIMARY:
 		/* ADDIP Section 4.2.4
