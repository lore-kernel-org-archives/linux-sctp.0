From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 31 Jul 2018 08:53:11 +0000
Subject: [PATCH lksctp-tools 3/9] peel_server: fix covscan warnings
Message-Id: <e898a930b0c7ea22be9bef6d35469adbd763c2d4.1533027042.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

check the select and listen returned value, and initialize event.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 src/apps/peel_server.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/src/apps/peel_server.c b/src/apps/peel_server.c
index 88545b4..24a1ef8 100644
--- a/src/apps/peel_server.c
+++ b/src/apps/peel_server.c
@@ -466,7 +466,8 @@ poll_fd(int fd)
 	printf("poll_fd\n");
 	FD_SET(fd,&readfds);
 
-	select(max,&readfds,&writefds,&exceptfds,NULL);
+	if (select(max, &readfds, &writefds, &exceptfds, NULL) = -1)
+		return(cameup);
 	if(FD_ISSET(fd,&readfds)){
 		printf("Read please\n");
 		cameup += my_sctpReadInput(fd,4100);
@@ -605,7 +606,7 @@ main(int argc, char **argv)
 	int i,fd;
 	uint16_t myport=0;
 	int magic=0;
-	struct sctp_event_subscribe event;
+	struct sctp_event_subscribe event = {0};
 	while((i= getopt(argc,argv,"m:M:")) != EOF){
 		switch(i){
 		case 'm':
@@ -639,7 +640,11 @@ main(int argc, char **argv)
 		return(-1);
 	}	
 	printf("fd uses port %d\n",ntohs(got.sin_port));
-	listen(fd,100);
+	if (listen(fd, 100) = -1) {
+		printf("listen err: %d\n", errno);
+		close(fd);
+		return(-1);
+	}
 	/* enable all event notifications */
 	event.sctp_data_io_event = 1;
 	event.sctp_association_event = 1;
-- 
2.1.0

