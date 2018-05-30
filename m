From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 30 May 2018 17:17:54 +0000
Subject: [PATCH lksctp-tools 03/12] configure.ac: style fixes
Message-Id: <b6de9e8af65bc83a71aa75abd51600f4208fbfb6.1527700680.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Try to keep lines shorter than 80 cols.

Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 configure.ac | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/configure.ac b/configure.ac
index 68fef7b7e46c01018c9b1ad1828122f8c7f9e027..c4c7c8e52b5b921cf279c56c2c21de0ac039eac8 100644
--- a/configure.ac
+++ b/configure.ac
@@ -41,7 +41,9 @@ AC_SUBST(LIBTOOL_DEPS)
 dnl Checks for header files.
 AC_HEADER_STDC
 AC_HEADER_SYS_WAIT
-AC_CHECK_HEADERS([arpa/inet.h fcntl.h malloc.h netdb.h netinet/in.h stdint.h stdlib.h string.h sys/ioctl.h sys/param.h sys/socket.h sys/time.h unistd.h])
+AC_CHECK_HEADERS([arpa/inet.h fcntl.h malloc.h netdb.h netinet/in.h stdint.h \
+		  stdlib.h string.h sys/ioctl.h sys/param.h sys/socket.h \
+		  sys/time.h unistd.h])
 
 dnl Checks for typedefs, structures, and compiler characteristics.
 AC_C_CONST
@@ -58,7 +60,8 @@ AC_FUNC_REALLOC
 AC_FUNC_SELECT_ARGTYPES
 AC_FUNC_SETVBUF_REVERSED
 AC_FUNC_VPRINTF
-AC_CHECK_FUNCS([bzero gethostbyname gettimeofday memmove memset select socket strchr strerror strtol strtoul])
+AC_CHECK_FUNCS([bzero gethostbyname gettimeofday memmove memset select socket \
+		strchr strerror strtol strtoul])
 
 AC_CONFIG_FILES([lksctp-tools.spec
 		Makefile
-- 
2.14.3

