From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 13 Nov 2017 05:47:58 +0000
Subject: [PATCH net] sctp: add wait_buf flag in asoc to avoid the peeloff and wait sndbuf race
Message-Id: <b6b9359b3f45a81d00f2ae108e871b2f1113f87a.1510552078.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>

Commit dfcb9f4f99f1 ("sctp: deny peeloff operation on asocs with threads
sleeping on it") fixed the race between peeloff and wait sndbuf by
checking waitqueue_active(&asoc->wait) in sctp_do_peeloff().

But it actually doesn't work as even if waitqueue_active returns false
the waiting sndbuf thread may still not yet hold sk lock.

This patch is to fix this by adding wait_buf flag in asoc, and setting it
before going the waiting loop, clearing it until the waiting loop breaks,
and checking it in sctp_do_peeloff instead.

Fixes: dfcb9f4f99f1 ("sctp: deny peeloff operation on asocs with threads sleeping on it")
Suggested-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/sctp/structs.h | 1 +
 net/sctp/socket.c          | 4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 0477945..446350e 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -1883,6 +1883,7 @@ struct sctp_association {
 
 	__u8 need_ecne:1,	/* Need to send an ECNE Chunk? */
 	     temp:1,		/* Is it a temporary association? */
+	     wait_buf:1,
 	     force_delay:1,
 	     prsctp_enable:1,
 	     reconf_enable:1;
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 6f45d17..1b2c78c 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4946,7 +4946,7 @@ int sctp_do_peeloff(struct sock *sk, sctp_assoc_t id, struct socket **sockp)
 	/* If there is a thread waiting on more sndbuf space for
 	 * sending on this asoc, it cannot be peeled.
 	 */
-	if (waitqueue_active(&asoc->wait))
+	if (asoc->wait_buf)
 		return -EBUSY;
 
 	/* An association cannot be branched off from an already peeled-off
@@ -7835,6 +7835,7 @@ static int sctp_wait_for_sndbuf(struct sctp_association *asoc, long *timeo_p,
 	/* Increment the association's refcnt.  */
 	sctp_association_hold(asoc);
 
+	asoc->wait_buf = 1;
 	/* Wait on the association specific sndbuf space. */
 	for (;;) {
 		prepare_to_wait_exclusive(&asoc->wait, &wait,
@@ -7860,6 +7861,7 @@ static int sctp_wait_for_sndbuf(struct sctp_association *asoc, long *timeo_p,
 	}
 
 out:
+	asoc->wait_buf = 0;
 	finish_wait(&asoc->wait, &wait);
 
 	/* Release the association's refcnt.  */
-- 
2.1.0

