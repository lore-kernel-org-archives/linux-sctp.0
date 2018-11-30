From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 30 Nov 2018 17:36:59 +0000
Subject: [PATCH net] sctp: kfree_rcu asoc
Message-Id: <cbb02c228ba4d3500580bf1fe0792a3b5561517b.1543599419.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>

In sctp_hash_transport/sctp_epaddr_lookup_transport, it dereferences
a transport's asoc under rcu_read_lock while asoc is freed not after
a grace period, which leads to a use-after-free panic.

This patch fixes it by calling kfree_rcu to make asoc be freed after
a grace period.

Note that only the asoc's memory is delayed to free in the patch, it
won't cause sk to linger longer.

Thanks Neil and Marcelo to make this clear.

Fixes: 7fda702f9315 ("sctp: use new rhlist interface on sctp transport rhashtable")
Fixes: cd2b70875058 ("sctp: check duplicate node before inserting a new transport")
Reported-by: syzbot+0b05d8aa7cb185107483@syzkaller.appspotmail.com
Reported-by: syzbot+aad231d51b1923158444@syzkaller.appspotmail.com
Suggested-by: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/sctp/structs.h | 2 ++
 net/sctp/associola.c       | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index a11f937..feada35 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -2075,6 +2075,8 @@ struct sctp_association {
 
 	__u64 abandoned_unsent[SCTP_PR_INDEX(MAX) + 1];
 	__u64 abandoned_sent[SCTP_PR_INDEX(MAX) + 1];
+
+	struct rcu_head rcu;
 };
 
 
diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index 6a28b96..3702f48 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -434,7 +434,7 @@ static void sctp_association_destroy(struct sctp_association *asoc)
 
 	WARN_ON(atomic_read(&asoc->rmem_alloc));
 
-	kfree(asoc);
+	kfree_rcu(asoc, rcu);
 	SCTP_DBG_OBJCNT_DEC(assoc);
 }
 
-- 
2.1.0
