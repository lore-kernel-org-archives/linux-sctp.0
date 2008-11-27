From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Thu, 27 Nov 2008 02:33:28 +0000
Subject: [PATCH] sctp: Add validity check for SCTP_PARTIAL_DELIVERY_POINT
Message-Id: <492E06F8.2030108@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

The latest ietf socket extensions API draft said:

  8.1.21.  Set or Get the SCTP Partial Delivery Point

    Note also that the call will fail if the user attempts to set
    this value larger than the socket receive buffer size.

This patch add this validity check for SCTP_PARTIAL_DELIVERY_POINT
socket option.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 net/sctp/socket.c |   16 +++++++++++++---
 1 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 3a71475..336e9af 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3010,14 +3010,21 @@ static int sctp_setsockopt_fragment_interleave(struct sock *sk,
 }
 
 /*
- * 7.1.25.  Set or Get the sctp partial delivery point
+ * 8.1.21.  Set or Get the SCTP Partial Delivery Point
  *       (SCTP_PARTIAL_DELIVERY_POINT)
+ *
  * This option will set or get the SCTP partial delivery point.  This
  * point is the size of a message where the partial delivery API will be
  * invoked to help free up rwnd space for the peer.  Setting this to a
- * lower value will cause partial delivery's to happen more often.  The
+ * lower value will cause partial deliveries to happen more often.  The
  * calls argument is an integer that sets or gets the partial delivery
- * point.
+ * point.  Note also that the call will fail if the user attempts to set
+ * this value larger than the socket receive buffer size.
+ *
+ * Note that any single message having a length smaller than or equal to
+ * the SCTP partial delivery point will be delivered in one single read
+ * call as long as the user provided buffer is large enough to hold the
+ * message.
  */
 static int sctp_setsockopt_partial_delivery_point(struct sock *sk,
 						  char __user *optval,
@@ -3030,6 +3037,9 @@ static int sctp_setsockopt_partial_delivery_point(struct sock *sk,
 	if (get_user(val, (int __user *)optval))
 		return -EFAULT;
 
+	if (val > sk->sk_rcvbuf)
+		return -EINVAL;
+
 	sctp_sk(sk)->pd_point = val;
 
 	return 0; /* is this the right error code? */
-- 
1.6.0.2.530.g67faa



