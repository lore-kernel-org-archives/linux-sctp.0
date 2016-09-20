From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Tue, 20 Sep 2016 21:19:13 +0000
Subject: [PATCH next 1/2] sctp: fix the handling of SACK Gap Ack blocks
Message-Id: <18f5ac1b303b60a4363cff8e002e8fea66666a08.1474405559.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1474405559.git.marcelo.leitner@gmail.com>
In-Reply-To: <cover.1474405559.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>, David Laight <David.Laight@ACULAB.COM>

sctp_acked() is using 32bit arithmetics on 16bits vars, via TSN_lte()
macros, which is weird and confusing.

Once the offset to ctsn is calculated, all wrapping is already handled
and thus to verify the Gap Ack blocks we can just use pure
less/big-or-equal than checks.

Also, rename gap variable to tsn_offset, so it's more meaningful, as
it doesn't point to any gap at all.

Even so, I don't think this discrepancy resulted in any practical bug.

This patch is a preparation for the next one, which will introduce
typecheck() for TSN_lte() macros and would cause a compile error here.

Suggested-by: David Laight <David.Laight@ACULAB.COM>
Reported-by: David Laight <David.Laight@ACULAB.COM>
Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 net/sctp/outqueue.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index 8c3f446d965c030376d0cfafd2c64b9a946d2cc1..3ec6da8bbb5360187007935838717885c97f9e91 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -1719,7 +1719,7 @@ static int sctp_acked(struct sctp_sackhdr *sack, __u32 tsn)
 {
 	int i;
 	sctp_sack_variable_t *frags;
-	__u16 gap;
+	__u16 tsn_offset, blocks;
 	__u32 ctsn = ntohl(sack->cum_tsn_ack);
 
 	if (TSN_lte(tsn, ctsn))
@@ -1738,10 +1738,11 @@ static int sctp_acked(struct sctp_sackhdr *sack, __u32 tsn)
 	 */
 
 	frags = sack->variable;
-	gap = tsn - ctsn;
-	for (i = 0; i < ntohs(sack->num_gap_ack_blocks); ++i) {
-		if (TSN_lte(ntohs(frags[i].gab.start), gap) &&
-		    TSN_lte(gap, ntohs(frags[i].gab.end)))
+	blocks = ntohs(sack->num_gap_ack_blocks);
+	tsn_offset = tsn - ctsn;
+	for (i = 0; i < blocks; ++i) {
+		if (tsn_offset >= ntohs(frags[i].gab.start) &&
+		    tsn_offset <= ntohs(frags[i].gab.end))
 			goto pass;
 	}
 
-- 
2.7.4

