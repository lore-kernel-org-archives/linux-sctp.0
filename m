From: Christian Schoch <e0326715@student.tuwien.ac.at>
Date: Tue, 05 Oct 2010 04:36:36 +0000
Subject: [PATCH] Error in calculation of RTTvar
Message-Id: <20101005063636.4x0vgeefesckcs0s@webmail.tuwien.ac.at>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

The problem is inside the calculation of RTTVAR, which could last in 
very high values for RTO. This wrong result exists when RTT is rising 
and is bigger than SRTT (the subtraction goes negative).
With this patch it should be possible to set RTOmin = 1 and the RTO has 
its minimum of 4 times the clock granularity - if the connection is 
fast enough like a LAN connection.

abs() takes two long as argument and the output is long.
srtt, rtt and rttvar are __u32.

Subtraction of two unsigned values results in a value, that is not the 
same as it would be if the arguments are two signed values and the 
casted back.
Without typecasting the result is the one's complement +1 for carry.

This patch should eliminate the problem.

Schoch Christian

-----------------------------------------------------------------------

--- a/net/sctp/transport.c        2010-10-05 06:04:17.000000000 +0200
+++ b/net/sctp/transport.c        2010-10-05 06:09:09.000000000 +0200
@@ -334,7 +334,7 @@
                 * 1/8, rto_alpha would be expressed as 3.
                 */
                tp->rttvar = tp->rttvar - (tp->rttvar >> sctp_rto_beta)
-                        + ((abs(tp->srtt - rtt)) >> sctp_rto_beta);
+                        + (((__u32)abs((long)tp->srtt - (long)rtt)) >> 
sctp_rto_beta);
                tp->srtt = tp->srtt - (tp->srtt >> sctp_rto_alpha)
                        + (rtt >> sctp_rto_alpha);
        } else {

---------------------------------------------

