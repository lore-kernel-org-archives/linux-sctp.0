From: David Laight <David.Laight@ACULAB.COM>
Date: Tue, 26 May 2020 16:40:01 +0000
Subject: [PATCH v3 net-next 8/8] sctp: setsockopt, whitespace changes
Message-Id: <522c0d1d83ff44cba6786f7cc3ca6547@AcuMS.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 'Vlad Yasevich' <vyasevich@gmail.com>, 'Neil Horman' <nhorman@tuxdriver.com>, "'David S. Miller'" <davem@davemloft.net>, 'Jakub Kicinski' <kuba@kernel.org>, "'linux-sctp@vger.kernel.org'" <linux-sctp@vger.kernel.org>, "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>, 'Christoph Hellwig' <hch@lst.de>, 'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>

Fix alignment of ?: continued lines.

Signed-off-by: David Laight <david.laight@aculab.com>

---
 net/sctp/socket.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 6d35ea3..4b89e5f 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -6304,7 +6304,7 @@ static int sctp_getsockopt_context(struct sock *sk, int len,
 		return -EINVAL;
 
 	params->assoc_value = asoc ? asoc->default_rcv_context
-				  : sctp_sk(sk)->default_rcv_context;
+				   : sctp_sk(sk)->default_rcv_context;
 
 	return 0;
 }
@@ -6789,7 +6789,7 @@ static int sctp_getsockopt_pr_supported(struct sock *sk, int len,
 	}
 
 	params->assoc_value = asoc ? asoc->peer.prsctp_capable
-				  : sctp_sk(sk)->ep->prsctp_enable;
+				   : sctp_sk(sk)->ep->prsctp_enable;
 
 	return 0;
 }
@@ -6924,7 +6924,7 @@ static int sctp_getsockopt_reconfig_supported(struct sock *sk, int len,
 		return -EINVAL;
 
 	params->assoc_value = asoc ? asoc->peer.reconf_capable
-				  : sctp_sk(sk)->ep->reconf_enable;
+				   : sctp_sk(sk)->ep->reconf_enable;
 
 	return 0;
 }
@@ -6943,7 +6943,7 @@ static int sctp_getsockopt_enable_strreset(struct sock *sk, int len,
 		return -EINVAL;
 
 	params->assoc_value = asoc ? asoc->strreset_enable
-				  : sctp_sk(sk)->ep->strreset_enable;
+				   : sctp_sk(sk)->ep->strreset_enable;
 
 	return 0;
 }
@@ -6962,7 +6962,7 @@ static int sctp_getsockopt_scheduler(struct sock *sk, int len,
 		return -EINVAL;
 
 	params->assoc_value = asoc ? sctp_sched_get_sched(asoc)
-				  : sctp_sk(sk)->default_ss;
+				   : sctp_sk(sk)->default_ss;
 
 	return 0;
 }
@@ -6997,7 +6997,7 @@ static int sctp_getsockopt_interleaving_supported(struct sock *sk, int len,
 		return -EINVAL;
 
 	params->assoc_value = asoc ? asoc->peer.intl_capable
-				  : sctp_sk(sk)->ep->intl_enable;
+				   : sctp_sk(sk)->ep->intl_enable;
 
 	return 0;
 }
@@ -7053,7 +7053,7 @@ static int sctp_getsockopt_asconf_supported(struct sock *sk, int len,
 		return -EINVAL;
 
 	params->assoc_value = asoc ? asoc->peer.asconf_capable
-				  : sctp_sk(sk)->ep->asconf_enable;
+				   : sctp_sk(sk)->ep->asconf_enable;
 
 	return 0;
 }
@@ -7072,7 +7072,7 @@ static int sctp_getsockopt_auth_supported(struct sock *sk, int len,
 		return -EINVAL;
 
 	params->assoc_value = asoc ? asoc->peer.auth_capable
-				  : sctp_sk(sk)->ep->auth_enable;
+				   : sctp_sk(sk)->ep->auth_enable;
 
 	return 0;
 }
@@ -7091,7 +7091,7 @@ static int sctp_getsockopt_ecn_supported(struct sock *sk, int len,
 		return -EINVAL;
 
 	params->assoc_value = asoc ? asoc->peer.ecn_capable
-				  : sctp_sk(sk)->ep->ecn_enable;
+				   : sctp_sk(sk)->ep->ecn_enable;
 
 	return 0;
 }
@@ -7110,7 +7110,7 @@ static int sctp_getsockopt_pf_expose(struct sock *sk, int len,
 		return -EINVAL;
 
 	params->assoc_value = asoc ? asoc->pf_expose
-				  : sctp_sk(sk)->pf_expose;
+				   : sctp_sk(sk)->pf_expose;
 
 	return 0;
 }
-- 
1.8.1.2

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
