From: Xin Long <lucien.xin@gmail.com>
Date: Sun, 03 Mar 2019 08:50:26 +0000
Subject: [PATCH net] sctp: call iov_iter_revert() after sending ABORT
Message-Id: <d335a35e857c8f72d99032077b15df50ced4b7f9.1551603026.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>

The user msg is also copied to the abort packet when doing SCTP_ABORT in
sctp_sendmsg_check_sflags(). When SCTP_SENDALL is set, iov_iter_revert()
should have been called for sending abort on the next asoc with copying
this msg. Otherwise, memcpy_from_msg() in sctp_make_abort_user() will
fail and return error.

Fixes: 4910280503f3 ("sctp: add support for snd flag SCTP_SENDALL process in sendmsg")
Reported-by: Ying Xu <yinxu@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/socket.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 65d6d04..a2771b3 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -1866,6 +1866,7 @@ static int sctp_sendmsg_check_sflags(struct sctp_association *asoc,
 
 		pr_debug("%s: aborting association:%p\n", __func__, asoc);
 		sctp_primitive_ABORT(net, asoc, chunk);
+		iov_iter_revert(&msg->msg_iter, msg_len);
 
 		return 0;
 	}
-- 
2.1.0
