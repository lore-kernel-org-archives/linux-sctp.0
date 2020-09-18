From: Petr Lautrbach <plautrba@redhat.com>
Date: Fri, 18 Sep 2020 18:48:30 +0000
Subject: [PATCH lksctp-tools] Use symvmer attribute, not asms for symbol versioning
Message-Id: <20200918184830.469979-1-plautrba@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

This project could not be built with LTO as it uses ASMs to implement
symbol versioning. ASMs like this are fundamentally incompatible with
LTO because GCC does not look inside the ASM string to find symbol
references. Starting with gcc-10 there is a new symbol attribute for
implementing symbol versioning.

A fallback to the old way of implementing symbol versioning via asms is
included, so it should work with clang as well as gcc-9 and
earlier.

Fixes: https://github.com/sctp/lksctp-tools/issues/35

Author: Jeff Law <law@redhat.com>
Signed-off-by: Petr Lautrbach <plautrba@redhat.com>
---
 configure.ac       |  8 ++++++++
 src/lib/connectx.c | 25 ++++++++++++++++---------
 2 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/configure.ac b/configure.ac
index 5de5c763005e..d3e31c35e6bb 100644
--- a/configure.ac
+++ b/configure.ac
@@ -130,4 +130,12 @@ AC_ARG_ENABLE(tests,
 	[enable_tests=yes])
 AM_CONDITIONAL(BUILD_TESTS, [test $enable_tests != no])
 
+# GCC tries to be "helpful" and only issue a warning for unrecognized
+# attributes.  So we compile the test with Werror, so that if the
+# attribute is not recognized the compilation fails
+AC_LANG(C)
+AC_LANG_WERROR
+AC_COMPILE_IFELSE([AC_LANG_SOURCE([[__attribute__ ((symver ("foo@foo_1"))) void frob (void) { }]])],
+                  [AC_DEFINE([HAVE_ATTRIBUTE_SYMVER], [1], [Checking for symver attribute])], [])
+
 AC_OUTPUT
diff --git a/src/lib/connectx.c b/src/lib/connectx.c
index 5f4552bd011b..2a21e3abe58d 100644
--- a/src/lib/connectx.c
+++ b/src/lib/connectx.c
@@ -26,6 +26,18 @@
 #include <stdlib.h>
 #include <string.h>
 #include <fcntl.h>
+#include "config.h"
+
+#define __SYMPFX(pfx, sym) #pfx sym
+#define _SYMPFX(pfx, sym) __SYMPFX(pfx, sym)
+#define SYMPFX(sym) _SYMPFX(__USER_LABEL_PREFIX__, #sym)
+
+#if HAVE_ATTRIBUTE_SYMVER
+#define SYMVER(name, name2) __attribute__ ((symver (SYMPFX(name2))))
+#else
+#define SYMVER(name, name2) __asm__(".symver " SYMPFX(name) "," SYMPFX(name2));
+#endif
+
 
 /* Support the sctp_connectx() interface.
  *
@@ -64,6 +76,7 @@ static int __connectx_addrsize(const struct sockaddr *addrs,
 }
 			
 
+SYMVER(__sctp_connectx, sctp_connectx@)
 int __sctp_connectx(int fd, struct sockaddr *addrs, int addrcnt)
 {
 	int addrs_size = __connectx_addrsize(addrs, addrcnt);
@@ -75,6 +88,7 @@ int __sctp_connectx(int fd, struct sockaddr *addrs, int addrcnt)
 			    addrs_size);
 }
 
+SYMVER(sctp_connectx_orig, sctp_connectx@VERS_1)
 extern int sctp_connectx_orig (int)
 	__attribute ((alias ("__sctp_connectx")));
 
@@ -114,6 +128,7 @@ static int __connectx(int fd, struct sockaddr *addrs, socklen_t addrs_size,
 			  addrs, addrs_size);
 }
 
+SYMVER(sctp_connectx2, sctp_connectx@VERS_2)
 int sctp_connectx2(int fd, struct sockaddr *addrs, int addrcnt,
 		      sctp_assoc_t *id)
 {
@@ -125,6 +140,7 @@ int sctp_connectx2(int fd, struct sockaddr *addrs, int addrcnt,
 	return __connectx(fd, addrs, addrs_size, id);
 }
 
+SYMVER(sctp_connectx3, sctp_connectx@@VERS_3)
 int sctp_connectx3(int fd, struct sockaddr *addrs, int addrcnt,
 		      sctp_assoc_t *id)
 {
@@ -179,12 +195,3 @@ int sctp_connectx3(int fd, struct sockaddr *addrs, int addrcnt,
 	return __connectx(fd, addrs, addrs_size, id);
 }
 
-#define __SYMPFX(pfx, sym) #pfx sym
-#define _SYMPFX(pfx, sym) __SYMPFX(pfx, sym)
-#define SYMPFX(sym) _SYMPFX(__USER_LABEL_PREFIX__, #sym)
-#define SYMVER(name, name2) __asm__(".symver " SYMPFX(name) "," SYMPFX(name2))
-
-SYMVER(__sctp_connectx, sctp_connectx@);
-SYMVER(sctp_connectx_orig, sctp_connectx@VERS_1);
-SYMVER(sctp_connectx2, sctp_connectx@VERS_2);
-SYMVER(sctp_connectx3, sctp_connectx@@VERS_3);
-- 
2.28.0
