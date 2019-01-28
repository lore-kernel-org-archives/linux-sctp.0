From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 28 Jan 2019 07:08:26 +0000
Subject: [PATCH net-next 04/24] sctp: use SCTP_FUTURE_ASSOC for SCTP_ASSOCINFO sockopt
Message-Id: <088bc37947694e4e80302b075f767a7828ea4a05.1548659198.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1548659198.git.lucien.xin@gmail.com>
 <3ca66b981a0fe9368bd976676fe7450634b091cd.1548659198.git.lucien.xin@gmail.com>
 <bf66a45aa6763646c07e1b8be102466f07fc1648.1548659198.git.lucien.xin@gmail.com>
 <16e83f8259873a6818863586e6a3fcb1e2e3717b.1548659198.git.lucien.xin@gmail.com>
In-Reply-To: <16e83f8259873a6818863586e6a3fcb1e2e3717b.1548659198.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

Check with SCTP_FUTURE_ASSOC instead in
sctp_set/getsockopt_associnfo, it's compatible with 0.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/socket.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 48d6be8..e505e18 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3208,7 +3208,8 @@ static int sctp_setsockopt_associnfo(struct sock *sk, char __user *optval, unsig
 
 	asoc = sctp_id2assoc(sk, assocparams.sasoc_assoc_id);
 
-	if (!asoc && assocparams.sasoc_assoc_id && sctp_style(sk, UDP))
+	if (!asoc && assocparams.sasoc_assoc_id != SCTP_FUTURE_ASSOC &&
+	    sctp_style(sk, UDP))
 		return -EINVAL;
 
 	/* Set the values to the specific association */
@@ -6357,7 +6358,8 @@ static int sctp_getsockopt_associnfo(struct sock *sk, int len,
 
 	asoc = sctp_id2assoc(sk, assocparams.sasoc_assoc_id);
 
-	if (!asoc && assocparams.sasoc_assoc_id && sctp_style(sk, UDP))
+	if (!asoc && assocparams.sasoc_assoc_id != SCTP_FUTURE_ASSOC &&
+	    sctp_style(sk, UDP))
 		return -EINVAL;
 
 	/* Values correspoinding to the specific association */
-- 
2.1.0
