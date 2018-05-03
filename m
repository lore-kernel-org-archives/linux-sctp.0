From: Wenwen Wang <wang6495@umn.edu>
Date: Thu, 03 May 2018 01:15:45 +0000
Subject: [PATCH] sctp: fix a potential missing-check bug
Message-Id: <1525310145-28102-1-git-send-email-wang6495@umn.edu>
List-Id: <linux-sctp.vger.kernel.org>
References: <1525299165-27098-1-git-send-email-wang6495@umn.edu>
In-Reply-To: <1525299165-27098-1-git-send-email-wang6495@umn.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wenwen Wang <wang6495@umn.edu>
Cc: Kangjie Lu <kjlu@umn.edu>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, "David S. Miller" <davem@davemloft.net>, "open list:SCTP PROTOCOL" <linux-sctp@vger.kernel.org>, "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>

In sctp_setsockopt_maxseg(), the integer 'val' is compared against min_len
and max_len to check whether it is in the appropriate range. If it is not,
an error code -EINVAL will be returned. This is enforced by a security
check. But, this check is only executed when 'val' is not 0. In fact, if
'val' is 0, it will be assigned with a new value (if the return value of
the function sctp_id2assoc() is not 0) in the following execution. However,
this new value of 'val' is not checked before it is used to assigned to
asoc->user_frag. That means it is possible that the new value of 'val'
could be out of the expected range. This can cause security issues
such as buffer overflows, e.g., the new value of 'val' is used as an index
to access a buffer.

This patch inserts a check for the new value of 'val' to see if it is in
the expected range. If it is not, an error code -EINVAL will be returned.

Signed-off-by: Wenwen Wang <wang6495@umn.edu>
---
 net/sctp/socket.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 80835ac..03e1cc3 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3212,6 +3212,7 @@ static int sctp_setsockopt_maxseg(struct sock *sk, char __user *optval, unsigned
 	struct sctp_af *af = sp->pf->af;
 	struct sctp_assoc_value params;
 	struct sctp_association *asoc;
+	int min_len, max_len;
 	int val;
 
 	if (optlen = sizeof(int)) {
@@ -3231,19 +3232,15 @@ static int sctp_setsockopt_maxseg(struct sock *sk, char __user *optval, unsigned
 		return -EINVAL;
 	}
 
-	if (val) {
-		int min_len, max_len;
+	min_len = SCTP_DEFAULT_MINSEGMENT - af->net_header_len;
+	min_len -= af->ip_options_len(sk);
+	min_len -= sizeof(struct sctphdr) +
+		   sizeof(struct sctp_data_chunk);
 
-		min_len = SCTP_DEFAULT_MINSEGMENT - af->net_header_len;
-		min_len -= af->ip_options_len(sk);
-		min_len -= sizeof(struct sctphdr) +
-			   sizeof(struct sctp_data_chunk);
+	max_len = SCTP_MAX_CHUNK_LEN - sizeof(struct sctp_data_chunk);
 
-		max_len = SCTP_MAX_CHUNK_LEN - sizeof(struct sctp_data_chunk);
-
-		if (val < min_len || val > max_len)
-			return -EINVAL;
-	}
+	if (val && (val < min_len || val > max_len))
+		return -EINVAL;
 
 	asoc = sctp_id2assoc(sk, params.assoc_id);
 	if (asoc) {
@@ -3253,6 +3250,9 @@ static int sctp_setsockopt_maxseg(struct sock *sk, char __user *optval, unsigned
 			val -= sizeof(struct sctphdr) +
 			       sctp_datachk_len(&asoc->stream);
 		}
+		/* Check the new val to make sure it is in the range. */
+		if (val < min_len || val > max_len)
+			return -EINVAL;
 		asoc->user_frag = val;
 		asoc->frag_point = sctp_frag_point(asoc, asoc->pathmtu);
 	} else {
-- 
2.7.4

