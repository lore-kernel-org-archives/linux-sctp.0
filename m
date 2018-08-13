From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Mon, 13 Aug 2018 20:05:04 +0000
Subject: New lksctp-tools release: 1.0.18
Message-Id: <20180813200504.GA31305@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hello,

A bit more than 2 years since last release, I'd like to announce the
new release, 1.0.18. Mostly composed of an initial integration with
Github CI stuff, mainly Travis and Coverity Scan, support for
sctp_peeloff_flags function, a bunch of bug fixes and build-time
improvements such as detecting which kernel features are available (so
we can build the library on older kernels again).

Build status: https://travis-ci.org/sctp/lksctp-tools/builds/415613801

Thank you to all those who contributed to this release.

Jamie Bainbridge (1):
      doc: Update Draft RFC docs to released RFCs

Jianwen Ji (5):
      nagle_snd/nagle_rcv: use getaddrinfo to replace gethostbyname
      nagle_snd/nagle_rcv: fix inconsistent indentations
      sctp_test: fix next stream identifier calculation
      lksctp-tools: update sctp.h with SCTP_DEFAULT_PRINFO/SCTP_PR_ASSOC_STATUS
      sctp_test: fix compiler warning

Marcelo Ricardo Leitner (31):
      sctp_status: fix hostname resolution
      lib/{bindx,connectx}: avoid pointer math with void type
      sctp_test: fix bogus memset size
      sctp.h: make use kernel UAPI header
      include: add private copy of kernel UAPI
      CI: initial integration
      Merge branch 'sendv': add the support for sctp_sendv and sctp_recvv
      travis: use parallel build
      travis: enable email notifications
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
      build: add two defines for Partial Delivery extensions on sctp_pdapi_event
      build: add define HAVE_SCTP_SENDV
      Merge branch 'issue24': build: detect kernel features when building
      travis: build against multiple kernel versions
      travis: build against multiple gcc versions
      travis: build against multiple clang versions
      travis: only send notifications if build status changed
      github: block pull requests
      doc: update docs to match current rfc documents
      travis: use git instead of downloading tarballs
      nagle_snd: silence false-positive compiler warning
      Release lksctp-tools-1.0.18

Neil Horman (1):
      lksctp-tools: Add sctp_peeloff_flags function

Xin Long (15):
      tests: fix SMALL_MAXSEG
      lib: add the core functions for sctp_sendv and sctp_recvv
      func_tests: add the testing for sctp_sendv and sctp_recvv
      man: add the man docs for sctp_sendv and sctp_recvv
      myftp: fix covscan warnings
      peel_client: fix covscan warnings
      peel_server: fix covscan warnings
      sctp_darn: fix covscan warnings
      sctp_test: fix covscan warnings
      sctp_xconnect: fix covscan warnings
      testlib: fix covscan warnings
      lib: fix covscan warnings
      func_tests: fix covscan warnings
      build: add define HAVE_SCTP_AUTH_NO_AUTH
      build: add two defines for Peer Address Parameters extensions on sctp_paddrparams

chenjia (3):
      Update sctp_test.c (#3)
      Fix SCTP stream option bugs in sctp_test (#4)
      Improve the -B option. (#8)

  Marcelo

