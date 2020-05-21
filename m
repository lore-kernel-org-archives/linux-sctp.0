From: Christoph Hellwig <hch@lst.de>
Date: Thu, 21 May 2020 17:46:46 +0000
Subject: [PATCH 11/49] sctp: pass a kernel pointer to sctp_setsockopt_default_send_param
Message-Id: <20200521174724.2635475-12-hch@lst.de>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200521174724.2635475-1-hch@lst.de>
In-Reply-To: <20200521174724.2635475-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, David Laight <David.Laight@ACULAB.COM>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

Use the kernel pointer that sctp_setsockopt has available instead of
directly handling the user pointer.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 net/sctp/socket.c | 54 ++++++++++++++++++++++-------------------------
 1 file changed, 25 insertions(+), 29 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 0180b22087c0b..acf1484cd62a1 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -2864,57 +2864,54 @@ static int sctp_setsockopt_initmsg(struct sock *sk, struct sctp_initmsg *sinit,
  *   to this call if the caller is using the UDP model.
  */
 static int sctp_setsockopt_default_send_param(struct sock *sk,
-					      char __user *optval,
+					      struct sctp_sndrcvinfo *info,
 					      unsigned int optlen)
 {
 	struct sctp_sock *sp = sctp_sk(sk);
 	struct sctp_association *asoc;
-	struct sctp_sndrcvinfo info;
 
 	if (optlen != sizeof(info))
 		return -EINVAL;
-	if (copy_from_user(&info, optval, optlen))
-		return -EFAULT;
-	if (info.sinfo_flags &
+	if (info->sinfo_flags &
 	    ~(SCTP_UNORDERED | SCTP_ADDR_OVER |
 	      SCTP_ABORT | SCTP_EOF))
 		return -EINVAL;
 
-	asoc = sctp_id2assoc(sk, info.sinfo_assoc_id);
-	if (!asoc && info.sinfo_assoc_id > SCTP_ALL_ASSOC &&
+	asoc = sctp_id2assoc(sk, info->sinfo_assoc_id);
+	if (!asoc && info->sinfo_assoc_id > SCTP_ALL_ASSOC &&
 	    sctp_style(sk, UDP))
 		return -EINVAL;
 
 	if (asoc) {
-		asoc->default_stream = info.sinfo_stream;
-		asoc->default_flags = info.sinfo_flags;
-		asoc->default_ppid = info.sinfo_ppid;
-		asoc->default_context = info.sinfo_context;
-		asoc->default_timetolive = info.sinfo_timetolive;
+		asoc->default_stream = info->sinfo_stream;
+		asoc->default_flags = info->sinfo_flags;
+		asoc->default_ppid = info->sinfo_ppid;
+		asoc->default_context = info->sinfo_context;
+		asoc->default_timetolive = info->sinfo_timetolive;
 
 		return 0;
 	}
 
 	if (sctp_style(sk, TCP))
-		info.sinfo_assoc_id = SCTP_FUTURE_ASSOC;
+		info->sinfo_assoc_id = SCTP_FUTURE_ASSOC;
 
-	if (info.sinfo_assoc_id = SCTP_FUTURE_ASSOC ||
-	    info.sinfo_assoc_id = SCTP_ALL_ASSOC) {
-		sp->default_stream = info.sinfo_stream;
-		sp->default_flags = info.sinfo_flags;
-		sp->default_ppid = info.sinfo_ppid;
-		sp->default_context = info.sinfo_context;
-		sp->default_timetolive = info.sinfo_timetolive;
+	if (info->sinfo_assoc_id = SCTP_FUTURE_ASSOC ||
+	    info->sinfo_assoc_id = SCTP_ALL_ASSOC) {
+		sp->default_stream = info->sinfo_stream;
+		sp->default_flags = info->sinfo_flags;
+		sp->default_ppid = info->sinfo_ppid;
+		sp->default_context = info->sinfo_context;
+		sp->default_timetolive = info->sinfo_timetolive;
 	}
 
-	if (info.sinfo_assoc_id = SCTP_CURRENT_ASSOC ||
-	    info.sinfo_assoc_id = SCTP_ALL_ASSOC) {
+	if (info->sinfo_assoc_id = SCTP_CURRENT_ASSOC ||
+	    info->sinfo_assoc_id = SCTP_ALL_ASSOC) {
 		list_for_each_entry(asoc, &sp->ep->asocs, asocs) {
-			asoc->default_stream = info.sinfo_stream;
-			asoc->default_flags = info.sinfo_flags;
-			asoc->default_ppid = info.sinfo_ppid;
-			asoc->default_context = info.sinfo_context;
-			asoc->default_timetolive = info.sinfo_timetolive;
+			asoc->default_stream = info->sinfo_stream;
+			asoc->default_flags = info->sinfo_flags;
+			asoc->default_ppid = info->sinfo_ppid;
+			asoc->default_context = info->sinfo_context;
+			asoc->default_timetolive = info->sinfo_timetolive;
 		}
 	}
 
@@ -4692,8 +4689,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_initmsg(sk, kopt, optlen);
 		break;
 	case SCTP_DEFAULT_SEND_PARAM:
-		retval = sctp_setsockopt_default_send_param(sk, optval,
-							    optlen);
+		retval = sctp_setsockopt_default_send_param(sk, kopt, optlen);
 		break;
 	case SCTP_DEFAULT_SNDINFO:
 		retval = sctp_setsockopt_default_sndinfo(sk, optval, optlen);
-- 
2.26.2
