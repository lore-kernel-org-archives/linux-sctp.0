From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 28 Jan 2019 07:08:46 +0000
Subject: [PATCH net-next 24/24] sctp: add SCTP_FUTURE_ASOC and SCTP_CURRENT_ASSOC for SCTP_STREAM_SCHEDULER s
Message-Id: <8b620a2f4685754ef092e64aa077c6561d09c39f.1548659198.git.lucien.xin@gmail.com>
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
 <402e97565440281780996e9832ff4ee465bb8858.1548659198.git.lucien.xin@gmail.com>
In-Reply-To: <402e97565440281780996e9832ff4ee465bb8858.1548659198.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

Check with SCTP_ALL_ASSOC instead in sctp_setsockopt_scheduler and
check with SCTP_FUTURE_ASSOC instead in sctp_getsockopt_scheduler,
it's compatible with 0.

SCTP_CURRENT_ASSOC is supported for SCTP_STREAM_SCHEDULER in this
patch. It also adds default_ss in sctp_sock to support
SCTP_FUTURE_ASSOC.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/sctp/structs.h |  2 ++
 net/sctp/outqueue.c        |  2 +-
 net/sctp/socket.c          | 44 +++++++++++++++++++++++++++++++-------------
 3 files changed, 34 insertions(+), 14 deletions(-)

diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index a5a46b1..58e4b23 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -211,6 +211,8 @@ struct sctp_sock {
 	/* Flags controlling Heartbeat, SACK delay, and Path MTU Discovery. */
 	__u32 param_flags;
 
+	__u32 default_ss;
+
 	struct sctp_rtoinfo rtoinfo;
 	struct sctp_paddrparams paddrparam;
 	struct sctp_assocparams assocparams;
diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index c37e1c2..fd33281 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -212,7 +212,7 @@ void sctp_outq_init(struct sctp_association *asoc, struct sctp_outq *q)
 	INIT_LIST_HEAD(&q->retransmit);
 	INIT_LIST_HEAD(&q->sacked);
 	INIT_LIST_HEAD(&q->abandoned);
-	sctp_sched_set_sched(asoc, SCTP_SS_DEFAULT);
+	sctp_sched_set_sched(asoc, sctp_sk(asoc->base.sk)->default_ss);
 }
 
 /* Free the outqueue structure and any related pending chunks.
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 00b0f66..9644bdc 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4352,29 +4352,44 @@ static int sctp_setsockopt_scheduler(struct sock *sk,
 				     char __user *optval,
 				     unsigned int optlen)
 {
+	struct sctp_sock *sp = sctp_sk(sk);
 	struct sctp_association *asoc;
 	struct sctp_assoc_value params;
-	int retval = -EINVAL;
+	int retval = 0;
 
 	if (optlen < sizeof(params))
-		goto out;
+		return -EINVAL;
 
 	optlen = sizeof(params);
-	if (copy_from_user(&params, optval, optlen)) {
-		retval = -EFAULT;
-		goto out;
-	}
+	if (copy_from_user(&params, optval, optlen))
+		return -EFAULT;
 
 	if (params.assoc_value > SCTP_SS_MAX)
-		goto out;
+		return -EINVAL;
 
 	asoc = sctp_id2assoc(sk, params.assoc_id);
-	if (!asoc)
-		goto out;
+	if (!asoc && params.assoc_id > SCTP_ALL_ASSOC &&
+	    sctp_style(sk, UDP))
+		return -EINVAL;
 
-	retval = sctp_sched_set_sched(asoc, params.assoc_value);
+	if (asoc)
+		return sctp_sched_set_sched(asoc, params.assoc_value);
+
+	if (params.assoc_id = SCTP_FUTURE_ASSOC ||
+	    params.assoc_id = SCTP_ALL_ASSOC)
+		sp->default_ss = params.assoc_value;
+
+	if (params.assoc_id = SCTP_CURRENT_ASSOC ||
+	    params.assoc_id = SCTP_ALL_ASSOC) {
+		list_for_each_entry(asoc, &sp->ep->asocs, asocs) {
+			int ret = sctp_sched_set_sched(asoc,
+						       params.assoc_value);
+
+			if (ret && !retval)
+				retval = ret;
+		}
+	}
 
-out:
 	return retval;
 }
 
@@ -5005,6 +5020,7 @@ static int sctp_init_sock(struct sock *sk)
 	sp->param_flags = SPP_HB_ENABLE |
 			  SPP_PMTUD_ENABLE |
 			  SPP_SACKDELAY_ENABLE;
+	sp->default_ss = SCTP_SS_DEFAULT;
 
 	/* If enabled no SCTP message fragmentation will be performed.
 	 * Configure through SCTP_DISABLE_FRAGMENTS socket option.
@@ -7572,12 +7588,14 @@ static int sctp_getsockopt_scheduler(struct sock *sk, int len,
 		goto out;
 
 	asoc = sctp_id2assoc(sk, params.assoc_id);
-	if (!asoc) {
+	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
+	    sctp_style(sk, UDP)) {
 		retval = -EINVAL;
 		goto out;
 	}
 
-	params.assoc_value = sctp_sched_get_sched(asoc);
+	params.assoc_value = asoc ? sctp_sched_get_sched(asoc)
+				  : sctp_sk(sk)->default_ss;
 
 	if (put_user(len, optlen))
 		goto out;
-- 
2.1.0
