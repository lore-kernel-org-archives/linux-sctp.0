From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Thu, 26 Apr 2018 19:59:02 +0000
Subject: [PATCH net-next 13/13] sctp: allow unsetting sockopt MAXSEG
Message-Id: <6b7e01ddf9be2954d55af5ea37b636a1f2e8bb89.1524772453.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1524772453.git.marcelo.leitner@gmail.com>
In-Reply-To: <cover.1524772453.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Xin Long <lucien.xin@gmail.com>

RFC 6458 Section 8.1.16 says that setting MAXSEG as 0 means that the user
is not limiting it, and not that it should set to the *current* maximum,
as we are doing.

This patch thus allow setting it as 0, effectively removing the user
limit.

Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 net/sctp/socket.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 2d35c8ea2470e7f5481bb9675ffd233eb3424d91..1b4593b842b001903f518e90484c763d9d3698f3 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3211,7 +3211,6 @@ static int sctp_setsockopt_mappedv4(struct sock *sk, char __user *optval, unsign
 static int sctp_setsockopt_maxseg(struct sock *sk, char __user *optval, unsigned int optlen)
 {
 	struct sctp_sock *sp = sctp_sk(sk);
-	struct sctp_af *af = sp->pf->af;
 	struct sctp_assoc_value params;
 	struct sctp_association *asoc;
 	int val;
@@ -3249,12 +3248,6 @@ static int sctp_setsockopt_maxseg(struct sock *sk, char __user *optval, unsigned
 	}
 
 	if (asoc) {
-		if (val = 0) {
-			val = asoc->pathmtu - af->net_header_len;
-			val -= af->ip_options_len(sk);
-			val -= sizeof(struct sctphdr) +
-			       sctp_datachk_len(&asoc->stream);
-		}
 		asoc->user_frag = val;
 		sctp_assoc_update_frag_point(asoc);
 	} else {
-- 
2.14.3

