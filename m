From: =?UTF-8?q?Diego=20Elio=20Petten=C3=B2?= <flameeyes@flameeyes.eu>
Date: Sun, 24 Feb 2013 07:10:27 +0000
Subject: [PATCH lksctp-tools] build: fix out-of-tree build of withsctp.
Message-Id: <1361689827-613022-1-git-send-email-flameeyes@flameeyes.eu>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org


Signed-off-by: Diego Elio Petten=C3=B2 <flameeyes@flameeyes.eu>
---
 src/withsctp/Makefile.am | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/withsctp/Makefile.am b/src/withsctp/Makefile.am
index e091049..cecf606 100644
--- a/src/withsctp/Makefile.am
+++ b/src/withsctp/Makefile.am
@@ -10,7 +10,7 @@ include $(top_srcdir)/Makefile.rules
 bin_PROGRAMS =3D checksctp
 bin_SCRIPTS =3D withsctp
=20
-AM_CPPFLAGS=3D-I../include
+AM_CPPFLAGS=3D-I$(top_srcdir)/src/include
 pkglib_LTLIBRARIES =3D libwithsctp.la
 libwithsctp_la_SOURCES =3D sctp_load_libs.c sctp_socket.c sctp_bind.c \
 	sctp_sockopt.c sctp_socket.h
--=20
1.8.1.2

