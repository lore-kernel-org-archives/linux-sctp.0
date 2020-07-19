From: Christoph Hellwig <hch@lst.de>
Date: Sun, 19 Jul 2020 07:22:24 +0000
Subject: [PATCH 47/51] sctp: pass a kernel pointer to sctp_setsockopt_event
Message-Id: <20200719072228.112645-48-hch@lst.de>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200719072228.112645-1-hch@lst.de>
In-Reply-To: <20200719072228.112645-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, David Laight <David.Laight@ACULAB.COM>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

Use the kernel pointer that sctp_setsockopt has available instead of
directly handling the user pointer.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 net/sctp/socket.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 12a33fc42eeeb2..b52acbf231ab9e 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4296,29 +4296,23 @@ static int sctp_setsockopt_event(struct sock *sk, struct sctp_event *param,
 }
 
 static int sctp_setsockopt_asconf_supported(struct sock *sk,
-					    char __user *optval,
+					    struct sctp_assoc_value *params,
 					    unsigned int optlen)
 {
-	struct sctp_assoc_value params;
 	struct sctp_association *asoc;
 	struct sctp_endpoint *ep;
 	int retval = -EINVAL;
 
-	if (optlen != sizeof(params))
-		goto out;
-
-	if (copy_from_user(&params, optval, optlen)) {
-		retval = -EFAULT;
+	if (optlen != sizeof(*params))
 		goto out;
-	}
 
-	asoc = sctp_id2assoc(sk, params.assoc_id);
-	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
+	asoc = sctp_id2assoc(sk, params->assoc_id);
+	if (!asoc && params->assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP))
 		goto out;
 
 	ep = sctp_sk(sk)->ep;
-	ep->asconf_enable = !!params.assoc_value;
+	ep->asconf_enable = !!params->assoc_value;
 
 	if (ep->asconf_enable && ep->auth_enable) {
 		sctp_auth_ep_add_chunkid(ep, SCTP_CID_ASCONF);
@@ -4641,7 +4635,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_event(sk, kopt, optlen);
 		break;
 	case SCTP_ASCONF_SUPPORTED:
-		retval = sctp_setsockopt_asconf_supported(sk, optval, optlen);
+		retval = sctp_setsockopt_asconf_supported(sk, kopt, optlen);
 		break;
 	case SCTP_AUTH_SUPPORTED:
 		retval = sctp_setsockopt_auth_supported(sk, optval, optlen);
-- 
2.27.0
