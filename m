From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 03 Feb 2017 09:37:06 +0000
Subject: [PATCH net-next] sctp: process fwd tsn chunk only when prsctp is enabled
Message-Id: <16dcae6a3bff4b7e4c6d37bfa7dba217d5ca34b7.1486114626.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>, davem@davemloft.net

This patch is to check if asoc->peer.prsctp_capable is set before
processing fwd tsn chunk, if not, it will return an ERROR to the
peer, just as rfc3758 section 3.3.1 demands.

Reported-by: Julian Cordes <julian.cordes@gmail.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/sm_statefuns.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 782e579..d8798dd 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -3867,6 +3867,9 @@ sctp_disposition_t sctp_sf_eat_fwd_tsn(struct net *net,
 		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
 	}
 
+	if (!asoc->peer.prsctp_capable)
+		return sctp_sf_unk_chunk(net, ep, asoc, type, arg, commands);
+
 	/* Make sure that the FORWARD_TSN chunk has valid length.  */
 	if (!sctp_chunk_length_valid(chunk, sizeof(struct sctp_fwdtsn_chunk)))
 		return sctp_sf_violation_chunklen(net, ep, asoc, type, arg,
@@ -3935,6 +3938,9 @@ sctp_disposition_t sctp_sf_eat_fwd_tsn_fast(
 		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
 	}
 
+	if (!asoc->peer.prsctp_capable)
+		return sctp_sf_unk_chunk(net, ep, asoc, type, arg, commands);
+
 	/* Make sure that the FORWARD_TSN chunk has a valid length.  */
 	if (!sctp_chunk_length_valid(chunk, sizeof(struct sctp_fwdtsn_chunk)))
 		return sctp_sf_violation_chunklen(net, ep, asoc, type, arg,
-- 
2.1.0

