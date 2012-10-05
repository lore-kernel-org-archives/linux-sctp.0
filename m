From: Masanari Iida <standby24x7@gmail.com>
Date: Fri, 05 Oct 2012 14:50:24 +0000
Subject: [PATCH] net: sctp: Fix typo in socket.c
Message-Id: <1349448624-15060-1-git-send-email-standby24x7@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vyasevich@gmail.com, sri@us.ibm.com, linux-sctp@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Masanari Iida <standby24x7@gmail.com>

Correct spelling typo in net/sctp/socket.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 net/sctp/socket.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index d37d24f..aaeff63 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -973,7 +973,7 @@ SCTP_STATIC int sctp_setsockopt_bindx(struct sock* sk,
 	void *addr_buf;
 	struct sctp_af *af;
 
-	SCTP_DEBUG_PRINTK("sctp_setsocktopt_bindx: sk %p addrs %p"
+	SCTP_DEBUG_PRINTK("sctp_setsockopt_bindx: sk %p addrs %p"
 			  " addrs_size %d opt %d\n", sk, addrs, addrs_size, op);
 
 	if (unlikely(addrs_size <= 0))
-- 
1.8.0.rc0.18.gf84667d

