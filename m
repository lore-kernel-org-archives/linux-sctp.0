From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 28 Jan 2019 07:08:28 +0000
Subject: [PATCH net-next 06/24] sctp: use SCTP_FUTURE_ASSOC for SCTP_LOCAL_AUTH_CHUNKS sockopt
Message-Id: <285500315e06236e468142d80c6557eae4898b36.1548659198.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1548659198.git.lucien.xin@gmail.com>
 <3ca66b981a0fe9368bd976676fe7450634b091cd.1548659198.git.lucien.xin@gmail.com>
 <bf66a45aa6763646c07e1b8be102466f07fc1648.1548659198.git.lucien.xin@gmail.com>
 <16e83f8259873a6818863586e6a3fcb1e2e3717b.1548659198.git.lucien.xin@gmail.com>
 <088bc37947694e4e80302b075f767a7828ea4a05.1548659198.git.lucien.xin@gmail.com>
 <b6b839acf08b7ed5ea06b36156ab3ad8a4a47cf7.1548659198.git.lucien.xin@gmail.com>
In-Reply-To: <b6b839acf08b7ed5ea06b36156ab3ad8a4a47cf7.1548659198.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

Check with SCTP_FUTURE_ASSOC instead in
sctp_getsockopt_local_auth_chunks, it's compatible with 0.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/socket.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index f38c912..7df2123 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -6767,14 +6767,12 @@ static int sctp_getsockopt_local_auth_chunks(struct sock *sk, int len,
 
 	to = p->gauth_chunks;
 	asoc = sctp_id2assoc(sk, val.gauth_assoc_id);
-	if (!asoc && val.gauth_assoc_id && sctp_style(sk, UDP))
+	if (!asoc && val.gauth_assoc_id != SCTP_FUTURE_ASSOC &&
+	    sctp_style(sk, UDP))
 		return -EINVAL;
 
-	if (asoc)
-		ch = (struct sctp_chunks_param *)asoc->c.auth_chunks;
-	else
-		ch = ep->auth_chunk_list;
-
+	ch = asoc ? (struct sctp_chunks_param *)asoc->c.auth_chunks
+		  : ep->auth_chunk_list;
 	if (!ch)
 		goto num;
 
-- 
2.1.0
