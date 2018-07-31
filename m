From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 31 Jul 2018 08:53:08 +0000
Subject: [PATCH lksctp-tools 0/9] lksctp-tools: fix covscan warnings
Message-Id: <cover.1533027042.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

This patchset fixes most of the warnings from the covscan of
  https://scan.coverity.com/projects/sctp-lksctp-tools

Note that we don't fix these types of warnings:
  - getchar() returned value check (medium):
    278659 (nowhere uses the returned value)

  - call close(-1)/getsockname(-1) (medium):
    278617, 278598, 278651, 278594, 278629, 278644, 278620, 278601
    (does on purpose)

  - DUMPCORE (medium):
    278611, 278626, 278653, 278663, 278641, 278591 (does on purpose)

  - call mkstemp without securely setting umask first (low):
    278636, 278634, 278628, 278616, 278603, 278589, 278647, 278625, 278610
    (low priority)

  - recvsk (high):
    278649, 278588 (false positives)

Xin Long (9):
  myftp: fix covscan warnings
  peel_client: fix covscan warnings
  peel_server: fix covscan warnings
  sctp_darn: fix covscan warnings
  sctp_test: fix covscan warnings
  sctp_xconnect: fix covscan warnings
  testlib: fix covscan warnings
  lib: fix covscan warnings
  func_tests: fix covscan warnings

 src/apps/myftp.c                       |  8 ++++++--
 src/apps/peel_client.c                 |  6 ++++--
 src/apps/peel_server.c                 | 11 ++++++++---
 src/apps/sctp_darn.c                   | 15 ++++++++++++---
 src/apps/sctp_test.c                   | 18 +++++++++++++-----
 src/apps/sctp_xconnect.c               | 18 +++++++++---------
 src/func_tests/test_1_to_1_rtoinfo.c   |  1 +
 src/func_tests/test_1_to_1_sendto.c    |  2 +-
 src/func_tests/test_sctp_sendrecvmsg.c |  2 +-
 src/func_tests/test_timetolive.c       |  2 +-
 src/lib/connectx.c                     |  6 +++---
 src/lib/sendmsg.c                      |  1 +
 src/testlib/sctputil.c                 |  1 +
 13 files changed, 61 insertions(+), 30 deletions(-)

-- 
2.1.0

