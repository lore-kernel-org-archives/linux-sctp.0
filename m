From: damir.franusic@gmail.com
Date: Fri, 26 Apr 2019 19:39:43 +0000
Subject: [PATCH] sctp_recvmsg man update
Message-Id: <20190426193943.30628-1-damir.franusic@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

From: Damir Franusic <damir.franusic@gmail.com>

* fixes issue #31
---
 man/sctp_recvmsg.3 | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/man/sctp_recvmsg.3 b/man/sctp_recvmsg.3
index a7dede1..7854aec 100644
--- a/man/sctp_recvmsg.3
+++ b/man/sctp_recvmsg.3
@@ -44,7 +44,16 @@ message.
 .I msg_flags
 is a pointer to a integer that is filled with any message flags like
 .B MSG_NOTIFICATION or
-.B MSG_EOR.
+.B MSG_EOR. 
+The value of 
+.I msg_flags 
+pointer should be initialized to 0 to avoid unexpected behavior;
+.I msg_flags
+is also used as an input 
+.I flags 
+argument to 
+.I recvmsg
+function.
 .SH "RETURN VALUE"
 On success,
 .BR sctp_recvmsg
-- 
2.21.0
