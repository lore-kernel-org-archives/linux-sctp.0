From: =?UTF-8?q?Diego=20Elio=20Petten=C3=B2?= <flameeyes@gmail.com>
Date: Fri, 03 Sep 2010 13:47:03 +0000
Subject: [PATCH] sctp: implement SIOCINQ ioctl() (take 3)
Message-Id: <1283521623-1609-1-git-send-email-flameeyes@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1277389013-14765-1-git-send-email-flameeyes@gmail.com>
In-Reply-To: <1277389013-14765-1-git-send-email-flameeyes@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, =?UTF-8?q?Diego=20Elio=20'Flameeyes'=20Petten=C3=B2?= <flameeyes@gmail.com>

From: Diego Elio 'Flameeyes' Pettenò <flameeyes@gmail.com>

This simple patch copies the current approach for SIOCINQ ioctl() from DCCP
into SCTP so that the userland code working with SCTP can use a similar
interface across different protocols to know how much space to allocate for
a buffer.

Signed-off-by: Diego Elio Pettenò <flameeyes@gmail.com>
---
 net/sctp/socket.c |   35 ++++++++++++++++++++++++++++++++++-
 1 files changed, 34 insertions(+), 1 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index ca44917..199ec05 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3595,7 +3595,40 @@ out:
 /* The SCTP ioctl handler. */
 SCTP_STATIC int sctp_ioctl(struct sock *sk, int cmd, unsigned long arg)
 {
-	return -ENOIOCTLCMD;
+	int rc = -ENOTCONN;
+
+	sctp_lock_sock(sk);
+
+	/*
+	 * SEQPACKET-style sockets in LISTENING state are valid, for
+	 * SCTP, so only discard TCP-style sockets in LISTENING state.
+	 */
+	if (sctp_style(sk, TCP) && sctp_sstate(sk, LISTENING))
+		goto out;
+
+	switch (cmd) {
+	case SIOCINQ: {
+		struct sk_buff *skb;
+		unsigned int amount = 0;
+
+		skb = skb_peek(&sk->sk_receive_queue);
+		if (skb != NULL) {
+			/*
+			 * We will only return the amount of this packet since
+			 * that is all that will be read.
+			 */
+			amount = skb->len;
+		}
+		rc = put_user(amount, (int __user *)arg);
+	}
+		break;
+	default:
+		rc = -ENOIOCTLCMD;
+		break;
+	}
+out:
+	sctp_release_sock(sk);
+	return rc;
 }
 
 /* This is the function which gets called during socket creation to
-- 
1.7.2.2

