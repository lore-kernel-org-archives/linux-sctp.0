From: Chris Packham <chris.packham@alliedtelesis.co.nz>
Date: Mon, 25 May 2020 22:55:59 +0000
Subject: [PATCH] net: sctp: Fix spelling in Kconfig help
Message-Id: <20200525225559.13596-1-chris.packham@alliedtelesis.co.nz>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vyasevich@gmail.com, nhorman@tuxdriver.com, marcelo.leitner@gmail.com, davem@davemloft.net
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org, trivial@kernel.org, linux-kernel@vger.kernel.org, Chris Packham <chris.packham@alliedtelesis.co.nz>, Jakub Kicinski <kuba@kernel.org>

Change 'handeled' to 'handled' in the Kconfig help for SCTP.

Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
---
 net/sctp/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/Kconfig b/net/sctp/Kconfig
index 6e2eb1dd64ed..68934438ee19 100644
--- a/net/sctp/Kconfig
+++ b/net/sctp/Kconfig
@@ -31,7 +31,7 @@ menuconfig IP_SCTP
 	  homing at either or both ends of an association."
 
 	  To compile this protocol support as a module, choose M here: the
-	  module will be called sctp. Debug messages are handeled by the
+	  module will be called sctp. Debug messages are handled by the
 	  kernel's dynamic debugging framework.
 
 	  If in doubt, say N.
-- 
2.25.1
