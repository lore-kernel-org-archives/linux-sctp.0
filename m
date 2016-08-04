From: Phil Sutter <phil@nwl.cc>
Date: Thu, 04 Aug 2016 10:11:57 +0000
Subject: [PATCH v3 3/3] sctp_diag: Respect ss adding TCPF_CLOSE to idiag_states
Message-Id: <1470305517-31880-4-git-send-email-phil@nwl.cc>
List-Id: <linux-sctp.vger.kernel.org>
References: <1470305517-31880-1-git-send-email-phil@nwl.cc>
In-Reply-To: <1470305517-31880-1-git-send-email-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem@davemloft.net>
Cc: Xin Long <lucien.xin@gmail.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, netdev@vger.kernel.org, linux-sctp@vger.kernel.org

Since 'ss' always adds TCPF_CLOSE to idiag_states flags, sctp_diag can't
rely upon TCPF_LISTEN flag solely being present when listening sockets
are requested.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/sctp/sctp_diag.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sctp/sctp_diag.c b/net/sctp/sctp_diag.c
index f728ef04a7b2d..bb691538adc8e 100644
--- a/net/sctp/sctp_diag.c
+++ b/net/sctp/sctp_diag.c
@@ -356,7 +356,7 @@ static int sctp_ep_dump(struct sctp_endpoint *ep, void *p)
 	if (cb->args[4] < cb->args[1])
 		goto next;
 
-	if ((r->idiag_states & ~TCPF_LISTEN) && !list_empty(&ep->asocs))
+	if (!(r->idiag_states & TCPF_LISTEN) && !list_empty(&ep->asocs))
 		goto next;
 
 	if (r->sdiag_family != AF_UNSPEC &&
@@ -471,7 +471,7 @@ skip:
 	 * 3 : to mark if we have dumped the ep info of the current asoc
 	 * 4 : to work as a temporary variable to traversal list
 	 */
-	if (!(idiag_states & ~TCPF_LISTEN))
+	if (!(idiag_states & ~(TCPF_LISTEN | TCPF_CLOSE)))
 		goto done;
 	sctp_for_each_transport(sctp_tsp_dump, net, cb->args[2], &commp);
 done:
-- 
2.8.2

