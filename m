From: Colin King <colin.king@canonical.com>
Date: Fri, 24 Jul 2020 12:17:53 +0000
Subject: [PATCH] sctp: remove redundant initialization of variable status
Message-Id: <20200724121753.16721-1-colin.king@canonical.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, "David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The variable status is being initialized with a value that is never read
and it is being updated later with a new value.  The initialization is
redundant and can be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 net/sctp/protocol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index 7ecaf7d575c0..a0448f7c64b9 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -1368,7 +1368,7 @@ static struct pernet_operations sctp_ctrlsock_ops = {
 static __init int sctp_init(void)
 {
 	int i;
-	int status = -EINVAL;
+	int status;
 	unsigned long goal;
 	unsigned long limit;
 	unsigned long nr_pages = totalram_pages();
-- 
2.27.0
