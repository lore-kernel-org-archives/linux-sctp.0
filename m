From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Fri, 26 Feb 2010 03:19:32 +0000
Subject: [PATCH 3/3] sctp_test: add -O option for specifying live time of
Message-Id: <4B873DC4.40800@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

This patch add -O option to sctp_test for specifying live
time of messages. Use for PRSCTP test.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 src/apps/sctp_test.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/src/apps/sctp_test.c b/src/apps/sctp_test.c
index 127f50e..7287d05 100644
--- a/src/apps/sctp_test.c
+++ b/src/apps/sctp_test.c
@@ -156,6 +156,7 @@ int order_state = 0;
 int max_stream = 0;
 int seed = 0;
 int max_msgsize = DEFAULT_MAX_WINDOW;
+int timetolive = 0;
 int assoc_pattern = ASSOC_PATTERN_SEQUENTIAL;
 int socket_type = SOCK_SEQPACKET;
 int repeat_count = 0;
@@ -260,6 +261,7 @@ void usage(char *argv0)
 	fprintf(stderr, "\t   using this argument multiple times.\n");
 	fprintf(stderr, "\t   For example, '-C 10.0.0.1 -C 20.0.0.2'.\n");
 	fprintf(stderr, "\t   This option is incompatible with the -h option.\n");
+	fprintf(stderr, "\t-O time to live (default value 0)\n");
 	fprintf(stderr, "\n");
 	fflush(stderr);
 
@@ -1024,6 +1026,8 @@ int send_r(int sk, int stream, int order, int send_size, int assoc_i)
 	sinfo->sinfo_flags = 0;
 	if (!order)
 		sinfo->sinfo_flags = SCTP_UNORDERED;
+	if (timetolive)
+		sinfo->sinfo_timetolive = timetolive;
 
 	DEBUG_PRINT(DEBUG_MIN, "\tsendmsg(sk=%d, assoc=%d) %4d bytes.\n",
 		    sk, assoc_i, send_size);
@@ -1418,7 +1422,7 @@ main(int argc, char *argv[])
 	struct sockaddr *tmp_addrs = NULL;
 	
         /* Parse the arguments.  */
-        while ((c = getopt(argc, argv, ":H:L:P:S:a:h:p:c:d:lm:sx:X:o:t:M:r:w:Di:TB:C:")) >= 0 ) {
+        while ((c = getopt(argc, argv, ":H:L:P:S:a:h:p:c:d:lm:sx:X:o:t:M:r:w:Di:TB:C:O:")) >= 0 ) {
 
                 switch (c) {
 		case 'H':
@@ -1518,6 +1522,13 @@ main(int argc, char *argv[])
 				exit(1);
 			}
 			break;
+		case 'O':
+			timetolive = atoi(optarg);
+			if (timetolive < 0) {
+				usage(argv[0]);
+				exit(1);
+			}
+			break;
 		case 't':
 			stream_pattern = atoi(optarg);
 			if (stream_pattern <  STREAM_PATTERN_SEQUENTIAL
-- 
1.6.5.2


