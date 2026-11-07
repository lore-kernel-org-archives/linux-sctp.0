Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.161.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794020736;
	b=peej4crp9FViYmW1dJb+YyIAw43F/3mqAWa2VwRtCS5pQ4rG0D/qSE/imxnn2d0K96yK
	 DNiHzOrT1pXzNkAhY6i5pq7Ou+CU2Z3zGn4+WfH0KVFDpo/pp0CvNBHhnuVZiWISZfPXJ
	 d1snBQUmKr8boNptO7BTCKCXOxM2To9c4fSz/3oeMKEe9YrzJLRW6pIO/q0GB9vB2tSys
	 i+ZdO6iCvc4ovb9cEgCR5LnS7ERKlXVUAw1+CayGec1yLsKTITLgtAUYvuCu98LJlraVT
	 wlszmhyMCAxaEMRRGKTzPKhOqn1uVremvccsGegHRWGtW45snRlFV/RLwKdTj4o1lkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794020736;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=rP1Yhc8V6RNptl8ZAiLhF4SuAftOJVbuJVVUglBaikU=;
	b=EEQc+ptgVpv67z04TKWcliHsJuhcd9YO3OthSbQS8Hrzv/3htw8ln4WayPz9XzqZM7kh
	 IKMjSmaZxwbe+LsE/U5vfYIq3nXkWWr2fEgMZOe1lYF5Ds2WAy7/QpXlYbOhJdbVOxA/D
	 obXzoIcYbj/HI+GcAnKkIGZcDOj5z1fD5KtR2rdwN+JcAZfi5coZatj0oJqizMdqj/KDA
	 nV8Fpa9CddVBoCbyBnt+rbK1YzKGddenSFaIK+q5X4pdeKfr3xcHyqvm0GcLhMavBjGZr
	 4lf70uWFKr5gFygtzb+5PY//yg4bTsf2mOxxbnT3QqCp/0n3hlIORaR4JIxjsQ7CwWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=openai.com;
	spf=pass smtp.mailfrom=openai.com;
	dkim=pass header.d=openai.com header.i=@openai.com header.a=rsa-sha256 header.s=google header.b=LnwVBnrF;
	arc=none smtp.remote-ip=209.85.161.54
Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com [209.85.161.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 461D3606A326
	for <linux-sctp@vger.kernel.org>; Sat,  7 Nov 2026 03:05:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 461D3606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=openai.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=openai.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=openai.com header.i=@openai.com header.a=rsa-sha256 header.s=google header.b=LnwVBnrF
Received: by mail-oo1-f54.google.com with SMTP id 006d021491bc7-6b8e2d8df4fso830691eaf.1
        for <linux-sctp@vger.kernel.org>; Fri, 06 Nov 2026 19:05:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openai.com; s=google; t=1794020735; x=1794625535; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=rP1Yhc8V6RNptl8ZAiLhF4SuAftOJVbuJVVUglBaikU=;
        b=LnwVBnrFVKd4RmmtwNpC5ZIpYUQ3jidty2bj9aG30X4RnNmPVWvtRXkubIjjaFev8e
         PaUNsCLZIbiMUMitEH3IpDfAiaxnytnUnwoYmJnQzGiYfREvafWZ/dSQ2hFI7mcgairU
         p8CuTzrpbPrrSbBINfVDKpwHDcX7tx4rBpBCI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794020735; x=1794625535;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rP1Yhc8V6RNptl8ZAiLhF4SuAftOJVbuJVVUglBaikU=;
        b=zcCkOn/6fnbGNorUfhrZt1yRkc5OsWcekazw75azz0s07GAqEeXtNwPLGs2eOFE62N
         5nyIqGPIv9+AugvQibp2RWeZoUeGM+oOdlZQzaO8rCjK9RM3d+JOaiyM3kRjs8DmgeB8
         RlJlyglzkooL/9/Gg4eI/1Bz6dqM44wuYzDjKH13N56wvRvJzHRShmmpjCejJBjhrJ0l
         tXn/OjxQdERpuNP/vi9m9YHH6Rrzl6A8v70bJ1c85scO7UhKv9c0XFM2casIsikIQFMV
         y1e7JT+iSxSkL3oevmNMjRNutbbgemWHTGvqFIJrG+b/9IQGxvhS+rF/4XX+bW2iOnX4
         WGRQ==
X-Gm-Message-State: APuU4Z+zUjPjVbsmXDwAsrPYv3EJGMdQorJtJwiE9lRX+5jDbIKQso3+
	j8EXAw2Uyw9kIa+LHQwvKOzD32+jL9UEUJQGJxBM8ZKf4zLoI7HZmCLEVpsTP4IKH3Ngy0bhzjA
	aAWFuvO8=
X-Gm-Gg: AYBFou2qTiDawrg5OlwrlHRQNzqpHqcdMQST47llcKFomcZkPQYbmD7uPho2A1G3YGl
	1aT5aP7PRuSeMgW1djPSr1cfF22Z2ge7zlwePynlyH/yS386vX/Pj8e0I+NUMtCWz2gjC3/WZsX
	IqGP8vdOQhvyJDLFr8rSxIwsqlJsajkV0FBwJRciNR3ZyuxL7RKvQVNke4kFEm+hT/bbhU+h6KH
	xEnfPYy/WJ19kHdJx1/ecpMafiLXEJhsFuOxrtBnhJxryolGn7UHZfeaawC8a+wZoleiUmuYPar
	uzvNT/oE1lRJJWtplo34FhGYJ+TkF50t+O5ueIxg5KeUT6Aicj8RMzANVP3TM0bWa2mo+iMroT7
	Zm5W01u7rJGHITmHIIXXddPAuReu4jsCp6Py6dSpG2byqp3qZnaSgKtTiU9WsTH3ArXiH1/83hJ
	vDzq3MNDvyR40w4mrxeblyJgiGyNubTY+GYC18bX0vwyjMbvfAVnqyRNV+5hMpINJui3En7Fdsk
	OpMdu1R5HA79t7A8LkJPdUKc4l+67zxocjFx5tEuX8y+KMQljJKUMLLZ0kXwfo/R6PQoaxTvLtZ
	4bks1Is7hqiB9+xwa4ZpTCGLBZm7L8Zoc1yv5Z1HSnPlgZx2d/6EVGHKS8sXS/lDs9Dluyjtxu7
	WqQvKWmkMUjNxfS+3bSA96SdChRLUcw==
X-Received: by 2002:a05:6820:1621:b0:716:f44b:2dd6 with SMTP id 006d021491bc7-716f44b2f07mr1500290eaf.25.1794020735120;
        Fri, 06 Nov 2026 19:05:35 -0800 (PST)
Received: from com-75606.corp.openai.org ([199.47.143.1])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4ad97a37725sm3581702fac.11.2026.11.06.19.05.34
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 06 Nov 2026 19:05:34 -0800 (PST)
From: Kyle Zeng <kylebot@openai.com>
To: linux-sctp@vger.kernel.org
Cc: lucien.xin@gmail.com,
	marcelo.leitner@gmail.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net v3] sctp: avoid requeueing pending control chunks
Date: Fri,  6 Nov 2026 19:05:32 -0800
Message-ID: <20261107030532.32310-1-kylebot@openai.com>
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

The T4 and RE-CONFIG timeout handlers take a reference to their cached
control chunk and submit it through SCTP_CMD_REPLY. A previous
transmission can still be on the control outqueue when output is corked
or suppressed, or when sctp_packet_transmit_chunk() could not append the
chunk.

sctp_outq_tail() then adds the same list node a second time. Re-adding a
non-tail entry can corrupt the list without being caught by the
insertion-time list checks. A subsequent flush or association teardown
can access an already freed chunk. The ASCONF path is reproducible by an
unprivileged SCTP socket owner in a user/network namespace, with KASAN
reporting a use-after-free in __sctp_outq_teardown().

Check sctp_chunk_pending() in both timeout handlers before taking the
extra reference and issuing SCTP_CMD_REPLY. If the chunk is already
linked, leave the existing entry for normal output processing. Keep
the remaining timer and error-handling commands unchanged. This also
covers RE-CONFIG retransmission after sctp_assoc_rm_peer() moves the
request to another transport and starts its timer.

The issue was found by an LLM.

Fixes: 2e3216cd54b1 ("sctp: Follow security requirement of responding with 1 packet")
Fixes: 7b9438de0cd4 ("sctp: add stream reconf timer")
Cc: stable@kernel.org
Suggested-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Kyle Zeng <kylebot@openai.com>
---
v1: https://lore.kernel.org/netdev/20261030042321.74407-1-kylebot@openai.com/
v2: Move the pending checks into the T4 and RE-CONFIG timeout handlers.
v3: Drop OUTQ_FLUSH and use the two pending checks as suggested. Leave
already-queued chunks for normal output processing.

I have a reproducer for this issue and can share by DM.

 net/sctp/sm_statefuns.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index b2f609f177fb..64519fd8f943 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -1122,9 +1122,11 @@ enum sctp_disposition sctp_sf_send_reconf(struct net *net,
 		return SCTP_DISPOSITION_DELETE_TCB;
 	}
 
-	sctp_chunk_hold(asoc->strreset_chunk);
-	sctp_add_cmd_sf(commands, SCTP_CMD_REPLY,
-			SCTP_CHUNK(asoc->strreset_chunk));
+	if (!sctp_chunk_pending(asoc->strreset_chunk)) {
+		sctp_chunk_hold(asoc->strreset_chunk);
+		sctp_add_cmd_sf(commands, SCTP_CMD_REPLY,
+				SCTP_CHUNK(asoc->strreset_chunk));
+	}
 	sctp_add_cmd_sf(commands, SCTP_CMD_STRIKE, SCTP_TRANSPORT(transport));
 
 	return SCTP_DISPOSITION_CONSUME;
@@ -6197,9 +6199,11 @@ enum sctp_disposition sctp_sf_t4_timer_expire(
 	 * chunk, it MUST be the same (including its serial number) as the last
 	 * ASCONF sent.
 	 */
-	sctp_chunk_hold(asoc->addip_last_asconf);
-	sctp_add_cmd_sf(commands, SCTP_CMD_REPLY,
-			SCTP_CHUNK(asoc->addip_last_asconf));
+	if (!sctp_chunk_pending(asoc->addip_last_asconf)) {
+		sctp_chunk_hold(asoc->addip_last_asconf);
+		sctp_add_cmd_sf(commands, SCTP_CMD_REPLY,
+				SCTP_CHUNK(asoc->addip_last_asconf));
+	}
 
 	/* ADDIP 4.1 B5) Restart the T-4 RTO timer. Note that if a different
 	 * destination is selected, then the RTO used will be that of the new

base-commit: 05441d697f7f9a927264f4058cbbc6a03dfcac9d
-- 
2.55.0.openai.911.g06873a30d2f3

