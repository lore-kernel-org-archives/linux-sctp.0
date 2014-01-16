From: Wang Weidong <wangweidong1@huawei.com>
Date: Thu, 16 Jan 2014 08:25:19 +0000
Subject: [PATCH net-next] sctp: remove the unnecessary assignment
Message-Id: <52D7976F.7070708@huawei.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Neil Horman <nhorman@tuxdriver.com>, David Miller <davem@davemloft.net>, Vlad Yasevich <vyasevich@gmail.com>
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

When go the right path, the status is 0, no need to assign it again.
So just remove the assignment.

Signed-off-by: Wang Weidong <wangweidong1@huawei.com>
---
 net/sctp/protocol.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index 7c16108..d6934dc 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -1461,7 +1461,6 @@ static __init int sctp_init(void)
 	if (status)
 		goto err_v6_add_protocol;
 
-	status = 0;
 out:
 	return status;
 err_v6_add_protocol:
-- 
1.7.12


