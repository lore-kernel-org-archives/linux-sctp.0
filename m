From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 31 Jul 2018 08:53:10 +0000
Subject: [PATCH lksctp-tools 2/9] peel_client: fix covscan warnings
Message-Id: <d695f370e856d27c8a0caa14d4440748a89b1ecd.1533027042.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

initialize msg.msg_flags and event, and check 'select' returned value
in peel_client.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 src/apps/peel_client.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/src/apps/peel_client.c b/src/apps/peel_client.c
index f604349..5c195d3 100644
--- a/src/apps/peel_client.c
+++ b/src/apps/peel_client.c
@@ -446,6 +446,7 @@ my_sctpReadInput(int fd)
 	msg.msg_iovlen = 1;
 	msg.msg_control = (caddr_t)controlVector;
 	msg.msg_controllen = sizeof(controlVector);
+	msg.msg_flags = 0;
 	errno = 0;
 	sz = recvmsg(fd,&msg,0);
 	if(sz <= 0){
@@ -483,7 +484,8 @@ clear_fds(int fd,int fd1)
 	}
 	notdone = 1;
 	while(notdone){
-		select(max,&readfds,&writefds,&exceptfds,&tv);
+		if (select(max, &readfds, &writefds, &exceptfds, &tv) = -1)
+			break;
 		notdone = 0;
 		if(FD_ISSET(fd,&readfds)){
 			notdone++;
@@ -553,7 +555,7 @@ main(int argc, char **argv)
 	char *addr=NULL;
 	uint16_t port=0;
 	int protocol_touse = IPPROTO_SCTP;
-	struct sctp_event_subscribe event;
+	struct sctp_event_subscribe event = {0};
 
 	while((i= getopt(argc,argv,"p:h:")) != EOF){
 		switch(i){
-- 
2.1.0

