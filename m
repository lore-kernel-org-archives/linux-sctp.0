From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 18 Mar 2019 12:06:01 +0000
Subject: [PATCH net 03/13] sctp: fix ignoring asoc_id for tcp-style sockets on SCTP_DEFAULT_SNDINFO sockopt
Message-Id: <47d570738f0cc850e9183731e47d15a7647764a0.1552910681.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1552910681.git.lucien.xin@gmail.com>
 <a866141aba7511710929fffd71b0b911ddda28f4.1552910681.git.lucien.xin@gmail.com>
 <b7541db7198a1df5d75100bd9cb19678613c0a10.1552910681.git.lucien.xin@gmail.com>
In-Reply-To: <b7541db7198a1df5d75100bd9cb19678613c0a10.1552910681.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>

A similar fix as Patch "sctp: fix ignoring asoc_id for tcp-style sockets on
SCTP_DEFAULT_SEND_PARAM sockopt" on SCTP_DEFAULT_SNDINFO sockopt.

Fixes: 92fc3bd928c9 ("sctp: use SCTP_FUTURE_ASSOC and add SCTP_CURRENT_ASSOC for SCTP_DEFAULT_SNDINFO sockopt")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/socket.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 4c5821b..3bac039 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3087,6 +3087,9 @@ static int sctp_setsockopt_default_sndinfo(struct sock *sk,
 		return 0;
 	}
 
+	if (sctp_style(sk, TCP))
+		info.snd_assoc_id = SCTP_FUTURE_ASSOC;
+
 	if (info.snd_assoc_id = SCTP_FUTURE_ASSOC ||
 	    info.snd_assoc_id = SCTP_ALL_ASSOC) {
 		sp->default_stream = info.snd_sid;
-- 
2.1.0
