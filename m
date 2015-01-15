From: Simon Xu <xu.simon@oracle.com>
Date: Thu, 15 Jan 2015 07:39:35 +0000
Subject: [PATCH] also expect EACCES when accept on an established socket
Message-Id: <1421307575-28655-1-git-send-email-xu.simon@oracle.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

When SELinux is set to enforcing, errno may be EACCES when accept
on an established socket.

Signed-off-by: Simon Xu <xu.simon@oracle.com>
---
 src/func_tests/test_1_to_1_accept_close.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/src/func_tests/test_1_to_1_accept_close.c b/src/func_tests/test_1_to_1_accept_close.c
index cbb1814..0e9e9c1 100644
--- a/src/func_tests/test_1_to_1_accept_close.c
+++ b/src/func_tests/test_1_to_1_accept_close.c
@@ -175,13 +175,15 @@ main(int argc, char *argv[])
 	/*Calling accept to establish the connection*/
 	acpt_sk = test_accept(lstn_sk, (struct sockaddr *) &acpt_addr, &len);
 
-	/*accept() TEST5: On a established socket EINVAL, Expected error*/
+	/*accept() TEST5: On a established socket EINVAL or EACCES when
+	SELinux set to enforcing, Expected error*/
 	error = accept(acpt_sk, (struct sockaddr *) &acpt_addr, &len);
-	if (error != -1 || errno != EINVAL)
+	if (error != -1 || (errno != EINVAL && errno != EACCES)) {
 		tst_brkm(TBROK, tst_exit, "accept on an established socket"
-                         "error:%d, errno:%d", error, errno);
+			"error:%d, errno:%d", error, errno);
+	}
 
-	tst_resm(TPASS, "accept() on an established socket - EINVAL");
+	tst_resm(TPASS, "accept() on an established socket - %d", errno);
 
 	/*Closing the previously established association*/
 	close(acpt_sk);
-- 
2.2.2

