From: Xin Long <lucien.xin@gmail.com>
Date: Sun, 26 Nov 2017 12:16:06 +0000
Subject: [PATCH net 1/3] sctp: force SCTP_ERROR_INV_STRM with __u32 when calling sctp_chunk_fail
Message-Id: <b1daca5283b99f8df5a48749a18e07c8596316d1.1511698478.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1511698478.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1511698478.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>

This patch is to force SCTP_ERROR_INV_STRM with right type to
fit in sctp_chunk_fail to avoid the sparse error.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/stream.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/stream.c b/net/sctp/stream.c
index a20145b..76ea66b 100644
--- a/net/sctp/stream.c
+++ b/net/sctp/stream.c
@@ -64,7 +64,7 @@ static void sctp_stream_outq_migrate(struct sctp_stream *stream,
 		 */
 
 		/* Mark as failed send. */
-		sctp_chunk_fail(ch, SCTP_ERROR_INV_STRM);
+		sctp_chunk_fail(ch, (__force __u32)SCTP_ERROR_INV_STRM);
 		if (asoc->peer.prsctp_capable &&
 		    SCTP_PR_PRIO_ENABLED(ch->sinfo.sinfo_flags))
 			asoc->sent_cnt_removable--;
-- 
2.1.0

