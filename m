From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Fri, 04 Sep 2009 06:33:19 +0000
Subject: [PATCH 1/2] sctp: turn flags in 'struct sctp_association' into bit
Message-Id: <4AA0B4AF.6070103@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

This shrinks the size of struct sctp_association a little.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 include/net/sctp/structs.h |   21 +++++++++------------
 1 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index a48d80e..42d00ce 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -1568,13 +1568,13 @@ struct sctp_association {
 		__u32	sack_cnt;
 
 		/* These are capabilities which our peer advertised.  */
-		__u8	ecn_capable;	 /* Can peer do ECN? */
-		__u8	ipv4_address;	 /* Peer understands IPv4 addresses? */
-		__u8	ipv6_address;	 /* Peer understands IPv6 addresses? */
-		__u8	hostname_address;/* Peer understands DNS addresses? */
-		__u8    asconf_capable;  /* Does peer support ADDIP? */
-		__u8    prsctp_capable;  /* Can peer do PR-SCTP? */
-		__u8	auth_capable;	 /* Is peer doing SCTP-AUTH? */
+		__u8	ecn_capable:1,	    /* Can peer do ECN? */
+			ipv4_address:1,	    /* Peer understands IPv4 addresses? */
+			ipv6_address:1,	    /* Peer understands IPv6 addresses? */
+			hostname_address:1, /* Peer understands DNS addresses? */
+			asconf_capable:1,   /* Does peer support ADDIP? */
+			prsctp_capable:1,   /* Can peer do PR-SCTP? */
+			auth_capable:1;	    /* Is peer doing SCTP-AUTH? */
 
 		__u32   adaptation_ind;	 /* Adaptation Code point. */
 
@@ -1913,11 +1913,8 @@ struct sctp_association {
 
 	__u16 active_key_id;
 
-	/* Need to send an ECNE Chunk? */
-	char need_ecne;
-
-	/* Is it a temporary association? */
-	char temp;
+	__u8 need_ecne:1,	/* Need to send an ECNE Chunk? */
+	     temp:1;		/* Is it a temporary association? */
 };
 
 
-- 
1.6.2.2




