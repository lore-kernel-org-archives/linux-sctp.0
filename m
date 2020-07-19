From: Christoph Hellwig <hch@lst.de>
Date: Sun, 19 Jul 2020 07:21:49 +0000
Subject: [PATCH 12/51] sctp: pass a kernel pointer to sctp_setsockopt_default_sndinfo
Message-Id: <20200719072228.112645-13-hch@lst.de>
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
 net/sctp/socket.c | 49 ++++++++++++++++++++++-------------------------
 1 file changed, 23 insertions(+), 26 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 9bcbb065cf9e1f..6695fa1cb0ca8f 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -2925,54 +2925,51 @@ static int sctp_setsockopt_default_send_param(struct sock *sk,
  * (SCTP_DEFAULT_SNDINFO)
  */
 static int sctp_setsockopt_default_sndinfo(struct sock *sk,
-					   char __user *optval,
+					   struct sctp_sndinfo *info,
 					   unsigned int optlen)
 {
 	struct sctp_sock *sp = sctp_sk(sk);
 	struct sctp_association *asoc;
-	struct sctp_sndinfo info;
 
-	if (optlen != sizeof(info))
+	if (optlen != sizeof(*info))
 		return -EINVAL;
-	if (copy_from_user(&info, optval, optlen))
-		return -EFAULT;
-	if (info.snd_flags &
+	if (info->snd_flags &
 	    ~(SCTP_UNORDERED | SCTP_ADDR_OVER |
 	      SCTP_ABORT | SCTP_EOF))
 		return -EINVAL;
 
-	asoc = sctp_id2assoc(sk, info.snd_assoc_id);
-	if (!asoc && info.snd_assoc_id > SCTP_ALL_ASSOC &&
+	asoc = sctp_id2assoc(sk, info->snd_assoc_id);
+	if (!asoc && info->snd_assoc_id > SCTP_ALL_ASSOC &&
 	    sctp_style(sk, UDP))
 		return -EINVAL;
 
 	if (asoc) {
-		asoc->default_stream = info.snd_sid;
-		asoc->default_flags = info.snd_flags;
-		asoc->default_ppid = info.snd_ppid;
-		asoc->default_context = info.snd_context;
+		asoc->default_stream = info->snd_sid;
+		asoc->default_flags = info->snd_flags;
+		asoc->default_ppid = info->snd_ppid;
+		asoc->default_context = info->snd_context;
 
 		return 0;
 	}
 
 	if (sctp_style(sk, TCP))
-		info.snd_assoc_id = SCTP_FUTURE_ASSOC;
+		info->snd_assoc_id = SCTP_FUTURE_ASSOC;
 
-	if (info.snd_assoc_id = SCTP_FUTURE_ASSOC ||
-	    info.snd_assoc_id = SCTP_ALL_ASSOC) {
-		sp->default_stream = info.snd_sid;
-		sp->default_flags = info.snd_flags;
-		sp->default_ppid = info.snd_ppid;
-		sp->default_context = info.snd_context;
+	if (info->snd_assoc_id = SCTP_FUTURE_ASSOC ||
+	    info->snd_assoc_id = SCTP_ALL_ASSOC) {
+		sp->default_stream = info->snd_sid;
+		sp->default_flags = info->snd_flags;
+		sp->default_ppid = info->snd_ppid;
+		sp->default_context = info->snd_context;
 	}
 
-	if (info.snd_assoc_id = SCTP_CURRENT_ASSOC ||
-	    info.snd_assoc_id = SCTP_ALL_ASSOC) {
+	if (info->snd_assoc_id = SCTP_CURRENT_ASSOC ||
+	    info->snd_assoc_id = SCTP_ALL_ASSOC) {
 		list_for_each_entry(asoc, &sp->ep->asocs, asocs) {
-			asoc->default_stream = info.snd_sid;
-			asoc->default_flags = info.snd_flags;
-			asoc->default_ppid = info.snd_ppid;
-			asoc->default_context = info.snd_context;
+			asoc->default_stream = info->snd_sid;
+			asoc->default_flags = info->snd_flags;
+			asoc->default_ppid = info->snd_ppid;
+			asoc->default_context = info->snd_context;
 		}
 	}
 
@@ -4695,7 +4692,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_default_send_param(sk, kopt, optlen);
 		break;
 	case SCTP_DEFAULT_SNDINFO:
-		retval = sctp_setsockopt_default_sndinfo(sk, optval, optlen);
+		retval = sctp_setsockopt_default_sndinfo(sk, kopt, optlen);
 		break;
 	case SCTP_PRIMARY_ADDR:
 		retval = sctp_setsockopt_primary_addr(sk, optval, optlen);
-- 
2.27.0
