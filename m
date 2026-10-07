Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 656A33B27D3
	for <linux-sctp@vger.kernel.org>; Wed,  7 Oct 2026 03:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791345467; cv=none; b=ifz10YJxpw/gPa0/9RjfDEsb4eoPOnqTpyDaJdeMAUEaaRu3eMl9PUbk0tikL9mWUzuByRUsogtMnThoASHxnMTHeK1wFJXfeh4Wf7j2E/2lxb85LIzwyL9tPulzYlZes2YYzpq2bsjBdFOA7r0ECCkqDP71Vq+5x2U13Swwdxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791345467; c=relaxed/simple;
	bh=yNeF2VfrlVcw4qcdr9g71l1ukl3FUd+CWTZt6ay+YbU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=e59XEh5fcjDErbhDTqg94es/nr2AvApsIvQ+jMGLsIl+iRyWpbG46H2/Ndcyw3lgY2aY9XiW0nTIJJgDTiXyjhTBMg1Jput9m8B/SWZcf6cExvtqMXI5c3f/xEZ0HmsUmV3xNw7n1Kbxsc+4kkXZgkEAISX8xCecyH4lw+2jEO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bECzfwFO; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bECzfwFO"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-383b4a3755fso2550425a91.3
        for <linux-sctp@vger.kernel.org>; Tue, 06 Oct 2026 20:57:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791345466; x=1791950266; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=3hjMMWqILo+RQ+ZlMN41DDpi4TQ1W3WpbzPCHm6Qne8=;
        b=bECzfwFOD9YX/RclfM3IOCeMkbrFevDI8Z07dCtIpfGSMs+6k4RKmfIoHCZo2aPe2K
         kCVaoPMtRkzxOe4G3hIfC3wzvIz2si4T2JUJ957yXDtuH0VBrGrqBWbr2K1Wil1kCZOk
         QvIgv91bkTXaEguO1E9jWacEvy0DYXcYdwuMeHIufblKBlZuWDMGjgbdL43y3EYClN0j
         8KSbsGGrSTDt2dpvjYqKY+PspurDOxDdp53u8S12ZtWq7idfNZGMdXqTs4WHa3FItj+Q
         V+lGFmilcAbCOpoDtvbCbjAI/CQYeVDqGunAqLAGIUcCp4CrSxe5N0xBmZedpwZxiMf8
         Ui/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791345466; x=1791950266;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3hjMMWqILo+RQ+ZlMN41DDpi4TQ1W3WpbzPCHm6Qne8=;
        b=lrlSI5M7OiVHFqM20hxO/68AIDvRGVJpCBGaMhoC5eH5MkrlMAIDY4+Y02nN/2Pf/L
         +kKK7TJvinWAWNVtFp2kAa5LaA5MLHtlQf2ocv8CIJvtK7Cca+d6SezI21heGdgVKqe8
         WqFvvQebvWHRVURy7lRj5YSuGhl0JSIddt4UOKX+nYKLcKZ8yEzMnGtK4EzKS1MIGxUQ
         AIPVH+d05x9gf9hSUsc+dIDPD8bdxGPZ7eCYV9joRbNGtAM03WkoL/RfHjmpHwgERfoP
         qjVK0OOtPik3yIZh1I3iqkD0dMJflzFnQ57ViE0d6H/6QsQ+P3+RMnFb6b0e/K3i0maC
         IYMQ==
X-Forwarded-Encrypted: i=1; AKwUvBxgkqt5d7U2zHGXBVtjqCc2pDdp5Wh12gzOm0yzc++RsxEyzIAR2AVBDFXqUpiZqJpdwHRMZN8xUhK5@vger.kernel.org
X-Gm-Message-State: AFq9FYL+g9+ntMdGg9Wi7OZokg7wnlpuKbT7tflG/PCXtF9JKWWRG7F9
	xQBxs3mYukE9K/9NOlEUKIbXL7BF7bLq7gDwkMjx08p9ybMpix9RUVPY
X-Gm-Gg: AYBFou2R9dMkY/4h8cITcWpoGeqIqFU1sMwYn6u7KFXBjxQ5d9axhbYcuz+0gmyOd5t
	8H496Z703WNcbj36D5N3peqCmxXVS9hdndnh2t1XrFbimyOwnQRiM75mAfUob294zq+m7Qd0ao/
	lQVtuDlMGqC+5VpgcjzgVQ7UF5P8y9tDj/lced1ky86p2e9SNZsDQTh0S1kvqfqXzcd5RN3SVsv
	7Tys+YU2UPrXw5eGFgYS+s/N3PdHePtPWEGvgagmVSQJ/ovy55DYI+LVI1ocKh91HZ4jPd8pfYM
	W1L8AHVXDpC6blVxojHrICXzYQxeerF+cwXP2OGvAHumZcN8hCnq30IlcVveP3WNH3ZEPfilUXQ
	dkN0h2bii97FNIpMCKQ/Ouvanxv5btHiTP8PaLUEe7mIjgFBkKJ1QlFI/Vm3jvoUaXsu+Cwc1gI
	Lb9NJhN7bk+FSBbt4k6s3+i5j5B0enMY3KAUwC4eoHqVrhmv5hqBzGVSnqfvUAXDtLiQKoegcBU
	4rL+hucXo+253k7Sdqckw==
X-Received: by 2002:a17:90b:1344:b0:3a8:7bbc:3f3e with SMTP id 98e67ed59e1d1-3a8a1b0071cmr986825a91.41.1791345465698;
        Tue, 06 Oct 2026 20:57:45 -0700 (PDT)
Received: from ancienth-X870E-Nova-WiFi ([125.186.72.2])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a89b625d01sm2397749a91.14.2026.10.06.20.57.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 20:57:45 -0700 (PDT)
From: Daehyeon Ko <4ncienth@gmail.com>
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
	Daehyeon Ko <4ncienth@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH net v2] sctp: revalidate output stream after association connect wait
Date: Wed,  7 Oct 2026 12:57:39 +0900
Message-ID: <20261007035739.3472432-1-4ncienth@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When message interleaving is enabled, the first send waits for association
establishment before building its data chunks.  The wait drops the socket
lock, and handshake processing can reduce the output stream count to the
peer-advertised inbound stream count.  sctp_stream_init() then frees the
extension of every removed stream.

The sender resumes with the stream that it checked before the wait.  If the
peer removed that stream, sctp_outq_tail() later dereferences its NULL
extension.  Fatal-oops policies then panic the host.

KASAN: null-ptr-deref in range [0x38-0x3f]
RIP: sctp_outq_tail+0x49e/0xaa0
Call Trace:
 sctp_primitive_SEND
 sctp_sendmsg_to_asoc
 sctp_sendmsg

A range check alone is insufficient.  Stream reconfiguration can grow the
output count again while the lock is released without recreating extensions
freed by the earlier shrink.  The stream can then be in range while its
extension remains NULL.  The send-buffer wait has the same issue.

Factor the range and extension checks into a helper and repeat both after
each send-path wait that drops the socket lock.  Once the lock is
reacquired, the validation remains stable through data creation and
queueing.

If validation fails after the connect wait, the auto-created association is
already established.  Return ESRCH so the existing caller path keeps it
under state-machine ownership instead of freeing it directly, which would
leave protocol, counter and socket state inconsistent.

Fixes: 668c9beb9020 ("sctp: implement assign_number for sctp_stream_interleave")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
---
Changes in v2:
- Repeat full stream validation after both send-path waits.
- Recreate a missing stream extension after shrink followed by growth.
- Return ESRCH after the connect wait to retain the live association.

v1: https://lore.kernel.org/r/20261002010449.3689454-1-4ncienth@gmail.com

 net/sctp/socket.c | 33 +++++++++++++++++++++------------
 1 file changed, 21 insertions(+), 12 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 4652fd90d9a6c4..aaeb58ce055771 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -1786,6 +1786,18 @@ static int sctp_sendmsg_check_sflags(struct sctp_association *asoc,
 	return 1;
 }
 
+static int sctp_sendmsg_check_stream(struct sctp_association *asoc,
+				     struct sctp_sndrcvinfo *sinfo)
+{
+	if (unlikely(sinfo->sinfo_stream >= asoc->stream.outcnt))
+		return -EINVAL;
+
+	if (unlikely(!SCTP_SO(&asoc->stream, sinfo->sinfo_stream)->ext))
+		return sctp_stream_init_ext(&asoc->stream, sinfo->sinfo_stream);
+
+	return 0;
+}
+
 static int sctp_sendmsg_to_asoc(struct sctp_association *asoc,
 				struct msghdr *msg, size_t msg_len,
 				struct sctp_transport *transport,
@@ -1800,16 +1812,9 @@ static int sctp_sendmsg_to_asoc(struct sctp_association *asoc,
 	long timeo;
 	int err;
 
-	if (sinfo->sinfo_stream >= asoc->stream.outcnt) {
-		err = -EINVAL;
+	err = sctp_sendmsg_check_stream(asoc, sinfo);
+	if (err)
 		goto err;
-	}
-
-	if (unlikely(!SCTP_SO(&asoc->stream, sinfo->sinfo_stream)->ext)) {
-		err = sctp_stream_init_ext(&asoc->stream, sinfo->sinfo_stream);
-		if (err)
-			goto err;
-	}
 
 	if (sp->disable_fragments && msg_len > asoc->frag_point) {
 		err = -EMSGSIZE;
@@ -1830,10 +1835,9 @@ static int sctp_sendmsg_to_asoc(struct sctp_association *asoc,
 		err = sctp_wait_for_sndbuf(asoc, transport, &timeo, msg_len);
 		if (err)
 			goto err;
-		if (unlikely(sinfo->sinfo_stream >= asoc->stream.outcnt)) {
-			err = -EINVAL;
+		err = sctp_sendmsg_check_stream(asoc, sinfo);
+		if (err)
 			goto err;
-		}
 	}
 
 	if (sctp_state(asoc, CLOSED)) {
@@ -1848,6 +1852,11 @@ static int sctp_sendmsg_to_asoc(struct sctp_association *asoc,
 				err = -ESRCH;
 				goto err;
 			}
+			err = sctp_sendmsg_check_stream(asoc, sinfo);
+			if (err) {
+				err = -ESRCH;
+				goto err;
+			}
 		} else {
 			wait_connect = true;
 		}
-- 
2.55.0
