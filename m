From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 28 Jan 2019 07:08:45 +0000
Subject: [PATCH net-next 23/24] sctp: use SCTP_FUTURE_ASSOC and add SCTP_CURRENT_ASSOC for SCTP_EVENT sockopt
Message-Id: <402e97565440281780996e9832ff4ee465bb8858.1548659198.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1548659198.git.lucien.xin@gmail.com>
 <3ca66b981a0fe9368bd976676fe7450634b091cd.1548659198.git.lucien.xin@gmail.com>
 <bf66a45aa6763646c07e1b8be102466f07fc1648.1548659198.git.lucien.xin@gmail.com>
 <16e83f8259873a6818863586e6a3fcb1e2e3717b.1548659198.git.lucien.xin@gmail.com>
 <088bc37947694e4e80302b075f767a7828ea4a05.1548659198.git.lucien.xin@gmail.com>
 <b6b839acf08b7ed5ea06b36156ab3ad8a4a47cf7.1548659198.git.lucien.xin@gmail.com>
 <285500315e06236e468142d80c6557eae4898b36.1548659198.git.lucien.xin@gmail.com>
 <ad87082d72bcf6efccfca7b13adb3a73c72c02ee.1548659198.git.lucien.xin@gmail.com>
 <a6316f97dbdcfbde1104e2296df9d8b24958a7df.1548659198.git.lucien.xin@gmail.com>
 <17140f5cc5fc1961e3e7cf74888affd55e0e6c06.1548659198.git.lucien.xin@gmail.com>
 <ea9e2c6de0c242a440773e99e22a59a72b77776d.1548659198.git.lucien.xin@gmail.com>
 <33a798e9b29f2dcbe6dd132cb801b4960d1411a5.1548659198.git.lucien.xin@gmail.com>
 <d2e888e961165b773dfbf68847af5f2d0ac864c0.1548659198.git.lucien.xin@gmail.com>
 <5d9d0bf635fb89cc3933b256e5e41dd3958c61d6.1548659198.git.lucien.xin@gmail.com>
 <b4094ac0945bbea9ebe455b4357e983400bfe8bb.1548659198.git.lucien.xin@gmail.com>
 <4a601f978a5364fb8f5c4ee97e314eb28087917f.1548659198.git.lucien.xin@gmail.com>
 <1788c2da8ddb39854267ea1321d725635a7c983e.1548659198.git.lucien.xin@gmail.com>
 <70a401b7942eae75d2834dcbefe242f5eb4ad28d.1548659198.git.lucien.xin@gmail.com>
 <a87d5c204cc640751b70c7df7947f4d57a62ab69.1548659198.git.lucien.xin@gmail.com>
 <8cc9dcf9afe96c746c525943dd95d51a804f0126.1548659198.git.lucien.xin@gmail.com>
 <439c70f52f7a642875ab45b7103f586bd09785d2.1548659198.git.lucien.xin@gmail.com>
 <3ec8b9a5111b19fc30d5f6acfdad7cdb771dc04c.1548659198.git.lucien.xin@gmail.com>
 <9f448381e64f109d0e82f25751cd04129b41b493.1548659198.git.lucien.xin@gmail.com>
In-Reply-To: <9f448381e64f109d0e82f25751cd04129b41b493.1548659198.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

Check with SCTP_ALL_ASSOC instead in sctp_setsockopt_event and
check with SCTP_FUTURE_ASSOC instead in sctp_getsockopt_event,
it's compatible with 0.

SCTP_CURRENT_ASSOC is supported for SCTP_EVENT in this patch.

It also adds sctp_assoc_ulpevent_type_set() to make code more
readable.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/socket.c | 77 ++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 48 insertions(+), 29 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 93004c7..00b0f66 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4477,54 +4477,69 @@ static int sctp_setsockopt_reuse_port(struct sock *sk, char __user *optval,
 	return 0;
 }
 
+static int sctp_assoc_ulpevent_type_set(struct sctp_event *param,
+					struct sctp_association *asoc)
+{
+	struct sctp_ulpevent *event;
+
+	sctp_ulpevent_type_set(&asoc->subscribe, param->se_type, param->se_on);
+
+	if (param->se_type = SCTP_SENDER_DRY_EVENT && param->se_on) {
+		if (sctp_outq_is_empty(&asoc->outqueue)) {
+			event = sctp_ulpevent_make_sender_dry_event(asoc,
+					GFP_USER | __GFP_NOWARN);
+			if (!event)
+				return -ENOMEM;
+
+			asoc->stream.si->enqueue_event(&asoc->ulpq, event);
+		}
+	}
+
+	return 0;
+}
+
 static int sctp_setsockopt_event(struct sock *sk, char __user *optval,
 				 unsigned int optlen)
 {
+	struct sctp_sock *sp = sctp_sk(sk);
 	struct sctp_association *asoc;
-	struct sctp_ulpevent *event;
 	struct sctp_event param;
 	int retval = 0;
 
-	if (optlen < sizeof(param)) {
-		retval = -EINVAL;
-		goto out;
-	}
+	if (optlen < sizeof(param))
+		return -EINVAL;
 
 	optlen = sizeof(param);
-	if (copy_from_user(&param, optval, optlen)) {
-		retval = -EFAULT;
-		goto out;
-	}
+	if (copy_from_user(&param, optval, optlen))
+		return -EFAULT;
 
 	if (param.se_type < SCTP_SN_TYPE_BASE ||
-	    param.se_type > SCTP_SN_TYPE_MAX) {
-		retval = -EINVAL;
-		goto out;
-	}
+	    param.se_type > SCTP_SN_TYPE_MAX)
+		return -EINVAL;
 
 	asoc = sctp_id2assoc(sk, param.se_assoc_id);
-	if (!asoc) {
-		sctp_ulpevent_type_set(&sctp_sk(sk)->subscribe,
-				       param.se_type, param.se_on);
-		goto out;
-	}
+	if (!asoc && param.se_assoc_id > SCTP_ALL_ASSOC &&
+	    sctp_style(sk, UDP))
+		return -EINVAL;
 
-	sctp_ulpevent_type_set(&asoc->subscribe, param.se_type, param.se_on);
+	if (asoc)
+		return sctp_assoc_ulpevent_type_set(&param, asoc);
 
-	if (param.se_type = SCTP_SENDER_DRY_EVENT && param.se_on) {
-		if (sctp_outq_is_empty(&asoc->outqueue)) {
-			event = sctp_ulpevent_make_sender_dry_event(asoc,
-					GFP_USER | __GFP_NOWARN);
-			if (!event) {
-				retval = -ENOMEM;
-				goto out;
-			}
+	if (param.se_assoc_id = SCTP_FUTURE_ASSOC ||
+	    param.se_assoc_id = SCTP_ALL_ASSOC)
+		sctp_ulpevent_type_set(&sp->subscribe,
+				       param.se_type, param.se_on);
 
-			asoc->stream.si->enqueue_event(&asoc->ulpq, event);
+	if (param.se_assoc_id = SCTP_CURRENT_ASSOC ||
+	    param.se_assoc_id = SCTP_ALL_ASSOC) {
+		list_for_each_entry(asoc, &sp->ep->asocs, asocs) {
+			int ret = sctp_assoc_ulpevent_type_set(&param, asoc);
+
+			if (ret && !retval)
+				retval = ret;
 		}
 	}
 
-out:
 	return retval;
 }
 
@@ -7696,6 +7711,10 @@ static int sctp_getsockopt_event(struct sock *sk, int len, char __user *optval,
 		return -EINVAL;
 
 	asoc = sctp_id2assoc(sk, param.se_assoc_id);
+	if (!asoc && param.se_assoc_id != SCTP_FUTURE_ASSOC &&
+	    sctp_style(sk, UDP))
+		return -EINVAL;
+
 	subscribe = asoc ? asoc->subscribe : sctp_sk(sk)->subscribe;
 	param.se_on = sctp_ulpevent_type_enabled(subscribe, param.se_type);
 
-- 
2.1.0
