From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 31 Jul 2018 08:53:13 +0000
Subject: [PATCH lksctp-tools 5/9] sctp_test: fix covscan warnings
Message-Id: <9404840a11fac75b057b7e8fb73b5b5d77c09873.1533027042.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

free the allocated memory host_s, host_s and ipaddr, check socket_r
and bind_r returned value, and not close sk twice in sctp_test.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 src/apps/sctp_test.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/src/apps/sctp_test.c b/src/apps/sctp_test.c
index 2a7fb0a..4aa2d13 100644
--- a/src/apps/sctp_test.c
+++ b/src/apps/sctp_test.c
@@ -596,7 +596,7 @@ append_addr(const char *parm, struct sockaddr *addrs, int *ret_count)
 	}
 
  finally:
-
+	free(ipaddr);
 	*ret_count = count;
 
 	return new_addrs;
@@ -697,6 +697,8 @@ int bind_r(int sk, struct sockaddr_storage *saddr)
 		}
         } while (error < 0 && i < MAX_BIND_RETRYS);
 
+	free(host_s);
+	free(serv_s);
 	return 0;
 
 } /* bind_r() */
@@ -1136,10 +1138,8 @@ client(int sk)
 		order_state = next_order(order_state, order_pattern);
 		stream_state = next_stream(stream_state, stream_pattern);
 
-		if (send_r(sk, stream_state, order_state, msg_size, 0) < 0) {
-			close(sk);
+		if (send_r(sk, stream_state, order_state, msg_size, 0) < 0)
 			break;
-		}
 		/* The sender is echoing so do discard the echoed data. */
 		if (drain) {
 			receive_r(sk, 1);
@@ -1398,7 +1398,15 @@ void start_test(int role)
 	}
 
 	sk = socket_r();
-	bind_r(sk, &s_loc);
+	if (sk < 0) {
+		DEBUG_PRINT(DEBUG_NONE, "\nSocket create err %d\n", errno);
+		return;
+	}
+
+	if (bind_r(sk, &s_loc) = -1) {
+		DEBUG_PRINT(DEBUG_NONE, "\nSocket bind err %d\n", errno);
+		return;
+	}
 
 	/* Do we need to do bindx() to add any additional addresses? */
 	if (bindx_add_addrs)
-- 
2.1.0

