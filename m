From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 18 Mar 2019 12:06:10 +0000
Subject: [PATCH net 12/13] sctp: fix ignoring asoc_id for tcp-style sockets on SCTP_EVENT sockopt
Message-Id: <a1956b59384a88fe50dac1852b4666793ba8c663.1552910681.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1552910681.git.lucien.xin@gmail.com>
 <a866141aba7511710929fffd71b0b911ddda28f4.1552910681.git.lucien.xin@gmail.com>
 <b7541db7198a1df5d75100bd9cb19678613c0a10.1552910681.git.lucien.xin@gmail.com>
 <47d570738f0cc850e9183731e47d15a7647764a0.1552910681.git.lucien.xin@gmail.com>
 <3d889968ad901918974cc09c78064bd4a5a24ff7.1552910681.git.lucien.xin@gmail.com>
 <446bf443557ec1433a5f85c9a1e15987df20a8df.1552910681.git.lucien.xin@gmail.com>
 <9028a9b0f9968d629614a36cbbf79fef34935717.1552910681.git.lucien.xin@gmail.com>
 <ead4f7e6f620d64b9616b8e394e559c55427229e.1552910681.git.lucien.xin@gmail.com>
 <0c9808b498eb088a9146a09c79d795e30e3c79c5.1552910681.git.lucien.xin@gmail.com>
 <fa16260b4714687bba2cfbf2703347c9d0d9f6c2.1552910681.git.lucien.xin@gmail.com>
 <35a7b393cc72087426f3c7bbd47c6fa7cbc838ae.1552910681.git.lucien.xin@gmail.com>
 <1b33cb70222974d65a7194a506c9e99d474732c2.1552910681.git.lucien.xin@gmail.com>
In-Reply-To: <1b33cb70222974d65a7194a506c9e99d474732c2.1552910681.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>

A similar fix as Patch "sctp: fix ignoring asoc_id for tcp-style sockets on
SCTP_DEFAULT_SEND_PARAM sockopt" on SCTP_EVENT sockopt.

Fixes: d251f05e3ba2 ("sctp: use SCTP_FUTURE_ASSOC and add SCTP_CURRENT_ASSOC for SCTP_EVENT sockopt")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/socket.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 6b0ee89..10df48a 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4574,6 +4574,9 @@ static int sctp_setsockopt_event(struct sock *sk, char __user *optval,
 	if (asoc)
 		return sctp_assoc_ulpevent_type_set(&param, asoc);
 
+	if (sctp_style(sk, TCP))
+		param.se_assoc_id = SCTP_FUTURE_ASSOC;
+
 	if (param.se_assoc_id = SCTP_FUTURE_ASSOC ||
 	    param.se_assoc_id = SCTP_ALL_ASSOC)
 		sctp_ulpevent_type_set(&sp->subscribe,
-- 
2.1.0
