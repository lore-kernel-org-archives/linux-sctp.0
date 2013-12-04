From: Wang Weidong <wangweidong1@huawei.com>
Date: Wed, 04 Dec 2013 09:32:39 +0000
Subject: [PATCH v2] sctp: disable max_burst when the max_burst is 0
Message-Id: <529EF6B7.7000501@huawei.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <529C2E01.3090005@huawei.com>
In-Reply-To: <529C2E01.3090005@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlad Yasevich <vyasevich@gmail.com>, nhorman@tuxdriver.com, David Miller <davem@davemloft.net>
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org, Daniel Borkmann <dborkman@redhat.com>

As Michael pointed out that when max_burst is 0, it just disable
max_burst. It declared in rfc6458#section-8.1.24. so add the check
in sctp_transport_burst_limited, when it 0, just do nothing.

Reviewed-by: Daniel Borkmann <dborkman@redhat.com>
Suggested-by: Vlad Yasevich <vyasevich@gmail.com>
Suggested-by: Michael Tuexen <Michael.Tuexen@lurchi.franken.de>
Signed-off-by: Wang Weidong <wangweidong1@huawei.com>
---
 net/sctp/transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/transport.c b/net/sctp/transport.c
index e332efb..efc46ff 100644
--- a/net/sctp/transport.c
+++ b/net/sctp/transport.c
@@ -573,7 +573,7 @@ void sctp_transport_burst_limited(struct sctp_transport *t)
 	u32 old_cwnd = t->cwnd;
 	u32 max_burst_bytes;
 
-	if (t->burst_limited)
+	if (t->burst_limited || asoc->max_burst = 0)
 		return;
 
 	max_burst_bytes = t->flight_size + (asoc->max_burst * asoc->pathmtu);
-- 
1.7.12



