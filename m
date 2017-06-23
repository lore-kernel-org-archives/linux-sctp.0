From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri, 23 Jun 2017 22:59:36 +0000
Subject: [PATCH net-next 4/4] sctp: adjust ssthresh when transport is idle
Message-Id: <c9a01544fb4ef7a9374fb64de6957c09247fbf6a.1498251459.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1498251459.git.marcelo.leitner@gmail.com>
In-Reply-To: <cover.1498251459.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>

RFC 4960 Errata 3.27 identifies that ssthresh should be adjusted to cwnd
because otherwise it could cause the transport to lock into congestion
avoidance phase specially if ssthresh was previously reduced by some
packet drop, leading to poor performance.

The Errata says to adjust ssthresh to cwnd only once, though the same
goal is achieved by updating it every time we update cwnd too. The
caveat is that we could take longer to get back up to speed but that
should be compensated by the fact that we don't adjust on RTO basis (as
RFC says) but based on Heartbeats, which are usually way longer.

See-also: https://tools.ietf.org/html/draft-ietf-tsvwg-rfc4960-errata-01#section-3.27
Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 net/sctp/transport.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/sctp/transport.c b/net/sctp/transport.c
index e3ebf04ddbd092a1ba04962c8fbe85a58588771a..7cdd6bcddbc5ad277f525635cf56788f70a4ee30 100644
--- a/net/sctp/transport.c
+++ b/net/sctp/transport.c
@@ -569,6 +569,8 @@ void sctp_transport_lower_cwnd(struct sctp_transport *transport,
 		 */
 		transport->cwnd = max(transport->cwnd/2,
 					 4*asoc->pathmtu);
+		/* RFC 4960 Errata 3.27.2: also adjust sshthresh */
+		transport->ssthresh = transport->cwnd;
 		break;
 	}
 
-- 
2.9.4

