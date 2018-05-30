From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 30 May 2018 17:17:51 +0000
Subject: [PATCH lksctp-tools 00/12] build: detect kernel features when building
Message-Id: <cover.1527700680.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Currently we have an issue with struct sctp_event_subscribe. Kernel
won't accept any buffer larger than the version of sctp_event_subscribe
that is expects, and because of that we cannot simply have a copy of
kernel headers inside lksctp-tools. If we do, we have no way to use the
right version of sctp_event_subscribe.

That pretty much means that currently one has to tweak the internal copy
to comply with what the kernel one is using, which is really not good.

This patchset introduces probing of kernel features during build time
into lksctp-tools. With that, we can tell the applications that this or
that feature is enabled or not in the environment that it was compiled
on.

With the removal of the internal copy, other issues came up. Such as the
usage of sctp_peeloff_flags_arg_t by default, regardless of the kernel
being used. This became an issue because old kernels don't have such
struct, and thus the library doesn't build.

Another example is support for sendv/recv. Even if we use a private copy
with the symbols needed, the lib functions will compile but unit tests
will fail, as such function calls will always return EINVAL.

A check for recent UAPI changes was done by me and Xin Long and this is
the list that we came up with. Hopefully this restores lksctp-tools
compatibility with older kernels.

Fixes https://github.com/sctp/lksctp-tools/issues/24 .

Marcelo Ricardo Leitner (12):
  build: remove internal copy of kernel header
  build: add m4 macros to probe for kernel features
  configure.ac: style fixes
  build: probe for linux/sctp.h
  netinet/sctp.h: dynamically build based on system setup
  build: add define HAVE_SCTP_STREAM_RESET_EVENT
  build: add define HAVE_SCTP_ASSOC_RESET_EVENT
  build: add define HAVE_SCTP_STREAM_CHANGE_EVENT
  build: add define HAVE_SCTP_STREAM_RECONFIG
  build: add define HAVE_SCTP_PEELOFF_FLAGS
  build: add two defines for Partial Delivery extensions on
    sctp_pdapi_event
  build: add define HAVE_SCTP_SENDV

 configure.ac                              |   44 +-
 m4/.gitignore                             |    1 +
 m4/sctp.m4                                |   63 ++
 src/func_tests/Makefile.am                |    9 +-
 src/include/linux/sctp.h                  | 1153 -----------------------------
 src/include/netinet/Makefile.am           |    5 +-
 src/include/netinet/{sctp.h => sctp.h.in} |   15 +
 src/lib/peeloff.c                         |   38 +-
 src/lib/recvmsg.c                         |    2 +
 src/lib/sendmsg.c                         |    2 +
 src/testlib/sctputil.h                    |    5 +
 11 files changed, 163 insertions(+), 1174 deletions(-)
 create mode 100644 m4/sctp.m4
 delete mode 100644 src/include/linux/sctp.h
 rename src/include/netinet/{sctp.h => sctp.h.in} (93%)

-- 
2.14.3

