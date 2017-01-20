From: Colin King <colin.king@canonical.com>
Date: Fri, 20 Jan 2017 13:01:57 +0000
Subject: [PATCH] net: sctp: fix array overrun read on sctp_timer_tbl
Message-Id: <20170120130157.20034-1-colin.king@canonical.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, "David S . Miller" <davem@davemloft.net>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The comparison on the timeout can lead to an array overrun
read on sctp_timer_tbl because of an off-by-one error. Fix
this by using < instead of <= and also compare to the array
size rather than SCTP_EVENT_TIMEOUT_MAX.

Fixes CoverityScan CID#1397639 ("Out-of-bounds read")

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 net/sctp/debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/debug.c b/net/sctp/debug.c
index 95d7b15..e371a0d 100644
--- a/net/sctp/debug.c
+++ b/net/sctp/debug.c
@@ -166,7 +166,7 @@ static const char *const sctp_timer_tbl[] = {
 /* Lookup timer debug name. */
 const char *sctp_tname(const sctp_subtype_t id)
 {
-	if (id.timeout <= SCTP_EVENT_TIMEOUT_MAX)
+	if (id.timeout < ARRAY_SIZE(sctp_timer_tbl))
 		return sctp_timer_tbl[id.timeout];
 	return "unknown_timer";
 }
-- 
2.10.2

