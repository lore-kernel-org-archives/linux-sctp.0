From: Colin King <colin.king@canonical.com>
Date: Fri, 24 Jul 2020 13:09:19 +0000
Subject: [PATCH][V2] sctp: remove redundant initialization of variable status
Message-Id: <20200724130919.18497-1-colin.king@canonical.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, "David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The variable status is being initialized with a value that is never read
and it is being updated later with a new value.  The initialization is
redundant and can be removed.  Also put the variable declarations into
reverse christmas tree order.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---

V2: put variable declarations into reverse christmas tree order.

---
 net/sctp/protocol.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index 7ecaf7d575c0..d19db22262fd 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -1367,15 +1367,15 @@ static struct pernet_operations sctp_ctrlsock_ops = {
 /* Initialize the universe into something sensible.  */
 static __init int sctp_init(void)
 {
-	int i;
-	int status = -EINVAL;
-	unsigned long goal;
-	unsigned long limit;
 	unsigned long nr_pages = totalram_pages();
+	unsigned long limit;
+	unsigned long goal;
+	int max_entry_order;
+	int num_entries;
 	int max_share;
+	int status;
 	int order;
-	int num_entries;
-	int max_entry_order;
+	int i;
 
 	sock_skb_cb_check_size(sizeof(struct sctp_ulpevent));
 
-- 
2.27.0
