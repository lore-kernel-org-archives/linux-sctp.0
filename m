From: Baolin Wang <baolin.wang@linaro.org>
Date: Tue, 03 Sep 2019 06:58:16 +0000
Subject: [BACKPORT 4.14.y 4/8] net: sctp: fix warning "NULL check before some freeing functions is not needed
Message-Id: <0e71732006c11f119826b3be9c1a9ccd102742d8.1567492316.git.baolin.wang@linaro.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1567492316.git.baolin.wang@linaro.org>
In-Reply-To: <cover.1567492316.git.baolin.wang@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stable@vger.kernel.org, vyasevich@gmail.com, nhorman@tuxdriver.com, davem@davemloft.net
Cc: hariprasad.kelam@gmail.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, arnd@arndb.de, baolin.wang@linaro.org, orsonzhai@gmail.com, vincent.guittot@linaro.org, linux-kernel@vger.kernel.org

From: Hariprasad Kelam <hariprasad.kelam@gmail.com>

This patch removes NULL checks before calling kfree.

fixes below issues reported by coccicheck
net/sctp/sm_make_chunk.c:2586:3-8: WARNING: NULL check before some
freeing functions is not needed.
net/sctp/sm_make_chunk.c:2652:3-8: WARNING: NULL check before some
freeing functions is not needed.
net/sctp/sm_make_chunk.c:2667:3-8: WARNING: NULL check before some
freeing functions is not needed.
net/sctp/sm_make_chunk.c:2684:3-8: WARNING: NULL check before some
freeing functions is not needed.

Signed-off-by: Hariprasad Kelam <hariprasad.kelam@gmail.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Baolin Wang <baolin.wang@linaro.org>
---
 net/sctp/sm_make_chunk.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index f67df16..6dac492 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -2586,8 +2586,7 @@ static int sctp_process_param(struct sctp_association *asoc,
 	case SCTP_PARAM_STATE_COOKIE:
 		asoc->peer.cookie_len  			ntohs(param.p->length) - sizeof(struct sctp_paramhdr);
-		if (asoc->peer.cookie)
-			kfree(asoc->peer.cookie);
+		kfree(asoc->peer.cookie);
 		asoc->peer.cookie = kmemdup(param.cookie->body, asoc->peer.cookie_len, gfp);
 		if (!asoc->peer.cookie)
 			retval = 0;
@@ -2652,8 +2651,7 @@ static int sctp_process_param(struct sctp_association *asoc,
 			goto fall_through;
 
 		/* Save peer's random parameter */
-		if (asoc->peer.peer_random)
-			kfree(asoc->peer.peer_random);
+		kfree(asoc->peer.peer_random);
 		asoc->peer.peer_random = kmemdup(param.p,
 					    ntohs(param.p->length), gfp);
 		if (!asoc->peer.peer_random) {
@@ -2667,8 +2665,7 @@ static int sctp_process_param(struct sctp_association *asoc,
 			goto fall_through;
 
 		/* Save peer's HMAC list */
-		if (asoc->peer.peer_hmacs)
-			kfree(asoc->peer.peer_hmacs);
+		kfree(asoc->peer.peer_hmacs);
 		asoc->peer.peer_hmacs = kmemdup(param.p,
 					    ntohs(param.p->length), gfp);
 		if (!asoc->peer.peer_hmacs) {
@@ -2684,8 +2681,7 @@ static int sctp_process_param(struct sctp_association *asoc,
 		if (!ep->auth_enable)
 			goto fall_through;
 
-		if (asoc->peer.peer_chunks)
-			kfree(asoc->peer.peer_chunks);
+		kfree(asoc->peer.peer_chunks);
 		asoc->peer.peer_chunks = kmemdup(param.p,
 					    ntohs(param.p->length), gfp);
 		if (!asoc->peer.peer_chunks)
-- 
1.7.9.5
