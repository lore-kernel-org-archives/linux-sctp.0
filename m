From: Alexey Dobriyan <adobriyan@gmail.com>
Date: Sun, 23 Aug 2009 19:11:36 +0000
Subject: [PATCH] sctp: use proc_create()
Message-Id: <20090823191136.GA4912@x200.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

create_proc_entry() is deprecated (not formally, though).

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 net/sctp/proc.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/net/sctp/proc.c
+++ b/net/sctp/proc.c
@@ -512,10 +512,8 @@ int __init sctp_remaddr_proc_init(void)
 {
 	struct proc_dir_entry *p;
 
-	p = create_proc_entry("remaddr", S_IRUGO, proc_net_sctp);
+	p = proc_create("remaddr", S_IRUGO, proc_net_sctp, &sctp_remaddr_seq_fops);
 	if (!p)
 		return -ENOMEM;
-	p->proc_fops = &sctp_remaddr_seq_fops;
-
 	return 0;
 }
