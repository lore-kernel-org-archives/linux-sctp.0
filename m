Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.227.135
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795762227;
	b=3md8EhB7HXc0QmjAcmCM/hDBdjmYunaCxezDFol2DTmULesr7C/kIjRpuPFTvqezAeD7
	 1FH/Od/9aem4nrGRqQaP2zxIu7F+mw+b3M12kzlGxh75thj3WPXiNWlvEHGUFMTyirjh1
	 3WPNOfX+AgXOn+BYA2bpPmBFw5EnQTkyrMFK3QgjNKmySu9Qz7mGhfok0CpsF0WNNlPA1
	 Ue39mICKKr0G50+O/VcxZUtHo8IdIf3qnhqcQJjiPucdXTlVIZytu2wVhkJybb8MrgwHH
	 i7VvVkqgthjbYn+Kqa+0i8/wC8muTGJLVTR92vFwpHO8zDitxCyDhDMHAj1enEFfBOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795762227;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=zkI3ZaCVO6DFWoIiiuuohl1A00TTUY+rHg5pk5A5ReM=;
	b=N3a9Atd4ywL3A7s8++iLLslN1xZIxjf21n/QkMD9HPSet7O3gOrBbJC7XAQf55kDbNPM
	 AxqqXIk0pYEV1EaqOUFFnPhLnl5QVJnCyhGYvuAgZuhtwfvDSa//grqvFSIS/SV0qzlvg
	 cIXYklvfbDJAO+o7pNKi7T4wLixpgXfBCgQBl9J6g5C6NBLcpXOV4+4TwEPq3HQjZuxHp
	 cpX1nlJQh+lauxkwmK0HJpE7RWNnXM1q1B8+B1JxNcZ7SccC1oAj3oplT9ovxvLg+EGsj
	 0CGhbPUQuPfgyKpE19wxTowvuqhB4OSfVE/Ivpaft1YHGPTaaGx36iEPwCdvO4SJVKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=N25xEqkv;
	arc=none smtp.remote-ip=74.125.227.135
Received: from mail-pj2-f7.google.com (mail-pj2-f7.google.com [74.125.227.135])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1E60606A321
	for <linux-sctp@vger.kernel.org>; Fri, 27 Nov 2026 06:50:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B1E60606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=N25xEqkv
Received: by mail-pj2-f7.google.com with SMTP id 98e67ed59e1d1-3b4be95e0afso2302798a91.1
        for <linux-sctp@vger.kernel.org>; Thu, 26 Nov 2026 22:50:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795762226; x=1796367026; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=zkI3ZaCVO6DFWoIiiuuohl1A00TTUY+rHg5pk5A5ReM=;
        b=N25xEqkv5pbmWpcUYO6PxJmIBAx0vL2XhBDLVkL/YevQdZaDsWIB7SomQ43Y1NP4np
         /ncFFwDk+/4rx+47PjGUHKBCG1F2yjNmYsSF07iVz2ZvRkjN2VcR0iQBPyHFMwmD+Esl
         0HEtj8HXHYPGI7wRHBmG820O7YXrZCb8SLFA/1DoekGvX/Ue9xJK4/+ztcrm3krQjJVz
         yM8CIxHEnVE0pJ5M17Sijlg/29qr1EMj7HSQLyAOOlvPGR9aSLb7Zr83QMLPW58w3Y9S
         trstm9drg+JkEQLJ/Lph/1iQwJnUU8BLd+cdtoA7jTc57CofSrO6fVnygCVTVHwz5Lmy
         2SZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795762226; x=1796367026;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zkI3ZaCVO6DFWoIiiuuohl1A00TTUY+rHg5pk5A5ReM=;
        b=x89WqA//VAFMgbettYIKBzz9gJE4S7czKLWQq1cKK2ZavgZQ2ZkOryHub5XHij/B5n
         In5/JSJcrdjStqDn144um6KUc2WmlePAgX+LKWfuGRUxYfVnJCKM1sTSgkR5GFDyi3ni
         oT2JxdI6y1BOm2lge/epiPIr0O7mES0a2w9S8YSvhbTyggtc9Wx6+hcGDl38zWl6uJ/p
         I3V/xCAeYOhwQJ8zq7flS3vyC7effIH9mLfP4Hs6SIEWJpAO+eu456/4vm6DJimbE4Q0
         CFpXxTEjhPFI20SXmCPYcLN0cyyv7esrpc6xloVkExX8gP7ZhfR4w5SWa7amePfQIVGk
         7TAQ==
X-Gm-Message-State: APuU4Z/EOZXt51svErbahxoZHYj/F0GOgZ8v5QznzVu+Dm/OtR7TBZ0L
	gppYAEJHaRRZhP9hfzgnC9JCobHdWrCqsXk2XT7Fz/1CtEko1bj9WlSX
X-Gm-Gg: AZFdTZcvUS/ra4jWCWgPVjus+mvvEE8eJfs5rVDqWuTwDfHJPeB4diz1pmul57de1Hb
	7xpmS82JQQDFiufKJF28ApvNRMNTkdK3+2k6C1TU94jdy/7afsINDzSeciwtOHN8NjtSSWTUa6P
	FNqZHI+9uWJcMYwQSzWauh7vx/DDfeTtnHY6yHQ4C3ijkmdeDuLCJU+I4STP88ZYwKWNWFsj97G
	VIsG59m0lMPw1WuQ6iTVUrbiD0TOQYjCI+ZzCKdTtyIhffidLCxgC6faj+NlxqFenZ3TfGp2r8h
	UatjzLKCleOWJqzu3qNFIQXjBDeRZ4J5ga3p7KvBuIn6B5kFNaVcpj8CFpIpH0ZK9vaJ60VDWqy
	h+6uYZtF/iDbcRpa1rXFdunQpVIPxJARTXJYkQZnLAsyfGTxa84cQhsmO8I4Np6Iv0qeCyzTZG8
	/3dwkNfqCHDHM3Nyuv56XpOvi1vn3cZ219nS9mIDiZ6Yqito0WR99//7gKUlusCbkdiW7Gm2BOH
	DIP8wt5wEEqbAw1LDzEj0+sYyDpyv4HEWN80zA4Nehy7RkDS07Rr1MWmZtbfJ2rggqvuuSlSWMA
	3+8MxS4OTmV2M0ngJk2FSMa9JjUM9YiDTMHr4ocz9wEXuGj7x9pyuUOVRN47xy/Hdli7Vfz7IAi
	J
X-Received: by 2002:a17:90a:e705:b0:3a0:9640:803a with SMTP id 98e67ed59e1d1-3b41c7e118emr23007990a91.5.1795762226024;
        Thu, 26 Nov 2026 22:50:26 -0800 (PST)
Received: from BSDHENRYMA-PC1.localdomain ([43.132.141.11])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b405d96bd3sm39498980a91.12.2026.11.26.22.50.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 22:50:25 -0800 (PST)
From: Henry Martin <bsdhenrymartin@gmail.com>
To: Xin Long <lucien.xin@gmail.com>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Vlad Yasevich <vladislav.yasevich@hp.com>,
	"David S . Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Simon Horman <horms@kernel.org>
Cc: linux-sctp@vger.kernel.org,
	netdev@vger.kernel.org,
	Henry Martin <bsdhenrymartin@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH net] sctp: don't count pending-deleted addresses as survivors on bindx del
Date: Fri, 27 Nov 2026 14:50:17 +0800
Message-ID: <20261127065017.2922776-1-bsdhenrymartin@gmail.com>
X-Mailer: git-send-email 2.53.0
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

sctp_send_asconf_del_ip() uses sctp_find_unmatch_addr() to make sure a
bindx delete keeps at least one address in the association.  The lookup
counts entries that are already marked SCTP_ADDR_DEL by a previous
delete request as survivors.  With a peer that holds back the ASCONF
acks, two sequential bindx deletes each pass the check while together
marking every address for deletion.  Once the peer acks both deletes,
the association's address list is empty.

An empty address list breaks its consumers.  SCTP diag reads the list
head as an address and returns 16 bytes of association memory in
idiag_src.  A following bindx add builds an ASCONF from a bogus address
taken from the empty list head, whose address family matches no sctp_af,
and dereferences a NULL af pointer.

e.g. on mainline v7.4-rc4 (KASAN build):

 Oops: general protection fault (non-canonical 0xdffffc000000000b)
 KASAN: null-ptr-deref in range [0x0000000000000058-0x000000000000005f]
 CPU: 1 UID: 1000 PID: 81 Comm: poc-crash Not tainted 7.4.0-rc4 #1
 RIP: 0010:sctp_make_asconf+0xd9/0x280
 Call Trace:
  sctp_make_asconf_update_ip+0x243/0x540
  sctp_send_asconf_add_ip+0x366/0xc90
  sctp_setsockopt+0x1986/0x9410
  do_sock_setsockopt+0xb2/0x160
  __sys_setsockopt+0xdd/0x140

An address that is already being deleted cannot serve as the remaining
address, so skip SCTP_ADDR_DEL entries in the survivor lookup.  The
existing keep-last handling then holds the final address back, same as
it already does for a single-address delete.

This issue was discovered by Tencent CodeBuddy Security.

Cc: stable@vger.kernel.org
Fixes: f57d96b2e92d ("[SCTP]: Change use_as_src into a full address state")
Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
---
 net/sctp/bind_addr.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/sctp/bind_addr.c b/net/sctp/bind_addr.c
index 31737f144c7f0..e20006b9f12e4 100644
--- a/net/sctp/bind_addr.c
+++ b/net/sctp/bind_addr.c
@@ -445,6 +445,12 @@ union sctp_addr *sctp_find_unmatch_addr(struct sctp_bind_addr	*bp,
 	 * can't change.
 	 */
 	list_for_each_entry(laddr, &bp->address_list, list) {
+		/* An address already being deleted cannot serve as the
+		 * one remaining address.
+		 */
+		if (laddr->state == SCTP_ADDR_DEL)
+			continue;
+
 		addr_buf = (union sctp_addr *)addrs;
 		for (i = 0; i < addrcnt; i++) {
 			addr = addr_buf;
-- 
2.39.5

