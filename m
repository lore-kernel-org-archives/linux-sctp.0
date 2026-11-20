Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=54.207.19.206
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795151045;
	b=pIg9K/d87xPQF3sMmssk1Oqldc3o0bT+vALrUyLIy/nubeGui1XLP3m4Xyf0ogAfuL8L
	 VCmGWipRXDrc/BVixj2aAv5pNI70KXdGWe678lDoUKQEzyTVDf3jfc758q4RZ67Kk/UvY
	 NU4ERZL2DSWNr2WJKrODakMtgC2E3zMHXyE1GE6B+UVV7jmqLYqaIM+Xr8OsxUr2QVrgG
	 bkY0EzrFWy+IiyWev/V7g0VCG47TG6EEz2eZO+0IkskWCgqMQv44eNf2oWpSrazfEicdS
	 2YIPiEjJm9CCk02/x8S9vBtwRHofTTtKevE/hV1KwzVYjjWwZfoCSQTJBB4NwX5yzLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795151045;
	h=DMARC-Filter:DKIM-Signature:X-QQ-mid:X-QQ-Originating-IP:Received:
	 X-QQ-SSF:X-QQ-GoodBg:X-BIZMAIL-ID:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding:X-QQ-SENDSIZE:
	 Feedback-ID:X-QQ-XMAILINFO:X-QQ-XMRINFO:X-QQ-RECHKSPAM;
	bh=JG2GQZF9OFBITES8znzV7SWl9mp648C4uR4ZeUQZ65A=;
	b=0vINsWR7ffLmQtM1l/md12IEAUSyYg2r0+slcZ5PKH0HkEoIlPJQ987pJl77XMpHjHUg
	 HB6nYjtpwLRk/KQ1ZRMbDMTls/e9y6Ppzx51/m6Sl6d3wffkt4V8cmKI2L7AqjosHkE2y
	 0nMuugeZB0NJPHU+Rv77YtYQwFUCEEhb8LZcl3OolpknAXDRR6hoic0ErR4p0Ld4QdRIC
	 Oc4uUVkVrB38uVLqaby1/ATZ3wygBooRPqJZwTNGeWOBoelBbJg+8M+AzpS/tmF7P1t4h
	 Ca2EPy9BrydHjYEJDFDB2A3aXoDL9xANEtAHyA3sfqCIbY83CxtBq67bUQwp1Rx1m2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=uniontech.com;
	spf=pass smtp.mailfrom=uniontech.com;
	dkim=pass header.d=uniontech.com header.i=@uniontech.com header.a=rsa-sha256 header.s=onoh2408 header.b=imxmy7l1;
	arc=none smtp.remote-ip=54.207.19.206
Received: from smtpbgbr1.qq.com (smtpbgbr1.qq.com [54.207.19.206])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A851606A320;
	Fri, 20 Nov 2026 05:04:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4A851606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.a=rsa-sha256 header.s=onoh2408 header.b=imxmy7l1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1795150901;
	bh=JG2GQZF9OFBITES8znzV7SWl9mp648C4uR4ZeUQZ65A=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=imxmy7l1O3p/P8zOUhQQk9JuuMbN3xRIkb+45V4AGsSFXt85eGDaZJy9T7fSjP4Qp
	 trfpjAQwM6VNgI+PGhHBhKM0cbBWEQegjJiU8SBGPkIMInXyWacKaKBeBda/VmDFS2
	 kq7KuklvyWl7geef20tCToz3OzcnOtG4aGQCt59E=
X-QQ-mid: esmtpsz17t1795150893t7e35b75a
X-QQ-Originating-IP: m6YYTV9TGyutVeOW9D230iP91GhygKncnbNmAIWOIuI=
Received: from localhost.localdomain ( [1.202.39.170])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 20 Nov 2026 13:01:30 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 15613825989066999136
From: Xue Haolin <xuehaolin@uniontech.com>
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Xin Long <lucien.xin@gmail.com>
Cc: "David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	linux-sctp@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH net] sctp: fix race between sctp_sendmsg free path and peeloff
Date: Fri, 20 Nov 2026 13:01:08 +0800
Message-Id: <20261120050108.426545-1-xuehaolin@uniontech.com>
X-Mailer: git-send-email 2.20.1
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
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz6b-0
X-QQ-XMAILINFO: NoS5wdqc5dY8G+zbEqRn5m+LMTinWX+CLhMYXdkLnFWHELO2FDEYeLzQ
	/xbqfs2YPLMI9Q2EkJSefV+aJzjAvJykWGS7mFLP7CCqdilf8eI1B2/EPH98ehkefJADjv6
	qM01rHG5g9dOBbcKLOvxe9XII/tu5orwLIpNwxMQ0pA88a17KyahGgzymLBvQa28IFSba/i
	TXmhI/R1s0Qw5mzGVneA3ixa2JUfIbONSyJbDpc6DKrmA+Qnr8bZnaAmMFXMMqC2tOCjfVX
	rnmDqOBI73PhOuCfV6VQbandD5gIZMTBD67UvsHGnlFYsyj2zdpcAuwHy3jzbRqzLRvHibL
	yjeG/BGojS6PXtdlDDfncADgLC8thQp5nouLv7wfcH16ZilUik3uH1MHT5SjrGylwdyxjre
	fpfIXwNXYs9JAR00+4hdqz1am8X8NOtL09s1A5ZYcFgV4zPoPxCc3r6EGxorcBmjzdelDLf
	Z6An5Dm9oNtwWc/0YcCdoO0BLxD2hVEX79P1X/oezs2f0+DgrFxQpgVXKxH0zI4Es9qnDj3
	YSUQg+dFlQO2ribnA+W25JFbF/+L3i+3qZOFX+NsLYpmdmBua1Ee1oKkuSd4/QGmUUy8Xl5
	6sfqiCBwzWp/9IBqV9XLj3aHbRF+XCTbPFsp2WAZDE2rcJ3IpO/348ZtZHDjxcTJvp+o28Z
	fIC6+xxaelk5VyJQ2zMV5rdxZpJWNIKJZgyfJ56bbgPCY5V02RorXuIKB5D7cadGWBfG6Vd
	2JLO9ukbwyKTRolx/F4iy9fzs14mXtIQTK+XRW4ktGdIeDK2OGm081lcwti0ImXhaCKkJag
	xuCLYo3qFl5NHElhrgTTAnfwi9k77khMznTDYdB2522wgfRMoSBVFshskANGBh+cmekGsNU
	YznODRMhu7I7VgYNWFLuDu8x4F6grAOfBlOnTtPbBKWmI/PT4eqyygOmVO6lXNpziKsUNuy
	izvzuatG+FzOCmYw83QIN05oZn+BS9dZKsSY+hpm4AU4QpbXhoo+iBzZnXi30mwH66AlqJw
	ow3vVVC2HTmq8NyZat6piaqhIoW/xKZzDL045R9g==
X-QQ-XMRINFO: OD9hHCdaPRBwH5bRRRw8tsiH4UAatJqXfg==
X-QQ-RECHKSPAM: 0

From: Haolin Xue <xuehaolin@uniontech.com>

sctp_sendmsg_to_asoc() may release the socket lock while waiting for
sndbuf space (sctp_wait_for_sndbuf) or connection establishment
(sctp_wait_for_connect).  During this window, another thread can peel
off the association to a new socket via getsockopt(SCTP_SOCKOPT_PEELOFF),
which migrates the association by setting asoc->base.sk to the new
socket and moving it to the new endpoint's association list.

When the waiting thread resumes, sctp_wait_for_sndbuf() detects the
migration (sk != asoc->base.sk) and returns -EPIPE.  However,
sctp_sendmsg() still calls sctp_association_free() on the migrated
association when err < 0 && err != -ESRCH && new.  This frees an
association that is now owned by the new socket, leading to a
use-after-free or double-free.

The connect-wait variant was fixed in commit f14fe6395a8b ("sctp: fix
race between sctp_wait_for_connect and peeloff") by adding the same
sk != asoc->base.sk check that sctp_wait_for_sndbuf already has.  This
patch applies the analogous fix on the caller side: guard the
sctp_association_free() call with asoc->base.sk == sk, and hold an
extra reference across the guard check so the association memory
remains valid even if the new socket is closed concurrently.

Note that the sndbuf variant of this window predates the connect
variant: the unguarded sctp_association_free() in the sendmsg error
path existed before the sctp_sendmsg_to_asoc() refactor, and the
sctp_wait_for_sndbuf() sk revalidation check was already present in
v4.14.  The Fixes tag targets the refactor commit because that is
where the current code structure (sendmsg calling sendmsg_to_asoc
which sleeps) was introduced; earlier kernels have the same race in
a slightly different code layout.

Discovered by manual code inspection, following the public report of
the SCTP local privilege escalation (Xint "NGINX2Root", 2026-11-18).
The issue was not triggered here and the fix has not been tested
against a reproducer; compile-tested only (make M=net/sctp).

Fixes: f84af33138a8 ("sctp: factor out sctp_sendmsg_to_asoc from sctp_sendmsg")
Cc: stable@vger.kernel.org
Signed-off-by: Haolin Xue <xuehaolin@uniontech.com>
---
 net/sctp/socket.c | 25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index b5a57f61ee6d..0039c54a55d6 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -2082,10 +2082,29 @@ static int sctp_sendmsg(struct sock *sk, struct msghdr *msg, size_t msg_len)
 	/* Update snd_info with the asoc */
 	sctp_sendmsg_update_sinfo(asoc, sinfo, &cmsgs);
 
-	/* Send msg to the asoc */
+	/* Send msg to the asoc.
+	 * Hold an extra reference for newly created associations so the
+	 * memory stays alive across the migration check below; see comment.
+	 */
+	if (new)
+		sctp_association_hold(asoc);
 	err = sctp_sendmsg_to_asoc(asoc, msg, msg_len, transport, sinfo);
-	if (err < 0 && err != -ESRCH && new)
-		sctp_association_free(asoc);
+	if (err < 0 && err != -ESRCH && new) {
+		/* sctp_sendmsg_to_asoc() may have released the socket lock
+		 * while waiting for sndbuf or connect, during which the newly
+		 * created association could have been peeled off to another
+		 * socket.  The hold above keeps the association memory alive
+		 * across this check.  If the association was migrated,
+		 * asoc->base.sk no longer matches @sk and the association is
+		 * now owned by the new socket; freeing it here would leave
+		 * the new socket referencing freed memory (use-after-free /
+		 * double-free).
+		 */
+		if (asoc->base.sk == sk)
+			sctp_association_free(asoc);
+	}
+	if (new)
+		sctp_association_put(asoc);
 
 out_unlock:
 	release_sock(sk);
-- 
2.43.0

