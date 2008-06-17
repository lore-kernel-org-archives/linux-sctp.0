From: Pavel Emelyanov <xemul@openvz.org>
Date: Tue, 17 Jun 2008 12:29:13 +0000
Subject: [PATCH] sctp: fix error path in sctp_proc_init
Message-Id: <4857AE19.9050708@openvz.org>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlad Yasevich <vladislav.yasevich@hp.com>, David Miller <davem@davemloft.net>
Cc: linux-sctp@vger.kernel.org, Linux Netdev List <netdev@vger.kernel.org>

After the sctp_remaddr_proc_init failed, the proper rollback is
not the sctp_remaddr_proc_exit, but the sctp_assocs_proc_exit.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---

diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index 23aaffb..98c6a88 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -119,7 +119,7 @@ static __init int sctp_proc_init(void)
 	return 0;
 
 out_remaddr_proc_init:
-	sctp_remaddr_proc_exit();
+	sctp_assocs_proc_exit();
 out_assocs_proc_init:
 	sctp_eps_proc_exit();
 out_eps_proc_init:
