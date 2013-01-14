From: Fan Du <fan.du@windriver.com>
Date: Mon, 14 Jan 2013 02:37:31 +0000
Subject: [PATCH] sctp_xconnect: memory leak when malloc big buffer
Message-Id: <1358131051-12636-1-git-send-email-fan.du@windriver.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1357888961-1546-1-git-send-email-fan.du@windriver.com>
In-Reply-To: <1357888961-1546-1-git-send-email-fan.du@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

CLIENT repeatly call process_ready_sockets, which malloc without free,
so sctp_xconnect exit unexpectly. Since SERVER and CLIENT could share
one buffer, so we malloc an global buffer at start.

Signed-off-by: Fan Du <fan.du@windriver.com>
---
 apps/sctp_xconnect.c |   19 ++++++++-----------
 1 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/apps/sctp_xconnect.c b/apps/sctp_xconnect.c
index 5874c33..5be5a34 100644
--- a/apps/sctp_xconnect.c
+++ b/apps/sctp_xconnect.c
@@ -73,6 +73,7 @@ char *remote_host = NULL;
 sockaddr_storage_t client_loop,
 		server_loop;
 struct hostent *hst;
+char *big_buffer;
 
 void usage(char *argv0);
 void parse_arguments(int argc, char*argv[]);
@@ -380,13 +381,8 @@ void server_mode() {
 	int assoc_num =0;
 	struct msghdr inmessage;
 	struct iovec iov;
-	char *big_buffer;
 	char incmsg[CMSG_SPACE(sizeof(sctp_cmsg_data_t))];
 
-	if ((big_buffer = malloc(REALLY_BIG)) = NULL) {
-		printf("malloc failure: %s\n", strerror(errno));
-		DUMP_CORE;
-	}
 
 	printf("Running in Server Mode...\n");
 
@@ -530,15 +526,9 @@ void process_ready_sockets(int client_socket[], int assoc_num, fd_set *rfds) {
         int i, stream, error;
 	struct msghdr inmessage;
 	struct iovec iov;
-	char *big_buffer;
 	char incmsg[CMSG_SPACE(sizeof (sctp_cmsg_data_t))];
 	sockaddr_storage_t msgname;
 
-	if ((big_buffer = malloc(REALLY_BIG)) = NULL) {
-		printf("malloc failure: %s\n", strerror(errno));
-		DUMP_CORE;
-	}
-
         /* Setup inmessage to be able to receive in incomming message */
 	memset(&inmessage, 0, sizeof (inmessage));
 	iov.iov_base = big_buffer;
@@ -579,11 +569,18 @@ int main(int argc, char *argv[]) {
 
 	parse_arguments(argc, argv);
 
+	if ((big_buffer = malloc(REALLY_BIG)) = NULL) {
+		printf("malloc failure: %s\n", strerror(errno));
+		DUMP_CORE;
+	}
+
 	if (mode = SERVER) {
 		server_mode();
 	} else if (mode = CLIENT){
 		client_mode();
 	}
+
+	free (big_buffer);
 	exit(1);
 }
 
-- 
1.7.1

