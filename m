From: Dan Carpenter <error27@gmail.com>
Date: Sat, 22 May 2010 20:20:24 +0000
Subject: [patch] sctp: dubious bitfields in sctp_transport
Message-Id: <20100522202024.GL22515@bicker>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlad Yasevich <vladislav.yasevich@hp.com>
Cc: Sridhar Samudrala <sri@us.ibm.com>, "David S. Miller" <davem@davemloft.net>, Wei Yongjun <yjwei@cn.fujitsu.com>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, kernel-janitors@vger.kernel.org

Sparse complains because these one-bit bitfields are signed.
  include/net/sctp/structs.h:879:24: error: dubious one-bit signed bitfield
  include/net/sctp/structs.h:889:31: error: dubious one-bit signed bitfield
  include/net/sctp/structs.h:895:26: error: dubious one-bit signed bitfield
  include/net/sctp/structs.h:898:31: error: dubious one-bit signed bitfield
  include/net/sctp/structs.h:901:27: error: dubious one-bit signed bitfield

It doesn't cause a problem in the current code, but it would be better
to clean it up.  This was introduced by c0058a35aacc7: "sctp: Save some
room in the sctp_transport by using bitfields".

Signed-off-by: Dan Carpenter <error27@gmail.com>
---
It looks like this header is exported to user space.  I don't know if
that makes a difference.

diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 6173c61..4b86011 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -876,7 +876,7 @@ struct sctp_transport {
 
 	/* Reference counting. */
 	atomic_t refcnt;
-	int	 dead:1,
+	__u32	 dead:1,
 		/* RTO-Pending : A flag used to track if one of the DATA
 		 *		chunks sent to this address is currently being
 		 *		used to compute a RTT. If this flag is 0,
