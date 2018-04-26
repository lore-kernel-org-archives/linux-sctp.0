From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Thu, 26 Apr 2018 19:58:59 +0000
Subject: [PATCH net-next 10/13] sctp: re-use sctp_transport_pmtu in sctp_transport_route
Message-Id: <f56dc0bbd8d3deae656e41fd91eebe7f303e2a00.1524772453.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1524772453.git.marcelo.leitner@gmail.com>
In-Reply-To: <cover.1524772453.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Xin Long <lucien.xin@gmail.com>

sctp_transport_route currently is very similar to sctp_transport_pmtu plus
a few other bits.

This patch reuses sctp_transport_pmtu in sctp_transport_route and removes
the duplicated code.

Also, as all calls to sctp_transport_route were forcing the dst release
before calling it, let's just include such release too.

Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 net/sctp/socket.c    |  6 ++----
 net/sctp/transport.c | 35 +++++++++++++++++------------------
 2 files changed, 19 insertions(+), 22 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index a93b60a28cc5fff0ebe299905fb31cb37de43d88..bb08d44b838bbbb0ffbf80b194a1291fed4069e4 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -644,16 +644,15 @@ static int sctp_send_asconf_add_ip(struct sock		*sk,
 
 			list_for_each_entry(trans,
 			    &asoc->peer.transport_addr_list, transports) {
-				/* Clear the source and route cache */
-				sctp_transport_dst_release(trans);
 				trans->cwnd = min(4*asoc->pathmtu, max_t(__u32,
 				    2*asoc->pathmtu, 4380));
 				trans->ssthresh = asoc->peer.i.a_rwnd;
 				trans->rto = asoc->rto_initial;
 				sctp_max_rto(asoc, trans);
 				trans->rtt = trans->srtt = trans->rttvar = 0;
+				/* Clear the source and route cache */
 				sctp_transport_route(trans, NULL,
-				    sctp_sk(asoc->base.sk));
+						     sctp_sk(asoc->base.sk));
 			}
 		}
 		retval = sctp_send_asconf(asoc, chunk);
@@ -896,7 +895,6 @@ static int sctp_send_asconf_del_ip(struct sock		*sk,
 		 */
 		list_for_each_entry(transport, &asoc->peer.transport_addr_list,
 					transports) {
-			sctp_transport_dst_release(transport);
 			sctp_transport_route(transport, NULL,
 					     sctp_sk(asoc->base.sk));
 		}
diff --git a/net/sctp/transport.c b/net/sctp/transport.c
index ed73a9d91b83eadd3eb8d681fda104fe71562c3f..4a95e260b674b3dffe2ffc4c54cf9a330dfac18c 100644
--- a/net/sctp/transport.c
+++ b/net/sctp/transport.c
@@ -242,6 +242,15 @@ void sctp_transport_pmtu(struct sctp_transport *transport, struct sock *sk)
 						&transport->fl, sk);
 	}
 
+	if (transport->param_flags & SPP_PMTUD_DISABLE) {
+		struct sctp_association *asoc = transport->asoc;
+
+		if (!transport->pathmtu && asoc && asoc->pathmtu)
+			transport->pathmtu = asoc->pathmtu;
+		if (transport->pathmtu)
+			return;
+	}
+
 	if (transport->dst)
 		transport->pathmtu = sctp_dst_mtu(transport->dst);
 	else
@@ -290,6 +299,7 @@ void sctp_transport_route(struct sctp_transport *transport,
 	struct sctp_association *asoc = transport->asoc;
 	struct sctp_af *af = transport->af_specific;
 
+	sctp_transport_dst_release(transport);
 	af->get_dst(transport, saddr, &transport->fl, sctp_opt2sk(opt));
 
 	if (saddr)
@@ -297,25 +307,14 @@ void sctp_transport_route(struct sctp_transport *transport,
 	else
 		af->get_saddr(opt, transport, &transport->fl);
 
-	if ((transport->param_flags & SPP_PMTUD_DISABLE) && transport->pathmtu) {
-		return;
-	}
-	if (transport->dst) {
-		transport->pathmtu = SCTP_TRUNC4(dst_mtu(transport->dst));
+	sctp_transport_pmtu(transport, sctp_opt2sk(opt));
 
-		/* Initialize sk->sk_rcv_saddr, if the transport is the
-		 * association's active path for getsockname().
-		 */
-		if (asoc && (!asoc->peer.primary_path ||
-			     (transport = asoc->peer.active_path)))
-			opt->pf->to_sk_saddr(&transport->saddr,
-					     asoc->base.sk);
-	} else if ((transport->param_flags & SPP_PMTUD_DISABLE) &&
-		   asoc && asoc->pathmtu) {
-		transport->pathmtu = asoc->pathmtu;
-	} else {
-		transport->pathmtu = SCTP_DEFAULT_MAXSEGMENT;
-	}
+	/* Initialize sk->sk_rcv_saddr, if the transport is the
+	 * association's active path for getsockname().
+	 */
+	if (transport->dst && asoc &&
+	    (!asoc->peer.primary_path || transport = asoc->peer.active_path))
+		opt->pf->to_sk_saddr(&transport->saddr, asoc->base.sk);
 }
 
 /* Hold a reference to a transport.  */
-- 
2.14.3

