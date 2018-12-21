From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri, 21 Dec 2018 12:30:53 +0000
Subject: [PATCH lksctp-tools] withsctp: do not reuse PACKAGE_VERSION as lib version
Message-Id: <79e7e6e4304bdde2922fab4a446b7384e204440e.1545395375.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Currently and likely in the future, they resolv to the same value, but
conceptually speaking they are different things. As we introduced
dedicated variables for libsctp and libwithsctp versioning, lets avoid
possible confusion and expand them instead of reusing the
PACKAGE_VERSION one.

Fixes: #28
Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 Makefile.rules           | 4 +++-
 src/withsctp/withsctp.in | 2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/Makefile.rules b/Makefile.rules
index d3693facfdfdbe6b0d776cd91e1fa7ae172e15b8..9488228fe017734a5e8976d27a76a23e2d373902 100644
--- a/Makefile.rules
+++ b/Makefile.rules
@@ -16,4 +16,6 @@ edit = @sed \
 	-e "s|\@bindir\@|$(bindir)|" \
 	-e "s|\@libdir\@|$(libdir)|" \
 	-e "s|\@PACKAGE\@|$(PACKAGE)|" \
-	-e "s|\@PACKAGE_VERSION\@|$(PACKAGE_VERSION)|"
+	-e "s|\@LIBWITHSCTP_CURRENT\@|$(LIBWITHSCTP_CURRENT)|" \
+	-e "s|\@LIBWITHSCTP_REVISION\@|$(LIBWITHSCTP_REVISION)|" \
+	-e "s|\@LIBWITHSCTP_AGE\@|$(LIBWITHSCTP_AGE)|"
diff --git a/src/withsctp/withsctp.in b/src/withsctp/withsctp.in
index fda5ebc2059063c910a274fb63abe243c6d8eb62..ef4f7bbc2eccf71829cae66c178b579d4ffbf5e4 100644
--- a/src/withsctp/withsctp.in
+++ b/src/withsctp/withsctp.in
@@ -2,7 +2,7 @@
 # -*- sh -*-
 LIBDIR=@libdir@/@PACKAGE@
 BINDIR=@bindir@
-LIBVER=@PACKAGE_VERSION@
+LIBVER=@LIBWITHSCTP_CURRENT@.@LIBWITHSCTP_AGE@.@LIBWITHSCTP_REVISION@
 export LD_PRELOAD=${LIBDIR}/libwithsctp.so.${LIBVER}
 if ! ${BINDIR}/checksctp 2> /dev/null
 then
-- 
2.19.2
