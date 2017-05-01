From: SF Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 01 May 2017 13:32:31 +0000
Subject: [PATCH 2/3] sctp: Combine two seq_printf() calls into one call in sctp_remaddr_seq_show()
Message-Id: <856b4c28-d620-38cd-a442-f2fcafd42034@users.sourceforge.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <ea9206ca-2a2f-095e-d764-3f819610d5e8@users.sourceforge.net>
In-Reply-To: <ea9206ca-2a2f-095e-d764-3f819610d5e8@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org, netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 1 May 2017 14:24:34 +0200

A bit of data was put into a sequence by two separate function calls.
Print the same data by a single function call instead.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 net/sctp/proc.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/sctp/proc.c b/net/sctp/proc.c
index 1cf4b6385418..458087681490 100644
--- a/net/sctp/proc.c
+++ b/net/sctp/proc.c
@@ -475,9 +475,7 @@ static int sctp_remaddr_seq_show(struct seq_file *seq, void *v)
 		 * The current state of this destination. I.e.
 		 * SCTP_ACTIVE, SCTP_INACTIVE, ...
 		 */
-		seq_printf(seq, "%d", tsp->state);
-
-		seq_printf(seq, "\n");
+		seq_printf(seq, "%d\n", tsp->state);
 	}
 
 	sctp_transport_put(transport);
-- 
2.12.2

