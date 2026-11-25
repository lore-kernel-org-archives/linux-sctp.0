Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795574216;
	b=ZjJ+KBMpSpaImkDKkr97ihCSrgVczdUoeZmPqv3kxFi4O2fObaZKzk5MOxxpr5qpsH0Y
	 LIFLtkuinRtmnuYjysSG7qGyYBKkZJn8FDwfzSy25FWs4JnbZVENw9vKQoTtGqcuox1mt
	 OMyGWK18ADz+kP30c7WaxKeZmcMrPQiMAvr1IFm4iU0TZyY8xArV807z0Y4VLupKO6wy5
	 QQKikfxDpZCOL+taPiYsnlH4rrZyrOQUku/2qPzYvRDLUeRuiCHX62uJefw4SesISS8KC
	 oizRNO+SBR3SvIjjN+bJI6OEHl0apykZZhXSvCvm0+3tNxHhvqzc6tkRdixYAmEzjxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795574216;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:MIME-Version:
	 Content-Transfer-Encoding;
	bh=vWY5PUY4KfOiqJ2qOGPYj99Y/AHpB1RWqszHGNr+0xo=;
	b=khLs23aTmLkzeJ0ds3U20cpxr5tg1VsWCvsyA52YCvL8dsarWhrLCnZKjqv3KQJ0hcLL
	 gPFUEXnH3lM5Cr2a97bGU6Dq7Y+oIQOuVOuT1Yqqb1dBO1Z6hgcsP1mOKj/zlaUh2aPRs
	 zKk20D/6Bz/J/gTtXWaocByoPitaZmIIphLj0wI68rBgIQXYA8xuSEK++uXP4gf879iep
	 Rjgzt1MyO30pci3Gl0kXNcARMQosj0pNP21HoXwiQkSKz8i3q4OOi8ehSGMnhSeSYl7uN
	 oYbAitPahEvUhHSE13muHqz+OzzUGZdneZ+Jg1sGuWvfi1/6ocTHCT7ApEFRBKxdGLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=xKQHalZd;
	arc=none smtp.remote-ip=209.85.210.171
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1FF6606A327
	for <linux-sctp@vger.kernel.org>; Wed, 25 Nov 2026 02:36:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A1FF6606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=xKQHalZd
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-8b4c8b51b58so3007309b3a.1
        for <linux-sctp@vger.kernel.org>; Tue, 24 Nov 2026 18:36:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795574214; x=1796179014; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=vWY5PUY4KfOiqJ2qOGPYj99Y/AHpB1RWqszHGNr+0xo=;
        b=xKQHalZdJ6ZNynwBxhbPZ6v28J2vCpSQO3QiW4t+lfKxVlX9KVl2WbGmreLmh2JH5L
         yOLZWCcs6cwkBoL3BTi38iPcu2Gvvyf7Y8rEDkuRi/bBR69kN5pyqlVt1GlUpwWpmcjJ
         q5BKzgU+5n9SIzymPO74CwL+u7H3z8e3IwsYl5qUtpgevklwVvZlfxOzF3Yypat/GqZu
         5O8p/L65VcIdpL2h7Wy0Qqxtx+ki7HPPAA9gr6/mhNE+IT959YaUvgjfKZLokTgLaR2A
         NLMCL/ecSevMhzGK83W0bCxjlrgkr4dcnKdML0M16vdJ3WLCXn15qHsTAUxDVR8zwcDM
         pz7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795574214; x=1796179014;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vWY5PUY4KfOiqJ2qOGPYj99Y/AHpB1RWqszHGNr+0xo=;
        b=m6cCo0opohLiPAfBMSa7NqEeeuHvVkD0KLTIcNo4n3+wavK3aCXZ3AxA6ucSsMtJue
         uIp5aaUEGF7E+oF65kS+SWkvnJvzhpBuw/u2uQd10FXkjgGqbiuCw7KTD/wnVPRHGohU
         Naq0saC/keSWyNo9vzLk8TO6lS4LXM29krxg+Pmniq6cOaMUB5n4hAlwMp3uwZc1Itqn
         dbWyBwUzAyfdsDlZJZlXiO7p9ZMIkRWy3MM70XDJaa5apDBn9UXix9SPl7QbCowIObNQ
         23efq4iGybYc1k7hEQMfsmD1KwKzKma6y4FaWaLuNE3XZTjO/UxtUrboSE59EZNPndgC
         4p3Q==
X-Forwarded-Encrypted: i=1; AL+hErElH227FvxXPNCRKBx0Oha9yj9PxmDnOSbyHpWq5rUsUtF6mpqNtfoLEVNLzkHHaT/fpnl26e6izcMS@vger.kernel.org
X-Gm-Message-State: APuU4Z8iLAg86T/KyJJ3Xna4TU+R1Fb1+NGyRWj3sp77O5rlAoFRb6Ej
	nfF+rp6lKo/oEMhvTa1C50Ij9xHs2TQjsHPaqXGN0dibBZRnO6W6zelo
X-Gm-Gg: AZFdTZeWNmZ2AhCVlagZ4w6y7P1m+jBaJRjOT7SS8sYDGk8WcqU+mv+DDB+RV0non9d
	anVjUz/aWil+EaclS+S60nKGlUB35hINp6N/as5Fg2tg5+B9ZbIphymXr/QXFhDYwq+AVWFJ9KM
	/tUDlIcbXN3gfngAlD4DwcH7Zv3pCn0BqzvQvOnib88DX4Um+uB1kkE+caFC9CYeOClRLe83grZ
	vynqACFWV+5FkT+2HpKLBiy941MTCM0WrYttIgZAGE9SuejEjN2Wp3+HPZKcrq3GbslgYlUOXEz
	nDf1fNigJXNYw2L2uAOXLHeLBvI4zDfguBfMya3vdS0zAFbP69qUcqRwNwSDL7+H/70qujDb7yU
	wOrHq8n2L7XTHc+WUKvCMSa4SqrHYKcziTmY2ZVvOb0Hr5pIiTUNB8chpgDHkOhrPoAFTAbqUk8
	3u/uXl8imnGPaHq3K04yA442KBe7cmSc6Q6ok05oX4YRNtpNacTwJKcqwrn99QG4oPJUcL04g8x
	BEqBqxfztoH/Xcqi863A1txtaZ7pI2v8lxA0NkN87/NoPDDfGJF86L4ElMGiQJ9K7W/QQuSMUG+
	0a/PSrluDz7KQcgU8rAMEnEuTLgwT8mqKFPxIXITDJtMByo/WsFtiaMvJxrhpAlz0A8=
X-Received: by 2002:a05:6a20:a126:b0:3e2:7a05:6bda with SMTP id adf61e73a8af0-4014d963fe0mr18125416637.43.1795574214549;
        Tue, 24 Nov 2026 18:36:54 -0800 (PST)
Received: from d20be28ee783.tail196be.ts.net (vldb.skku.ac.kr. [115.145.173.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c908a56acfsm7294885b3a.23.2026.11.24.18.36.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 18:36:54 -0800 (PST)
From: Kyuwon Cho <kyuwoncho18@gmail.com>
To: Xin Long <lucien.xin@gmail.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Willem de Bruijn <willemb@google.com>,
	Jun Yang <junvyyang@tencent.com>,
	linux-sctp@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net v4 0/1] sctp: fail the association when the INIT-ACK cannot be processed
Date: Wed, 25 Nov 2026 11:36:49 +0900
Message-ID: <cover.1795572890.git.kyuwoncho18@gmail.com>
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

From: ChoKyuWon <kyuwoncho18@gmail.com>

When processing an INIT-ACK fails, the association stays AUTH capable
with a NULL association key, and close() with SO_LINGER {1, 0} then
takes a reference on that NULL key. As Xin suggested, the patch
processes the INIT-ACK and sets up the key directly in
sctp_sf_do_5_1C_ack() and aborts the association if either step fails.

The issue was found by an LLM-guided test generator that we are
developing as a research prototype.

v4:
- Free err_chunk and abort with sctp_stop_t1_and_abort() on both
  failure paths, which also sets sk_err and counts the abort (Xin, and
  the Sashiko review).
- Say in the commit message that an INIT-ACK from a peer that is ASCONF
  capable but not AUTH capable now aborts the association at once too.
v3: https://lore.kernel.org/netdev/179539544818.3016044.13738712075053349592@gmail.com/
- Pass the error to SCTP_CMD_INIT_FAILED with SCTP_PERR(), like the
  other callers; SCTP_U16() made sparse warn about the __be16 value
  (netdev CI).
v2: https://lore.kernel.org/netdev/179514851805.604157.8527055700821138420@gmail.com/
- Process the INIT-ACK in sctp_sf_do_5_1C_ack() as Xin suggested,
  instead of skipping AUTH in sctp_auth_send_cid(), and remove
  SCTP_CMD_PEER_INIT and SCTP_CMD_ASSOC_SHKEY.
v1: https://lore.kernel.org/netdev/179505710266.3511678.14017674052424733262@gmail.com/

The patch was written with LLM assistance; we reviewed and tested it.
With it, the reproducer from v1 no longer triggers the report.

Kyuwon Cho (1):
  sctp: fail the association when the INIT-ACK cannot be processed

 net/sctp/sm_statefuns.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

-- 
2.43.0

