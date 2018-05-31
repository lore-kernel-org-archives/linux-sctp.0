From: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Date: Thu, 31 May 2018 12:18:00 +0000
Subject: [PATCH] sctp: use non-archaic spelling of failes
Message-Id: <20180531121800.9035-1-cascardo@canonical.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
---
 net/sctp/sm_statefuns.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index c9ae3404b1bb..b71d8e211f50 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -3482,7 +3482,7 @@ enum sctp_disposition sctp_sf_do_9_2_final(struct net *net,
 		goto nomem_chunk;
 
 	/* Do all the commands now (after allocation), so that we
-	 * have consistent state if memory allocation failes
+	 * have consistent state if memory allocation fails
 	 */
 	sctp_add_cmd_sf(commands, SCTP_CMD_EVENT_ULP, SCTP_ULPEVENT(ev));
 
-- 
2.17.0

