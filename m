From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Thu, 03 Nov 2016 19:03:41 +0000
Subject: [PATCH net] sctp: assign assoc_id earlier in __sctp_connect
Message-Id: <9df38dcd0323ad92386eb6851a60dc128dd00b4e.1478199530.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, syzkaller@googlegroups.com, kcc@google.com, glider@google.com, edumazet@google.com, dvyukov@google.com, andreyknvl@google.com

sctp_wait_for_connect() currently already holds the asoc to keep it
alive during the sleep, in case another thread release it. But Andrey
Konovalov and Dmitry Vyukov reported an use-after-free in such
situation.

Problem is that __sctp_connect() doesn't get a ref on the asoc and will
do a read on the asoc after calling sctp_wait_for_connect(), but by then
another thread may have closed it and the _put on sctp_wait_for_connect
will actually release it, causing the use-after-free.

Fix is, instead of doing the read after waiting for the connect, do it
before so, and avoid this issue as the socket is still locked by then.
There should be no issue on returning the asoc id in case of failure as
the application shouldn't trust on that number in such situations
anyway.

This issue doesn't exist in sctp_sendmsg() path.

Reported-by: Dmitry Vyukov <dvyukov@google.com>
Reported-by: Andrey Konovalov <andreyknvl@google.com>
Tested-by: Andrey Konovalov <andreyknvl@google.com>
Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 net/sctp/socket.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 6cdc61c21438aa9b6dbdad93e70759071a4d6789..be1d9bb98230c9d77f676949db773b2dacd801a4 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -1214,9 +1214,12 @@ static int __sctp_connect(struct sock *sk,
 
 	timeo = sock_sndtimeo(sk, f_flags & O_NONBLOCK);
 
-	err = sctp_wait_for_connect(asoc, &timeo);
-	if ((err = 0 || err = -EINPROGRESS) && assoc_id)
+	if (assoc_id)
 		*assoc_id = asoc->assoc_id;
+	err = sctp_wait_for_connect(asoc, &timeo);
+	/* Note: the asoc may be freed after the return of
+	 * sctp_wait_for_connect.
+	 */
 
 	/* Don't free association on exit. */
 	asoc = NULL;
-- 
2.7.4

