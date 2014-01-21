From: Wang Weidong <wangweidong1@huawei.com>
Date: Tue, 21 Jan 2014 07:44:10 +0000
Subject: [PATCH net-next 5/7] sctp: remove macros sctp_read_[un]lock
Message-Id: <1390290252-16080-6-git-send-email-wangweidong1@huawei.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1390290252-16080-1-git-send-email-wangweidong1@huawei.com>
In-Reply-To: <1390290252-16080-1-git-send-email-wangweidong1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: nhorman@tuxdriver.com, davem@davemloft.net, vyasevich@gmail.com
Cc: dborkman@redhat.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org

Redefined read_[un]lock to sctp_read_[un]lock for user space
friendly code which we haven't use in years, and the macros
we never used, so removing them.

Signed-off-by: Wang Weidong <wangweidong1@huawei.com>
---
 include/net/sctp/sctp.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
index 73dcc0c..572cd5a 100644
--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -170,10 +170,6 @@ extern struct kmem_cache *sctp_bucket_cachep __read_mostly;
  *  Section:  Macros, externs, and inlines
  */
 
-/* spin lock wrappers. */
-#define sctp_read_lock(lock)    read_lock(lock)
-#define sctp_read_unlock(lock)  read_unlock(lock)
-
 /* sock lock wrappers. */
 #define sctp_lock_sock(sk)       lock_sock(sk)
 #define sctp_release_sock(sk)    release_sock(sk)
-- 
1.7.12


