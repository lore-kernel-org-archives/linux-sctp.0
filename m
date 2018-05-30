From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 30 May 2018 17:17:55 +0000
Subject: [PATCH lksctp-tools 04/12] build: probe for linux/sctp.h
Message-Id: <4acee122afd81d5cb8d3244f4918d88160aaf2e1.1527700680.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Now that we don't have an internal copy anymore, we need to make sure
kernel headers are available.

Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 configure.ac | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/configure.ac b/configure.ac
index c4c7c8e52b5b921cf279c56c2c21de0ac039eac8..349819e1fdca716274ac4dd1b33e1c5683303c5d 100644
--- a/configure.ac
+++ b/configure.ac
@@ -44,6 +44,14 @@ AC_HEADER_SYS_WAIT
 AC_CHECK_HEADERS([arpa/inet.h fcntl.h malloc.h netdb.h netinet/in.h stdint.h \
 		  stdlib.h string.h sys/ioctl.h sys/param.h sys/socket.h \
 		  sys/time.h unistd.h])
+AC_CHECK_HEADERS([linux/sctp.h], [], [], [AC_INCLUDES_DEFAULT
+#ifdef HAVE_STDINT_H
+# include <stdint.h>
+#endif
+#ifdef HAVE_SYS_SOCKET_H
+# include <sys/socket.h>
+#endif
+])
 
 dnl Checks for typedefs, structures, and compiler characteristics.
 AC_C_CONST
-- 
2.14.3

