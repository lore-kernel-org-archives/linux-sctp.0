From: Shan Wei <shanwei@cn.fujitsu.com>
Date: Sun, 20 Feb 2011 07:57:26 +0000
Subject: [PATCH net-next] sctp: fix compile warnings in sctp_tsnmap_num_gabs
Message-Id: <4D60C966.2000302@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Vlad Yasevich <vladislav.yasevich@hp.com>, David Miller <davem@davemloft.net>, Network-Maillist <netdev@vger.kernel.org>, SCTP-Maillist <linux-sctp@vger.kernel.org>

net/sctp/tsnmap.c: In function ‘sctp_tsnmap_num_gabs’:
net/sctp/tsnmap.c:347: warning: ‘start’ may be used uninitialized in this function
net/sctp/tsnmap.c:347: warning: ‘end’ may be used uninitialized in this function

Signed-off-by: Shan Wei <shanwei@cn.fujitsu.com>
---
 net/sctp/tsnmap.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/sctp/tsnmap.c b/net/sctp/tsnmap.c
index 747d541..f1e40ce 100644
--- a/net/sctp/tsnmap.c
+++ b/net/sctp/tsnmap.c
@@ -344,7 +344,7 @@ __u16 sctp_tsnmap_num_gabs(struct sctp_tsnmap *map,
 
 	/* Refresh the gap ack information. */
 	if (sctp_tsnmap_has_gap(map)) {
-		__u16 start, end;
+		__u16 start = 0, end = 0;
 		sctp_tsnmap_iter_init(map, &iter);
 		while (sctp_tsnmap_next_gap_ack(map, &iter,
 						&start,
-- 
1.6.3.3

