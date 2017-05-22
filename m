From: SF Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 22 May 2017 16:38:21 +0000
Subject: [PATCH 2/5] sctp: Delete an error message for a failed memory allocation in sctp_init()
Message-Id: <7db0cb49-109b-88a6-532f-c591cc8ffa85@users.sourceforge.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <2845df67-d35d-536a-0a53-b2eb83fe1ba5@users.sourceforge.net>
In-Reply-To: <2845df67-d35d-536a-0a53-b2eb83fe1ba5@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org, netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 22 May 2017 17:28:14 +0200

Omit an extra message for a memory allocation failure in this function.

This issue was detected by using the Coccinelle software.

Link: http://events.linuxfoundation.org/sites/events/files/slides/LCJ16-Refactor_Strings-WSang_0.pdf
Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 net/sctp/protocol.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index 2b1a6215bd2f..5e7c8a344770 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -1447,5 +1447,4 @@ static __init int sctp_init(void)
 	if (!sctp_ep_hashtable) {
-		pr_err("Failed endpoint_hash alloc\n");
 		status = -ENOMEM;
 		goto err_ehash_alloc;
 	}
-- 
2.13.0

