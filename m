From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 08 Jul 2019 16:57:04 +0000
Subject: [PATCH net-next 1/4] sctp: remove reconf_enable from asoc
Message-Id: <988dac46cfecb6ae4fa21e40bf16da6faf3da6ab.1562604972.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1562604972.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1562604972.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

asoc's reconf support is actually decided by the 4-shakehand negotiation,
not something that users can set by sockopt. asoc->peer.reconf_capable is
working for this. So remove it from asoc.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/sctp/structs.h | 3 +--
 net/sctp/associola.c       | 1 -
 net/sctp/sm_make_chunk.c   | 5 ++---
 net/sctp/socket.c          | 7 ++-----
 4 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 0767701..d9e0e1a 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -2051,8 +2051,7 @@ struct sctp_association {
 	     temp:1,		/* Is it a temporary association? */
 	     force_delay:1,
 	     intl_enable:1,
-	     prsctp_enable:1,
-	     reconf_enable:1;
+	     prsctp_enable:1;
 
 	__u8 strreset_enable;
 	__u8 strreset_outstanding; /* request param count on the fly */
diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index 1999237..321c199 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -262,7 +262,6 @@ static struct sctp_association *sctp_association_init(
 
 	asoc->active_key_id = ep->active_key_id;
 	asoc->prsctp_enable = ep->prsctp_enable;
-	asoc->reconf_enable = ep->reconf_enable;
 	asoc->strreset_enable = ep->strreset_enable;
 
 	/* Save the hmacs and chunks list into this association */
diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 9b0e5b0..d784dc1 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -261,7 +261,7 @@ struct sctp_chunk *sctp_make_init(const struct sctp_association *asoc,
 		num_ext += 2;
 	}
 
-	if (asoc->reconf_enable) {
+	if (asoc->ep->reconf_enable) {
 		extensions[num_ext] = SCTP_CID_RECONF;
 		num_ext += 1;
 	}
@@ -2007,8 +2007,7 @@ static void sctp_process_ext_param(struct sctp_association *asoc,
 	for (i = 0; i < num_ext; i++) {
 		switch (param.ext->chunks[i]) {
 		case SCTP_CID_RECONF:
-			if (asoc->reconf_enable &&
-			    !asoc->peer.reconf_capable)
+			if (asoc->ep->reconf_enable)
 				asoc->peer.reconf_capable = 1;
 			break;
 		case SCTP_CID_FWD_TSN:
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 39ea0a3..0424876 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4226,10 +4226,7 @@ static int sctp_setsockopt_reconfig_supported(struct sock *sk,
 	    sctp_style(sk, UDP))
 		goto out;
 
-	if (asoc)
-		asoc->reconf_enable = !!params.assoc_value;
-	else
-		sctp_sk(sk)->ep->reconf_enable = !!params.assoc_value;
+	sctp_sk(sk)->ep->reconf_enable = !!params.assoc_value;
 
 	retval = 0;
 
@@ -7554,7 +7551,7 @@ static int sctp_getsockopt_reconfig_supported(struct sock *sk, int len,
 		goto out;
 	}
 
-	params.assoc_value = asoc ? asoc->reconf_enable
+	params.assoc_value = asoc ? asoc->peer.reconf_capable
 				  : sctp_sk(sk)->ep->reconf_enable;
 
 	if (put_user(len, optlen))
-- 
2.1.0
