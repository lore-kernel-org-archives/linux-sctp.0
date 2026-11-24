Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795486890;
	b=ibMPH6Xiq010aQ03R3UMQIXQ9S0PBRr8MCrsM5GUXZ2x0pe6mEOnFf/optAmVVNbaOVe
	 zQ1EafRvKGvzBjskqEVAwsh3FvHlHNAui7YVmjpuP4QCe21qWxnDueoBsqLNXkraTgWSY
	 pcJbbZlP6IJXoV90ptrwisomtcSVE3EstJYI3gKOMLlk7KqSy6WocYCzYH+DpH6bYC9rO
	 cofsMG5cfgDr49znPqPVfodfHkUvmBG6XjiCtyhMd1ebip2GWrIRq7z7CVs6BAwltmzBt
	 5c3LXRe2t5JrWbArGpnO4L2shMRH1RhGLmcReY0lsQeqwbWs9lxhO7HYo/nwXuZCidQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795486890;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=S167o9uoutsfP2jut1Z47ahN/OtfjROuup7AudPgKbg=;
	b=p/IxsKASD9dO+3GQYzULSa/gafSVKuvvvkruOQ6QgZdPtn2Db0UeXZLUxc9KwAvA/r+g
	 GhrVEza0tdyXGBYnP9XEuHI/mmC85woWhT87hckrnEe40jaLb3qlBK0KSOT9OIKtJPNIV
	 8wPHKmD149zMAlEvBjsHL3yQt3WBRDimadMKAyzuySSHC0eQCXx8Af+UETUVPyopvTLRd
	 J8hAmFc8kRP3WLDod40DLTm24+FbqLmNXbJq/gaSHWSJfjl5iQk1Vxf7KJRAq4E0C/mQl
	 UrVCfmJ2CAmlj/uVcm7fAqCRDFYDjBBMXUuwOzNi9n8dxyQTL/fQ139QEUvvjaMv7vA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=LpZz9fFo;
	arc=none smtp.remote-ip=209.85.214.177
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95177606A321
	for <linux-sctp@vger.kernel.org>; Tue, 24 Nov 2026 02:21:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 95177606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=LpZz9fFo
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2f0a0d1a1e5so7578695ad.0
        for <linux-sctp@vger.kernel.org>; Mon, 23 Nov 2026 18:21:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795486890; x=1796091690; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=S167o9uoutsfP2jut1Z47ahN/OtfjROuup7AudPgKbg=;
        b=LpZz9fFoyKJtDc3WnHBrsmEvV1Pgqp5tX4/73EvjvaCXtckQ86HWu1lM4yKPOLSPyQ
         3Bs+OqDHcG4rghN6o+2neRpZD63e8a4GSmp/mNk8x/JJIGmuD3ddPikpZO7cLq1TUrFU
         +19rYkQxY0aG4B1JpwKD0QJ0cTOFBiuNDNManLol9/QJUqLnBpAb2+X9/kf7gS7SXDEe
         eiCE4aQTWJtXTPrus5OhWQieSbp8YtiYVYem01xsReDaLYaSwpcGEI3ZEJzyb0LFWfFd
         WU3jD7OMVfDokDSjW1E/dw9/lqsoeD4kQpyx1oSxxjYc2ora9ejnMWAHzCSNVjrKnerp
         brlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795486890; x=1796091690;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=S167o9uoutsfP2jut1Z47ahN/OtfjROuup7AudPgKbg=;
        b=WhsPcENVpn7nNzn4m1HW2aRSLzcbG0nTOr8AQ3zZgMmVySzgzcX0mDnjWK+wSx6omV
         aAIUIwVppCgQwDj48CqeSvfzQsQ1yCEHPyd4Dktn2beXZJDs3fqUVk1O1OQlcJBy6M+w
         H+fI/8Mcu9VZHQfFbHvy7RxOiRq8KyX7xIgvth2csWDbou86Y91keN5sxwt66dt5GMfW
         5sUA990bhb5BijRvPVOh6jDGhza/aSDl0wcrP39pbWN2VRhi4NIrbmK9PuwmzFYkwvei
         2obVobYhrHzexCrmUyRn3IBgMfkiYodtDSvkzhV79AokmDWlm7yj73vTzs3jVR8oCdZK
         C6gg==
X-Forwarded-Encrypted: i=1; AL+hErHSvtShrw1kGcETYdIwSiu0D9CoGisBS37ciBE85mJe9YcUbsV6AqftP4Sqqe5rS6NlG6Nee0d+TI+v@vger.kernel.org
X-Gm-Message-State: APuU4Z9ZENCCRjhIAqEoSjyJ2/vSAfmFLcnoPcYc6IqHHAoAWUqlL86v
	eakMFJEngnNqjLnHQLu6xc+WYtF6budV3PJ3ONmXwCZLVjnVHfIxwUr+
X-Gm-Gg: AZFdTZf9l5jHk1Xw9MWPIw5nzNujhHqQdnMPF0PjYQzCKKHXhIqIa27WohROaXchetF
	OSHfsLe6j29Hh4aMYSXlGicTF7DNaGxC67Zve1opRaSn/QA/LiLOCu2t/4EsZ2hHSVfC1n4UdRj
	QZFjOpPmdu5M4srZ1SJHdocqXsyzrkIkceEpD5JWyvfiDtfYo6WdpsD8amSmr8reMKdloNFbxwO
	+IaoHZXC4RovcRpJYUu31U24DoB6TFuboIm2BRYY0NMvBrGkYgiJ4VFxaD9diQM8TYiI2lKR3CP
	2ZzuubzrKKccP4d7zJalzxi+KUeMK3oXCq/ZEXsT3JM/WZWnLbk4UUS1fAJV9lEOxMw7CJDNeyY
	Ps7M91S3r0FjA4t9HxN0bongKJPI+USRxiEc2Ju+/g/ClaerzCeTYKqZ4uxGGojRZnK7228CaK0
	4lUsqgKWh2ZqTgGz22UUrLvsdCm90daFMQpGOd52V2KUuYQs6EjG+DSrJRKAcYtXsaYp+Y2sMq3
	nyoQzE3OUk11Q0DGsSN2J1UejCwAbi90mRpTPj5Up5cF5kdfrovekbB47IQY/Zphsi1vISbiOHC
	Rb7ugRLCJCReg7Wt/hHjEF5YYm8J9Ta02OXaf2TNbm72PRChuB1jVwPSxOszpHHOMPD/+mKIJA=
	=
X-Received: by 2002:a17:903:b0e:b0:2df:35f1:8771 with SMTP id d9443c01a7336-2f03f1e0d4amr128824035ad.54.1795486889807;
        Mon, 23 Nov 2026 18:21:29 -0800 (PST)
Received: from JIAPENGLIN-MC0.tencent.com ([43.132.141.21])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f0b7be3347sm7003095ad.15.2026.11.23.18.21.25
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 23 Nov 2026 18:21:29 -0800 (PST)
From: Lin Jiapeng <ljp1205831794@gmail.com>
To: marcelo.leitner@gmail.com,
	lucien.xin@gmail.com,
	davem@davemloft.net,
	edumazet@kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	vladislav.yasevich@hp.com,
	linux-sctp@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Lin Jiapeng <jiapenglin@tencent.com>,
	stable@vger.kernel.org,
	TencentOS Corvus AI <corvus@tencent.com>
Subject: [PATCH net v2] sctp: preserve the peer transport during INIT error cleanup
Date: Tue, 24 Nov 2026 10:21:00 +0800
Message-ID: <20261124022107.32283-1-ljp1205831794@gmail.com>
X-Mailer: git-send-email 2.55.0
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

From: Lin Jiapeng <jiapenglin@tencent.com>

sctp_process_init() removes non-ACTIVE peer transports when INIT processing
fails. The transport matching peer_addr may itself be UNCONFIRMED, because
sctp_assoc_add_peer() only promotes an existing UNKNOWN transport to
ACTIVE.

If no ACTIVE transport remains, the cleanup can remove the last transport.
sctp_assoc_rm_peer() then interprets the empty list head as a transport and
passes the invalid replacement to sctp_assoc_set_primary(). KASAN reports a
null-ptr-deref in sctp_ulpevent_notify_peer_addr_change() through
sctp_assoc_rm_peer() and sctp_process_init().

Keep the transport matching peer_addr while removing the other non-ACTIVE
transports. This preserves a valid replacement path without retaining an
arbitrary UNCONFIRMED address from failed INIT processing. On a live
COOKIE_WAIT association, T1-init remains armed and can continue using the
retained transport until association teardown. Successful INIT processing
is unchanged.

Fixes: add52379dde2 ("sctp: Fix oops when INIT-ACK indicates that peer doesn't support AUTH")
Cc: stable@vger.kernel.org
Reported-by: TencentOS Corvus AI <corvus@tencent.com>
Link: https://lore.kernel.org/netdev/20261112092114.12458-1-ljp1205831794@gmail.com/
Signed-off-by: Lin Jiapeng <jiapenglin@tencent.com>
---
v2:
- Keep the transport matching peer_addr instead of an arbitrary last
  transport, as suggested by Xin Long.
- Update the subject, cleanup comment, and commit message to describe the
  retained transport's use by a live COOKIE_WAIT association.

 net/sctp/sm_make_chunk.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 15c2d87575a8..65594eaaeacd 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -2525,10 +2525,14 @@ int sctp_process_init(struct sctp_association *asoc, struct sctp_chunk *chunk,
 	return 1;
 
 clean_up:
-	/* Release the transport structures. */
+	/*
+	 * Release non-ACTIVE transports except the one for peer_addr.
+	 * Keep it so sctp_assoc_rm_peer() always has a replacement path.
+	 */
 	list_for_each_safe(pos, temp, &asoc->peer.transport_addr_list) {
 		transport = list_entry(pos, struct sctp_transport, transports);
-		if (transport->state != SCTP_ACTIVE)
+		if (transport->state != SCTP_ACTIVE &&
+		    !sctp_cmp_addr_exact(&transport->ipaddr, peer_addr))
 			sctp_assoc_rm_peer(asoc, transport);
 	}
 

base-commit: 145480b28ca82e9fae789427cc4569e596515a32
-- 
2.55.0

