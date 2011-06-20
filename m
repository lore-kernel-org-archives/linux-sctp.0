From: Max Matveev <makc@redhat.com>
Date: Mon, 20 Jun 2011 08:08:10 +0000
Subject: [PATCH v2 1/2] Update description of net.sctp.sctp_rmem and net.sctp.sctp_wmem tunables
Message-Id: <20110705015723.8B226815DBB1@regina.usersys.redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org
Cc: netdev@vger.kernel.org

sctp does not use second and third ("default" and "max") values
of sctp_rmem tunable. The format is the same as tcp_rmem
but the meaning is different so make the documentation explicit to
avoid confusion.

sctp_wmem is not used at all.

Acked-by: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: Max Matveev <makc@redhat.com>
---
 Documentation/networking/ip-sysctl.txt |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
index d3d653a..ce09f83 100644
--- a/Documentation/networking/ip-sysctl.txt
+++ b/Documentation/networking/ip-sysctl.txt
@@ -1465,10 +1465,17 @@ sctp_mem - vector of 3 INTEGERs: min, pressure, max
 	Default is calculated at boot time from amount of available memory.
 
 sctp_rmem - vector of 3 INTEGERs: min, default, max
-	See tcp_rmem for a description.
+	Only the first value ("min") is used, "default" and "max" are
+	ignored.
+
+	min: Minimal size of receive buffer used by SCTP socket.
+	It is guaranteed to each SCTP socket (but not association) even 
+	under moderate memory pressure.
+
+	Default: 1 page
 
 sctp_wmem  - vector of 3 INTEGERs: min, default, max
-	See tcp_wmem for a description.
+	Currently this tunable has no effect.
 
 addr_scope_policy - INTEGER
 	Control IPv4 address scoping - draft-stewart-tsvwg-sctp-ipv4-00
-- 
1.7.3.3

