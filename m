From: Michele Baldessari <michele@acksyn.org>
Date: Thu, 30 Oct 2014 09:29:16 +0000
Subject: [net-next 2/2] sctp: replace seq_printf with seq_puts
Message-Id: <1414661356-17255-2-git-send-email-michele@acksyn.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <1414661356-17255-1-git-send-email-michele@acksyn.org>
In-Reply-To: <1414661356-17255-1-git-send-email-michele@acksyn.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Michele Baldessari <michele@acksyn.org>

Fixes checkpatch warning:
"WARNING: Prefer seq_puts to seq_printf"

Signed-off-by: Michele Baldessari <michele@acksyn.org>
---
 net/sctp/proc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sctp/proc.c b/net/sctp/proc.c
index bfb242af06ab..0697eda5aed8 100644
--- a/net/sctp/proc.c
+++ b/net/sctp/proc.c
@@ -490,14 +490,14 @@ static int sctp_remaddr_seq_show(struct seq_file *seq, void *v)
 			 * Note: We don't have a way to tally this at the moment
 			 * so lets just leave it as zero for the moment
 			 */
-			seq_printf(seq, "0 ");
+			seq_puts(seq, "0 ");
 
 			/*
 			 * remote address start time (START).  This is also not
 			 * currently implemented, but we can record it with a
 			 * jiffies marker in a subsequent patch
 			 */
-			seq_printf(seq, "0 ");
+			seq_puts(seq, "0 ");
 
 			/*
 			 * The current state of this destination. I.e.
-- 
2.1.0

