From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Thu, 26 Apr 2018 19:59:01 +0000
Subject: [PATCH net-next 12/13] sctp: consider idata chunks when setting SCTP_MAXSEG
Message-Id: <f5f87da8ce305c2f3e48374f03a6039da715e51b.1524772453.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1524772453.git.marcelo.leitner@gmail.com>
In-Reply-To: <cover.1524772453.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Xin Long <lucien.xin@gmail.com>

When setting SCTP_MAXSEG sock option, it should consider which kind of
data chunk is being used if the asoc is already available, so that the
limit better reflect reality.

Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 net/sctp/socket.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index ad8965835d8d51d4eda857b91dfca140710bf7da..2d35c8ea2470e7f5481bb9675ffd233eb3424d91 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3233,18 +3233,21 @@ static int sctp_setsockopt_maxseg(struct sock *sk, char __user *optval, unsigned
 		return -EINVAL;
 	}
 
+	asoc = sctp_id2assoc(sk, params.assoc_id);
+
 	if (val) {
 		int min_len, max_len;
+		__u16 datasize = asoc ? sctp_datachk_len(&asoc->stream) :
+				 sizeof(struct sctp_data_chunk);
 
 		min_len = sctp_mtu_payload(sp, SCTP_DEFAULT_MINSEGMENT,
-					   sizeof(struct sctp_data_chunk));
-		max_len = SCTP_MAX_CHUNK_LEN - sizeof(struct sctp_data_chunk);
+					   datasize);
+		max_len = SCTP_MAX_CHUNK_LEN - datasize;
 
 		if (val < min_len || val > max_len)
 			return -EINVAL;
 	}
 
-	asoc = sctp_id2assoc(sk, params.assoc_id);
 	if (asoc) {
 		if (val = 0) {
 			val = asoc->pathmtu - af->net_header_len;
-- 
2.14.3

