From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 17 Nov 2017 06:11:11 +0000
Subject: [PATCH net] sctp: set frag_point in sctp_setsockopt_maxseg correctly
Message-Id: <676049ead9b85fa71b3ccf99e2bf29d0dc826cab.1510899071.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, syzkaller@googlegroups.com, Hangbin Liu <liuhangbin@gmail.com>

Now in sctp_setsockopt_maxseg user_frag or frag_point can be set with
val >= 8 and val <= SCTP_MAX_CHUNK_LEN. But both checks are incorrect.

val >= 8 means frag_point can even be less than SCTP_DEFAULT_MINSEGMENT.
Then in sctp_datamsg_from_user(), when it's value is greater than cookie
echo len and trying to bundle with cookie echo chunk, the first_len will
overflow.

The worse case is when it's value is equal as cookie echo len, first_len
becomes 0, it will go into a dead loop for fragment later on. In Hangbin
syzkaller testing env, oom was even triggered due to consecutive memory
allocation in that loop.

Besides, SCTP_MAX_CHUNK_LEN is the max size of the whole chunk, it should
deduct the data header for frag_point or user_frag check.

This patch does a proper check with SCTP_DEFAULT_MINSEGMENT subtracting
the sctphdr and datahdr, SCTP_MAX_CHUNK_LEN subtracting datahdr when
setting frag_point via sockopt. It also improves sctp_setsockopt_maxseg
codes.

Suggested-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Reported-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/sctp/sctp.h |  3 ++-
 net/sctp/socket.c       | 29 +++++++++++++++++++----------
 2 files changed, 21 insertions(+), 11 deletions(-)

diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
index d7d8cba..749a428 100644
--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -444,7 +444,8 @@ static inline int sctp_frag_point(const struct sctp_association *asoc, int pmtu)
 	if (asoc->user_frag)
 		frag = min_t(int, frag, asoc->user_frag);
 
-	frag = SCTP_TRUNC4(min_t(int, frag, SCTP_MAX_CHUNK_LEN));
+	frag = SCTP_TRUNC4(min_t(int, frag, SCTP_MAX_CHUNK_LEN -
+					    sizeof(struct sctp_data_chunk)));
 
 	return frag;
 }
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 4c0a772..3204a9b 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3140,9 +3140,9 @@ static int sctp_setsockopt_mappedv4(struct sock *sk, char __user *optval, unsign
  */
 static int sctp_setsockopt_maxseg(struct sock *sk, char __user *optval, unsigned int optlen)
 {
+	struct sctp_sock *sp = sctp_sk(sk);
 	struct sctp_assoc_value params;
 	struct sctp_association *asoc;
-	struct sctp_sock *sp = sctp_sk(sk);
 	int val;
 
 	if (optlen = sizeof(int)) {
@@ -3158,26 +3158,35 @@ static int sctp_setsockopt_maxseg(struct sock *sk, char __user *optval, unsigned
 		if (copy_from_user(&params, optval, optlen))
 			return -EFAULT;
 		val = params.assoc_value;
-	} else
+	} else {
 		return -EINVAL;
+	}
 
-	if ((val != 0) && ((val < 8) || (val > SCTP_MAX_CHUNK_LEN)))
-		return -EINVAL;
+	if (val) {
+		int min_len, max_len;
 
-	asoc = sctp_id2assoc(sk, params.assoc_id);
-	if (!asoc && params.assoc_id && sctp_style(sk, UDP))
-		return -EINVAL;
+		min_len = SCTP_DEFAULT_MINSEGMENT - sp->pf->af->net_header_len;
+		min_len -= sizeof(struct sctphdr) +
+			   sizeof(struct sctp_data_chunk);
+
+		max_len = SCTP_MAX_CHUNK_LEN - sizeof(struct sctp_data_chunk);
 
+		if (val < min_len || val > max_len)
+			return -EINVAL;
+	}
+
+	asoc = sctp_id2assoc(sk, params.assoc_id);
 	if (asoc) {
 		if (val = 0) {
-			val = asoc->pathmtu;
-			val -= sp->pf->af->net_header_len;
+			val = asoc->pathmtu - sp->pf->af->net_header_len;
 			val -= sizeof(struct sctphdr) +
-					sizeof(struct sctp_data_chunk);
+			       sizeof(struct sctp_data_chunk);
 		}
 		asoc->user_frag = val;
 		asoc->frag_point = sctp_frag_point(asoc, asoc->pathmtu);
 	} else {
+		if (params.assoc_id && sctp_style(sk, UDP))
+			return -EINVAL;
 		sp->user_frag = val;
 	}
 
-- 
2.1.0

