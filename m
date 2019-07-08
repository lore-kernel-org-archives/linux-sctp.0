From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 08 Jul 2019 16:57:05 +0000
Subject: [PATCH net-next 2/4] sctp: remove prsctp_enable from asoc
Message-Id: <40a905e7b9733c7bdca74af31ab86586fbb91cd0.1562604972.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1562604972.git.lucien.xin@gmail.com>
 <988dac46cfecb6ae4fa21e40bf16da6faf3da6ab.1562604972.git.lucien.xin@gmail.com>
In-Reply-To: <988dac46cfecb6ae4fa21e40bf16da6faf3da6ab.1562604972.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

Like reconf_enable, prsctp_enable should also be removed from asoc,
as asoc->peer.prsctp_capable has taken its job.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/sctp/structs.h | 3 +--
 net/sctp/associola.c       | 1 -
 net/sctp/sm_make_chunk.c   | 8 ++++----
 net/sctp/socket.c          | 2 +-
 4 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index d9e0e1a..7f35b8e 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -2050,8 +2050,7 @@ struct sctp_association {
 	__u8 need_ecne:1,	/* Need to send an ECNE Chunk? */
 	     temp:1,		/* Is it a temporary association? */
 	     force_delay:1,
-	     intl_enable:1,
-	     prsctp_enable:1;
+	     intl_enable:1;
 
 	__u8 strreset_enable;
 	__u8 strreset_outstanding; /* request param count on the fly */
diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index 321c199..5010cce 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -261,7 +261,6 @@ static struct sctp_association *sctp_association_init(
 		goto stream_free;
 
 	asoc->active_key_id = ep->active_key_id;
-	asoc->prsctp_enable = ep->prsctp_enable;
 	asoc->strreset_enable = ep->strreset_enable;
 
 	/* Save the hmacs and chunks list into this association */
diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index d784dc1..227bbac 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -247,7 +247,7 @@ struct sctp_chunk *sctp_make_init(const struct sctp_association *asoc,
 	chunksize += SCTP_PAD4(SCTP_SAT_LEN(num_types));
 	chunksize += sizeof(ecap_param);
 
-	if (asoc->prsctp_enable)
+	if (asoc->ep->prsctp_enable)
 		chunksize += sizeof(prsctp_param);
 
 	/* ADDIP: Section 4.2.7:
@@ -348,7 +348,7 @@ struct sctp_chunk *sctp_make_init(const struct sctp_association *asoc,
 		sctp_addto_param(retval, num_ext, extensions);
 	}
 
-	if (asoc->prsctp_enable)
+	if (asoc->ep->prsctp_enable)
 		sctp_addto_chunk(retval, sizeof(prsctp_param), &prsctp_param);
 
 	if (sp->adaptation_ind) {
@@ -2011,7 +2011,7 @@ static void sctp_process_ext_param(struct sctp_association *asoc,
 				asoc->peer.reconf_capable = 1;
 			break;
 		case SCTP_CID_FWD_TSN:
-			if (asoc->prsctp_enable && !asoc->peer.prsctp_capable)
+			if (asoc->ep->prsctp_enable)
 				asoc->peer.prsctp_capable = 1;
 			break;
 		case SCTP_CID_AUTH:
@@ -2636,7 +2636,7 @@ static int sctp_process_param(struct sctp_association *asoc,
 		break;
 
 	case SCTP_PARAM_FWD_TSN_SUPPORT:
-		if (asoc->prsctp_enable) {
+		if (asoc->ep->prsctp_enable) {
 			asoc->peer.prsctp_capable = 1;
 			break;
 		}
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 0424876..da2a3c2 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -7343,7 +7343,7 @@ static int sctp_getsockopt_pr_supported(struct sock *sk, int len,
 		goto out;
 	}
 
-	params.assoc_value = asoc ? asoc->prsctp_enable
+	params.assoc_value = asoc ? asoc->peer.prsctp_capable
 				  : sctp_sk(sk)->ep->prsctp_enable;
 
 	if (put_user(len, optlen))
-- 
2.1.0
