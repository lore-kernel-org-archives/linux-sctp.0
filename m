From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 31 Jul 2018 08:53:09 +0000
Subject: [PATCH lksctp-tools 1/9] myftp: fix covscan warnings
Message-Id: <3946badd1926c4aa2337385307131b6d61f499e3.1533027042.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

add the missing 'break', check the listen returned value, initialize
laddr and remove the useless 'while' check in myftp.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 src/apps/myftp.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/src/apps/myftp.c b/src/apps/myftp.c
index 993e591..64fa3f2 100644
--- a/src/apps/myftp.c
+++ b/src/apps/myftp.c
@@ -161,6 +161,8 @@ static int parse_arguments(int argc, char *argv[])
 				buffer_size = BUFSIZE;
 				fprintf(stderr,"Warning, buffer size too large, set to %d\n",buffer_size);
 			}
+			break;
+
 		case 12:
 		case 'q':	interactive = 0; break;
 
@@ -246,6 +248,7 @@ static int build_endpoint(char *argv0)
 		struct hostent *hst;
 		struct sockaddr_in laddr;
 
+		memset(&laddr, 0, sizeof(laddr));
 		/* Get the transport address for the local host name.  */
 		fprintf(stderr,"Hostname %d is %s\n",i+1,local_host[i]);
 		if ( (hst = gethostbyname(local_host[i])) = NULL ) {
@@ -286,7 +289,8 @@ command_recv(char *argv0, int sk)
 	int fd;
 	int ct;
 
-	listen(sk, 1);
+	if (listen(sk, 1) = -1)
+		emsg(argv0, "listen");
 	/* Initialize inmessage with enough space for DATA... */
 	memset(&inmessage, 0, sizeof(inmessage));
 	iov.iov_base = buffer;
@@ -379,7 +383,7 @@ command_send(char *argv0, int sk)
 			// no flow control? no problem, make it slow
 		else if ( delay > 0 ) 
 			usleep(delay);
-	} while ( msglen > 0 );
+	}
 
 	close(fd);
 	close(sk);
-- 
2.1.0

