From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Tue, 24 Jan 2017 09:05:40 +0000
Subject: [patch net-next] sctp: fix some debug output
Message-Id: <20170124090540.GA27652@mwanda>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlad Yasevich <vyasevich@gmail.com>, Xin Long <lucien.xin@gmail.com>
Cc: Neil Horman <nhorman@tuxdriver.com>, "David S. Miller" <davem@davemloft.net>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, kernel-janitors@vger.kernel.org

We added SCTP_EVENT_TIMEOUT_RECONF but we didn't update this array so
it causes an off-by-one read overflow.

Fixes: 7b9438de0cd4 ("sctp: add stream reconf timer")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/net/sctp/debug.c b/net/sctp/debug.c
index 95d7b15dad21..c5f4ed5242ac 100644
--- a/net/sctp/debug.c
+++ b/net/sctp/debug.c
@@ -159,6 +159,7 @@ static const char *const sctp_timer_tbl[] = {
 	"TIMEOUT_T4_RTO",
 	"TIMEOUT_T5_SHUTDOWN_GUARD",
 	"TIMEOUT_HEARTBEAT",
+	"TIMEOUT_RECONF",
 	"TIMEOUT_SACK",
 	"TIMEOUT_AUTOCLOSE",
 };
