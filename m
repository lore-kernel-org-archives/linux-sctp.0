From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 31 Jul 2018 08:53:12 +0000
Subject: [PATCH lksctp-tools 4/9] sctp_darn: fix covscan warnings
Message-Id: <d59772f49248274bec8f83c53a7aac89e365c86f.1533027042.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

check sendto returned value, initialize outmsg.msg_flags, and
return if 'parm' is NULL in append_addr in sctp_darn.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 src/apps/sctp_darn.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/src/apps/sctp_darn.c b/src/apps/sctp_darn.c
index 90a5c42..bcfb822 100644
--- a/src/apps/sctp_darn.c
+++ b/src/apps/sctp_darn.c
@@ -731,9 +731,14 @@ command_listen(char *argv0, int sk)
 
 		if (echo) {
 			if( !(MSG_NOTIFICATION & inmessage.msg_flags)) {
-				sendto(recvsk, inmessage.msg_iov->iov_base,
-				       error, 0, (struct sockaddr *)&msgname,
-				       sizeof(msgname));
+				if (sendto(recvsk, inmessage.msg_iov->iov_base,
+					   error, 0,
+					   (struct sockaddr *)&msgname,
+					   sizeof(msgname)) = -1) {
+					fprintf(stderr, "%s: error: %s.\n",
+						argv0, strerror(errno));
+					exit(1);
+				}
 			}
 		}
 
@@ -950,6 +955,7 @@ command_send(char *argv0, int *skp)
 				outmsg.msg_controllen = 0;
 				outmsg.msg_name = &remote_addr;
 				outmsg.msg_namelen = ra_len;
+				outmsg.msg_flags = 0;
 
 				error = sendmsg(sk, &outmsg, 0);
 			} else {
@@ -1086,6 +1092,7 @@ command_poll(char *argv0)
 		outmsg.msg_controllen = 0;
 		outmsg.msg_name = &remote_addr;
 		outmsg.msg_namelen = ra_len;
+		outmsg.msg_flags = 0;
 	}
 
 
@@ -1412,6 +1419,8 @@ append_addr(const char *parm, struct sockaddr *addrs, int *ret_count)
 	int count = orig_count;
 
 
+	if (!parm)
+		return NULL;
 	/* Get the entries for this host.  */
 	hst4 = gethostbyname(parm);
 	hst6 = gethostbyname2(parm, AF_INET6);
-- 
2.1.0

