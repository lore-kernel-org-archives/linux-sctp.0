From: Max Matveev <makc@redhat.com>
Date: Wed, 22 Jun 2011 07:18:13 +0000
Subject: [PATCH 2/2] Update documented default values for various TCP/UDP tunables
Message-Id: <20110704083616.43F2C8156C57@regina.usersys.redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org
Cc: netdev@vger.kernel.org

tcp_rmem and tcp_wmem use 1 page as default value for the minimum
amount of memory to be used, same as udp_wmem_min and udp_rmem_min.
Pages are different size on different architectures - use the right
units when describing the defaults.

Signed-off-by: Max Matveev <makc@redhat.com>
---
 Documentation/networking/ip-sysctl.txt |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
index f37d374..387ee53 100644
--- a/Documentation/networking/ip-sysctl.txt
+++ b/Documentation/networking/ip-sysctl.txt
@@ -394,7 +394,7 @@ tcp_rmem - vector of 3 INTEGERs: min, default, max
 	min: Minimal size of receive buffer used by TCP sockets.
 	It is guaranteed to each TCP socket, even under moderate memory
 	pressure.
-	Default: 8K
+	Default: 1 page
 
 	default: initial size of receive buffer used by TCP sockets.
 	This value overrides net.core.rmem_default used by other protocols.
@@ -483,7 +483,7 @@ tcp_window_scaling - BOOLEAN
 tcp_wmem - vector of 3 INTEGERs: min, default, max
 	min: Amount of memory reserved for send buffers for TCP sockets.
 	Each TCP socket has rights to use it due to fact of its birth.
-	Default: 4K
+	Default: 1 page
 
 	default: initial size of send buffer used by TCP sockets.  This
 	value overrides net.core.wmem_default used by other protocols.
@@ -553,13 +553,13 @@ udp_rmem_min - INTEGER
 	Minimal size of receive buffer used by UDP sockets in moderation.
 	Each UDP socket is able to use the size for receiving data, even if
 	total pages of UDP sockets exceed udp_mem pressure. The unit is byte.
-	Default: 4096
+	Default: 1 page
 
 udp_wmem_min - INTEGER
 	Minimal size of send buffer used by UDP sockets in moderation.
 	Each UDP socket is able to use the size for sending data, even if
 	total pages of UDP sockets exceed udp_mem pressure. The unit is byte.
-	Default: 4096
+	Default: 1 page
 
 CIPSOv4 Variables:
 
-- 
1.7.3.3

