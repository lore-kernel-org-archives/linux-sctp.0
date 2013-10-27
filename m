From: Hangbin Liu <liuhangbin@gmail.com>
Date: Sun, 27 Oct 2013 02:55:49 +0000
Subject: [lksctp-developers] [PATCH] test_1_to_1_sockopt: we have changed the Minimum value to 2048
Message-Id: <1382842549-527-1-git-send-email-liuhangbin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 src/func_tests/test_1_to_1_sockopt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/func_tests/test_1_to_1_sockopt.c b/src/func_tests/test_1_to_1_sockopt.c
index 37aac1d..ca5a1b9 100644
--- a/src/func_tests/test_1_to_1_sockopt.c
+++ b/src/func_tests/test_1_to_1_sockopt.c
@@ -299,7 +299,7 @@ main(void)
 	tst_resm(TPASS, "getsockopt() SCTP_STATUS - SUCCESS");
 
 	/* Reducing the SO_RCVBUF value using setsockopt() */
-	/*Minimum value is 128 and hence I am using it*/
+	/* upstream have change the MIN_RCVBUF (2048 + sizeof(struct sk_buff)) */
 	len = sizeof(int);
 	rcvbuf_val_set = 2048;
 	/* TEST16: Test case for setsockopt SO_RCVBUF */
-- 
1.8.1.4

