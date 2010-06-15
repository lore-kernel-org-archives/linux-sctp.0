From: =?UTF-8?q?Diego=20Elio=20=27Flameeyes=27=20Petten=C3=B2?=
Date: Tue, 15 Jun 2010 16:24:52 +0000
Subject: [PATCH 1/2] Avoid warning "cast to pointer from integer of different size"
Message-Id: <1276619093-3880-2-git-send-email-flameeyes@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

---
 src/func_tests/test_1_to_1_threads.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/src/func_tests/test_1_to_1_threads.c b/src/func_tests/test_1_to_1_threads.c
index 84b9fb2..bc843df 100644
--- a/src/func_tests/test_1_to_1_threads.c
+++ b/src/func_tests/test_1_to_1_threads.c
@@ -174,7 +174,7 @@ main(void)
 	for ( i = 0; i < THREAD_SND_RCV_LOOPS; i++ ) {
 		for (cnt = 1; cnt < THREADS; cnt++) {
 			status = pthread_create(&thread[cnt], &attr,
-						(void *)relay, (void*)cnt);
+						(void *)relay, (void*)(long)cnt);
 			if (status)
 				tst_brkm(TBROK, tst_exit, "pthread_create "
                          		 "failed status:%d, errno:%d", status,
-- 
1.7.1

