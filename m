From: Daniel Borkmann <dborkman@redhat.com>
Date: Tue, 27 Aug 2013 14:06:03 +0000
Subject: [PATCH net-next v2] net: sctp: sctp_verify_init: clean up mandatory checks and add comment
Message-Id: <1377612363-10779-1-git-send-email-dborkman@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

Add a comment related to RFC4960 explaning why we do not check for initial
TSN, and while at it, remove yoda notation checks and clean up code from
checks of mandatory conditions. That's probably just really minor, but makes
reviewing easier.

Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
---
 v1->v2: update comment as Neil suggested

 net/sctp/sm_make_chunk.c | 26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 01e9783..e1c1531 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -2240,25 +2240,23 @@ int sctp_verify_init(struct net *net, const struct sctp_association *asoc,
 		     struct sctp_chunk **errp)
 {
 	union sctp_params param;
-	int has_cookie = 0;
+	bool has_cookie = false;
 	int result;
 
-	/* Verify stream values are non-zero. */
-	if ((0 = peer_init->init_hdr.num_outbound_streams) ||
-	    (0 = peer_init->init_hdr.num_inbound_streams) ||
-	    (0 = peer_init->init_hdr.init_tag) ||
-	    (SCTP_DEFAULT_MINWINDOW > ntohl(peer_init->init_hdr.a_rwnd))) {
-
+	/* Check for missing mandatory parameters. Note: Initial TSN is
+	 * also mandatory, but is not checked here since the valid range
+	 * is 0..2**(32-1). RFC4960, section 3.3.3.
+	 */
+	if (peer_init->init_hdr.num_outbound_streams = 0 ||
+	    peer_init->init_hdr.num_inbound_streams = 0 ||
+	    peer_init->init_hdr.init_tag = 0 ||
+	    ntohl(peer_init->init_hdr.a_rwnd) < SCTP_DEFAULT_MINWINDOW)
 		return sctp_process_inv_mandatory(asoc, chunk, errp);
-	}
 
-	/* Check for missing mandatory parameters.  */
 	sctp_walk_params(param, peer_init, init_hdr.params) {
-
-		if (SCTP_PARAM_STATE_COOKIE = param.p->type)
-			has_cookie = 1;
-
-	} /* for (loop through all parameters) */
+		if (param.p->type = SCTP_PARAM_STATE_COOKIE)
+			has_cookie = true;
+	}
 
 	/* There is a possibility that a parameter length was bad and
 	 * in that case we would have stoped walking the parameters.
-- 
1.7.11.7

