Received: from mail-qk2-f15.google.com (mail-qk2-f15.google.com [74.125.230.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FD644E2F0F
	for <linux-sctp@vger.kernel.org>; Mon, 21 Sep 2026 18:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790013829; cv=none; b=HAR+NRk3M7otkmLOPiAyf59XsexoXenI3zL9bI3cDnmrCA1X/qTuCKoFejXJ2vl7Hs4CPcclNiIXMR9CdikS5SFNoMlHqik5Ck1d7oqA9bYKNAwztJ1gRCQV3tnkmLNwIhJoAoniviwev3Gk5Q+Yq+5DkjPJ0a/GJ4/Ul3kP8uM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790013829; c=relaxed/simple;
	bh=RGbyyk0qu3tdeoC5PudwhMmU/cEkEb9FKuwrTVQXv7A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZtWGOG4MdBbM02BwW4GNInutkI33K4TbjiVgvx0lK0PjbO34Op52L35C/tPm3AsxpUpRPWl+ZaTyJjpsrAMIFMpH3T7HjyRBkDjS6HH6eIrwVnLRl8xrtEDrTyPnEBsbErEPECT64qn0zZLKTLrGWJwp0EcpQZgaXZ/d8Xi7mjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PPtgGqQE; arc=none smtp.client-ip=74.125.230.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PPtgGqQE"
Received: by mail-qk2-f15.google.com with SMTP id af79cd13be357-93910c3d02aso140337085a.1
        for <linux-sctp@vger.kernel.org>; Mon, 21 Sep 2026 11:03:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790013827; x=1790618627; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=OU7Mf64VfjI+2J2xC8nOVzgC82LYLlyjr/Z4y5CGoH4=;
        b=PPtgGqQEyPw8Ci5QLokgHh1/dejgZcAoij4mRn6Xeautxsh8MwX93L+QfkUyzwQmbm
         /BnF+csHR+tULUD2rl748pLamEOik7lh6b4kVR0JRz1k4NeOz5osHwWHSxDZON/UfnE+
         47PzIoaJzMRfL44/O9Mq9r3uSxUW+TFnBmiAgQ5i/g9DbzEL34rTlJUsSIR9Ib5FGbIo
         V479scd0d2zFsDXyXY3pLpuqDdGaNxPuYvajJGdlUKuN0A/Cvpq7Xt/bO8qyr31CfvVg
         +JRQIkJsF3IxQ41GITJq3VnylsFLc+8pUnC3FjmlNzQwNMyqH1QyTKqz9YTgamF0Yjho
         PwDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790013827; x=1790618627;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OU7Mf64VfjI+2J2xC8nOVzgC82LYLlyjr/Z4y5CGoH4=;
        b=VsEywhQiDBYnjTSdblVvPh2MY7tpy1lkuDnu2jG45xHizSO25X3XsXstTTzkM3G/6E
         IWme5tYe7hqFOUOWhiGqFeH9EBuU1rRVD1TRnDRDcvlevL0vC9Nz1oj4PhCPR+FwoKpq
         qt2CHk0o8S5svZFRzgQhLb5d8dXkZhV/dHz053QE/z4B8vpRY/Nh90KVBaZ0o6/MG/VM
         4s4hjxq4PsBkXPHa664Cr5nvtKQY/Q4X/ODdvTyjdt3Sc30yg4KpdAsxyxXoPsmUpC+1
         Wi/S3dig4nw/sj516xwcChyOOEm8CD5sbu/mQ988R0PGurHlQ8HyPRt048KFp//bgo8I
         8FdQ==
X-Forwarded-Encrypted: i=1; AKwUvBx0mJu1+acWIbCaVVN1d1nfpS0zILEsh66JVp8zjr2EX58glk/LPv7BjQRegyFNFIOrSlcuzqSS3DLB@vger.kernel.org
X-Gm-Message-State: AFuF++lHrqVVTFvXVo01CxM24XJwjpoY7EoNrIwIFn0zxo2aTsKERm4Q
	SgUIC7gGaMVKASsEzEK0whunEXxPfBOIwABDt2vjoSHUqxl5HcG3uPhz
X-Gm-Gg: AYBFou3N9GETipuFCTi03ouOCw0DFekB/nVWJBjtd7aZ5fyZcH1dnzxOcfBfiKz4WAG
	k2Jw2yZHZ3KovcI40keWUQ8h+GcVz6LmHQR5KzlZRB3yu+cxDxJBC/9wP2hcl4wsBAIxU1oFTGC
	ciPE1V3sHRjxjJtBfla1LoY0d0pghj/34gDjqGl/FP03kFZ4PdmeP75wmvd5aZhzv/ys55U0jIy
	9d8UFvP3BhH0JrwbxtgrzSbniQnJw9AMKYympk8bwrLa/nc2rUnPjiOZTgDihBJz+r92FSighNR
	koWKY+vwtALgv3Fo/7wXX10AmBGge5ZyRvOzHNPfsz/ViwDn/8fzpiWUdItSzSEdbRlgLFrYc3V
	mdE3Ldz329hgp4/xpot4dkCWOsFMM0y08Q2DyI2W4XyVvQievNAl3EfIwePp6Ufy4qYB6uWMCm1
	HjEJvpke26eskb1QcMVXENZc3mkocs2Pn/Gq26adP6fVBLlJKMMYvMx579IM+OwXddPws5e8HxC
	AF/ifw/gTkLg9euC0K4QacEUmd5GVwyEotv6FEooR6WqV4UeHiuB9nWGfVnpLRh3XjnDsj/Ko9/
	cc1hQ0Ycki726t1T1cvbJf4pyoqBWmnuOb0o06LJh9aknLw=
X-Received: by 2002:a05:620a:1a0f:b0:93b:d7a4:9d49 with SMTP id af79cd13be357-93c17ecf267mr61226285a.28.1790013826924;
        Mon, 21 Sep 2026 11:03:46 -0700 (PDT)
Received: from wsfd-netdev58.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93beda707c2sm714351185a.16.2026.09.21.11.03.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 11:03:46 -0700 (PDT)
From: Xin Long <lucien.xin@gmail.com>
To: network dev <netdev@vger.kernel.org>,
	linux-sctp@vger.kernel.org
Cc: davem@davemloft.net,
	kuba@kernel.org,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Tangxin Xie <xietangxin@h-partners.com>,
	David Laight <david.laight.linux@gmail.com>
Subject: [PATCH net] sctp: hold asoc or transport before mod_timer() in timer handlers
Date: Mon, 21 Sep 2026 14:03:45 -0400
Message-ID: <c31b5e3ee2b7274e804f5eba2f21e2412e7eef7a.1790013825.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Take the association or transport reference before rearming a timer in the
timer handlers.

The existing code calls mod_timer() before taking the reference needed by
the rearmed timer without holding the sock lock. This creates a race with
timer cleanup: if the timer is deleted after mod_timer() returns but before
the reference is taken, the cleanup path can drop the timer's reference and
destroy the transport or association. The timer handler then takes a
reference on the already freed object and eventually drops it, causing a
refcount underflow.

Hold the object before mod_timer() and drop the reference if mod_timer()
reports that the timer was already pending in timer handlers. Apply the
same ordering to the proto-unreachable path, which can rearm a transport
timer outside the timer handlers without holding the sock lock.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Tangxin Xie <xietangxin@h-partners.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/input.c         |  7 ++++---
 net/sctp/sm_sideeffect.c | 37 ++++++++++++++++++++++---------------
 2 files changed, 26 insertions(+), 18 deletions(-)

diff --git a/net/sctp/input.c b/net/sctp/input.c
index 864741fae418..9494cfa51106 100644
--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@ -436,9 +436,10 @@ void sctp_icmp_proto_unreachable(struct sock *sk,
 		if (timer_pending(&t->proto_unreach_timer))
 			return;
 		else {
-			if (!mod_timer(&t->proto_unreach_timer,
-						jiffies + (HZ/20)))
-				sctp_transport_hold(t);
+			sctp_transport_hold(t);
+			if (mod_timer(&t->proto_unreach_timer,
+				      jiffies + (HZ / 20)))
+				sctp_transport_put(t);
 		}
 	} else {
 		struct net *net = sock_net(sk);
diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
index 0d99b7e8c082..35f540fb15fc 100644
--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -244,8 +244,9 @@ void sctp_generate_t3_rtx_event(struct timer_list *t)
 		pr_debug("%s: sock is busy\n", __func__);
 
 		/* Try again later.  */
-		if (!mod_timer(&transport->T3_rtx_timer, jiffies + (HZ/20)))
-			sctp_transport_hold(transport);
+		sctp_transport_hold(transport);
+		if (mod_timer(&transport->T3_rtx_timer, jiffies + (HZ / 20)))
+			sctp_transport_put(transport);
 		goto out_unlock;
 	}
 
@@ -280,8 +281,9 @@ static void sctp_generate_timeout_event(struct sctp_association *asoc,
 			 timeout_type);
 
 		/* Try again later.  */
-		if (!mod_timer(&asoc->timers[timeout_type], jiffies + (HZ/20)))
-			sctp_association_hold(asoc);
+		sctp_association_hold(asoc);
+		if (mod_timer(&asoc->timers[timeout_type], jiffies + (HZ / 20)))
+			sctp_association_put(asoc);
 		goto out_unlock;
 	}
 
@@ -378,8 +380,9 @@ void sctp_generate_heartbeat_event(struct timer_list *t)
 		pr_debug("%s: sock is busy\n", __func__);
 
 		/* Try again later.  */
-		if (!mod_timer(&transport->hb_timer, jiffies + (HZ/20)))
-			sctp_transport_hold(transport);
+		sctp_transport_hold(transport);
+		if (mod_timer(&transport->hb_timer, jiffies + (HZ / 20)))
+			sctp_transport_put(transport);
 		goto out_unlock;
 	}
 
@@ -388,8 +391,9 @@ void sctp_generate_heartbeat_event(struct timer_list *t)
 	timeout = sctp_transport_timeout(transport);
 	if (elapsed < timeout) {
 		elapsed = timeout - elapsed;
-		if (!mod_timer(&transport->hb_timer, jiffies + elapsed))
-			sctp_transport_hold(transport);
+		sctp_transport_hold(transport);
+		if (mod_timer(&transport->hb_timer, jiffies + elapsed))
+			sctp_transport_put(transport);
 		goto out_unlock;
 	}
 
@@ -422,9 +426,10 @@ void sctp_generate_proto_unreach_event(struct timer_list *t)
 		pr_debug("%s: sock is busy\n", __func__);
 
 		/* Try again later.  */
-		if (!mod_timer(&transport->proto_unreach_timer,
-				jiffies + (HZ/20)))
-			sctp_transport_hold(transport);
+		sctp_transport_hold(transport);
+		if (mod_timer(&transport->proto_unreach_timer,
+			      jiffies + (HZ / 20)))
+			sctp_transport_put(transport);
 		goto out_unlock;
 	}
 
@@ -458,8 +463,9 @@ void sctp_generate_reconf_event(struct timer_list *t)
 		pr_debug("%s: sock is busy\n", __func__);
 
 		/* Try again later.  */
-		if (!mod_timer(&transport->reconf_timer, jiffies + (HZ / 20)))
-			sctp_transport_hold(transport);
+		sctp_transport_hold(transport);
+		if (mod_timer(&transport->reconf_timer, jiffies + (HZ / 20)))
+			sctp_transport_put(transport);
 		goto out_unlock;
 	}
 
@@ -495,8 +501,9 @@ void sctp_generate_probe_event(struct timer_list *t)
 		pr_debug("%s: sock is busy\n", __func__);
 
 		/* Try again later.  */
-		if (!mod_timer(&transport->probe_timer, jiffies + (HZ / 20)))
-			sctp_transport_hold(transport);
+		sctp_transport_hold(transport);
+		if (mod_timer(&transport->probe_timer, jiffies + (HZ / 20)))
+			sctp_transport_put(transport);
 		goto out_unlock;
 	}
 
-- 
2.47.1

