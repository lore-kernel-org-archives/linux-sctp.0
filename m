From: Shan Wei <shanwei@cn.fujitsu.com>
Date: Fri, 03 Sep 2010 06:52:31 +0000
Subject: [PATCH] sctp_test: don't specifc the destination address when sendint
Message-Id: <4C809B2F.3020904@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org



For multi-home mode, don't need to specific msg_name.
If msg_name is set, this will force sctp send data to the destination address
to which msg_name is pointed.
So, this patch will cause sctp to choose primary path to send data.

Signed-off-by: Shan Wei <shanwei@cn.fujitsu.com>
---
 src/apps/sctp_test.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/src/apps/sctp_test.c b/src/apps/sctp_test.c
index 7287d05..7922686 100644
--- a/src/apps/sctp_test.c
+++ b/src/apps/sctp_test.c
@@ -1005,8 +1005,14 @@ int send_r(int sk, int stream, int order, int send_size, int assoc_i)
 		}
 	}
 
-	outmsg.msg_name = &s_rem;
-       	outmsg.msg_namelen = sizeof(struct sockaddr_storage);
+	if (connectx_count != 0) {	
+		outmsg.msg_name = NULL;
+		outmsg.msg_namelen = 0;
+	}
+	else {
+		outmsg.msg_name = &s_rem;
+		outmsg.msg_namelen = sizeof(struct sockaddr_storage);
+	}
 	outmsg.msg_iov = &iov;
 	outmsg.msg_iovlen = 1;
 	outmsg.msg_control = outcmsg;
-- 
1.6.3.3
