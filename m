From: Max Matveev <makc@redhat.com>
Date: Mon, 20 Jun 2011 08:08:10 +0000
Subject: [PATCH 1/2] Update description of net.sctp.sctp_rmem and net.sctp.sctp_wmem tunables
Message-Id: <20110704083605.AF9C28156C57@regina.usersys.redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org
Cc: netdev@vger.kernel.org

sctp does not use second and third ("default" and "max") values
of sctp_(r|w)mem tunables. The format is the same and tcp_(r|w)mem
but the meaning is different so make the documentation explicit to
avoid confusion.

Signed-off-by: Max Matveev <makc@redhat.com>
---
 Documentation/networking/ip-sysctl.txt |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
index d3d653a..f37d374 100644
--- a/Documentation/networking/ip-sysctl.txt
+++ b/Documentation/networking/ip-sysctl.txt
@@ -1465,10 +1465,17 @@ sctp_mem - vector of 3 INTEGERs: min, pressure, max
 	Default is calculated at boot time from amount of available memory.
 
 sctp_rmem - vector of 3 INTEGERs: min, default, max
-	See tcp_rmem for a description.
+	Only the first value ("min") is used, "default" and "max" are
+	ignored and may be removed in the future versions.
+
+	min: Minimal size of receive buffer used by SCTP socket.
+	It is guaranteed to each STCP socket (but not association) even 
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

