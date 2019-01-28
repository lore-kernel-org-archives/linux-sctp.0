From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 28 Jan 2019 07:08:25 +0000
Subject: [PATCH net-next 03/24] sctp: use SCTP_FUTURE_ASSOC for SCTP_RTOINFO sockopt
Message-Id: <16e83f8259873a6818863586e6a3fcb1e2e3717b.1548659198.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1548659198.git.lucien.xin@gmail.com>
 <3ca66b981a0fe9368bd976676fe7450634b091cd.1548659198.git.lucien.xin@gmail.com>
 <bf66a45aa6763646c07e1b8be102466f07fc1648.1548659198.git.lucien.xin@gmail.com>
In-Reply-To: <bf66a45aa6763646c07e1b8be102466f07fc1648.1548659198.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

Check with SCTP_FUTURE_ASSOC instead in
sctp_set/getsockopt_rtoinfo, it's compatible with 0.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/socket.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 4c43b95..48d6be8 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3145,7 +3145,8 @@ static int sctp_setsockopt_rtoinfo(struct sock *sk, char __user *optval, unsigne
 	asoc = sctp_id2assoc(sk, rtoinfo.srto_assoc_id);
 
 	/* Set the values to the specific association */
-	if (!asoc && rtoinfo.srto_assoc_id && sctp_style(sk, UDP))
+	if (!asoc && rtoinfo.srto_assoc_id != SCTP_FUTURE_ASSOC &&
+	    sctp_style(sk, UDP))
 		return -EINVAL;
 
 	rto_max = rtoinfo.srto_max;
@@ -6298,7 +6299,8 @@ static int sctp_getsockopt_rtoinfo(struct sock *sk, int len,
 
 	asoc = sctp_id2assoc(sk, rtoinfo.srto_assoc_id);
 
-	if (!asoc && rtoinfo.srto_assoc_id && sctp_style(sk, UDP))
+	if (!asoc && rtoinfo.srto_assoc_id != SCTP_FUTURE_ASSOC &&
+	    sctp_style(sk, UDP))
 		return -EINVAL;
 
 	/* Values corresponding to the specific association. */
-- 
2.1.0
