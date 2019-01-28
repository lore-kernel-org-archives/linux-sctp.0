From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 28 Jan 2019 07:08:33 +0000
Subject: [PATCH net-next 11/24] sctp: add SCTP_CURRENT_ASSOC for SCTP_STREAM_SCHEDULER_VALUE sockopt
Message-Id: <33a798e9b29f2dcbe6dd132cb801b4960d1411a5.1548659198.git.lucien.xin@gmail.com>
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
In-Reply-To: <ea9e2c6de0c242a440773e99e22a59a72b77776d.1548659198.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

SCTP_STREAM_SCHEDULER_VALUE is a special one, as its value is not
save in sctp_sock, but only in asoc. So only SCTP_CURRENT_ASSOC
reserved assoc_id can be used in sctp_setsockopt_scheduler_value.

This patch adds SCTP_CURRENT_ASOC support for
SCTP_STREAM_SCHEDULER_VALUE.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/socket.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index b9263ad..bf91591 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4211,8 +4211,8 @@ static int sctp_setsockopt_scheduler_value(struct sock *sk,
 					   char __user *optval,
 					   unsigned int optlen)
 {
-	struct sctp_association *asoc;
 	struct sctp_stream_value params;
+	struct sctp_association *asoc;
 	int retval = -EINVAL;
 
 	if (optlen < sizeof(params))
@@ -4225,11 +4225,24 @@ static int sctp_setsockopt_scheduler_value(struct sock *sk,
 	}
 
 	asoc = sctp_id2assoc(sk, params.assoc_id);
-	if (!asoc)
+	if (!asoc && params.assoc_id != SCTP_CURRENT_ASSOC &&
+	    sctp_style(sk, UDP))
 		goto out;
 
-	retval = sctp_sched_set_value(asoc, params.stream_id,
-				      params.stream_value, GFP_KERNEL);
+	if (asoc) {
+		retval = sctp_sched_set_value(asoc, params.stream_id,
+					      params.stream_value, GFP_KERNEL);
+		goto out;
+	}
+
+	retval = 0;
+
+	list_for_each_entry(asoc, &sctp_sk(sk)->ep->asocs, asocs) {
+		int ret = sctp_sched_set_value(asoc, params.stream_id,
+					       params.stream_value, GFP_KERNEL);
+		if (ret && !retval) /* try to return the 1st error. */
+			retval = ret;
+	}
 
 out:
 	return retval;
-- 
2.1.0
