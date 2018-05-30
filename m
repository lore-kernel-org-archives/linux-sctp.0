From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 30 May 2018 17:17:53 +0000
Subject: [PATCH lksctp-tools 02/12] build: add m4 macros to probe for kernel features
Message-Id: <c8edd02013cec56b9abc0d3d11d4b2f3e487e591.1527700680.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

These macros are to assist on probing kernel features. The main reason
for using them is to have the default includes right and the
AM_CONDITIONALs that can be used to selectively enable (unit tests)
sources.

Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 m4/.gitignore |  1 +
 m4/sctp.m4    | 63 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 64 insertions(+)
 create mode 100644 m4/sctp.m4

diff --git a/m4/.gitignore b/m4/.gitignore
index 0f4126cd671839a82779a5c522f95ec373eb9a00..1ff72df33a7f7e709bb752a23623266d11c92282 100644
--- a/m4/.gitignore
+++ b/m4/.gitignore
@@ -1 +1,2 @@
 *.m4
+!sctp.m4
diff --git a/m4/sctp.m4 b/m4/sctp.m4
new file mode 100644
index 0000000000000000000000000000000000000000..6593517502b565ee1e02f143c8ad2efdcf7e587d
--- /dev/null
+++ b/m4/sctp.m4
@@ -0,0 +1,63 @@
+# Handy references:
+# https://www.gnu.org/software/autoconf/manual/autoconf.html#Generic-Structures
+# AC_CHECK_MEMBER (aggregate.member, [action-if-found], [action-if-not-found], [includes = 'AC_INCLUDES_DEFAULT'])
+# https://www.gnu.org/software/autoconf/manual/autoconf.html#Generic-Types
+# AC_CHECK_TYPE (type, [action-if-found], [action-if-not-found], [includes = 'AC_INCLUDES_DEFAULT'])
+
+# Macros to assist on probing kernel features
+#   Probes if a type is defined
+AC_DEFUN([LKSCTP_CHECK_TYPE], [{
+AC_CHECK_TYPE([$1],
+	AC_DEFINE([$2], 1,
+		  [Define if $1 is present.])
+	AM_CONDITIONAL([$2], [true]),
+	AM_CONDITIONAL([$2], [false]),
+	[AC_INCLUDES_DEFAULT
+#ifdef HAVE_STDINT_H
+# include <stdint.h>
+#endif
+#ifdef HAVE_SYS_SOCKET_H
+# include <sys/socket.h>
+#endif
+#ifdef HAVE_LINUX_SCTP_H
+# include <linux/sctp.h>
+#endif
+])}])
+
+#   Probes if a struct has a given member
+AC_DEFUN([LKSCTP_CHECK_MEMBER], [{
+AC_CHECK_MEMBER([$1],
+	AC_DEFINE([$2], 1,
+		  [Define if $1 is present.])
+	AM_CONDITIONAL([$2], [true]),
+	AM_CONDITIONAL([$2], [false]),
+	[AC_INCLUDES_DEFAULT
+#ifdef HAVE_STDINT_H
+# include <stdint.h>
+#endif
+#ifdef HAVE_SYS_SOCKET_H
+# include <sys/socket.h>
+#endif
+#ifdef HAVE_LINUX_SCTP_H
+# include <linux/sctp.h>
+#endif
+])}])
+
+#   Probes if a declaration is present
+AC_DEFUN([LKSCTP_CHECK_DECL], [{
+AC_CHECK_DECL([$1],
+	AC_DEFINE([$2], 1,
+		  [Define if $1 is present.])
+	AM_CONDITIONAL([$2], [true]),
+	AM_CONDITIONAL([$2], [false]),
+	[AC_INCLUDES_DEFAULT
+#ifdef HAVE_STDINT_H
+# include <stdint.h>
+#endif
+#ifdef HAVE_SYS_SOCKET_H
+# include <sys/socket.h>
+#endif
+#ifdef HAVE_LINUX_SCTP_H
+# include <linux/sctp.h>
+#endif
+])}])
-- 
2.14.3

