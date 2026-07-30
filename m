Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC31A3769F5
	for <linux-sctp@vger.kernel.org>; Thu, 30 Jul 2026 02:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785378803; cv=none; b=qZT7iySC0yt1coYpVIfcTt+zMRsWhP5e9a7jRTpXcBuRTPSi1HEjIt+5tuop2ulpdfj/yLWug4vvf+WUddfnD8vHfFDBejV+USCROrKFzJw5iFOeB0cTXQQw51udVnq73LoByA1sTp3hF7vjx8Zs9DHNNvCxWk0fYAWVufGDyYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785378803; c=relaxed/simple;
	bh=Iwuc5U7WKBARUra/t58c0cg7GS28SQYw+Sv3GNlpazA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=R5001s3OTFKF307O+qCT/CzFHM6C9C7MxCpGVkvWYFXKkeMjZRl1P36FzffJBMFuGPg1K/BpFj9ATYRmQ91Nv9m2+R/Goj9dhyO4wa8X/99U1w6+o0Z59g1lNXKyjFcYpuGzAiw9tG0TEp8X4pbEADvvqZ2OzSgw/CPMEj3DWpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f72tui43; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f72tui43"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-84a2dcede83so2187916b3a.3
        for <linux-sctp@vger.kernel.org>; Wed, 29 Jul 2026 19:33:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785378801; x=1785983601; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=GFQEZHCieGUxsn8s5z6wQ2LAPE8dpKhgSk8OBI83lDY=;
        b=f72tui43FmpwdjvBsOGZUJzIa2/++in76kjn486BW8vMrizSYgvaVnggRbNq+Jhkg+
         heAPVKXYalqWjzYgfDOJ09GMrWqPLbebkScjfVjLLPtqfDMQB6FjbxLTmQadAKeJBcL3
         cZGiDdCF87XQsLVCJTZ5Wb6oMHmtgLYWCU0h31vhiV6DWd1iutTNLShv3snCWQyzX+rU
         Eoelh/cDFPTnMIGsywfXU9nwG5a+erLYAgkk2lT6862g08rGzM4rT4cCEMFLJWIcdJIe
         KTP7MtQjQqjhsLLuQBai79Fm1Xd7J4Lq5Ei1N3CCoKo4sFNprGjpaklizIKzLnIw2AJK
         GBpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785378801; x=1785983601;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GFQEZHCieGUxsn8s5z6wQ2LAPE8dpKhgSk8OBI83lDY=;
        b=ALaFpgFkWe1RRJiA8ifuIbHTjYluG2IDjPfHM8r+xXXUTNv+pSVs3h8h75jH18zFMD
         JeFkAUpwNjOheeTl1EXa4l/oFpdLeDe07YRSUHh1+9yGv+VhRrLXynzhSLspGCLROVYZ
         VZyvRmOwUO2ALL4t6Pg1tzGPg3dedAwkSD67zaiO4p4EU1ZAqJ5ylGxDq/GvmRgPsPQh
         +sNHIxnKKpcHGN7i0AOBUjVq6nvSMttBUcRD/F6HHAAPmM93e7b1u3cAJgJ6FphRzg8F
         Y3o3v/VP7hH3SIVAjGcKCs3ZAkpv3kyk0WXFZTbkT10BNxPPD+6P4pTOzsoq0tMtyfGc
         7pNA==
X-Forwarded-Encrypted: i=1; AHgh+Rq4MeQKHAGWmsTeXT8RXz17/DPKmvZOU+2Pf/yI7Sv7MdOtRVo6iK9zJJJ+jU9DKZ6MlhpmaboZ0QD8@vger.kernel.org
X-Gm-Message-State: AOJu0YwjTSdeh5c9ylZyGzaXJvZOVjbxrUPURYXUjKm3o0H0EHfp4+11
	3TodIeesyvlEQYEW6MYZEn44JfrEV9ZCbQ4Qqh4KiyTpyOhk19Lf6yawMWEXaQ==
X-Gm-Gg: AR+sD11z3dIbxoRMX0RsIFFdtQTM5Ks0kdbDSDjs78MqKrg+m5ATFOBgm/3/xbT+jTN
	l/dStrvaBlj7SQt1rLeOZ8osc69S5mEDHFO9Ko6tSY7mEaCxjKvjBv9SkQmrSgJXpEU/GjqH+Lh
	o5iFbIaJ/b1EzvlWiO0YLbpsjZnAarVpVeEllXMUuuPWYsjaTMz5YpUunWMIhHE0HEmWlCl5T6A
	SNVcpz4Em4MW365ayMy0T2sZZdMznitM0W3wCnSqJj95Vt3rVrNQLLQ76akTAXwaew3yyFYHAy4
	u5DwIOkhFmlXqpW+GmmDOnVqG6fZs3aZ7PKVcAvgxE2w/OrEThD2DETvry2MKy0Dwzvetk0sKm8
	AxRYlV4uXngCow1hS1aiqP6+wyhSTE+7PUsww4NzlABR0W/5YqZ4udoHBxiPRGB7XccWPbFfeSI
	awVeWFU9noyMLL4dqESb/N7tKd6c04ZLgiQxP+eiiC2xbSAICdnUY+wR41101getCxmbJMNBdB4
	V5EPtij69yE
X-Received: by 2002:a05:6a00:414a:b0:848:5540:2377 with SMTP id d2e1a72fcca58-84ebc24e899mr865101b3a.17.1785378800736;
        Wed, 29 Jul 2026 19:33:20 -0700 (PDT)
Received: from localhost.localdomain ([47.246.98.83])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e9fe2153csm2179348b3a.3.2026.07.29.19.33.17
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 29 Jul 2026 19:33:19 -0700 (PDT)
From: MingXuan <omeux327@gmail.com>
To: marcelo.leitner@gmail.com
Cc: lucien.xin@gmail.com,
	linux-sctp@vger.kernel.org,
	netdev@vger.kernel.org,
	MingXuan <omeux327@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v2] sctp: diag: fix uninitialized stack leak via INET_DIAG_LOCALS/PEERS
Date: Thu, 30 Jul 2026 10:33:09 +0800
Message-ID: <20260730023309.21654-1-omeux327@gmail.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

inet_diag_msg_sctpladdrs_fill() copies sizeof(union sctp_addr) (28 bytes,
the size of sockaddr_in6) from each sctp_sockaddr_entry.a into the netlink
INET_DIAG_LOCALS attribute and then only zeroes the bytes from offset 28 to
sizeof(sockaddr_storage).  The same pattern is used by
inet_diag_msg_sctpaddrs_fill() for INET_DIAG_PEERS.

The IPv4 address-filling helpers sctp_v4_from_addr_param() and
sctp_v4_from_skb() only initialize the sockaddr_in portion (16 bytes) of the
union sctp_addr; the trailing 12 bytes (offset 16..27, the sockaddr_in6-only
region) are left uninitialized.  Those bytes are propagated verbatim through
sctp_add_bind_addr() (which copies sizeof(union sctp_addr)=28 bytes) and then
copied straight to userspace by the diag fill functions, leaking 12 bytes of
kernel stack residue per local/peer address to any process that can issue a
SOCK_DIAG_BY_FAMILY dump for IPPROTO_SCTP.

Fix it by computing the actually-initialized length of the address from its
sa_family (struct sockaddr_in for AF_INET, the whole union otherwise) and
copying only that many bytes into an already-zeroed sockaddr_storage slot, so
the uninitialized tail is never read and never reaches userspace.

Fixes: 8f840e47f190 ("sctp: add the sctp_diag.c file")
Cc: stable@vger.kernel.org
Signed-off-by: MingXuan <omeux327@gmail.com>
Acked-by: Xin Long <lucien.xin@gmail.com>
---
Changes in v2 (per review feedback on v1):
  - trim the Fixes: commit hash to the recommended abbreviated form (12 chars)
  - rename the introduced local from addr_len to copy_len so it does not
    collide with the existing addrlen (slot stride) in the same scope

No semantic change relative to v1; Xin Long's Acked-by is carried forward.

 net/sctp/diag.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/net/sctp/diag.c b/net/sctp/diag.c
index d758f5c3e06e..12557e924cc2 100644
--- a/net/sctp/diag.c
+++ b/net/sctp/diag.c
@@ -85,8 +85,12 @@ static int inet_diag_msg_sctpladdrs_fill(struct sk_buff *skb,
 	info = nla_data(attr);
 	rcu_read_lock();
 	list_for_each_entry_rcu(laddr, address_list, list) {
-		memcpy(info, &laddr->a, sizeof(laddr->a));
-		memset(info + sizeof(laddr->a), 0, addrlen - sizeof(laddr->a));
+		size_t copy_len = laddr->a.sa.sa_family == AF_INET ?
+				  sizeof(struct sockaddr_in) :
+				  sizeof(struct sockaddr_in6);
+
+		memset(info, 0, addrlen);
+		memcpy(info, &laddr->a, copy_len);
 		info += addrlen;
 
 		if (!--addrcnt)
@@ -113,9 +117,12 @@ static int inet_diag_msg_sctpaddrs_fill(struct sk_buff *skb,
 	info = nla_data(attr);
 	list_for_each_entry(from, &asoc->peer.transport_addr_list,
 			    transports) {
-		memcpy(info, &from->ipaddr, sizeof(from->ipaddr));
-		memset(info + sizeof(from->ipaddr), 0,
-		       addrlen - sizeof(from->ipaddr));
+		size_t copy_len = from->ipaddr.sa.sa_family == AF_INET ?
+				  sizeof(struct sockaddr_in) :
+				  sizeof(struct sockaddr_in6);
+
+		memset(info, 0, addrlen);
+		memcpy(info, &from->ipaddr, copy_len);
 		info += addrlen;
 	}
 
-- 
2.50.1 (Apple Git-155)

