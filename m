From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Thu, 26 Apr 2018 19:58:58 +0000
Subject: [PATCH net-next 09/13] sctp: remove sctp_transport_pmtu_check
Message-Id: <d4663bc43cafa6824959391e8797cd27e06ff3ff.1524772453.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1524772453.git.marcelo.leitner@gmail.com>
In-Reply-To: <cover.1524772453.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Xin Long <lucien.xin@gmail.com>

We are now keeping the MTU information synced between asoc, transport
and dst, which makes the check at sctp_packet_config() not needed
anymore. As it was the sole caller to this function, lets remove it.

Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 include/net/sctp/sctp.h | 12 ------------
 net/sctp/output.c       |  3 ---
 2 files changed, 15 deletions(-)

diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
index 4965cbfa7d92c0f60a76dd6e03571f78209dda5a..f66d4435000799f523fbaa34b0a57dbdeebda040 100644
--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -606,16 +606,4 @@ static inline __u32 sctp_dst_mtu(const struct dst_entry *dst)
 				 SCTP_DEFAULT_MINSEGMENT));
 }
 
-static inline bool sctp_transport_pmtu_check(struct sctp_transport *t)
-{
-	__u32 pmtu = sctp_dst_mtu(t->dst);
-
-	if (t->pathmtu = pmtu)
-		return true;
-
-	t->pathmtu = pmtu;
-
-	return false;
-}
-
 #endif /* __net_sctp_h__ */
diff --git a/net/sctp/output.c b/net/sctp/output.c
index bf4226c3cc1de79f2041d55a68ea53f4fd600b25..e672dee302c7092433a64ed3ed8bfcd183e1f9c8 100644
--- a/net/sctp/output.c
+++ b/net/sctp/output.c
@@ -118,9 +118,6 @@ void sctp_packet_config(struct sctp_packet *packet, __u32 vtag,
 		sctp_transport_route(tp, NULL, sp);
 		if (asoc->param_flags & SPP_PMTUD_ENABLE)
 			sctp_assoc_sync_pmtu(asoc);
-	} else if (!sctp_transport_pmtu_check(tp)) {
-		if (asoc->param_flags & SPP_PMTUD_ENABLE)
-			sctp_assoc_sync_pmtu(asoc);
 	}
 
 	/* If there a is a prepend chunk stick it on the list before
-- 
2.14.3

