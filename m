From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Thu, 26 Apr 2018 19:58:51 +0000
Subject: [PATCH net-next 02/13] sctp: move transport pathmtu calc away of sctp_assoc_add_peer
Message-Id: <d40cf27eff03637b382254a2ba0bec5ff89a3710.1524772453.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1524772453.git.marcelo.leitner@gmail.com>
In-Reply-To: <cover.1524772453.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Xin Long <lucien.xin@gmail.com>

There was only one case that sctp_assoc_add_peer couldn't handle, which
is when SPP_PMTUD_DISABLE is set and pathmtu not initialized.
So add this situation to sctp_transport_route and reuse what was
already in there.

Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 net/sctp/associola.c | 9 +--------
 net/sctp/transport.c | 8 ++++++--
 2 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index a8f3b088fcb2ac82f58b7d6fb8894fe712e2bc0a..b3aa95222bd52113295cb246c503c903bdd5c353 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -652,15 +652,8 @@ struct sctp_transport *sctp_assoc_add_peer(struct sctp_association *asoc,
 	 */
 	peer->param_flags = asoc->param_flags;
 
-	sctp_transport_route(peer, NULL, sp);
-
 	/* Initialize the pmtu of the transport. */
-	if (peer->param_flags & SPP_PMTUD_DISABLE) {
-		if (asoc->pathmtu)
-			peer->pathmtu = asoc->pathmtu;
-		else
-			peer->pathmtu = SCTP_DEFAULT_MAXSEGMENT;
-	}
+	sctp_transport_route(peer, NULL, sp);
 
 	/* If this is the first transport addr on this association,
 	 * initialize the association PMTU to the peer's PMTU.
diff --git a/net/sctp/transport.c b/net/sctp/transport.c
index 47f82bd794d915188bad037463c2aa14175a55ef..c5fc3aed08a18658448b528b07dbb13900686313 100644
--- a/net/sctp/transport.c
+++ b/net/sctp/transport.c
@@ -307,11 +307,15 @@ void sctp_transport_route(struct sctp_transport *transport,
 		 * association's active path for getsockname().
 		 */
 		if (asoc && (!asoc->peer.primary_path ||
-				(transport = asoc->peer.active_path)))
+			     (transport = asoc->peer.active_path)))
 			opt->pf->to_sk_saddr(&transport->saddr,
 					     asoc->base.sk);
-	} else
+	} else if ((transport->param_flags & SPP_PMTUD_DISABLE) &&
+		   asoc && asoc->pathmtu) {
+		transport->pathmtu = asoc->pathmtu;
+	} else {
 		transport->pathmtu = SCTP_DEFAULT_MAXSEGMENT;
+	}
 }
 
 /* Hold a reference to a transport.  */
-- 
2.14.3

