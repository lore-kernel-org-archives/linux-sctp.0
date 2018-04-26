From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Thu, 26 Apr 2018 19:58:56 +0000
Subject: [PATCH net-next 07/13] sctp: remove sctp_assoc_pending_pmtu
Message-Id: <9b74ba9efb97c65bb6f670c51953c6e92e50eed1.1524772453.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1524772453.git.marcelo.leitner@gmail.com>
In-Reply-To: <cover.1524772453.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Xin Long <lucien.xin@gmail.com>

No need for this helper.

Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 include/net/sctp/sctp.h | 6 ------
 net/sctp/socket.c       | 6 ++++--
 2 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
index 350c65620a4eb35ba2af0d59fef70e2b8b461e44..e327acad8e7d0710e30f32d0829116593c1171cf 100644
--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -428,12 +428,6 @@ static inline int sctp_list_single_entry(struct list_head *head)
 	return (head->next != head) && (head->next = head->prev);
 }
 
-static inline void sctp_assoc_pending_pmtu(struct sctp_association *asoc)
-{
-	sctp_assoc_sync_pmtu(asoc);
-	asoc->pmtu_pending = 0;
-}
-
 static inline bool sctp_chunk_pending(const struct sctp_chunk *chunk)
 {
 	return !list_empty(&chunk->list);
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 21bf457be3ea321457107256c12ccb93e1fbab06..a93b60a28cc5fff0ebe299905fb31cb37de43d88 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -1918,8 +1918,10 @@ static int sctp_sendmsg_to_asoc(struct sctp_association *asoc,
 		goto err;
 	}
 
-	if (asoc->pmtu_pending)
-		sctp_assoc_pending_pmtu(asoc);
+	if (asoc->pmtu_pending) {
+		sctp_assoc_sync_pmtu(asoc);
+		asoc->pmtu_pending = 0;
+	}
 
 	if (sctp_wspace(asoc) < msg_len)
 		sctp_prsctp_prune(asoc, sinfo, msg_len - sctp_wspace(asoc));
-- 
2.14.3

