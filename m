From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Tue, 14 Aug 2018 02:23:46 +0000
Subject: Re: New lksctp-tools release: 1.0.18
Message-Id: <20180814022346.GG5311@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <20180813200504.GA31305@localhost.localdomain>
In-Reply-To: <20180813200504.GA31305@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Mon, Aug 13, 2018 at 05:05:04PM -0300, Marcelo Ricardo Leitner wrote:
> Hello,
> 
> A bit more than 2 years since last release, I'd like to announce the
> new release, 1.0.18. Mostly composed of an initial integration with
> Github CI stuff, mainly Travis and Coverity Scan, support for
> sctp_peeloff_flags function, a bunch of bug fixes and build-time
> improvements such as detecting which kernel features are available (so
> we can build the library on older kernels again).
> 
> Build status: https://travis-ci.org/sctp/lksctp-tools/builds/415613801

There is always place for improving CI, right?  I forgot to update the
hardcoded version in withsctp library:

diff --git a/src/withsctp/Makefile.am b/src/withsctp/Makefile.am
index 70b1cca3886b..a77e10d0cebf 100644
--- a/src/withsctp/Makefile.am
+++ b/src/withsctp/Makefile.am
@@ -14,7 +14,7 @@ AM_CPPFLAGS=-I$(top_srcdir)/src/include
 pkglib_LTLIBRARIES = libwithsctp.la
 libwithsctp_la_SOURCES = sctp_load_libs.c sctp_socket.c sctp_bind.c \
 	sctp_sockopt.c sctp_socket.h
-libwithsctp_la_LDFLAGS = -version-info 1:17:0 -ldl
+libwithsctp_la_LDFLAGS = -version-info 1:18:0 -ldl
 
 pkgdoc_DATA = sctp_load_libs.c sctp_socket.c sctp_bind.c \
 	sctp_sockopt.c sctp_socket.h checksctp.c
diff --git a/src/withsctp/withsctp.in b/src/withsctp/withsctp.in
index 7f182ba6cde9..98130848166e 100644
--- a/src/withsctp/withsctp.in
+++ b/src/withsctp/withsctp.in
@@ -2,7 +2,7 @@
 # -*- sh -*-
 LIBDIR=@libdir@/@PACKAGE@
 BINDIR=@bindir@
-export LD_PRELOAD=${LIBDIR}/libwithsctp.so.1.0.17
+export LD_PRELOAD=${LIBDIR}/libwithsctp.so.1.0.18
 if ! ${BINDIR}/checksctp 2> /dev/null
 then
     ${BINDIR}/checksctp;

It would be nice to get ride of these hardcoded ones. Patches are welcomed.

Thanks,
Marcelo
