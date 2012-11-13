From: Schoch Christian <e0326715@student.tuwien.ac.at>
Date: Tue, 13 Nov 2012 06:46:20 +0000
Subject: [PATCH v2]sctp: Error in calculation of RTTvar
Message-Id: <20121113074620.21386wv4qcpbm75o@webmail.tuwien.ac.at>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

The calculation of RTTVAR involves the subtraction of two unsigned  
numbers which
may causes rollover and results in very high values of RTTVAR when RTT > SRTT.
With this patch it is possible to set RTOmin = 1 to get the minimum of RTO at
4 times the clock granularity.


Change Notes:

v2)
        *Replaced abs() by abs64() and long by __s64, changed patch  
description.

Signed-off-by: Christian Schoch <e0326715@student.tuwien.ac.at>
CC: Vlad Yasevich <vyasevich@gmail.com>
CC: Sridhar Samudrala <sri@us.ibm.com>
CC: Neil Horman <nhorman@tuxdriver.com>
CC: linux-sctp@vger.kernel.org
---

diff --git a/net/sctp/transport.c b/net/sctp/transport.c
index 953c21e..206cf52 100644
--- a/net/sctp/transport.c
+++ b/net/sctp/transport.c
@@ -331,7 +331,7 @@ void sctp_transport_update_rto(struct  
sctp_transport *tp, __u32 rtt)
                  * 1/8, rto_alpha would be expressed as 3.
                  */
                 tp->rttvar = tp->rttvar - (tp->rttvar >> net->sctp.rto_beta)
-                       + ((abs(tp->srtt - rtt)) >> net->sctp.rto_beta);
+                       + (((__u32)abs64((__s64)tp->srtt -  
(__s64)rtt)) >> net->sctp.rto_beta);
                 tp->srtt = tp->srtt - (tp->srtt >> net->sctp.rto_alpha)
                         + (rtt >> net->sctp.rto_alpha);
         } else {
--

