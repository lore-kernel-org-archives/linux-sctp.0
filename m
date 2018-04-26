From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Thu, 26 Apr 2018 19:59:00 +0000
Subject: [PATCH net-next 11/13] sctp: honor PMTU_DISABLED when handling icmp
Message-Id: <01299c62ca1ec2902de69ed872bea8c1520cce3d.1524772453.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1524772453.git.marcelo.leitner@gmail.com>
In-Reply-To: <cover.1524772453.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Xin Long <lucien.xin@gmail.com>

sctp_sendmsg() could trigger PMTU updates even when PMTU_DISABLED was
set, as pmtu_pending could be set unconditionally during icmp handling
if the socket was in use by the application.

This patch fixes it by checking for PMTU_DISABLED when handling such
deferred updates.

Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 net/sctp/socket.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index bb08d44b838bbbb0ffbf80b194a1291fed4069e4..ad8965835d8d51d4eda857b91dfca140710bf7da 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -1893,6 +1893,7 @@ static int sctp_sendmsg_to_asoc(struct sctp_association *asoc,
 				struct sctp_sndrcvinfo *sinfo)
 {
 	struct sock *sk = asoc->base.sk;
+	struct sctp_sock *sp = sctp_sk(sk);
 	struct net *net = sock_net(sk);
 	struct sctp_datamsg *datamsg;
 	bool wait_connect = false;
@@ -1911,13 +1912,14 @@ static int sctp_sendmsg_to_asoc(struct sctp_association *asoc,
 			goto err;
 	}
 
-	if (sctp_sk(sk)->disable_fragments && msg_len > asoc->frag_point) {
+	if (sp->disable_fragments && msg_len > asoc->frag_point) {
 		err = -EMSGSIZE;
 		goto err;
 	}
 
 	if (asoc->pmtu_pending) {
-		sctp_assoc_sync_pmtu(asoc);
+		if (sp->param_flags & SPP_PMTUD_ENABLE)
+			sctp_assoc_sync_pmtu(asoc);
 		asoc->pmtu_pending = 0;
 	}
 
@@ -1936,7 +1938,7 @@ static int sctp_sendmsg_to_asoc(struct sctp_association *asoc,
 		if (err)
 			goto err;
 
-		if (sctp_sk(sk)->strm_interleave) {
+		if (sp->strm_interleave) {
 			timeo = sock_sndtimeo(sk, 0);
 			err = sctp_wait_for_connect(asoc, &timeo);
 			if (err)
-- 
2.14.3

