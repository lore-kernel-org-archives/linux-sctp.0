Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85775457E79
	for <linux-sctp@vger.kernel.org>; Mon, 21 Sep 2026 09:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789983439; cv=none; b=J/E7nuaRBM9MD9kUt6eCr2iX2R/UE+ohAvImJPfX2bTDs4C83ioexRE0OJXKEJdI162+/CbX+YkfLhnU2H754zLgkSK0gQiRzKSk8T2oqO49y6RUMi8mP/WwiRNCOWhyaDXe2oFnjLVJ5H4lPN6u/iJrAMedE94oeDb1Z7WHpz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789983439; c=relaxed/simple;
	bh=DjkeyF9FjUQU2PuvGj1DiBtxbzqamGHfh/avpU0E3Ag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pQyNhN6sH5gfFbRc8X1VF11uJNogHnM7RJX/2I7lvpMx67GwrR+ijr549Y5xty3/2FryMUCPmAqtCF76DgLLtQLdDeWRx/YXx98tuycWOVaj6dcRoITHbsCB4MEOgA6kTbGtZ6+YerxjKghuHMetI3JNW63Xp8KUZGOLcoJj6Hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K9P40Pi0; arc=none smtp.client-ip=74.125.227.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K9P40Pi0"
Received: by mail-pj2-f12.google.com with SMTP id d9443c01a7336-2d8fb334ddcso22441705ad.0
        for <linux-sctp@vger.kernel.org>; Mon, 21 Sep 2026 02:37:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789983437; x=1790588237; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SZkGOV2v3EKiVxv0iFZpEgc+uW9SwmXctAKdDjSSr1c=;
        b=K9P40Pi0eQ/fxU240CR6GvK9OZfm+UBn7nPK1p5ecpXez44DHlrfB1wqUPnozzGkVb
         qjFKWsFFRRDDu/CUBUatVrxxb9gAXvPydoZGRJUxV10o/345G3FmJKMsjNyEW+lZw/WA
         I02MIJ/jigjZH/4hLicIxt4JeN9tiJEqEdsIXQn8dl353F4FJGga9Vr7aaNwvy4xv+nZ
         03yY4N8hktNN+krX9raT3L6gueLVJuF5xEc+j4qu3G7KoKkJjjGX0NbyoYmZWqP1sI8n
         W1RYeek0BfxTPSr4PRn8iwpEV21IMuR1Tk/0ksX6MNnN9Bkm4xxJKBx1ZpOBFCf30dUw
         J+rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789983437; x=1790588237;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=SZkGOV2v3EKiVxv0iFZpEgc+uW9SwmXctAKdDjSSr1c=;
        b=zsvT3JWllIHHwGchRbEIq1gEVC9p28YcRX1dwQmDpt4VrK48tWegiaekTEVnfGh01o
         EA+3tyA0wVaVZVZnhO4rvj8Ae3+SzrpbKtRzY1iPhpVVTkNCkpRlfH3j4yoiZ+nko3r3
         YJ7y33lSh9HXbK7OLQK7/wg6Cq7CgDypv6e0ZaYYCtohztYePsDXbFcmmmcaaLlQRMLs
         dytC+0LFMWsrsD+WchioQPMFux2B5JqbYrOoTBF5A5VODmo8e5YbKQnT7hrJFKeyudHx
         AqZZSBqKTw/xaeXyQy5wj9z8oWEqVq6hlPQe8pbnK/LM68XlqMKP/46Z1zGdT5ff/X/1
         Rq4Q==
X-Gm-Message-State: AFuF++lYBMuyEm3eceix4pwjl+aiGQsdX/UwCE/iaWTZ/5gMx7kcJfXo
	M+qxYHRJf3BfQJQ/W8ZvAZ7OG7RpU6jUoo+qJPoDB5cKFa0yK+j52fYM
X-Gm-Gg: AYBFou1z3ZURZXIK75uC2/k98mExUCONhaxoY1mlPI9EuUMS2SlTDD6fVX6j83XEDV2
	/BXNbQddihCplHXIjpYSwjPTcptbpxjA3SajuplBtaOeh2pj480WWDhwb/Pexcap7qKYUvYtPf7
	b+ubRa7vvdDeZfyq43xWEOyw6w1q7ce2KLTe85KqjVtMQspEry15KM6fuF9wcX0tU3qSbkYoQfj
	aHnByQiWKmiU8gyb+Kju3Yaab30OMXkyKmqZeQhwQPKsrcpkjpPf786fclcJrwbhFhJKRtPBjQb
	ctQwNSA4Bk8CjaxfzQwqEIv2+7nRk7RNvpBcXg6bEq0KeiNUCOaqSaJB8bWzVLVl9ri2nclQT1t
	K8beEoLmZbQC7hkqxGrGF2GYPHUBgPA5EcVjH8oqjo17mAKPkA0Od27WO9aKYHt0vTi+HpdjBqO
	hKpgK01aE8eGVu38j0RcP5cXdLUVaOLmOV/akBxtCS3MRTmbPZ1atSs43WR5HWE0+qnJG7WOtPI
	asmfafBDqNYdOqBCvQRk0IVcbMZLw4lSSQp
X-Received: by 2002:a17:903:2f4c:b0:2dd:c170:2d4d with SMTP id d9443c01a7336-2ddc17034demr99894695ad.24.1789983436470;
        Mon, 21 Sep 2026 02:37:16 -0700 (PDT)
Received: from localhost.localdomain ([117.88.121.70])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df52383751sm3496445ad.9.2026.09.21.02.37.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 02:37:15 -0700 (PDT)
From: Aohan Mei <ljp1205831794@gmail.com>
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org,
	marcelo.leitner@gmail.com,
	lucien.xin@gmail.com,
	imv4bel@gmail.com,
	Aohan Mei <henrymei@tencent.com>,
	TencentOS Corvus AI <corvus@tencent.com>,
	stable@vger.kernel.org
Subject: [PATCH net v2] sctp: discard the rest of the packet on a stale-cookie error
Date: Mon, 21 Sep 2026 17:37:04 +0800
Message-ID: <20260921093707.1432184-1-ljp1205831794@gmail.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <CADvbK_eQjfg_-HLT3zJ5Bt5LWbUTx_+fLG5ggLPNY1Ah+sF9GA@mail.gmail.com>
References: <CADvbK_eQjfg_-HLT3zJ5Bt5LWbUTx_+fLG5ggLPNY1Ah+sF9GA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Aohan Mei <henrymei@tencent.com>

When an association is in COOKIE-ECHOED state and the peer sends a
bundled [ERROR(Stale Cookie)][DATA] packet from one of its non-primary
addresses, processing the ERROR chunk takes the non-fatal stale-cookie
retry path sctp_sf_do_5_2_6_stale(), which queues
SCTP_CMD_DEL_NON_PRIMARY while keeping the association alive.
sctp_cmd_del_non_primary() removes every non-primary transport -
including the very transport this packet arrived on, which is still
referenced by the receive lookup and shared by all chunks of the
packet via chunk->transport.

sctp_assoc_rm_peer() does redirect asoc->peer.last_data_from away from
the removed transport, but right afterwards the bundled DATA chunk
makes sctp_assoc_bh_rcv() re-register
asoc->peer.last_data_from = chunk->transport unconditionally, undoing
the redirection with the just-removed transport.

Once the packet is done, the receive reference is dropped and the
transport is RCU-freed, while the surviving association keeps the
dangling last_data_from.  A later FWD-TSN (or the delayed SACK timer)
makes sctp_gen_sack() dereference it (->param_flags and friends), and
sctp_make_sack()/sctp_outq_select_transport() may write to the freed
object and link it into the live transport list.  This is a
use-after-free triggerable by any malicious SCTP peer (or a local
unprivileged user acting as one) with no capabilities required:

  BUG: KASAN: slab-use-after-free in sctp_do_sm+0x498a/0x5660
  Read of size 4 at addr ffff88800e1e356c by task poc/115
  Call Trace: sctp_do_sm <- sctp_assoc_bh_rcv <- sctp_inq_push <-
              sctp_rcv <- ip_protocol_deliver_rcu <- ip_rcv
  Allocated: sctp_transport_new <- sctp_assoc_add_peer <-
             sctp_process_init (INIT-ACK processing)
  Freed: kfree <- sctp_transport_destroy_rcu <- rcu_core
         (call_rcu queued by sctp_transport_put at end of sctp_rcv)
  The buggy address is located 364 bytes inside of freed 1024-byte
  region [ffff88800e1e3400, ffff88800e1e3800), cache kmalloc-1k

Note that commit 03a9d10ecf71 ("sctp: drop a chunk if its transport
was removed") only covers the window between the receive lookup and
the chunk processing (e.g. an ASCONF DEL-IP racing the socket backlog);
here the transport is removed *while* the packet is being processed,
by an earlier chunk of the same packet, so the drop in sctp_inq_push()
does not reach this path.  Verified with the bundled [ERROR(Stale
Cookie)][DATA] + FWD-TSN reproducer: the KASAN report above still
fires with that commit applied, and is gone with this patch on top.

Fix it by discarding the rest of the packet on this path, as suggested
by Xin.  After the stale-cookie ERROR has sent the association back to
COOKIE-WAIT and removed the non-primary transports, the remaining
chunks of the packet can only run against the restarted handshake
while referencing the removed arrival transport through
chunk->transport: besides the last_data_from registration above,
sctp_cmd_setup_t2() and the sctp_make_*() reply builders would also
copy that pointer into association-lifetime state that
sctp_assoc_rm_peer() has already sanitized.  Let the peer retransmit
them, in line with what sctp_inq_push() does for chunks whose
transport was removed before processing.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Suggested-by: Xin Long <lucien.xin@gmail.com>
Reported-by: TencentOS Corvus AI <corvus@tencent.com>
Cc: stable@vger.kernel.org
Assisted-by: CodeBuddy:Kimi-K3
Signed-off-by: Aohan Mei <henrymei@tencent.com>
---

Hi Xin,

Thanks a lot for the review and the suggestion.  Implemented in v2:
SCTP_CMD_DISCARD_PACKET queued at the end of the stale-cookie retry.

Verified with the reproducer: the kprobe trace now shows the ERROR
chunk still removing the transport (sctp_assoc_rm_peer/
sctp_transport_free fire as before) but no further chunk of the packet
being processed, and asoc->peer.last_data_from keeps the redirection
done by sctp_assoc_rm_peer().  The KASAN use-after-free is gone and
the association completes the retry handshake normally.

This also takes care of the other same-packet sinks the sashiko review
pointed out (sctp_cmd_setup_t2() and the sctp_make_*() reply chunks
copying chunk->transport into association-lifetime state): the
remaining chunks are now dropped before they can run, in line with
what sctp_inq_push() does for chunks whose transport was removed
before processing.

Regarding the cookie-echo restart path the review mentioned
(sctp_assoc_update() removing the arrival transport mid-packet, with a
bundled [COOKIE ECHO][SHUTDOWN] reaching SCTP_CMD_SETUP_T2): discarding
the packet does not look like an option there, as bundling DATA with
COOKIE-ECHO is a legitimate fast path.  I can look into clearing the
in-progress chunk's transport on removal, or a loop-level check, as a
follow-up - please let me know if you'd rather have it handled here.

On the bitfield concern: v2 no longer reads transport->dead at all.
The race described (sctp_icmp_frag_needed() in softirq doing a
non-atomic read-modify-write of pmtu_pending racing dead = 1) would
also defeat the existing transport->dead check in sctp_inq_push() from
03a9d10ecf71, so it might be worth moving that flag into its own word
separately.

As for the reproducer: it is a single static binary that plays both
roles over a TUN device - the victim side is a plain SCTP client
socket, while the peer side answers the INIT-ACK advertising a primary
and a non-primary address plus FWD-TSN support, injects the bundled
[ERROR(Stale Cookie)][DATA] from the non-primary address while the
association is COOKIE-ECHOED, completes the retry handshake, and sends
an FWD-TSN one second later to consume the dangling pointer.  It was
verified on tlinux 6.6.119 and on mainline v7.2-rc6-343, where it
still fires with 03a9d10ecf71f applied and is clean with this patch on
top.

Since it is a ready-to-run trigger for the bug, I'd prefer not to post
it to the public list - would it be OK if I send it to you and Marcelo
off-list instead?  Happy to share it in whatever way you prefer.

Thanks again!

 net/sctp/sm_statefuns.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 708fa07d5fffc..43ebceb5e15f5 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -2654,6 +2654,8 @@ static enum sctp_disposition sctp_sf_do_5_2_6_stale(
 
 	sctp_add_cmd_sf(commands, SCTP_CMD_REPLY, SCTP_CHUNK(reply));
 
+	sctp_add_cmd_sf(commands, SCTP_CMD_DISCARD_PACKET, SCTP_NULL());
+
 	return SCTP_DISPOSITION_CONSUME;
 
 nomem:
-- 
2.43.7

