From: Hangbin Liu <liuhangbin@gmail.com>
Date: Mon, 28 Oct 2013 09:42:31 +0000
Subject: [lksctp-developers] [PATCH] sctp_status: add missed parameter description and remove unused option
Message-Id: <1382953351-21797-1-git-send-email-liuhangbin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 src/apps/sctp_status.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/src/apps/sctp_status.c b/src/apps/sctp_status.c
index 76f96e4..691052f 100644
--- a/src/apps/sctp_status.c
+++ b/src/apps/sctp_status.c
@@ -127,7 +127,7 @@ int main(int argc, char *argv[]) {
 	struct sockaddr_in6 *t_addr6;
 
 	/* Parse the arguments.  */
-	while ((c = getopt(argc, argv, ":H:L:P:h:p:c:d:lm:sx:X:o:M:r:Di:I:f:")) >= 0 ) {
+	while ((c = getopt(argc, argv, ":H:L:P:h:p:c:d:lm:sx:X:o:M:Di:I:f:")) >= 0 ) {
 		switch (c) {
 		case 'H':
 			local_host = optarg;
@@ -817,6 +817,7 @@ void usage(char *argv0) {
 	fprintf(stderr, "\t-c value = Packets of specifed size.\n");
 	fprintf(stderr, "\t-m msgsize(1500-65515, default value 32768)\n");
 	fprintf(stderr, "\t-x number of repeats\n");
+	fprintf(stderr, "\t-X number of message count\n");
 	fprintf(stderr, "\t-o order-pattern\n");
 	fprintf(stderr, "\t   0 = all unordered(default) \n");
 	fprintf(stderr, "\t   1 = all ordered \n");
@@ -824,6 +825,7 @@ void usage(char *argv0) {
 	fprintf(stderr, "\t   3 = random\n");
 	fprintf(stderr, "\t-M max-stream (default value 0)\n");
 	fprintf(stderr, "\t-D drain. If in client mode do a read following send.\n");
+	fprintf(stderr, "\t-I receive after how many times of send, default is 1.\n");
 	fprintf(stderr, "\n");
 	fflush(stderr);
 
-- 
1.8.1.4

