From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 28 Jan 2019 07:08:31 +0000
Subject: [PATCH net-next 09/24] sctp: use SCTP_FUTURE_ASSOC for SCTP_RECONFIG_SUPPORTED sockopt
Message-Id: <17140f5cc5fc1961e3e7cf74888affd55e0e6c06.1548659198.git.lucien.xin@gmail.com>
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
In-Reply-To: <a6316f97dbdcfbde1104e2296df9d8b24958a7df.1548659198.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

Check with SCTP_FUTURE_ASSOC instead in
sctp_set/getsockopt_reconfig_supported, it's compatible with 0.

It also adjusts some code to keep a same check form as other functions.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/socket.c | 27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 9e2b153..e5487a1 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4041,15 +4041,14 @@ static int sctp_setsockopt_reconfig_supported(struct sock *sk,
 	}
 
 	asoc = sctp_id2assoc(sk, params.assoc_id);
-	if (asoc) {
-		asoc->reconf_enable = !!params.assoc_value;
-	} else if (!params.assoc_id) {
-		struct sctp_sock *sp = sctp_sk(sk);
-
-		sp->ep->reconf_enable = !!params.assoc_value;
-	} else {
+	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
+	    sctp_style(sk, UDP))
 		goto out;
-	}
+
+	if (asoc)
+		asoc->reconf_enable = !!params.assoc_value;
+	else
+		sctp_sk(sk)->ep->reconf_enable = !!params.assoc_value;
 
 	retval = 0;
 
@@ -7295,17 +7294,15 @@ static int sctp_getsockopt_reconfig_supported(struct sock *sk, int len,
 		goto out;
 
 	asoc = sctp_id2assoc(sk, params.assoc_id);
-	if (asoc) {
-		params.assoc_value = asoc->reconf_enable;
-	} else if (!params.assoc_id) {
-		struct sctp_sock *sp = sctp_sk(sk);
-
-		params.assoc_value = sp->ep->reconf_enable;
-	} else {
+	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
+	    sctp_style(sk, UDP)) {
 		retval = -EINVAL;
 		goto out;
 	}
 
+	params.assoc_value = asoc ? asoc->reconf_enable
+				  : sctp_sk(sk)->ep->reconf_enable;
+
 	if (put_user(len, optlen))
 		goto out;
 
-- 
2.1.0
