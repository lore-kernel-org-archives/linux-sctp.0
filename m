Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B6053B38B5
	for <linux-sctp@vger.kernel.org>; Wed, 29 Jul 2026 12:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785329381; cv=none; b=JE7L17Lhc4hXKR9PZI4dES2jDIY8K1czBhPXogKgpUpf+8wnWusRIvvBNhin5Bs7beRcKpKx7+HJKGNBSYDRR4mwaBJx2YdZrPp14J7x0M1Cuw+CP6wEExNF/461N8h2sUN2ncOKl+4P8+adi2ye/VGNTEiKGLMsWsw+GY7qdqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785329381; c=relaxed/simple;
	bh=dMdTSc3Tl06nw6OzYIROsHnUf57ucn/iJeZtWzjvvy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rXg7/E+I3CMl6dNx+Or97Ci0uqbdu/hZw0+YZuykqsWIEKnU5qdzkJIa6/bPgzujkb38bWCmZZS4G14xHOIFnkFODRnjWKRAZUQKEDn7OgWctMqDkXyUVMl7/hYN9Hyyjb+O2VdCw+KC9pkuHPDLkjWbaKOTj8eTRkZauMNMI4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xbow.com; spf=pass smtp.mailfrom=xbow.com; dkim=pass (2048-bit key) header.d=xbow.com header.i=@xbow.com header.b=j9I+6Z/i; arc=none smtp.client-ip=209.85.222.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xbow.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xbow.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=xbow.com header.i=@xbow.com header.b="j9I+6Z/i"
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-92f03daaa97so60724885a.2
        for <linux-sctp@vger.kernel.org>; Wed, 29 Jul 2026 05:49:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=xbow.com; s=google; t=1785329377; x=1785934177; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sibTfHUhgDSEqAJ8U27DkLL8Rr1uOtqg41a+d4rH7xQ=;
        b=j9I+6Z/iCdtA5TjdVLfrJNg7bTQpImHYzEkia9XJgbz4Vzsz8KhfdcC6dZr0rrHlOX
         5IsZT71tM2KsbOi0ZD56I8CzP1r5oymaPQrCaP6oM5HUSoJM6dsEgLpZjtzr2MAqAk6Q
         Mg8WIxw09aRdG5gxuTry1GeVqMdhK8Wnp7/+PxIJmc9odmAEpHCCAOyS10QOFph2r8ba
         Uw1K9DawowncIj/BZT3kT3Ja2Uz9q6CEasZ06YqCArK1dE1nVCrVKYdHU0k5U0c+8SHT
         3X7n5+vTp22qKSpg/Xqk3mKDLKAWWqeMgb6eHuVMsQZ1U2Spyjj4ZV2UX2BXhsxIoLFT
         It9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785329377; x=1785934177;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=sibTfHUhgDSEqAJ8U27DkLL8Rr1uOtqg41a+d4rH7xQ=;
        b=F4qHqiiJN0ZM16T4dKNZSUoGtZVgbnishmJl72zt5xq9v7RspU6rRpowvAT8o09YS2
         Y0vebi7+0v6qXuqndg5iVYGo+1j3FzlY18zuvgeNQSB4BGSIGIxjQlTWkimhnp9O0rHV
         vppdSvrnNQLHf27NhEDcX+Z0qFioVEgdu8YKaUqpOpo7FVKClC+O+/KGK9lIRcPU5iBX
         aPnQ5kLxuzUvJspJsQ4QBeUsQtjssh6f+hFaExeNp2D8gKLJRZ6Wg1bOd0F0dBIml8IX
         54gyGGHBjT6BTJ9sePMaKoi/xhJ9md9p+PU5QfvSe/XlGCmto2gpLlJAhigvNDAoxGzD
         GxIQ==
X-Forwarded-Encrypted: i=1; AHgh+Rq9WTn4516wMhO/T4KA8ABOM7oOa/P/hxvSUb2chQgIgUuHccFbvdE7017mKQYbUMVBoJrmRrDEP616@vger.kernel.org
X-Gm-Message-State: AOJu0Yz18MbKkMMYOUANMg19dqIjh5yqWolRL+a40iqokofso3ZqDRGy
	jO38H3sSoZaGI6l3bQP70rr4QOSPH6VPZ/1uz02cDmFq9aR8iQ2zEeCoez/azto59Ag=
X-Gm-Gg: AR+sD13sV6xV8P26OS1g0T2ru1cGUIDh5qOUb7HKsxMC1j7E3POCyzMiYEsoRrmNYR/
	Ppk/05ol0RP7Ps4rTbHwQ0MdqmPpm0a50vvLO87J8u9+jhC0WVWLyZRi1g79vRD1fD4LJDadQx9
	CwWOEd3GhCuxIuUvAzQhHlBgeYVm1O8h/nM2p0GF1q3Ak4Feze2fDvD7QhFmtf06BHA5boZMAxe
	T3pNpLoe9yWlxJvQrq3thPpVUpgiR/KXE2VJFB1C2kLrKDOpLtWLg9uqxZVX9zQjisANHudXSaw
	e7n15rHPjiEy7UKUqpYGjEZl8P5nx6vNPE5uEM7LMsqh82VA3Qm8xKBEWk54fdlVlZi4KP5yc/Z
	pM48MQsVb/FHQwFlIRKuvXNLoCb8YLo8+//PMUqW8svpJMi3T0VQzmWlU/hNGB7MQOOML0cWdW2
	3+BSkI7ziuI6CXtzTTm/xxBhKYs8BSlZQkXSgwQi54qo+1qFYHyy40EWZ8v79EBkuVXakdrjVK3
	x7/2CqcqXfPWyB4GSMw9LK8UkleZOXCu2JYXaSutbgBUpZVLrGlnWh/1yTqPSWnL1EDHZjty7HJ
	62il2OUs1QK77N99O7BJyoCQuw/kOBfgl1r7EHI0
X-Received: by 2002:a05:620a:1729:b0:92e:5f90:c0de with SMTP id af79cd13be357-933026efff5mr662962785a.22.1785329377284;
        Wed, 29 Jul 2026 05:49:37 -0700 (PDT)
Received: from buildmachine.tailf331da.ts.net (ec2-3-14-143-233.us-east-2.compute.amazonaws.com. [3.14.143.233])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-933d3257522sm160393885a.11.2026.07.29.05.49.33
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 29 Jul 2026 05:49:36 -0700 (PDT)
From: Baul Lee <baul.lee@xbow.com>
To: netdev@vger.kernel.org,
	linux-sctp@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	stable@vger.kernel.org,
	Baul Lee <baul.lee@xbow.com>
Subject: [PATCH net v2] sctp: keep chunk->transport in step with the list it is queued on
Date: Wed, 29 Jul 2026 21:49:29 +0900
Message-ID: <20260729124929.5885-1-baul.lee@xbow.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260726060453.42730-1-baul.lee@xbow.com>
References: <20260726060453.42730-1-baul.lee@xbow.com>
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

__sctp_outq_flush_rtx() moves a chunk onto transport->transmitted in two
places but only one of them leaves chunk->transport describing where the
chunk actually is.  The ordinary resend path is consistent because
sctp_packet_append_chunk() rebinds the chunk in
__sctp_packet_append_chunk():

	list_add_tail(&chunk->list, &packet->chunk_list);
	packet->size += chunk_len;
	chunk->transport = packet->transport;

The gap-acked path has no such rebind.  It parks the chunk on another
transport's transmitted list and leaves the stale back-pointer alone:

	if (chunk->tsn_gap_acked) {
		list_move_tail(&chunk->transmitted_list,
			       &transport->transmitted);
		continue;
	}

So a chunk can sit on a live transport's transmitted list while
chunk->transport still names a different transport.  If that transport is
then removed - sctp_assoc_rm_peer() from an ASCONF Delete-IP - the last
reference goes away and sctp_transport_free() RCU-frees it, leaving the
chunk with a dangling pointer.  sctp_assoc_rm_peer() scrubs the
back-pointer on peer->transmitted and on asoc->outqueue.out_chunk_list,
but this chunk is on neither.

While tsn_gap_acked stays set the dangling pointer is not followed, since
sctp_check_transmitted() skips the flight accounting for gap-acked chunks.
A later SACK that reneges on the TSN clears the flag, and the next SACK
then reaches

	tchunk->transport->flight_size -= sctp_data_size(tchunk);

a read-modify-write inside the freed sctp_transport.  KASAN reports a
slab-use-after-free read of 4 bytes at offset 216 of a freed kmalloc-1k
sctp_transport in sctp_check_transmitted(), freed from
sctp_assoc_rm_peer() via sctp_process_asconf().  The removal and the
faulting SACKs all come from the association peer, so an application that
speaks SCTP and accepts multihoming is enough to reach it.

Assign chunk->transport after both list_move_tail() calls, so the
back-pointer always matches the list the chunk is queued on.  Doing it on
the ordinary path too keeps the invariant local to the move instead of
resting on a rebind that happens later and only if the chunk is appended to
a packet.  Fixing it here rather than by scrubbing more lists in
sctp_assoc_rm_peer() covers the chunks that were already migrated before
the transport went away, which a scrub at removal time cannot see.

Discovered by XBOW, triaged by Baul Lee <baul.lee@xbow.com>
[Reported privately to the maintainers on 2026-07-10 with root-cause
analysis, a PoC, a KASAN log and a fix; posting to the list was requested
as the follow-up.]

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Baul Lee <baul.lee@xbow.com>
---
v2:
 - fix the root cause in __sctp_outq_flush_rtx() instead of clearing the
   back-pointer for the retransmit queue in sctp_assoc_rm_peer().  The v1
   scrub could not see chunks that had already been migrated onto another
   transport's transmitted list before the removal, which is the case the
   reviews on v1 asked about
 - correct the Fixes tag: the inconsistency is as old as the code, not
   introduced by df132eff4638

Link to v1: https://lore.kernel.org/netdev/20260726060453.42730-1-baul.lee@xbow.com/

 net/sctp/outqueue.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index f6b8c13da..1b2d08f2e 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -650,6 +650,7 @@ static int __sctp_outq_flush_rtx(struct sctp_outq *q, struct sctp_packet *pkt,
 		if (chunk->tsn_gap_acked) {
 			list_move_tail(&chunk->transmitted_list,
 				       &transport->transmitted);
+			chunk->transport = transport;
 			continue;
 		}
 
@@ -715,6 +716,7 @@ static int __sctp_outq_flush_rtx(struct sctp_outq *q, struct sctp_packet *pkt,
 			 */
 			list_move_tail(&chunk->transmitted_list,
 				       &transport->transmitted);
+			chunk->transport = transport;
 
 			/* Mark the chunk as ineligible for fast retransmit
 			 * after it is retransmitted.
-- 
2.53.0

