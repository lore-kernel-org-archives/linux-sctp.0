From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 18 Mar 2019 12:06:02 +0000
Subject: [PATCH net 04/13] sctp: fix ignoring asoc_id for tcp-style sockets on SCTP_CONTEXT sockopt
Message-Id: <3d889968ad901918974cc09c78064bd4a5a24ff7.1552910681.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1552910681.git.lucien.xin@gmail.com>
 <a866141aba7511710929fffd71b0b911ddda28f4.1552910681.git.lucien.xin@gmail.com>
 <b7541db7198a1df5d75100bd9cb19678613c0a10.1552910681.git.lucien.xin@gmail.com>
 <47d570738f0cc850e9183731e47d15a7647764a0.1552910681.git.lucien.xin@gmail.com>
In-Reply-To: <47d570738f0cc850e9183731e47d15a7647764a0.1552910681.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>

A similar fix as Patch "sctp: fix ignoring asoc_id for tcp-style sockets on
SCTP_DEFAULT_SEND_PARAM sockopt" on SCTP_CONTEXT sockopt.

Fixes: 49b037acca8c ("sctp: use SCTP_FUTURE_ASSOC and add SCTP_CURRENT_ASSOC for SCTP_CONTEXT sockopt")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/socket.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 3bac039..b024a62 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3540,6 +3540,9 @@ static int sctp_setsockopt_context(struct sock *sk, char __user *optval,
 		return 0;
 	}
 
+	if (sctp_style(sk, TCP))
+		params.assoc_id = SCTP_FUTURE_ASSOC;
+
 	if (params.assoc_id = SCTP_FUTURE_ASSOC ||
 	    params.assoc_id = SCTP_ALL_ASSOC)
 		sp->default_rcv_context = params.assoc_value;
-- 
2.1.0
