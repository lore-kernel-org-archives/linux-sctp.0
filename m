From: yegorslists@googlemail.com
Date: Mon, 29 Feb 2016 11:25:42 +0000
Subject: [PATCH] libsctp: add pkg-config support
Message-Id: <1456745142-23268-1-git-send-email-yegorslists@googlemail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

From: Yegor Yefremov <yegorslists@googlemail.com>

pkg-config is a helper tool used when compiling applications and libraries.
This patch adds automatic generation and installation of libsctp.pc file,
that provides libsctp's version, compiler and linker information.

Signed-off-by: Yegor Yefremov <yegorslists@googlemail.com>
---
 Makefile.am   |  5 +++++
 configure.ac  |  3 ++-
 libsctp.pc.in | 10 ++++++++++
 3 files changed, 17 insertions(+), 1 deletion(-)
 create mode 100644 libsctp.pc.in

diff --git a/Makefile.am b/Makefile.am
index 2c9c8c6..58cacf0 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -9,6 +9,11 @@ EXTRA_DIST += ChangeLog AUTHORS COPYING COPYING.lib INSTALL \
 	README ROADMAP NEWS \
 	Makefile.vars Makefile.rules Makefile.dirs
 
+pkgconfigdir = $(libdir)/pkgconfig
+pkgconfig_DATA = libsctp.pc
+EXTRA_DIST += libsctp.pc.in
+CLEANFILES = libsctp.pc
+
 # bin or src products may be required to generate stuff in test/
 SUBDIRS = man bin src doc
 
diff --git a/configure.ac b/configure.ac
index 778dac5..675fb96 100644
--- a/configure.ac
+++ b/configure.ac
@@ -72,5 +72,6 @@ AC_CONFIG_FILES([lksctp-tools.spec
 		src/lib/Makefile
 		src/testlib/Makefile
 		src/withsctp/Makefile
-		doc/Makefile])
+		doc/Makefile
+		libsctp.pc])
 AC_OUTPUT
diff --git a/libsctp.pc.in b/libsctp.pc.in
new file mode 100644
index 0000000..b1eafaf
--- /dev/null
+++ b/libsctp.pc.in
@@ -0,0 +1,10 @@
+prefix=@prefix@
+exec_prefix=@exec_prefix@
+libdir=@libdir@
+includedir=@includedir@
+
+Name: sctp
+Description: User-level SCTP API library
+Version: @VERSION@
+Libs: -L${libdir} -lsctp
+Cflags: -I${includedir}
-- 
2.7.0

