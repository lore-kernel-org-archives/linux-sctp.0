From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri, 01 Apr 2016 17:30:32 +0000
Subject: [PATCH v2] sctp: use list_* in sctp_list_dequeue
Message-Id: <729a27385f91aacaee46ecfa6f37f084f2843b9c.1459530791.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>, linux-sctp@vger.kernel.org

Use list_* helpers in sctp_list_dequeue, more readable.

Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
v2: patch rechecked

 include/net/sctp/sctp.h | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
index 65521cfdcadeee35d61f280165a387cc2164ab6d..03fb33efcae21d54192204629ff4ced2e36e7d4d 100644
--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -386,11 +386,9 @@ static inline struct list_head *sctp_list_dequeue(struct list_head *list)
 {
 	struct list_head *result = NULL;
 
-	if (list->next != list) {
+	if (!list_empty(list)) {
 		result = list->next;
-		list->next = result->next;
-		list->next->prev = list;
-		INIT_LIST_HEAD(result);
+		list_del_init(result);
 	}
 	return result;
 }
-- 
2.5.0

