From: Jakub Audykowicz <jakub.audykowicz@gmail.com>
Date: Sun, 18 Nov 2018 20:49:03 +0000
Subject: [PATCH lksctp-tools] func_tests: frag_point should never be zero
Message-Id: <20181118204903.7226-1-jakub.audykowicz@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Introduces a "Fragmentation point is not zero if pmtu is set manually
before connection" test. Reproduces issue described on linux-sctp mailing
list ("sctp: always set frag_point on pmtu change").

Signed-off-by: Jakub Audykowicz <jakub.audykowicz@gmail.com>
---
 src/func_tests/test_fragments.c | 43 ++++++++++++++++++++++++++++++++-
 1 file changed, 42 insertions(+), 1 deletion(-)

diff --git a/src/func_tests/test_fragments.c b/src/func_tests/test_fragments.c
index 7feb2b2..3ca381e 100644
--- a/src/func_tests/test_fragments.c
+++ b/src/func_tests/test_fragments.c
@@ -73,7 +73,7 @@ int msg_sizes[] = {1353, 2000, 5000, 10000, 20000, 32768};
 int
 main(int argc, char *argv[])
 {
-        int sk1, sk2;
+        int sk1, sk2, sk3;
         sockaddr_storage_t loop1;
         sockaddr_storage_t loop2;
         struct iovec iov;
@@ -93,6 +93,10 @@ main(int argc, char *argv[])
 	void *msg_buf;
 	int disable_frag;
 	socklen_t optlen;
+	struct sctp_paddrparams paddr_params = {0};
+	struct sctp_status status;
+	const char send_msg[] = "hello";
+	char recv_msg[sizeof(send_msg)];
 
         /* Rather than fflush() throughout the code, set stdout to 
 	 * be unbuffered. 
@@ -292,6 +296,43 @@ main(int argc, char *argv[])
 				
         close(sk2);
 
+	/* Fragmentation point is not zero if pmtu is set manually
+	 * before connection
+	 */
+	sk1 = test_socket(pf_class, SOCK_STREAM, IPPROTO_SCTP);
+	sk2 = test_socket(pf_class, SOCK_STREAM, IPPROTO_SCTP);
+	test_bind(sk2, &loop2.sa, sizeof(loop2));
+	test_listen(sk2, 1);
+
+	paddr_params.spp_pathmtu = 1000;
+	paddr_params.spp_flags = SPP_PMTUD_DISABLE;
+	test_setsockopt(sk1, SCTP_PEER_ADDR_PARAMS, &paddr_params,
+		sizeof(struct sctp_paddrparams));
+
+	test_connect(sk1, &loop2.sa, sizeof(loop2));
+	sk3 = test_accept(sk2, NULL, NULL);
+
+	optlen = sizeof(struct sctp_status);
+	test_getsockopt(sk1, SCTP_STATUS, &status, &optlen);
+	if (status.sstat_fragmentation_point = 0)
+		tst_brkm(TBROK, tst_exit,
+			"Fragmentation point is not zero if pmtu is set manually"
+			" - fragmentation point is zero");
+
+	test_send(sk1, &send_msg, sizeof(send_msg), 0);
+	test_recv(sk3, &recv_msg, sizeof(recv_msg), 0);
+
+	if (strcmp(send_msg, recv_msg) != 0)
+		tst_brkm(TBROK, tst_exit,
+			"Fragmentation point is not zero if pmtu is set manually"
+			" - received unexpected message");
+
+	tst_resm(TPASS, "Fragmentation point is not zero if pmtu is set manually");
+
+	close(sk1);
+	close(sk2);
+	close(sk3);
+
         /* Indicate successful completion.  */
        	return 0; 
 }
-- 
2.17.1
