From: Neil Horman <nhorman@tuxdriver.com>
Date: Wed, 24 Oct 2012 19:26:51 +0000
Subject: [PATCH] MAINTAINERS: Add myself to list of SCTP maintainers
Message-Id: <1351106811-23601-1-git-send-email-nhorman@tuxdriver.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>, "David S. Miller" <davem@davemloft.net>, linux-sctp@vger.kernel.org

I've been messing with the code for a bit, and I figured Vlad could use a hand
as interest in the protocol has picked up over the last year or so.  I've asked
him, and he doesn't seem too upset over the idea :)

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
CC: Vlad Yasevich <vyasevich@gmail.com>
CC: "David S. Miller" <davem@davemloft.net>
CC: linux-sctp@vger.kernel.org
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 5655bcc..2463a0a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6352,6 +6352,7 @@ F:	drivers/scsi/st*
 SCTP PROTOCOL
 M:	Vlad Yasevich <vyasevich@gmail.com>
 M:	Sridhar Samudrala <sri@us.ibm.com>
+M:	Neil Horman <nhorman@tuxdriver.com>
 L:	linux-sctp@vger.kernel.org
 W:	http://lksctp.sourceforge.net
 S:	Maintained
-- 
1.7.11.7

