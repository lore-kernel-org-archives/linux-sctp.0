From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 18 Mar 2019 12:05:59 +0000
Subject: [PATCH net 01/13] sctp: fix ignoring asoc_id for tcp-style sockets on SCTP_DEFAULT_SEND_PARAM sockop
Message-Id: <a866141aba7511710929fffd71b0b911ddda28f4.1552910681.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1552910681.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1552910681.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>

From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Currently if the user pass an invalid asoc_id to SCTP_DEFAULT_SEND_PARAM
on a TCP-style socket, it will silently ignore the new parameters.
That's because after not finding an asoc, it is checking asoc_id against
the known values of CURRENT/FUTURE/ALL values and that fails to match.

IOW, if the user supplies an invalid asoc id or not, it should either
match the current asoc or the socket itself so that it will inherit
these later. Fixes it by forcing asoc_id to SCTP_FUTURE_ASSOC in case it
is a TCP-style socket without an asoc, so that the values get set on the
socket.

Fixes: 707e45b3dc5a ("sctp: use SCTP_FUTURE_ASSOC and add SCTP_CURRENT_ASSOC for SCTP_DEFAULT_SEND_PARAM sockopt")
Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 net/sctp/socket.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 65b5386..d0e5c62 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3024,6 +3024,9 @@ static int sctp_setsockopt_default_send_param(struct sock *sk,
 		return 0;
 	}
 
+	if (sctp_style(sk, TCP))
+		info.sinfo_assoc_id = SCTP_FUTURE_ASSOC;
+
 	if (info.sinfo_assoc_id = SCTP_FUTURE_ASSOC ||
 	    info.sinfo_assoc_id = SCTP_ALL_ASSOC) {
 		sp->default_stream = info.sinfo_stream;
-- 
2.1.0
