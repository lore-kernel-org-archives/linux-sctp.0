From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 16 Aug 2018 06:12:01 +0000
Subject: [PATCH lksctp-tools] withsctp: use @PACKAGE_VERSION@ in withsctp.h
Message-Id: <70c25589197d15443ab3b5a38c973862aa731fcd.1534399921.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

use @PACKAGE_VERSION@ to replace the hardcode version.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 Makefile.rules           | 3 ++-
 src/withsctp/withsctp.in | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/Makefile.rules b/Makefile.rules
index 83f5f0c..d3693fa 100644
--- a/Makefile.rules
+++ b/Makefile.rules
@@ -15,4 +15,5 @@
 edit = @sed \
 	-e "s|\@bindir\@|$(bindir)|" \
 	-e "s|\@libdir\@|$(libdir)|" \
-	-e "s|\@PACKAGE\@|$(PACKAGE)|"
+	-e "s|\@PACKAGE\@|$(PACKAGE)|" \
+	-e "s|\@PACKAGE_VERSION\@|$(PACKAGE_VERSION)|"
diff --git a/src/withsctp/withsctp.in b/src/withsctp/withsctp.in
index 7f182ba..fda5ebc 100644
--- a/src/withsctp/withsctp.in
+++ b/src/withsctp/withsctp.in
@@ -2,7 +2,8 @@
 # -*- sh -*-
 LIBDIR=@libdir@/@PACKAGE@
 BINDIR=@bindir@
-export LD_PRELOAD=${LIBDIR}/libwithsctp.so.1.0.17
+LIBVER=@PACKAGE_VERSION@
+export LD_PRELOAD=${LIBDIR}/libwithsctp.so.${LIBVER}
 if ! ${BINDIR}/checksctp 2> /dev/null
 then
     ${BINDIR}/checksctp;
-- 
2.1.0
