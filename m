From: Daniel Borkmann <dborkman@redhat.com>
Date: Tue, 23 Jul 2013 12:51:48 +0000
Subject: [PATCH net-next 2/2] net: sctp: trivial: add uapi/linux/sctp.h into maintainers
Message-Id: <1374583908-17152-2-git-send-email-dborkman@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1374583908-17152-1-git-send-email-dborkman@redhat.com>
In-Reply-To: <1374583908-17152-1-git-send-email-dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

After this file has moved to the uapi section, we also need to update
this in the maintainers file.

Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index bf61e04..339e798 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7216,6 +7216,7 @@ W:	http://lksctp.sourceforge.net
 S:	Maintained
 F:	Documentation/networking/sctp.txt
 F:	include/linux/sctp.h
+F:	include/uapi/linux/sctp.h
 F:	include/net/sctp/
 F:	net/sctp/
 
-- 
1.7.11.7

