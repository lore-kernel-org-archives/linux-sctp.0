From: Christian Schoch <e0326715@student.tuwien.ac.at>
Date: Tue, 09 Nov 2010 05:48:02 +0000
Subject: Insufficient RTO calculation
Message-Id: <20101109064802.aq6dp6j404cccgkc@webmail.tuwien.ac.at>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

The actual calculation of the RTO is insufficient for very small RTTs.

tp->srtt = tp->srtt - (tp->srtt >> sctp_rto_alpha)
            + (rtt >> sctp_rto_alpha);

If srtt is less then 8ms (with alpha=3), the shift operation will mask 
out the last 3 bits. So the minimum of srtt is 7ms, assuming a RTT of 
0ms.

tp->rttvar = tp->rttvar - (tp->rttvar >> sctp_rto_beta)
              + ((abs(tp->srtt - rtt)) >> sctp_rto_beta);

With the minimum of 7ms for SRTT, the resulting minimum for RTTVAR is 7ms.

tp->rto = tp->srtt + (tp->rttvar << 2);

This results in a minimum of 35ms for RTO (7ms + 4*7ms).
These minimums are archieved, if SRTT and RTTVAR had larger values before.

Instead of do a right shift, the other values are shifted to the left 
and the whole result is shifted backwards.
Only point is, that if RTTVAR or SRTT are large enough, there would be 
a masking of the most significant bits. But I think, if one of them is 
going to 2^32, there must be an error elsewhere.


Here is the patch:
Generated with Kernel 2.6.36

Signed-off-by: Christian Schoch <e0326715@student.tuwien.ac.at>
---
--- a/net/sctp/transport.c	2010-10-20 22:30:22.000000000 +0200
+++ b/net/sctp/transport.c	2010-11-03 22:19:33.879104009 +0100
@@ -333,10 +333,10 @@
		 * For example, assuming the default value of RTO.Alpha of
		 * 1/8, rto_alpha would be expressed as 3.
		 */
-		tp->rttvar = tp->rttvar - (tp->rttvar >> sctp_rto_beta)
-			+ ((abs(tp->srtt - rtt)) >> sctp_rto_beta);
-		tp->srtt = tp->srtt - (tp->srtt >> sctp_rto_alpha)
-			+ (rtt >> sctp_rto_alpha);
+		tp->rttvar = ((tp->rttvar << sctp_rto_beta) - tp->rttvar
+			+ abs(tp->srtt - rtt)) >> sctp_rto_beta;
+		tp->srtt = ((tp->srtt << sctp_rto_alpha) - tp->srtt
+			+ rtt) >> sctp_rto_alpha;
	} else {
		/* 6.3.1 C2) When the first RTT measurement R is made, set
		 * SRTT <- R, RTTVAR <- R/2.

