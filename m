From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 28 Dec 2016 11:26:35 +0000
Subject: [PATCH RESEND net-next 5/5] sctp: sctp_chunk_length_valid should return bool
Message-Id: <11191de6d1bbf1548f1dc7aa1d1eb0ff469e6998.1482924092.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1482924092.git.marcelo.leitner@gmail.com>
In-Reply-To: <cover.1482924092.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>

Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 net/sctp/sm_statefuns.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 9a223d5b2314ff166be0446462c33219b7eec1b9..3382ef254e7b41ae4723f2e72e5aca30d46a4a8e 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -160,23 +160,22 @@ static sctp_disposition_t __sctp_sf_do_9_1_abort(struct net *net,
 /* Small helper function that checks if the chunk length
  * is of the appropriate length.  The 'required_length' argument
  * is set to be the size of a specific chunk we are testing.
- * Return Values:  1 = Valid length
- * 		   0 = Invalid length
+ * Return Values:  true  = Valid length
+ * 		   false = Invalid length
  *
  */
-static inline int
-sctp_chunk_length_valid(struct sctp_chunk *chunk,
-			   __u16 required_length)
+static inline bool
+sctp_chunk_length_valid(struct sctp_chunk *chunk, __u16 required_length)
 {
 	__u16 chunk_length = ntohs(chunk->chunk_hdr->length);
 
 	/* Previously already marked? */
 	if (unlikely(chunk->pdiscard))
-		return 0;
+		return false;
 	if (unlikely(chunk_length < required_length))
-		return 0;
+		return false;
 
-	return 1;
+	return true;
 }
 
 /**********************************************************
-- 
2.9.3

