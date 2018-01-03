From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 03 Jan 2018 22:59:52 +0000
Subject: [PATCH net v2 2/2] sctp: fix the handling of ICMP Frag Needed for too small MTUs
Message-Id: <fa373ffe7ccb1b7e75a00d904d673851f833d98b.1515020059.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1515020059.git.marcelo.leitner@gmail.com>
In-Reply-To: <cover.1515020059.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, Xin Long <lucien.xin@gmail.com>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>

syzbot reported a hang involving SCTP, on which it kept flooding dmesg
with the message:
[  246.742374] sctp: sctp_transport_update_pmtu: Reported pmtu 508 too
low, using default minimum of 512

That happened because whenever SCTP hits an ICMP Frag Needed, it tries
to adjust to the new MTU and triggers an immediate retransmission. But
it didn't consider the fact that MTUs smaller than the SCTP minimum MTU
allowed (512) would not cause the PMTU to change, and issued the
retransmission anyway (thus leading to another ICMP Frag Needed, and so
on).

As IPv4 (ip_rt_min_pmtuU6) and IPv6 (IPV6_MIN_MTU80) minimum MTU
are higher than that, sctp_transport_update_pmtu() is changed to
re-fetch the PMTU that got set after our request, and with that, detect
if there was an actual change or not.

The fix, thus, skips the immediate retransmission if the received ICMP
resulted in no change, in the hope that SCTP will select another path.

Note: The value being used for the minimum MTU (512,
SCTP_DEFAULT_MINSEGMENT) is not right and instead it should be (576,
SCTP_MIN_PMTU), but such change belongs to another patch.

Changes from v1:
- do not disable PMTU discovery, in the light of commit
06ad391919b2 ("[SCTP] Don't disable PMTU discovery when mtu is small")
and as suggested by Xin Long.
- changed the way to break the rtx loop by detecting if the icmp
  resulted in a change or not.
- change the warn to use pr_warn_ratelimited, to protect in case there
  are several transports using such path.

See-also: https://lkml.org/lkml/2017/12/22/811
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 include/net/sctp/structs.h |  2 +-
 net/sctp/input.c           |  8 ++++++--
 net/sctp/transport.c       | 29 +++++++++++++++++++----------
 3 files changed, 26 insertions(+), 13 deletions(-)

diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 2f8f93da5dc2660f4db37c04f8a434809b3120a1..9a5ccf03a59b1e0a4820e2a978c66f1df8a9a82f 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -966,7 +966,7 @@ void sctp_transport_burst_limited(struct sctp_transport *);
 void sctp_transport_burst_reset(struct sctp_transport *);
 unsigned long sctp_transport_timeout(struct sctp_transport *);
 void sctp_transport_reset(struct sctp_transport *t);
-void sctp_transport_update_pmtu(struct sctp_transport *t, u32 pmtu);
+bool sctp_transport_update_pmtu(struct sctp_transport *t, u32 pmtu);
 void sctp_transport_immediate_rtx(struct sctp_transport *);
 void sctp_transport_dst_release(struct sctp_transport *t);
 void sctp_transport_dst_confirm(struct sctp_transport *t);
diff --git a/net/sctp/input.c b/net/sctp/input.c
index 4a8e76f4834c90de9398455862423e598b8354a7..3cddbecabaa2db410971c66d3256c466c7f5289f 100644
--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@ -406,8 +406,12 @@ void sctp_icmp_frag_needed(struct sock *sk, struct sctp_association *asoc,
 		 */
 		return;
 
-	/* Update transports view of the MTU */
-	sctp_transport_update_pmtu(t, pmtu);
+	/* Update transports view of the MTU. Return if no update was needed.
+	 * If an update wasn't needed/possible, it also doesn't make sense to
+	 * try to retransmit now.
+	 */
+	if (!sctp_transport_update_pmtu(t, pmtu))
+		return;
 
 	/* Update association pmtu. */
 	sctp_assoc_sync_pmtu(asoc);
diff --git a/net/sctp/transport.c b/net/sctp/transport.c
index 1e5a22430cf56e40a6f323081beb97836b506384..47f82bd794d915188bad037463c2aa14175a55ef 100644
--- a/net/sctp/transport.c
+++ b/net/sctp/transport.c
@@ -248,28 +248,37 @@ void sctp_transport_pmtu(struct sctp_transport *transport, struct sock *sk)
 		transport->pathmtu = SCTP_DEFAULT_MAXSEGMENT;
 }
 
-void sctp_transport_update_pmtu(struct sctp_transport *t, u32 pmtu)
+bool sctp_transport_update_pmtu(struct sctp_transport *t, u32 pmtu)
 {
 	struct dst_entry *dst = sctp_transport_dst_check(t);
+	bool change = true;
 
 	if (unlikely(pmtu < SCTP_DEFAULT_MINSEGMENT)) {
-		pr_warn("%s: Reported pmtu %d too low, using default minimum of %d\n",
-			__func__, pmtu, SCTP_DEFAULT_MINSEGMENT);
-		/* Use default minimum segment size and disable
-		 * pmtu discovery on this transport.
-		 */
-		t->pathmtu = SCTP_DEFAULT_MINSEGMENT;
-	} else {
-		t->pathmtu = pmtu;
+		pr_warn_ratelimited("%s: Reported pmtu %d too low, using default minimum of %d\n",
+				    __func__, pmtu, SCTP_DEFAULT_MINSEGMENT);
+		/* Use default minimum segment instead */
+		pmtu = SCTP_DEFAULT_MINSEGMENT;
 	}
+	pmtu = SCTP_TRUNC4(pmtu);
 
 	if (dst) {
 		dst->ops->update_pmtu(dst, t->asoc->base.sk, NULL, pmtu);
 		dst = sctp_transport_dst_check(t);
 	}
 
-	if (!dst)
+	if (!dst) {
 		t->af_specific->get_dst(t, &t->saddr, &t->fl, t->asoc->base.sk);
+		dst = t->dst;
+	}
+
+	if (dst) {
+		/* Re-fetch, as under layers may have a higher minimum size */
+		pmtu = SCTP_TRUNC4(dst_mtu(dst));
+		change = t->pathmtu != pmtu;
+	}
+	t->pathmtu = pmtu;
+
+	return change;
 }
 
 /* Caches the dst entry and source address for a transport's destination
-- 
2.14.3

