From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 09 May 2018 02:14:06 +0000
Subject: [PATCH lksctp-tools] func_tests: add a reference to Issue 24
Message-Id: <ce318353a5288076342d5517262e9aa08d4b1c67.1525831854.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

We extended struct sctp_event_subscribe in the kernel UAPI. The change
itself would have been backwards compatible if only the kernel was doing
the right size check, as described at Issue 24.

That said, place a pointer to the known issue in the code to ease it for
who else trip over this.

See-also: https://github.com/sctp/lksctp-tools/issues/24
Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
Note: kernel is not yet fixed. Draft patch is available at the issue
page.

 src/func_tests/test_1_to_1_events.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/src/func_tests/test_1_to_1_events.c b/src/func_tests/test_1_to_1_events.c
index 352534680610248382f8ce6aebe7f97aa49283af..5c0dcc0341efb92ea0e253dabecdc8541b201651 100644
--- a/src/func_tests/test_1_to_1_events.c
+++ b/src/func_tests/test_1_to_1_events.c
@@ -96,6 +96,9 @@ main(int argc, char *argv[])
 	event.sctp_association_event = 1;
 	event.sctp_shutdown_event = 1;
 	len = sizeof(struct sctp_event_subscribe);
+	/* The below may fail due to:
+	 *   - https://github.com/sctp/lksctp-tools/issues/24
+	 */
 	test_setsockopt(svr_sk, SCTP_EVENTS, &event, len);
 	test_setsockopt(clt_sk, SCTP_EVENTS, &event, len);

--
2.14.3

