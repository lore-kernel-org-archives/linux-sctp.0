From: Geliang Tang <geliangtang@gmail.com>
Date: Sun, 28 Jun 2020 09:32:25 +0000
Subject: [PATCH net-next] sctp: use list_is_singular in sctp_list_single_entry
Message-Id: <1ae93f6e86ea0baf9ffb4068caed46d951076d12.1593336592.git.geliangtang@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>
Cc: Geliang Tang <geliangtang@gmail.com>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org

Use list_is_singular() instead of open-coding.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 include/net/sctp/sctp.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
index f8bcb75bb044..e3bd198b00ae 100644
--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -412,7 +412,7 @@ static inline void sctp_skb_set_owner_r(struct sk_buff *skb, struct sock *sk)
 /* Tests if the list has one and only one entry. */
 static inline int sctp_list_single_entry(struct list_head *head)
 {
-	return (head->next != head) && (head->next = head->prev);
+	return list_is_singular(head);
 }
 
 static inline bool sctp_chunk_pending(const struct sctp_chunk *chunk)
-- 
2.17.1
