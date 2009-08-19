From: Chunbo Luo <chunbo.luo@windriver.com>
Date: Wed, 19 Aug 2009 07:01:08 +0000
Subject: [PATCH 2/2] sctp: fix heartbeat count of path failure
Message-Id: <1250665268-29770-2-git-send-email-chunbo.luo@windriver.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1250665268-29770-1-git-send-email-chunbo.luo@windriver.com>
In-Reply-To: <1250665268-29770-1-git-send-email-chunbo.luo@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, chunbo.luo@windriver.com

RFC4960 Section 8.2 defined that the transport should enter INACTIVE
state only when the value in the error counter exceeds the protocol 
parameter 'Path.Max.Retrans' of that destination address. This means 
that the transport should enter INACTIVE state after pathmaxrxt+1
heartbeats are not acknowledged.


Signed-off-by: Chunbo Luo <chunbo.luo@windriver.com>
---
 net/sctp/sm_sideeffect.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
index 86426aa..0e2e269 100644
--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -447,7 +447,7 @@ static void sctp_do_8_2_transport_strike(struct sctp_association *asoc,
 		asoc->overall_error_count++;
 
 	if (transport->state != SCTP_INACTIVE &&
-	    (transport->error_count++ >= transport->pathmaxrxt)) {
+	    (transport->error_count++ > transport->pathmaxrxt)) {
 		SCTP_DEBUG_PRINTK_IPADDR("transport_strike:association %p",
 					 " transport IP: port:%d failed.\n",
 					 asoc,
-- 
1.6.4

