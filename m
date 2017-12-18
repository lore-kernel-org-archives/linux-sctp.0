From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 18 Dec 2017 06:13:17 +0000
Subject: [PATCH net] sctp: add SCTP_CID_RECONF conversion in sctp_cname
Message-Id: <ae9172b7dc432d6092ab2bc061a0cf322a3939b5.1513577597.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>

Whenever a new type of chunk is added, the corresp conversion in
sctp_cname should be added. Otherwise, in some places, pr_debug
will print it as "unknown chunk".

Fixes: cc16f00f6529 ("sctp: add support for generating stream reconf ssn reset request chunk")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/debug.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/sctp/debug.c b/net/sctp/debug.c
index 3f619fd..291c97b 100644
--- a/net/sctp/debug.c
+++ b/net/sctp/debug.c
@@ -78,6 +78,9 @@ const char *sctp_cname(const union sctp_subtype cid)
 	case SCTP_CID_AUTH:
 		return "AUTH";
 
+	case SCTP_CID_RECONF:
+		return "RECONF";
+
 	default:
 		break;
 	}
-- 
2.1.0

