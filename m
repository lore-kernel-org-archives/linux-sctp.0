Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0997644C64B;
	Fri,  7 Aug 2026 06:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786085038; cv=none; b=HUWkkxsD1xirwFGnJCbX8kWHiFUeT8xUyTh3ennjyYHr9pKB+ST5tXfqvcrv8NQKRfSrHv0r7TNEtGbRibfevJNmpmRxgACJbmWXAoWottjkwwl57p1MtXloP+rb97j+21NOxsGynb2fgywQ5cmk5Z7+s3peYzMLpptqB0iWyVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786085038; c=relaxed/simple;
	bh=ownM38qo6qKUu/ffImXqntcXmjD0N74UnEarE0QoUQQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SwcCylLW/s3smvHNRjiubvXcwDw33ZRkeB7GQsC1SnX9Sq5xX7Ms5OI5A1tP7hhM21YD/5B/w+NJifQAql2jLSfKDMlNvf6ekT/GfgdmyBjH2a1jgdRkZcbNvKLu3GICRXwTWyUaBin5lLcgDS3aDjoQhSXmWdHr4AF7QM6cJBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=ik/JaOFV; arc=none smtp.client-ip=117.135.210.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="ik/JaOFV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version:
	Content-Type; bh=XiEF1RhqiQjGuKkXjKUAZy724ihfORrXJyDL4vNVdqw=;
	b=ik/JaOFVklvsZsGmbhpbbwCw7E3rY0u5I0VJDDRxZpF6oxN13o2cO1B7idjihD
	ws9T+FYrmHaPsoek/IzZ3N7aGP3n5d9K2RHhh4laFWYIJoINfvKlPbiPUnuLQAWx
	ZwJDlytxgL78E6AoVy1iaD6AUo+E7m7xdFTTBOPHe19PY=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-4 (Coremail) with SMTP id _____wBXY8eDfnVqS8ZGOQ--.43665S2;
	Fri, 07 Aug 2026 14:43:17 +0800 (CST)
From: luoqing <l1138897701@163.com>
To: l1138897701@163.com,
	lucien.xin@gmail.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com
Cc: horms@kernel.org,
	linux-sctp@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net-next v4] sctp: auth: propagate HMAC calculation errors to callers
Date: Fri,  7 Aug 2026 14:43:14 +0800
Message-Id: <20260807064314.500742-1-l1138897701@163.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260730064202.792809-1-l1138897701@163.com>
References: <20260730064202.792809-1-l1138897701@163.com>
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wBXY8eDfnVqS8ZGOQ--.43665S2
X-Coremail-Antispam: 1Uf129KBjvJXoW3Ar4xuFyrZw17tF1DZryfXrb_yoWxJFWfp3
	Z8CrZYkw1xJr4aqFs3CF48G3WY9ws5C3y3JayYqwsay3Z8Xryrtryjka18KryUCFWkJa42
	yw4jgF15Gr1qyFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0piJ5rxUUUUU=
X-CM-SenderInfo: jorrjmiyzxliqr6rljoofrz/xtbC3gW4-Gp1foW5zgAA3M

From: Qing Luo <luoqing@kylinos.cn>

sctp_auth_calculate_hmac() can fail when building the association secret
under memory pressure, but its void return silently leaves the HMAC digest
zeroed.  On the receive path, sctp_sf_authenticate() compares this zeroed
digest against the peer-supplied one using crypto_memneq(), potentially
accepting an all-zero HMAC from the peer if the allocation failed.  On the
send path, sctp_packet_pack() transmits a packet with a zeroed HMAC that
the peer would reject.

Improve error handling by making sctp_auth_calculate_hmac() return int:
- sctp_sf_authenticate() returns SCTP_IERROR_NOMEM instead of accepting
  a zero HMAC.
- sctp_packet_pack() drops the packet on failure instead of transmitting
  a zeroed HMAC.

Update the declaration in auth.h accordingly.

Assisted-by: LLM
Signed-off-by: Qing Luo <luoqing@kylinos.cn>
---
v4: Remove the entry "sctp_auth_chunk_verify()" that has been removed from the commit message.
    
v3: Add missing SCTP maintainers and sctp mailing list, no code changes

---
 include/net/sctp/auth.h |  6 +++---
 net/sctp/auth.c         | 10 ++++++----
 net/sctp/output.c       | 12 +++++++++---
 net/sctp/sm_statefuns.c |  9 ++++++---
 4 files changed, 24 insertions(+), 13 deletions(-)

diff --git a/include/net/sctp/auth.h b/include/net/sctp/auth.h
index 6f2cd562b1de..eeb3297fe97d 100644
--- a/include/net/sctp/auth.h
+++ b/include/net/sctp/auth.h
@@ -83,9 +83,9 @@ int sctp_auth_send_cid(enum sctp_cid chunk,
 		       const struct sctp_association *asoc);
 int sctp_auth_recv_cid(enum sctp_cid chunk,
 		       const struct sctp_association *asoc);
-void sctp_auth_calculate_hmac(const struct sctp_association *asoc,
-			      struct sk_buff *skb, struct sctp_auth_chunk *auth,
-			      struct sctp_shared_key *ep_key, gfp_t gfp);
+int sctp_auth_calculate_hmac(const struct sctp_association *asoc,
+			     struct sk_buff *skb, struct sctp_auth_chunk *auth,
+			     struct sctp_shared_key *ep_key, gfp_t gfp);
 void sctp_auth_shkey_release(struct sctp_shared_key *sh_key);
 void sctp_auth_shkey_hold(struct sctp_shared_key *sh_key);
 
diff --git a/net/sctp/auth.c b/net/sctp/auth.c
index c901d373af80..6de66f56c41c 100644
--- a/net/sctp/auth.c
+++ b/net/sctp/auth.c
@@ -613,9 +613,9 @@ int sctp_auth_recv_cid(enum sctp_cid chunk, const struct sctp_association *asoc)
  *    zero (as shown in Figure 6) followed by all chunks that are placed
  *    after the AUTH chunk in the SCTP packet.
  */
-void sctp_auth_calculate_hmac(const struct sctp_association *asoc,
-			      struct sk_buff *skb, struct sctp_auth_chunk *auth,
-			      struct sctp_shared_key *ep_key, gfp_t gfp)
+int sctp_auth_calculate_hmac(const struct sctp_association *asoc,
+			     struct sk_buff *skb, struct sctp_auth_chunk *auth,
+			     struct sctp_shared_key *ep_key, gfp_t gfp)
 {
 	struct sctp_auth_bytes *asoc_key;
 	__u16 key_id, hmac_id;
@@ -636,7 +636,7 @@ void sctp_auth_calculate_hmac(const struct sctp_association *asoc,
 		/* ep_key can't be NULL here */
 		asoc_key = sctp_auth_asoc_create_secret(asoc, ep_key, gfp);
 		if (!asoc_key)
-			return;
+			return -ENOMEM;
 
 		free_key = 1;
 	}
@@ -654,6 +654,8 @@ void sctp_auth_calculate_hmac(const struct sctp_association *asoc,
 
 	if (free_key)
 		sctp_auth_key_put(asoc_key);
+
+	return 0;
 }
 
 /* API Helpers */
diff --git a/net/sctp/output.c b/net/sctp/output.c
index 23e96305cad7..3d7ead9d40e1 100644
--- a/net/sctp/output.c
+++ b/net/sctp/output.c
@@ -517,8 +517,14 @@ static int sctp_packet_pack(struct sctp_packet *packet,
 		}
 
 		if (auth) {
-			sctp_auth_calculate_hmac(tp->asoc, nskb, auth,
-						 packet->auth->shkey, gfp);
+			if (sctp_auth_calculate_hmac(tp->asoc, nskb, auth,
+						     packet->auth->shkey, gfp)) {
+				sctp_chunk_free(packet->auth);
+				packet->auth = NULL;
+				if (gso)
+					kfree_skb(nskb);
+				return -ENOMEM;
+			}
 			/* free auth if no more chunks, or add it back */
 			if (list_empty(&packet->chunk_list))
 				sctp_chunk_free(packet->auth);
@@ -619,7 +625,7 @@ int sctp_packet_transmit(struct sctp_packet *packet, gfp_t gfp)
 
 	/* pack up chunks */
 	pkt_count = sctp_packet_pack(packet, head, gso, gfp);
-	if (!pkt_count) {
+	if (pkt_count <= 0) {
 		kfree_skb(head);
 		goto out;
 	}
diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 708fa07d5fff..bb89c9b52e0b 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -4455,9 +4455,12 @@ static enum sctp_ierror sctp_sf_authenticate(
 
 	memset(digest, 0, sig_len);
 
-	sctp_auth_calculate_hmac(asoc, chunk->skb,
-				 (struct sctp_auth_chunk *)chunk->chunk_hdr,
-				 sh_key, GFP_ATOMIC);
+	if (sctp_auth_calculate_hmac(asoc, chunk->skb,
+				     (struct sctp_auth_chunk *)chunk->chunk_hdr,
+				     sh_key, GFP_ATOMIC)) {
+		kfree(save_digest);
+		return SCTP_IERROR_NOMEM;
+	}
 
 	/* Discard the packet if the digests do not match */
 	if (crypto_memneq(save_digest, digest, sig_len)) {
-- 
2.25.1

> Returning 0 here is fine, as its only caller, sctp_packet_transmit(),
> currently always returns 0. sctp_packet_pack(), on the other hand, returns
> the number of packets it builds.
>
> If you'd like to improve the return value for sctp_packet_transmit(),
> that can be done in a separate patch targeting net-next.

Hi Longxin

Thank you very much for your patient guidance on community patch submission conventions and your valuable review. I fully take your comment.

As you mentioned, returning 0 is acceptable for the moment, given `sctp_packet_transmit()` always returns zero today, while `sctp_packet_pack()` returns the count of generated packets.

Although there is no functional bug in the current code, unifying the return‑value semantics makes the interface more consistent, which can prevent latent risks when this code path is extended in the future.

I will implement this optimization as a standalone patch for net‑next as you suggested.

Please help to evaluate whether this improvement is necessary for mainline. If maintainers think it brings limited practical benefit, I am okay to drop this patch entirely.

Thanks,
luoqing

