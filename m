From: Colin King <colin.king@canonical.com>
Date: Tue, 10 Jan 2017 22:53:06 +0000
Subject: [PATCH] sctp: Fix spelling mistake: "Atempt" -> "Attempt"
Message-Id: <20170110225306.14880-1-colin.king@canonical.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, "David S . Miller" <davem@davemloft.net>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to spelling mistake in WARN_ONCE message

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 net/sctp/outqueue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index e540826..34efaa4 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -1048,7 +1048,7 @@ static void sctp_outq_flush(struct sctp_outq *q, int rtx_timeout, gfp_t gfp)
 			     (new_transport->state = SCTP_PF)))
 				new_transport = asoc->peer.active_path;
 			if (new_transport->state = SCTP_UNCONFIRMED) {
-				WARN_ONCE(1, "Atempt to send packet on unconfirmed path.");
+				WARN_ONCE(1, "Attempt to send packet on unconfirmed path.");
 				sctp_chunk_fail(chunk, 0);
 				sctp_chunk_free(chunk);
 				continue;
-- 
2.10.2

