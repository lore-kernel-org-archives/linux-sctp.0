From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 17 Nov 2017 06:15:02 +0000
Subject: [PATCH net] sctp: report SCTP_ERROR_INV_STRM as cpu endian
Message-Id: <d4de9314041c0ebb1d1e5f49130b880788a30735.1510899302.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>

rfc6458 demands the send_error in SCTP_SEND_FAILED_EVENT should
be in cpu endian, while SCTP_ERROR_INV_STRM is in big endian.

This issue is there since very beginning, Eric noticed it by
running 'make C=2 M=net/sctp/'.

This patch is to convert it before reporting it.

Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/stream.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/stream.c b/net/sctp/stream.c
index a11db21..f86ceee 100644
--- a/net/sctp/stream.c
+++ b/net/sctp/stream.c
@@ -64,7 +64,7 @@ static void sctp_stream_outq_migrate(struct sctp_stream *stream,
 		 */
 
 		/* Mark as failed send. */
-		sctp_chunk_fail(ch, SCTP_ERROR_INV_STRM);
+		sctp_chunk_fail(ch, be16_to_cpu(SCTP_ERROR_INV_STRM));
 		if (asoc->peer.prsctp_capable &&
 		    SCTP_PR_PRIO_ENABLED(ch->sinfo.sinfo_flags))
 			asoc->sent_cnt_removable--;
-- 
2.1.0

